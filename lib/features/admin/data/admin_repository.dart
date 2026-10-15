import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/app_user.dart';
import '../../../core/data/converters.dart';
import '../../../core/providers.dart';
import '../../../core/services/service_providers.dart';
import '../../sos/data/safety_notify.dart';
import '../domain/admin_rules.dart';
import '../domain/support.dart';

DateTime _date(Object? v) => parseDate(v) ?? DateTime.fromMillisecondsSinceEpoch(0);

/// Everything the admin panel reads and changes (spec 10). Admin access is
/// enforced by the admin custom claim in firestore.rules; role changes,
/// suspensions and partner approvals also go through Cloud Functions with
/// Firebase so the sign-in claims change too.
class AdminRepository {
  AdminRepository(this._db, this._notifier, {this.functions});
  final FirebaseFirestore _db;
  final SafetyNotifier _notifier;

  /// Null in the standalone demo.
  final FirebaseFunctions? functions;

  // ---------- audit log ----------

  Future<void> audit(AppUser admin, String action, String targetId, [Map<String, dynamic> details = const {}]) =>
      _db.collection('auditLog').add({'actorId': admin.uid, 'actorName': admin.name, 'action': action, 'targetId': targetId, 'details': details, 'createdAt': DateTime.now()});

  Stream<List<Map<String, dynamic>>> watchAudit() => _db
      .collection('auditLog')
      .orderBy('createdAt', descending: true)
      .limit(200)
      .snapshots()
      .map((s) => [for (final d in s.docs) {...d.data(), 'id': d.id}]);

  // ---------- dashboard ----------

  Stream<List<DayStats>> watchAnalytics({int days = 90}) => _db
      .collection('analyticsDaily')
      .orderBy('date', descending: true)
      .limit(days)
      .snapshots()
      .map((s) => [for (final d in s.docs) DayStats.fromMap(d.data(), _date)]..sort((a, b) => a.date.compareTo(b.date)));

  Future<Totals> totals(DateTime now) async {
    final since = now.subtract(const Duration(days: 30));
    final users = await _db.collection('users').get();
    final pets = await _db.collection('pets').get();
    final bookings = await _db.collection('bookings').get();
    final orders = await _db.collection('orders').get();
    final sos = await _db.collection('sosLogs').get();
    bool recent(Object? v) => _date(v).isAfter(since);
    final owners = users.docs.where((d) => (d.data()['role'] ?? 'owner') == 'owner' && d.data()['neighbour'] != true).toList();
    final plus = owners.where((d) => d.data()['plan'] == 'plus' || d.data()['plan'] == 'trial').length;
    final recentOrders = orders.docs.where((d) => recent(d.data()['createdAt']) && d.data()['status'] != 'cancelled');
    final recentBookings = bookings.docs.where((d) => recent(d.data()['createdAt'] ?? d.data()['start']));
    return Totals(
      users: users.docs.where((d) => d.data()['neighbour'] != true).length,
      owners: owners.length,
      partners: users.docs.where((d) => !['owner', 'admin'].contains(d.data()['role'] ?? 'owner')).length,
      pets: pets.docs.where((d) => d.data()['archived'] != true).length,
      bookings30: recentBookings.length,
      orderValue30: recentOrders.fold(0, (a, d) => a + ((d.data()['total'] as num?)?.toInt() ?? 0)),
      commission30: recentOrders.fold<int>(0, (a, d) => a + ((d.data()['commission'] as num?)?.toInt() ?? 0)) +
          recentBookings.fold<int>(0, (a, d) => a + ((d.data()['commission'] as num?)?.toInt() ?? 0)),
      plusMembers: plus,
      sos30: sos.docs.where((d) => recent(d.data()['at'])).length,
      topClinics: topCounts([for (final d in bookings.docs) if (d.data()['kind'] == 'clinic') (d.data()['providerName'] as String?) ?? '']),
      topProducts: topCounts([
        for (final o in orders.docs)
          for (final i in (o.data()['items'] as List?) ?? const [])
            for (var q = 0; q < (((i as Map)['qty'] as num?)?.toInt() ?? 1); q++) (i['name'] as String?) ?? '',
      ]),
    );
  }

  // ---------- approvals ----------

  Stream<List<PendingPartner>> watchPartners(String status) {
    Stream<List<PendingPartner>> col(String c) => _db
        .collection(c)
        .where('status', isEqualTo: status)
        .snapshots()
        .map((s) => [for (final d in s.docs) PendingPartner(c, d.id, d.data(), _date)]);
    final streams = [col('clinics'), col('vets'), col('providers'), col('sellers')];
    return _combine(streams).map((lists) => lists.expand((x) => x).toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt)));
  }

  /// Approve, reject (with a reason) or suspend a partner listing.
  Future<void> review(AppUser admin, PendingPartner p, String decision, {String reason = ''}) async {
    final status = switch (decision) { 'approve' => 'approved', 'reject' => 'rejected', 'suspend' => 'suspended', _ => 'approved' };
    if (functions != null) {
      await functions!.httpsCallable('reviewPartner').call({'collection': p.collection, 'id': p.id, 'decision': decision, 'reason': reason});
      return;
    }
    await _db.collection(p.collection).doc(p.id).update({'status': status, 'reviewReason': reason, 'reviewedAt': DateTime.now(), 'reviewedBy': admin.uid});
    final uid = p.ownerUid;
    if (uid != null) {
      final app = await _db.collection('partnerApplications').doc(uid).get();
      if (app.exists) await app.reference.update({'status': status, 'reason': reason});
      await _notifier.notify([uid],
          title: (l) => switch (status) {
                'approved' => l.admNoteApproved(p.name),
                'rejected' => l.admNoteRejected(p.name),
                _ => l.admNoteSuspended(p.name),
              },
          body: (l) => reason,
          type: 'account',
          link: '/partner',
          sms: false);
    }
    await audit(admin, 'partner_$decision', '${p.collection}/${p.id}', {'name': p.name, 'reason': reason});
  }

  // ---------- users ----------

  Stream<List<Map<String, dynamic>>> watchUsers() => _db.collection('users').snapshots().map((s) {
        final list = [for (final d in s.docs) if (d.data()['neighbour'] != true) {...d.data(), 'id': d.id}];
        list.sort((a, b) => ((a['name'] as String?) ?? '').toLowerCase().compareTo(((b['name'] as String?) ?? '').toLowerCase()));
        return list;
      });

  Future<void> setSuspended(AppUser admin, String uid, bool suspended, {String reason = ''}) async {
    if (functions != null) {
      await functions!.httpsCallable('setUserSuspended').call({'uid': uid, 'suspended': suspended, 'reason': reason});
      return;
    }
    await _db.collection('users').doc(uid).update({'suspended': suspended, 'suspendReason': suspended ? reason : null});
    await audit(admin, suspended ? 'user_suspend' : 'user_unsuspend', 'users/$uid', {'reason': reason});
  }

  Future<void> setRole(AppUser admin, String uid, String role) async {
    if (functions != null) {
      await functions!.httpsCallable('setUserRole').call({'uid': uid, 'role': role});
      return;
    }
    await _db.collection('users').doc(uid).update({'role': role});
    await audit(admin, 'setUserRole', 'users/$uid', {'role': role});
  }

  // ---------- catalogue ----------

  Stream<List<Map<String, dynamic>>> watchAll(String collection) =>
      _db.collection(collection).snapshots().map((s) => [for (final d in s.docs) {...d.data(), 'id': d.id}]);

  Future<void> updateDoc(AppUser admin, String collection, String id, Map<String, dynamic> fields, {required String action}) async {
    await _db.collection(collection).doc(id).update(fields);
    await audit(admin, action, '$collection/$id', _plain(fields));
  }

  /// Audit details without timestamps or delete markers.
  static Map<String, dynamic> _plain(Map<String, dynamic> fields) =>
      fields.map((k, v) => MapEntry(k, v is DateTime ? v.toIso8601String() : (v is FieldValue ? null : v)));

  Future<String> addDoc(AppUser admin, String collection, Map<String, dynamic> fields, {required String action, String? id}) async {
    final ref = id == null ? _db.collection(collection).doc() : _db.collection(collection).doc(id);
    await ref.set(fields);
    await audit(admin, action, '$collection/${ref.id}', {'name': fields['name'] ?? fields['title'] ?? ref.id});
    return ref.id;
  }

  // ---------- complaints and tickets ----------

  Stream<List<Ticket>> watchTickets() => _db
      .collection('tickets')
      .snapshots()
      .map((s) => [for (final d in s.docs) Ticket(d.id, d.data(), _date)]..sort((a, b) => b.updatedAt.compareTo(a.updatedAt)));

  /// A reply from support: the person gets a notification (and push) in
  /// their own language.
  Future<void> replyToTicket(AppUser admin, Ticket t, String text, {String? newStatus}) async {
    final msg = TicketMessage(byUid: admin.uid, byName: admin.name, fromAdmin: true, text: text.trim(), at: DateTime.now());
    final status = newStatus ?? statusAfterMessage(t.status, fromAdmin: true);
    await _db.collection('tickets').doc(t.id).update({
      'messages': FieldValue.arrayUnion([msg.toMap()]),
      'status': status,
      'assignee': t.assignee ?? admin.name,
      'updatedAt': DateTime.now(),
    });
    if (functions == null) {
      await _notifier.notify([t.uid], title: (l) => l.hpReplyTitle(t.subject), body: (l) => text.trim(), type: 'support', link: _ticketLink(t));
    }
    await audit(admin, 'ticket_reply', 'tickets/${t.id}', {'status': status});
  }

  Future<void> setTicketStatus(AppUser admin, Ticket t, String status) async {
    await _db.collection('tickets').doc(t.id).update({'status': status, 'updatedAt': DateTime.now()});
    if (functions == null && status == 'resolved') {
      await _notifier.notify([t.uid], title: (l) => l.hpResolvedTitle(t.subject), type: 'support', link: _ticketLink(t));
    }
    await audit(admin, 'ticket_status', 'tickets/${t.id}', {'status': status});
  }

  Future<void> assignTicket(AppUser admin, Ticket t, String assignee) async {
    await _db.collection('tickets').doc(t.id).update({'assignee': assignee, 'updatedAt': DateTime.now()});
    await audit(admin, 'ticket_assign', 'tickets/${t.id}', {'assignee': assignee});
  }

  /// A simulated refund (Version 1): recorded on the ticket and as a payment.
  Future<void> refundTicket(AppUser admin, Ticket t, int amount) async {
    final now = DateTime.now();
    await _db.collection('tickets').doc(t.id).update({
      'refund': {'amount': amount, 'status': 'refunded', 'at': now, 'by': admin.uid},
      'updatedAt': now,
    });
    await _db.collection('payments').add({
      'uid': t.uid,
      'kind': 'refund',
      'amount': -amount,
      'tax': 0,
      'status': 'refunded',
      'ticketId': t.id,
      'linkType': t.linkType,
      'linkId': t.linkId,
      'demo': true,
      'at': now,
    });
    if (functions == null) {
      await _notifier.notify([t.uid], title: (l) => l.hpRefundTitle(amount), body: (l) => l.hpRefundBody, type: 'support', link: _ticketLink(t), sms: true);
    }
    await audit(admin, 'ticket_refund', 'tickets/${t.id}', {'amount': amount});
  }

  String _ticketLink(Ticket t) => t.role == 'owner' ? '/me/help/${t.id}' : '/help/${t.id}';

  // ---------- moderation ----------

  Stream<List<Report>> watchReports() => _db
      .collection('reports')
      .snapshots()
      .map((s) => [for (final d in s.docs) Report(d.id, d.data(), _date)]..sort((a, b) => b.createdAt.compareTo(a.createdAt)));

  /// Hide a reported review (or restore it), mark a chat or content report
  /// as handled, or dismiss the report.
  Future<void> resolveReport(AppUser admin, Report r, String action) async {
    if (r.type == 'review' && (action == 'hide' || action == 'restore')) {
      await _db.collection('reviews').doc(r.targetId).update({'status': action == 'hide' ? 'hidden' : 'visible'});
    }
    await _db.collection('reports').doc(r.id).update({'status': action == 'dismiss' || action == 'restore' ? 'dismissed' : 'actioned', 'resolvedAt': DateTime.now(), 'resolvedBy': admin.uid});
    await audit(admin, 'report_$action', 'reports/${r.id}', {'type': r.type, 'target': r.targetId});
  }

  // ---------- settings ----------

  /// Changes config/app; the app picks the new values up straight away.
  /// Keys are dotted paths such as `limits.free.teleVetMessages`.
  Future<void> updateConfig(AppUser admin, Map<String, dynamic> paths, {required String what}) async {
    await _db.collection('config').doc('app').update({...paths, 'updatedAt': DateTime.now(), 'updatedBy': admin.uid});
    await audit(admin, 'settings_$what', 'config/app', _plain(paths));
  }

  Future<void> saveCoupon(AppUser admin, String code, Map<String, dynamic> fields, {required bool isNew}) async {
    final ref = _db.collection('coupons').doc(code);
    if (isNew) {
      await ref.set({'uses': 0, ...fields});
    } else {
      await ref.update(fields);
    }
    await audit(admin, isNew ? 'coupon_create' : 'coupon_update', 'coupons/$code', _plain(fields));
  }

  // ---------- Demo Outbox ----------

  Stream<List<Map<String, dynamic>>> watchOutbox() => _db
      .collection('outbox')
      .orderBy('createdAt', descending: true)
      .limit(300)
      .snapshots()
      .map((s) => [for (final d in s.docs) {...d.data(), 'id': d.id}]);
}

/// Merges several list streams into one stream of their latest values.
Stream<List<T>> _combine<T>(List<Stream<T>> streams) {
  return Stream<List<T>>.multi((c) {
    final latest = List<T?>.filled(streams.length, null);
    final has = List<bool>.filled(streams.length, false);
    final subs = [
      for (var i = 0; i < streams.length; i++)
        streams[i].listen((v) {
          latest[i] = v;
          has[i] = true;
          if (has.every((x) => x)) c.add([for (final x in latest) x as T]);
        }, onError: c.addError),
    ];
    c.onCancel = () async {
      for (final s in subs) {
        await s.cancel();
      }
    };
  });
}

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  final db = ref.watch(firestoreProvider);
  final cfg = ref.watch(appConfigProvider);
  return AdminRepository(db, SafetyNotifier(db, ref.watch(messagingServiceProvider)),
      functions: cfg.isStandalone ? null : FirebaseFunctions.instanceFor(region: 'asia-south1'));
});

final adminAnalyticsProvider = StreamProvider<List<DayStats>>((ref) => ref.watch(adminRepositoryProvider).watchAnalytics());
final adminTotalsProvider = FutureProvider<Totals>((ref) => ref.watch(adminRepositoryProvider).totals(DateTime.now()));
final adminPartnersProvider = StreamProvider.family<List<PendingPartner>, String>((ref, status) => ref.watch(adminRepositoryProvider).watchPartners(status));
final adminUsersProvider = StreamProvider<List<Map<String, dynamic>>>((ref) => ref.watch(adminRepositoryProvider).watchUsers());
final adminCollectionProvider = StreamProvider.family<List<Map<String, dynamic>>, String>((ref, c) => ref.watch(adminRepositoryProvider).watchAll(c));
final adminTicketsProvider = StreamProvider<List<Ticket>>((ref) => ref.watch(adminRepositoryProvider).watchTickets());
final adminReportsProvider = StreamProvider<List<Report>>((ref) => ref.watch(adminRepositoryProvider).watchReports());
final adminOutboxProvider = StreamProvider<List<Map<String, dynamic>>>((ref) => ref.watch(adminRepositoryProvider).watchOutbox());
final adminAuditProvider = StreamProvider<List<Map<String, dynamic>>>((ref) => ref.watch(adminRepositoryProvider).watchAudit());
