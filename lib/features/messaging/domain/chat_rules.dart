/// Chat safety and helper rules (spec 7.8). Pure Dart, unit tested.
library;

/// Phone numbers typed into a chat are hidden: neither side should see the
/// other's real number (calls go through a masked relay in the live app).
/// Matches Indian mobile and landline formats with or without +91 / 0.
final _phonePattern = RegExp(r'(?:(?:\+|00)\s?91[\s-]?|\b0)?(?:\d[\s-]?){9}\d\b');

/// Placeholder shown instead of a hidden number.
const hiddenNumber = '•••• ••••••';

/// Returns the text with phone numbers hidden and whether anything changed.
({String text, bool masked}) maskPhoneNumbers(String text) {
  var masked = false;
  final out = text.replaceAllMapped(_phonePattern, (m) {
    final digits = m[0]!.replaceAll(RegExp(r'\D'), '');
    // Only real phone-length numbers (10 digits, or 12 with 91 / 11 with 0).
    if (digits.length < 10 || digits.length > 13) return m[0]!;
    masked = true;
    return hiddenNumber;
  });
  return (text: out, masked: masked);
}

/// A masked version of a phone number for display: +91 90000 •••12.
String maskedPhone(String? phone) {
  if (phone == null || phone.trim().isEmpty) return '+91 ••••• •••••';
  final digits = phone.replaceAll(RegExp(r'\D'), '');
  final last2 = digits.length >= 2 ? digits.substring(digits.length - 2) : digits;
  final local = digits.length > 10 ? digits.substring(digits.length - 10) : digits;
  final first5 = local.length >= 5 ? local.substring(0, 5) : local;
  return '+91 $first5 •••$last2';
}

final _upiPattern = RegExp(r'\b[\w.\-]{2,}@(?:upi|ok[a-z]+|ybl|ibl|axl|apl|paytm|sbi|icici|hdfcbank|axisbank|kotak|yesbank|pnb|boi|barodampay|freecharge|airtel|jio)\b', caseSensitive: false);
final _cardPattern = RegExp(r'\b(?:\d[ -]?){13,19}\b');
final _sensitiveWords = RegExp(r'\b(otp|cvv|upi pin|atm pin|card number|card no|net ?banking password)\b', caseSensitive: false);
const _sensitiveIndic = ['ओटीपी', 'पिन नंबर', 'कार्ड नंबर', 'ఓటీపీ', 'పిన్ నంబర్', 'కార్డ్ నంబర్'];

/// True when a message looks like it shares payment details (UPI ID, card
/// number, OTP or PIN). The app warns before sending: pay only in PawSetu.
bool looksLikePaymentDetails(String text) {
  if (_upiPattern.hasMatch(text)) return true;
  if (_sensitiveWords.hasMatch(text)) return true;
  if (_sensitiveIndic.any(text.contains)) return true;
  for (final m in _cardPattern.allMatches(text)) {
    final digits = m[0]!.replaceAll(RegExp(r'\D'), '');
    // Phone numbers are 10-12 digits; cards are 13-19.
    if (digits.length >= 13 && _luhn(digits)) return true;
  }
  return false;
}

bool _luhn(String digits) {
  var sum = 0;
  var alt = false;
  for (var i = digits.length - 1; i >= 0; i--) {
    var n = digits.codeUnitAt(i) - 48;
    if (alt) {
      n *= 2;
      if (n > 9) n -= 9;
    }
    sum += n;
    alt = !alt;
  }
  return sum % 10 == 0;
}

/// "typing…" shows only while the other person typed in the last few seconds.
bool typingIsFresh(DateTime? at, DateTime now, {Duration window = const Duration(seconds: 6)}) =>
    at != null && now.difference(at) < window && !at.isAfter(now.add(const Duration(seconds: 5)));

/// Case-insensitive search: every word of [query] must appear in one of
/// [fields] ("bruno vet" finds a chat with Bruno and a vet).
bool matchesSearch(String query, Iterable<String?> fields) {
  final words = query.toLowerCase().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
  if (words.isEmpty) return true;
  final hay = fields.whereType<String>().join(' \u0000 ').toLowerCase();
  return words.every(hay.contains);
}

/// Unread counts after [senderId] sends a message: everyone else +1, the
/// sender back to 0.
Map<String, int> bumpUnread(Map<String, int> unread, Iterable<String> participants, String senderId) => {
      for (final p in participants) p: p == senderId ? 0 : (unread[p] ?? 0) + 1,
    };

/// Voice notes stop at 2 minutes (spec 7.8).
const maxVoiceNote = Duration(minutes: 2);

/// Participants without an app account in the demo (fictional customers and
/// places that are not on PawSetu yet) use ids like p_clinic_blr_1.
bool isPlaceholderParticipant(String uid) => uid.startsWith('p_') || uid.startsWith('u_cust');

/// Deterministic conversation ids keep one thread per booking, enquiry,
/// consultation and assistant.
String bookingConversationId(String bookingId) => 'chat_$bookingId';
String enquiryConversationId(String placeId, String ownerUid) => 'enq_${placeId}_$ownerUid';
String teleVetConversationId(String consultationId) => 'tv_$consultationId';
String assistantConversationId(String uid) => 'ai_$uid';

/// Builds a WAV file from 16-bit mono PCM (voice notes are recorded as PCM
/// on every platform, including the web).
List<int> pcm16ToWav(List<int> pcm, {int sampleRate = 16000}) {
  final dataLen = pcm.length;
  final byteRate = sampleRate * 2;
  List<int> u32(int v) => [v & 0xff, (v >> 8) & 0xff, (v >> 16) & 0xff, (v >> 24) & 0xff];
  List<int> u16(int v) => [v & 0xff, (v >> 8) & 0xff];
  return [
    ...'RIFF'.codeUnits,
    ...u32(36 + dataLen),
    ...'WAVE'.codeUnits,
    ...'fmt '.codeUnits,
    ...u32(16),
    ...u16(1), // PCM
    ...u16(1), // mono
    ...u32(sampleRate),
    ...u32(byteRate),
    ...u16(2),
    ...u16(16),
    ...'data'.codeUnits,
    ...u32(dataLen),
    ...pcm,
  ];
}
