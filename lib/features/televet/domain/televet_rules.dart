/// Tele-vet rules (spec 7.7 and 8). Pure Dart so the standalone demo, the
/// unit tests and (by port) the sendTeleVetMessage Cloud Function agree.
///
/// Every number comes from config/app limits (admin-configurable); the
/// defaults below are only used when the document has no value.
library;

/// The allowance a consultation was opened with (copied onto the
/// consultation so later admin changes do not affect running chats).
class TeleVetLimits {
  const TeleVetLimits({
    required this.perMonth,
    required this.messages,
    required this.words,
    required this.hours,
    required this.video,
  });

  /// Consultations a month.
  final int perMonth;

  /// Owner messages per consultation.
  final int messages;

  /// Words per owner message.
  final int words;

  /// How long the chat stays open after a vet joins.
  final int hours;

  /// Video calls allowed (Plus only).
  final bool video;

  static const freeDefaults = TeleVetLimits(perMonth: 1, messages: 20, words: 60, hours: 24, video: false);
  static const plusDefaults = TeleVetLimits(perMonth: 999, messages: 100, words: 300, hours: 72, video: true);

  /// Builds limits from a plan's map in config/app (`limits.free` / `limits.plus`).
  factory TeleVetLimits.fromPlan(Map<String, dynamic>? m, {required bool plus}) {
    final d = plus ? plusDefaults : freeDefaults;
    int v(String k, int def) => (m?[k] as num?)?.toInt() ?? def;
    return TeleVetLimits(
      perMonth: v('teleVetPerMonth', d.perMonth),
      messages: v('teleVetMessages', d.messages),
      words: v('teleVetWords', d.words),
      hours: v('teleVetHours', d.hours),
      video: plus,
    );
  }

  /// Reads the copy stored on a consultation.
  factory TeleVetLimits.fromStored(Map<dynamic, dynamic>? m, {bool plus = false}) {
    final d = plus ? plusDefaults : freeDefaults;
    int v(String k, int def) => (m?[k] as num?)?.toInt() ?? def;
    return TeleVetLimits(
      perMonth: v('perMonth', d.perMonth),
      messages: v('messages', d.messages),
      words: v('words', d.words),
      hours: v('hours', d.hours),
      video: (m?['video'] as bool?) ?? d.video,
    );
  }

  Map<String, dynamic> toMap() => {'perMonth': perMonth, 'messages': messages, 'words': words, 'hours': hours, 'video': video};

  /// Plus shows "unlimited" instead of a big number.
  bool get unlimitedPerMonth => perMonth >= 999;
}

/// Counts words the way people do: anything separated by spaces. Works for
/// English, Hindi and Telugu (all use spaces between words).
int countWords(String text) {
  final t = text.trim();
  if (t.isEmpty) return 0;
  return t.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
}

/// Why a tele-vet message cannot be sent right now.
enum TeleVetBlock { none, empty, tooManyWords, noMessagesLeft, chatClosed, ended }

class TeleVetCheck {
  const TeleVetCheck(this.block, {this.words = 0, this.maxWords = 0, this.messagesLeft = 0});
  final TeleVetBlock block;
  final int words;
  final int maxWords;

  /// Owner messages left after this one is sent (or now, if blocked).
  final int messagesLeft;
  bool get ok => block == TeleVetBlock.none;
}

/// Checks one message before it is sent. Vets are never limited; owners
/// are limited by message count and words per message. Photos and voice
/// notes count as a message but have no words.
TeleVetCheck checkTeleVetMessage({
  required String text,
  required bool fromOwner,
  required TeleVetLimits limits,
  required int messagesUsed,
  required String status,
  required DateTime now,
  DateTime? endsAt,
  bool attachment = false,
}) {
  final left = (limits.messages - messagesUsed).clamp(0, limits.messages);
  if (status == 'ended') return TeleVetCheck(TeleVetBlock.ended, messagesLeft: left);
  // The vet can still wrap up (advice, prescription) after the owner's
  // window closes; only the owner's side closes.
  if (fromOwner && endsAt != null && now.isAfter(endsAt)) return TeleVetCheck(TeleVetBlock.chatClosed, messagesLeft: left);
  final words = countWords(text);
  if (words == 0 && !attachment) return TeleVetCheck(TeleVetBlock.empty, messagesLeft: left);
  if (!fromOwner) return TeleVetCheck(TeleVetBlock.none, words: words, messagesLeft: left);
  if (messagesUsed >= limits.messages) return TeleVetCheck(TeleVetBlock.noMessagesLeft, words: words, maxWords: limits.words);
  if (words > limits.words) {
    return TeleVetCheck(TeleVetBlock.tooManyWords, words: words, maxWords: limits.words, messagesLeft: left);
  }
  return TeleVetCheck(TeleVetBlock.none, words: words, maxWords: limits.words, messagesLeft: left - 1);
}

/// Start of the calendar month [now] is in.
DateTime monthStart(DateTime now) => DateTime(now.year, now.month);

/// First day of next month: when monthly allowances reset.
DateTime nextMonthStart(DateTime now) => DateTime(now.year, now.month + 1);

/// How many consultations were started in the current calendar month.
int consultationsThisMonth(Iterable<DateTime> createdAt, DateTime now) {
  final from = monthStart(now);
  return createdAt.where((d) => !d.isBefore(from) && !d.isAfter(now)).length;
}

/// Why a new consultation cannot start.
enum StartBlock { none, monthlyLimit, videoNeedsPlus }

StartBlock canStartConsultation({required int usedThisMonth, required TeleVetLimits limits, required bool video}) {
  if (video && !limits.video) return StartBlock.videoNeedsPlus;
  if (usedThisMonth >= limits.perMonth) return StartBlock.monthlyLimit;
  return StartBlock.none;
}

/// Price of a video consultation. Plus members get the admin-set discount
/// (default 10%). Chat consultations are included in the plan (fee 0).
class TeleVetPrice {
  const TeleVetPrice({required this.fee, required this.discount, required this.total, required this.commission, required this.payout});
  final int fee;
  final int discount;
  final int total;
  final int commission;
  final int payout;
  static const free = TeleVetPrice(fee: 0, discount: 0, total: 0, commission: 0, payout: 0);
}

TeleVetPrice priceTeleVet({
  required bool video,
  required int videoFee,
  required bool plus,
  required num discountPercent,
  required num commissionPercent,
}) {
  if (!video) return TeleVetPrice.free;
  final discount = plus ? (videoFee * discountPercent / 100).round() : 0;
  final total = videoFee - discount;
  final commission = (total * commissionPercent / 100).round();
  return TeleVetPrice(fee: videoFee, discount: discount, total: total, commission: commission, payout: total - commission);
}

/// Queue order: Plus members (priority) first, then whoever waited longest.
/// Scheduled consultations wait until their time.
int compareQueue({required bool aPriority, required DateTime aAt, required bool bPriority, required DateTime bAt}) {
  if (aPriority != bPriority) return aPriority ? -1 : 1;
  return aAt.compareTo(bAt);
}

/// When the chat closes once a vet joins.
DateTime chatEndsAt(DateTime startedAt, TeleVetLimits limits) => startedAt.add(Duration(hours: limits.hours));

/// Shows the allowance in amber when few messages remain.
bool allowanceLow(int messagesLeft, TeleVetLimits limits) => messagesLeft <= (limits.messages / 4).ceil();
