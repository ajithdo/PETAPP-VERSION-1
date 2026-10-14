/// Medicine dose times (spec 7.4). Pure Dart.
library;

class MedicinePlan {
  const MedicinePlan({
    required this.frequency,
    required this.times,
    required this.start,
    this.end,
    this.everyHours,
    this.weekdays = const [],
  });

  /// once, twice, every_x_hours, weekly, custom
  final String frequency;

  /// "08:00" style times. once: 1 time, twice: 2 times, weekly: 1 time,
  /// custom: any times on [weekdays].
  final List<String> times;
  final DateTime start;
  final DateTime? end;
  final int? everyHours;

  /// 1 = Monday ... 7 = Sunday, for custom schedules.
  final List<int> weekdays;
}

({int h, int m}) _hm(String t) {
  final p = t.split(':');
  return (h: int.parse(p[0]), m: int.parse(p.length > 1 ? p[1] : '0'));
}

/// Dose times on one calendar day.
List<DateTime> dosesOn(MedicinePlan plan, DateTime day) {
  final d = DateTime(day.year, day.month, day.day);
  final startDay = DateTime(plan.start.year, plan.start.month, plan.start.day);
  if (d.isBefore(startDay)) return const [];
  if (plan.end != null && d.isAfter(DateTime(plan.end!.year, plan.end!.month, plan.end!.day))) return const [];
  DateTime at(String t) {
    final x = _hm(t);
    return DateTime(d.year, d.month, d.day, x.h, x.m);
  }

  switch (plan.frequency) {
    case 'every_x_hours':
      final every = (plan.everyHours ?? 8).clamp(1, 24);
      final first = plan.times.isEmpty ? (h: 8, m: 0) : _hm(plan.times.first);
      final origin = DateTime(startDay.year, startDay.month, startDay.day, first.h, first.m);
      final out = <DateTime>[];
      // Walk forward from the origin and keep the doses on this day.
      final hoursFromOrigin = d.difference(origin).inHours;
      var k = hoursFromOrigin <= 0 ? 0 : (hoursFromOrigin / every).floor();
      while (true) {
        final t = origin.add(Duration(hours: k * every));
        if (t.isAfter(d.add(const Duration(days: 1)))) break;
        if (!t.isBefore(d) && t.isBefore(d.add(const Duration(days: 1)))) out.add(t);
        k++;
      }
      return out;
    case 'weekly':
      return d.weekday == plan.start.weekday ? [at(plan.times.isEmpty ? '09:00' : plan.times.first)] : const [];
    case 'custom':
      return plan.weekdays.contains(d.weekday) ? [for (final t in plan.times) at(t)] : const [];
    case 'twice':
      return [for (final t in (plan.times.length >= 2 ? plan.times.take(2) : const ['08:00', '20:00'])) at(t)];
    default:
      return [at(plan.times.isEmpty ? '09:00' : plan.times.first)];
  }
}

/// Next dose at or after [now].
DateTime? nextDose(MedicinePlan plan, DateTime now) {
  for (var i = 0; i < 14; i++) {
    final day = DateTime(now.year, now.month, now.day + i);
    for (final t in dosesOn(plan, day)) {
      if (!t.isBefore(now)) return t;
    }
  }
  return null;
}

/// Days of stock left given the doses per day.
int? stockDays(int? stock, MedicinePlan plan, DateTime now) {
  if (stock == null) return null;
  final perDay = dosesOn(plan, now).length;
  if (perDay == 0) return null;
  return stock ~/ perDay;
}
