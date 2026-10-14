import 'seed.dart';

/// Vaccine histories, medicines, deworming/flea-tick, vet visits, symptoms,
/// reminders and notification history (spec 12). Simba is the only pet with
/// an overdue vaccine.
void seedHealth(Add add, DateTime now, SeedData data) {
  DateTime birthday(String petId) => data['pets']![petId]!['birthday'] as DateTime;
  DateTime daysAgo(int d, [int hour = 10]) => DateTime(now.year, now.month, now.day - d, hour);
  var n = 0;

  void vaccine(String petId, String key, String name, DateTime given, {String? brand, String? clinic, String? vet}) {
    add('vaccinations', 'vac_${n++}', {
      'petId': petId,
      'templateKey': key,
      'name': name,
      'givenDate': given,
      'brand': brand ?? (name.contains('rabies') || name.contains('Rabies') ? 'Rabivet (sample)' : 'Vaxipet (sample)'),
      'batch': 'SAMPLE-${1000 + n}',
      'vetName': vet,
      'clinicName': clinic,
      'certificateDocId': null,
      'createdAt': given,
    });
  }

  void puppySeries(String petId, String prefix, String name, {String? clinic, String? vet, bool includeThird = true, bool rabies = true}) {
    final b = birthday(petId);
    vaccine(petId, '${prefix}_1', name, b.add(const Duration(days: 45)), clinic: clinic, vet: vet);
    vaccine(petId, '${prefix}_2', name, b.add(const Duration(days: 68)), clinic: clinic, vet: vet);
    if (includeThird) vaccine(petId, '${prefix}_3', name, b.add(const Duration(days: 91)), clinic: clinic, vet: vet);
    if (rabies) vaccine(petId, 'rabies_1', 'Anti-rabies', b.add(const Duration(days: 98)), clinic: clinic, vet: vet);
  }

  // Bruno: full puppy series, boosters due in about 10 days.
  puppySeries('pet_bruno', 'dhppi', 'DHPPi + Lepto', clinic: 'Gulmohar Vet Studio');
  vaccine('pet_bruno', 'dhppi_booster', 'DHPPi + Lepto', daysAgo(720), clinic: 'Gulmohar Vet Studio');
  vaccine('pet_bruno', 'dhppi_booster', 'DHPPi + Lepto', daysAgo(355), clinic: 'Gulmohar Vet Studio');
  vaccine('pet_bruno', 'rabies_booster', 'Anti-rabies', daysAgo(355), clinic: 'Gulmohar Vet Studio');
  // Misty: FVRCP every 3 years, rabies yearly.
  puppySeries('pet_misty', 'fvrcp', 'FVRCP', clinic: 'Gulmohar Vet Studio');
  vaccine('pet_misty', 'fvrcp_booster', 'FVRCP', daysAgo(700), clinic: 'Gulmohar Vet Studio');
  vaccine('pet_misty', 'rabies_booster', 'Anti-rabies', daysAgo(300), clinic: 'Gulmohar Vet Studio');
  // Simba: dose 3 missing -> overdue (the one overdue vaccine).
  puppySeries('pet_simba', 'dhppi', 'DHPPi + Lepto', clinic: 'Golconda Gate Pet Clinic', vet: 'Dr. Sameer Khan', includeThird: false);
  // Tiger: senior cat, rabies due soon.
  vaccine('pet_tiger', 'fvrcp_booster', 'FVRCP', daysAgo(540), clinic: 'Saket Pet Wellness');
  vaccine('pet_tiger', 'rabies_booster', 'Anti-rabies', daysAgo(356), clinic: 'Saket Pet Wellness');
  // Max: boosters 8 months ago.
  vaccine('pet_max', 'dhppi_booster', 'DHPPi + Lepto', daysAgo(240), clinic: 'Sea Breeze Pet Clinic');
  vaccine('pet_max', 'rabies_booster', 'Anti-rabies', daysAgo(240), clinic: 'Sea Breeze Pet Clinic');
  // Luna: puppy series complete.
  puppySeries('pet_luna', 'dhppi', 'DHPPi + Lepto', clinic: 'Sea Breeze Pet Clinic');

  // Medicines (names are generic, as a vet would write them on a demo).
  add('medicines', 'med_tiger_kidney', {
    'petId': 'pet_tiger',
    'name': 'Kidney support tablet',
    'dose': '1',
    'unit': 'tablet',
    'frequency': 'once',
    'times': ['09:00'],
    'withFood': true,
    'startDate': daysAgo(60, 0),
    'endDate': null,
    'stock': 12,
    'refillAt': 5,
    'active': true,
    'createdAt': daysAgo(60),
  });
  add('medicines', 'med_max_joint', {
    'petId': 'pet_max',
    'name': 'Joint care tablet',
    'dose': '1',
    'unit': 'tablet',
    'frequency': 'twice',
    'times': ['08:00', '20:00'],
    'withFood': true,
    'startDate': daysAgo(90, 0),
    'endDate': null,
    'stock': 4,
    'refillAt': 5,
    'active': true,
    'createdAt': daysAgo(90),
  });
  add('medicines', 'med_misty_hairball', {
    'petId': 'pet_misty',
    'name': 'Hairball gel',
    'dose': '2',
    'unit': 'ml',
    'frequency': 'weekly',
    'times': ['19:00'],
    'withFood': false,
    'startDate': daysAgo(40, 0),
    'endDate': null,
    'stock': null,
    'refillAt': 5,
    'active': true,
    'createdAt': daysAgo(40),
  });
  for (var d = 7; d >= 1; d--) {
    add('medicineLogs', 'ml_tiger_$d', {
      'medicineId': 'med_tiger_kidney',
      'petId': 'pet_tiger',
      'dose': daysAgo(d, 9),
      'at': DateTime(now.year, now.month, now.day - d, 9, 6),
      'status': d == 4 ? 'skipped' : 'given',
      'byUid': 'u_anjali',
      'byName': 'Anjali Verma',
    });
  }
  for (var d = 3; d >= 1; d--) {
    for (final h in [8, 20]) {
      add('medicineLogs', 'ml_max_${d}_$h', {
        'medicineId': 'med_max_joint',
        'petId': 'pet_max',
        'dose': daysAgo(d, h),
        'at': DateTime(now.year, now.month, now.day - d, h, 10),
        'status': 'given',
        'byUid': h == 8 ? 'u_meera' : 'u_arjun',
        'byName': h == 8 ? 'Meera Pillai' : 'Arjun Mehta',
      });
    }
  }

  void event(String petId, String type, int ago, Map<String, dynamic> extra) => add('healthEvents', 'he_${n++}', {
    'petId': petId,
    'type': type,
    'date': daysAgo(ago, 11),
    'notes': '',
    'photos': <String>[],
    'createdAt': daysAgo(ago, 11),
    ...extra,
  });

  for (final e in [('pet_bruno', 80, 25), ('pet_misty', 60, 20), ('pet_simba', 20, 28), ('pet_luna', 15, 12), ('pet_max', 85, 26), ('pet_tiger', 70, 22)]) {
    event(e.$1, 'deworming', e.$2, {'title': 'Deworming tablet (sample)'});
    event(e.$1, 'flea_tick', e.$3, {'title': 'Spot-on tick and flea (sample)'});
  }

  event('pet_bruno', 'vet_visit', 120, {
    'title': 'Annual check-up',
    'clinicName': 'Gulmohar Vet Studio',
    'diagnosis': 'Healthy. Mild ear infection, ear drops for 7 days.',
  });
  event('pet_tiger', 'vet_visit', 30, {
    'title': 'Kidney function follow-up',
    'clinicName': 'Saket Pet Wellness',
    'diagnosis': 'Early kidney changes. Renal diet and daily support tablet.',
  });
  event('pet_max', 'vet_visit', 62, {
    'title': 'Stiff hips',
    'clinicName': 'Sea Breeze Pet Clinic',
    'diagnosis': 'Mild arthritis. Joint care tablet, short gentle walks.',
  });
  event('pet_kiwi', 'vet_visit', 150, {
    'title': 'Annual avian check',
    'clinicName': 'Featherfold Bird & Pet Hospital',
    'diagnosis': 'Healthy. Nails and beak trimmed.',
  });
  event('pet_coco', 'vet_visit', 95, {'title': 'Health check', 'clinicName': 'Saket Pet Wellness', 'diagnosis': 'Healthy. More hay, fewer pellets.'});
  event('pet_simba', 'symptom', 6, {'title': 'Symptom', 'symptom': 'vomiting', 'severity': 1, 'notes': 'Once, after eating grass'});
  event('pet_max', 'symptom', 3, {'title': 'Symptom', 'symptom': 'limping', 'severity': 2, 'notes': 'After a long walk on the beach'});
  event('pet_tiger', 'symptom', 10, {'title': 'Symptom', 'symptom': 'not_eating', 'severity': 1, 'notes': 'Ate half his dinner'});

  void reminder(String owner, String petId, String type, String title, int inDays, String repeat) => add('reminders', 'rem_${n++}', {
    'ownerId': owner,
    'petId': petId,
    'type': type,
    'title': title,
    'at': DateTime(now.year, now.month, now.day + inDays, 10),
    'repeat': repeat,
    'done': false,
  });
  reminder('u_priya', 'pet_bruno', 'grooming', 'Grooming · Bruno', 9, 'monthly');
  reminder('u_arjun', 'pet_max', 'insurance', 'Insurance renewal · Max', 20, 'yearly');
  reminder('u_anjali', 'pet_coco', 'nail_trim', 'Nail trim · Coco', 4, 'monthly');
  reminder('u_ravi', 'pet_kiwi', 'custom', 'Clean Kiwi\'s cage', 2, 'none');

  void note(String uid, String title, String type, int hoursAgo, {bool read = false, String? link}) => add('notifications', 'note_${n++}', {
    'uid': uid,
    'title': title,
    'body': '',
    'type': type,
    'link': link,
    'read': read,
    'createdAt': now.subtract(Duration(hours: hoursAgo)),
  });
  note('u_ravi', "Simba's DHPPi + Lepto is overdue", 'vaccines', 5, link: '/health?pet=pet_simba');
  note('u_ravi', "Kiwi's cage cleaning is in 2 days", 'custom', 30, read: true);
  note('u_priya', 'Rohan gave Bruno his deworming tablet', 'medicines', 20, read: true);
  note('u_priya', "Bruno's flea and tick prevention is due soon", 'deworming', 3, link: '/health?pet=pet_bruno');
  note('u_anjali', "Time for Tiger's Kidney support tablet", 'medicines', 1, link: '/health?pet=pet_tiger');
  note('u_arjun', 'Only 4 Joint care tablets left for Max', 'medicines', 8, link: '/health?pet=pet_max');

  void outbox(String channel, String to, String body, int hoursAgo, {String? subject}) => add('outbox', 'out_${n++}', {
    'channel': channel,
    'to': to,
    'subject': subject,
    'body': body,
    'type': 'reminder',
    'createdAt': now.subtract(Duration(hours: hoursAgo)),
  });
  outbox('sms', '+91 90000 00002', "PawSetu: Simba's DHPPi + Lepto is overdue. Book a vet in the app.", 5);
  outbox('whatsapp', '+91 90000 00001', "PawSetu: Bruno's flea and tick prevention is due soon.", 3);
  outbox('email', 'anjali@example.com', "Time for Tiger's Kidney support tablet.", 1, subject: 'Medicine reminder for Tiger');
}
