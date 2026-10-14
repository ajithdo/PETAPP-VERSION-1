import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/app_user.dart';
import '../../../core/data/converters.dart';
import '../../../core/providers.dart';
import '../../messaging/data/chat_models.dart';
import '../../messaging/domain/chat_rules.dart';
import '../domain/assistant_engine.dart';

/// Thrown when the monthly question allowance is used up.
class AssistantLimitException implements Exception {
  const AssistantLimitException(this.limit);
  final int limit;
}

/// Ask PawSetu history lives in a private "assistant" conversation
/// (`ai_<uid>`). Answers are stored as a topic id and shown in the reader's
/// language, so switching language translates the history too.
abstract class AssistantBackend {
  /// Asks a question. Red-flag questions are always answered (and not
  /// counted); others count toward the monthly allowance.
  Future<AssistantReply> ask(AppUser me, String question, {String? topic, required int limit});
}

class LocalAssistantBackend implements AssistantBackend {
  LocalAssistantBackend(this._db);
  final FirebaseFirestore _db;

  @override
  Future<AssistantReply> ask(AppUser me, String question, {String? topic, required int limit}) async {
    final reply = replyTo(question, topic: topic);
    final now = DateTime.now();
    final id = assistantConversationId(me.uid);
    final msgs = _db.collection('messages');
    if (!reply.isRedFlag) {
      final asked = await msgs.where('conversationId', isEqualTo: id).get();
      final used = questionsThisMonth(
        [
          for (final d in asked.docs)
            if (d.data()['type'] == 'question') (at: parseDate(d.data()['createdAt']) ?? now, redFlag: d.data()['redFlag'] != null),
        ],
        now,
      );
      if (AssistantAllowance(used: used, limit: limit).exhausted) throw AssistantLimitException(limit);
    }
    final conv = _db.collection('conversations').doc(id);
    if (!(await conv.get()).exists) {
      await conv.set({
        'type': 'assistant',
        'participantIds': [me.uid],
        'participants': {
          me.uid: {'name': me.name, 'role': 'owner'},
        },
        'ownerId': me.uid,
        'ownerName': me.name,
        'providerName': 'Ask PawSetu',
        'providerKind': 'assistant',
        'unread': <String, int>{},
        'createdAt': now,
        'lastAt': now,
      });
    }
    await msgs.add({
      'conversationId': id,
      'senderId': me.uid,
      'senderName': me.name,
      'type': 'question',
      'text': question,
      'topic': reply.topic,
      'redFlag': reply.redFlag,
      'createdAt': now,
      'readBy': [me.uid],
    });
    await msgs.add({
      'conversationId': id,
      'senderId': 'pawsetu_ai',
      'senderName': 'Ask PawSetu',
      'type': 'answer',
      'text': '',
      'topic': reply.topic,
      'redFlag': reply.redFlag,
      'createdAt': now.add(const Duration(milliseconds: 5)),
      'readBy': [me.uid],
    });
    await conv.update({'lastMessage': question, 'lastAt': now});
    return reply;
  }
}

/// Firebase: the askPawSetu Cloud Function counts questions on the server.
/// Version 1 still matches topics with the shared Dart engine and sends the
/// result; Version 2 moves answering to Gemini in the function.
class FunctionsAssistantBackend implements AssistantBackend {
  FunctionsAssistantBackend(this._fns);
  final FirebaseFunctions _fns;

  @override
  Future<AssistantReply> ask(AppUser me, String question, {String? topic, required int limit}) async {
    final reply = replyTo(question, topic: topic);
    try {
      await _fns.httpsCallable('askPawSetu').call({'question': question, 'topic': reply.topic, 'redFlag': reply.redFlag});
    } on FirebaseFunctionsException catch (e) {
      if (e.code == 'resource-exhausted') throw AssistantLimitException(limit);
      rethrow;
    }
    return reply;
  }
}

final assistantBackendProvider = Provider<AssistantBackend>((ref) {
  final cfg = ref.watch(appConfigProvider);
  if (cfg.usesFirebase) return FunctionsAssistantBackend(FirebaseFunctions.instanceFor(region: 'asia-south1'));
  return LocalAssistantBackend(ref.watch(firestoreProvider));
});

/// My Ask PawSetu history (oldest first).
final assistantMessagesProvider = StreamProvider<List<ChatMessage>>((ref) {
  final u = ref.watch(currentUserProvider);
  if (u == null) return Stream.value(const []);
  return ref
      .watch(firestoreProvider)
      .collection('messages')
      .where('conversationId', isEqualTo: assistantConversationId(u.uid))
      .snapshots()
      .map((s) => [for (final d in s.docs) ChatMessage(d.id, d.data())]..sort((a, b) => a.createdAt.compareTo(b.createdAt)));
});

/// Questions left this month for the current user.
final assistantAllowanceProvider = Provider<AssistantAllowance>((ref) {
  final limits = ref.watch(planLimitsProvider);
  final limit = (limits['aiQuestions'] as num?)?.toInt() ?? 5;
  final msgs = ref.watch(assistantMessagesProvider).value ?? const <ChatMessage>[];
  final used = questionsThisMonth(
    [for (final m in msgs) if (m.type == 'question') (at: m.createdAt, redFlag: m.redFlag != null)],
    DateTime.now(),
  );
  return AssistantAllowance(used: used, limit: limit);
});
