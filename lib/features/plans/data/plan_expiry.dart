import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/data/converters.dart';
import '../domain/plan_rules.dart';

/// The nightly plan check (`runPlanExpiry` in functions/src/phase10.ts) for
/// the standalone demo, which has no server to run it. `DemoStore` runs it
/// when the app opens, when it comes back to the front and now and then
/// while it stays open.
///
/// A Plus period that has ended renews when auto-renew is on, with one demo
/// payment for each month (or year) it missed; otherwise it, like an ended
/// trial, goes back to free. Without this, saved demo data keeps the dates
/// of the day it was made and Plus members quietly become free a few weeks
/// later. Unlike the server it sends no notifications. Running it again
/// changes nothing. Returns how many people's plans changed.
Future<int> runPlanExpiry(FirebaseFirestore db, DateTime now) async {
  var changed = 0;
  PlanPrices? prices;
  final users = await db.collection('users').where('plan', whereIn: ['trial', 'plus']).get();
  for (final d in users.docs) {
    final u = d.data();
    final plan = u['plan'] as String;
    final renewsAt = parseDate(u['planRenewsAt']);
    if (effectivePlan(plan: plan, trialEndsAt: parseDate(u['trialEndsAt']), planRenewsAt: renewsAt, now: now) != 'free') continue;
    if (plan == 'plus' && u['autoRenew'] != false) {
      final yearly = u['planPeriod'] == 'yearly';
      final missed = missedRenewals(renewsAt!, now, yearly: yearly);
      prices ??= PlanPrices.fromConfig((await db.collection('config').doc('app').get()).data());
      final batch = db.batch()..update(d.reference, {'planRenewsAt': renewalDate(missed.last, yearly: yearly)});
      for (final at in missed) {
        // Named after the renewal, so a second run can't pay twice.
        batch.set(db.collection('payments').doc('pay_renew_${d.id}_${at.millisecondsSinceEpoch}'), {
          'uid': d.id,
          'kind': 'plus',
          'period': yearly ? 'yearly' : 'monthly',
          'amount': yearly ? prices.yearly : prices.monthly,
          'tax': 0, // GST placeholder (Version 2)
          'status': 'paid',
          'demo': true,
          'renewal': true,
          'at': at,
        });
      }
      await batch.commit();
    } else {
      await d.reference.update({'plan': 'free'});
    }
    changed++;
  }
  return changed;
}
