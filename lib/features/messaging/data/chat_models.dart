import '../../../core/data/converters.dart';

/// One chat thread (collection `conversations`). Types: chat (from a
/// booking), enquiry (before booking), televet (consultation) and
/// assistant (Ask PawSetu, hidden from the inbox).
class Conversation {
  Conversation(this.id, this.raw);
  final String id;
  final Map<String, dynamic> raw;

  String get type => (raw['type'] as String?) ?? 'chat';
  bool get isTeleVet => type == 'televet';
  bool get isAssistant => type == 'assistant';
  bool get isEnquiry => type == 'enquiry';
  List<String> get participantIds => ((raw['participantIds'] as List?) ?? const []).cast<String>();
  Map<String, dynamic> get participants => ((raw['participants'] as Map?) ?? const {}).cast<String, dynamic>();
  String get ownerId => (raw['ownerId'] as String?) ?? (participantIds.isEmpty ? '' : participantIds.first);
  String get ownerName => (raw['ownerName'] as String?) ?? '';
  String? get ownerPhone => raw['ownerPhone'] as String?;
  String get providerName => (raw['providerName'] as String?) ?? '';
  String? get providerId => raw['providerId'] as String?;
  String? get providerPhone => raw['providerPhone'] as String?;

  /// clinic, groomer, trainer, boarder, walker or vet (tele-vet).
  String get providerKind => (raw['providerKind'] as String?) ?? 'clinic';
  String? get petId => raw['petId'] as String?;
  String get petName => (raw['petName'] as String?) ?? '';
  String get petSpecies => (raw['petSpecies'] as String?) ?? 'dog';
  String? get bookingId => raw['bookingId'] as String?;
  String? get consultationId => raw['consultationId'] as String?;
  String get lastMessage => (raw['lastMessage'] as String?) ?? '';
  String get lastType => (raw['lastType'] as String?) ?? 'text';
  String? get lastSenderId => raw['lastSenderId'] as String?;
  DateTime get lastAt => parseDate(raw['lastAt']) ?? parseDate(raw['createdAt']) ?? DateTime.fromMillisecondsSinceEpoch(0);
  List<String> get blockedBy => ((raw['blockedBy'] as List?) ?? const []).cast<String>();
  bool get isBlocked => blockedBy.isNotEmpty;

  int unreadFor(String uid) => (((raw['unread'] as Map?)?[uid]) as num?)?.toInt() ?? 0;
  bool mutedFor(String uid) => ((raw['muted'] as Map?)?[uid] as bool?) ?? false;
  DateTime? typingAt(String uid) => parseDate((raw['typing'] as Map?)?[uid]);

  /// Everyone else in the thread.
  List<String> others(String uid) => participantIds.where((p) => p != uid).toList();

  /// Pet owners see the clinic or provider; partners see the pet parent.
  String titleFor(String uid) => uid == ownerId ? providerName : ownerName;

  String nameOf(String uid) => ((participants[uid] as Map?)?['name'] as String?) ?? (uid == ownerId ? ownerName : providerName);
  String roleOf(String uid) => ((participants[uid] as Map?)?['role'] as String?) ?? (uid == ownerId ? 'owner' : providerKind);

  /// Somebody else typed in the last few seconds.
  String? typingOther(String me, DateTime now, bool Function(DateTime? at, DateTime now) fresh) {
    for (final o in others(me)) {
      if (fresh(typingAt(o), now)) return o;
    }
    return null;
  }
}

/// One message (collection `messages`).
class ChatMessage {
  ChatMessage(this.id, this.raw);
  final String id;
  final Map<String, dynamic> raw;

  String get conversationId => (raw['conversationId'] as String?) ?? '';
  String get senderId => (raw['senderId'] as String?) ?? '';
  String get senderName => (raw['senderName'] as String?) ?? '';

  /// text, photo, pdf, voice, system, prescription, call, question, answer
  String get type => (raw['type'] as String?) ?? 'text';
  String get text => (raw['text'] as String?) ?? '';
  String? get url => raw['url'] as String?;
  String? get fileName => raw['fileName'] as String?;
  int get sizeBytes => (raw['sizeBytes'] as num?)?.toInt() ?? 0;
  int get durationSec => (raw['durationSec'] as num?)?.toInt() ?? 0;
  DateTime get createdAt => parseDate(raw['createdAt']) ?? DateTime.now();
  List<String> get readBy => ((raw['readBy'] as List?) ?? const []).cast<String>();

  /// Simulated reply in the standalone demo (labelled in the chat).
  bool get demo => (raw['demo'] as bool?) ?? false;

  /// System messages: joined, ended, recommend_visit, recommend_emergency,
  /// started, call_ended.
  String? get event => raw['event'] as String?;
  String? get prescriptionId => raw['prescriptionId'] as String?;
  Map<String, dynamic> get meta => ((raw['meta'] as Map?) ?? const {}).cast<String, dynamic>();

  /// Ask PawSetu answers.
  String? get topic => raw['topic'] as String?;
  String? get redFlag => raw['redFlag'] as String?;
  bool get masked => (raw['masked'] as bool?) ?? false;

  bool readByAnyoneBut(String uid) => readBy.any((r) => r != uid);
}
