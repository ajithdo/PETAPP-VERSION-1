import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/app_user.dart';
import '../../../core/providers.dart';
import '../domain/privacy.dart';

/// Privacy centre (spec 7.14): consents, "Download my data" and "Delete my
/// account" with a 30-day grace period.
class PrivacyRepository {
  PrivacyRepository(this._db, {this.functions});
  final FirebaseFirestore _db;

  /// Null in the standalone demo.
  final FirebaseFunctions? functions;

  Future<void> setConsent(AppUser user, String key, bool value) =>
      _db.collection('users').doc(user.uid).update({'consents.$key': value, 'consents.updatedAt': DateTime.now()});

  /// Everything about the person as pretty JSON.
  Future<String> exportMyData(AppUser user) async {
    if (functions != null) {
      final res = await functions!.httpsCallable('exportMyData').call<Map<String, dynamic>>(<String, dynamic>{});
      return const JsonEncoder.withIndent('  ').convert(res.data);
    }
    String iso(Object v) {
      if (v is Timestamp) return v.toDate().toUtc().toIso8601String();
      return '$v';
    }

    final out = <String, Object?>{
      'exportedAt': DateTime.now().toUtc().toIso8601String(),
      'app': 'PawSetu',
    };
    final profile = await _db.collection('users').doc(user.uid).get();
    out['profile'] = plainJson(profile.data(), iso);
    final pets = await _db.collection('pets').where('ownerId', isEqualTo: user.uid).get();
    final petIds = [for (final p in pets.docs) p.id];
    for (final part in exportParts) {
      final docs = <Map<String, dynamic>>[];
      if (part.byPet) {
        for (final id in petIds) {
          final q = await _db.collection(part.collection).where(part.field, isEqualTo: id).get();
          docs.addAll([for (final d in q.docs) {'id': d.id, ...d.data()}]);
        }
      } else {
        final base = _db.collection(part.collection);
        final q = await (part.arrayContains ? base.where(part.field, arrayContains: user.uid) : base.where(part.field, isEqualTo: user.uid)).get();
        docs.addAll([for (final d in q.docs) {'id': d.id, ...d.data()}]);
      }
      if (docs.isNotEmpty) out[part.collection] = plainJson(docs, iso);
    }
    return const JsonEncoder.withIndent('  ').convert(out);
  }

  Future<DateTime> requestDeletion(AppUser user) async {
    final now = DateTime.now();
    await _db.collection('users').doc(user.uid).update({'deletionRequestedAt': now});
    return deletionDate(now);
  }

  Future<void> cancelDeletion(AppUser user) => _db.collection('users').doc(user.uid).update({'deletionRequestedAt': null});
}

final privacyRepositoryProvider = Provider<PrivacyRepository>((ref) {
  final cfg = ref.watch(appConfigProvider);
  return PrivacyRepository(ref.watch(firestoreProvider), functions: cfg.isStandalone ? null : FirebaseFunctions.instanceFor(region: 'asia-south1'));
});
