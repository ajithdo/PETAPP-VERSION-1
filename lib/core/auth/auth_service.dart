import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../demo/seed/seed_people.dart';
import 'app_user.dart';

/// Friendly error codes the UI turns into plain-language messages.
class AuthFailure implements Exception {
  const AuthFailure(this.code);
  final String code;
  @override
  String toString() => 'AuthFailure($code)';
}

/// Sign-in for every platform. Demo (standalone) and Firebase implementations.
abstract class AuthService {
  Stream<AppUser?> userChanges();
  AppUser? get current;

  Future<void> signInWithEmail(String email, String password);
  Future<void> signUpWithEmail(String name, String email, String password);
  Future<void> sendPasswordReset(String email);
  Future<void> sendEmailVerification();
  Future<void> refresh();

  /// Starts phone sign-in and returns a verification id for [confirmPhoneCode].
  Future<String> startPhoneSignIn(String phone);
  Future<void> confirmPhoneCode(String verificationId, String code);

  Future<void> signInWithGoogle();
  Future<void> signInWithApple();

  /// One-tap demo login (demo mode only).
  Future<void> signInAsDemo(String uid);
  Future<void> signOut();
}

String normalizePhone(String raw) {
  final digits = raw.replaceAll(RegExp(r'[^0-9+]'), '');
  if (digits.startsWith('+')) return digits;
  final d = digits.replaceFirst(RegExp(r'^0+'), '');
  return '+91$d';
}

/// Emits the current value first, then every change, with no gap in between.
Stream<AppUser?> _replay(AppUser? Function() current, Stream<AppUser?> changes) {
  StreamSubscription<AppUser?>? sub;
  late final StreamController<AppUser?> c;
  c = StreamController<AppUser?>(
    onListen: () {
      c.add(current());
      sub = changes.listen(c.add, onError: c.addError);
    },
    onCancel: () => sub?.cancel(),
  );
  return c.stream;
}

String _phoneKey(String phone) => phone.replaceAll(RegExp(r'[^0-9]'), '');

/// Standalone demo: accounts live in the demo database (demoAccounts).
/// Nothing leaves the device. OTP is always 123456.
class DemoAuthService implements AuthService {
  DemoAuthService(this._db, this._prefs) {
    final uid = _prefs.getString(_sessionKey);
    if (uid != null) {
      _listen(uid);
    } else {
      _controller.add(null);
    }
  }

  final FirebaseFirestore _db;
  final SharedPreferences _prefs;
  static const _sessionKey = 'demo_session_uid';
  final _controller = StreamController<AppUser?>.broadcast();
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _sub;
  AppUser? _current;
  bool _emailVerified = true;

  @override
  AppUser? get current => _current;

  @override
  Stream<AppUser?> userChanges() => _replay(() => _current, _controller.stream);

  void _listen(String uid) {
    _sub?.cancel();
    _sub = _db.collection('users').doc(uid).snapshots().listen((snap) async {
      if (!snap.exists) {
        _current = null;
        _controller.add(null);
        return;
      }
      final acc = await _db.collection('demoAccounts').doc(uid).get();
      _emailVerified = (acc.data()?['emailVerified'] as bool?) ?? true;
      _current = AppUser.fromProfile(uid, snap.data(), emailVerified: _emailVerified);
      _controller.add(_current);
    });
  }

  Future<void> _start(String uid) async {
    await _prefs.setString(_sessionKey, uid);
    _listen(uid);
  }

  Future<QueryDocumentSnapshot<Map<String, dynamic>>?> _byEmail(String email) async {
    final q = await _db
        .collection('demoAccounts')
        .where('email', isEqualTo: email.trim().toLowerCase())
        .limit(1)
        .get();
    return q.docs.isEmpty ? null : q.docs.first;
  }

  @override
  Future<void> signInWithEmail(String email, String password) async {
    final acc = await _byEmail(email);
    if (acc == null) throw const AuthFailure('user-not-found');
    if (acc.data()['password'] != password) throw const AuthFailure('wrong-password');
    await _start(acc.id);
  }

  @override
  Future<void> signUpWithEmail(String name, String email, String password) async {
    final e = email.trim().toLowerCase();
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(e)) throw const AuthFailure('invalid-email');
    if (password.length < 6) throw const AuthFailure('weak-password');
    if (await _byEmail(e) != null) throw const AuthFailure('email-in-use');
    final uid = 'u_${DateTime.now().microsecondsSinceEpoch}';
    await _db.collection('demoAccounts').doc(uid).set({
      'email': e,
      'password': password,
      'phone': null,
      'emailVerified': false,
    });
    await _createProfile(uid, name: name, email: e);
    await _db.collection('outbox').add({
      'channel': 'email',
      'to': e,
      'uid': uid,
      'subject': 'Verify your PawSetu email',
      'body': 'Tap the link to verify your email (demo).',
      'createdAt': DateTime.now(),
    });
    await _start(uid);
  }

  Future<void> _createProfile(String uid, {String name = '', String? email, String? phone}) =>
      _db.collection('users').doc(uid).set({
        'name': name,
        'email': email,
        'phone': phone,
        'role': 'owner',
        'plan': 'free',
        'language': _prefs.getString('locale') ?? 'en',
        'onboarded': false,
        'createdAt': DateTime.now(),
        'addresses': <Map<String, dynamic>>[],
        'consents': {'marketing': false, 'analytics': true, 'lostPetAlerts': true},
        'referralCode': 'PAW${uid.substring(uid.length - 5)}',
      });

  @override
  Future<void> sendPasswordReset(String email) async {
    final acc = await _byEmail(email);
    await _db.collection('outbox').add({
      'channel': 'email',
      'to': email.trim().toLowerCase(),
      'uid': acc?.id,
      'subject': 'Reset your PawSetu password',
      'body': 'Tap the link to choose a new password (demo).',
      'createdAt': DateTime.now(),
    });
  }

  @override
  Future<void> sendEmailVerification() async {
    final u = _current;
    if (u == null) return;
    // Demo: the link "opens" straight away.
    await _db.collection('demoAccounts').doc(u.uid).update({'emailVerified': true});
    await refresh();
  }

  @override
  Future<void> refresh() async {
    final u = _current;
    if (u != null) _listen(u.uid);
  }

  @override
  Future<String> startPhoneSignIn(String phone) async => normalizePhone(phone);

  @override
  Future<void> confirmPhoneCode(String verificationId, String code) async {
    if (code.trim() != demoOtp) throw const AuthFailure('invalid-code');
    final all = await _db.collection('demoAccounts').get();
    final key = _phoneKey(verificationId);
    for (final d in all.docs) {
      final p = d.data()['phone'] as String?;
      if (p != null && _phoneKey(p) == key) {
        await _start(d.id);
        return;
      }
    }
    final uid = 'u_${DateTime.now().microsecondsSinceEpoch}';
    await _db.collection('demoAccounts').doc(uid).set({
      'email': null,
      'password': null,
      'phone': verificationId,
      'emailVerified': true,
    });
    await _createProfile(uid, phone: verificationId);
    await _start(uid);
  }

  Future<void> _social(String provider) async {
    final email = 'demo.$provider.user@example.com';
    final acc = await _byEmail(email);
    if (acc != null) {
      await _start(acc.id);
      return;
    }
    final uid = 'u_${provider}_demo';
    await _db.collection('demoAccounts').doc(uid).set({
      'email': email,
      'password': null,
      'phone': null,
      'emailVerified': true,
    });
    await _createProfile(uid,
        name: provider == 'google' ? 'Demo Google User' : 'Demo Apple User', email: email);
    await _start(uid);
  }

  @override
  Future<void> signInWithGoogle() => _social('google');
  @override
  Future<void> signInWithApple() => _social('apple');

  @override
  Future<void> signInAsDemo(String uid) => _start(uid);

  @override
  Future<void> signOut() async {
    await _sub?.cancel();
    await _prefs.remove(_sessionKey);
    _current = null;
    _controller.add(null);
  }
}

/// Firebase Auth (emulator in Version 1, real project in Version 2).
/// Roles come from custom claims set by the ensureProfile/setUserRole functions.
class FirebaseAuthService implements AuthService {
  FirebaseAuthService(this._auth, this._db, this._functions, {required this.demoLoginEnabled}) {
    _auth.userChanges().listen(_onAuth);
  }

  final fb.FirebaseAuth _auth;
  final FirebaseFirestore _db;
  final FirebaseFunctions _functions;
  final bool demoLoginEnabled;
  final _controller = StreamController<AppUser?>.broadcast();
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _sub;
  AppUser? _current;
  fb.ConfirmationResult? _webConfirmation;

  @override
  AppUser? get current => _current;

  @override
  Stream<AppUser?> userChanges() => _replay(() => _current, _controller.stream);

  Future<void> _onAuth(fb.User? user) async {
    await _sub?.cancel();
    if (user == null) {
      _current = null;
      _controller.add(null);
      return;
    }
    try {
      await _functions.httpsCallable('ensureProfile').call<Map<String, dynamic>>({});
    } catch (e) {
      debugPrint('ensureProfile failed: $e');
    }
    final token = await user.getIdTokenResult(true);
    final claimRole = token.claims?['role'] as String?;
    _sub = _db.collection('users').doc(user.uid).snapshots().listen((snap) {
      _current = AppUser.fromProfile(user.uid, snap.data(),
          email: user.email,
          phone: user.phoneNumber,
          emailVerified: user.emailVerified || user.providerData.every((p) => p.providerId != 'password'),
          claimRole: claimRole);
      _controller.add(_current);
    });
  }

  Never _map(fb.FirebaseAuthException e) => throw AuthFailure(switch (e.code) {
        'user-not-found' || 'invalid-credential' || 'invalid-login-credentials' => 'wrong-password',
        'wrong-password' => 'wrong-password',
        'email-already-in-use' => 'email-in-use',
        'weak-password' => 'weak-password',
        'invalid-email' => 'invalid-email',
        'invalid-verification-code' => 'invalid-code',
        'network-request-failed' => 'network',
        'popup-closed-by-user' || 'web-context-cancelled' || 'canceled' => 'cancelled',
        _ => 'unknown',
      });

  @override
  Future<void> signInWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email.trim(), password: password);
    } on fb.FirebaseAuthException catch (e) {
      _map(e);
    }
  }

  @override
  Future<void> signUpWithEmail(String name, String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(email: email.trim(), password: password);
      await cred.user?.updateDisplayName(name);
      await cred.user?.sendEmailVerification();
    } on fb.FirebaseAuthException catch (e) {
      _map(e);
    }
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on fb.FirebaseAuthException catch (e) {
      if (e.code != 'user-not-found') _map(e);
    }
  }

  @override
  Future<void> sendEmailVerification() async => _auth.currentUser?.sendEmailVerification();

  @override
  Future<void> refresh() async {
    await _auth.currentUser?.reload();
    await _onAuth(_auth.currentUser);
  }

  @override
  Future<String> startPhoneSignIn(String phone) async {
    final number = normalizePhone(phone);
    try {
      if (kIsWeb) {
        _webConfirmation = await _auth.signInWithPhoneNumber(number);
        return _webConfirmation!.verificationId;
      }
      final completer = Completer<String>();
      await _auth.verifyPhoneNumber(
        phoneNumber: number,
        verificationCompleted: (cred) async => _auth.signInWithCredential(cred),
        verificationFailed: (e) => completer.completeError(AuthFailure(e.code)),
        codeSent: (id, _) => completer.complete(id),
        codeAutoRetrievalTimeout: (_) {},
      );
      return await completer.future;
    } on fb.FirebaseAuthException catch (e) {
      _map(e);
    }
  }

  @override
  Future<void> confirmPhoneCode(String verificationId, String code) async {
    try {
      if (kIsWeb && _webConfirmation != null) {
        await _webConfirmation!.confirm(code);
      } else {
        await _auth.signInWithCredential(
            fb.PhoneAuthProvider.credential(verificationId: verificationId, smsCode: code));
      }
    } on fb.FirebaseAuthException catch (e) {
      _map(e);
    }
  }

  Future<void> _provider(fb.AuthProvider p) async {
    try {
      if (kIsWeb) {
        await _auth.signInWithPopup(p);
      } else {
        await _auth.signInWithProvider(p);
      }
    } on fb.FirebaseAuthException catch (e) {
      _map(e);
    }
  }

  @override
  Future<void> signInWithGoogle() => _provider(fb.GoogleAuthProvider());
  @override
  Future<void> signInWithApple() => _provider(fb.AppleAuthProvider());

  @override
  Future<void> signInAsDemo(String uid) async {
    if (!demoLoginEnabled) throw const AuthFailure('unknown');
    final acc = demoAccounts.firstWhere((a) => a.uid == uid);
    await signInWithEmail(acc.email, demoPassword);
  }

  @override
  Future<void> signOut() => _auth.signOut();
}
