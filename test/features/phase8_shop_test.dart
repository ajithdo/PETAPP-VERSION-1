import 'package:flutter_test/flutter_test.dart';
import 'package:pawsetu/core/demo/seed/seed.dart';
import 'package:pawsetu/features/shop/domain/food_stock.dart';
import 'package:pawsetu/features/shop/domain/shop_models.dart';
import 'package:pawsetu/features/shop/domain/shop_rules.dart';

void main() {
  final now = DateTime(2026, 10, 14, 11); // a Wednesday

  Product product(String id, {int price = 100, int? mrp, String category = 'toys', String seller = 's1', int stock = 10, String? partner, List<String> species = const ['dog'], String? ingredients, String name = 'Thing', List<String> life = const ['all'], List<String> sizes = const ['all'], double rating = 4, int reviews = 10}) =>
      Product(id, {
        'name': name,
        'brand': 'B',
        'category': category,
        'species': species,
        'lifeStages': life,
        'breedSizes': sizes,
        'price': price,
        'mrp': mrp ?? price,
        'stock': partner == null ? stock : null,
        'sellerId': partner == null ? seller : null,
        'partnerId': partner,
        'ingredients': ingredients,
        'rating': rating,
        'reviewCount': reviews,
        'active': true,
      });

  group('food running low (spec 7.10)', () {
    test('bag size ÷ daily portion, counted from the day it was opened', () {
      // Bruno: 10 kg at 400 g a day, opened 20 days ago → about 5 days left.
      final left = foodDaysLeft(bagKg: 10, dailyGrams: 400, openedAt: now.subtract(const Duration(days: 20)), now: now)!;
      expect(left, closeTo(5, 0.01));
      expect(roundDays(left), 5);
      expect(foodState(left), FoodState.low);
      expect(foodState(8), FoodState.ok);
      expect(foodState(7), FoodState.low);
      expect(foodState(-1), FoodState.out);
      expect(foodState(null), FoodState.unknown);
    });

    test('unknown when the bag, portion or opening day is missing', () {
      expect(foodDaysLeft(bagKg: null, dailyGrams: 400, openedAt: now, now: now), isNull);
      expect(foodDaysLeft(bagKg: 10, dailyGrams: 0, openedAt: now, now: now), isNull);
      expect(foodDaysLeft(bagKg: 10, dailyGrams: 400, openedAt: null, now: now), isNull);
    });

    test('run-out date and when a new bag is opened', () {
      final opened = DateTime(2026, 10, 1, 8);
      expect(foodRunOutDate(bagKg: 3, dailyGrams: 300, openedAt: opened), DateTime(2026, 10, 11, 8));
      // Delivered before the old bag runs out → opened when it runs out.
      expect(newBagOpenedAt(deliveredAt: DateTime(2026, 10, 9), oldRunOut: DateTime(2026, 10, 11, 8)), DateTime(2026, 10, 11, 8));
      // Delivered after → opened on delivery.
      expect(newBagOpenedAt(deliveredAt: DateTime(2026, 10, 12), oldRunOut: DateTime(2026, 10, 11, 8)), DateTime(2026, 10, 12));
    });

    test('suggested daily portions are sensible starting points', () {
      expect(suggestedDailyGrams(species: 'dog', weightKg: 29), 400); // Labrador adult
      expect(suggestedDailyGrams(species: 'dog', weightKg: 8.5, lifeStage: 'young'), 240); // puppy
      expect(suggestedDailyGrams(species: 'cat', weightKg: 4.2), 60);
      expect(suggestedDailyGrams(species: 'bird'), 15);
      expect(suggestedDailyGrams(species: 'dog'), 250);
    });
  });

  group('cart pricing', () {
    final products = {
      'food': product('food', price: 3899, mrp: 4499, category: 'food', seller: 's1'),
      'chew': product('chew', price: 399, category: 'treats', seller: 's1'),
      'ball': product('ball', price: 249, seller: 's2'),
      'aff': product('aff', price: 1999, partner: 'p1'),
      'gone': product('gone', price: 99, stock: 0),
    };

    test('one order per seller; affiliate and out-of-stock lines are skipped', () {
      final p = priceCart(const [CartLine('food', 1), CartLine('chew', 1), CartLine('ball', 2), CartLine('aff', 1), CartLine('gone', 1)], products, plus: false, now: now);
      expect(p.groups.map((g) => g.sellerId), ['s1', 's2']);
      expect(p.skipped.map((s) => s.productId), ['aff', 'gone']);
      expect(p.subtotal, 3899 + 399 + 498);
      expect(p.mrpTotal, 4499 + 399 + 498);
      expect(p.deliveryFee, 0); // above ₹999
      expect(p.total, p.subtotal);
      expect(p.savings, 600);
    });

    test('commission: 8% on food, 15% on other categories, seller and admin overrides', () {
      const s = ShopSettings();
      expect(commissionPercent('food', s), 8);
      expect(commissionPercent('toys', s), 15);
      expect(commissionPercent('treats', s), 15);
      expect(commissionPercent('toys', const ShopSettings(categoryPercent: {'toys': 12})), 12);
      expect(commissionPercent('food', s, sellerOverride: 5), 5);
      expect(commissionPercent('food', s, sellerOverride: {'food': 6}), 6);
      expect(commissionPercent('toys', s, sellerOverride: {'food': 6}), 15);
      final p = priceCart(const [CartLine('food', 1), CartLine('chew', 2)], products, plus: false, now: now);
      expect(p.commission, (3899 * 0.08).round() + (798 * 0.15).round());
    });

    test('delivery: ₹49 under ₹999, free above; Plus free above ₹499', () {
      expect(deliveryFeeFor(998, plus: false), 49);
      expect(deliveryFeeFor(999, plus: false), 0);
      expect(deliveryFeeFor(498, plus: true), 49);
      expect(deliveryFeeFor(499, plus: true), 0);
      expect(deliveryFeeFor(0, plus: false), 0);
      final p = priceCart(const [CartLine('ball', 2)], products, plus: true, now: now);
      expect(p.deliveryFee, 49); // ₹498 < ₹499
    });

    test('coupon and delivery fee are shared across sellers and add up exactly', () {
      final c = Coupon('WELCOME10', {'percent': 10, 'maxDiscount': 200, 'minOrder': 499});
      final p = priceCart(const [CartLine('food', 1), CartLine('ball', 1)], products, plus: false, coupon: c, now: now);
      expect(p.discount, 200);
      expect(p.groups.fold(0, (s, g) => s + g.discount), 200);
      expect(p.groups.fold(0, (s, g) => s + g.total), p.total);
      expect(p.groups.first.discount, greaterThan(p.groups.last.discount));
    });

    test('allocate splits in proportion and never loses a rupee', () {
      expect(allocate(100, [1, 1, 1]), [34, 33, 33]);
      expect(allocate(49, [3899, 249]), [46, 3]);
      expect(allocate(10, [0, 0]), [10, 0]);
      for (final a in [1, 7, 199, 1000]) {
        expect(allocate(a, [17, 3, 80]).fold(0, (s, v) => s + v), a);
      }
    });

    test('quantity is capped at the stock left', () {
      final p = priceCart(const [CartLine('food', 50)], products, plus: false, now: now);
      expect(p.groups.single.lines.single.qty, 10);
    });
  });

  group('coupons', () {
    test('percent with a cap, flat, minimum order, expiry, use limit', () {
      expect(checkCoupon(Coupon('A', {'percent': 10, 'maxDiscount': 200}), subtotal: 1000, now: now), (result: CouponResult.ok, discount: 100));
      expect(checkCoupon(Coupon('A', {'percent': 10, 'maxDiscount': 200}), subtotal: 5000, now: now).discount, 200);
      expect(checkCoupon(Coupon('B', {'flat': 100, 'minOrder': 999}), subtotal: 999, now: now).discount, 100);
      expect(checkCoupon(Coupon('B', {'flat': 100, 'minOrder': 999}), subtotal: 998, now: now).result, CouponResult.minOrder);
      expect(checkCoupon(Coupon('C', {'percent': 50, 'validTill': DateTime(2026, 10, 1)}), subtotal: 500, now: now).result, CouponResult.expired);
      expect(checkCoupon(Coupon('D', {'percent': 5, 'uses': 300, 'maxUses': 300}), subtotal: 500, now: now).result, CouponResult.usedUp);
      expect(checkCoupon(Coupon('E', {'percent': 5, 'active': false}), subtotal: 500, now: now).result, CouponResult.inactive);
      expect(checkCoupon(null, subtotal: 500, now: now).result, CouponResult.notFound);
      expect(checkCoupon(Coupon('F', {'flat': 900}), subtotal: 500, now: now).discount, 500);
      expect(normaliseCoupon(' welcome 10 '), 'WELCOME10');
    });
  });

  group('delivery dates', () {
    test('PIN codes: 6 digits, not starting with 0', () {
      expect(isValidPinCode('560038'), isTrue);
      expect(isValidPinCode('060038'), isFalse);
      expect(isValidPinCode('56003'), isFalse);
      expect(isValidPinCode('56003a'), isFalse);
    });

    test('big cities are faster and Sundays are skipped', () {
      final city = deliveryEstimate('560038', 2, now)!; // Bengaluru
      expect(city.from, DateTime(2026, 10, 16)); // Wed + 2 working days = Fri
      expect(city.to, DateTime(2026, 10, 17));
      final town = deliveryEstimate('571401', 2, now)!; // +2 days, skips Sunday
      expect(town.from, DateTime(2026, 10, 19));
      expect(deliveryEstimate('12345', 2, now), isNull);
    });

    test('slots skip windows starting within 2 hours and Sundays', () {
      final slots = deliverySlots(DateTime(2026, 10, 14), now);
      expect(slots.first, (date: DateTime(2026, 10, 14), window: '15-18'));
      expect(slots.length, 12);
      expect(slots.any((s) => s.date.weekday == DateTime.sunday), isFalse);
    });

    test('invoice numbers follow the Indian financial year', () {
      expect(invoiceNumber(DateTime(2026, 10, 14), 123), 'PS/26-27/00123');
      expect(invoiceNumber(DateTime(2027, 2, 1), 7), 'PS/26-27/00007');
      expect(invoiceNumber(DateTime(2027, 4, 1), 7), 'PS/27-28/00007');
      expect(shortOrderNo('ord_1'), 'PS806099'); // same as functions/src/phase8.test.ts
      expect(shortOrderNo('ord_1'), shortOrderNo('ord_1'));
    });
  });

  group('order life', () {
    ShopOrder order(String status, {DateTime? delivered, List<Map<String, dynamic>> items = const [{'category': 'toys', 'returnable': true, 'price': 100, 'qty': 1}]}) =>
        ShopOrder('o', {'status': status, 'deliveredAt': delivered, 'items': items, 'subtotal': 100, 'commission': 15, 'total': 100});

    test('cancel until shipped; return within 7 days for returnable items', () {
      expect(canCancel(order('placed')), isTrue);
      expect(canCancel(order('packed')), isTrue);
      expect(canCancel(order('shipped')), isFalse);
      expect(canReturn(order('delivered', delivered: now.subtract(const Duration(days: 6))), now), isTrue);
      expect(canReturn(order('delivered', delivered: now.subtract(const Duration(days: 8))), now), isFalse);
      expect(canReturn(order('delivered', delivered: now, items: const [{'category': 'food', 'returnable': false}]), now), isFalse);
      expect(canReturn(order('shipped'), now), isFalse);
    });

    test('seller steps', () {
      expect(sellerNextStatuses('placed'), ['packed', 'cancelled']);
      expect(sellerNextStatuses('out_for_delivery'), ['delivered']);
      expect(sellerNextStatuses('return_requested'), ['returned', 'return_rejected']);
      expect(sellerNextStatuses('delivered'), isEmpty);
    });

    test('payouts are held during the return window', () {
      expect(payoutState(order('shipped'), now), 'pending');
      expect(payoutState(order('delivered', delivered: now.subtract(const Duration(days: 3))), now), 'on_hold');
      expect(payoutState(order('delivered', delivered: now.subtract(const Duration(days: 8))), now), 'ready');
      expect(payoutState(order('cancelled'), now), 'none');
      expect(order('delivered').payout, 85);
    });

    test('orders become food and supplies expenses that add up to the total', () {
      final o = ShopOrder('o', {
        'total': 4249,
        'items': [
          {'category': 'food', 'price': 3899, 'qty': 1},
          {'category': 'toys', 'price': 399, 'qty': 1},
        ],
      });
      final parts = orderExpenseSplit(o);
      expect(parts.map((p) => p.category), ['food', 'supplies']);
      expect(parts.fold(0, (s, p) => s + p.amount), 4249);
    });
  });

  group('search and picks', () {
    final all = [
      product('lab', name: 'Adult Large Breed Lamb Food', category: 'food', life: ['adult'], sizes: ['large'], ingredients: 'Lamb, rice'),
      product('chk', name: 'Chicken Chunks', category: 'food', ingredients: 'Chicken, gravy'),
      product('free', name: 'Chicken-free Biscuits', category: 'treats'),
      product('pup', name: 'Puppy Food', category: 'food', life: ['puppy'], price: 1299),
      product('cat', name: 'Cat Food', category: 'food', species: ['cat']),
      product('ball', name: 'Ball', price: 249, rating: 4.8, reviews: 100),
    ];

    test('filters, words and sorting', () {
      expect(searchProducts(all, const ProductFilter(species: 'cat')).map((p) => p.id), ['cat']);
      expect(searchProducts(all, const ProductFilter(query: 'lamb food')).map((p) => p.id), ['lab']);
      expect(searchProducts(all, const ProductFilter(category: 'food', maxPrice: 200)).length, 3);
      final cheap = searchProducts(all, const ProductFilter(), sort: ProductSort.priceLow);
      expect(cheap.last.id, 'pup');
      expect(searchProducts(all, const ProductFilter(), sort: ProductSort.popular).first.id, 'ball');
      expect(searchProducts(all, const ProductFilter(query: 'खाना'), labels: (p) => p.category == 'food' ? 'खाना' : '').length, 4);
    });

    test('allergies: "chicken" excludes chicken, not "chicken-free"', () {
      expect(hasAllergen(all[1], ['Chicken']), isTrue);
      expect(hasAllergen(all[2], ['chicken']), isFalse);
      expect(hasAllergen(all[0], ['chicken']), isFalse);
    });

    test('picks for Bruno (adult Labrador, allergic to chicken)', () {
      final picks = picksFor(all, species: 'dog', lifeStage: 'adult', breedSize: 'large', allergies: ['Chicken']);
      expect(picks.first.id, 'lab');
      expect(picks.map((p) => p.id), isNot(contains('chk')));
      expect(picks.map((p) => p.id), isNot(contains('cat')));
      expect(shopLifeStage('young'), 'puppy');
    });

    test('Buy again: delivered orders, newest first, no repeats', () {
      ShopOrder o(String id, String status, int day, List<String> items) =>
          ShopOrder(id, {'status': status, 'createdAt': DateTime(2026, 10, day), 'items': [for (final i in items) {'productId': i}]});
      expect(buyAgainIds([o('a', 'delivered', 1, ['x', 'y']), o('b', 'delivered', 5, ['y', 'z']), o('c', 'cancelled', 9, ['q'])]), ['y', 'z', 'x']);
    });

    test('subscriptions every 2, 4 or 6 weeks', () {
      expect(nextSubscriptionDate(DateTime(2026, 10, 14, 15), 4), DateTime(2026, 11, 11, 9));
      final subs = [Subscription('a', {'nextAt': now.subtract(const Duration(hours: 1)), 'active': true}), Subscription('b', {'nextAt': now.subtract(const Duration(hours: 1)), 'active': false}), Subscription('c', {'nextAt': now.add(const Duration(days: 1))})];
      expect(dueSubscriptions(subs, now).map((s) => s.id), ['a']);
    });
  });

  group('expenses', () {
    final list = [
      Expense('1', {'category': 'food', 'amount': 3899, 'date': DateTime(2026, 10, 2), 'petId': 'bruno'}),
      Expense('2', {'category': 'vet', 'amount': 1850, 'date': DateTime(2026, 9, 3), 'petId': 'bruno'}),
      Expense('3', {'category': 'food', 'amount': 1599, 'date': DateTime(2026, 9, 12), 'petId': 'misty'}),
      Expense('4', {'category': 'nonsense', 'amount': 100, 'date': DateTime(2026, 4, 1)}),
    ];

    test('monthly totals per category and per pet', () {
      final m = monthlyTotals(list, now, months: 3);
      expect(m.map((t) => t.month), [DateTime(2026, 8), DateTime(2026, 9), DateTime(2026, 10)]);
      expect(m[1].byCategory, {'vet': 1850, 'food': 1599});
      expect(m[2].total, 3899);
      expect(monthlyTotals(list, now, months: 3, petId: 'bruno')[1].total, 1850);
      expect(list.last.category, 'other');
      expect(categoryTotals(list, from: DateTime(2026, 9)), {'food': 5498, 'vet': 1850});
    });
  });

  group('seller CSV upload', () {
    test('valid rows, quoted commas and clear problems per row', () {
      final rows = parseProductCsv('name,brand,category,species,price,mrp,stock,packKg,description\n'
          '"Biscuits, peanut",Tail,treats,dog,249,299,40,0.5,"Baked, crunchy"\n'
          'Mouse toy,Tail,toys,cat|dog,199,,60,,\n'
          ',X,food,lion,0,10,-1,abc,\n');
      expect(rows.length, 3);
      expect(rows[0].ok, isTrue);
      expect(rows[0].data['name'], 'Biscuits, peanut');
      expect(rows[0].data['description'], 'Baked, crunchy');
      expect(rows[1].ok, isTrue);
      expect(rows[1].data['species'], ['cat', 'dog']);
      expect(rows[1].data['mrp'], 199);
      expect(rows[2].ok, isFalse);
      expect(rows[2].errors, containsAll(['name', 'species', 'price', 'stock', 'packKg']));
      expect(rows[2].line, 4);
    });

    test('the sample template parses cleanly', () {
      expect(parseProductCsv(sampleProductCsv).every((r) => r.ok), isTrue);
    });
  });

  group('demo data', () {
    final data = DemoSeed.build(DateTime(2026, 10, 14, 9));

    test("Bruno's food runs out in about 5 days", () {
      final b = data['pets']!['pet_bruno']!;
      final left = foodDaysLeft(bagKg: (b['foodBagKg'] as num).toDouble(), dailyGrams: b['dailyPortionG'] as int, openedAt: b['foodOpenedAt'] as DateTime, now: DateTime(2026, 10, 14, 9));
      expect(roundDays(left!), 5);
      expect(b['foodProductId'], 'prod_lab_adult_10');
      expect(data['products']!['prod_lab_adult_10']!['sellerId'], 'seller_1');
      expect(data['sellers']!['seller_1']!['uid'], 'u_seller');
    });

    test('orders in every state, one subscription, coupons and expenses', () {
      final statuses = {for (final o in data['orders']!.values) o['status']};
      expect(statuses, containsAll(['placed', 'packed', 'shipped', 'out_for_delivery', 'delivered', 'cancelled', 'return_requested', 'returned']));
      expect(data['subscriptions']!.length, 1);
      expect(data['coupons']!.keys, containsAll(['WELCOME10', 'PAWS100']));
      for (final e in data['orders']!.entries) {
        final o = ShopOrder(e.key, e.value);
        expect(o.total, o.subtotal - o.discount + o.deliveryFee, reason: e.key);
        if (o.status == 'cancelled' || o.status == 'returned') continue;
        final exp = data['expenses']!.entries.where((x) => x.value['sourceId'] == e.key).fold<int>(0, (s, x) => s + (x.value['amount'] as int));
        expect(exp, o.total, reason: 'expenses for ${e.key}');
      }
    });
  });
}
