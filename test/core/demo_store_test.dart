import 'package:flutter_test/flutter_test.dart';
import 'package:pawsetu/core/demo/demo_store.dart';
import 'package:pawsetu/core/demo/seed/seed.dart';

void main() {
  test('start-up loads recent data first and the long history right after', () {
    final now = DateTime(2026, 10, 15, 9);
    final data = DemoSeed.build(now);
    final (first, later) = DemoStore.splitForStartup(data, now);
    int count(SeedData d) => d.values.fold(0, (n, c) => n + c.length);

    // Nothing is lost or loaded twice.
    expect(count(first) + count(later), count(data));
    for (final c in later.entries) {
      for (final id in c.value.keys) {
        expect(first[c.key]?.containsKey(id) ?? false, isFalse, reason: '${c.key}/$id');
      }
    }
    // Today's routine, pets and people come first; old logs and admin
    // history follow.
    final cutoff = now.subtract(const Duration(days: 2));
    expect(first['logs']!.values.every((l) => !(l['at'] as DateTime).isBefore(cutoff)), isTrue);
    expect(later['logs']!.values.every((l) => (l['at'] as DateTime).isBefore(cutoff)), isTrue);
    expect(first.keys, containsAll(['users', 'pets', 'vaccinations', 'config']));
    expect(later.keys, containsAll(['analyticsDaily', 'logs']));
    expect(first.containsKey('analyticsDaily'), isFalse);
    // Most of the records wait, so the first screen appears sooner.
    expect(count(later), greaterThan(count(first)));
  });
}
