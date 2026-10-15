/// Emergency SOS (spec 7.12): which clinics to show first, which location to
/// use, and the small saved list of clinics that keeps SOS working on weak
/// internet.
///
/// Pure Dart: shared by the app and the unit tests.
library;

import 'dart:convert';

import '../../booking/domain/booking_rules.dart' show isOpenNow;
import '../../routine/domain/routine.dart' show distanceKm;

/// How long a remembered location is still good enough for SOS.
const lastKnownMaxAge = Duration(hours: 6);

/// How many clinics are saved on the device for weak internet.
const savedClinicsCount = 20;

/// Where the SOS location came from (stored in sosLogs.source).
enum SosSource { gps, lastKnown, chosen }

String sosSourceId(SosSource s) => switch (s) {
      SosSource.gps => 'gps',
      SosSource.lastKnown => 'last_known',
      SosSource.chosen => 'chosen',
    };

class SosSpot {
  const SosSpot({required this.lat, required this.lng, required this.source, this.label = '', this.at});
  final double lat;
  final double lng;
  final SosSource source;

  /// Area name for a chosen area ("Indiranagar"); empty for GPS fixes.
  final String label;

  /// When the fix was taken (GPS and last known).
  final DateTime? at;
}

/// GPS first; then a location remembered in the last [lastKnownMaxAge];
/// then the area the person chose (or their home area).
SosSpot pickSosSpot({SosSpot? gps, SosSpot? lastKnown, required SosSpot chosen, required DateTime now}) {
  if (gps != null) return gps;
  final at = lastKnown?.at;
  if (lastKnown != null && at != null && now.difference(at) <= lastKnownMaxAge) return lastKnown;
  return chosen;
}

/// A clinic as SOS needs it. Small enough to save on the device.
class SosClinic {
  const SosClinic({
    required this.id,
    required this.name,
    required this.address,
    required this.area,
    required this.city,
    required this.lat,
    required this.lng,
    required this.phone,
    this.emergencyPhone,
    required this.is24x7,
    required this.hours,
  });

  final String id;
  final String name;
  final String address;
  final String area;
  final String city;
  final double lat;
  final double lng;
  final String phone;
  final String? emergencyPhone;
  final bool is24x7;
  final Map<String, dynamic> hours;

  /// The emergency line when the clinic has one.
  String get callNumber => (emergencyPhone == null || emergencyPhone!.isEmpty) ? phone : emergencyPhone!;

  String get fullAddress => [address, area, city].where((s) => s.trim().isNotEmpty).join(', ');

  bool openAt(DateTime now) => is24x7 || isOpenNow(hours, now);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'address': address,
        'area': area,
        'city': city,
        'lat': lat,
        'lng': lng,
        'phone': phone,
        'emergencyPhone': emergencyPhone,
        'is24x7': is24x7,
        'hours': hours,
      };

  factory SosClinic.fromJson(Map<String, dynamic> j) => SosClinic(
        id: j['id'] as String,
        name: (j['name'] as String?) ?? '',
        address: (j['address'] as String?) ?? '',
        area: (j['area'] as String?) ?? '',
        city: (j['city'] as String?) ?? '',
        lat: (j['lat'] as num).toDouble(),
        lng: (j['lng'] as num).toDouble(),
        phone: (j['phone'] as String?) ?? '',
        emergencyPhone: j['emergencyPhone'] as String?,
        is24x7: (j['is24x7'] as bool?) ?? false,
        hours: ((j['hours'] as Map?) ?? const {}).cast<String, dynamic>(),
      );
}

typedef RankedClinic = ({SosClinic clinic, double km, bool open});

/// Open-now and 24x7 clinics first, each group nearest first (spec 7.12).
List<RankedClinic> rankSosClinics(Iterable<SosClinic> clinics, {required double lat, required double lng, required DateTime now}) {
  final list = [
    for (final c in clinics) (clinic: c, km: distanceKm(lat, lng, c.lat, c.lng), open: c.openAt(now)),
  ];
  list.sort((a, b) {
    if (a.open != b.open) return a.open ? -1 : 1;
    return a.km.compareTo(b.km);
  });
  return list;
}

/// The clinics worth saving for weak internet: the nearest [savedClinicsCount].
List<SosClinic> clinicsToSave(Iterable<SosClinic> clinics, {required double lat, required double lng}) {
  final list = clinics.toList()..sort((a, b) => distanceKm(lat, lng, a.lat, a.lng).compareTo(distanceKm(lat, lng, b.lat, b.lng)));
  return list.take(savedClinicsCount).toList();
}

String encodeSavedClinics(List<SosClinic> clinics, DateTime at) =>
    jsonEncode({'at': at.toIso8601String(), 'clinics': [for (final c in clinics) c.toJson()]});

({List<SosClinic> clinics, DateTime at})? decodeSavedClinics(String? raw) {
  if (raw == null || raw.isEmpty) return null;
  try {
    final j = jsonDecode(raw) as Map<String, dynamic>;
    return (
      clinics: [for (final c in (j['clinics'] as List)) SosClinic.fromJson((c as Map).cast<String, dynamic>())],
      at: DateTime.parse(j['at'] as String),
    );
  } catch (_) {
    return null;
  }
}

String encodeSpot(SosSpot s) => jsonEncode({'lat': s.lat, 'lng': s.lng, 'at': s.at?.toIso8601String()});

SosSpot? decodeSpot(String? raw) {
  if (raw == null || raw.isEmpty) return null;
  try {
    final j = jsonDecode(raw) as Map<String, dynamic>;
    return SosSpot(
      lat: (j['lat'] as num).toDouble(),
      lng: (j['lng'] as num).toDouble(),
      source: SosSource.lastKnown,
      at: j['at'] == null ? null : DateTime.parse(j['at'] as String),
    );
  } catch (_) {
    return null;
  }
}
