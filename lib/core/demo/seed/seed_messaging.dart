import 'seed.dart';

/// Phase 6: chat threads (with photos, a PDF and a voice note), tele-vet
/// consultations with chat history and prescriptions, and Ask PawSetu
/// history. Conversation ids follow lib/features/messaging/domain/chat_rules.dart.
void seedMessaging(Add add, DateTime now, SeedData data) {
  DateTime ago({int d = 0, int h = 0, int m = 0}) => now.subtract(Duration(days: d, hours: h, minutes: m));
  final monthStart = DateTime(now.year, now.month);
  // Times that must fall in the current month (monthly allowances).
  DateTime thisMonth({int h = 0, int m = 0}) {
    final t = ago(h: h, m: m);
    return t.isBefore(monthStart) ? monthStart.add(Duration(minutes: 5 + m)) : t;
  }

  final halfHour = DateTime(now.year, now.month, now.day, now.hour, now.minute < 30 ? 30 : 60);
  Map<String, dynamic> vet(String id) => data['vets']![id]!;
  Map<String, dynamic> clinic(String id) => data['clinics']![id]!;
  Map<String, dynamic> pet(String id) => data['pets']![id]!;
  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  String dateText(DateTime d) => '${d.day} ${months[d.month - 1]} ${d.year}';

  var msgN = 0;
  Map<String, dynamic> msg(
    String from,
    String name,
    DateTime at, {
    String type = 'text',
    String text = '',
    String? url,
    String? fileName,
    int? sizeBytes,
    int? durationSec,
    String? event,
    Map<String, dynamic>? meta,
    String? prescriptionId,
    List<String>? readBy,
  }) => {
    'senderId': from,
    'senderName': name,
    'type': type,
    'text': text,
    'url': url,
    'fileName': fileName,
    'sizeBytes': sizeBytes,
    'durationSec': durationSec,
    'event': event,
    'meta': meta,
    'prescriptionId': prescriptionId,
    'demo': false,
    'masked': false,
    'createdAt': at,
    'readBy': readBy ?? [from],
  };
  Map<String, dynamic> sys(String event, DateTime at, Map<String, dynamic> meta, List<String> readBy) =>
      msg('system', '', at, type: 'system', event: event, meta: meta, readBy: readBy);

  String preview(Map<String, dynamic> m) => switch (m['type']) {
    'text' => m['text'] as String,
    'pdf' => (m['fileName'] as String?) ?? '',
    _ => (m['text'] as String?) ?? '',
  };

  void conversation(String id, Map<String, dynamic> c, List<Map<String, dynamic>> msgs, {Map<String, int> unread = const {}}) {
    final last = msgs.lastWhere((m) => m['type'] != 'system', orElse: () => msgs.last);
    add('conversations', id, {
      ...c,
      'lastMessage': preview(last),
      'lastType': last['type'],
      'lastSenderId': last['senderId'],
      'lastAt': msgs.last['createdAt'],
      'createdAt': msgs.first['createdAt'],
      'unread': unread,
      'muted': <String, bool>{},
      'blockedBy': <String>[],
      'typing': <String, Object?>{},
    });
    for (final m in msgs) {
      add('messages', 'msg_seed_${msgN++}', {'conversationId': id, ...m});
    }
  }

  Map<String, dynamic> bookingChat({
    required String bookingId,
    required String ownerId,
    required String ownerName,
    required Map<String, (String name, String role)> partners,
    required String providerId,
    required String providerName,
    required String kind,
    required String petId,
    required String petName,
    String petSpecies = 'dog',
  }) => {
    'type': 'chat',
    'participantIds': [ownerId, ...partners.keys],
    'participants': {
      ownerId: {'name': ownerName, 'role': 'owner'},
      for (final p in partners.entries) p.key: {'name': p.value.$1, 'role': p.value.$2},
    },
    'ownerId': ownerId,
    'ownerName': ownerName,
    'providerId': providerId,
    'providerName': providerName,
    'providerKind': kind,
    'providerPhone': null,
    'petId': petId,
    'petName': petName,
    'petSpecies': petSpecies,
    'bookingId': bookingId,
  };

  // ---------------- Booking chats ----------------
  const sameer = 'Dr. Sameer Khan';
  final simbaVisit = halfHour.add(const Duration(hours: 2));
  conversation(
    'chat_bk_seed_r2',
    bookingChat(
      bookingId: 'bk_seed_r2',
      ownerId: 'u_ravi',
      ownerName: 'Ravi Teja',
      partners: {'u_clinicadmin': ('Golconda Gate Pet Clinic', 'clinic'), 'u_vet': (sameer, 'vet')},
      providerId: 'clinic_hyd_1',
      providerName: 'Golconda Gate Pet Clinic',
      kind: 'clinic',
      petId: 'pet_simba',
      petName: 'Simba',
    ),
    [
      sys('booking_chat', ago(h: 5), {'petName': 'Simba', 'service': 'Consultation', 'start': simbaVisit}, ['u_ravi', 'u_clinicadmin', 'u_vet']),
      msg(
        'u_ravi',
        'Ravi Teja',
        ago(h: 4, m: 10),
        text: 'నమస్తే, సింబా రెండు రోజులుగా చెవులు గోక్కుంటోంది. ఈరోజు చూపించడానికి వస్తున్నాను.',
        readBy: ['u_ravi', 'u_clinicadmin', 'u_vet'],
      ),
      msg('u_ravi', 'Ravi Teja', ago(h: 4, m: 9), type: 'photo', url: 'seed:album:dog:3', readBy: ['u_ravi', 'u_clinicadmin', 'u_vet']),
      msg(
        'u_clinicadmin',
        'Golconda Gate Pet Clinic',
        ago(h: 3, m: 30),
        text: 'Thanks Ravi. Dr. Sameer will see Simba. Please don\'t clean his ears before the visit so the doctor can check them properly.',
        readBy: ['u_clinicadmin', 'u_ravi'],
      ),
      msg(
        'u_vet',
        sameer,
        ago(h: 1, m: 5),
        text: 'Please also bring his vaccination card. His DHPPi dose is overdue and we can give it today if he is well.',
        readBy: ['u_vet'],
      ),
    ],
    unread: {'u_ravi': 1, 'u_clinicadmin': 1},
  );

  conversation(
    'chat_bk_seed_r1',
    bookingChat(
      bookingId: 'bk_seed_r1',
      ownerId: 'u_ravi',
      ownerName: 'Ravi Teja',
      partners: {'u_walker': ('Imran Walks', 'walker')},
      providerId: 'prov_walk_1',
      providerName: 'Imran Walks',
      kind: 'walker',
      petId: 'pet_simba',
      petName: 'Simba',
    ),
    [
      sys('booking_chat', ago(d: 1, h: 2), {'petName': 'Simba', 'service': '60-minute walk', 'start': ago(m: 20)}, ['u_ravi', 'u_walker']),
      msg(
        'u_ravi',
        'Ravi Teja',
        ago(d: 1, h: 1),
        text: 'Simba pulls a lot near the park gate. Please hold the leash short there.',
        readBy: ['u_ravi', 'u_walker'],
      ),
      msg('u_walker', 'Imran Walks', ago(d: 1, m: 50), text: 'Sure Ravi ji, will do. See you tomorrow!', readBy: ['u_walker', 'u_ravi']),
      msg('u_walker', 'Imran Walks', ago(m: 15), type: 'voice', url: 'seed:voice:1', durationSec: 14),
      msg('u_walker', 'Imran Walks', ago(m: 8), type: 'photo', url: 'seed:album:dog:3'),
      msg('u_walker', 'Imran Walks', ago(m: 8), text: 'Simba met two friends at the park and is having a great time!'),
    ],
    unread: {'u_ravi': 3},
  );

  conversation(
    'chat_bk_seed_p2',
    bookingChat(
      bookingId: 'bk_seed_p2',
      ownerId: 'u_priya',
      ownerName: 'Priya Sharma',
      partners: {'p_clinic_blr_1': ('Gulmohar Vet Studio', 'clinic')},
      providerId: 'clinic_blr_1',
      providerName: 'Gulmohar Vet Studio',
      kind: 'clinic',
      petId: 'pet_misty',
      petName: 'Misty',
      petSpecies: 'cat',
    ),
    [
      sys(
        'booking_chat',
        ago(d: 1, h: 3),
        {'petName': 'Misty', 'service': 'Vaccination', 'start': DateTime(now.year, now.month, now.day + 3, 11)},
        ['u_priya'],
      ),
      msg('u_priya', 'Priya Sharma', ago(d: 1, h: 2), text: 'Hi! Should Misty skip breakfast before her vaccination?', readBy: ['u_priya', 'p_clinic_blr_1']),
      msg(
        'p_clinic_blr_1',
        'Gulmohar Vet Studio',
        ago(d: 1, h: 1),
        text: 'No need to fast for vaccines. A light meal is fine. Please bring her previous vaccination card.',
        readBy: ['p_clinic_blr_1', 'u_priya'],
      ),
      msg(
        'u_priya',
        'Priya Sharma',
        ago(d: 1, m: 40),
        type: 'pdf',
        url: 'seed:pdf:misty_card',
        fileName: 'Misty-vaccination-card.pdf',
        sizeBytes: 182400,
        readBy: ['u_priya', 'p_clinic_blr_1'],
      ),
      msg(
        'p_clinic_blr_1',
        'Gulmohar Vet Studio',
        ago(d: 1, m: 20),
        text: 'Got it, thank you! See you at the appointment.',
        readBy: ['p_clinic_blr_1', 'u_priya'],
      ),
    ],
  );

  conversation(
    'chat_bk_seed_a1',
    bookingChat(
      bookingId: 'bk_seed_a1',
      ownerId: 'u_anjali',
      ownerName: 'Anjali Verma',
      partners: {'p_clinic_del_2': ('Cyber City Vet Care', 'clinic')},
      providerId: 'clinic_del_2',
      providerName: 'Cyber City Vet Care',
      kind: 'clinic',
      petId: 'pet_tiger',
      petName: 'Tiger',
      petSpecies: 'cat',
    ),
    [
      sys('booking_chat', ago(h: 5), {'petName': 'Tiger', 'service': 'Consultation', 'start': DateTime(now.year, now.month, now.day + 1, 10)}, ['u_anjali']),
      msg(
        'u_anjali',
        'Anjali Verma',
        ago(h: 4, m: 50),
        text: 'नमस्ते, टाइगर दो दिन से ठीक से नहीं खा रहा। क्या सुबह का समय मिल सकता है?',
        readBy: ['u_anjali', 'p_clinic_del_2'],
      ),
      msg(
        'p_clinic_del_2',
        'Cyber City Vet Care',
        ago(h: 3),
        text: 'Namaste Anjali ji. Tomorrow morning is full, so we have suggested 5 PM. Please accept it in the app if that works for you.',
      ),
    ],
    unread: {'u_anjali': 1},
  );

  conversation(
    'chat_bk_seed_m1',
    bookingChat(
      bookingId: 'bk_seed_m1',
      ownerId: 'u_arjun',
      ownerName: 'Arjun Mehta',
      partners: {'p_prov_board_3': ('Chembur Cosy Kennels', 'boarder')},
      providerId: 'prov_board_3',
      providerName: 'Chembur Cosy Kennels',
      kind: 'boarder',
      petId: 'pet_max',
      petName: 'Max',
    ),
    [
      sys(
        'booking_chat',
        ago(d: 2, h: 1),
        {'petName': 'Max', 'service': 'Boarding (per night)', 'start': DateTime(now.year, now.month, now.day - 2, 10)},
        ['u_arjun'],
      ),
      msg(
        'u_arjun',
        'Arjun Mehta',
        ago(d: 2),
        text: 'Max needs his joint supplement with breakfast. It\'s in the blue box in his bag.',
        readBy: ['u_arjun', 'p_prov_board_3'],
      ),
      msg(
        'p_prov_board_3',
        'Chembur Cosy Kennels',
        ago(d: 1, h: 23),
        text: 'Noted, we\'ll give it with breakfast every day.',
        readBy: ['p_prov_board_3', 'u_arjun'],
      ),
      msg('p_prov_board_3', 'Chembur Cosy Kennels', ago(d: 1, h: 14), type: 'photo', url: 'seed:album:dog:5', readBy: ['p_prov_board_3', 'u_arjun']),
      msg(
        'p_prov_board_3',
        'Chembur Cosy Kennels',
        ago(d: 1, h: 14),
        text: 'Morning run in the garden, then a nap in the sun.',
        readBy: ['p_prov_board_3', 'u_arjun'],
      ),
    ],
  );

  // Enquiry before booking.
  conversation(
    'enq_prov_groom_3_u_priya',
    {
      'type': 'enquiry',
      'participantIds': ['u_priya', 'p_prov_groom_3'],
      'participants': {
        'u_priya': {'name': 'Priya Sharma', 'role': 'owner'},
        'p_prov_groom_3': {'name': 'Bubble Paws Salon', 'role': 'groomer'},
      },
      'ownerId': 'u_priya',
      'ownerName': 'Priya Sharma',
      'ownerPhone': '+91 90000 00001',
      'providerId': 'prov_groom_3',
      'providerName': 'Bubble Paws Salon',
      'providerKind': 'groomer',
      'providerPhone': null,
      'petId': 'pet_misty',
      'petName': 'Misty',
      'petSpecies': 'cat',
    },
    [
      msg('u_priya', 'Priya Sharma', ago(d: 6, h: 2), text: 'Hi, do you groom Persian cats too? Misty has a long coat.', readBy: ['u_priya', 'p_prov_groom_3']),
      msg(
        'p_prov_groom_3',
        'Bubble Paws Salon',
        ago(d: 6, h: 1),
        text: 'Yes! We do a gentle cat groom on Tuesdays and Fridays, when the salon is quiet.',
        readBy: ['p_prov_groom_3', 'u_priya'],
      ),
    ],
  );

  // Partner side: customers without an app account (u_cust_*).
  conversation(
    'chat_bk_seed_g1',
    bookingChat(
      bookingId: 'bk_seed_g1',
      ownerId: 'u_cust_9',
      ownerName: 'Sneha Reddy',
      partners: {'u_groomer': ('Lakshmi Groom Studio', 'groomer')},
      providerId: 'prov_groom_1',
      providerName: 'Lakshmi Groom Studio',
      kind: 'groomer',
      petId: 'pet_cust_9',
      petName: 'Bella',
    ),
    [
      sys('booking_chat', ago(m: 20), {'petName': 'Bella', 'service': 'Full groom', 'start': DateTime(now.year, now.month, now.day + 1, 11)}, ['u_cust_9']),
      msg('u_cust_9', 'Sneha Reddy', ago(m: 18), text: 'Hi, Bella is scared of dryers. Could you towel-dry her, or use the lowest setting?'),
    ],
    unread: {'u_groomer': 1},
  );

  conversation(
    'chat_bk_seed_w4',
    bookingChat(
      bookingId: 'bk_seed_w4',
      ownerId: 'u_cust_16',
      ownerName: 'Pooja Shah',
      partners: {'u_walker': ('Imran Walks', 'walker')},
      providerId: 'prov_walk_1',
      providerName: 'Imran Walks',
      kind: 'walker',
      petId: 'pet_cust_w0',
      petName: 'Leo',
    ),
    [
      sys('booking_chat', ago(h: 6), {'petName': 'Leo', 'service': '30-minute walk', 'start': DateTime(now.year, now.month, now.day + 1, 7)}, ['u_cust_16']),
      msg('u_cust_16', 'Pooja Shah', ago(h: 5), text: 'Leo had his vaccine today, so a slow, short walk tomorrow please.'),
    ],
    unread: {'u_walker': 1},
  );

  conversation(
    'chat_bk_seed_c1',
    bookingChat(
      bookingId: 'bk_seed_c1',
      ownerId: 'u_cust_1',
      ownerName: 'Lakshmi Prasad',
      partners: {'u_clinicadmin': ('Golconda Gate Pet Clinic', 'clinic'), 'u_vet': (sameer, 'vet')},
      providerId: 'clinic_hyd_1',
      providerName: 'Golconda Gate Pet Clinic',
      kind: 'clinic',
      petId: 'pet_cust_1',
      petName: 'Rocky',
    ),
    [
      sys('booking_chat', ago(d: 1), {'petName': 'Rocky', 'service': 'Consultation', 'start': halfHour.add(const Duration(minutes: 30))}, ['u_cust_1']),
      msg(
        'u_cust_1',
        'Lakshmi Prasad',
        ago(h: 20),
        text: 'The rash on Rocky\'s belly is much better with the shampoo. Should we continue it?',
        readBy: ['u_cust_1', 'u_clinicadmin'],
      ),
      msg(
        'u_clinicadmin',
        'Golconda Gate Pet Clinic',
        ago(h: 19),
        text: 'Glad to hear that! Continue until the follow-up today, and Dr. Sameer will decide the next step.',
        readBy: ['u_clinicadmin', 'u_cust_1'],
      ),
    ],
  );

  // ---------------- Tele-vet consultations ----------------

  Map<String, dynamic> snapshot(String petId, {required bool full, List<Map<String, dynamic>> medicines = const []}) {
    final p = pet(petId);
    return {
      'breedId': p['breedId'],
      'breedOther': p['breedOther'],
      'birthday': p['birthday'],
      'gender': p['gender'],
      'weightKg': p['weightKg'],
      'colorTag': p['colorTag'],
      'photoUrl': p['photoUrl'],
      'neutered': p['neutered'],
      'allergies': p['allergies'],
      if (full) ...{'dietType': p['dietType'], 'temperament': p['temperament'], 'markings': p['markings'], 'medicines': medicines},
    };
  }

  List<Map<String, dynamic>> medicinesOf(String petId) => [
    for (final m in (data['medicines'] ?? const <String, Map<String, dynamic>>{}).values)
      if (m['petId'] == petId) {'name': m['name'], 'dose': m['dose'], 'unit': m['unit'], 'frequency': m['frequency']},
  ];

  final plusLimits = {'perMonth': 999, 'messages': 100, 'words': 300, 'hours': 72, 'video': true};
  final freeLimits = {'perMonth': 1, 'messages': 20, 'words': 60, 'hours': 24, 'video': false};

  void consultation(
    String id, {
    required String ownerId,
    required String ownerName,
    required String petId,
    required String plan,
    required String status,
    required String problem,
    required DateTime createdAt,
    String mode = 'chat',
    String? vetId,
    String? vetUid,
    DateTime? startedAt,
    DateTime? endedAt,
    int messagesUsed = 0,
    String? prescriptionId,
    int? rating,
    String? ratingText,
    String? recommendation,
    int fee = 0,
    int discount = 0,
  }) {
    final p = pet(petId);
    final plus = plan == 'plus';
    final v = vetId == null ? null : vet(vetId);
    final limits = plus ? plusLimits : freeLimits;
    final total = fee - discount;
    final commission = (total * 0.10).round();
    add('consultations', id, {
      'ownerId': ownerId,
      'ownerName': ownerName,
      'petId': petId,
      'petName': p['name'],
      'petSpecies': p['species'],
      'petSnapshot': snapshot(petId, full: plus, medicines: plus ? medicinesOf(petId) : const []),
      'vetId': vetId,
      'vetUid': vetUid,
      'vetName': v?['name'],
      'clinicId': v?['clinicId'],
      'clinicName': v?['clinicName'],
      'status': status,
      'mode': mode,
      'problem': problem,
      'photos': <String>[],
      'plan': plan,
      'priority': plus,
      'limits': limits,
      'messagesUsed': messagesUsed,
      'createdAt': createdAt,
      'scheduledAt': null,
      'startedAt': startedAt,
      'endsAt': startedAt?.add(Duration(hours: limits['hours'] as int)),
      'endedAt': endedAt,
      'consentAt': createdAt,
      'fee': fee,
      'discount': discount,
      'total': total,
      'commission': commission,
      'payout': total - commission,
      'paymentStatus': total > 0 ? 'paid' : 'included',
      'conversationId': 'tv_$id',
      'redFlag': null,
      'privateNotes': '',
      'prescriptionId': prescriptionId,
      'rating': rating,
      'ratingText': ratingText,
      'recommendation': recommendation,
    });
  }

  Map<String, dynamic> teleVetConversation(
    String id, {
    required String ownerId,
    required String ownerName,
    required String petId,
    String? vetUid,
    String? vetId,
  }) {
    final p = pet(petId);
    final v = vetId == null ? null : vet(vetId);
    final vu = vetUid ?? (vetId == null ? null : 'p_$vetId');
    return {
      'type': 'televet',
      'participantIds': [ownerId, ?vu],
      'participants': {
        ownerId: {'name': ownerName, 'role': 'owner'},
        ?vu: {'name': v?['name'], 'role': 'vet'},
      },
      'ownerId': ownerId,
      'ownerName': ownerName,
      'providerName': v?['name'] ?? '',
      'providerId': vetId,
      'providerKind': 'vet',
      'petId': petId,
      'petName': p['name'],
      'petSpecies': p['species'],
      'consultationId': id,
    };
  }

  void prescription(
    String rxId, {
    required String consultationId,
    required String ownerId,
    required String ownerName,
    required String ownerLang,
    required String petId,
    required String vetId,
    String? vetUid,
    required DateTime at,
    required List<Map<String, String>> items,
    required String diagnosis,
    required String notes,
    DateTime? followUp,
  }) {
    final p = pet(petId);
    final v = vet(vetId);
    final c = clinic(v['clinicId'] as String);
    final meds = items.map((i) => i['medicine']).join(', ');
    add('prescriptions', rxId, {
      'consultationId': consultationId,
      'petId': petId,
      'petName': p['name'],
      'petSpecies': p['species'],
      'petInfo': {
        'breedId': p['breedId'],
        'breedOther': p['breedOther'],
        'birthday': p['birthday'],
        'weightKg': p['weightKg'],
        'gender': p['gender'],
        'allergies': p['allergies'],
      },
      'ownerId': ownerId,
      'ownerName': ownerName,
      'vetId': vetId,
      'vetUid': vetUid,
      'vetName': v['name'],
      'qualification': v['qualification'],
      'regNo': v['regNo'],
      'clinicId': v['clinicId'],
      'clinicName': v['clinicName'],
      'clinicAddress': c['address'],
      'clinicPhone': c['phone'],
      'items': items,
      'diagnosis': diagnosis,
      'notes': notes,
      'followUp': followUp,
      'createdAt': at,
      'url': null,
      'language': ownerLang,
    });
    // The pet parent's records, as PrescriptionService.writeOwnerRecords
    // writes them (English titles: both owners here read English).
    add('documents', 'doc_$rxId', {
      'ownerId': ownerId,
      'petId': petId,
      'type': 'prescription',
      'title': 'Prescription for ${p['name']}, ${dateText(at)}',
      'tags': ['prescription', 'tele-vet'],
      'url': null,
      'contentType': 'application/pdf',
      'expiry': null,
      'extracted': {'vetName': v['name'], 'regNo': v['regNo'], 'date': at, 'medicines': meds},
      'prescriptionId': rxId,
      'consultationId': consultationId,
      'link': '/prescriptions/$rxId',
      'createdAt': at,
    });
    add('healthEvents', 'he_$rxId', {
      'petId': petId,
      'type': 'vet_visit',
      'date': at,
      'nextDue': followUp,
      'title': 'Tele-vet consultation with ${v['name']}',
      'clinicName': v['clinicName'],
      'diagnosis': diagnosis,
      'notes': 'Prescribed: $meds',
      'prescriptionId': rxId,
      'consultationId': consultationId,
      'docId': 'doc_$rxId',
      'link': '/prescriptions/$rxId',
      'source': 'televet',
      'byUid': vetUid,
      'createdAt': at,
    });
  }

  // 1. Bruno, 12 days ago: limping. Ended with a prescription and a rating.
  final b1 = ago(d: 12, h: 3);
  consultation(
    'tvc_seed_bruno_old',
    ownerId: 'u_priya',
    ownerName: 'Priya Sharma',
    petId: 'pet_bruno',
    plan: 'plus',
    status: 'ended',
    problem: 'Bruno is limping on his front left leg since running on the beach yesterday.',
    createdAt: b1,
    vetId: 'vet_hyd_1_a',
    vetUid: 'u_vet',
    startedAt: b1.add(const Duration(minutes: 6)),
    endedAt: b1.add(const Duration(minutes: 41)),
    messagesUsed: 3,
    prescriptionId: 'rx_seed_bruno_1',
    rating: 5,
    ratingText: 'Very clear advice. Bruno is running again!',
  );
  prescription(
    'rx_seed_bruno_1',
    consultationId: 'tvc_seed_bruno_old',
    ownerId: 'u_priya',
    ownerName: 'Priya Sharma',
    ownerLang: 'en',
    petId: 'pet_bruno',
    vetId: 'vet_hyd_1_a',
    vetUid: 'u_vet',
    at: b1.add(const Duration(minutes: 35)),
    items: [
      {
        'medicine': 'Meloxicam oral suspension (SAMPLE)',
        'dose': 'As marked on the syringe',
        'frequency': 'Once a day',
        'duration': '5 days',
        'instructions': 'After food',
      },
    ],
    diagnosis: 'Mild sprain, left wrist (carpus)',
    notes: 'Rest for 5 days: short toilet walks only, no running, jumping or stairs. Cold compress for 10 minutes twice a day. Book a clinic visit if the limp is not better in 3 days.',
    followUp: b1.add(const Duration(days: 7)),
  );
  add('reviews', 'rev_seed_vet_1', {
    'targetType': 'vet',
    'targetId': 'vet_hyd_1_a',
    'ownerId': 'u_priya',
    'ownerName': 'Priya Sharma',
    'consultationId': 'tvc_seed_bruno_old',
    'rating': 5,
    'text': 'Very clear advice. Bruno is running again!',
    'status': 'visible',
    'reply': null,
    'createdAt': b1.add(const Duration(hours: 2)),
  });
  conversation(
    'tv_tvc_seed_bruno_old',
    teleVetConversation('tvc_seed_bruno_old', ownerId: 'u_priya', ownerName: 'Priya Sharma', petId: 'pet_bruno', vetUid: 'u_vet', vetId: 'vet_hyd_1_a'),
    [
      sys('tv_started', b1, {'mode': 'chat'}, ['u_priya', 'u_vet']),
      msg(
        'u_priya',
        'Priya Sharma',
        b1.add(const Duration(milliseconds: 1)),
        text: 'Bruno is limping on his front left leg since running on the beach yesterday.',
        meta: {'problem': true},
        readBy: ['u_priya', 'u_vet'],
      ),
      msg(
        'u_priya',
        'Priya Sharma',
        b1.add(const Duration(milliseconds: 2)),
        type: 'photo',
        url: 'seed:album:dog:1',
        meta: {'problem': true},
        readBy: ['u_priya', 'u_vet'],
      ),
      sys('tv_joined', b1.add(const Duration(minutes: 6)), {'name': sameer, 'endsAt': b1.add(const Duration(minutes: 6, hours: 72))}, ['u_priya', 'u_vet']),
      msg(
        'u_vet',
        sameer,
        b1.add(const Duration(minutes: 7)),
        text: 'Hello Priya, I\'m Dr. Sameer. Is Bruno putting weight on the leg? Any swelling, or does he cry when you touch the wrist?',
        readBy: ['u_vet', 'u_priya'],
      ),
      msg(
        'u_priya',
        'Priya Sharma',
        b1.add(const Duration(minutes: 12)),
        text: 'He puts weight on it but limps. No swelling, a little sore near the wrist.',
        readBy: ['u_priya', 'u_vet'],
      ),
      msg(
        'u_vet',
        sameer,
        b1.add(const Duration(minutes: 20)),
        text: 'That sounds like a mild sprain. Rest him for 5 days: short toilet walks only, no running or stairs. I\'m sending a prescription for a pet-safe anti-inflammatory.',
        readBy: ['u_vet', 'u_priya'],
      ),
      msg(
        'u_vet',
        sameer,
        b1.add(const Duration(minutes: 35)),
        type: 'prescription',
        prescriptionId: 'rx_seed_bruno_1',
        text: 'Mild sprain, left wrist (carpus)',
        readBy: ['u_vet', 'u_priya'],
      ),
      msg('u_priya', 'Priya Sharma', b1.add(const Duration(minutes: 38)), text: 'Thank you, doctor!', readBy: ['u_priya', 'u_vet']),
      sys('tv_ended', b1.add(const Duration(minutes: 41)), {'by': sameer}, ['u_priya', 'u_vet']),
    ],
  );

  // 2. Bruno, now: vomited after eating grass. Open, so the vet demo
  // account can write a prescription that lands in Bruno's records.
  final b2 = ago(m: 40);
  consultation(
    'tvc_seed_bruno_now',
    ownerId: 'u_priya',
    ownerName: 'Priya Sharma',
    petId: 'pet_bruno',
    plan: 'plus',
    status: 'active',
    problem: 'Bruno vomited twice this morning after eating grass in the park. He is drinking water and wants to play.',
    createdAt: b2,
    vetId: 'vet_hyd_1_a',
    vetUid: 'u_vet',
    startedAt: b2.add(const Duration(minutes: 4)),
    messagesUsed: 2,
  );
  conversation(
    'tv_tvc_seed_bruno_now',
    teleVetConversation('tvc_seed_bruno_now', ownerId: 'u_priya', ownerName: 'Priya Sharma', petId: 'pet_bruno', vetUid: 'u_vet', vetId: 'vet_hyd_1_a'),
    [
      sys('tv_started', b2, {'mode': 'chat'}, ['u_priya', 'u_vet']),
      msg(
        'u_priya',
        'Priya Sharma',
        b2.add(const Duration(milliseconds: 1)),
        text: 'Bruno vomited twice this morning after eating grass in the park. He is drinking water and wants to play.',
        meta: {'problem': true},
        readBy: ['u_priya', 'u_vet'],
      ),
      sys('tv_joined', b2.add(const Duration(minutes: 4)), {'name': sameer, 'endsAt': b2.add(const Duration(minutes: 4, hours: 72))}, ['u_priya', 'u_vet']),
      msg(
        'u_vet',
        sameer,
        b2.add(const Duration(minutes: 6)),
        text: 'Hi Priya, thanks for the details. When did he last eat, and could he have swallowed anything unusual, like a bone, plastic or chocolate?',
        readBy: ['u_vet', 'u_priya'],
      ),
      msg(
        'u_priya',
        'Priya Sharma',
        b2.add(const Duration(minutes: 11)),
        text: 'Breakfast at 8. Nothing unusual that I saw, and he seems normal now.',
        readBy: ['u_priya'],
      ),
    ],
    unread: {'u_vet': 1},
  );

  // 3. Simba (Ravi, Free plan), open: ear scratching. Ravi uses his free
  // consultation this month, so the 60-word limit and monthly limit show.
  final s1 = thisMonth(h: 2);
  consultation(
    'tvc_seed_simba',
    ownerId: 'u_ravi',
    ownerName: 'Ravi Teja',
    petId: 'pet_simba',
    plan: 'free',
    status: 'active',
    problem: 'సింబా రెండు రోజులుగా చెవులు గోక్కుంటోంది, కొంచెం వాసన కూడా వస్తోంది.',
    createdAt: s1,
    vetId: 'vet_hyd_1_a',
    vetUid: 'u_vet',
    startedAt: s1.add(const Duration(minutes: 9)),
    messagesUsed: 3,
  );
  conversation(
    'tv_tvc_seed_simba',
    teleVetConversation('tvc_seed_simba', ownerId: 'u_ravi', ownerName: 'Ravi Teja', petId: 'pet_simba', vetUid: 'u_vet', vetId: 'vet_hyd_1_a'),
    [
      sys('tv_started', s1, {'mode': 'chat'}, ['u_ravi', 'u_vet']),
      msg(
        'u_ravi',
        'Ravi Teja',
        s1.add(const Duration(milliseconds: 1)),
        text: 'సింబా రెండు రోజులుగా చెవులు గోక్కుంటోంది, కొంచెం వాసన కూడా వస్తోంది.',
        meta: {'problem': true},
        readBy: ['u_ravi', 'u_vet'],
      ),
      sys('tv_joined', s1.add(const Duration(minutes: 9)), {'name': sameer, 'endsAt': s1.add(const Duration(minutes: 9, hours: 24))}, ['u_ravi', 'u_vet']),
      msg(
        'u_vet',
        sameer,
        s1.add(const Duration(minutes: 10)),
        text: 'Hello Ravi. Is the inside of the ear red, and is there any discharge? Please send a clear photo of the ear.',
        readBy: ['u_vet', 'u_ravi'],
      ),
      msg('u_ravi', 'Ravi Teja', s1.add(const Duration(minutes: 14)), type: 'photo', url: 'seed:album:dog:2', readBy: ['u_ravi', 'u_vet']),
      msg('u_ravi', 'Ravi Teja', s1.add(const Duration(minutes: 15)), text: 'కొంచెం ఎర్రగా ఉంది, గోధుమ రంగు మురికి ఉంది.', readBy: ['u_ravi', 'u_vet']),
      msg(
        'u_vet',
        sameer,
        s1.add(const Duration(minutes: 22)),
        text: 'Thanks. This looks like an ear infection, common in the monsoon. You\'re visiting our clinic today, so I\'ll examine Simba and clean the ear properly there. Please don\'t put oil or cotton buds in his ears.',
      ),
    ],
    unread: {'u_ravi': 1},
  );

  // 4. Tiger (Anjali), waiting in the vet queue.
  final t1 = thisMonth(m: 6);
  consultation(
    'tvc_seed_tiger',
    ownerId: 'u_anjali',
    ownerName: 'Anjali Verma',
    petId: 'pet_tiger',
    plan: 'free',
    status: 'queued',
    problem: 'टाइगर दो दिन से कम खा रहा है और ज़्यादा पानी पी रहा है। वह 11 साल का है।',
    createdAt: t1,
  );
  conversation('tv_tvc_seed_tiger', teleVetConversation('tvc_seed_tiger', ownerId: 'u_anjali', ownerName: 'Anjali Verma', petId: 'pet_tiger'), [
    sys('tv_started', t1, {'mode': 'chat'}, ['u_anjali']),
    msg(
      'u_anjali',
      'Anjali Verma',
      t1.add(const Duration(milliseconds: 1)),
      text: 'टाइगर दो दिन से कम खा रहा है और ज़्यादा पानी पी रहा है। वह 11 साल का है।',
      meta: {'problem': true},
    ),
  ]);

  // 5. Max (Arjun, Plus), 25 days ago: video call about stiff hips.
  final m1 = ago(d: 25, h: 4);
  final mumVet = vet('vet_mum_1_a');
  final videoFee = (mumVet['videoFee'] as num?)?.toInt() ?? 399;
  final videoDiscount = (videoFee * 0.10).round();
  consultation(
    'tvc_seed_max',
    ownerId: 'u_arjun',
    ownerName: 'Arjun Mehta',
    petId: 'pet_max',
    plan: 'plus',
    status: 'ended',
    mode: 'video',
    problem: 'Max is slow to get up in the mornings and avoids the stairs.',
    createdAt: m1,
    vetId: 'vet_mum_1_a',
    startedAt: m1.add(const Duration(minutes: 3)),
    endedAt: m1.add(const Duration(minutes: 28)),
    messagesUsed: 1,
    prescriptionId: 'rx_seed_max_1',
    recommendation: 'in_person',
    fee: videoFee,
    discount: videoDiscount,
  );
  prescription(
    'rx_seed_max_1',
    consultationId: 'tvc_seed_max',
    ownerId: 'u_arjun',
    ownerName: 'Arjun Mehta',
    ownerLang: 'en',
    petId: 'pet_max',
    vetId: 'vet_mum_1_a',
    at: m1.add(const Duration(minutes: 25)),
    items: [
      {
        'medicine': 'Joint supplement with glucosamine (SAMPLE)',
        'dose': '1 chew',
        'frequency': 'Once a day',
        'duration': '30 days',
        'instructions': 'With breakfast',
      },
    ],
    diagnosis: 'Age-related stiffness (suspected hip arthritis)',
    notes: 'Keep walks short and frequent on soft ground. Use rugs on slippery floors. Book a clinic visit for an X-ray of the hips.',
    followUp: m1.add(const Duration(days: 30)),
  );
  add('expenses', 'exp_tvc_seed_max', {
    'ownerId': 'u_arjun',
    'petId': 'pet_max',
    'category': 'vet',
    'amount': videoFee - videoDiscount,
    'date': m1,
    'note': '${mumVet['name']} · tele-vet',
    'source': 'televet',
    'sourceId': 'tvc_seed_max',
  });
  final mumVetName = mumVet['name'] as String;
  conversation('tv_tvc_seed_max', teleVetConversation('tvc_seed_max', ownerId: 'u_arjun', ownerName: 'Arjun Mehta', petId: 'pet_max', vetId: 'vet_mum_1_a'), [
    sys('tv_started', m1, {'mode': 'video'}, ['u_arjun']),
    msg(
      'u_arjun',
      'Arjun Mehta',
      m1.add(const Duration(milliseconds: 1)),
      text: 'Max is slow to get up in the mornings and avoids the stairs.',
      meta: {'problem': true},
      readBy: ['u_arjun', 'p_vet_mum_1_a'],
    ),
    sys('tv_joined', m1.add(const Duration(minutes: 3)), {'name': mumVetName, 'endsAt': m1.add(const Duration(minutes: 3, hours: 72))}, ['u_arjun']),
    msg('system', '', m1.add(const Duration(minutes: 20)), type: 'system', event: 'call_ended', meta: {'seconds': 1012}, readBy: ['u_arjun']),
    msg(
      'p_vet_mum_1_a',
      mumVetName,
      m1.add(const Duration(minutes: 22)),
      text: 'Thanks for showing me Max walking. It looks like stiffness in the hips, common at his age. Let\'s start a joint supplement and get an X-ray at the clinic.',
      readBy: ['p_vet_mum_1_a', 'u_arjun'],
    ),
    msg('system', '', m1.add(const Duration(minutes: 23)), type: 'system', event: 'recommend_visit', meta: {'name': mumVetName}, readBy: ['u_arjun']),
    msg(
      'p_vet_mum_1_a',
      mumVetName,
      m1.add(const Duration(minutes: 25)),
      type: 'prescription',
      prescriptionId: 'rx_seed_max_1',
      text: 'Age-related stiffness (suspected hip arthritis)',
      readBy: ['p_vet_mum_1_a', 'u_arjun'],
    ),
    sys('tv_ended', m1.add(const Duration(minutes: 28)), {'by': mumVetName}, ['u_arjun']),
  ]);

  // ---------------- Ask PawSetu history ----------------
  void askHistory(String uid, String name, List<(String question, String topic, DateTime at)> asked) {
    final id = 'ai_$uid';
    add('conversations', id, {
      'type': 'assistant',
      'participantIds': [uid],
      'participants': {
        uid: {'name': name, 'role': 'owner'},
      },
      'ownerId': uid,
      'ownerName': name,
      'providerName': 'Ask PawSetu',
      'providerKind': 'assistant',
      'unread': <String, int>{},
      'createdAt': asked.first.$3,
      'lastAt': asked.last.$3,
      'lastMessage': asked.last.$1,
    });
    for (final q in asked) {
      add('messages', 'msg_seed_${msgN++}', {'conversationId': id, ...msg(uid, name, q.$3, type: 'question', text: q.$1), 'topic': q.$2, 'redFlag': null});
      add('messages', 'msg_seed_${msgN++}', {
        'conversationId': id,
        ...msg('pawsetu_ai', 'Ask PawSetu', q.$3.add(const Duration(milliseconds: 5)), type: 'answer', readBy: [uid]),
        'topic': q.$2,
        'redFlag': null,
      });
    }
  }

  askHistory('u_priya', 'Priya Sharma', [
    ('How often should I bathe Bruno?', 'bath', ago(d: 9, h: 2)),
    ('How do I prevent ticks in the monsoon?', 'ticks', ago(d: 3, h: 5)),
  ]);
  askHistory('u_ravi', 'Ravi Teja', [
    ('సింబాకు ఏ టీకాలు కావాలి?', 'vaccines', thisMonth(h: 30)),
    ('నులిపురుగుల మందు ఎంత తరచుగా ఇవ్వాలి?', 'deworming', thisMonth(h: 20)),
    ('Simba bites my hands when we play', 'chewing', thisMonth(h: 3)),
  ]);

  // ---------------- Notifications ----------------
  var noteN = 0;
  void note(String uid, String title, DateTime at, String link, {String type = 'messages', bool read = false}) =>
      add('notifications', 'note_msg_${noteN++}', {'uid': uid, 'title': title, 'body': '', 'type': type, 'link': link, 'read': read, 'createdAt': at});
  note('u_ravi', 'టెలి-వెట్: $sameer నుండి కొత్త సందేశం', s1.add(const Duration(minutes: 22)), '/messages/tv_tvc_seed_simba');
  note('u_ravi', '$sameer నుండి కొత్త సందేశం', ago(h: 1, m: 5), '/messages/chat_bk_seed_r2');
  note('u_vet', 'New tele-vet request: Tiger (Anjali Verma)', t1, '/partner/televet');
  note('u_vet', 'Tele-vet: new message from Priya Sharma', b2.add(const Duration(minutes: 11)), '/messages/tv_tvc_seed_bruno_now');
  note('u_priya', '$sameer sent a prescription for Bruno', b1.add(const Duration(minutes: 35)), '/prescriptions/rx_seed_bruno_1', type: 'health', read: true);
}
