import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawsetu/core/auth/app_user.dart';
import 'package:pawsetu/core/data/converters.dart';
import 'package:pawsetu/core/demo/demo_store.dart';
import 'package:pawsetu/core/demo/seed/seed.dart';
import 'package:pawsetu/features/plans/data/plan_expiry.dart';
import 'package:pawsetu/features/plans/domain/plan_rules.dart';

/// The standalone demo's stand-in for the nightly plan job. Demo data made on
/// 14 Oct 2026 has Priya (monthly) and Arjun (yearly) renewing on 6 Nov 2026.
void main() {
  final made = DateTime(2026, 10, 14);
  final renews = DateTime(2026, 11, 6);
  late FakeFirebaseFirestore db;

  setUp(() async {
    db = FakeFirebaseFirestore();
    await DemoStore.loadInto(db, DemoSeed.build(made));
  });

  Future<AppUser> user(String uid) async => AppUser.fromProfile(uid, (await db.collection('users').doc(uid).get()).data());
  Future<List<Map<String, dynamic>>> renewals(String uid) async =>
      (await db.collection('payments').where('uid', isEqualTo: uid).where('renewal', isEqualTo: true).get()).docs.map((d) => d.data()).toList();

  group('missed renewals', () {
    test('none while the period is still running', () {
      expect(missedRenewals(renews, DateTime(2026, 11, 5), yearly: false), isEmpty);
    });

    test('the end date itself and every month after it up to now', () {
      expect(missedRenewals(renews, renews, yearly: false), [renews]);
      expect(missedRenewals(renews, DateTime(2027, 2, 10), yearly: false),
          [renews, DateTime(2026, 12, 6), DateTime(2027, 1, 6), DateTime(2027, 2, 6)]);
      expect(missedRenewals(renews, DateTime(2027, 2, 10), yearly: true), [renews]);
    });
  });

  group('plan check', () {
    test('the day after the demo month ends, Priya and Arjun are still Plus', () async {
      final now = DateTime(2026, 11, 7, 9);
      // What the owner saw before the fix: the month has ended, so Free.
      expect((await user('u_priya')).effectivePlanAt(now), 'free');

      expect(await runPlanExpiry(db, now), 2);

      final priya = await user('u_priya');
      expect(priya.effectivePlanAt(now), 'plus');
      expect(priya.planRenewsAt, DateTime(2026, 12, 6));
      final paid = await renewals('u_priya');
      expect(paid, hasLength(1));
      expect(paid.single['amount'], 99);
      expect(paid.single['period'], 'monthly');
      expect(paid.single['demo'], isTrue);
      expect(parseDate(paid.single['at']), renews);

      final arjun = await user('u_arjun');
      expect(arjun.effectivePlanAt(now), 'plus');
      expect(arjun.planRenewsAt, DateTime(2027, 11, 6));
      expect((await renewals('u_arjun')).single['amount'], 799);

      // Ravi is on the free plan and stays there.
      expect((await user('u_ravi')).plan, 'free');
    });

    test('months later it catches up on every missed month, once', () async {
      final now = DateTime(2027, 3, 20);
      await runPlanExpiry(db, now);
      final priya = await user('u_priya');
      expect(priya.effectivePlanAt(now), 'plus');
      expect(priya.planRenewsAt, DateTime(2027, 4, 6));
      expect(await renewals('u_priya'), hasLength(5)); // Nov, Dec, Jan, Feb, Mar
      expect(await renewals('u_arjun'), hasLength(1));

      // A second run (the app reopened) changes nothing and pays nothing.
      expect(await runPlanExpiry(db, now), 0);
      expect(await renewals('u_priya'), hasLength(5));
    });

    test('with auto-renew off Plus ends, and an ended trial goes back to free', () async {
      await db.collection('users').doc('u_priya').update({'autoRenew': false});
      await db.collection('users').doc('u_ravi').update({'plan': 'trial', 'trialEndsAt': DateTime(2026, 10, 20), 'trialUsedAt': made});
      await db.collection('users').doc('u_anjali').update({'plan': 'trial', 'trialEndsAt': DateTime(2026, 11, 10), 'trialUsedAt': made});
      final now = DateTime(2026, 11, 7, 9);

      await runPlanExpiry(db, now);

      expect((await user('u_priya')).plan, 'free');
      expect(await renewals('u_priya'), isEmpty);
      expect((await user('u_ravi')).plan, 'free');
      final anjali = await user('u_anjali');
      expect(anjali.plan, 'trial', reason: 'her trial is still running');
      expect(anjali.effectivePlanAt(now), 'trial');
    });
  });
}
