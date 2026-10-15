import 'dart:convert';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawsetu/core/auth/app_user.dart';
import 'package:pawsetu/core/data/converters.dart';
import 'package:pawsetu/core/demo/demo_store.dart';
import 'package:pawsetu/core/demo/seed/seed.dart';
import 'package:pawsetu/core/services/messaging_service.dart';
import 'package:pawsetu/features/admin/data/admin_repository.dart';
import 'package:pawsetu/features/admin/data/privacy_repository.dart';
import 'package:pawsetu/features/admin/data/support_repository.dart';
import 'package:pawsetu/features/admin/domain/admin_rules.dart';
import 'package:pawsetu/features/admin/domain/privacy.dart';
import 'package:pawsetu/features/admin/domain/support.dart';
import 'package:pawsetu/features/booking/domain/booking_rules.dart';
import 'package:pawsetu/features/health/domain/vaccine_schedule.dart';
import 'package:pawsetu/features/plans/data/plan_repository.dart';
import 'package:pawsetu/features/plans/domain/plan_rules.dart';
import 'package:pawsetu/features/shop/data/shop_repository.dart';
import 'package:pawsetu/features/sos/data/safety_notify.dart';
import 'package:pawsetu/features/televet/domain/televet_rules.dart';

DateTime _date(Object? v) => parseDate(v) ?? DateTime.fromMillisecondsSinceEpoch(0);

void main() {
  final now = DateTime(2026, 10, 15, 10);

  group('PawSetu Plus rules (spec 8)', () {
    test('prices come from settings; yearly saves a third', () {
      const p = PlanPrices();
      expect(p.monthly, 99);
      expect(p.yearly, 799);
      expect(p.yearlySavingPercent, 33);
      final custom = PlanPrices.fromConfig({
        'plans': {'plusMonthly': 129, 'plusYearly': 999, 'trialDays': 14},
      });
      expect([custom.monthly, custom.yearly, custom.trialDays], [129, 999, 14]);
    });

    test('an ended trial or paid period counts as free', () {
      final later = now.add(const Duration(days: 2));
      final earlier = now.subtract(const Duration(days: 2));
      expect(effectivePlan(plan: 'trial', trialEndsAt: later, now: now), 'trial');
      expect(effectivePlan(plan: 'trial', trialEndsAt: earlier, now: now), 'free');
      expect(effectivePlan(plan: 'plus', planRenewsAt: earlier, now: now), 'free');
      expect(effectivePlan(plan: 'plus', now: now), 'plus');
      final u = AppUser(uid: 'x', role: UserRole.owner, plan: 'trial', trialEndsAt: earlier);
      expect(u.effectivePlanAt(now), 'free');
      expect(AppUser(uid: 'x', role: UserRole.owner, plan: 'trial', trialEndsAt: later).effectivePlanAt(now), 'trial');
    });

    test('the 7-day trial is once per person; renewals land on the same day', () {
      expect(canStartTrial(plan: 'free'), isTrue);
      expect(canStartTrial(plan: 'free', trialUsedAt: now), isFalse);
      expect(canStartTrial(plan: 'plus'), isFalse);
      expect(trialEnd(now, const PlanPrices()), now.add(const Duration(days: 7)));
      expect(renewalDate(DateTime(2026, 1, 15, 9), yearly: false), DateTime(2026, 2, 15, 9));
      expect(renewalDate(DateTime(2026, 1, 15, 9), yearly: true), DateTime(2027, 1, 15, 9));
      expect(daysLeft(now.add(const Duration(hours: 30)), now), 2);
      expect(daysLeft(now.subtract(const Duration(hours: 1)), now), 0);
    });

    test('referral codes', () {
      var i = 0;
      int rnd(int max) => [3, 17, 25, 8][i++ % 4] % max;
      expect(newReferralCode('Priya Sharma', rnd), matches(RegExp(r'^PRIY[A-Z2-9]{4}$')));
      expect(newReferralCode('రవి', rnd), startsWith('PAWS'));
      expect(referralCodeLooksValid('pawpri1'), isTrue);
      expect(referralCodeLooksValid('ab-12'), isFalse);
      expect(isUnlimited(999), isTrue);
      expect(isUnlimited(100), isFalse);
    });
  });

  group('tickets, approvals and the dashboard (spec 10)', () {
    test('support replying moves a ticket on; the person replying reopens it', () {
      expect(statusAfterMessage('open', fromAdmin: true), 'in_progress');
      expect(statusAfterMessage('resolved', fromAdmin: false), 'open');
      expect(statusAfterMessage('in_progress', fromAdmin: false), 'in_progress');
      expect(ticketRefundAmount(500, paid: 349), 349);
      expect(ticketRefundAmount(-1, paid: 349), 0);
      final t = Ticket('t', {
        'status': 'in_progress',
        'messages': [
          TicketMessage(byUid: 'u', byName: 'U', fromAdmin: false, text: 'Hi', at: now).toMap(),
          TicketMessage(byUid: 'a', byName: 'A', fromAdmin: true, text: 'Hello', at: now).toMap(),
        ],
      }, _date);
      expect(t.awaitingUser, isTrue);
      expect(t.messages.last.text, 'Hello');
    });

    test('registration numbers: demo, state council and VCI formats', () {
      expect(regNoLooksValid('DEMO-VC-0412'), isTrue);
      expect(regNoLooksValid('TSVC-12345'), isTrue);
      expect(regNoLooksValid('VCI 2231'), isTrue);
      expect(regNoLooksValid('MH/2019/77'), isFalse);
      expect(regNoLooksValid(null), isFalse);
    });

    test('numbers group by day, Monday-weeks and months; open periods are not compared', () {
      final days = [
        for (var i = 1; i <= 60; i++) DayStats(date: DateTime(2026, 10, 15).subtract(Duration(days: i)), bookings: 10, orders: 2),
      ];
      final byDay = groupStats(days, StatRange.day);
      expect(byDay.length, 14);
      expect(byDay.last.date, DateTime(2026, 10, 14));
      // 16 Aug (a Sunday) to 14 Oct: weeks starting 10 Aug … 12 Oct.
      final byWeek = groupStats(days, StatRange.week);
      expect(byWeek.length, 10);
      expect(byWeek.every((w) => w.date.weekday == DateTime.monday), isTrue);
      expect(byWeek[byWeek.length - 2].bookings, 70);
      final byMonth = groupStats(days, StatRange.month);
      expect(byMonth.map((m) => m.date.month), [8, 9, 10]);
      expect(byMonth[1].bookings, 300);
      // 12 Oct (Monday) week is still running on 15 Oct.
      final complete = completePeriods(byWeek, StatRange.week, DateTime(2026, 10, 15));
      expect(complete.last.date, DateTime(2026, 10, 5));
      expect(changePercent(complete, (d) => d.bookings), 0);
      expect(changePercent([DayStats(date: now, orders: 10), DayStats(date: now, orders: 15)], (d) => d.orders), 50);
      expect(topCounts(['A', 'B', 'A', '', 'C', 'B', 'A']), [('A', 3), ('B', 2), ('C', 1)]);
    });

    test('the commission report adds bookings, shop margin, Plus payments and refunds', () {
      final r = commissionReport(
        bookings: [
          {'status': 'completed', 'start': DateTime(2026, 10, 3), 'providerName': 'Clinic', 'total': 600, 'commission': 60, 'payout': 540},
          {'status': 'cancelled', 'start': DateTime(2026, 10, 4), 'providerName': 'Clinic', 'total': 600, 'commission': 60},
          {'status': 'completed', 'start': DateTime(2026, 9, 3), 'providerName': 'Clinic', 'total': 600, 'commission': 60},
        ],
        orders: [
          {'status': 'delivered', 'createdAt': DateTime(2026, 10, 5), 'sellerName': 'Shop, Ltd', 'total': 1000, 'commission': 80},
        ],
        payments: [
          {'kind': 'plus', 'amount': 99, 'at': DateTime(2026, 10, 1)},
          {'kind': 'refund', 'amount': -349, 'at': DateTime(2026, 10, 2)},
        ],
        month: DateTime(2026, 10),
        date: _date,
      );
      expect(r.bookingCommission, 60);
      expect(r.shopMargin, 80);
      expect(r.plusRevenue, 99);
      expect(r.refunds, 349);
      expect(r.platformTotal, 60 + 80 + 99 - 349);
      expect(r.lines.first.name, 'Shop, Ltd');
      final csv = r.toCsv(['Partner', 'Type', 'Count', 'Gross', 'Commission', 'Payout'], (k) => k);
      expect(csv.split('\n')[1], '"Shop, Ltd",shop,1,1000,80,920');
    });

    test('booking commission: provider rate, then type rate, then default', () {
      final cfg = {
        'commission': {
          'bookingPercent': 10,
          'bookingTypePercent': {'groomer': 12},
        },
      };
      expect(bookingCommissionPercent(cfg, kind: 'clinic'), 10);
      expect(bookingCommissionPercent(cfg, kind: 'groomer'), 12);
      expect(bookingCommissionPercent(cfg, kind: 'groomer', providerRate: 8), 8);
      expect(bookingCommissionPercent(null, kind: 'walker'), 10);
    });

    test('admin vaccine timing changes apply to every schedule', () {
      final base = dogTemplates;
      final changed = applyVaccineOverride(base, {
        'dhppi_1': {'from': 7, 'to': 9},
        'rabies_booster': {'everyYears': 3},
      });
      expect(changed.firstWhere((t) => t.key == 'dhppi_1').fromWeeks, 7);
      expect(changed.firstWhere((t) => t.key == 'dhppi_1').toWeeks, 9);
      expect(changed.firstWhere((t) => t.key == 'rabies_booster').everyYears, 3);
      expect(changed.firstWhere((t) => t.key == 'dhppi_2').fromWeeks, 9);
      expect(identical(applyVaccineOverride(base, const {}), base), isTrue);
    });

    test('privacy: 30-day grace and plain JSON', () {
      expect(deletionDate(now), now.add(const Duration(days: 30)));
      expect(exportParts.length, 27);
      expect(plainJson({'a': [1, null], 'd': DateTime.utc(2026)}, (v) => '$v'), {
        'a': [1, null],
        'd': '2026-01-01T00:00:00.000Z',
      });
    });
  });

  group('with the demo data', () {
    late FakeFirebaseFirestore db;
    late SafetyNotifier notifier;
    const admin = AppUser(uid: 'u_admin', role: UserRole.admin, name: 'PawSetu Admin');
    const ravi = AppUser(uid: 'u_ravi', role: UserRole.owner, name: 'Ravi Teja', referralCode: 'PAWRAV2');

    setUp(() async {
      db = FakeFirebaseFirestore();
      await DemoStore.loadInto(db, DemoSeed.build(DateTime.now()));
      notifier = SafetyNotifier(db, DemoMessagingService(db));
    });

    Future<AppUser> user(String uid) async {
      final d = await db.collection('users').doc(uid).get();
      return AppUser.fromProfile(uid, d.data());
    }

    test('the seed has pending listings, tickets in every state, reports and 90 days of numbers', () async {
      final repo = AdminRepository(db, notifier);
      final pending = await repo.watchPartners('pending').first;
      expect(pending.map((p) => p.name), containsAll(['Hitech Pet Care Point', 'Chembur Critter Clinic', 'Koregaon Coat Care', 'Desi Pet Bazaar']));
      final tickets = await repo.watchTickets().first;
      expect(tickets.map((t) => t.status).toSet(), {'open', 'in_progress', 'resolved'});
      expect(tickets.where((t) => t.role != 'owner'), isNotEmpty);
      expect(tickets.firstWhere((t) => t.id == 'tk_arjun_damaged').refund?['status'], 'refunded');
      expect((await repo.watchReports().first).where((r) => r.status == 'open').length, 3);
      final days = await repo.watchAnalytics().first;
      expect(days.length, 90);
      final totals = await repo.totals(DateTime.now());
      expect(totals.plusMembers, 2);
      expect(totals.topClinics, isNotEmpty);
    });

    test('approving Hitech Pet Care Point puts it in the clinic finder and the audit log', () async {
      final repo = AdminRepository(db, notifier);
      Future<List<String>> finder() async =>
          [for (final d in (await db.collection('clinics').where('status', isEqualTo: 'approved').get()).docs) d.data()['name'] as String];
      expect(await finder(), isNot(contains('Hitech Pet Care Point')));
      final p = (await repo.watchPartners('pending').first).firstWhere((p) => p.name == 'Hitech Pet Care Point');
      expect(p.regNo, 'DEMO-VC-0412');
      await repo.review(admin, p, 'approve');
      expect(await finder(), contains('Hitech Pet Care Point'));
      final audit = await db.collection('auditLog').where('action', isEqualTo: 'partner_approve').get();
      expect(audit.docs.any((d) => d.data()['targetId'] == 'clinics/clinic_pending_1'), isTrue);
      final rejected = (await repo.watchPartners('pending').first).firstWhere((p) => p.name == 'Koregaon Coat Care');
      await repo.review(admin, rejected, 'reject', reason: 'Documents are unclear');
      final doc = (await db.collection('providers').doc('prov_groom_pending').get()).data()!;
      expect([doc['status'], doc['reviewReason']], ['rejected', 'Documents are unclear']);
    });

    test('changing the free tele-vet limit to 30 messages reaches the app', () async {
      final repo = AdminRepository(db, notifier);
      await repo.updateConfig(admin, {'limits.free.teleVetMessages': 30}, what: 'limits');
      final cfg = (await db.collection('config').doc('app').get()).data()!;
      final free = ((cfg['limits'] as Map)['free'] as Map).cast<String, dynamic>();
      expect(free['teleVetMessages'], 30);
      expect(free['teleVetWords'], 60, reason: 'other limits stay');
      expect(TeleVetLimits.fromPlan(free, plus: false).messages, 30);
      final audit = await db.collection('auditLog').where('action', isEqualTo: 'settings_limits').get();
      expect(audit.docs, isNotEmpty);
    });

    test("Ravi's complaint reaches support and the reply reaches him in Telugu", () async {
      final support = SupportRepository(db, notifier, standalone: true);
      final repo = AdminRepository(db, notifier);
      final id = await support.create(
        user: ravi,
        topic: 'late',
        subject: 'Walker late again',
        body: 'The walker came 30 minutes late today.',
        linkType: 'booking',
        linkId: 'bk_seed_r1',
        linkLabel: '60-minute walk',
      );
      final forAdmin = await db.collection('notifications').where('uid', isEqualTo: 'u_admin').where('type', isEqualTo: 'support').get();
      expect(forAdmin.docs.any((d) => d.data()['link'] == '/admin/complaints/$id'), isTrue);
      final t = (await repo.watchTickets().first).firstWhere((t) => t.id == id);
      expect(t.status, 'open');
      await repo.replyToTicket(admin, t, 'Sorry! We spoke to the walker.');
      final notes = await db.collection('notifications').where('uid', isEqualTo: 'u_ravi').where('type', isEqualTo: 'support').get();
      final reply = notes.docs.firstWhere((d) => d.data()['link'] == '/me/help/$id').data();
      expect(reply['title'], contains('సహాయ బృందం జవాబు'));
      expect(reply['body'], 'Sorry! We spoke to the walker.');
      final after = (await support.watch(id).first)!;
      expect(after.status, 'in_progress');
      expect(after.awaitingUser, isTrue);
      expect(after.assignee, 'PawSetu Admin');
      await support.reply(ravi, after, 'Thank you');
      expect((await support.watch(id).first)!.messages.length, 3);
    });

    test('a demo refund is recorded on the ticket and as a payment', () async {
      final repo = AdminRepository(db, notifier);
      final t = (await repo.watchTickets().first).firstWhere((t) => t.id == 'tk_priya_harness');
      await repo.refundTicket(admin, t, 499);
      final after = (await db.collection('tickets').doc(t.id).get()).data()!;
      expect((after['refund'] as Map)['amount'], 499);
      final pay = await db.collection('payments').where('ticketId', isEqualTo: t.id).get();
      expect(pay.docs.single.data()['amount'], -499);
      expect(pay.docs.single.data()['demo'], isTrue);
    });

    test('moderation hides a reported review from the clinic page', () async {
      final repo = AdminRepository(db, notifier);
      final r = (await repo.watchReports().first).firstWhere((r) => r.id == 'rpt_review_spam');
      await repo.resolveReport(admin, r, 'hide');
      expect((await db.collection('reviews').doc('rev_admin_spam').get()).data()!['status'], 'hidden');
      expect((await db.collection('reports').doc(r.id).get()).data()!['status'], 'actioned');
    });

    test('Ravi takes the 7-day trial once, then buys yearly Plus after it ends', () async {
      final plans = PlanRepository(db);
      const prices = PlanPrices();
      await plans.startTrial(await user('u_ravi'), prices);
      var r = await user('u_ravi');
      expect(r.effectivePlan, 'trial');
      expect(r.trialEndsAt!.difference(DateTime.now()).inDays, closeTo(7, 1));
      expect(() async => plans.startTrial(r, prices), throwsA(isA<StateError>()));
      final renews = await plans.buy(r, prices, yearly: true);
      expect(renews.isAfter(r.trialEndsAt!.add(const Duration(days: 364))), isTrue);
      r = await user('u_ravi');
      expect([r.plan, r.planPeriod, r.autoRenew], ['plus', 'yearly', true]);
      final pay = await db.collection('payments').where('uid', isEqualTo: 'u_ravi').where('kind', isEqualTo: 'plus').get();
      expect(pay.docs.single.data()['amount'], 799);
    });

    test("a friend's referral code gives both a personal coupon, once", () async {
      final plans = PlanRepository(db);
      final priya = await user('u_priya');
      final r = await user('u_ravi');
      expect(await plans.redeemReferral(r, r.referralCode!), isNull, reason: 'not your own code');
      final coupon = await plans.redeemReferral(r, priya.referralCode!.toLowerCase());
      expect(coupon, startsWith('REF'));
      expect(await plans.redeemReferral(r, priya.referralCode!), isNull, reason: 'only once');
      final shop = ShopRepository(db);
      expect(await shop.coupon(coupon!, uid: 'u_ravi'), isNotNull);
      expect(await shop.coupon(coupon, uid: 'u_priya'), isNull, reason: 'personal coupons are for their owner');
      final mine = await db.collection('coupons').where('forUid', isEqualTo: 'u_priya').get();
      expect(mine.docs.length, 2, reason: "Priya's seeded reward and the new one");
    });

    test('Download my data has the pets and bookings; deletion can be cancelled', () async {
      final privacy = PrivacyRepository(db);
      final priya = await user('u_priya');
      final data = jsonDecode(await privacy.exportMyData(priya)) as Map<String, dynamic>;
      expect((data['profile'] as Map)['name'], 'Priya Sharma');
      expect((data['pets'] as List).map((p) => (p as Map)['name']), contains('Bruno'));
      expect(data['bookings'], isNotEmpty);
      expect(data['vaccinations'], isNotEmpty);
      final when = await privacy.requestDeletion(priya);
      expect(when.difference(DateTime.now()).inDays, closeTo(30, 1));
      expect((await user('u_priya')).deletionRequestedAt, isNotNull);
      await privacy.cancelDeletion(priya);
      expect((await user('u_priya')).deletionRequestedAt, isNull);
      await privacy.setConsent(priya, 'marketing', true);
      expect((await user('u_priya')).consents['marketing'], isTrue);
    });

    test('pausing an account and changing a role are logged', () async {
      final repo = AdminRepository(db, notifier);
      await repo.setSuspended(admin, 'u_meera', true, reason: 'Fake account');
      expect((await user('u_meera')).suspended, isTrue);
      await repo.setSuspended(admin, 'u_meera', false);
      expect((await user('u_meera')).suspended, isFalse);
      await repo.setRole(admin, 'u_rohan', 'walker');
      expect((await user('u_rohan')).role, UserRole.walker);
      final actions = [for (final d in (await db.collection('auditLog').get()).docs) d.data()['action']];
      expect(actions, containsAll(['user_suspend', 'user_unsuspend', 'setUserRole']));
    });
  });
}
