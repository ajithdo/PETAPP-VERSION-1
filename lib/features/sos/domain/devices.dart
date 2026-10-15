/// Connected devices (spec 7.13): device records, safe zones and the demo
/// readings that make Version 1 feel alive. Real vendors plug in behind
/// DeviceProvider (lib/features/sos/data/device_provider.dart).
///
/// Pure Dart: shared by the app and the unit tests.
library;

import 'dart:math' as math;

import '../../routine/domain/routine.dart' show distanceKm;

enum DeviceType { gpsCollar, activityTracker, feeder, fountain, camera, litterBox }

const deviceTypeIds = <DeviceType, String>{
  DeviceType.gpsCollar: 'gps_collar',
  DeviceType.activityTracker: 'activity_tracker',
  DeviceType.feeder: 'feeder',
  DeviceType.fountain: 'fountain',
  DeviceType.camera: 'camera',
  DeviceType.litterBox: 'litter_box',
};

DeviceType? deviceTypeFrom(String? id) {
  for (final e in deviceTypeIds.entries) {
    if (e.value == id) return e.key;
  }
  return null;
}

/// Which pets a device type suits (litter boxes are for cats and rabbits).
bool deviceSuits(DeviceType t, String species) => switch (t) {
      DeviceType.gpsCollar || DeviceType.activityTracker => species == 'dog' || species == 'cat',
      DeviceType.litterBox => species == 'cat' || species == 'rabbit',
      _ => true,
    };

class SafeZone {
  const SafeZone({required this.lat, required this.lng, required this.radiusM});
  final double lat;
  final double lng;
  final int radiusM;

  Map<String, dynamic> toMap() => {'lat': lat, 'lng': lng, 'radiusM': radiusM};

  static SafeZone? fromMap(Object? m) {
    if (m is! Map) return null;
    final lat = m['lat'], lng = m['lng'], r = m['radiusM'];
    if (lat is! num || lng is! num || r is! num) return null;
    return SafeZone(lat: lat.toDouble(), lng: lng.toDouble(), radiusM: r.toInt());
  }
}

class Device {
  Device(this.id, this.raw);
  final String id;
  final Map<String, dynamic> raw;

  String get ownerId => (raw['ownerId'] as String?) ?? '';
  String get petId => (raw['petId'] as String?) ?? '';
  DeviceType get type => deviceTypeFrom(raw['type'] as String?) ?? DeviceType.activityTracker;
  String get name => (raw['name'] as String?) ?? '';
  String get vendor => (raw['vendor'] as String?) ?? '';
  String get serial => (raw['serial'] as String?) ?? '';
  String get status => (raw['status'] as String?) ?? 'connected';
  int get battery => (raw['battery'] as num?)?.toInt() ?? 100;
  Map<String, dynamic> get data => ((raw['data'] as Map?) ?? const {}).cast<String, dynamic>();
  SafeZone? get safeZone => SafeZone.fromMap(raw['safeZone']);

  /// Last safe-zone state we alerted on: true inside, false outside.
  bool? get lastInside => data['inside'] as bool?;
}

double distanceMeters(double lat1, double lng1, double lat2, double lng2) => distanceKm(lat1, lng1, lat2, lng2) * 1000;

bool insideZone(double lat, double lng, SafeZone z) => distanceMeters(lat, lng, z.lat, z.lng) <= z.radiusM;

/// The safe-zone alert fires once, when the collar goes from inside (or
/// unknown) to outside. Coming back inside clears it.
bool shouldAlertLeftZone({required bool? wasInside, required bool isInside}) => !isInside && wasInside != false;

// ---------------------------------------------------------------------------
// Demo readings. Deterministic from the device id and the clock, so every
// screen (and every family member) sees the same numbers.
// ---------------------------------------------------------------------------

int _seed(String id) => id.codeUnits.fold(7, (a, c) => (a * 31 + c) & 0x7fffffff);

/// Smallest safe zone the app allows, and the largest.
const minZoneM = 100, maxZoneM = 2000;

class CollarFix {
  const CollarFix({required this.lat, required this.lng, required this.metersFromHome, required this.inside, required this.at});
  final double lat;
  final double lng;
  final double metersFromHome;
  final bool inside;
  final DateTime at;
}

/// Where the demo collar is: wandering slowly well inside the safe zone, or,
/// after [walkOutAt] (the "walk out of the safe zone" demo button), heading
/// out to about 1.6× the zone radius over 20 seconds and staying there.
CollarFix demoCollarFix(Device d, DateTime now, {DateTime? walkOutAt}) {
  final z = d.safeZone ?? const SafeZone(lat: 12.9784, lng: 77.6408, radiusM: 300);
  final s = _seed(d.id);
  final minutes = now.millisecondsSinceEpoch / 60000.0;
  final angle = (s % 360) * math.pi / 180 + minutes / 7;
  var dist = z.radiusM * (0.25 + 0.15 * math.sin(minutes / 3 + s));
  if (walkOutAt != null && !now.isBefore(walkOutAt)) {
    final t = (now.difference(walkOutAt).inMilliseconds / 20000).clamp(0.0, 1.0);
    dist = dist + (z.radiusM * 1.6 - dist) * t;
  }
  // Metres to degrees (small distances): 1° latitude ≈ 111.32 km.
  final dLat = dist * math.cos(angle) / 111320;
  final dLng = dist * math.sin(angle) / (111320 * math.cos(z.lat * math.pi / 180));
  final lat = z.lat + dLat, lng = z.lng + dLng;
  final m = distanceMeters(lat, lng, z.lat, z.lng);
  return CollarFix(lat: lat, lng: lng, metersFromHome: m, inside: m <= z.radiusM, at: now);
}

/// One stretch of activity the device noticed, written to the routine
/// tracker as a walk or play log.
class ActivitySession {
  const ActivitySession({required this.id, required this.start, required this.minutes, required this.km, required this.kind, required this.steps});
  final String id;
  final DateTime start;
  final int minutes;
  final double km;

  /// walk or play
  final String kind;
  final int steps;
}

class ActivityDay {
  const ActivityDay({required this.steps, required this.activeMinutes, required this.goalMinutes, required this.sessions});
  final int steps;
  final int activeMinutes;
  final int goalMinutes;
  final List<ActivitySession> sessions;
}

/// A demo day for a tracker or collar: a morning walk, an evening walk and a
/// play session, counted only once they have happened.
ActivityDay demoActivity(Device d, DateTime day, DateTime now, {int goalMinutes = 60}) {
  final s = _seed(d.id) + day.year * 400 + day.month * 32 + day.day;
  final r = math.Random(s);
  final date = DateTime(day.year, day.month, day.day);
  final plan = <(int hour, int minute, int minutes, String kind)>[
    (6 + r.nextInt(2), 10 + r.nextInt(40), 25 + r.nextInt(15), 'walk'),
    (13, 30 + r.nextInt(20), 10 + r.nextInt(10), 'play'),
    (18 + r.nextInt(2), 5 + r.nextInt(40), 20 + r.nextInt(15), 'walk'),
  ];
  final sessions = <ActivitySession>[];
  var i = 0;
  for (final p in plan) {
    final start = date.add(Duration(hours: p.$1, minutes: p.$2));
    i++;
    if (!start.add(Duration(minutes: p.$3)).isBefore(now)) continue;
    final km = p.$4 == 'walk' ? (p.$3 * (0.07 + r.nextDouble() * 0.02)) : 0.0;
    final steps = p.$4 == 'walk' ? (km * 1300).round() : p.$3 * 90;
    sessions.add(ActivitySession(
      id: 'dev_${d.id}_${date.year}${_two(date.month)}${_two(date.day)}_$i',
      start: start,
      minutes: p.$3,
      km: double.parse(km.toStringAsFixed(1)),
      kind: p.$4,
      steps: steps,
    ));
  }
  // Light pottering about between sessions.
  final dayDone = now.isAfter(date.add(const Duration(days: 1)))
      ? 1.0
      : (now.difference(date).inMinutes / 1440).clamp(0.0, 1.0);
  final background = (1800 * dayDone).round();
  return ActivityDay(
    steps: sessions.fold(background, (a, x) => a + x.steps),
    activeMinutes: sessions.fold(0, (a, x) => a + x.minutes),
    goalMinutes: goalMinutes,
    sessions: sessions,
  );
}

String _two(int n) => n.toString().padLeft(2, '0');

class FeederState {
  const FeederState({required this.meals, required this.next, required this.hopperPct});
  final List<({DateTime at, int grams})> meals;
  final DateTime? next;
  final int hopperPct;
}

/// Smart feeder: two meals a day from the pet's daily portion.
FeederState demoFeeder(Device d, DateTime now, {int dailyGrams = 120}) {
  final date = DateTime(now.year, now.month, now.day);
  final half = (dailyGrams / 2).round();
  final times = [date.add(const Duration(hours: 8)), date.add(const Duration(hours: 19))];
  final meals = [for (final t in times) if (!t.isAfter(now)) (at: t, grams: half)];
  final next = times.firstWhere((t) => t.isAfter(now), orElse: () => times.first.add(const Duration(days: 1)));
  final hopper = 100 - ((now.difference(DateTime(2026)).inDays + _seed(d.id)) % 9) * 8 - meals.length * 3;
  return FeederState(meals: meals, next: next, hopperPct: hopper.clamp(5, 100));
}

class FountainState {
  const FountainState({required this.waterPct, required this.filterDaysLeft});
  final int waterPct;
  final int filterDaysLeft;
  bool get refillSoon => waterPct < 25;
}

/// Water fountain: refilled at 7 am, drinks through the day.
FountainState demoFountain(Device d, DateTime now) {
  final refill = DateTime(now.year, now.month, now.day, 7);
  final since = now.isBefore(refill) ? now.difference(refill.subtract(const Duration(days: 1))) : now.difference(refill);
  final used = (since.inMinutes / 1440 * 85).round();
  return FountainState(waterPct: (100 - used).clamp(0, 100), filterDaysLeft: 30 - (now.day + _seed(d.id)) % 30);
}

class LitterState {
  const LitterState({required this.visitsToday, required this.lastVisit});
  final int visitsToday;
  final DateTime? lastVisit;
  bool get needsCleaning => visitsToday >= 4;
}

/// Litter box: a visit every few hours.
LitterState demoLitter(Device d, DateTime now) {
  final date = DateTime(now.year, now.month, now.day);
  final offset = _seed(d.id) % 90;
  final visits = [for (final h in const [2, 7, 12, 17, 22]) date.add(Duration(hours: h, minutes: offset))].where((t) => !t.isAfter(now)).toList();
  return LitterState(visitsToday: visits.length, lastVisit: visits.isEmpty ? null : visits.last);
}

/// Battery drains about 3% a day from pairing, then the demo "charges" it.
int demoBattery(Device d, DateTime now) {
  final paired = d.raw['pairedAt'];
  final at = paired is DateTime ? paired : now.subtract(const Duration(days: 5));
  final days = now.difference(at).inHours / 24;
  return (100 - (days * 3) % 80).round().clamp(5, 100);
}
