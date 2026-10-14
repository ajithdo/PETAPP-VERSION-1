import '../../../features/routine/domain/routine.dart';
import 'seed.dart';
import 'seed_places.dart';

/// 30 days of routine logs per pet (spec 12), including GPS walk routes,
/// plus 90 days of weight history.
class _PetSeed {
  const _PetSeed(this.id, this.owner, this.ownerName, this.area, this.kind,
      {this.walkKm = 2.0, this.helper, this.helperName, this.weights = const []});
  final String id;
  final String owner;
  final String ownerName;
  final String area;
  final String kind; // dog, puppy, senior_dog, cat, bird, rabbit
  final double walkKm;
  final String? helper;
  final String? helperName;
  final List<double> weights; // oldest to newest, spread over 90 days
}

const _pets = [
  _PetSeed('pet_bruno', 'u_priya', 'Priya Sharma', 'indiranagar', 'dog',
      walkKm: 3.0, helper: 'u_rohan', helperName: 'Rohan Sharma', weights: [28.2, 28.5, 28.4, 28.8, 29.1, 29.0]),
  _PetSeed('pet_misty', 'u_priya', 'Priya Sharma', 'indiranagar', 'cat',
      helper: 'u_rohan', helperName: 'Rohan Sharma', weights: [4.3, 4.3, 4.2, 4.2, 4.2]),
  _PetSeed('pet_simba', 'u_ravi', 'Ravi Teja', 'banjara', 'puppy', walkKm: 1.2, weights: [5.2, 5.9, 6.6, 7.3, 7.9, 8.5]),
  _PetSeed('pet_kiwi', 'u_ravi', 'Ravi Teja', 'banjara', 'bird', weights: [0.088, 0.09, 0.091, 0.09]),
  _PetSeed('pet_coco', 'u_anjali', 'Anjali Verma', 'saket', 'rabbit', weights: [1.7, 1.75, 1.8, 1.8]),
  _PetSeed('pet_tiger', 'u_anjali', 'Anjali Verma', 'saket', 'cat', weights: [5.2, 5.1, 5.0, 4.9, 4.8]),
  _PetSeed('pet_max', 'u_arjun', 'Arjun Mehta', 'bandra', 'senior_dog',
      walkKm: 1.6, helper: 'u_meera', helperName: 'Meera Pillai', weights: [35.0, 34.8, 34.5, 34.2, 34.0]),
  _PetSeed('pet_luna', 'u_arjun', 'Arjun Mehta', 'bandra', 'puppy',
      walkKm: 1.0, helper: 'u_meera', helperName: 'Meera Pillai', weights: [3.4, 3.9, 4.5, 5.0, 5.5]),
];

void seedRoutine(Add add, DateTime now) {
  var n = 0;
  void log(String petId, String type, DateTime at, String by, String byName,
      {Map<String, dynamic>? data, String? note}) {
    if (at.isAfter(now)) return;
    add('logs', 'log_${n++}', {
      'petId': petId,
      'type': type,
      'at': at,
      'byUid': by,
      'byName': byName,
      if (note != null) 'note': note,
      if (data != null) 'data': data,
    });
  }

  for (final p in _pets) {
    final r = SeedRandom(p.id.hashCode & 0xffff);
    final home = areas[p.area]!;
    for (var d = 29; d >= 0; d--) {
      final day = DateTime(now.year, now.month, now.day - d);
      DateTime at(int h, int m) => DateTime(day.year, day.month, day.day, h, m + r.next(25));
      (String, String) who() => p.helper != null && r.chance(0.3) ? (p.helper!, p.helperName!) : (p.owner, p.ownerName);
      final isDog = p.kind == 'dog' || p.kind == 'puppy' || p.kind == 'senior_dog';

      if (isDog) {
        final walkTimes = p.kind == 'puppy' ? [(7, 0), (13, 0), (18, 30)] : [(6, 40), (18, 50)];
        for (final (i, t) in walkTimes.indexed) {
          // Skip an occasional walk so the charts look real.
          if (r.chance(0.08)) continue;
          final km = p.walkKm * (0.7 + 0.6 * r.nextDouble());
          final route = demoLoopRoute(home.lat, home.lng, seed: n + i, km: km, points: 24);
          final realKm = routeKm(route);
          final minutes = (realKm * (13 + r.next(5))).round();
          final (uid, name) = who();
          log(p.id, 'walk', at(t.$1, t.$2), uid, name, data: {
            'distanceKm': double.parse(realKm.toStringAsFixed(2)),
            'durationMin': minutes,
            'route': [for (final pt in route) {'lat': double.parse(pt.lat.toStringAsFixed(5)), 'lng': double.parse(pt.lng.toStringAsFixed(5))}],
            'source': 'gps',
          });
        }
        log(p.id, 'potty', at(7, 10), p.owner, p.ownerName);
      }

      final meals = switch (p.kind) { 'puppy' => [(8, 0), (13, 30), (19, 30)], 'cat' => [(8, 0), (14, 0), (20, 0)], _ => [(8, 15), (19, 45)] };
      for (final t in meals) {
        final (uid, name) = who();
        log(p.id, 'meal', at(t.$1, t.$2), uid, name, data: {
          'grams': switch (p.kind) { 'dog' => 220, 'senior_dog' => 230, 'puppy' => 80, 'cat' => 40, 'rabbit' => 60, _ => 15 },
        });
      }
      log(p.id, 'water', at(12, 0), p.owner, p.ownerName);

      final playMin = switch (p.kind) { 'rabbit' => 90, 'bird' => 45, 'puppy' => 35, 'senior_dog' => 10, 'cat' => 15, _ => 25 };
      if (!r.chance(0.15)) {
        log(p.id, 'play', at(17, 0), p.owner, p.ownerName, data: {'minutes': (playMin * (0.6 + 0.8 * r.nextDouble())).round()});
      }
      log(p.id, 'mood', at(21, 0), p.owner, p.ownerName, data: {
        'mood': p.kind == 'senior_dog' && r.chance(0.3) ? 'tired' : moods[r.next(3)],
      });

      if (d % 7 == 3) {
        final tags = switch (p.kind) {
          'dog' => {'leash_pulling': 1 + (d < 14 ? 0 : 1), 'playful': 3},
          'puppy' => {'chewing': 2, 'playful': 3, 'jumping_on_people': 2},
          'senior_dog' => {'calm': 3},
          'cat' => {'calm': 2, 'scratching_furniture': 1},
          'rabbit' => {'hiding': 1, 'calm': 2},
          _ => {'playful': 2},
        };
        log(p.id, 'behaviour', at(20, 0), p.owner, p.ownerName, data: {'tags': tags});
      }
      if (d % 10 == 4 && (p.kind == 'dog' || p.kind == 'cat')) {
        log(p.id, 'grooming', at(11, 0), p.owner, p.ownerName, note: 'Brushing');
      }
      if (p.kind == 'puppy' && d % 3 == 0) {
        log(p.id, 'training', at(16, 0), p.owner, p.ownerName, data: {'minutes': 15}, note: 'Sit and stay');
      }
    }
    // Weight history over the last 90 days.
    for (var i = 0; i < p.weights.length; i++) {
      final daysAgo = 90 - (90 * i ~/ (p.weights.length - 1).clamp(1, 99));
      log(p.id, 'weight', DateTime(now.year, now.month, now.day - daysAgo, 10), p.owner, p.ownerName,
          data: {'weightKg': p.weights[i]});
    }
  }
}
