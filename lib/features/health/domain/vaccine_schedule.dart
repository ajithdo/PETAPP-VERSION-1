/// Indicative vaccination schedules (spec section 11). Admin-editable in
/// Version 2 and to be reviewed by a vet before launch. Pure Dart.
library;

import '../../pets/domain/breeds.dart';

enum DoseStatus { done, overdue, dueSoon, upcoming, askVet }

/// One step of a schedule template.
class DoseTemplate {
  const DoseTemplate(this.key, this.name, this.doseLabel, {this.fromWeeks, this.toWeeks, this.yearlyAfter, this.everyYears = 1, this.optional = false});
  final String key;
  final String name; // e.g. "DHPPi + Lepto"
  final String doseLabel; // dose_1, dose_2, dose_3, booster, optional
  final int? fromWeeks;
  final int? toWeeks;

  /// For boosters: the series key whose last dose starts the clock.
  final String? yearlyAfter;
  final int everyYears;
  final bool optional;
}

const dogTemplates = [
  DoseTemplate('dhppi_1', 'DHPPi + Lepto', 'dose_1', fromWeeks: 6, toWeeks: 8),
  DoseTemplate('dhppi_2', 'DHPPi + Lepto', 'dose_2', fromWeeks: 9, toWeeks: 11),
  DoseTemplate('dhppi_3', 'DHPPi + Lepto', 'dose_3', fromWeeks: 12, toWeeks: 16),
  DoseTemplate('rabies_1', 'Anti-rabies', 'dose_1', fromWeeks: 12, toWeeks: 16),
  DoseTemplate('dhppi_booster', 'DHPPi + Lepto', 'booster', yearlyAfter: 'dhppi'),
  DoseTemplate('rabies_booster', 'Anti-rabies', 'booster', yearlyAfter: 'rabies'),
  DoseTemplate('kennel_cough', 'Kennel cough', 'optional', optional: true),
];

const catTemplates = [
  DoseTemplate('fvrcp_1', 'FVRCP', 'dose_1', fromWeeks: 6, toWeeks: 8),
  DoseTemplate('fvrcp_2', 'FVRCP', 'dose_2', fromWeeks: 10, toWeeks: 12),
  DoseTemplate('fvrcp_3', 'FVRCP', 'dose_3', fromWeeks: 14, toWeeks: 16),
  DoseTemplate('rabies_1', 'Anti-rabies', 'dose_1', fromWeeks: 12, toWeeks: 16),
  DoseTemplate('fvrcp_booster', 'FVRCP', 'booster', yearlyAfter: 'fvrcp', everyYears: 3),
  DoseTemplate('rabies_booster', 'Anti-rabies', 'booster', yearlyAfter: 'rabies'),
  DoseTemplate('felv', 'FeLV', 'optional', optional: true),
];

List<DoseTemplate> templatesFor(Species s) => applyVaccineOverride(
      switch (s) {
        Species.dog => dogTemplates,
        Species.cat => catTemplates,
        _ => const [],
      },
      (VaccineOverrides.current[s.name] as Map?) ?? const {},
    );

/// Timing changes made in the admin panel (Settings → Vaccine schedules),
/// kept in config/app `vaccineSchedules`, for example
/// `{'dog': {'dhppi_1': {'from': 6, 'to': 8}, 'rabies_booster': {'everyYears': 1}}}`.
/// The app copies them here whenever config/app changes.
class VaccineOverrides {
  static Map<String, dynamic> current = const {};
}

/// [base] with the admin's timing changes for one species applied.
List<DoseTemplate> applyVaccineOverride(List<DoseTemplate> base, Map overrides) {
  if (overrides.isEmpty) return base;
  int? n(Object? v) => (v as num?)?.toInt();
  return [
    for (final t in base)
      if (overrides[t.key] is Map)
        DoseTemplate(
          t.key,
          t.name,
          t.doseLabel,
          fromWeeks: n((overrides[t.key] as Map)['from']) ?? t.fromWeeks,
          toWeeks: n((overrides[t.key] as Map)['to']) ?? t.toWeeks,
          yearlyAfter: t.yearlyAfter,
          everyYears: n((overrides[t.key] as Map)['everyYears']) ?? t.everyYears,
          optional: t.optional,
        )
      else
        t,
  ];
}

/// A vaccine the owner recorded.
class VaccineRecord {
  const VaccineRecord({required this.id, required this.key, required this.name, required this.givenDate, this.brand, this.batch, this.vetName, this.clinicName, this.certificateDocId});
  final String id;
  final String key; // template key (e.g. dhppi_2) or "other"
  final String name;
  final DateTime givenDate;
  final String? brand;
  final String? batch;
  final String? vetName;
  final String? clinicName;
  final String? certificateDocId;
}

class ScheduleItem {
  const ScheduleItem({required this.template, required this.status, this.due, this.record});
  final DoseTemplate template;
  final DoseStatus status;
  final DateTime? due;
  final VaccineRecord? record;
}

const dueSoonDays = 14;

DoseStatus _statusFor(DateTime due, DateTime? windowEnd, DateTime today) {
  final end = windowEnd ?? due;
  if (end.isBefore(today)) return DoseStatus.overdue;
  if (!due.isAfter(today.add(const Duration(days: dueSoonDays)))) return DoseStatus.dueSoon;
  return DoseStatus.upcoming;
}

String _series(String key) => key.split('_').first;

/// Builds the schedule for a pet. Puppy/kitten doses are shown while the pet
/// is young; for older pets with no records we don't invent overdue puppy
/// doses, we show "Ask your vet for a catch-up plan" instead ([needsCatchUp]).
({List<ScheduleItem> items, bool needsCatchUp}) buildSchedule({
  required Species species,
  required DateTime? birthday,
  required List<VaccineRecord> records,
  required DateTime now,
}) {
  final today = DateTime(now.year, now.month, now.day);
  final templates = templatesFor(species);
  if (templates.isEmpty) return (items: const <ScheduleItem>[], needsCatchUp: false);
  final byKey = <String, VaccineRecord>{};
  for (final r in records) {
    final cur = byKey[r.key];
    if (cur == null || r.givenDate.isAfter(cur.givenDate)) byKey[r.key] = r;
  }
  final ageWeeks = birthday == null ? 9999 : today.difference(birthday).inDays ~/ 7;
  final young = ageWeeks < 26;
  final items = <ScheduleItem>[];
  final hasAnyRecord = records.isNotEmpty;

  DateTime? lastOfSeries(String series) {
    DateTime? last;
    for (final r in records) {
      if (_series(r.key) == series && (last == null || r.givenDate.isAfter(last))) last = r.givenDate;
    }
    return last;
  }

  for (final t in templates) {
    final rec = byKey[t.key];
    if (t.optional) {
      items.add(ScheduleItem(template: t, status: rec != null ? DoseStatus.done : DoseStatus.askVet, record: rec));
      continue;
    }
    if (t.fromWeeks != null) {
      // Puppy / kitten series.
      if (rec != null) {
        items.add(ScheduleItem(template: t, status: DoseStatus.done, record: rec, due: rec.givenDate));
      } else if (birthday != null && young) {
        final due = birthday.add(Duration(days: t.fromWeeks! * 7));
        final end = birthday.add(Duration(days: t.toWeeks! * 7));
        items.add(ScheduleItem(template: t, status: _statusFor(due, end, today), due: due));
      }
      continue;
    }
    // Boosters: every N years after the last dose of the series.
    final last = lastOfSeries(_series(t.yearlyAfter!));
    if (last == null) {
      if (!young && !hasAnyRecord) continue; // handled by needsCatchUp
      if (young) continue; // first booster appears once the series is done
      items.add(ScheduleItem(template: t, status: DoseStatus.askVet));
      continue;
    }
    final due = DateTime(last.year + t.everyYears, last.month, last.day);
    items.add(ScheduleItem(template: t, status: _statusFor(due, null, today), due: due));
  }
  return (items: items, needsCatchUp: !young && !hasAnyRecord);
}

/// Deworming interval by age (spec 11): every 2 weeks until 12 weeks,
/// monthly until 6 months, then every 3 months.
Duration dewormInterval(DateTime? birthday, DateTime at) {
  if (birthday == null) return const Duration(days: 90);
  final weeks = at.difference(birthday).inDays ~/ 7;
  if (weeks < 12) return const Duration(days: 14);
  if (weeks < 26) return const Duration(days: 30);
  return const Duration(days: 90);
}

DateTime nextDeworming(DateTime? birthday, DateTime? last, DateTime now) {
  if (last == null) return DateTime(now.year, now.month, now.day);
  return last.add(dewormInterval(birthday, last));
}

DateTime nextFleaTick(DateTime? last, DateTime now) =>
    last == null ? DateTime(now.year, now.month, now.day) : last.add(const Duration(days: 30));

/// Indicative healthy weight range (kg) by species, breed and size.
({double min, double max})? healthyWeight(Species s, String? breedId, BreedSize size, {required bool young}) {
  if (young) return null; // growing: ask the vet
  const byBreed = {
    'labrador': (min: 25.0, max: 36.0),
    'golden': (min: 25.0, max: 34.0),
    'gsd': (min: 22.0, max: 40.0),
    'beagle': (min: 9.0, max: 11.0),
    'pug': (min: 6.0, max: 8.0),
    'shih_tzu': (min: 4.0, max: 7.5),
    'pomeranian': (min: 1.8, max: 3.5),
    'indie_dog': (min: 15.0, max: 30.0),
    'persian': (min: 3.0, max: 5.5),
    'indie_cat': (min: 3.0, max: 5.0),
    'holland_lop': (min: 1.3, max: 1.8),
    'cockatiel': (min: 0.08, max: 0.12),
    'budgie': (min: 0.03, max: 0.04),
  };
  final b = byBreed[breedId];
  if (b != null) return b;
  return switch (s) {
    Species.dog => switch (size) {
        BreedSize.small => (min: 3.0, max: 10.0),
        BreedSize.medium => (min: 10.0, max: 25.0),
        BreedSize.large => (min: 25.0, max: 40.0),
        BreedSize.giant => (min: 45.0, max: 80.0),
      },
    Species.cat => (min: 3.0, max: 6.0),
    Species.rabbit => (min: 1.0, max: 5.0),
    Species.bird => null,
  };
}
