import 'package:flutter_test/flutter_test.dart';
import 'package:pawsetu/features/health/domain/medicine_schedule.dart';
import 'package:pawsetu/features/health/domain/vaccine_schedule.dart';
import 'package:pawsetu/features/pets/domain/breeds.dart';

void main() {
  final now = DateTime(2026, 10, 14, 10);

  group('vaccine schedule', () {
    test('a 5-month puppy missing dose 3 is overdue, then the booster is next', () {
      final birthday = DateTime(2026, 5, 14);
      final records = [
        VaccineRecord(id: 'a', key: 'dhppi_1', name: 'DHPPi + Lepto', givenDate: birthday.add(const Duration(days: 45))),
        VaccineRecord(id: 'b', key: 'dhppi_2', name: 'DHPPi + Lepto', givenDate: birthday.add(const Duration(days: 66))),
        VaccineRecord(id: 'c', key: 'rabies_1', name: 'Anti-rabies', givenDate: birthday.add(const Duration(days: 98))),
      ];
      final s = buildSchedule(species: Species.dog, birthday: birthday, records: records, now: now);
      final d3 = s.items.firstWhere((i) => i.template.key == 'dhppi_3');
      expect(d3.status, DoseStatus.overdue);
      expect(s.items.where((i) => i.status == DoseStatus.overdue), hasLength(1));
      expect(s.needsCatchUp, isFalse);

      // Mark dose 3 done today -> the yearly booster appears a year later.
      final after = buildSchedule(species: Species.dog, birthday: birthday, now: now, records: [
        ...records,
        VaccineRecord(id: 'd', key: 'dhppi_3', name: 'DHPPi + Lepto', givenDate: now),
      ]);
      expect(after.items.firstWhere((i) => i.template.key == 'dhppi_3').status, DoseStatus.done);
      final booster = after.items.firstWhere((i) => i.template.key == 'dhppi_booster');
      expect(booster.due, DateTime(2027, 10, 14));
      expect(booster.status, DoseStatus.upcoming);
    });

    test('an adult with boosters 11.5 months ago is due soon', () {
      final s = buildSchedule(species: Species.dog, birthday: DateTime(2023, 7, 1), now: now, records: [
        VaccineRecord(id: 'x', key: 'rabies_booster', name: 'Anti-rabies', givenDate: DateTime(2025, 10, 22)),
      ]);
      expect(s.items.firstWhere((i) => i.template.key == 'rabies_booster').status, DoseStatus.dueSoon);
    });

    test('an adult with no history asks for a catch-up plan, not fake overdues', () {
      final s = buildSchedule(species: Species.cat, birthday: DateTime(2020, 1, 1), records: const [], now: now);
      expect(s.needsCatchUp, isTrue);
      expect(s.items.where((i) => i.status == DoseStatus.overdue), isEmpty);
    });

    test('cats get FVRCP every 3 years', () {
      final s = buildSchedule(species: Species.cat, birthday: DateTime(2021, 1, 1), now: now, records: [
        VaccineRecord(id: 'x', key: 'fvrcp_booster', name: 'FVRCP', givenDate: DateTime(2024, 12, 1)),
      ]);
      expect(s.items.firstWhere((i) => i.template.key == 'fvrcp_booster').due, DateTime(2027, 12, 1));
    });

    test('rabbits and birds have no routine vaccines', () {
      expect(buildSchedule(species: Species.rabbit, birthday: null, records: const [], now: now).items, isEmpty);
    });

    test('deworming: 2 weeks, then monthly, then every 3 months', () {
      final b = DateTime(2026, 8, 1);
      expect(dewormInterval(b, DateTime(2026, 9, 1)).inDays, 14);
      expect(dewormInterval(b, DateTime(2026, 11, 20)).inDays, 30);
      expect(dewormInterval(b, DateTime(2027, 3, 1)).inDays, 90);
    });
  });

  group('medicines', () {
    final start = DateTime(2026, 10, 1);
    test('twice daily', () {
      final p = MedicinePlan(frequency: 'twice', times: const ['08:00', '20:00'], start: start);
      expect(dosesOn(p, now).map((d) => d.hour), [8, 20]);
      expect(nextDose(p, now), DateTime(2026, 10, 14, 20));
    });
    test('every 8 hours', () {
      final p = MedicinePlan(frequency: 'every_x_hours', everyHours: 8, times: const ['06:00'], start: start);
      expect(dosesOn(p, now).map((d) => d.hour), [6, 14, 22]);
    });
    test('weekly and end dates', () {
      final p = MedicinePlan(frequency: 'weekly', times: const ['09:00'], start: start, end: DateTime(2026, 10, 20));
      expect(dosesOn(p, DateTime(2026, 10, 8)), hasLength(1));
      expect(dosesOn(p, DateTime(2026, 10, 9)), isEmpty);
      expect(dosesOn(p, DateTime(2026, 10, 22)), isEmpty);
    });
    test('stock days', () {
      final p = MedicinePlan(frequency: 'twice', times: const ['08:00', '20:00'], start: start);
      expect(stockDays(10, p, now), 5);
    });
  });
}
