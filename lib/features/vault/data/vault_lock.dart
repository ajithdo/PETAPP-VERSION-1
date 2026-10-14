import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

import '../../../core/providers.dart';
import '../../../core/settings/settings_controller.dart';
import '../domain/pin_hash.dart';

/// Fingerprint / face unlock (spec 7.9). Android and iOS use local_auth;
/// the website has no biometrics, so it always uses the vault PIN.
abstract class BiometricAuth {
  Future<bool> isAvailable();
  Future<bool> authenticate(String reason);
}

class LocalBiometricAuth implements BiometricAuth {
  final _auth = LocalAuthentication();

  @override
  Future<bool> isAvailable() async {
    try {
      if (!await _auth.isDeviceSupported()) return false;
      final types = await _auth.getAvailableBiometrics();
      return types.isNotEmpty;
    } catch (e) {
      debugPrint('Biometrics unavailable: $e');
      return false;
    }
  }

  @override
  Future<bool> authenticate(String reason) async {
    try {
      return await _auth.authenticate(localizedReason: reason, biometricOnly: true, persistAcrossBackgrounding: true);
    } catch (e) {
      debugPrint('Biometric unlock failed: $e');
      return false;
    }
  }
}

class NoBiometricAuth implements BiometricAuth {
  const NoBiometricAuth();
  @override
  Future<bool> isAvailable() async => false;
  @override
  Future<bool> authenticate(String reason) async => false;
}

final biometricAuthProvider = Provider<BiometricAuth>((ref) {
  final mobile = !kIsWeb && (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS);
  return mobile ? LocalBiometricAuth() : const NoBiometricAuth();
});

final biometricAvailableProvider = FutureProvider<bool>((ref) => ref.watch(biometricAuthProvider).isAvailable());

/// Lock after 2 minutes in the background or without vault activity.
const vaultAutoLockAfter = Duration(minutes: 2);
const vaultMaxWrongPins = 5;
const vaultLockout = Duration(seconds: 30);

class VaultLockState {
  const VaultLockState({this.unlocked = false, this.wrongPins = 0, this.lockedOutUntil});
  final bool unlocked;
  final int wrongPins;
  final DateTime? lockedOutUntil;

  bool lockedOut(DateTime now) => lockedOutUntil != null && lockedOutUntil!.isAfter(now);
}

/// The vault lock. The PIN is stored on this device only as a salted
/// PBKDF2 hash (with the uid it belongs to), in the same place the settings
/// screen reads `vaultPinSet` from. Signing in again resets it.
class VaultLock extends Notifier<VaultLockState> {
  Timer? _timer;
  DateTime _lastActive = DateTime.now();
  DateTime? _hiddenAt;
  AppLifecycleListener? _life;

  @override
  VaultLockState build() {
    // Locks whenever the signed-in person changes.
    ref.watch(currentUserProvider.select((u) => u?.uid));
    _life?.dispose();
    _life = AppLifecycleListener(
      onHide: () => _hiddenAt ??= DateTime.now(),
      onPause: () => _hiddenAt ??= DateTime.now(),
      onShow: _back,
      onResume: _back,
    );
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 10), (_) => _checkIdle());
    ref.onDispose(() {
      _timer?.cancel();
      _life?.dispose();
    });
    return const VaultLockState();
  }

  void _back() {
    final hidden = _hiddenAt;
    _hiddenAt = null;
    if (hidden != null && DateTime.now().difference(hidden) >= vaultAutoLockAfter) lock();
  }

  void _checkIdle() {
    if (state.unlocked && DateTime.now().difference(_lastActive) >= vaultAutoLockAfter) lock();
  }

  String? get _uid => ref.read(currentUserProvider)?.uid;
  String? get _stored => ref.read(prefsProvider).getString('vaultPin');

  /// True when this person already chose a vault PIN on this device.
  bool get hasPin {
    final s = _stored;
    final uid = _uid;
    return s != null && uid != null && s.startsWith('$uid|');
  }

  bool get biometricsOn => ref.read(prefsProvider).getBool('vaultBiometrics') ?? true;
  void setBiometrics(bool on) {
    ref.read(prefsProvider).setBool('vaultBiometrics', on);
    state = VaultLockState(unlocked: state.unlocked, wrongPins: state.wrongPins, lockedOutUntil: state.lockedOutUntil);
  }

  void setPin(String pin) {
    final uid = _uid;
    if (uid == null || !isValidPin(pin)) return;
    ref.read(settingsProvider.notifier).setVaultPin('$uid|${hashPin(pin)}');
    unlock();
  }

  /// Checks a PIN. Five wrong tries lock the pad for 30 seconds.
  bool tryPin(String pin) {
    final now = DateTime.now();
    if (state.lockedOut(now)) return false;
    final s = _stored;
    final ok = hasPin && verifyPin(pin, s!.substring(s.indexOf('|') + 1));
    if (ok) {
      unlock();
      return true;
    }
    final wrong = state.wrongPins + 1;
    state = VaultLockState(
      wrongPins: wrong >= vaultMaxWrongPins ? 0 : wrong,
      lockedOutUntil: wrong >= vaultMaxWrongPins ? now.add(vaultLockout) : null,
    );
    return false;
  }

  /// "Forgot PIN": forget it on this device; the person signs in again and
  /// chooses a new one.
  void resetPin() {
    ref.read(settingsProvider.notifier).setVaultPin(null);
    state = const VaultLockState();
  }

  void unlock() {
    _lastActive = DateTime.now();
    state = const VaultLockState(unlocked: true);
  }

  void touch() => _lastActive = DateTime.now();

  void lock() {
    if (!state.unlocked) return;
    // Decoded vault images should not linger in memory once locked.
    PaintingBinding.instance.imageCache
      ..clear()
      ..clearLiveImages();
    state = const VaultLockState();
  }
}

final vaultLockProvider = NotifierProvider<VaultLock, VaultLockState>(VaultLock.new);
