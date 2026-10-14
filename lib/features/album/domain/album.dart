/// Memory album (spec 7.11): items, monthly grouping, "On this day",
/// milestones and birthdays. Pure Dart.
library;

import '../../../core/data/converters.dart';

/// Milestone kinds with a badge each (spec 7.11).
const milestoneKinds = ['birthday', 'gotcha', 'first_walk', 'first_vaccine', 'custom'];

class AlbumItem {
  AlbumItem(this.id, this.raw);
  final String id;
  final Map<String, dynamic> raw;

  String get petId => (raw['petId'] as String?) ?? '';
  String get ownerId => (raw['ownerId'] as String?) ?? '';

  /// photo, video, or milestone (a milestone without a photo).
  String get type => (raw['type'] as String?) ?? 'photo';
  bool get isVideo => type == 'video';
  bool get hasMedia => type != 'milestone' && (url?.isNotEmpty ?? false);
  String? get url => raw['url'] as String?;
  String get caption => (raw['caption'] as String?) ?? '';
  DateTime get takenAt => parseDate(raw['takenAt']) ?? createdAt;
  DateTime get createdAt => parseDate(raw['createdAt']) ?? DateTime.fromMillisecondsSinceEpoch(0);
  bool get favourite => (raw['favourite'] as bool?) ?? false;
  List<String> get albums => ((raw['albums'] as List?) ?? const []).map((e) => '$e').toList();
  String? get milestone {
    final m = raw['milestone'] as String?;
    return milestoneKinds.contains(m) ? m : null;
  }

  String? get milestoneTitle => raw['milestoneTitle'] as String?;
  int get durationSec => (raw['durationSec'] as num?)?.toInt() ?? 0;
  int get sizeBytes => (raw['sizeBytes'] as num?)?.toInt() ?? 0;
  String? get contentType => raw['contentType'] as String?;
  String? get byUid => raw['byUid'] as String?;
  String get byName => (raw['byName'] as String?) ?? '';
}

class MonthGroup {
  const MonthGroup(this.month, this.items);

  /// First day of the month.
  final DateTime month;
  final List<AlbumItem> items;
}

/// Newest month first; newest item first inside each month.
List<MonthGroup> groupByMonth(Iterable<AlbumItem> items) {
  final map = <DateTime, List<AlbumItem>>{};
  for (final i in items) {
    final k = DateTime(i.takenAt.year, i.takenAt.month);
    (map[k] ??= []).add(i);
  }
  final keys = map.keys.toList()..sort((a, b) => b.compareTo(a));
  return [
    for (final k in keys) MonthGroup(k, map[k]!..sort((a, b) => b.takenAt.compareTo(a.takenAt))),
  ];
}

/// Items taken on today's date in earlier years, most recent year first.
List<AlbumItem> onThisDay(Iterable<AlbumItem> items, DateTime now) => items
    .where((i) => i.hasMedia && i.takenAt.month == now.month && i.takenAt.day == now.day && i.takenAt.year < now.year)
    .toList()
  ..sort((a, b) => b.takenAt.compareTo(a.takenAt));

/// Distinct album names, A–Z.
List<String> albumNames(Iterable<AlbumItem> items) {
  final s = <String>{};
  for (final i in items) {
    s.addAll(i.albums.where((a) => a.trim().isNotEmpty));
  }
  return s.toList()..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
}

/// Milestones oldest first (the timeline reads like a story).
List<AlbumItem> milestones(Iterable<AlbumItem> items) =>
    items.where((i) => i.milestone != null).toList()..sort((a, b) => a.takenAt.compareTo(b.takenAt));

/// Milestone kinds already earned (custom can repeat).
Set<String> earnedBadges(Iterable<AlbumItem> items) => {for (final i in items) ?i.milestone};

/// The latest photo or video to show on Home.
AlbumItem? latestMemory(Iterable<AlbumItem> items) {
  AlbumItem? best;
  for (final i in items.where((i) => i.hasMedia)) {
    if (best == null || i.takenAt.isAfter(best.takenAt)) best = i;
  }
  return best;
}

/// Next birthday on or after today. 29 Feb birthdays are celebrated on
/// 28 Feb in non-leap years.
DateTime? nextBirthday(DateTime? birthday, DateTime now) {
  if (birthday == null) return null;
  final today = DateTime(now.year, now.month, now.day);
  DateTime inYear(int y) {
    final leap = (y % 4 == 0 && y % 100 != 0) || y % 400 == 0;
    final d = birthday.month == 2 && birthday.day == 29 && !leap ? 28 : birthday.day;
    return DateTime(y, birthday.month, d);
  }

  final thisYear = inYear(now.year);
  return thisYear.isBefore(today) ? inYear(now.year + 1) : thisYear;
}

bool isBirthdayToday(DateTime? birthday, DateTime now) {
  final next = nextBirthday(birthday, now);
  return next != null && next.year == now.year && next.month == now.month && next.day == now.day;
}

/// Age the pet turns on [next].
int turningAge(DateTime birthday, DateTime next) => next.year - birthday.year;

int daysUntil(DateTime day, DateTime now) =>
    DateTime(day.year, day.month, day.day).difference(DateTime(now.year, now.month, now.day)).inDays;

/// Whole years between [then] and [now] ("1 year ago").
int yearsAgo(DateTime then, DateTime now) {
  var y = now.year - then.year;
  if (now.month < then.month || (now.month == then.month && now.day < then.day)) y--;
  return y;
}
