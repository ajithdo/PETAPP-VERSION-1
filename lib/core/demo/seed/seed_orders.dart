import 'seed.dart';

/// Phase 8: orders in every status (with the seller demo account's orders),
/// Bruno's food running low, Max's auto-reorder subscription, coupons,
/// product reviews, partner-store clicks and expenses beyond bookings.
///
/// Prices and commission follow lib/features/shop/domain/shop_rules.dart
/// (food 8%, other categories 15%; delivery ₹49, free above ₹999, or above
/// ₹499 on Plus). Pure Dart, so the numbers are worked out here.
void seedOrders(Add add, DateTime now, SeedData data) {
  DateTime day(int ago, [int hour = 11, int minute = 0]) => DateTime(now.year, now.month, now.day - ago, hour, minute);
  Map<String, dynamic> product(String id) => data['products']![id]!;
  Map<String, dynamic> user(String uid) => data['users']![uid]!;
  bool plus(String uid) => user(uid)['plan'] == 'plus';
  const sellerUid = {'seller_1': 'u_seller'};

  Map<String, dynamic> address(String uid) {
    final u = user(uid);
    final a = ((u['addresses'] as List).first as Map).cast<String, dynamic>();
    return {...a, 'name': u['name'], 'phone': u['phone']};
  }

  // Same as shortOrderNo() in shop_rules.dart.
  String shortNo(String orderId) {
    var h = 0;
    for (final c in orderId.codeUnits) {
      h = (h * 31 + c) & 0x7fffffff;
    }
    return 'PS${(h % 900000 + 100000)}';
  }

  String invoice(DateTime at, int seq) {
    final fy = at.month >= 4 ? at.year : at.year - 1;
    String yy(int y) => (y % 100).toString().padLeft(2, '0');
    return 'PS/${yy(fy)}-${yy(fy + 1)}/${seq.toString().padLeft(5, '0')}';
  }

  var seq = 10421;
  final expenseLines = <({String owner, String? pet, String category, int amount, DateTime date, String note, String orderId})>[];

  /// [steps] lists each status reached after "placed" with how many days
  /// after the order it happened.
  void order(
    String id, {
    required String owner,
    String? pet,
    required String seller,
    required List<(String, int)> items,
    required DateTime placed,
    List<(String, double)> steps = const [],
    String payment = 'paid',
    String? coupon,
    int discount = 0,
    String source = 'cart',
    String? subscriptionId,
    String? cancelReason,
    String? returnReason,
    String payoutStatus = 'pending',
    Map<String, bool> reviewed = const {},
  }) {
    final lines = [
      for (final (pid, qty) in items)
        () {
          final p = product(pid);
          final price = p['price'] as int;
          final pct = p['category'] == 'food' ? 8 : 15;
          return {
            'productId': pid,
            'name': p['name'],
            'brand': p['brand'],
            'category': p['category'],
            'qty': qty,
            'price': price,
            'mrp': p['mrp'],
            'commissionPercent': pct,
            'commission': (price * qty * pct / 100).round(),
            'packKg': p['packKg'],
            'returnable': p['returnable'],
            'imageSeed': p['imageSeed'],
          };
        }(),
    ];
    final subtotal = lines.fold<int>(0, (s, l) => s + (l['price'] as int) * (l['qty'] as int));
    final commission = lines.fold<int>(0, (s, l) => s + (l['commission'] as int));
    final after = subtotal - discount;
    final fee = after >= (plus(owner) ? 499 : 999) ? 0 : 49;
    final total = after + fee;
    final timeline = <Map<String, dynamic>>[
      {'status': 'placed', 'at': placed},
      for (final (s, d) in steps) {'status': s, 'at': placed.add(Duration(minutes: (d * 24 * 60).round()))},
    ];
    final status = steps.isEmpty ? 'placed' : steps.last.$1;
    final delivered = steps.where((s) => s.$1 == 'delivered').map((s) => placed.add(Duration(minutes: (s.$2 * 24 * 60).round()))).firstOrNull;
    final expected = DateTime(placed.year, placed.month, placed.day + 3);
    final u = user(owner);
    add('orders', id, {
      'groupId': 'grp_$id',
      'ownerId': owner,
      'ownerName': u['name'],
      'petId': pet,
      'petName': pet == null ? null : data['pets']![pet]!['name'],
      'sellerId': seller,
      'sellerName': data['sellers']![seller]!['name'],
      'sellerUids': [?sellerUid[seller]],
      'items': lines,
      'subtotal': subtotal,
      'discount': discount,
      'coupon': coupon,
      'deliveryFee': fee,
      'total': total,
      'commission': commission,
      'payout': subtotal - commission,
      'payoutStatus': payoutStatus,
      'tax': {'gstPercent': null, 'gstAmount': 0},
      'address': address(owner),
      'slot': {'date': expected, 'window': '18-21'},
      'expectedBy': expected,
      'status': status,
      'timeline': timeline,
      'paymentMethod': payment == 'cod' ? 'cod' : 'online',
      'paymentStatus': status == 'cancelled' || status == 'returned' ? (payment == 'paid' ? 'refunded' : payment) : payment,
      'invoiceNo': invoice(placed, seq++),
      'source': source,
      'subscriptionId': subscriptionId,
      'cancelReason': cancelReason,
      'cancelledBy': cancelReason == null ? null : 'customer',
      'returnReason': returnReason,
      'deliveredAt': delivered,
      'reviewed': reviewed,
      'createdAt': placed,
    });
    if (status == 'cancelled' || status == 'returned') return;
    var food = 0;
    var other = 0;
    for (final l in lines) {
      final amt = (l['price'] as int) * (l['qty'] as int);
      if (l['category'] == 'food' || l['category'] == 'treats') {
        food += amt;
      } else {
        other += amt;
      }
    }
    final foodShare = subtotal == 0 ? 0 : (total * food / subtotal).round();
    final first = lines.first['name'] as String;
    final note = lines.length == 1 ? first : '$first +${lines.length - 1}';
    if (food > 0) expenseLines.add((owner: owner, pet: pet, category: 'food', amount: other > 0 ? foodShare : total, date: placed, note: note, orderId: id));
    if (other > 0) expenseLines.add((owner: owner, pet: pet, category: 'supplies', amount: food > 0 ? total - foodShare : total, date: placed, note: note, orderId: id));
  }

  // ---------- Priya (Plus) ----------
  // Bruno's food: the last 10 kg bag arrived 20 days ago; at 400 g a day it
  // runs out in about 5 days, so Home shows the reorder card.
  order('ord_seed_p7', owner: 'u_priya', pet: 'pet_bruno', seller: 'seller_1', items: [('prod_lab_adult_10', 1)], placed: day(73, 19), steps: [('packed', 0.3), ('shipped', 0.9), ('out_for_delivery', 1.8), ('delivered', 2)], payoutStatus: 'paid');
  order('ord_seed_p6', owner: 'u_priya', pet: 'pet_bruno', seller: 'seller_1', items: [('prod_lab_adult_10', 1), ('prod_treat_training', 2)], placed: day(48, 20), steps: [('packed', 0.4), ('shipped', 1), ('out_for_delivery', 1.9), ('delivered', 2.1)], payoutStatus: 'paid', reviewed: {'prod_lab_adult_10': true});
  order('ord_seed_p1', owner: 'u_priya', pet: 'pet_bruno', seller: 'seller_1', items: [('prod_lab_adult_10', 1), ('prod_treat_chew', 1)], placed: day(22, 18), steps: [('packed', 0.3), ('shipped', 0.8), ('out_for_delivery', 1.7), ('delivered', 2)]);
  order('ord_seed_p5', owner: 'u_priya', pet: 'pet_bruno', seller: 'seller_6', items: [('prod_bed_l', 1)], placed: day(63, 12), steps: [('packed', 0.5), ('shipped', 1), ('out_for_delivery', 2.8), ('delivered', 3)], coupon: 'WELCOME10', discount: 200, payoutStatus: 'paid');
  order('ord_seed_p2', owner: 'u_priya', pet: 'pet_misty', seller: 'seller_3', items: [('prod_cat_dry_3', 1), ('prod_treat_cat', 2)], placed: day(30, 9), steps: [('packed', 0.4), ('shipped', 1), ('out_for_delivery', 1.9), ('delivered', 2)], payoutStatus: 'paid');
  order('ord_seed_p4', owner: 'u_priya', pet: 'pet_misty', seller: 'seller_6', items: [('prod_brush', 1)], placed: day(40, 15), steps: [('packed', 0.5), ('shipped', 1), ('out_for_delivery', 2.8), ('delivered', 3), ('return_requested', 5), ('returned', 7)], returnReason: 'Not suitable for my pet');
  order('ord_seed_p3', owner: 'u_priya', pet: 'pet_bruno', seller: 'seller_5', items: [('prod_harness', 1), ('prod_toy_ball', 1)], placed: day(1, 10), steps: [('packed', 0.2), ('shipped', 0.9)]);

  // ---------- Ravi (Free, Telugu) ----------
  order('ord_seed_r1', owner: 'u_ravi', pet: 'pet_simba', seller: 'seller_1', items: [('prod_puppy_3', 1), ('prod_treat_training', 1)], placed: day(11, 20), steps: [('packed', 0.5), ('shipped', 1), ('out_for_delivery', 2.6), ('delivered', 2.8)], payment: 'cod', reviewed: {'prod_puppy_3': true});
  order('ord_seed_r3', owner: 'u_ravi', pet: 'pet_simba', seller: 'seller_1', items: [('prod_puppy_3', 1)], placed: day(15, 9), steps: [('cancelled', 0.1)], payment: 'cod', cancelReason: 'I changed my mind');
  order('ord_seed_r2', owner: 'u_ravi', pet: 'pet_kiwi', seller: 'seller_4', items: [('prod_bird_seed_1', 2), ('prod_toy_bird', 1)], placed: day(0, 8, 30), payment: 'cod');
  order('ord_seed_r4', owner: 'u_ravi', pet: 'pet_simba', seller: 'seller_1', items: [('prod_treat_chew', 1)], placed: day(0, 9, 15), payment: 'cod');

  // ---------- Anjali (Free, Hindi) ----------
  order('ord_seed_a1', owner: 'u_anjali', pet: 'pet_coco', seller: 'seller_4', items: [('prod_rabbit_hay_1', 2), ('prod_rabbit_pellets', 1)], placed: day(14, 11), steps: [('packed', 0.4), ('shipped', 1), ('out_for_delivery', 2.9), ('delivered', 3)], payoutStatus: 'paid');
  order('ord_seed_a2', owner: 'u_anjali', pet: 'pet_tiger', seller: 'seller_3', items: [('prod_cat_senior_renal', 1)], placed: day(2, 17), steps: [('packed', 0.3), ('shipped', 1), ('out_for_delivery', 1.7)], payment: 'cod');

  // ---------- Arjun (Plus) ----------
  order('ord_seed_m1', owner: 'u_arjun', pet: 'pet_max', seller: 'seller_2', items: [('prod_senior_dog_7', 1)], placed: day(19, 9), steps: [('packed', 0.3), ('shipped', 1), ('out_for_delivery', 1.8), ('delivered', 2)], payment: 'cod', source: 'subscription', subscriptionId: 'sub_max_food', payoutStatus: 'paid');
  order('ord_seed_m2', owner: 'u_arjun', pet: 'pet_luna', seller: 'seller_1', items: [('prod_puppy_3', 1), ('prod_treat_training', 2)], placed: day(1, 21), steps: [('packed', 0.6)]);
  order('ord_seed_m3', owner: 'u_arjun', pet: 'pet_max', seller: 'seller_1', items: [('prod_treat_chew', 2)], placed: day(7, 13), steps: [('packed', 0.3), ('shipped', 1), ('out_for_delivery', 2.7), ('delivered', 3), ('return_requested', 6)], returnReason: 'It arrived damaged');

  for (final e in expenseLines) {
    add('expenses', 'exp_${e.orderId}_${e.category}', {
      'ownerId': e.owner,
      'petId': e.pet,
      'category': e.category,
      'amount': e.amount,
      'date': e.date,
      'note': e.note,
      'source': 'order',
      'sourceId': e.orderId,
    });
  }

  // ---------- food stock on the pets ----------
  void food(String petId, String productId, double bagKg, int grams, int openedDaysAgo) {
    data['pets']![petId]!.addAll({
      'foodProductId': productId,
      'foodBagKg': bagKg,
      'dailyPortionG': grams,
      'foodOpenedAt': day(openedDaysAgo, 8),
    });
  }

  food('pet_bruno', 'prod_lab_adult_10', 10, 400, 20); // about 5 days left
  food('pet_misty', 'prod_cat_dry_3', 3, 60, 28);
  food('pet_simba', 'prod_puppy_3', 3, 240, 4);
  food('pet_tiger', 'prod_cat_senior_renal', 2, 50, 10);
  food('pet_max', 'prod_senior_dog_7', 7, 410, 4);
  food('pet_luna', 'prod_puppy_3', 3, 170, 13); // low, but a new bag is already packed

  // ---------- auto-reorder ----------
  add('subscriptions', 'sub_max_food', {
    'ownerId': 'u_arjun',
    'petId': 'pet_max',
    'productId': 'prod_senior_dog_7',
    'productName': product('prod_senior_dog_7')['name'],
    'qty': 1,
    'everyWeeks': 4,
    'nextAt': DateTime(now.year, now.month, now.day + 9, 9),
    'active': true,
    'address': address('u_arjun'),
    'lastOrderGroup': 'grp_ord_seed_m1',
    'createdAt': day(47),
  });

  // ---------- coupons (admin-created) ----------
  add('coupons', 'WELCOME10', {'percent': 10, 'maxDiscount': 200, 'minOrder': 499, 'validTill': DateTime(now.year + 1, 3, 31), 'uses': 128, 'maxUses': 5000, 'active': true, 'description': '10% off your order, up to ₹200'});
  add('coupons', 'PAWS100', {'flat': 100, 'minOrder': 999, 'validTill': DateTime(now.year, now.month + 2, 1), 'uses': 46, 'maxUses': 1000, 'active': true, 'description': '₹100 off orders above ₹999'});
  add('coupons', 'MONSOON15', {'percent': 15, 'maxDiscount': 300, 'minOrder': 799, 'validTill': DateTime(now.year, now.month, now.day + 30), 'uses': 12, 'maxUses': 500, 'active': true, 'description': '15% off rainy-season gear, up to ₹300'});
  add('coupons', 'DIWALI50', {'percent': 50, 'maxDiscount': 500, 'minOrder': 0, 'validTill': day(20), 'uses': 300, 'maxUses': 300, 'active': true, 'description': 'Expired festival offer'});

  // ---------- verified product reviews ----------
  var rv = 0;
  void review(String productId, String owner, int rating, String text, int daysAgo, {String? orderId, String? reply}) {
    add('reviews', 'rev_shop_${rv++}', {
      'targetType': 'product',
      'targetId': productId,
      'sellerId': product(productId)['sellerId'],
      'ownerId': owner,
      'ownerName': user(owner)['name'],
      'orderId': orderId,
      'rating': rating,
      'text': text,
      'status': 'visible',
      'reply': reply,
      'replyAt': reply == null ? null : day(daysAgo - 1),
      'createdAt': day(daysAgo, 20),
    });
  }

  review('prod_lab_adult_10', 'u_priya', 5, 'Bruno is allergic to chicken and this suits him well. No itching since we switched.', 44, orderId: 'ord_seed_p6', reply: 'Thank you, Priya! Give Bruno a pat from us.');
  review('prod_puppy_3', 'u_ravi', 4, 'సింబాకి బాగా నచ్చింది. చిన్న గింజలు, తినడం సులభం.', 7, orderId: 'ord_seed_r1');
  review('prod_treat_chew', 'u_arjun', 3, 'Max likes them but they finish quickly.', 30);
  review('prod_treat_training', 'u_priya', 5, 'Perfect size for training rewards.', 44);
  review('prod_cat_dry_3', 'u_priya', 4, 'Misty eats it happily. Fewer hairballs.', 26);
  review('prod_rabbit_hay_1', 'u_anjali', 5, 'कोको को यह घास बहुत पसंद है। ताज़ी और साफ़।', 10);

  // ---------- partner-store clicks ----------
  var ck = 0;
  for (final (uid, pid, partner, ago) in [
    ('u_priya', 'prod_aff_fountain', 'partner_1', 3),
    ('u_priya', 'prod_aff_cooling', 'partner_3', 12),
    ('u_arjun', 'prod_aff_gps_collar', 'partner_3', 5),
    ('u_ravi', 'prod_aff_bird_bath', 'partner_1', 8),
    ('u_anjali', 'prod_aff_carrier', 'partner_3', 20),
  ]) {
    add('affiliateClicks', 'click_${ck++}', {'uid': uid, 'productId': pid, 'partnerId': partner, 'at': day(ago, 19)});
  }

  // ---------- manual expenses (6 months, so the chart has history) ----------
  var ex = 0;
  void expense(String owner, String? pet, String category, int amount, int daysAgo, String note) => add('expenses', 'exp_manual_${ex++}', {
        'ownerId': owner,
        'petId': pet,
        'category': category,
        'amount': amount,
        'date': day(daysAgo, 18),
        'note': note,
        'source': 'manual',
        'createdAt': day(daysAgo, 18),
      });

  expense('u_priya', 'pet_bruno', 'vet', 1850, 41, 'Ear infection visit, Gulmohar Vet Studio');
  expense('u_priya', 'pet_bruno', 'insurance', 6499, 300, 'Shield Pet Cover premium');
  expense('u_priya', 'pet_bruno', 'food', 3650, 100, 'Dog food from the local store');
  expense('u_priya', 'pet_bruno', 'food', 3650, 130, 'Dog food from the local store');
  expense('u_priya', 'pet_bruno', 'grooming', 900, 95, 'Bath and nail trim at home');
  expense('u_priya', 'pet_misty', 'supplies', 899, 18, 'Cat litter 10 kg (partner store)');
  expense('u_priya', 'pet_misty', 'supplies', 899, 76, 'Cat litter 10 kg (partner store)');
  expense('u_priya', 'pet_misty', 'vet', 700, 120, 'Annual check-up');
  expense('u_priya', 'pet_misty', 'food', 1450, 150, 'Cat food');
  expense('u_priya', null, 'other', 1200, 160, 'Pet-friendly cab to the beach');
  expense('u_ravi', 'pet_simba', 'vet', 650, 70, 'టీకా, క్లినిక్‌లో');
  expense('u_ravi', 'pet_simba', 'supplies', 450, 120, 'కాలర్, లీష్');
  expense('u_ravi', 'pet_kiwi', 'food', 300, 40, 'విత్తనాల మిక్స్');
  expense('u_ravi', 'pet_kiwi', 'supplies', 1800, 140, 'కొత్త పంజరం');
  expense('u_anjali', 'pet_tiger', 'vet', 1200, 60, 'किडनी की जाँच');
  expense('u_anjali', 'pet_tiger', 'other', 540, 33, 'किडनी की गोलियाँ');
  expense('u_anjali', 'pet_coco', 'food', 380, 90, 'ताज़ी सब्ज़ियाँ और घास');
  expense('u_arjun', 'pet_max', 'other', 980, 30, 'Joint care tablets');
  expense('u_arjun', 'pet_max', 'boarding', 2400, 110, 'Two nights at a friend\'s kennel');
  expense('u_arjun', 'pet_luna', 'vet', 1300, 75, 'Puppy vaccines');
  expense('u_arjun', 'pet_luna', 'supplies', 1650, 115, 'Crate and bowls for the new puppy');

  // ---------- notifications ----------
  var nt = 0;
  void note(String uid, String title, String link, int hoursAgo, {bool read = false}) => add('notifications', 'note_shop_${nt++}', {
        'uid': uid,
        'title': title,
        'body': '',
        'type': 'orders',
        'link': link,
        'read': read,
        'createdAt': now.subtract(Duration(hours: hoursAgo)),
      });

  note('u_priya', '${product('prod_harness')['name']} is on the way', '/shop/orders/ord_seed_p3', 3);
  note('u_seller', 'New order: ${product('prod_treat_chew')['name']}', '/partner/order/ord_seed_r4', 2);
  note('u_seller', 'Return requested for order ${shortNo('ord_seed_m3')}', '/partner/order/ord_seed_m3', 20, read: true);
  note('u_anjali', '${product('prod_cat_senior_renal')['name']} आज डिलीवरी के लिए निकला', '/shop/orders/ord_seed_a2', 4);
  note('u_ravi', '${product('prod_puppy_3')['name']} డెలివరీ అయింది', '/shop/orders/ord_seed_r1', 190, read: true);
}
