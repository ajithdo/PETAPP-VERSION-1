import 'package:flutter_test/flutter_test.dart';
import 'package:pawsetu/core/demo/demo_store.dart';
import 'package:pawsetu/core/demo/seed/seed.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  test('after a reset the next start has fresh demo data and the demo accounts', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final store = await DemoStore.open(prefs);
    await store.db.collection('users').doc('u_priya').update({'name': 'Changed'});
    await store.db.collection('pets').doc('pet_mine').set({'ownerId': 'u_priya', 'name': 'New'});
    await prefs.setString('demo_db_v1', store.db.dump());
    await store.reset();
    await store.save(); // saving stops once a reset starts
    final fresh = await DemoStore.open(prefs);
    expect((await fresh.db.collection('users').doc('u_priya').get()).data()!['name'], 'Priya Sharma');
    expect((await fresh.db.collection('pets').doc('pet_mine').get()).exists, isFalse);
    expect((await fresh.db.collection('demoAccounts').doc('u_priya').get()).exists, isTrue);
    fresh.dispose();
  });

  test('saved data without the demo accounts is not used', () {
    final now = DateTime(2026, 10, 15);
    final data = DemoSeed.build(now);
    expect(DemoStore.hasDemoAccounts(data), isTrue);
    data['users']!.remove('u_priya');
    expect(DemoStore.hasDemoAccounts(data), isFalse);
    expect(DemoStore.hasDemoAccounts({}), isFalse);
  });
}
