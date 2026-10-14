import 'seed.dart';

/// Real city areas with approximate coordinates so maps work.
class Area {
  const Area(this.city, this.name, this.lat, this.lng, this.pin);
  final String city;
  final String name;
  final double lat;
  final double lng;
  final String pin;
}

const areas = <String, Area>{
  'banjara': Area('Hyderabad', 'Banjara Hills', 17.4126, 78.4482, '500034'),
  'gachibowli': Area('Hyderabad', 'Gachibowli', 17.4401, 78.3489, '500032'),
  'kukatpally': Area('Hyderabad', 'Kukatpally', 17.4849, 78.4138, '500072'),
  'madhapur': Area('Hyderabad', 'Madhapur', 17.4483, 78.3915, '500081'),
  'indiranagar': Area('Bengaluru', 'Indiranagar', 12.9784, 77.6408, '560038'),
  'koramangala': Area('Bengaluru', 'Koramangala', 12.9352, 77.6245, '560034'),
  'whitefield': Area('Bengaluru', 'Whitefield', 12.9698, 77.7500, '560066'),
  'hsr': Area('Bengaluru', 'HSR Layout', 12.9116, 77.6474, '560102'),
  'bandra': Area('Mumbai', 'Bandra West', 19.0596, 72.8295, '400050'),
  'andheri': Area('Mumbai', 'Andheri West', 19.1364, 72.8296, '400053'),
  'powai': Area('Mumbai', 'Powai', 19.1176, 72.9060, '400076'),
  'chembur': Area('Mumbai', 'Chembur', 19.0522, 72.9005, '400071'),
  'adyar': Area('Chennai', 'Adyar', 13.0012, 80.2565, '600020'),
  'annanagar': Area('Chennai', 'Anna Nagar', 13.0850, 80.2101, '600040'),
  'koregaon': Area('Pune', 'Koregaon Park', 18.5362, 73.8940, '411001'),
  'baner': Area('Pune', 'Baner', 18.5590, 73.7868, '411045'),
  'saket': Area('Delhi NCR', 'Saket', 28.5245, 77.2066, '110017'),
  'gurugram': Area('Delhi NCR', 'Gurugram Sector 29', 28.4690, 77.0640, '122001'),
  'noida': Area('Delhi NCR', 'Noida Sector 18', 28.5708, 77.3261, '201301'),
};

const cities = ['Hyderabad', 'Bengaluru', 'Mumbai', 'Chennai', 'Pune', 'Delhi NCR'];

/// Clinic services and indicative prices (₹).
const clinicServiceCatalog = <String, int>{
  'consultation': 0, // uses the clinic's consultation fee
  'vaccination': 650,
  'surgery': 6500,
  'dental': 2200,
  'lab_tests': 1200,
  'xray_ultrasound': 1500,
  'grooming': 900,
  'boarding': 800,
  'home_visit': 1200,
};

Map<String, List<String>> standardHours(bool open24x7) => open24x7
    ? {
        for (final d in _days) d: ['00:00', '24:00'],
      }
    : {
        for (final d in _days.take(6)) d: ['09:00', '20:00'],
        'sun': ['10:00', '14:00'],
      };

const _days = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];

class _ClinicSeed {
  const _ClinicSeed(
    this.id,
    this.name,
    this.area,
    this.is24x7,
    this.rating,
    this.reviews,
    this.fee,
    this.mode,
    this.payments,
    this.langs,
    this.vets, {
    this.exotic = false,
    this.services = const [],
    this.status = 'approved',
  });
  final String id;
  final String name;
  final String area;
  final bool is24x7;
  final double rating;
  final int reviews;
  final int fee;
  final String mode;
  final List<String> payments;
  final List<String> langs;
  final int vets;
  final bool exotic;
  final List<String> services;
  final String status;
}

const _base = ['consultation', 'vaccination', 'lab_tests'];

const _clinics = <_ClinicSeed>[
  _ClinicSeed(
    'clinic_hyd_1',
    'Golconda Gate Pet Clinic',
    'banjara',
    false,
    4.6,
    24,
    600,
    'instant',
    ['online', 'at_clinic'],
    ['en', 'hi', 'te'],
    3,
    services: [..._base, 'dental', 'grooming', 'home_visit'],
  ),
  _ClinicSeed(
    'clinic_hyd_2',
    'Featherfold Bird & Pet Hospital',
    'gachibowli',
    true,
    4.8,
    30,
    800,
    'request',
    ['online'],
    ['en', 'te'],
    2,
    exotic: true,
    services: [..._base, 'surgery', 'xray_ultrasound'],
  ),
  _ClinicSeed(
    'clinic_hyd_3',
    'Tulsi Tails Veterinary',
    'kukatpally',
    false,
    3.9,
    9,
    350,
    'instant',
    ['at_clinic'],
    ['en', 'te'],
    1,
    services: [..._base, 'grooming'],
  ),
  _ClinicSeed(
    'clinic_blr_1',
    'Gulmohar Vet Studio',
    'indiranagar',
    false,
    4.8,
    28,
    750,
    'instant',
    ['online', 'at_clinic'],
    ['en', 'hi'],
    4,
    services: [..._base, 'surgery', 'dental', 'xray_ultrasound', 'home_visit'],
  ),
  _ClinicSeed(
    'clinic_blr_2',
    'Namma Pet Hospital',
    'koramangala',
    true,
    4.5,
    22,
    900,
    'instant',
    ['online', 'at_clinic'],
    ['en', 'hi'],
    3,
    exotic: true,
    services: [..._base, 'surgery', 'xray_ultrasound', 'boarding'],
  ),
  _ClinicSeed(
    'clinic_blr_3',
    'Whitefield Wag Clinic',
    'whitefield',
    false,
    4.1,
    12,
    500,
    'request',
    ['at_clinic'],
    ['en'],
    1,
    services: [..._base, 'grooming', 'boarding'],
  ),
  _ClinicSeed(
    'clinic_mum_1',
    'Sea Breeze Pet Clinic',
    'bandra',
    true,
    4.7,
    26,
    850,
    'instant',
    ['online', 'at_clinic'],
    ['en', 'hi'],
    3,
    services: [..._base, 'surgery', 'dental', 'xray_ultrasound'],
  ),
  _ClinicSeed('clinic_mum_2', 'Andheri Animal Aid Clinic', 'andheri', false, 3.6, 7, 300, 'request', ['at_clinic'], ['en', 'hi'], 1, services: [..._base]),
  _ClinicSeed(
    'clinic_mum_3',
    'Powai Lakeview Vets',
    'powai',
    false,
    4.4,
    15,
    700,
    'instant',
    ['online'],
    ['en', 'hi'],
    2,
    exotic: true,
    services: [..._base, 'dental', 'home_visit'],
  ),
  _ClinicSeed(
    'clinic_che_1',
    'Marina Paw Care',
    'adyar',
    true,
    4.3,
    18,
    650,
    'instant',
    ['online', 'at_clinic'],
    ['en'],
    2,
    services: [..._base, 'surgery', 'xray_ultrasound'],
  ),
  _ClinicSeed('clinic_che_2', 'Anna Nagar Pet Point', 'annanagar', false, 4.0, 10, 400, 'request', ['at_clinic'], ['en'], 1, services: [..._base, 'grooming']),
  _ClinicSeed(
    'clinic_pun_1',
    'Sahyadri Tails Clinic',
    'koregaon',
    false,
    4.6,
    19,
    600,
    'instant',
    ['online', 'at_clinic'],
    ['en', 'hi'],
    2,
    services: [..._base, 'dental', 'boarding'],
  ),
  _ClinicSeed(
    'clinic_pun_2',
    'Baner Bark & Purr',
    'baner',
    false,
    3.8,
    5,
    450,
    'request',
    ['online', 'at_clinic'],
    ['en', 'hi'],
    1,
    services: [..._base, 'grooming'],
  ),
  _ClinicSeed(
    'clinic_del_1',
    'Saket Pet Wellness',
    'saket',
    true,
    4.9,
    29,
    900,
    'instant',
    ['online', 'at_clinic'],
    ['en', 'hi'],
    4,
    services: [..._base, 'surgery', 'dental', 'xray_ultrasound', 'home_visit'],
  ),
  _ClinicSeed(
    'clinic_del_2',
    'Cyber City Vet Care',
    'gurugram',
    false,
    4.2,
    14,
    550,
    'request',
    ['at_clinic'],
    ['en', 'hi'],
    2,
    services: [..._base, 'grooming'],
  ),
  // Waiting for admin approval (spec 12: 2 pending clinics)
  _ClinicSeed(
    'clinic_pending_1',
    'Hitech Pet Care Point',
    'madhapur',
    false,
    0,
    0,
    500,
    'instant',
    ['at_clinic'],
    ['en', 'te'],
    1,
    services: [..._base],
    status: 'pending',
  ),
  _ClinicSeed(
    'clinic_pending_2',
    'Chembur Critter Clinic',
    'chembur',
    false,
    0,
    0,
    450,
    'request',
    ['at_clinic'],
    ['en', 'hi'],
    1,
    services: [..._base],
    status: 'pending',
  ),
];

const _vetFirst = [
  'Sameer',
  'Ananya',
  'Rahul',
  'Deepa',
  'Karthik',
  'Meghna',
  'Farhan',
  'Sneha',
  'Aditya',
  'Pooja',
  'Naveen',
  'Ishita',
  'Sanjay',
  'Divya',
  'Harsh',
  'Lavanya',
  'Manoj',
  'Ritika',
  'Varun',
  'Shalini',
  'Gaurav',
  'Nandini',
  'Abhishek',
  'Swati',
  'Prakash',
  'Tanvi',
  'Suresh',
  'Keerthi',
  'Mohit',
  'Aparna',
  'Yash',
  'Bhavana',
];
const _vetLast = ['Khan', 'Reddy', 'Iyer', 'Nair', 'Kulkarni', 'Bose', 'Gupta', 'Menon', 'Joshi', 'Rao', 'Singh', 'Das', 'Patil', 'Chopra', 'Shetty', 'Varma'];
const _quals = ['BVSc & AH', 'BVSc & AH, MVSc (Medicine)', 'BVSc & AH, MVSc (Surgery)', 'BVSc & AH, PG Dip. Small Animal Practice'];

void seedPlaces(Add add, DateTime now) {
  final r = SeedRandom(7);
  var vetN = 0;
  var phoneN = 21;
  for (final c in _clinics) {
    final a = areas[c.area]!;
    final species = c.exotic ? ['dog', 'cat', 'bird', 'rabbit'] : ['dog', 'cat'];
    final vetIds = <String>[];
    for (var i = 0; i < c.vets; i++) {
      final letter = String.fromCharCode(97 + i);
      final vid = 'vet_${c.id.substring(7)}_$letter';
      vetIds.add(vid);
      final isDemoVet = vid == 'vet_hyd_1_a';
      final first = isDemoVet ? 'Sameer' : _vetFirst[vetN % _vetFirst.length];
      final last = isDemoVet ? 'Khan' : _vetLast[(vetN * 5 + 3) % _vetLast.length];
      vetN++;
      add('vets', vid, {
        'clinicId': c.id,
        'clinicName': c.name,
        'city': a.city,
        'uid': isDemoVet ? 'u_vet' : null,
        'name': 'Dr. $first $last',
        'qualification': _quals[vetN % _quals.length],
        'regNo': 'DEMO-VC-${vetN.toString().padLeft(4, '0')}',
        'experienceYears': 3 + r.next(18),
        'languages': c.langs,
        'species': species,
        'teleVet': c.payments.contains('online') && i < 2,
        'videoFee': 299 + 50 * r.next(6),
        'rating': (40 + r.next(10)) / 10,
        'status': c.status,
      });
    }
    add('clinics', c.id, {
      'name': c.name,
      'city': a.city,
      'area': a.name,
      'address': '${12 + r.next(80)}, ${['Main Road', 'Cross Road', '1st Avenue', 'Park Street'][r.next(4)]}, ${a.name}, ${a.city} ${a.pin}',
      'pin': a.pin,
      'lat': a.lat + (r.nextDouble() - 0.5) * 0.02,
      'lng': a.lng + (r.nextDouble() - 0.5) * 0.02,
      'phone': demoPhone(phoneN),
      'emergencyPhone': c.is24x7 ? demoPhone(12) : null,
      'is24x7': c.is24x7,
      'hours': standardHours(c.is24x7),
      'rating': c.rating,
      'reviewCount': c.reviews,
      'species': species,
      'services': [
        for (final s in c.services)
          {
            'id': s,
            'price': s == 'consultation' ? c.fee : clinicServiceCatalog[s],
            'durationMin': s == 'surgery' ? 120 : (s == 'consultation' ? 20 : 30),
            'mode': s == 'surgery' ? 'request' : c.mode,
            'payments': c.payments,
          },
      ],
      'consultationFee': c.fee,
      'teleVet': c.payments.contains('online'),
      'languages': c.langs,
      'vetIds': vetIds,
      'photoSeed': r.next(6),
      'slotMinutes': 20,
      'bufferMinutes': 5,
      'capacityPerSlot': c.vets > 2 ? 2 : 1,
      'holidays': <DateTime>[],
      'cancellationHours': 4,
      'homeVisitRadiusKm': c.services.contains('home_visit') ? 8 : 0,
      'homeVisitFee': c.services.contains('home_visit') ? 300 : 0,
      'requestWindowHours': 2,
      'enquiriesEnabled': true,
      'status': c.status,
      'ownerUid': c.id == 'clinic_hyd_1' ? 'u_clinicadmin' : null,
      'kycDocs': ['Clinic registration (SAMPLE)', 'GST certificate (SAMPLE)'],
      'createdAt': now.subtract(Duration(days: 200 - r.next(100))),
    });
    phoneN++;
  }

  // Service providers: 8 groomers, 6 trainers, 5 boarding/sitters, 6 walkers.
  final provs = <(String id, String type, String name, String area, String? uid, String status)>[
    ('prov_groom_1', 'groomer', 'Lakshmi Groom Studio', 'banjara', 'u_groomer', 'approved'),
    ('prov_groom_2', 'groomer', 'Fluff & Fold Mobile Spa', 'madhapur', null, 'approved'),
    ('prov_groom_3', 'groomer', 'Bubble Paws Salon', 'indiranagar', null, 'approved'),
    ('prov_groom_4', 'groomer', 'Doorstep Doggie Spa', 'hsr', null, 'approved'),
    ('prov_groom_5', 'groomer', 'Bandra Bath & Brush', 'bandra', null, 'approved'),
    ('prov_groom_6', 'groomer', 'Powai Pet Parlour', 'powai', null, 'approved'),
    ('prov_groom_7', 'groomer', 'Adyar Grooming Nook', 'adyar', null, 'approved'),
    ('prov_groom_8', 'groomer', 'Saket Snip & Style', 'saket', null, 'approved'),
    ('prov_groom_pending', 'groomer', 'Koregaon Coat Care', 'koregaon', null, 'pending'),
    ('prov_train_1', 'trainer', 'Vikram Desai Dog Training', 'gachibowli', 'u_trainer', 'approved'),
    ('prov_train_2', 'trainer', 'Good Boy Academy', 'koramangala', null, 'approved'),
    ('prov_train_3', 'trainer', 'Calm Canine Coaching', 'andheri', null, 'approved'),
    ('prov_train_4', 'trainer', 'Paws & Praise Training', 'annanagar', null, 'approved'),
    ('prov_train_5', 'trainer', 'Sit Stay Pune', 'baner', null, 'approved'),
    ('prov_train_6', 'trainer', 'Leash Lessons NCR', 'gurugram', null, 'approved'),
    ('prov_board_1', 'boarder', 'Nisha Home Boarding', 'kukatpally', 'u_boarder', 'approved'),
    ('prov_board_2', 'boarder', 'Happy Tails Farm Stay', 'whitefield', null, 'approved'),
    ('prov_board_3', 'boarder', 'Chembur Cosy Kennels', 'chembur', null, 'approved'),
    ('prov_board_4', 'boarder', 'Pet Nanny Pune', 'koregaon', null, 'approved'),
    ('prov_board_5', 'boarder', 'Noida Pet Sitters', 'noida', null, 'approved'),
    ('prov_walk_1', 'walker', 'Imran Walks', 'banjara', 'u_walker', 'approved'),
    ('prov_walk_2', 'walker', 'Sunrise Strolls', 'indiranagar', null, 'approved'),
    ('prov_walk_3', 'walker', 'Bandra Bark Walkers', 'bandra', null, 'approved'),
    ('prov_walk_4', 'walker', 'Marina Morning Walks', 'adyar', null, 'approved'),
    ('prov_walk_5', 'walker', 'Saket Sniff Walks', 'saket', null, 'approved'),
    ('prov_walk_6', 'walker', 'Andheri Pack Walks', 'andheri', null, 'approved'),
  ];
  for (final p in provs) {
    final a = areas[p.$4]!;
    final services = switch (p.$2) {
      'groomer' => [
        {'id': 'bath_brush', 'price': 799, 'durationMin': 60},
        {'id': 'full_groom', 'price': 1499, 'durationMin': 120},
        {'id': 'nail_trim', 'price': 299, 'durationMin': 20},
        {'id': 'tick_treatment', 'price': 999, 'durationMin': 60},
      ],
      'trainer' => [
        {'id': 'puppy_basics', 'price': 1200, 'durationMin': 60},
        {'id': 'obedience', 'price': 1500, 'durationMin': 60},
        {'id': 'behaviour', 'price': 2000, 'durationMin': 90},
      ],
      'boarder' => [
        {'id': 'boarding_night', 'price': 900, 'durationMin': 1440},
        {'id': 'day_care', 'price': 600, 'durationMin': 600},
        {'id': 'home_sitting', 'price': 1100, 'durationMin': 1440},
      ],
      _ => [
        {'id': 'walk_30', 'price': 199, 'durationMin': 30},
        {'id': 'walk_60', 'price': 349, 'durationMin': 60},
      ],
    };
    final mode = p.$1 == 'prov_groom_1' ? 'request' : (r.chance(0.5) ? 'instant' : 'request');
    add('providers', p.$1, {
      'type': p.$2,
      'name': p.$3,
      'city': a.city,
      'area': a.name,
      'address': '${5 + r.next(60)}, ${a.name}, ${a.city} ${a.pin}',
      'lat': a.lat + (r.nextDouble() - 0.5) * 0.02,
      'lng': a.lng + (r.nextDouble() - 0.5) * 0.02,
      'phone': demoPhone(phoneN++),
      'uid': p.$5,
      'rating': p.$6 == 'pending' ? 0 : (37 + r.next(13)) / 10,
      'reviewCount': p.$6 == 'pending' ? 0 : 5 + r.next(26),
      'species': p.$2 == 'walker' || p.$2 == 'trainer' ? ['dog'] : ['dog', 'cat'],
      'services': [
        for (final s in services)
          {
            ...s,
            'mode': mode,
            'payments': r.chance(0.6) ? ['online', 'at_clinic'] : ['online'],
          },
      ],
      'packages': p.$2 == 'groomer'
          ? [
              {'id': 'monthly_groom', 'name': 'Monthly groom (4 visits)', 'price': 4999, 'visits': 4},
            ]
          : p.$2 == 'walker'
          ? [
              {'id': 'walk_month', 'name': '30 walks a month', 'price': 4999, 'visits': 30},
            ]
          : <Map<String, dynamic>>[],
      'homeVisit': p.$2 != 'boarder' || p.$1 == 'prov_board_4',
      'atCentre': p.$2 != 'walker',
      'radiusKm': 6 + r.next(6),
      'travelFee': p.$2 == 'walker' ? 0 : 150,
      'hours': standardHours(false),
      'slotMinutes': 30,
      'bufferMinutes': 10,
      'capacityPerSlot': 1,
      'holidays': <DateTime>[],
      'cancellationHours': 6,
      'requestWindowHours': 2,
      'enquiriesEnabled': true,
      'languages': a.city == 'Hyderabad' ? ['en', 'te', 'hi'] : ['en', 'hi'],
      'about': 'Fictional demo partner. Friendly, certified and insured (sample).',
      'status': p.$6,
      'kycDocs': ['ID proof (SAMPLE)', 'Address proof (SAMPLE)'],
      'createdAt': now.subtract(Duration(days: 150 - r.next(100))),
    });
  }
}
