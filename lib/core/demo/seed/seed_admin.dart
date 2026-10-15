import 'seed.dart';
import 'seed_analytics.dart';

/// Phase 10: 90 days of platform numbers, complaints and tickets in every
/// state, reported reviews and chats, the audit log, PawSetu Plus payments,
/// a referral, banners, featured products and Demo Outbox examples.
/// Only that phase edits this file.
void seedAdmin(Add add, DateTime now, SeedData data) {
  DateTime ago({int days = 0, int hours = 0, int minutes = 0}) => now.subtract(Duration(days: days, hours: hours, minutes: minutes));
  Map<String, dynamic> doc(String col, String id) => data[col]![id]!;

  seedAnalytics(add, now);

  // ---------- settings added in Phase 10 ----------
  doc('config', 'app')
    ..['referral'] = {'reward': 100}
    ..['commission'] = {...(doc('config', 'app')['commission'] as Map), 'bookingTypePercent': <String, num>{}, 'categoryPercent': <String, num>{}}
    ..['contentReview'] = <String, String>{}
    ..['vaccineSchedules'] = <String, dynamic>{};

  // ---------- plans: Priya pays monthly, Arjun yearly ----------
  final priya = doc('users', 'u_priya');
  final arjun = doc('users', 'u_arjun');
  priya
    ..['planPeriod'] = 'monthly'
    ..['autoRenew'] = true
    ..['trialUsedAt'] = ago(days: 190);
  arjun
    ..['planPeriod'] = 'yearly'
    ..['autoRenew'] = true
    ..['trialUsedAt'] = ago(days: 350);
  final priyaRenews = priya['planRenewsAt'] as DateTime;
  for (var k = 1; k <= 6; k++) {
    add('payments', 'pay_plus_priya_$k', {
      'uid': 'u_priya',
      'kind': 'plus',
      'period': 'monthly',
      'amount': 99,
      'tax': 0,
      'status': 'paid',
      'demo': true,
      'at': DateTime(priyaRenews.year, priyaRenews.month - k, priyaRenews.day, 9),
    });
  }
  add('payments', 'pay_plus_arjun_1', {
    'uid': 'u_arjun',
    'kind': 'plus',
    'period': 'yearly',
    'amount': 799,
    'tax': 0,
    'status': 'paid',
    'demo': true,
    'at': DateTime(priyaRenews.year - 1, priyaRenews.month, priyaRenews.day, 11),
  });
  // Other (made-up) members' Plus payments, so the commission report has numbers.
  final r = SeedRandom(1010);
  for (var i = 0; i < 36; i++) {
    final yearly = r.chance(0.3);
    add('payments', 'pay_plus_cust_$i', {
      'uid': 'u_cust_${1 + r.next(40)}',
      'kind': 'plus',
      'period': yearly ? 'yearly' : 'monthly',
      'amount': yearly ? 799 : 99,
      'tax': 0,
      'status': 'paid',
      'demo': true,
      'at': ago(days: r.next(150), hours: r.next(20)),
    });
  }

  // ---------- referral: Rohan joined with Priya's code ----------
  final priyaCode = priya['referralCode'] as String;
  for (final (code, uid) in [('REFPRI100', 'u_priya'), ('REFROH100', 'u_rohan')]) {
    add('coupons', code, {
      'flat': 100,
      'minOrder': 299,
      'validTill': now.add(const Duration(days: 45)),
      'uses': 0,
      'maxUses': 1,
      'active': true,
      'forUid': uid,
      'description': 'Referral reward',
    });
  }
  add('referrals', 'ref_seed_1', {
    'referrerId': 'u_priya',
    'referredId': 'u_rohan',
    'code': priyaCode,
    'reward': 100,
    'coupons': {'u_priya': 'REFPRI100', 'u_rohan': 'REFROH100'},
    'createdAt': ago(days: 15),
  });

  // ---------- approvals: registration numbers to check ----------
  doc('clinics', 'clinic_pending_1')['regNo'] = 'DEMO-VC-0412';
  if (data['vets']!.containsKey('vet_pending_2_a')) doc('vets', 'vet_pending_2_a')['regNo'] = 'MH/2019/77';

  // ---------- featured products and banners ----------
  for (final id in ['prod_lab_adult_10', 'prod_harness', 'prod_cat_dry_3', 'prod_bird_seed_1', 'prod_toy_ball']) {
    if (data['products']!.containsKey(id)) doc('products', id)['featured'] = true;
  }
  add('banners', 'banner_plus_trial', {
    'title': 'Try PawSetu Plus free for 7 days',
    'body': 'Video vet calls, unlimited pets and more.',
    'link': '/me/plus',
    'placement': 'home',
    'tone': 'primary',
    'active': true,
    'order': 1,
    'createdAt': ago(days: 20),
  });
  add('banners', 'banner_monsoon', {
    'title': 'MONSOON15: 15% off rainy-season gear',
    'body': 'Raincoats, paw balm and quick-dry towels.',
    'link': '/shop/search?q=rain',
    'placement': 'shop',
    'tone': 'accent',
    'active': true,
    'order': 2,
    'createdAt': ago(days: 12),
  });
  add('banners', 'banner_diwali', {
    'title': 'Diwali safety: keep pets indoors during crackers',
    'body': 'Read our tips for a calm festival.',
    'link': '/first-aid',
    'placement': 'home',
    'tone': 'accent',
    'active': false,
    'order': 3,
    'createdAt': ago(days: 40),
  });

  // ---------- complaints and tickets ----------
  Map<String, dynamic> msg(String by, String byName, bool admin, String text, DateTime at) => {'by': by, 'byName': byName, 'admin': admin, 'text': text, 'at': at};
  String orderLabel(String id) {
    final o = doc('orders', id);
    final short = id.length > 6 ? id.substring(id.length - 6).toUpperCase() : id;
    return '${o['sellerName']} · ₹${o['total']} · #$short';
  }

  String bookingLabel(String id) {
    final b = doc('bookings', id);
    return '${b['serviceName']} · ${b['providerName']} · ${b['petName']}';
  }

  void ticket(String id,
      {required String uid,
      required String name,
      String role = 'owner',
      required String topic,
      required String subject,
      required String status,
      String linkType = 'other',
      String? linkId,
      String? assignee,
      Map<String, dynamic>? refund,
      required List<Map<String, dynamic>> messages}) {
    add('tickets', id, {
      'uid': uid,
      'name': name,
      'role': role,
      'topic': topic,
      'subject': subject,
      'body': messages.first['text'],
      'linkType': linkType,
      'linkId': linkId,
      'linkLabel': switch (linkType) {
        'order' => orderLabel(linkId!),
        'booking' => bookingLabel(linkId!),
        _ => '',
      },
      'status': status,
      'assignee': assignee,
      'refund': refund,
      'messages': messages,
      'createdAt': messages.first['at'],
      'updatedAt': messages.last['at'],
    });
  }

  const admin = 'PawSetu Admin';
  ticket('tk_ravi_walk',
      uid: 'u_ravi',
      name: 'Ravi Teja',
      topic: 'late',
      subject: 'వాకర్ 20 నిమిషాలు ఆలస్యంగా వచ్చారు',
      status: 'open',
      linkType: 'booking',
      linkId: 'bk_seed_r1',
      messages: [
        msg('u_ravi', 'Ravi Teja', false, 'ఈ రోజు ఉదయం వాకర్ 20 నిమిషాలు ఆలస్యంగా వచ్చారు. సింబా చాలా సేపు ఎదురుచూశాడు. దయచేసి చూడండి.', ago(hours: 2)),
      ]);
  ticket('tk_priya_harness',
      uid: 'u_priya',
      name: 'Priya Sharma',
      topic: 'late',
      subject: 'Harness order still not delivered',
      status: 'in_progress',
      linkType: 'order',
      linkId: 'ord_seed_p3',
      assignee: admin,
      messages: [
        msg('u_priya', 'Priya Sharma', false, 'The tracking has said "shipped" since yesterday. Bruno\'s old harness is broken, can you check when it will arrive?', ago(hours: 20)),
        msg('u_admin', admin, true, 'Sorry for the wait, Priya. We asked Paws & Claws Co. and the courier will deliver it today before 7 pm.', ago(hours: 6)),
      ]);
  final arjunOrder = doc('orders', 'ord_seed_m3');
  final arjunPaid = (arjunOrder['total'] as num).toInt();
  ticket('tk_arjun_damaged',
      uid: 'u_arjun',
      name: 'Arjun Mehta',
      topic: 'refund',
      subject: 'Chews arrived damaged',
      status: 'resolved',
      linkType: 'order',
      linkId: 'ord_seed_m3',
      assignee: admin,
      refund: {'amount': arjunPaid, 'status': 'refunded', 'at': ago(days: 3), 'by': 'u_admin'},
      messages: [
        msg('u_arjun', 'Arjun Mehta', false, 'The packet was torn and half the chews were broken. I have asked for a return.', ago(days: 5)),
        msg('u_admin', admin, true, 'Thanks for the photos, Arjun. We have refunded the full amount to your original payment method (demo).', ago(days: 3)),
        msg('u_arjun', 'Arjun Mehta', false, 'Got it, thank you!', ago(days: 3, hours: -2)),
      ]);
  add('payments', 'pay_refund_arjun', {
    'uid': 'u_arjun',
    'kind': 'refund',
    'amount': -arjunPaid,
    'tax': 0,
    'status': 'refunded',
    'ticketId': 'tk_arjun_damaged',
    'linkType': 'order',
    'linkId': 'ord_seed_m3',
    'demo': true,
    'at': ago(days: 3),
  });
  ticket('tk_anjali_sound',
      uid: 'u_anjali',
      name: 'Anjali Verma',
      topic: 'app',
      subject: 'दवा के रिमाइंडर की आवाज़ बहुत धीमी है',
      status: 'open',
      messages: [
        msg('u_anjali', 'Anjali Verma', false, 'कोको की दवा का रिमाइंडर आता है पर आवाज़ बहुत धीमी है, मुझे सुनाई नहीं देता। क्या इसे तेज़ कर सकते हैं?', ago(days: 1, hours: 3)),
      ]);
  ticket('tk_groomer_payout',
      uid: 'u_groomer',
      name: 'Lakshmi Groom Studio',
      role: 'groomer',
      topic: 'other',
      subject: 'Last week\'s payout is not showing',
      status: 'in_progress',
      assignee: admin,
      messages: [
        msg('u_groomer', 'Lakshmi Groom Studio', false, 'I finished 6 bookings last week but the payout page shows only 4.', ago(days: 2)),
        msg('u_admin', admin, true, 'Two bookings were completed after Sunday midnight, so they are in this week\'s payout. We will confirm on Monday.', ago(days: 1, hours: 20)),
      ]);
  ticket('tk_seller_return',
      uid: 'u_seller',
      name: 'Tail Treats Traders',
      role: 'seller',
      topic: 'quality',
      subject: 'Return for damaged chews: please check the photos',
      status: 'open',
      linkType: 'order',
      linkId: 'ord_seed_m3',
      messages: [
        msg('u_seller', 'Tail Treats Traders', false, 'The customer says the packet was torn. Our packing photos show it sealed. Can support check with the courier?', ago(days: 4)),
      ]);

  // ---------- moderation: reported reviews and chats ----------
  add('reviews', 'rev_admin_spam', {
    'targetType': 'clinic',
    'targetId': 'clinic_hyd_1',
    'ownerId': 'u_cust_31',
    'ownerName': 'Suresh K.',
    'rating': 1,
    'text': 'Worst clinic!!! Call 90000 99999 for a cheaper home vet.',
    'status': 'visible',
    'createdAt': ago(days: 2),
  });
  add('reviews', 'rev_admin_rude', {
    'targetType': 'product',
    'targetId': 'prod_toy_ball',
    'sellerId': 'seller_5',
    'ownerId': 'u_cust_32',
    'ownerName': 'Mohit S.',
    'rating': 1,
    'text': 'These sellers are cheats and liars, never buy here.',
    'status': 'visible',
    'createdAt': ago(days: 1),
  });
  add('reports', 'rpt_review_spam', {
    'type': 'review',
    'targetId': 'rev_admin_spam',
    'targetTitle': 'Golconda Gate Pet Clinic',
    'reporterId': 'u_clinicadmin',
    'reporterName': 'Kavya Rao',
    'reason': 'spam',
    'details': 'Advertises another service and shares a phone number.',
    'excerpt': 'Worst clinic!!! Call 90000 99999 for a cheaper home vet.',
    'status': 'open',
    'createdAt': ago(days: 1, hours: 20),
  });
  add('reports', 'rpt_review_rude', {
    'type': 'review',
    'targetId': 'rev_admin_rude',
    'targetTitle': 'Squeaky Rubber Ball (2 pack)',
    'reporterId': 'u_seller',
    'reporterName': 'Tail Treats Traders',
    'reason': 'abuse',
    'details': '',
    'excerpt': 'These sellers are cheats and liars, never buy here.',
    'status': 'open',
    'createdAt': ago(hours: 18),
  });
  final chat = data['conversations']?['chat_bk_seed_m1'];
  add('reports', 'rpt_chat_payment', {
    'type': 'chat',
    'targetId': 'chat_bk_seed_m1',
    'targetTitle': chat == null ? 'Arjun Mehta' : '${chat['ownerName']} · ${chat['providerName']}',
    'reporterId': 'u_arjun',
    'reporterName': 'Arjun Mehta',
    'reason': 'payment',
    'details': 'Was asked to pay by UPI outside the app for the next visit.',
    'excerpt': 'Next time just send it to my UPI, it is cheaper for you.',
    'status': 'open',
    'createdAt': ago(days: 1, hours: 2),
  });
  add('reports', 'rpt_content_old', {
    'type': 'content',
    'targetId': 'lost_seed_luna',
    'targetTitle': 'Lost pet page',
    'reporterId': 'u_cust_7',
    'reporterName': 'Deepa N.',
    'reason': 'fake',
    'details': 'Thought the poster was fake, but the family confirmed it.',
    'excerpt': '',
    'status': 'dismissed',
    'resolvedAt': ago(days: 9),
    'resolvedBy': 'u_admin',
    'createdAt': ago(days: 10),
  });

  // ---------- audit log ----------
  var auditN = 0;
  void audit(String action, String target, Map<String, dynamic> details, DateTime at) => add('auditLog', 'audit_seed_${auditN++}', {
        'actorId': 'u_admin',
        'actorName': admin,
        'action': action,
        'targetId': target,
        'details': details,
        'createdAt': at,
      });
  audit('partner_approve', 'providers/prov_groom_5', {'name': 'Bandra Bath & Brush', 'reason': ''}, ago(days: 26));
  audit('coupon_create', 'coupons/MONSOON15', {'percent': 15, 'maxDiscount': 300, 'minOrder': 799}, ago(days: 21));
  audit('banner_create', 'banners/banner_plus_trial', {'name': 'Try PawSetu Plus free for 7 days'}, ago(days: 20));
  audit('settings_limits', 'config/app', {'limits.free.aiQuestions': 5}, ago(days: 18));
  audit('report_dismiss', 'reports/rpt_content_old', {'type': 'content', 'target': 'lost_seed_luna'}, ago(days: 9));
  audit('ticket_reply', 'tickets/tk_arjun_damaged', {'status': 'in_progress'}, ago(days: 3, hours: 1));
  audit('ticket_refund', 'tickets/tk_arjun_damaged', {'amount': arjunPaid}, ago(days: 3));
  audit('ticket_status', 'tickets/tk_arjun_damaged', {'status': 'resolved'}, ago(days: 2, hours: 22));
  audit('ticket_reply', 'tickets/tk_groomer_payout', {'status': 'in_progress'}, ago(days: 1, hours: 20));
  audit('ticket_reply', 'tickets/tk_priya_harness', {'status': 'in_progress'}, ago(hours: 6));

  // ---------- Demo Outbox examples ----------
  var outN = 0;
  void outbox(String channel, String to, String body, DateTime at, {String? subject, String? uid, String? type}) => add('outbox', 'out_admin_${outN++}', {
        'channel': channel,
        'to': to,
        'subject': subject,
        'body': body,
        'uid': uid,
        'type': type,
        'createdAt': at,
      });
  outbox('email', 'arjun@example.com', 'Your refund of ₹$arjunPaid for the damaged chews is on its way (demo, no real money).', ago(days: 3),
      subject: 'Refund started', uid: 'u_arjun', type: 'support');
  outbox('whatsapp', demoPhone(1), 'PawSetu: Your Plus membership renews on the ${priyaRenews.day}th. Reply STOP to turn off renewal reminders.', ago(days: 1),
      uid: 'u_priya', type: 'plan');
  outbox('sms', demoPhone(4), 'PawSetu support replied to "Chews arrived damaged". Open the app to read it.', ago(days: 3), uid: 'u_arjun', type: 'support');
  outbox('push', 'u_priya', 'Support replied: Harness order still not delivered', ago(hours: 6), uid: 'u_priya', type: 'support');
}
