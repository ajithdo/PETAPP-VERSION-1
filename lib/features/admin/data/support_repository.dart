import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/app_user.dart';
import '../../../core/data/converters.dart';
import '../../../core/providers.dart';
import '../../../core/services/service_providers.dart';
import '../../sos/data/safety_notify.dart';
import '../domain/support.dart';

DateTime _date(Object? v) => parseDate(v) ?? DateTime.fromMillisecondsSinceEpoch(0);

/// Help and complaints for pet parents and partners (spec 10): raise a
/// ticket about a booking, order or chat, read replies and answer them.
class SupportRepository {
  SupportRepository(this._db, this._notifier, {required this.standalone});
  final FirebaseFirestore _db;
  final SafetyNotifier _notifier;

  /// With Firebase the onTicketWritten function tells the support team.
  final bool standalone;

  Stream<List<Ticket>> watchMine(String uid) => _db
      .collection('tickets')
      .where('uid', isEqualTo: uid)
      .snapshots()
      .map((s) => [for (final d in s.docs) Ticket(d.id, d.data(), _date)]..sort((a, b) => b.updatedAt.compareTo(a.updatedAt)));

  Stream<Ticket?> watch(String id) => _db.collection('tickets').doc(id).snapshots().map((d) => d.exists ? Ticket(d.id, d.data()!, _date) : null);

  Future<String> create({
    required AppUser user,
    required String topic,
    required String subject,
    required String body,
    String linkType = 'other',
    String? linkId,
    String linkLabel = '',
  }) async {
    final now = DateTime.now();
    final ref = _db.collection('tickets').doc();
    await ref.set({
      'uid': user.uid,
      'name': user.name,
      'role': user.role.key,
      'topic': topic,
      'subject': subject.trim(),
      'body': body.trim(),
      'linkType': linkType,
      'linkId': linkId,
      'linkLabel': linkLabel,
      'status': 'open',
      'assignee': null,
      'messages': [TicketMessage(byUid: user.uid, byName: user.name, fromAdmin: false, text: body.trim(), at: now).toMap()],
      'refund': null,
      'createdAt': now,
      'updatedAt': now,
    });
    await _tellSupport(user, subject, ref.id);
    return ref.id;
  }

  Future<void> reply(AppUser user, Ticket t, String text) async {
    final msg = TicketMessage(byUid: user.uid, byName: user.name, fromAdmin: false, text: text.trim(), at: DateTime.now());
    await _db.collection('tickets').doc(t.id).update({
      'messages': FieldValue.arrayUnion([msg.toMap()]),
      'status': statusAfterMessage(t.status, fromAdmin: false),
      'updatedAt': DateTime.now(),
    });
    await _tellSupport(user, t.subject, t.id);
  }

  Future<void> _tellSupport(AppUser user, String subject, String id) async {
    if (!standalone) return;
    final admins = await _db.collection('users').where('role', isEqualTo: 'admin').get();
    await _notifier.notify([for (final a in admins.docs) a.id],
        title: (l) => l.hpNewForSupport(user.name), body: (l) => subject, type: 'support', link: '/admin/complaints/$id');
  }
}

final supportRepositoryProvider = Provider<SupportRepository>((ref) {
  final db = ref.watch(firestoreProvider);
  return SupportRepository(db, SafetyNotifier(db, ref.watch(messagingServiceProvider)), standalone: ref.watch(appConfigProvider).isStandalone);
});

final myTicketsProvider = StreamProvider<List<Ticket>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value(const []);
  return ref.watch(supportRepositoryProvider).watchMine(user.uid);
});

final ticketProvider = StreamProvider.family<Ticket?, String>((ref, id) => ref.watch(supportRepositoryProvider).watch(id));
