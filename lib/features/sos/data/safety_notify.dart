import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../../../core/l10n/gen/app_localizations.dart';
import '../../../core/services/messaging_service.dart';

/// Notifications for Phase 9 (lost pets, sightings, safe-zone alerts), each in
/// the person's own language, plus the matching push/SMS in the Demo Outbox.
class SafetyNotifier {
  SafetyNotifier(this._db, this._messaging);
  final FirebaseFirestore _db;
  final MessagingService _messaging;

  Future<({AppLocalizations l, String phone})> _person(String uid) async {
    try {
      final u = await _db.collection('users').doc(uid).get();
      final lang = (u.data()?['language'] as String?) ?? 'en';
      return (l: lookupAppLocalizations(Locale(lang)), phone: (u.data()?['phone'] as String?) ?? '');
    } catch (_) {
      return (l: lookupAppLocalizations(const Locale('en')), phone: '');
    }
  }

  /// Sends one notification per person. [title] and [body] are built in each
  /// person's language. [sms] also sends a text message (Demo Outbox in
  /// demo mode).
  Future<void> notify(
    Iterable<String> uids, {
    required String Function(AppLocalizations l) title,
    String Function(AppLocalizations l)? body,
    required String type,
    required String link,
    bool sms = false,
  }) async {
    for (final uid in uids.toSet()) {
      final p = await _person(uid);
      final t = title(p.l);
      final b = body?.call(p.l) ?? '';
      await _db.collection('notifications').add({
        'uid': uid,
        'title': t,
        'body': b,
        'type': type,
        'link': link,
        'read': false,
        'createdAt': DateTime.now(),
      });
      await _messaging.send(channel: Channel.push, to: uid, body: b.isEmpty ? t : '$t\n$b', subject: t, uid: uid, type: type);
      if (sms && p.phone.isNotEmpty) {
        await _messaging.send(channel: Channel.sms, to: p.phone, body: b.isEmpty ? t : '$t $b', uid: uid, type: type);
      }
    }
  }
}
