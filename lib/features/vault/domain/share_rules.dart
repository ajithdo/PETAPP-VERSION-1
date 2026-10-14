/// Expiring, view-only share links (spec 7.9 and 7.11). Pure Dart: the
/// standalone demo and the openShareLink Cloud Function follow the same rules.
library;

import '../../../core/data/converters.dart';
import 'pin_hash.dart';

/// Link lifetimes a vet can be given (spec 7.9).
enum ShareExpiry {
  hour1(Duration(hours: 1)),
  hours24(Duration(hours: 24)),
  days7(Duration(days: 7)),
  never(null);

  const ShareExpiry(this.duration);
  final Duration? duration;

  DateTime? from(DateTime now) => duration == null ? null : now.add(duration!);
}

/// Result of opening a link.
enum ShareStatus { ok, needsPin, wrongPin, locked, expired, revoked, notFound }

class ShareLink {
  ShareLink(this.id, this.raw);
  final String id;
  final Map<String, dynamic> raw;

  String get ownerId => (raw['ownerId'] as String?) ?? '';
  String get ownerName => (raw['ownerName'] as String?) ?? '';
  String get petId => (raw['petId'] as String?) ?? '';
  String get petName => (raw['petName'] as String?) ?? '';

  /// docs (vault documents for a vet) or album (private family link).
  String get kind => (raw['kind'] as String?) ?? 'docs';
  List<String> get docIds => ((raw['docIds'] as List?) ?? const []).map((e) => '$e').toList();

  /// For album links: an album name to limit the link to, or null for all.
  String? get albumName => raw['albumName'] as String?;
  DateTime? get expiresAt => parseDate(raw['expiresAt']);
  String? get pinHash => raw['pinHash'] as String?;
  bool get hasPin => pinHash != null;
  bool get revoked => (raw['revoked'] as bool?) ?? false;
  DateTime? get revokedAt => parseDate(raw['revokedAt']);
  DateTime get createdAt => parseDate(raw['createdAt']) ?? DateTime.fromMillisecondsSinceEpoch(0);
  List<ShareAccess> get accessLog => [
        for (final a in (raw['accessLog'] as List?) ?? const [])
          if (a is Map) ShareAccess(at: parseDate(a['at']) ?? DateTime.fromMillisecondsSinceEpoch(0), device: (a['device'] as String?) ?? '', ok: (a['ok'] as bool?) ?? true),
      ]..sort((a, b) => b.at.compareTo(a.at));

  bool isExpired(DateTime now) => expiresAt != null && !expiresAt!.isAfter(now);
  bool isActive(DateTime now) => !revoked && !isExpired(now);
}

class ShareAccess {
  const ShareAccess({required this.at, required this.device, this.ok = true});
  final DateTime at;
  final String device;

  /// False for a wrong PIN attempt.
  final bool ok;
}

/// Decides whether a link may be opened. Revoked wins over expired so the
/// owner's action is what the vet is told about.
ShareStatus checkShare(ShareLink? link, {String? pin, required DateTime now}) {
  if (link == null) return ShareStatus.notFound;
  if (link.revoked) return ShareStatus.revoked;
  if (link.isExpired(now)) return ShareStatus.expired;
  if (link.hasPin) {
    if (tooManyWrongPins(link, now)) return ShareStatus.locked;
    if (pin == null || pin.isEmpty) return ShareStatus.needsPin;
    if (!verifyPin(pin, link.pinHash)) return ShareStatus.wrongPin;
  }
  return ShareStatus.ok;
}

/// Too many wrong PINs in the last 15 minutes locks the link for a while.
const maxWrongPins = 5;
bool tooManyWrongPins(ShareLink link, DateTime now) =>
    link.accessLog.where((a) => !a.ok && now.difference(a.at) < const Duration(minutes: 15)).length >= maxWrongPins;

/// The public web address of a link.
String shareUrl(String token, {String? webBase}) {
  final base = webBase ?? 'https://pawsetu.app/';
  return '$base#/share/$token';
}
