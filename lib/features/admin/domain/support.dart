/// Help and complaints (spec 10, 7.14): tickets raised by pet parents and
/// partners, linked to a booking, order or chat; and reports of reviews,
/// chats or content for moderation.
///
/// Pure Dart: shared by the app and the unit tests.
library;

/// open → in_progress → resolved (and back to open if the person replies).
const ticketStatuses = ['open', 'in_progress', 'resolved'];

/// What a ticket can be about.
const ticketLinkTypes = ['booking', 'order', 'chat', 'other'];

/// Ticket topics shown when raising one.
const ticketTopics = ['refund', 'late', 'quality', 'behaviour', 'app', 'other'];

class TicketMessage {
  const TicketMessage({required this.byUid, required this.byName, required this.fromAdmin, required this.text, required this.at});
  final String byUid;
  final String byName;
  final bool fromAdmin;
  final String text;
  final DateTime at;

  Map<String, dynamic> toMap() => {'by': byUid, 'byName': byName, 'admin': fromAdmin, 'text': text, 'at': at};

  static TicketMessage fromMap(Map m, DateTime Function(Object?) date) => TicketMessage(
        byUid: (m['by'] as String?) ?? '',
        byName: (m['byName'] as String?) ?? '',
        fromAdmin: (m['admin'] as bool?) ?? false,
        text: (m['text'] as String?) ?? '',
        at: date(m['at']),
      );
}

class Ticket {
  Ticket(this.id, this.raw, this.date);
  final String id;
  final Map<String, dynamic> raw;
  final DateTime Function(Object?) date;

  String get uid => (raw['uid'] as String?) ?? '';
  String get name => (raw['name'] as String?) ?? '';
  String get role => (raw['role'] as String?) ?? 'owner';
  String get topic => (raw['topic'] as String?) ?? 'other';
  String get subject => (raw['subject'] as String?) ?? '';
  String get body => (raw['body'] as String?) ?? '';
  String get linkType => (raw['linkType'] as String?) ?? 'other';
  String? get linkId => raw['linkId'] as String?;
  String get linkLabel => (raw['linkLabel'] as String?) ?? '';
  String get status => (raw['status'] as String?) ?? 'open';
  String? get assignee => raw['assignee'] as String?;
  DateTime get createdAt => date(raw['createdAt']);
  DateTime get updatedAt => date(raw['updatedAt'] ?? raw['createdAt']);
  Map<String, dynamic>? get refund => (raw['refund'] as Map?)?.cast<String, dynamic>();
  List<TicketMessage> get messages => [
        for (final m in (raw['messages'] as List?) ?? const []) TicketMessage.fromMap(m as Map, date),
      ];

  /// The newest message is from the support team and the person hasn't replied.
  bool get awaitingUser => messages.isNotEmpty && messages.last.fromAdmin && status != 'resolved';
}

/// Status after a new message: the person replying reopens a resolved
/// ticket; support replying to an open one moves it to in progress.
String statusAfterMessage(String current, {required bool fromAdmin}) {
  if (fromAdmin) return current == 'open' ? 'in_progress' : current;
  return current == 'resolved' ? 'open' : current;
}

/// Refunds in Version 1 are simulated and can't exceed what was paid.
int refundAmount(int requested, {required int paid}) => requested < 0 ? 0 : (requested > paid ? paid : requested);

class Report {
  Report(this.id, this.raw, this.date);
  final String id;
  final Map<String, dynamic> raw;
  final DateTime Function(Object?) date;

  /// review, chat or content
  String get type => (raw['type'] as String?) ?? 'content';
  String get targetId => (raw['targetId'] as String?) ?? '';
  String get reporterId => (raw['reporterId'] as String?) ?? '';
  String get reason => (raw['reason'] as String?) ?? '';
  String get excerpt => (raw['excerpt'] as String?) ?? '';

  /// open, actioned or dismissed
  String get status => (raw['status'] as String?) ?? 'open';
  DateTime get createdAt => date(raw['createdAt']);
}
