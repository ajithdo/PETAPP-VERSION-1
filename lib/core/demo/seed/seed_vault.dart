import '../../../features/vault/domain/pin_hash.dart';
import 'seed.dart';

/// Phase 7: vault documents, insurance policies with claims, share links,
/// and album photos, videos and milestones (spec 7.9, 7.11, 12).
///
/// Documents use the built-in samples (url `sample:<key>`): the app draws
/// each one from what is printed on it, and `extracted` holds exactly those
/// values ([printedSample]; a unit test checks they match the app).
/// Photos and videos are illustrated placeholders (`seed:album:<species>:<n>`).
void seedVault(Add add, DateTime now, SeedData data) {
  DateTime day(int ago, [int hour = 10, int minute = 0]) => DateTime(now.year, now.month, now.day - ago, hour, minute);
  Map<String, dynamic> pet(String id) => data['pets']![id]!;
  DateTime birthday(String id) => pet(id)['birthday'] as DateTime;
  DateTime after(DateTime d, int days, [int hour = 11]) => DateTime(d.year, d.month, d.day + days, hour);
  const people = {
    'u_priya': 'Priya Sharma',
    'u_rohan': 'Rohan Sharma',
    'u_ravi': 'Ravi Teja',
    'u_anjali': 'Anjali Verma',
    'u_arjun': 'Arjun Mehta',
    'u_meera': 'Meera Pillai',
  };

  // ---------- documents ----------

  var docN = 0;
  void doc(
    String id,
    String petId,
    String key,
    DateTime issued, {
    required String title,
    List<String> tags = const [],
    bool pending = false,
  }) {
    final p = pet(petId);
    final owner = p['ownerId'] as String;
    final printed = printedSample(key, p['name'] as String, issued);
    final type = sampleType(key);
    final created = DateTime(issued.year, issued.month, issued.day, 18, (docN++ * 7) % 60);
    add('documents', id, {
      'ownerId': owner,
      'petId': petId,
      'type': type,
      'title': title,
      'tags': tags,
      'url': 'sample:$key',
      'contentType': 'sample',
      'sizeBytes': 240000 + (docN * 61000) % 420000,
      'fileName': '${key}_${(p['name'] as String).toLowerCase()}.jpg',
      'storagePath': null,
      // Vaccines use the next due date; insurance the renewal date.
      'expiry': pending ? null : (printed['expiry'] ?? printed['nextDue']),
      'source': 'sample',
      'sampleIssuedOn': DateTime(issued.year, issued.month, issued.day),
      'readStatus': pending ? 'pending' : 'confirmed',
      'extracted': pending ? null : {...printed, 'confirmedAt': created, 'confirmedBy': people[owner]},
      'byName': people[owner],
      'createdAt': created,
    });
  }

  // Bruno: certificates for last year's boosters (rabies due in about 10
  // days, so it shows "Expires soon"), his insurance policy, the lab report
  // and vet bill behind an open claim, and his licence.
  final brunoBooster = day(355);
  doc('doc_bruno_rabies', 'pet_bruno', 'rabies_certificate', brunoBooster, title: 'Anti-rabies certificate', tags: ['rabies', '${brunoBooster.year}']);
  doc('doc_bruno_dhppi', 'pet_bruno', 'dhppi_certificate', brunoBooster, title: 'DHPPi + Lepto certificate', tags: ['dhppi', '${brunoBooster.year}']);
  final brunoPolicyStart = day(300);
  doc('doc_bruno_policy', 'pet_bruno', 'insurance_policy', brunoPolicyStart, title: 'Shield Pet Cover (sample) policy', tags: ['insurance', '${brunoPolicyStart.year}']);
  final earVisit = day(41);
  doc('doc_bruno_lab', 'pet_bruno', 'lab_report', earVisit, title: 'Complete blood count (CBC)', tags: ['lab', 'ear infection']);
  doc('doc_bruno_invoice', 'pet_bruno', 'invoice', earVisit, title: 'Gulmohar Vet Studio bill', tags: ['vet bill', 'claim']);
  doc('doc_bruno_licence', 'pet_bruno', 'licence', day(200), title: 'Dog licence', tags: ['licence']);

  // Misty: rabies certificate, adoption papers, and a new lab report that
  // still needs checking (it sits at the top with "Check details").
  doc('doc_misty_rabies', 'pet_misty', 'rabies_certificate', day(300), title: 'Anti-rabies certificate', tags: ['rabies']);
  doc('doc_misty_adoption', 'pet_misty', 'adoption', after(birthday('pet_misty'), 70), title: 'Adoption papers', tags: ['adoption']);
  doc('doc_misty_lab', 'pet_misty', 'lab_report', day(2), title: 'Lab report', pending: true);

  // Simba (Ravi): shelter adoption papers, first puppy vaccine, a vet bill.
  final simbaBorn = birthday('pet_simba');
  doc('doc_simba_adoption', 'pet_simba', 'adoption', after(simbaBorn, 40), title: 'Adoption certificate', tags: ['adoption']);
  doc('doc_simba_dhppi', 'pet_simba', 'dhppi_certificate', after(simbaBorn, 45), title: 'DHPPi + Lepto certificate', tags: ['dhppi', 'dose 1']);
  doc('doc_simba_invoice', 'pet_simba', 'invoice', day(20), title: 'Vet bill', tags: ['vet bill']);

  // Kiwi: a check-up bill and an old travel certificate (expired).
  doc('doc_kiwi_invoice', 'pet_kiwi', 'invoice', day(95), title: 'Bird check-up bill', tags: ['vet bill']);
  doc('doc_kiwi_travel', 'pet_kiwi', 'travel', day(160), title: 'Travel health certificate', tags: ['travel', 'Vizag']);

  // Anjali reads Hindi, so her own titles are in Hindi.
  doc('doc_coco_invoice', 'pet_coco', 'invoice', day(60), title: 'क्लिनिक का बिल', tags: ['बिल']);
  doc('doc_coco_lab', 'pet_coco', 'lab_report', day(60), title: 'खून की जाँच (CBC)', tags: ['जाँच']);
  doc('doc_tiger_rabies', 'pet_tiger', 'rabies_certificate', day(356), title: 'रेबीज़ टीका प्रमाणपत्र', tags: ['rabies']);
  doc('doc_tiger_lab', 'pet_tiger', 'lab_report', day(60), title: 'किडनी जाँच रिपोर्ट', tags: ['किडनी']);
  doc('doc_tiger_adoption', 'pet_tiger', 'adoption', after(birthday('pet_tiger'), 90), title: 'गोद लेने के कागज़', tags: ['adoption']);

  // Max: policy renewing in 20 days (matches his renewal reminder),
  // booster certificates and a Goa trip certificate that has expired.
  final maxRenewal = DateTime(now.year, now.month, now.day + 20);
  final maxPolicyStart = DateTime(maxRenewal.year - 1, maxRenewal.month, maxRenewal.day + 1);
  doc('doc_max_policy', 'pet_max', 'insurance_policy', maxPolicyStart, title: 'Shield Pet Cover (sample) policy', tags: ['insurance']);
  doc('doc_max_dhppi', 'pet_max', 'dhppi_certificate', day(240), title: 'DHPPi + Lepto certificate', tags: ['dhppi']);
  doc('doc_max_rabies', 'pet_max', 'rabies_certificate', day(240), title: 'Anti-rabies certificate', tags: ['rabies']);
  doc('doc_max_travel', 'pet_max', 'travel', day(150), title: 'Travel certificate (Goa trip)', tags: ['travel', 'Goa']);
  final lunaBorn = birthday('pet_luna');
  doc('doc_luna_dhppi', 'pet_luna', 'dhppi_certificate', after(lunaBorn, 45), title: 'DHPPi + Lepto certificate', tags: ['dhppi', 'dose 1']);
  doc('doc_luna_adoption', 'pet_luna', 'adoption', after(lunaBorn, 60), title: 'Adoption papers', tags: ['adoption']);

  // Link certificates to the matching vaccine records on the health tab.
  void linkCertificate(String petId, String templateKey, DateTime given, String docId) {
    for (final v in data['vaccinations']!.values) {
      final g = v['givenDate'] as DateTime;
      if (v['petId'] == petId && v['templateKey'] == templateKey && g.year == given.year && g.month == given.month && g.day == given.day) {
        v['certificateDocId'] = docId;
      }
    }
  }

  linkCertificate('pet_bruno', 'rabies_booster', brunoBooster, 'doc_bruno_rabies');
  linkCertificate('pet_bruno', 'dhppi_booster', brunoBooster, 'doc_bruno_dhppi');
  linkCertificate('pet_misty', 'rabies_booster', day(300), 'doc_misty_rabies');
  linkCertificate('pet_simba', 'dhppi_1', after(simbaBorn, 45), 'doc_simba_dhppi');
  linkCertificate('pet_tiger', 'rabies_booster', day(356), 'doc_tiger_rabies');
  linkCertificate('pet_max', 'dhppi_booster', day(240), 'doc_max_dhppi');
  linkCertificate('pet_max', 'rabies_booster', day(240), 'doc_max_rabies');
  linkCertificate('pet_luna', 'dhppi_1', after(lunaBorn, 45), 'doc_luna_dhppi');

  // ---------- insurance ----------

  Map<String, bool> checklist(Set<String> done) => {
    for (final k in ['claim_form', 'vet_bills', 'prescription', 'lab_reports', 'policy_copy', 'pet_photo', 'id_proof']) k: done.contains(k),
  };

  Map<String, dynamic> policy(String petId, String docId, String planName, DateTime start) {
    final p = pet(petId);
    final printed = printedSample('insurance_policy', p['name'] as String, start);
    return {
      'petId': petId,
      'ownerId': p['ownerId'],
      'provider': printed['insurer'],
      'planName': planName,
      'policyNo': printed['policyNo'],
      'cover': printed['cover'],
      'premium': printed['premium'],
      'start': printed['coverStart'],
      'renewal': printed['expiry'],
      'docId': docId,
      'createdAt': DateTime(start.year, start.month, start.day, 19),
    };
  }

  add('insurance', 'ins_bruno', {
    ...policy('pet_bruno', 'doc_bruno_policy', 'Comprehensive', brunoPolicyStart),
    'claims': [
      {
        'id': 'clm_bruno_ear',
        'title': 'Ear infection treatment',
        'date': earVisit,
        'amount': 1850,
        'settledAmount': null,
        'status': 'in_review',
        'checklist': checklist({'claim_form', 'vet_bills', 'lab_reports', 'policy_copy', 'pet_photo'}),
        'attachments': {'vet_bills': 'doc_bruno_invoice', 'lab_reports': 'doc_bruno_lab', 'policy_copy': 'doc_bruno_policy'},
        'notes': 'Insurer said they will reply within 7 working days.',
      },
      {
        'id': 'clm_bruno_paw',
        'title': 'Paw cut, stitches',
        'date': day(160),
        'amount': 4200,
        'settledAmount': 3800,
        'status': 'paid',
        'checklist': checklist({'claim_form', 'vet_bills', 'prescription', 'policy_copy', 'pet_photo', 'id_proof'}),
        'attachments': {'policy_copy': 'doc_bruno_policy'},
        'notes': '₹400 deducted as co-pay.',
      },
    ],
  });
  add('insurance', 'ins_max', {
    ...policy('pet_max', 'doc_max_policy', 'Senior care', maxPolicyStart),
    'claims': [
      {
        'id': 'clm_max_joint',
        'title': 'Joint X-ray and medicines',
        'date': day(90),
        'amount': 5200,
        'settledAmount': 4680,
        'status': 'paid',
        'checklist': checklist({'claim_form', 'vet_bills', 'prescription', 'lab_reports', 'policy_copy', 'id_proof'}),
        'attachments': {'policy_copy': 'doc_max_policy'},
        'notes': null,
      },
      {
        'id': 'clm_max_televet',
        'title': 'Tele-vet video consultation',
        'date': day(15),
        'amount': 269,
        'settledAmount': null,
        'status': 'draft',
        'checklist': checklist({'policy_copy'}),
        'attachments': {'policy_copy': 'doc_max_policy'},
        'notes': null,
      },
    ],
  });

  // ---------- share links ----------
  // Tokens are the document ids (random in the app; fixed here so the demo
  // guide can name them). Device names match accessDeviceLabel().

  void link(String token, String petId, Map<String, dynamic> fields) {
    final p = pet(petId);
    final owner = p['ownerId'] as String;
    add('shareLinks', token, {
      'ownerId': owner,
      'ownerName': people[owner]!.split(' ').first,
      'petId': petId,
      'petName': p['name'],
      'kind': 'docs',
      'docIds': <String>[],
      'albumName': null,
      'expiresAt': null,
      'pinHash': null,
      'revoked': false,
      'revokedAt': null,
      'accessLog': <Map<String, dynamic>>[],
      ...fields,
    });
  }

  // Active: Bruno's vaccine papers and lab report for a new vet, 7 days.
  link('BrunoVetVisitDemoK7q2X', 'pet_bruno', {
    'docIds': ['doc_bruno_rabies', 'doc_bruno_dhppi', 'doc_bruno_lab'],
    'createdAt': day(2, 9, 30),
    'expiresAt': day(-5, 9, 30),
    'accessLog': [
      {'at': day(2, 11, 4), 'device': 'Web browser', 'ok': true},
      {'at': day(1, 16, 40), 'device': 'Android app', 'ok': true},
    ],
  });
  // Revoked: the policy shared with an insurance agent.
  link('BrunoPolicyAgentDemoR4w', 'pet_bruno', {
    'docIds': ['doc_bruno_policy'],
    'createdAt': day(20, 15),
    'revoked': true,
    'revokedAt': day(18, 10, 15),
    'accessLog': [
      {'at': day(20, 16, 2), 'device': 'Web browser', 'ok': true},
    ],
  });
  // Family album link with a PIN (2580), no expiry.
  link('BrunoFamilyAlbumDemo8pZ', 'pet_bruno', {
    'kind': 'album',
    'createdAt': day(7, 20),
    'pinHash': hashPin('2580', salt: List<int>.generate(16, (i) => (i * 37 + 11) % 256)),
    'accessLog': [
      {'at': day(6, 21, 5), 'device': 'Android app', 'ok': false},
      {'at': day(6, 21, 6), 'device': 'Android app', 'ok': true},
    ],
  });
  // Expired: Max's certificates for a boarding kennel, 24 hours.
  link('MaxKennelDocsDemoE3vT9', 'pet_max', {
    'docIds': ['doc_max_dhppi', 'doc_max_rabies'],
    'createdAt': day(4, 12),
    'expiresAt': day(3, 12),
    'accessLog': [
      {'at': day(4, 12, 30), 'device': 'Web browser', 'ok': true},
    ],
  });

  // ---------- album ----------

  var albumN = 0;
  void memory(
    String petId,
    DateTime at,
    String caption, {
    String type = 'photo',
    bool fav = false,
    List<String> albums = const [],
    String? milestone,
    String? milestoneTitle,
    int durationSec = 0,
    String? by,
  }) {
    final p = pet(petId);
    final owner = p['ownerId'] as String;
    final uid = by ?? owner;
    final n = albumN++;
    final media = type != 'milestone';
    add('album', 'alb_${petId.substring(4)}_$n', {
      'petId': petId,
      'ownerId': owner,
      'type': type,
      'url': media ? 'seed:album:${p['species']}:$n' : null,
      'contentType': switch (type) {
        'video' => 'video/mp4',
        'photo' => 'image/jpeg',
        _ => null,
      },
      'storagePath': null,
      'sizeBytes': switch (type) {
        'video' => 2400000 + durationSec * 180000,
        'photo' => 900000 + (n * 137000) % 1600000,
        _ => 0,
      },
      'durationSec': durationSec,
      'caption': caption,
      'takenAt': at,
      'favourite': fav,
      'albums': albums,
      'milestone': milestone,
      'milestoneTitle': milestoneTitle,
      'byUid': uid,
      'byName': people[uid],
      'createdAt': at.add(const Duration(minutes: 25)),
    });
  }

  DateTime onDay(int yearsBack, [int hour = 17]) => DateTime(now.year - yearsBack, now.month, now.day, hour);
  DateTime birthdayIn(String petId, int yearsAfterBirth) {
    final b = birthday(petId);
    return DateTime(b.year + yearsAfterBirth, b.month, b.day, 16);
  }

  // Bruno (17): puppy milestones, two birthdays, a beach trip exactly one
  // year ago ("On this day"), and photos across recent months, some added
  // by Rohan.
  final brunoBorn = birthday('pet_bruno');
  memory('pet_bruno', after(brunoBorn, 45), 'Brave boy at his first vaccine', milestone: 'first_vaccine', albums: ['Puppy days']);
  memory('pet_bruno', after(brunoBorn, 58), 'Bruno came home!', milestone: 'gotcha', fav: true, albums: ['Puppy days']);
  memory('pet_bruno', after(brunoBorn, 100, 7), 'First walk around the block', milestone: 'first_walk', albums: ['Puppy days']);
  memory('pet_bruno', after(brunoBorn, 150), '', type: 'milestone', milestone: 'custom', milestoneTitle: 'Learned to sit and shake hands');
  memory('pet_bruno', birthdayIn('pet_bruno', 2), 'Second birthday', milestone: 'birthday', albums: ['Birthdays']);
  memory('pet_bruno', onDay(1, 8), 'First time at the beach in Gokarna', fav: true, albums: ['Beach days']);
  memory('pet_bruno', onDay(1, 9), 'Chasing the waves', type: 'video', durationSec: 24, albums: ['Beach days']);
  memory('pet_bruno', day(200, 18), 'Muddy paws after the rain');
  memory('pet_bruno', day(150, 17), 'Learning to fetch');
  memory('pet_bruno', day(120, 9), 'Sunday swim at the pool', albums: ['Beach days']);
  memory('pet_bruno', day(80, 19), 'Playing with Misty', fav: true);
  memory('pet_bruno', birthdayIn('pet_bruno', 3), 'Third birthday, cake from the pet bakery', milestone: 'birthday', fav: true, albums: ['Birthdays']);
  memory('pet_bruno', day(38, 18), 'Rainy day zoomies', type: 'video', durationSec: 18, by: 'u_rohan');
  memory('pet_bruno', day(23, 12), 'New red collar', fav: true);
  memory('pet_bruno', day(9, 15), 'Nap after the bath');
  memory('pet_bruno', day(2, 7), 'Morning walk in Cubbon Park', by: 'u_rohan');
  memory('pet_bruno', day(0, 8), 'Breakfast face');

  // Misty (5).
  memory('pet_misty', after(birthday('pet_misty'), 70), 'Tiny Misty on her first day home', milestone: 'gotcha', fav: true);
  memory('pet_misty', onDay(1, 18), 'Fourth birthday, tuna treat', milestone: 'birthday', albums: ['Birthdays']);
  memory('pet_misty', day(75, 16), 'Window watching');
  memory('pet_misty', day(30, 20), 'Brushing time', by: 'u_rohan');
  memory('pet_misty', day(4, 14), 'Sunbeam nap', fav: true);

  // Simba (Ravi writes in Telugu).
  memory('pet_simba', after(simbaBorn, 40), 'సింబా ఇంటికి వచ్చాడు!', milestone: 'gotcha', fav: true);
  memory('pet_simba', after(simbaBorn, 45), 'మొదటి టీకా, ధైర్యంగా ఉన్నాడు', milestone: 'first_vaccine');
  memory('pet_simba', after(simbaBorn, 100, 7), 'మొదటి వాక్', milestone: 'first_walk');
  memory('pet_simba', day(14, 18), 'తోక వెంట పరుగు', type: 'video', durationSec: 12);
  memory('pet_simba', day(6, 11), 'స్నానం టైమ్');
  memory('pet_simba', day(1, 20), 'మళ్ళీ నా చెప్పు కొరికాడు', fav: true);
  memory('pet_kiwi', after(birthday('pet_kiwi'), 90), 'కీవీ ఇంటికి వచ్చాడు', milestone: 'gotcha');
  memory('pet_kiwi', day(45, 9), 'కొత్త పంజరం');
  memory('pet_kiwi', day(3, 7), 'ఉదయం ఈల పాట', type: 'video', durationSec: 9, fav: true);

  // Coco and Tiger (Anjali writes in Hindi).
  memory('pet_coco', after(birthday('pet_coco'), 75), 'कोको घर आई', milestone: 'gotcha', fav: true);
  memory('pet_coco', day(28, 17), 'बगीचे में कूद-फांद');
  memory('pet_coco', day(5, 10), 'गाजर का नाश्ता');
  memory('pet_tiger', after(birthday('pet_tiger'), 90), 'टाइगर का पहला दिन', milestone: 'gotcha');
  memory('pet_tiger', day(40, 13), 'पुराना दोस्त, नया कंबल', fav: true);
  memory('pet_tiger', day(8, 15), 'धूप में आराम');

  // Max, Luna and Sheru (Arjun; Meera is Max's sitter this week).
  memory('pet_max', after(birthday('pet_max'), 60), 'Max joins the family', milestone: 'gotcha');
  memory('pet_max', onDay(1, 19), 'Sixth birthday', milestone: 'birthday', fav: true);
  memory('pet_max', day(47, 18), 'Fetch at Shivaji Park', type: 'video', durationSec: 30);
  memory('pet_max', day(33, 17), 'Sitting pretty for the camera', fav: true);
  memory('pet_max', day(12, 7), 'Juhu beach morning run', albums: ['Beach days']);
  memory('pet_max', day(1, 18), 'Evening walk with Meera', by: 'u_meera');
  memory('pet_luna', after(lunaBorn, 45), 'First vaccine done', milestone: 'first_vaccine');
  memory('pet_luna', after(lunaBorn, 60), 'Luna joins the family', milestone: 'gotcha', fav: true);
  memory('pet_luna', after(lunaBorn, 100, 7), 'First walk', milestone: 'first_walk');
  memory('pet_luna', day(3, 10), 'Puppy school, day one');
  final sheruBorn = birthday('pet_sheru');
  memory('pet_sheru', DateTime(sheruBorn.year, sheruBorn.month + 2, 1, 12), 'Our first boy comes home', milestone: 'gotcha', fav: true);
  memory('pet_sheru', DateTime(now.year - 4, 7, 21, 18), 'Monsoon walk');
  memory('pet_sheru', DateTime(now.year - 3, 1, 14, 9), 'His favourite step in the sun', fav: true);
  memory('pet_sheru', DateTime(now.year - 1, sheruBorn.month, sheruBorn.day, 16), 'Last birthday together', milestone: 'birthday');
}

/// What vault sample document [key] prints when made out for [petName] on
/// [issuedOn]. Same values as sampleDetails() in
/// lib/features/vault/domain/auto_read.dart (pure Dart here so the emulator
/// seed tool can run without Flutter).
Map<String, dynamic> printedSample(String key, String petName, DateTime issuedOn) {
  final on = DateTime(issuedOn.year, issuedOn.month, issuedOn.day);
  DateTime plusYear(DateTime d) => DateTime(d.year + 1, d.month, d.day);
  const vet = {'vetName': 'Dr. Ananya Rao', 'vetRegNo': 'DEMO-VC-0107', 'clinicName': 'Gulmohar Vet Studio'};
  final Map<String, dynamic> m = switch (key) {
    'rabies_certificate' || 'dhppi_certificate' || 'fvrcp_certificate' => {
      'vaccineName': switch (key) {
        'dhppi_certificate' => 'DHPPi + Lepto',
        'fvrcp_certificate' => 'FVRCP',
        _ => 'Anti-rabies',
      },
      'brand': switch (key) {
        'dhppi_certificate' => 'Vaxipet (sample)',
        'fvrcp_certificate' => 'Felivax (sample)',
        _ => 'Rabivet (sample)',
      },
      'batch': switch (key) {
        'dhppi_certificate' => 'SAMPLE-DP-1180',
        'fvrcp_certificate' => 'SAMPLE-FV-3307',
        _ => 'SAMPLE-RB-2291',
      },
      'dateGiven': on,
      'nextDue': plusYear(on),
      'expiry': plusYear(on),
      ...vet,
    },
    'insurance_policy' => {
      'insurer': 'Shield Pet Cover (sample)',
      'policyNo': 'SAMPLE-PI-${20431 + petName.length}',
      'cover': 100000,
      'premium': 6499,
      'coverStart': on,
      'expiry': plusYear(on).subtract(const Duration(days: 1)),
    },
    'lab_report' => {
      'testName': 'Complete blood count (CBC)',
      'clinicName': 'Sample Diagnostics Lab',
      'vetName': 'Dr. Ananya Rao',
      'dateGiven': on,
    },
    'invoice' => {'clinicName': 'Gulmohar Vet Studio', 'referenceNo': 'SAMPLE-INV-5521', 'amount': 1850},
    'licence' => {'issuer': 'Municipal Corporation (sample)', 'referenceNo': 'SAMPLE-LIC-0912', 'expiry': plusYear(on)},
    'adoption' => {'issuer': 'Happy Tails Shelter (sample)', 'referenceNo': 'SAMPLE-AD-4410'},
    'travel' => {'issuer': 'Animal Quarantine Office (sample)', 'referenceNo': 'SAMPLE-TR-7731', 'expiry': on.add(const Duration(days: 30))},
    'prescription' => {...vet},
    _ => <String, dynamic>{},
  };
  return {'type': sampleType(key), 'petName': petName, ...m, 'issuedOn': on};
}

/// Document type of a sample (sampleDocType() in auto_read.dart).
String sampleType(String key) => switch (key) {
  'rabies_certificate' || 'dhppi_certificate' || 'fvrcp_certificate' => 'vaccination',
  'insurance_policy' => 'insurance',
  'lab_report' => 'lab',
  'invoice' || 'licence' || 'adoption' || 'travel' || 'prescription' => key,
  _ => 'other',
};
