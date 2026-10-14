import 'package:flutter_test/flutter_test.dart';
import 'package:pawsetu/features/pets/domain/breeds.dart';
import 'package:pawsetu/features/routine/domain/routine.dart';

void main() {
  test('suggested goals fit species, size and age', () {
    final lab = suggestedGoals(species: Species.dog, size: BreedSize.large);
    expect(lab.walks, 2);
    expect(lab.walkMinutes, 60);
    final puppy = suggestedGoals(species: Species.dog, lifeStage: 'young');
    expect(puppy.meals, 3);
    expect(puppy.walks, 3);
    final seniorCat = suggestedGoals(species: Species.cat, lifeStage: 'senior');
    expect(seniorCat.walks, 0);
    expect(seniorCat.playMinutes, 10);
  });

  test('streak counts back from today (or yesterday)', () {
    final today = DateTime(2026, 10, 14, 9);
    final logs = [
      DateTime(2026, 10, 13, 8),
      DateTime(2026, 10, 12, 19),
      DateTime(2026, 10, 11, 7),
      DateTime(2026, 10, 9, 7),
    ];
    expect(streak(logs, today), 3);
    expect(streak([...logs, DateTime(2026, 10, 14, 7)], today), 4);
    expect(streak(const [], today), 0);
  });

  test('flat-faced breeds get warned earlier', () {
    expect(heatLevel(30), HeatLevel.warm);
    expect(heatLevel(30, flatFaced: true), HeatLevel.hot);
    expect(heatLevel(35, flatFaced: true), HeatLevel.danger);
    expect(heatLevel(25), HeatLevel.ok);
  });

  test('demo temperature peaks in the afternoon', () {
    final morning = demoTemperature('Hyderabad', DateTime(2026, 10, 14, 6));
    final afternoon = demoTemperature('Hyderabad', DateTime(2026, 10, 14, 15));
    expect(afternoon, greaterThan(morning));
  });

  test('route distance and pace', () {
    final route = demoLoopRoute(17.41, 78.45, seed: 1, km: 2);
    final km = routeKm(route);
    expect(km, inInclusiveRange(1.5, 3.0));
    expect(paceMinPerKm(2, const Duration(minutes: 24)), 12);
    expect(paceMinPerKm(0.01, const Duration(minutes: 1)), isNull);
  });
}
