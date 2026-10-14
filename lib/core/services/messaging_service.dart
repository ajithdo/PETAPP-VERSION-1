import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

/// Outgoing SMS, WhatsApp, email and push messages.
/// Demo: every message is logged to the Demo Outbox (admin can read it).
/// Live (Version 2, L3): the sendMessage Cloud Function talks to the providers.
enum Channel { push, email, sms, whatsapp }

abstract class MessagingService {
  Future<void> send({
    required Channel channel,
    required String to,
    required String body,
    String? subject,
    String? uid,
    String? type,
  });
}

class DemoMessagingService implements MessagingService {
  DemoMessagingService(this._db);
  final FirebaseFirestore _db;

  @override
  Future<void> send({
    required Channel channel,
    required String to,
    required String body,
    String? subject,
    String? uid,
    String? type,
  }) =>
      _db.collection('outbox').add({
        'channel': channel.name,
        'to': to,
        'subject': subject,
        'body': body,
        'uid': uid,
        'type': type,
        'createdAt': DateTime.now(),
      });
}

class LiveMessagingService implements MessagingService {
  LiveMessagingService(this._functions);
  final FirebaseFunctions _functions;

  @override
  Future<void> send({
    required Channel channel,
    required String to,
    required String body,
    String? subject,
    String? uid,
    String? type,
  }) =>
      _functions.httpsCallable('sendMessage').call({
        'channel': channel.name,
        'to': to,
        'subject': subject,
        'body': body,
        'uid': uid,
        'type': type,
      });
}
