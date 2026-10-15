import 'seed.dart';
import 'seed_places.dart';

/// Phase 9: QR tags on every pet, Bruno's activity tracker and Max's GPS
/// collar (spec section 12) plus Misty's water fountain, SOS activations for
/// admin analytics, a past lost report (Luna, found two days later), and
/// demo neighbours who get lost-pet alerts near each owner's home.
/// Only that phase edits this file.
void seedSafety(Add add, DateTime now, SeedData data) {
  DateTime day(int ago, [int hour = 10, int minute = 0]) => DateTime(now.year, now.month, now.day - ago, hour, minute);

  // ---------- QR tags ----------
  // Hard-to-guess ids (no 0/O/1/l/I), fixed so printed demo tags keep working.
  const tokens = {
    'pet_bruno': 'Bq7KpX2mVn9RtLw4',
    'pet_misty': 'Ms3HgT8yQp2ZkWc6',
    'pet_simba': 'Sb5NvR9xLm3PqTy7',
    'pet_kiwi': 'Kw8YtE4hBn6VzQa2',
    'pet_coco': 'Cc2MwP7rJx5KsNd9',
    'pet_tiger': 'Tg6QbZ3vHk8WmRx4',
    'pet_max': 'Mx9LcV5tGp2YqHn7',
    'pet_luna': 'Ln4DsK8wFz6BxPr3',
    'pet_sheru': 'Sh7XmQ2nCv9TkLp5',
  };
  for (final e in tokens.entries) {
    data['pets']?[e.key]?['qrToken'] = e.value;
  }

  // ---------- home locations (for lost-pet alerts within 5 km) ----------
  const homes = {'Bengaluru': 'indiranagar', 'Hyderabad': 'banjara', 'Delhi NCR': 'saket', 'Mumbai': 'bandra'};
  for (final u in (data['users'] ?? const <String, Map<String, dynamic>>{}).values) {
    final a = areas[homes[u['city']]];
    if (a == null || u['role'] != 'owner') continue;
    u['homeLat'] = a.lat;
    u['homeLng'] = a.lng;
  }

  // Fictional neighbours who turned on lost-pet alerts (they can't sign in).
  const neighbours = <(String uid, String name, String city, String lang, double dLat, double dLng)>[
    ('u_nb_blr_1', 'Neha Kulkarni', 'Bengaluru', 'en', 0.008, 0.006),
    ('u_nb_blr_2', 'Arif Khan', 'Bengaluru', 'hi', -0.012, 0.010),
    ('u_nb_blr_3', 'Divya Reddy', 'Bengaluru', 'te', 0.018, -0.014),
    ('u_nb_hyd_1', 'Sravani Rao', 'Hyderabad', 'te', 0.010, -0.007),
    ('u_nb_hyd_2', 'Kiran Kumar', 'Hyderabad', 'te', -0.015, 0.012),
    ('u_nb_hyd_3', 'Farah Ali', 'Hyderabad', 'en', 0.006, 0.020),
    ('u_nb_del_1', 'Rahul Gupta', 'Delhi NCR', 'hi', 0.009, 0.011),
    ('u_nb_del_2', 'Simran Kaur', 'Delhi NCR', 'hi', -0.013, -0.006),
    ('u_nb_del_3', 'Aman Joshi', 'Delhi NCR', 'en', 0.020, 0.004),
    ('u_nb_mum_1', 'Sneha Patil', 'Mumbai', 'en', 0.007, 0.009),
    ('u_nb_mum_2', 'Yusuf Shaikh', 'Mumbai', 'hi', -0.011, 0.005),
    ('u_nb_mum_3', 'Pooja Nair', 'Mumbai', 'en', 0.016, -0.010),
  ];
  var phone = 31;
  for (final n in neighbours) {
    final home = areas[homes[n.$3]]!;
    add('users', n.$1, {
      'name': n.$2,
      'email': '${n.$1.substring(2)}@example.com',
      'phone': demoPhone(phone++),
      'role': 'owner',
      'plan': 'free',
      'language': n.$4,
      'city': n.$3,
      'easyMode': false,
      'onboarded': true,
      'demo': true,
      'neighbour': true,
      'homeLat': home.lat + n.$5,
      'homeLng': home.lng + n.$6,
      'createdAt': day(200),
      'addresses': <Map<String, dynamic>>[],
      'consents': {'marketing': false, 'analytics': true, 'lostPetAlerts': true},
    });
  }

  // ---------- connected devices ----------
  final bandra = areas['bandra']!;
  add('devices', 'dev_max_collar', {
    'ownerId': 'u_arjun',
    'petId': 'pet_max',
    'type': 'gps_collar',
    'name': "Max's GPS collar",
    'vendor': 'PawTrail Demo',
    'model': 'GPS Collar G2',
    'serial': 'DEMO-7316',
    'status': 'connected',
    'battery': 82,
    'safeZone': {'lat': bandra.lat, 'lng': bandra.lng, 'radiusM': 400},
    'data': {'inside': true, 'lat': bandra.lat + 0.0008, 'lng': bandra.lng + 0.0006, 'metersFromHome': 110, 'at': now.subtract(const Duration(minutes: 4))},
    'pairedAt': day(60),
    'pairedBy': 'u_arjun',
  });
  add('devices', 'dev_bruno_tracker', {
    'ownerId': 'u_priya',
    'petId': 'pet_bruno',
    'type': 'activity_tracker',
    'name': "Bruno's activity tag",
    'vendor': 'FitTail Demo',
    'model': 'Activity Tag A1',
    'serial': 'DEMO-4821',
    'status': 'connected',
    'battery': 76,
    'data': <String, dynamic>{},
    'pairedAt': day(40),
    'pairedBy': 'u_priya',
  });
  add('devices', 'dev_misty_fountain', {
    'ownerId': 'u_priya',
    'petId': 'pet_misty',
    'type': 'fountain',
    'name': "Misty's water fountain",
    'vendor': 'AquaPaw Demo',
    'model': 'Fountain 2L',
    'serial': 'DEMO-2290',
    'status': 'connected',
    'battery': 100,
    'data': <String, dynamic>{},
    'pairedAt': day(25),
    'pairedBy': 'u_rohan',
  });

  // ---------- SOS activations (admin analytics) ----------
  const sos = <(String uid, String? petId, int ago, int hour, String area, String source)>[
    ('u_priya', 'pet_bruno', 3, 21, 'Indiranagar', 'gps'),
    ('u_ravi', 'pet_simba', 6, 23, 'Banjara Hills', 'chosen'),
    ('u_arjun', 'pet_max', 9, 7, 'Bandra West', 'gps'),
    ('u_anjali', 'pet_tiger', 12, 18, 'Saket', 'last_known'),
    ('u_priya', 'pet_misty', 17, 14, 'Indiranagar', 'gps'),
    ('u_ravi', 'pet_kiwi', 21, 10, 'Banjara Hills', 'gps'),
    ('u_arjun', 'pet_luna', 25, 19, 'Bandra West', 'gps'),
    ('u_meera', 'pet_max', 31, 8, 'Bandra West', 'last_known'),
    ('u_anjali', 'pet_coco', 38, 16, 'Saket', 'chosen'),
    ('u_rohan', 'pet_bruno', 44, 22, 'Indiranagar', 'gps'),
    ('u_ravi', 'pet_simba', 52, 13, 'Banjara Hills', 'gps'),
    ('u_priya', 'pet_bruno', 63, 20, 'Indiranagar', 'chosen'),
    ('u_arjun', 'pet_max', 71, 6, 'Bandra West', 'gps'),
    ('u_anjali', 'pet_tiger', 84, 11, 'Saket', 'gps'),
  ];
  var n = 0;
  for (final s in sos) {
    final a = areas.values.firstWhere((x) => x.name == s.$5);
    add('sosLogs', 'sos_seed_${++n}', {
      'uid': s.$1,
      'petId': s.$2,
      'at': day(s.$3, s.$4, 12),
      'lat': double.parse(a.lat.toStringAsFixed(3)),
      'lng': double.parse(a.lng.toStringAsFixed(3)),
      'area': s.$6 == 'chosen' ? '${a.name}, ${a.city}' : '',
      'source': s.$6,
    });
  }

  // ---------- a past lost report: Luna, found after two days ----------
  add('lostReports', 'lost_seed_luna', {
    'petId': 'pet_luna',
    'ownerId': 'u_arjun',
    'petName': 'Luna',
    'species': 'dog',
    'qrToken': tokens['pet_luna'],
    'status': 'found',
    'since': day(25, 18, 30),
    'foundAt': day(23, 11, 15),
    'area': 'Bandra West',
    'lat': bandra.lat,
    'lng': bandra.lng,
    'note': 'Brown and white beagle puppy, blue collar',
    'alert': true,
    'alertsSent': 3,
    'sightings': [
      {'at': day(24, 8, 40), 'lat': bandra.lat + 0.006, 'lng': bandra.lng - 0.004, 'area': '', 'note': 'Near the bandstand, looked scared', 'name': 'Sneha'},
      {'at': day(23, 10, 5), 'lat': null, 'lng': null, 'area': 'Bandra West, Mumbai', 'note': 'Sitting outside the bakery on Hill Road', 'name': ''},
    ],
    'createdBy': 'u_arjun',
    'createdAt': day(25, 18, 35),
  });

  // ---------- history in the notification centre ----------
  void note(String id, String uid, String title, String body, String type, String link, DateTime at) => add('notifications', id, {
        'uid': uid,
        'title': title,
        'body': body,
        'type': type,
        'link': link,
        'read': true,
        'createdAt': at,
      });
  note('note_safety_1', 'u_arjun', 'Good news: Luna is home safe', '', 'lost', '/pets/pet_luna', day(23, 11, 16));
  note('note_safety_2', 'u_arjun', 'Max has left the safe zone', "Max's GPS collar: now 520 m from home. Tap to see where.", 'device', '/me/devices/dev_max_collar', day(6, 7, 20));
  note('note_safety_3', 'u_meera', 'Max has left the safe zone', "Max's GPS collar: now 520 m from home. Tap to see where.", 'device', '/me/devices/dev_max_collar', day(6, 7, 20));
  note('note_safety_4', 'u_arjun', 'Max is back in the safe zone', '', 'device', '/me/devices/dev_max_collar', day(6, 7, 34));
}
