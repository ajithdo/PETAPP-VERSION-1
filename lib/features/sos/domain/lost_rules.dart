/// Lost pet mode and QR tags (spec 7.14): the public pet page, nearby
/// alerts and the finder's message relay.
///
/// Pure Dart: shared by the app and the unit tests. functions/src/phase9.ts
/// mirrors publicPetView, nearbyAlertUids and relayAllowed.
library;

import 'dart:math' as math;

import '../../routine/domain/routine.dart' show distanceKm;

/// Opt-in alerts reach PawSetu users within this distance (spec 7.14).
const lostAlertRadiusKm = 5.0;

/// A finder can send this many messages per tag in an hour.
const relayPerHour = 5;

/// Web address printed on the QR tag and the poster.
String lostPageUrl(String token, {String? webBase}) {
  final base = webBase ?? 'https://pawsetu.app/';
  return '$base#/lost/$token';
}

const _tokenChars = 'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz23456789';

/// A hard-to-guess tag id (about 95 bits). Tags are public, so they must
/// not be guessable from the pet's id.
String newQrToken([math.Random? random]) {
  final r = random ?? math.Random.secure();
  return List.generate(16, (_) => _tokenChars[r.nextInt(_tokenChars.length)]).join();
}

class Sighting {
  const Sighting({required this.at, this.lat, this.lng, this.area = '', this.note = '', this.name = ''});
  final DateTime at;
  final double? lat;
  final double? lng;
  final String area;
  final String note;

  /// The finder's name, if they gave one.
  final String name;

  Map<String, dynamic> toMap() => {'at': at, 'lat': lat, 'lng': lng, 'area': area, 'note': note, 'name': name};

  static Sighting fromMap(Map m, DateTime Function(Object?) date) => Sighting(
        at: date(m['at']),
        lat: (m['lat'] as num?)?.toDouble(),
        lng: (m['lng'] as num?)?.toDouble(),
        area: (m['area'] as String?) ?? '',
        note: (m['note'] as String?) ?? '',
        name: (m['name'] as String?) ?? '',
      );
}

/// What anyone who scans the tag may see: never the family's phone,
/// address, medical details or who the family members are.
Map<String, dynamic> publicPetView(Map<String, dynamic> pet) {
  final lost = pet['lost'];
  return {
    'name': pet['name'],
    'species': pet['species'],
    'breedId': pet['breedId'],
    'breedOther': pet['breedOther'],
    'colorTag': pet['colorTag'],
    'photoUrl': pet['photoUrl'],
    'markings': pet['markings'],
    'gender': pet['gender'],
    'lost': lost is Map
        ? {'since': lost['since'], 'area': lost['area'], 'note': lost['note'], 'lat': lost['lat'], 'lng': lost['lng']}
        : null,
  };
}

typedef AlertCandidate = ({String uid, double? lat, double? lng, bool optIn});

/// People who turned on lost-pet alerts and live within [km] of where the
/// pet was last seen. The pet's own family is left out (they already know).
List<String> nearbyAlertUids(Iterable<AlertCandidate> users, {required double lat, required double lng, double km = lostAlertRadiusKm, Set<String> except = const {}}) => [
      for (final u in users)
        if (u.optIn && u.lat != null && u.lng != null && !except.contains(u.uid) && distanceKm(lat, lng, u.lat!, u.lng!) <= km) u.uid,
    ];

/// Messages a finder may still send: at most [relayPerHour] per tag per hour.
bool relayAllowed(Iterable<DateTime> recent, DateTime now) =>
    recent.where((t) => now.difference(t) < const Duration(hours: 1)).length < relayPerHour;
