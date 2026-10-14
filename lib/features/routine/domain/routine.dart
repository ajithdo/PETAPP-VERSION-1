/// Daily routine rules (spec 7.3). Pure Dart so it is unit tested and also
/// usable by the seed tool.
library;

import 'dart:math' as math;

import '../../pets/domain/breeds.dart';

/// Every kind of routine log.
enum LogType { walk, play, meal, water, potty, sleep, grooming, training, mood, weight, behaviour }

LogType parseLogType(String? s) => LogType.values.firstWhere((t) => t.name == s, orElse: () => LogType.meal);

/// Mood choices for the mood log.
const moods = ['happy', 'calm', 'playful', 'tired', 'anxious', 'unwell'];

/// Behaviour and trait tags (intensity 1 = mild, 2 = moderate, 3 = strong).
const behaviourTags = [
  'playful',
  'calm',
  'anxious',
  'leash_pulling',
  'barking',
  'aggression_dogs',
  'separation_anxiety',
  'scratching_furniture',
  'chewing',
  'jumping_on_people',
  'hiding',
  'not_eating_well',
];

/// Suggested daily goals by species, size and age.
class Goals {
  const Goals({required this.walks, required this.walkMinutes, required this.meals, required this.playMinutes});
  final int walks;
  final int walkMinutes;
  final int meals;
  final int playMinutes;
}

Goals suggestedGoals({required Species species, BreedSize size = BreedSize.medium, String lifeStage = 'adult'}) {
  switch (species) {
    case Species.dog:
      final young = lifeStage == 'young';
      final senior = lifeStage == 'senior';
      final walkMin = switch (size) {
        BreedSize.small => 30,
        BreedSize.medium => 45,
        BreedSize.large => 60,
        BreedSize.giant => 45,
      };
      return Goals(
        walks: young ? 3 : 2,
        walkMinutes: senior ? (walkMin * 0.6).round() : (young ? 30 : walkMin),
        meals: young ? 3 : 2,
        playMinutes: senior ? 15 : (young ? 40 : 30),
      );
    case Species.cat:
      return Goals(walks: 0, walkMinutes: 0, meals: lifeStage == 'young' ? 4 : 3, playMinutes: lifeStage == 'senior' ? 10 : 20);
    case Species.bird:
      return const Goals(walks: 0, walkMinutes: 0, meals: 2, playMinutes: 60);
    case Species.rabbit:
      return const Goals(walks: 0, walkMinutes: 0, meals: 2, playMinutes: 120);
  }
}

/// Number of consecutive days, ending today (or yesterday if today has no
/// log yet), that have at least one log.
int streak(Iterable<DateTime> logTimes, DateTime today) {
  final days = logTimes.map((d) => DateTime(d.year, d.month, d.day)).toSet();
  var day = DateTime(today.year, today.month, today.day);
  if (!days.contains(day)) day = day.subtract(const Duration(days: 1));
  var n = 0;
  while (days.contains(day)) {
    n++;
    day = DateTime(day.year, day.month, day.day - 1);
  }
  return n;
}

/// Walk-weather advice. Indian summers are dangerous for flat-faced breeds.
enum HeatLevel { ok, warm, hot, danger }

HeatLevel heatLevel(double tempC, {bool flatFaced = false}) {
  final t = flatFaced ? tempC + 4 : tempC;
  if (t >= 38) return HeatLevel.danger;
  if (t >= 33) return HeatLevel.hot;
  if (t >= 29) return HeatLevel.warm;
  return HeatLevel.ok;
}

/// Demo temperatures by city and hour, shaped like an October day in India.
double demoTemperature(String? city, DateTime at) {
  final base = switch (city) {
    'Hyderabad' => 31.0,
    'Bengaluru' => 27.0,
    'Mumbai' => 32.0,
    'Chennai' => 33.0,
    'Pune' => 30.0,
    'Delhi NCR' => 33.0,
    _ => 31.0,
  };
  // Coolest at 5 am, hottest at 3 pm.
  final h = at.hour + at.minute / 60;
  final swing = math.cos((h - 15) / 24 * 2 * math.pi);
  return double.parse((base + 4 * swing).toStringAsFixed(1));
}

/// Haversine distance in km between two points.
double distanceKm(double lat1, double lng1, double lat2, double lng2) {
  const r = 6371.0;
  double rad(double d) => d * math.pi / 180;
  final dLat = rad(lat2 - lat1);
  final dLng = rad(lng2 - lng1);
  final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(rad(lat1)) * math.cos(rad(lat2)) * math.sin(dLng / 2) * math.sin(dLng / 2);
  return 2 * r * math.asin(math.sqrt(a));
}

double routeKm(List<({double lat, double lng})> pts) {
  var d = 0.0;
  for (var i = 1; i < pts.length; i++) {
    d += distanceKm(pts[i - 1].lat, pts[i - 1].lng, pts[i].lat, pts[i].lng);
  }
  return d;
}

/// Minutes per km, or null when too short to say.
double? paceMinPerKm(double km, Duration d) => km < 0.05 ? null : d.inSeconds / 60 / km;

/// Generates a pleasant loop walk around a point (demo GPS and seed data).
List<({double lat, double lng})> demoLoopRoute(double lat, double lng, {required int seed, double km = 2.0, int points = 40}) {
  final rnd = math.Random(seed);
  // Radius in degrees for a loop of roughly [km].
  final radiusKm = km / (2 * math.pi);
  final dLat = radiusKm / 111.0;
  final dLng = radiusKm / (111.0 * math.cos(lat * math.pi / 180));
  final start = rnd.nextDouble() * 2 * math.pi;
  return [
    for (var i = 0; i <= points; i++)
      (
        lat: lat + dLat * math.sin(start + i / points * 2 * math.pi) * (0.85 + 0.3 * rnd.nextDouble()) - dLat * math.sin(start),
        lng: lng + dLng * math.cos(start + i / points * 2 * math.pi) * (0.85 + 0.3 * rnd.nextDouble()) - dLng * math.cos(start),
      ),
  ];
}
