import 'seed.dart';

/// Demo accounts. Password for every demo account: demo1234.
/// Phone OTP in demo mode: 123456.
class DemoAccount {
  const DemoAccount(
    this.uid,
    this.name,
    this.email,
    this.phoneN,
    this.role, {
    this.language = 'en',
    this.city = 'Hyderabad',
    this.plan = 'free',
    this.easyMode = false,
    this.partnerId,
    this.label,
  });
  final String uid;
  final String name;
  final String email;
  final int phoneN;
  final String role;
  final String language;
  final String city;
  final String plan;
  final bool easyMode;
  final String? partnerId;

  /// Short label for the demo login screen.
  final String? label;
}

const demoPassword = 'demo1234';
const demoOtp = '123456';

const demoAccounts = <DemoAccount>[
  DemoAccount('u_priya', 'Priya Sharma', 'priya@example.com', 1, 'owner', city: 'Bengaluru', plan: 'plus', label: 'owner_plus'),
  DemoAccount('u_ravi', 'Ravi Teja', 'ravi@example.com', 2, 'owner', language: 'te', city: 'Hyderabad', label: 'owner_free'),
  DemoAccount('u_anjali', 'Anjali Verma', 'anjali@example.com', 3, 'owner', language: 'hi', city: 'Delhi NCR', easyMode: true, label: 'owner_easy'),
  DemoAccount('u_arjun', 'Arjun Mehta', 'arjun@example.com', 4, 'owner', city: 'Mumbai', plan: 'plus', label: 'owner_plus'),
  DemoAccount('u_rohan', 'Rohan Sharma', 'rohan@example.com', 5, 'owner', city: 'Bengaluru', label: 'family'),
  DemoAccount('u_meera', 'Meera Pillai', 'meera@example.com', 6, 'owner', city: 'Mumbai', label: 'sitter'),
  DemoAccount('u_clinicadmin', 'Kavya Rao', 'clinic@example.com', 7, 'clinic_admin', partnerId: 'clinic_hyd_1'),
  DemoAccount('u_vet', 'Dr. Sameer Khan', 'vet@example.com', 8, 'vet', partnerId: 'vet_hyd_1_a'),
  DemoAccount('u_groomer', 'Lakshmi Groom Studio', 'groomer@example.com', 9, 'groomer', partnerId: 'prov_groom_1'),
  DemoAccount('u_trainer', 'Vikram Desai', 'trainer@example.com', 10, 'trainer', partnerId: 'prov_train_1'),
  DemoAccount('u_boarder', 'Nisha Home Boarding', 'boarding@example.com', 11, 'boarder', partnerId: 'prov_board_1'),
  DemoAccount('u_walker', 'Imran Walks', 'walker@example.com', 13, 'walker', partnerId: 'prov_walk_1'),
  DemoAccount('u_seller', 'Tail Treats Traders', 'seller@example.com', 14, 'seller', partnerId: 'seller_1'),
  DemoAccount('u_admin', 'PawSetu Admin', 'admin@example.com', 15, 'admin'),
];

DateTime yearsAgo(DateTime now, int years, [int months = 0]) => DateTime(now.year - years, now.month - months, now.day.clamp(1, 28));

void seedPeople(Add add, DateTime now) {
  for (final a in demoAccounts) {
    add('demoAccounts', a.uid, {'email': a.email, 'password': demoPassword, 'phone': demoPhone(a.phoneN), 'emailVerified': true});
    add('users', a.uid, {
      'name': a.name,
      'email': a.email,
      'phone': demoPhone(a.phoneN),
      'role': a.role,
      'plan': a.plan,
      'planRenewsAt': a.plan == 'plus' ? now.add(const Duration(days: 23)) : null,
      'language': a.language,
      'city': a.city,
      'easyMode': a.easyMode,
      'partnerId': a.partnerId,
      'onboarded': true,
      'demo': true,
      'createdAt': now.subtract(const Duration(days: 120)),
      'addresses': a.role == 'owner'
          ? [
              {
                'id': 'home',
                'label': 'Home',
                'line1': 'Flat 12B, Demo Residency',
                'area': _homeArea[a.city] ?? 'Banjara Hills',
                'city': a.city,
                'pin': _homePin[a.city] ?? '500034',
              },
            ]
          : <Map<String, dynamic>>[],
      'consents': {'marketing': false, 'analytics': true, 'lostPetAlerts': true},
      'referralCode': 'PAW${a.uid.substring(2, 5).toUpperCase()}${a.phoneN}',
    });
  }

  Map<String, dynamic> members(Map<String, (String role, String name, DateTime? expires)> m) => {
    for (final e in m.entries) e.key: {'role': e.value.$1, 'name': e.value.$2, 'expiresAt': e.value.$3},
  };

  void pet(String id, Map<String, dynamic> d, Map<String, (String, String, DateTime?)> mem) {
    add('pets', id, {
      'archived': false,
      'neutered': false,
      'allergies': <String>[],
      'photoUrl': null,
      'createdAt': now.subtract(const Duration(days: 110)),
      'qrToken': 'qr_$id',
      'lost': null,
      ...d,
      'memberIds': mem.keys.toList(),
      'members': members(mem),
    });
  }

  final sitterExpiry = DateTime(now.year, now.month, now.day + 3, 21);

  pet(
    'pet_bruno',
    {
      'ownerId': 'u_priya',
      'name': 'Bruno',
      'species': 'dog',
      'breedId': 'labrador',
      'birthday': yearsAgo(now, 3, 2),
      'gender': 'male',
      'weightKg': 29.0,
      'colorTag': 'amber',
      'markings': 'Yellow coat, white chest patch',
      'microchip': 'DEMO-985-000-111',
      'neutered': true,
      'allergies': ['Chicken'],
      'dietType': 'Dry food + home-cooked',
      'clinicId': 'clinic_blr_1',
      'temperament': 'Friendly, loves water, pulls on leash',
      'dailyPlan': {'walks': 2, 'meals': 2, 'playMinutes': 30},
    },
    {'u_priya': ('owner', 'Priya Sharma', null), 'u_rohan': ('carer', 'Rohan Sharma', null)},
  );
  pet(
    'pet_misty',
    {
      'ownerId': 'u_priya',
      'name': 'Misty',
      'species': 'cat',
      'breedId': 'persian',
      'birthday': yearsAgo(now, 5),
      'gender': 'female',
      'weightKg': 4.2,
      'colorTag': 'lavender',
      'markings': 'White long coat',
      'neutered': true,
      'dietType': 'Wet + dry cat food',
      'clinicId': 'clinic_blr_1',
      'temperament': 'Calm, dislikes car rides',
      'dailyPlan': {'walks': 0, 'meals': 3, 'playMinutes': 15},
    },
    {'u_priya': ('owner', 'Priya Sharma', null), 'u_rohan': ('carer', 'Rohan Sharma', null)},
  );
  pet(
    'pet_simba',
    {
      'ownerId': 'u_ravi',
      'name': 'Simba',
      'species': 'dog',
      'breedId': 'indie_dog',
      'birthday': DateTime(now.year, now.month - 5, now.day.clamp(1, 28)),
      'gender': 'male',
      'weightKg': 8.5,
      'colorTag': 'sky',
      'markings': 'Brown with black muzzle',
      'dietType': 'Puppy food',
      'clinicId': 'clinic_hyd_1',
      'temperament': 'Playful, chews everything',
      'dailyPlan': {'walks': 2, 'meals': 3, 'playMinutes': 40},
    },
    {'u_ravi': ('owner', 'Ravi Teja', null)},
  );
  pet(
    'pet_kiwi',
    {
      'ownerId': 'u_ravi',
      'name': 'Kiwi',
      'species': 'bird',
      'breedId': 'cockatiel',
      'birthday': yearsAgo(now, 2),
      'gender': 'male',
      'weightKg': 0.09,
      'colorTag': 'mint',
      'markings': 'Grey with yellow crest',
      'dietType': 'Seed mix + fresh greens',
      'clinicId': 'clinic_hyd_2',
      'temperament': 'Whistles in the morning',
      'dailyPlan': {'walks': 0, 'meals': 2, 'playMinutes': 30},
    },
    {'u_ravi': ('owner', 'Ravi Teja', null)},
  );
  pet(
    'pet_coco',
    {
      'ownerId': 'u_anjali',
      'name': 'Coco',
      'species': 'rabbit',
      'breedId': 'holland_lop',
      'birthday': yearsAgo(now, 2, 4),
      'gender': 'female',
      'weightKg': 1.8,
      'colorTag': 'rose',
      'markings': 'Brown and white, lop ears',
      'neutered': true,
      'dietType': 'Hay + pellets + greens',
      'clinicId': 'clinic_del_1',
      'temperament': 'Shy with strangers',
      'dailyPlan': {'walks': 0, 'meals': 2, 'playMinutes': 60},
    },
    {'u_anjali': ('owner', 'Anjali Verma', null)},
  );
  pet(
    'pet_tiger',
    {
      'ownerId': 'u_anjali',
      'name': 'Tiger',
      'species': 'cat',
      'breedId': 'indie_cat',
      'birthday': yearsAgo(now, 11),
      'gender': 'male',
      'weightKg': 4.8,
      'colorTag': 'amber',
      'markings': 'Orange tabby',
      'neutered': true,
      'dietType': 'Senior renal diet',
      'clinicId': 'clinic_del_1',
      'temperament': 'Sleepy, loves sun',
      'dailyPlan': {'walks': 0, 'meals': 3, 'playMinutes': 10},
    },
    {'u_anjali': ('owner', 'Anjali Verma', null)},
  );
  pet(
    'pet_max',
    {
      'ownerId': 'u_arjun',
      'name': 'Max',
      'species': 'dog',
      'breedId': 'gsd',
      'birthday': yearsAgo(now, 7),
      'gender': 'male',
      'weightKg': 34.0,
      'colorTag': 'sand',
      'markings': 'Black and tan',
      'microchip': 'DEMO-985-000-222',
      'neutered': true,
      'dietType': 'Senior large-breed dry food',
      'clinicId': 'clinic_mum_1',
      'temperament': 'Protective, gentle with kids, stiff hips',
      'dailyPlan': {'walks': 2, 'meals': 2, 'playMinutes': 20},
    },
    {'u_arjun': ('owner', 'Arjun Mehta', null), 'u_meera': ('carer', 'Meera Pillai', sitterExpiry)},
  );
  pet(
    'pet_luna',
    {
      'ownerId': 'u_arjun',
      'name': 'Luna',
      'species': 'dog',
      'breedId': 'beagle',
      'birthday': DateTime(now.year, now.month - 4, now.day.clamp(1, 28)),
      'gender': 'female',
      'weightKg': 5.5,
      'colorTag': 'rose',
      'markings': 'Tricolour',
      'dietType': 'Puppy food',
      'clinicId': 'clinic_mum_1',
      'temperament': 'Curious, howls at the doorbell',
      'dailyPlan': {'walks': 3, 'meals': 3, 'playMinutes': 45},
    },
    {'u_arjun': ('owner', 'Arjun Mehta', null), 'u_meera': ('carer', 'Meera Pillai', sitterExpiry)},
  );
  pet(
    'pet_sheru',
    {
      'ownerId': 'u_arjun',
      'name': 'Sheru',
      'species': 'dog',
      'breedId': 'indie_dog',
      'birthday': DateTime(now.year - 15, 3, 10),
      'gender': 'male',
      'weightKg': 18.0,
      'colorTag': 'sand',
      'archived': true,
      'archivedReason': 'passed_away',
      'archivedAt': DateTime(now.year - 1, 8, 2),
      'memorial': true,
      'memorialNote': 'Our first boy. Forever in our hearts.',
      'dailyPlan': {'walks': 0, 'meals': 0, 'playMinutes': 0},
    },
    {'u_arjun': ('owner', 'Arjun Mehta', null)},
  );

  // Family activity feed
  final acts = [
    ('pet_bruno', 'u_rohan', 'Rohan Sharma', 'medicine_given', 'Deworming tablet', 0, 20, 5),
    ('pet_bruno', 'u_priya', 'Priya Sharma', 'walk_logged', '3.2 km', 0, 7, 15),
    ('pet_misty', 'u_rohan', 'Rohan Sharma', 'meal_logged', 'Wet food', 1, 13, 0),
    ('pet_max', 'u_meera', 'Meera Pillai', 'walk_logged', '1.8 km', 0, 6, 45),
    ('pet_max', 'u_arjun', 'Arjun Mehta', 'member_added', 'Meera Pillai', 2, 18, 30),
  ];
  var i = 0;
  for (final a in acts) {
    final day = DateTime(now.year, now.month, now.day - a.$6, a.$7, a.$8);
    add('activity', 'act_${i++}', {'petId': a.$1, 'actorId': a.$2, 'actorName': a.$3, 'type': a.$4, 'detail': a.$5, 'createdAt': day});
  }
}

const _homeArea = {'Bengaluru': 'Indiranagar', 'Hyderabad': 'Banjara Hills', 'Delhi NCR': 'Saket', 'Mumbai': 'Bandra West'};
const _homePin = {'Bengaluru': '560038', 'Hyderabad': '500034', 'Delhi NCR': '110017', 'Mumbai': '400050'};
