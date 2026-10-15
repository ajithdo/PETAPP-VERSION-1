import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/app_user.dart';
import '../../../core/providers.dart';
import '../domain/plan_rules.dart';

/// PawSetu Plus (spec 8): the 7-day free trial, the demo purchase, renewal
/// and referral codes. People can't change their own plan in Firestore
/// (rules), so with Firebase these go through Cloud Functions.
class PlanRepository {
  PlanRepository(this._db, {this.functions});
  final FirebaseFirestore _db;

  /// Null in the standalone demo.
  final FirebaseFunctions? functions;

  Future<void> startTrial(AppUser user, PlanPrices prices) async {
    if (functions != null) {
      await functions!.httpsCallable('startTrial').call(<String, dynamic>{});
      return;
    }
    if (!canStartTrial(plan: user.effectivePlan, trialUsedAt: user.trialUsedAt)) throw StateError('trial-used');
    final now = DateTime.now();
    await _db.collection('users').doc(user.uid).update({'plan': 'trial', 'trialEndsAt': trialEnd(now, prices), 'trialUsedAt': now});
  }

  /// After the (demo) payment succeeded.
  Future<DateTime> buy(AppUser user, PlanPrices prices, {required bool yearly}) async {
    if (functions != null) {
      final res = await functions!.httpsCallable('buyPlus').call<Map<String, dynamic>>({'yearly': yearly});
      return DateTime.parse(res.data['renewsAt'] as String);
    }
    final now = DateTime.now();
    // Buying during a trial or an active period starts after it ends.
    final from = [user.trialEndsAt, user.planRenewsAt].whereType<DateTime>().where((d) => d.isAfter(now)).fold<DateTime>(now, (a, b) => b.isAfter(a) ? b : a);
    final renews = renewalDate(from, yearly: yearly);
    final amount = yearly ? prices.yearly : prices.monthly;
    await _db.collection('users').doc(user.uid).update({'plan': 'plus', 'planRenewsAt': renews, 'autoRenew': true, 'planPeriod': yearly ? 'yearly' : 'monthly'});
    await _db.collection('payments').add({
      'uid': user.uid,
      'kind': 'plus',
      'period': yearly ? 'yearly' : 'monthly',
      'amount': amount,
      'tax': 0, // GST placeholder (Version 2)
      'status': 'paid',
      'demo': true,
      'at': now,
    });
    return renews;
  }

  /// Plus stays until the paid period ends, then becomes free.
  Future<void> setAutoRenew(AppUser user, bool on) => _db.collection('users').doc(user.uid).update({'autoRenew': on});

  /// Redeems a friend's referral code: both get a ₹[reward] coupon.
  /// Returns the new coupon code, or null if the code isn't valid.
  Future<String?> redeemReferral(AppUser user, String code, {int reward = 100}) async {
    final c = code.trim().toUpperCase();
    if (functions != null) {
      final res = await functions!.httpsCallable('redeemReferral').call<Map<String, dynamic>>({'code': c});
      return res.data['coupon'] as String?;
    }
    if (c.isEmpty || c == user.referralCode) return null;
    final already = await _db.collection('referrals').where('referredId', isEqualTo: user.uid).limit(1).get();
    if (already.docs.isNotEmpty) return null;
    final q = await _db.collection('users').where('referralCode', isEqualTo: c).limit(1).get();
    if (q.docs.isEmpty) return null;
    final referrer = q.docs.first;
    final now = DateTime.now();
    String newCode() => 'REF${List.generate(6, (_) => 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'[math.Random().nextInt(32)]).join()}';
    final mine = newCode(), theirs = newCode();
    for (final (code, uid) in [(mine, user.uid), (theirs, referrer.id)]) {
      await _db.collection('coupons').doc(code).set({
        'flat': reward,
        'minOrder': 299,
        'validTill': now.add(const Duration(days: 60)),
        'uses': 0,
        'maxUses': 1,
        'active': true,
        'forUid': uid,
        'description': 'Referral reward',
      });
    }
    await _db.collection('referrals').add({
      'referrerId': referrer.id,
      'referredId': user.uid,
      'code': c,
      'reward': reward,
      'coupons': {user.uid: mine, referrer.id: theirs},
      'createdAt': now,
    });
    return mine;
  }
}

final planRepositoryProvider = Provider<PlanRepository>((ref) {
  final cfg = ref.watch(appConfigProvider);
  return PlanRepository(ref.watch(firestoreProvider), functions: cfg.isStandalone ? null : FirebaseFunctions.instanceFor(region: 'asia-south1'));
});

final planPricesProvider = Provider<PlanPrices>((ref) => PlanPrices.fromConfig(ref.watch(appSettingsDocProvider).value));
