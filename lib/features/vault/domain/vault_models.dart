/// Document vault models and pure rules (spec 7.9). No Flutter imports.
library;

import '../../../core/data/converters.dart';

/// Document types in the order the vault shows them.
const vaultDocTypes = [
  'vaccination',
  'insurance',
  'lab',
  'prescription',
  'invoice',
  'licence',
  'adoption',
  'travel',
  'other',
];

/// A file in the vault. Phase 4 (vaccine certificates) and Phase 6
/// (prescriptions) write the same shape: ownerId, petId, type, title, tags,
/// url, contentType, createdAt; the vault adds the optional fields.
class VaultDoc {
  VaultDoc(this.id, this.raw);
  final String id;
  final Map<String, dynamic> raw;

  String get ownerId => (raw['ownerId'] as String?) ?? '';
  String get petId => (raw['petId'] as String?) ?? '';
  String get type {
    final t = raw['type'] as String?;
    return vaultDocTypes.contains(t) ? t! : 'other';
  }

  String get title => (raw['title'] as String?) ?? '';
  List<String> get tags => ((raw['tags'] as List?) ?? const []).map((e) => '$e').toList();
  String? get url => raw['url'] as String?;
  String get contentType => (raw['contentType'] as String?) ?? (isSample ? 'sample' : 'image/jpeg');
  DateTime? get expiry => parseDate(raw['expiry']);
  DateTime get createdAt => parseDate(raw['createdAt']) ?? DateTime.fromMillisecondsSinceEpoch(0);
  int get sizeBytes => (raw['sizeBytes'] as num?)?.toInt() ?? 0;
  String? get fileName => raw['fileName'] as String?;
  String? get notes => raw['notes'] as String?;

  /// Where the file came from: scan, gallery, pdf, sample, health (Phase 4
  /// certificate), televet (Phase 6 prescription).
  String? get source => raw['source'] as String?;

  /// Optional in-app screen for documents made by other features, e.g. a
  /// tele-vet prescription.
  String? get link => raw['link'] as String?;

  /// none, pending (auto-read not confirmed yet), confirmed, skipped.
  String get readStatus => (raw['readStatus'] as String?) ?? 'none';
  bool get needsReview => readStatus == 'pending';
  Map<String, dynamic>? get extracted => (raw['extracted'] as Map?)?.cast<String, dynamic>();

  bool get isSample => url?.startsWith('sample:') ?? false;
  String? get sampleKey => isSample ? url!.substring(7) : null;
  bool get isPdf => contentType == 'application/pdf';
  bool get isImage => contentType.startsWith('image/');
}

enum ExpiryState { none, valid, soon, expired }

/// Documents expiring within this many days are flagged "Expires soon".
const expirySoonDays = 30;

ExpiryState expiryState(DateTime? expiry, DateTime now) {
  if (expiry == null) return ExpiryState.none;
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(expiry.year, expiry.month, expiry.day);
  if (day.isBefore(today)) return ExpiryState.expired;
  if (!day.isAfter(today.add(const Duration(days: expirySoonDays)))) return ExpiryState.soon;
  return ExpiryState.valid;
}

/// When to remind the owner about an expiry: 14 days before at 10 am, or
/// tomorrow at 10 am if that moment has already passed. Null when the
/// document has already expired.
DateTime? expiryReminderAt(DateTime expiry, DateTime now) {
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(expiry.year, expiry.month, expiry.day);
  if (day.isBefore(today)) return null;
  final early = DateTime(day.year, day.month, day.day - 14, 10);
  if (early.isAfter(now)) return early;
  final tomorrow = DateTime(now.year, now.month, now.day + 1, 10);
  if (!tomorrow.isAfter(DateTime(day.year, day.month, day.day, 23, 59))) return tomorrow;
  return now.add(const Duration(hours: 1));
}

/// Free-text search over everything the owner can see about a document.
/// [typeLabel] and [petName] are passed in already translated.
bool docMatches(VaultDoc d, String query, {String typeLabel = '', String petName = ''}) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return true;
  final ex = d.extracted ?? const {};
  final hay = [
    d.title,
    typeLabel,
    petName,
    d.fileName ?? '',
    d.notes ?? '',
    ...d.tags,
    for (final v in ex.values)
      if (v is String) v,
  ].join(' ').toLowerCase();
  return q.split(RegExp(r'\s+')).every(hay.contains);
}

/// Sorts newest first, but documents waiting for review and those expiring
/// soon come to the top.
List<VaultDoc> sortDocs(List<VaultDoc> docs, DateTime now) {
  int rank(VaultDoc d) {
    if (d.needsReview) return 0;
    final e = expiryState(d.expiry, now);
    if (e == ExpiryState.soon) return 1;
    return 2;
  }

  return [...docs]..sort((a, b) {
      final r = rank(a).compareTo(rank(b));
      return r != 0 ? r : b.createdAt.compareTo(a.createdAt);
    });
}

/// Distinct tags across documents, most used first.
List<String> popularTags(List<VaultDoc> docs, {int max = 12}) {
  final counts = <String, int>{};
  for (final d in docs) {
    for (final t in d.tags) {
      final k = t.trim();
      if (k.isNotEmpty) counts[k] = (counts[k] ?? 0) + 1;
    }
  }
  final keys = counts.keys.toList()..sort((a, b) => counts[b]!.compareTo(counts[a]!) != 0 ? counts[b]!.compareTo(counts[a]!) : a.compareTo(b));
  return keys.take(max).toList();
}

/// Cleans user-typed tags: trims, drops empties and duplicates (case-insensitive).
List<String> cleanTags(Iterable<String> tags) {
  final seen = <String>{};
  final out = <String>[];
  for (final t in tags) {
    final v = t.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (v.isEmpty || v.length > 30) continue;
    if (seen.add(v.toLowerCase())) out.add(v);
  }
  return out;
}
