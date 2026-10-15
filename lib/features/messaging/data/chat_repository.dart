import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/app_user.dart';
import '../../../core/data/paging.dart';
import '../../../core/l10n/gen/app_localizations.dart';
import '../../../core/providers.dart';
import '../../../core/services/service_providers.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/settings/settings_controller.dart';
import '../../../core/utils/format.dart';
import '../domain/chat_rules.dart';
import 'chat_models.dart';

/// Chats between pet parents and vets, clinics and providers (spec 7.8).
/// Tele-vet messages from owners go through the tele-vet backend (limits);
/// everything else is written here.
class ChatRepository {
  ChatRepository(this._db, this._storage, {required this.simulate, required this.uiLang});
  final FirebaseFirestore _db;
  final StorageService _storage;

  /// Standalone demo: the other side "types" and sends a short, clearly
  /// labelled demo reply so a single-device demo feels alive.
  final bool simulate;
  final String Function() uiLang;

  CollectionReference<Map<String, dynamic>> get _conv => _db.collection('conversations');
  CollectionReference<Map<String, dynamic>> get _msgs => _db.collection('messages');

  Stream<List<Conversation>> watchInbox(String uid) => _conv
      .where('participantIds', arrayContains: uid)
      .snapshots()
      .map((s) => [for (final d in s.docs) Conversation(d.id, d.data())].where((c) => !c.isAssistant).toList()
        ..sort((a, b) => b.lastAt.compareTo(a.lastAt)));

  Stream<Conversation?> watchOne(String id) => _conv.doc(id).snapshots().map((d) => d.exists ? Conversation(d.id, d.data()!) : null);

  /// The latest [limit] messages, oldest first.
  Stream<List<ChatMessage>> watchMessages(String conversationId, {int limit = pageSize}) => _msgs
      .where('conversationId', isEqualTo: conversationId)
      .orderBy('createdAt', descending: true)
      .limit(limit)
      .snapshots()
      .map((s) => [for (final d in s.docs) ChatMessage(d.id, d.data())]..sort((a, b) => a.createdAt.compareTo(b.createdAt)));

  /// Finds messages containing [query] across the given conversations.
  Future<List<ChatMessage>> searchMessages(List<String> conversationIds, String query) async {
    if (query.trim().length < 2 || conversationIds.isEmpty) return const [];
    final out = <ChatMessage>[];
    for (var i = 0; i < conversationIds.length; i += 10) {
      final chunk = conversationIds.sublist(i, (i + 10).clamp(0, conversationIds.length));
      final s = await _msgs.where('conversationId', whereIn: chunk).get();
      for (final d in s.docs) {
        final m = ChatMessage(d.id, d.data());
        if ((m.type == 'text' || m.type == 'pdf') && matchesSearch(query, [m.text, m.fileName])) out.add(m);
      }
    }
    out.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return out;
  }

  Future<Conversation?> _tryGet(String id) async {
    try {
      final d = await _conv.doc(id).get();
      return d.exists ? Conversation(d.id, d.data()!) : null;
    } catch (_) {
      // Live rules deny reading a conversation that does not exist yet.
      return null;
    }
  }

  /// Opens (or creates) the thread for a booking. The pet parent and every
  /// partner on the booking (clinic admin, vet, provider) are in it.
  Future<String> openForBooking(String bookingId, AppUser me) async {
    final id = bookingConversationId(bookingId);
    final existing = await _tryGet(id);
    if (existing != null) return id;
    final snap = await _db.collection('bookings').doc(bookingId).get();
    final b = snap.data();
    if (b == null) throw StateError('booking not found');
    final ownerId = b['ownerId'] as String;
    final kind = (b['kind'] as String?) ?? 'clinic';
    final providerId = b['providerId'] as String;
    final providerName = (b['providerName'] as String?) ?? '';
    final partnerUids = ((b['partnerUids'] as List?) ?? const []).cast<String>();
    final partners = partnerUids.isEmpty ? ['p_$providerId'] : partnerUids;
    final vetUid = await _vetUid(b['vetId'] as String?);
    final now = DateTime.now();
    await _conv.doc(id).set({
      'type': 'chat',
      'participantIds': [ownerId, ...partners.where((p) => p != ownerId)],
      'participants': {
        ownerId: {'name': b['ownerName'] ?? '', 'role': 'owner'},
        for (final p in partners)
          p: {'name': p == vetUid ? (b['vetName'] ?? providerName) : providerName, 'role': p == vetUid ? 'vet' : kind},
      },
      'ownerId': ownerId,
      'ownerName': b['ownerName'] ?? '',
      'providerId': providerId,
      'providerName': providerName,
      'providerKind': kind,
      'providerPhone': b['providerPhone'],
      'petId': b['petId'],
      'petName': b['petName'] ?? '',
      'petSpecies': b['petSpecies'] ?? 'dog',
      'bookingId': bookingId,
      'lastMessage': '',
      'lastType': 'system',
      'lastAt': now,
      'createdAt': now,
      'unread': <String, int>{},
      'muted': <String, bool>{},
      'blockedBy': <String>[],
      'typing': <String, Object?>{},
    });
    await _msgs.add({
      'conversationId': id,
      'senderId': 'system',
      'senderName': '',
      'type': 'system',
      'event': 'booking_chat',
      'meta': {'petName': b['petName'] ?? '', 'service': b['serviceName'] ?? '', 'start': b['start']},
      'text': '',
      'createdAt': now,
      'readBy': <String>[me.uid],
    });
    return id;
  }

  /// Opens (or creates) a pre-booking enquiry with a clinic or provider.
  Future<String> openEnquiry({
    required AppUser me,
    required String placeId,
    required String placeName,
    required String kind,
    String? placeUid,
    String? placePhone,
    String? petId,
    String? petName,
    String? petSpecies,
  }) async {
    final id = enquiryConversationId(placeId, me.uid);
    final existing = await _tryGet(id);
    if (existing != null) return id;
    final other = placeUid ?? 'p_$placeId';
    final now = DateTime.now();
    await _conv.doc(id).set({
      'type': 'enquiry',
      'participantIds': [me.uid, other],
      'participants': {
        me.uid: {'name': me.name, 'role': 'owner'},
        other: {'name': placeName, 'role': kind},
      },
      'ownerId': me.uid,
      'ownerName': me.name,
      'ownerPhone': me.phone,
      'providerId': placeId,
      'providerName': placeName,
      'providerKind': kind,
      'providerPhone': placePhone,
      'petId': petId,
      'petName': petName ?? '',
      'petSpecies': petSpecies ?? 'dog',
      'lastMessage': '',
      'lastType': 'system',
      'lastAt': now,
      'createdAt': now,
      'unread': <String, int>{},
      'muted': <String, bool>{},
      'blockedBy': <String>[],
      'typing': <String, Object?>{},
    });
    return id;
  }

  Future<String?> _vetUid(String? vetId) async {
    if (vetId == null) return null;
    try {
      return (await _db.collection('vets').doc(vetId).get()).data()?['uid'] as String?;
    } catch (_) {
      return null;
    }
  }

  /// Short preview for the inbox (attachments show as an icon + label in
  /// the UI, so we store the type and a plain text).
  static String previewOf(String type, String text, String? fileName) => switch (type) {
        'text' => text.length > 120 ? '${text.substring(0, 120)}…' : text,
        'pdf' => fileName ?? '',
        _ => text,
      };

  /// Writes a message and updates the conversation (preview, unread
  /// counts, typing) and the recipients' notifications.
  Future<String> writeMessage({
    required Conversation c,
    required String senderId,
    required String senderName,
    String type = 'text',
    String text = '',
    String? url,
    String? fileName,
    int? sizeBytes,
    int? durationSec,
    String? event,
    Map<String, dynamic>? meta,
    String? prescriptionId,
    bool demo = false,
    bool notify = true,
  }) async {
    var body = text;
    var masked = false;
    if (type == 'text') {
      final m = maskPhoneNumbers(text);
      body = m.text;
      masked = m.masked;
    }
    final now = DateTime.now();
    final ref = _msgs.doc();
    await ref.set({
      'conversationId': c.id,
      'senderId': senderId,
      'senderName': senderName,
      'type': type,
      'text': body,
      'url': url,
      'fileName': fileName,
      'sizeBytes': sizeBytes,
      'durationSec': durationSec,
      'event': event,
      'meta': meta,
      'prescriptionId': prescriptionId,
      'demo': demo,
      'masked': masked,
      'createdAt': now,
      'readBy': [senderId],
    });
    // System notes (joined, ended...) move the chat up but keep the last
    // real message as the inbox preview.
    final update = <String, Object?>{
      if (type != 'system') ...{
        'lastMessage': previewOf(type, body, fileName),
        'lastType': type,
        'lastSenderId': senderId,
      },
      'lastAt': now,
      'typing.$senderId': null,
    };
    for (final p in c.participantIds) {
      if (p == senderId) {
        update['unread.$p'] = 0;
      } else if (type != 'system' || event != null) {
        update['unread.$p'] = FieldValue.increment(1);
      }
    }
    await _conv.doc(c.id).update(update);
    if (notify) {
      for (final p in c.others(senderId)) {
        if (isPlaceholderParticipant(p) || c.mutedFor(p) || p == 'system') continue;
        await _notifyMessage(p, c, senderName, type, body, fileName);
      }
    }
    return ref.id;
  }

  Future<AppLocalizations> _langOf(String uid) async {
    try {
      final u = await _db.collection('users').doc(uid).get();
      return lookupAppLocalizations(Locale((u.data()?['language'] as String?) ?? 'en'));
    } catch (_) {
      return lookupAppLocalizations(const Locale('en'));
    }
  }

  Future<void> _notifyMessage(String uid, Conversation c, String senderName, String type, String text, String? fileName) async {
    final l = await _langOf(uid);
    final body = switch (type) {
      'photo' => l.msgPreviewPhoto,
      'pdf' => fileName ?? l.msgPreviewPdf,
      'voice' => l.msgPreviewVoice,
      'prescription' => l.rxSentPreview,
      'system' => '',
      _ => text,
    };
    try {
      await _db.collection('notifications').add({
        'uid': uid,
        'title': c.isTeleVet ? l.ntfTeleVetMessage(senderName) : l.ntfNewMessage(senderName),
        'body': body,
        'type': 'messages',
        'link': '/messages/${c.id}',
        'conversationId': c.id,
        'read': false,
        'createdAt': DateTime.now(),
      });
    } catch (_) {}
  }

  /// Sends a user message and, in the standalone demo, a simulated reply.
  Future<String> send(
    Conversation c,
    AppUser me, {
    String type = 'text',
    String text = '',
    String? url,
    String? fileName,
    int? sizeBytes,
    int? durationSec,
  }) async {
    final id = await writeMessage(
      c: c,
      senderId: me.uid,
      senderName: me.name,
      type: type,
      text: text,
      url: url,
      fileName: fileName,
      sizeBytes: sizeBytes,
      durationSec: durationSec,
    );
    if (simulate && !c.isTeleVet) simulateReply(c, me);
    return id;
  }

  final _lastSimulated = <String, DateTime>{};

  /// Standalone demo only: the other person types for a moment, then sends
  /// a short reply marked "Demo reply". At most one every 25 seconds per chat.
  void simulateReply(Conversation c, AppUser me, {String? text}) {
    if (!simulate || c.isBlocked) return;
    final other = c.others(me.uid).where((o) => o != 'system').firstOrNull;
    if (other == null) return;
    final now = DateTime.now();
    final last = _lastSimulated[c.id];
    if (last != null && now.difference(last) < const Duration(seconds: 25)) return;
    _lastSimulated[c.id] = now;
    Future<void>.delayed(const Duration(milliseconds: 1200), () => setTyping(c.id, other).catchError((_) {}));
    Future<void>.delayed(const Duration(milliseconds: 4200), () async {
      try {
        final fresh = await _tryGet(c.id);
        if (fresh == null || fresh.isBlocked) return;
        final l = lookupAppLocalizations(Locale(uiLang()));
        final reply = text ?? _demoReply(l, fresh, me, other);
        await writeMessage(c: fresh, senderId: other, senderName: fresh.nameOf(other), text: reply, demo: true, notify: false);
      } catch (e) {
        debugPrint('Demo reply failed: $e');
      }
    });
  }

  String _demoReply(AppLocalizations l, Conversation c, AppUser me, String other) {
    if (me.uid != c.ownerId) return l.demoReplyOwner(me.name.split(' ').first);
    final pet = c.petName.isEmpty ? l.msgYourPet : c.petName;
    return switch (c.roleOf(other)) {
      'groomer' => l.demoReplyGroomer(pet),
      'walker' => l.demoReplyWalker(pet),
      'trainer' => l.demoReplyTrainer(pet),
      'boarder' => l.demoReplyBoarder(pet),
      'vet' => l.demoReplyVet(pet),
      _ => l.demoReplyClinic(pet),
    };
  }

  /// Resets my unread count and marks the others' messages as read.
  Future<void> markRead(Conversation c, String uid, List<ChatMessage> messages) async {
    if (c.unreadFor(uid) > 0) await _conv.doc(c.id).update({'unread.$uid': 0});
    for (final m in messages) {
      if (m.senderId != uid && !m.readBy.contains(uid)) {
        await _msgs.doc(m.id).update({
          'readBy': FieldValue.arrayUnion([uid]),
        });
      }
    }
  }

  DateTime? _lastTypingWrite;

  /// Tells the other side "typing…" (throttled to one write every 3 s).
  Future<void> setTyping(String conversationId, String uid, {bool throttle = false}) async {
    final now = DateTime.now();
    if (throttle && _lastTypingWrite != null && now.difference(_lastTypingWrite!) < const Duration(seconds: 3)) return;
    if (throttle) _lastTypingWrite = now;
    await _conv.doc(conversationId).update({'typing.$uid': now});
  }

  Future<void> setMuted(Conversation c, String uid, bool muted) => _conv.doc(c.id).update({'muted.$uid': muted});

  Future<void> block(Conversation c, String uid) => _conv.doc(c.id).update({
        'blockedBy': FieldValue.arrayUnion([uid]),
      });

  Future<void> unblock(Conversation c, String uid) => _conv.doc(c.id).update({
        'blockedBy': FieldValue.arrayRemove([uid]),
      });

  /// Reported chats go to the admin moderation queue (Phase 10).
  Future<void> report(Conversation c, AppUser me, String reason, String details) => _db.collection('reports').add({
        'type': 'chat',
        'targetId': c.id,
        'targetTitle': '${c.ownerName} · ${c.providerName}',
        'reporterId': me.uid,
        'reporterName': me.name,
        'reason': reason,
        'details': details,
        'status': 'open',
        'createdAt': DateTime.now(),
      });

  /// Uploads a chat attachment (photo, PDF, voice note) to the user's folder.
  Future<String> upload(Uint8List bytes, {required String uid, required String name, required String contentType}) =>
      _storage.upload(bytes, path: 'users/$uid/chat/${DateTime.now().millisecondsSinceEpoch}_$name', contentType: contentType);

  Future<Uint8List?> read(String url) => _storage.read(url);
}

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final cfg = ref.watch(appConfigProvider);
  return ChatRepository(
    ref.watch(firestoreProvider),
    ref.watch(storageServiceProvider),
    simulate: cfg.isDemo && cfg.isStandalone,
    uiLang: () => ref.read(settingsProvider).locale,
  );
});

final inboxProvider = StreamProvider<List<Conversation>>((ref) {
  final u = ref.watch(currentUserProvider);
  if (u == null) return Stream.value(const []);
  return ref.watch(chatRepositoryProvider).watchInbox(u.uid);
});

final conversationProvider = StreamProvider.family<Conversation?, String>((ref, id) => ref.watch(chatRepositoryProvider).watchOne(id));

/// The latest page of a chat; "Show earlier messages" loads more.
final messagesProvider = StreamProvider.autoDispose.family<List<ChatMessage>, String>(
    (ref, id) => ref.watch(chatRepositoryProvider).watchMessages(id, limit: ref.watch(listLimitProvider('chat:$id'))));

/// "Today 9:30 AM" style time for the inbox and bubbles.
String chatTime(DateTime at, String lang, {DateTime? now}) {
  final n = now ?? DateTime.now();
  if (Fmt.sameDay(at, n)) return Fmt.time(at, lang);
  if (n.difference(at).inDays < 6) return Fmt.weekdayDate(at, lang).split(',').first;
  return Fmt.dateShort(at, lang);
}
