import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/app_user.dart';
import '../../../core/l10n/gen/app_localizations.dart';
import '../../../core/providers.dart';
import '../../../core/services/messaging_service.dart';
import '../../../core/services/service_providers.dart';
import '../../../core/utils/format.dart';
import '../../pets/domain/pet.dart';
import '../domain/food_stock.dart';
import '../domain/shop_models.dart';
import '../domain/shop_rules.dart';

class OrderException implements Exception {
  OrderException(this.code);

  /// empty, coupon, stock, payment
  final String code;
  @override
  String toString() => 'OrderException($code)';
}

/// Orders, subscriptions and the expenses they create (spec 7.10, 7.14).
/// Standalone demo: priced and written here with the shared rules.
/// Emulator / live: the createOrder Cloud Function prices the order,
/// checks stock and the coupon, and writes the orders, expenses and seller
/// notifications.
class OrderRepository {
  OrderRepository(this._db, this._messages, {this.functions});
  final FirebaseFirestore _db;
  final MessagingService _messages;
  final FirebaseFunctions? functions;

  CollectionReference<Map<String, dynamic>> get _orders => _db.collection('orders');

  Stream<List<ShopOrder>> watchOwner(String uid) => _orders
      .where('ownerId', isEqualTo: uid)
      .snapshots()
      .map((s) => [for (final d in s.docs) ShopOrder(d.id, d.data())]..sort((a, b) => b.createdAt.compareTo(a.createdAt)));

  Stream<List<ShopOrder>> watchSeller(String uid) => _orders
      .where('sellerUids', arrayContains: uid)
      .snapshots()
      .map((s) => [for (final d in s.docs) ShopOrder(d.id, d.data())]..sort((a, b) => b.createdAt.compareTo(a.createdAt)));

  Stream<ShopOrder?> watchOne(String id) => _orders.doc(id).snapshots().map((d) => d.exists ? ShopOrder(d.id, d.data()!) : null);

  Stream<List<ShopOrder>> watchGroup(String uid, String groupId) => _orders
      .where('ownerId', isEqualTo: uid)
      .where('groupId', isEqualTo: groupId)
      .snapshots()
      .map((s) => [for (final d in s.docs) ShopOrder(d.id, d.data())]);

  Future<AppLocalizations> _lang(String uid) async {
    final u = await _db.collection('users').doc(uid).get();
    return lookupAppLocalizations(Locale((u.data()?['language'] as String?) ?? 'en'));
  }

  Future<void> _notify(String uid, String Function(AppLocalizations l) title, String link) async {
    final l = await _lang(uid);
    await _db.collection('notifications').add({
      'uid': uid,
      'title': title(l),
      'body': '',
      'type': 'orders',
      'link': link,
      'read': false,
      'createdAt': DateTime.now(),
    });
  }

  // ---------- placing orders ----------

  /// Places the cart as one order per seller. Returns the group id.
  Future<String> place({
    required AppUser owner,
    Pet? pet,
    required List<CartLine> lines,
    String? couponCode,
    required Address address,
    required ({DateTime date, String window}) slot,
    required String paymentMethod,
    required String paymentStatus,
    String source = 'cart',
    String? subscriptionId,
  }) async {
    final fns = functions;
    if (fns != null) {
      final res = await fns.httpsCallable('createOrder').call<Map<String, dynamic>>({
        'lines': [for (final l in lines) l.toMap()],
        'couponCode': couponCode,
        'address': address.toMap(),
        'slot': {'date': slot.date.toIso8601String(), 'window': slot.window},
        'petId': pet?.id,
        'paymentMethod': paymentMethod,
        'paymentStatus': paymentStatus,
        'source': source,
        'subscriptionId': subscriptionId,
      });
      return res.data['groupId'] as String;
    }

    final now = DateTime.now();
    final products = <String, Product>{};
    for (final l in lines) {
      final d = await _db.collection('products').doc(l.productId).get();
      if (d.exists) products[d.id] = Product(d.id, d.data()!);
    }
    final sellers = <String, Seller>{};
    for (final p in products.values) {
      final id = p.sellerId;
      if (id == null || sellers.containsKey(id)) continue;
      final d = await _db.collection('sellers').doc(id).get();
      if (d.exists) sellers[id] = Seller(d.id, d.data()!);
    }
    final cfg = (await _db.collection('config').doc('app').get()).data();
    final settings = ShopSettings.fromConfig(cfg);
    Coupon? coupon;
    if (couponCode != null && couponCode.isNotEmpty) {
      final d = await _db.collection('coupons').doc(normaliseCoupon(couponCode)).get();
      if (!d.exists) throw OrderException('coupon');
      coupon = Coupon(d.id, d.data()!);
    }
    final price = priceCart(
      lines,
      products,
      plus: owner.isPlus,
      settings: settings,
      sellerOverrides: {for (final s in sellers.values) s.id: s.commissionPercent},
      coupon: coupon,
      now: now,
    );
    if (price.isEmpty) throw OrderException('empty');
    if (coupon != null && price.coupon?.result != CouponResult.ok) throw OrderException('coupon');

    final groupId = _orders.doc().id;
    final batch = _db.batch();
    final created = <(String, SellerGroup)>[];
    var seq = now.millisecondsSinceEpoch % 90000 + 10000;
    for (final g in price.groups) {
      final ref = _orders.doc();
      final seller = sellers[g.sellerId];
      final expected = addWorkingDays(Fmt.dayOnly(now), g.deliveryDays);
      final data = {
        'groupId': groupId,
        'ownerId': owner.uid,
        'ownerName': owner.name,
        'petId': pet?.id,
        'petName': pet?.name,
        'sellerId': g.sellerId,
        'sellerName': seller?.name ?? '',
        'sellerUids': [?seller?.uid],
        'items': [
          for (final l in g.lines)
            {
              'productId': l.product.id,
              'name': l.product.name,
              'brand': l.product.brand,
              'category': l.product.category,
              'qty': l.qty,
              'price': l.product.price,
              'mrp': l.product.mrp,
              'commissionPercent': l.commissionPercent,
              'commission': l.commission,
              'packKg': l.product.packKg,
              'returnable': l.product.returnable,
              'imageSeed': l.product.imageSeed,
            },
        ],
        'subtotal': g.subtotal,
        'discount': g.discount,
        'coupon': coupon?.code,
        'deliveryFee': g.deliveryFee,
        'total': g.total,
        'commission': g.commission,
        'payout': g.subtotal - g.commission,
        'payoutStatus': 'pending',
        // Tax fields are placeholders until GST is set up (spec 8).
        'tax': {'gstPercent': null, 'gstAmount': 0},
        'address': address.toMap(),
        'slot': {'date': slot.date, 'window': slot.window},
        'expectedBy': slot.date.isAfter(expected) ? slot.date : expected,
        'status': 'placed',
        'timeline': [
          {'status': 'placed', 'at': now},
        ],
        'paymentMethod': paymentMethod,
        'paymentStatus': paymentStatus,
        'invoiceNo': invoiceNumber(now, seq++),
        'source': source,
        'subscriptionId': subscriptionId,
        'reviewed': <String, bool>{},
        'createdAt': now,
      };
      batch.set(ref, data);
      created.add((ref.id, g));
      for (final l in g.lines) {
        batch.update(_db.collection('products').doc(l.product.id), {'stock': FieldValue.increment(-l.qty)});
      }
    }
    if (coupon != null) batch.update(_db.collection('coupons').doc(coupon.code), {'uses': FieldValue.increment(1)});
    await batch.commit();

    for (final (id, g) in created) {
      final o = ShopOrder(id, (await _orders.doc(id).get()).data()!);
      await _writeExpenses(o);
      final sellerUid = sellers[g.sellerId]?.uid;
      if (sellerUid != null) {
        final first = g.lines.first;
        await _notify(sellerUid, (l) => l.ntfNewOrder(first.product.name, g.lines.length), '/partner/order/$id');
      }
    }
    final l = await _lang(owner.uid);
    await _messages.send(
      channel: Channel.email,
      to: owner.email ?? owner.uid,
      uid: owner.uid,
      type: 'orders',
      subject: l.orderEmailSubject,
      body: l.orderEmailBody(owner.firstName, Fmt.inr(price.total), Fmt.date(slot.date, l.localeName)),
    );
    return groupId;
  }

  Future<void> _writeExpenses(ShopOrder o) async {
    final parts = orderExpenseSplit(o);
    final name = o.items.length == 1 ? o.items.first.name : '${o.items.first.name} +${o.items.length - 1}';
    for (final p in parts) {
      await _db.collection('expenses').doc('exp_${o.id}_${p.category}').set({
        'ownerId': o.ownerId,
        'petId': o.petId,
        'category': p.category,
        'amount': p.amount,
        'date': o.createdAt,
        'note': name,
        'source': 'order',
        'sourceId': o.id,
      });
    }
  }

  Future<void> _deleteExpenses(String orderId) async {
    for (final c in ['food', 'supplies']) {
      final ref = _db.collection('expenses').doc('exp_${orderId}_$c');
      if ((await ref.get()).exists) await ref.delete();
    }
  }

  Future<void> _restock(ShopOrder o) async {
    for (final i in o.items) {
      await _db.collection('products').doc(i.productId).update({'stock': FieldValue.increment(i.qty)});
    }
  }

  // ---------- after the order ----------

  Future<void> _setStatus(ShopOrder o, String status, {Map<String, dynamic> extra = const {}}) async {
    final now = DateTime.now();
    await _orders.doc(o.id).update({
      ...extra,
      'status': status,
      'timeline': FieldValue.arrayUnion([
        {'status': status, 'at': now},
      ]),
      if (status == 'delivered') 'deliveredAt': now,
    });
  }

  /// Payment that was pending is completed (demo payment sheet again).
  Future<void> markPaid(ShopOrder o) => _orders.doc(o.id).update({'paymentStatus': 'paid'});

  /// The customer cancels before shipping; paid orders are refunded (demo).
  Future<void> cancel(ShopOrder o, {required String reason, bool bySeller = false}) async {
    await _setStatus(o, 'cancelled', extra: {
      'cancelReason': reason,
      'cancelledBy': bySeller ? 'seller' : 'customer',
      if (o.paymentStatus == 'paid') 'paymentStatus': 'refunded',
    });
    if (functions == null) {
      await _restock(o);
      await _deleteExpenses(o.id);
    }
    if (bySeller) {
      await _notify(o.ownerId, (l) => l.ntfOrderCancelledBySeller(o.items.first.name), '/shop/orders/${o.id}');
    } else {
      for (final uid in o.sellerUids) {
        await _notify(uid, (l) => l.ntfOrderCancelled(shortOrderNo(o.id)), '/partner/order/${o.id}');
      }
    }
  }

  Future<void> requestReturn(ShopOrder o, {required String reason}) async {
    await _setStatus(o, 'return_requested', extra: {'returnReason': reason});
    for (final uid in o.sellerUids) {
      await _notify(uid, (l) => l.ntfReturnRequested(shortOrderNo(o.id)), '/partner/order/${o.id}');
    }
  }

  /// Seller moves the order along: packed, shipped, out for delivery,
  /// delivered; or accepts / rejects a return.
  Future<void> sellerUpdate(ShopOrder o, String status, {String? note}) async {
    if (status == 'cancelled') return cancel(o, reason: note ?? '', bySeller: true);
    await _setStatus(o, status, extra: {
      if (status == 'returned' && o.paymentStatus == 'paid') 'paymentStatus': 'refunded',
      if (note != null && note.isNotEmpty) 'sellerNote': note,
    });
    if (functions == null) {
      if (status == 'returned') {
        await _restock(o);
        await _deleteExpenses(o.id);
      }
      if (status == 'delivered') await _openNewFoodBag(o);
    }
    final first = o.items.first.name;
    await _notify(o.ownerId, (l) => switch (status) {
          'packed' => l.ntfOrderPacked(first),
          'shipped' => l.ntfOrderShipped(first),
          'out_for_delivery' => l.ntfOrderOutForDelivery(first),
          'delivered' => l.ntfOrderDelivered(first),
          'returned' => l.ntfReturnAccepted(first),
          'return_rejected' => l.ntfReturnRejected(first),
          _ => l.ntfOrderUpdated(first),
        }, '/shop/orders/${o.id}');
    if (status == 'out_for_delivery') {
      final u = (await _db.collection('users').doc(o.ownerId).get()).data();
      final l = await _lang(o.ownerId);
      await _messages.send(channel: Channel.sms, to: (u?['phone'] as String?) ?? o.ownerId, uid: o.ownerId, type: 'orders', body: l.ntfOrderOutForDelivery(first));
    }
  }

  /// A delivered food bag becomes the pet's current bag (opened when the
  /// old one runs out), so the "food running low" card starts again.
  Future<void> _openNewFoodBag(ShopOrder o) async {
    final petId = o.petId;
    if (petId == null) return;
    final food = o.items.where((i) => i.category == 'food' && (i.packKg ?? 0) > 0).firstOrNull;
    if (food == null) return;
    final petRef = _db.collection('pets').doc(petId);
    final pet = (await petRef.get()).data();
    if (pet == null) return;
    final oldRunOut = foodRunOutDate(
      bagKg: (pet['foodBagKg'] as num?)?.toDouble(),
      dailyGrams: (pet['dailyPortionG'] as num?)?.toInt(),
      openedAt: pet['foodOpenedAt'] is Timestamp ? (pet['foodOpenedAt'] as Timestamp).toDate() : pet['foodOpenedAt'] as DateTime?,
    );
    await petRef.update({
      'foodProductId': food.productId,
      'foodBagKg': food.packKg! * food.qty,
      'foodOpenedAt': newBagOpenedAt(deliveredAt: DateTime.now(), oldRunOut: oldRunOut),
      if (pet['dailyPortionG'] == null)
        'dailyPortionG': suggestedDailyGrams(species: (pet['species'] as String?) ?? 'dog', weightKg: (pet['weightKg'] as num?)?.toDouble()),
    });
  }

  /// Weekly payout run (simulated): delivered orders past the return window
  /// are marked paid.
  Future<int> runPayouts(Iterable<ShopOrder> orders) async {
    final now = DateTime.now();
    var n = 0;
    for (final o in orders.where((o) => payoutState(o, now) == 'ready')) {
      await _orders.doc(o.id).update({'payoutStatus': 'paid', 'paidOutAt': now});
      n++;
    }
    return n;
  }

  // ---------- subscriptions ----------

  CollectionReference<Map<String, dynamic>> get _subs => _db.collection('subscriptions');

  Stream<List<Subscription>> watchSubscriptions(String uid) =>
      _subs.where('ownerId', isEqualTo: uid).snapshots().map((s) => [for (final d in s.docs) Subscription(d.id, d.data())]);

  Future<void> subscribe({required AppUser owner, Pet? pet, required Product p, required int qty, required int everyWeeks, required Address address}) async {
    await _subs.add({
      'ownerId': owner.uid,
      'petId': pet?.id,
      'productId': p.id,
      'productName': p.name,
      'qty': qty,
      'everyWeeks': everyWeeks,
      'nextAt': nextSubscriptionDate(DateTime.now(), everyWeeks),
      'active': true,
      'address': address.toMap(),
      'createdAt': DateTime.now(),
    });
  }

  Future<void> updateSubscription(String id, Map<String, dynamic> fields) => _subs.doc(id).update(fields);

  Future<void> deleteSubscription(String id) => _subs.doc(id).delete();

  /// Places orders for subscriptions that are due (pay on delivery). The
  /// standalone demo runs this when the shop opens; with Firebase a daily
  /// scheduled function does it.
  Future<int> runDueSubscriptions(AppUser owner, List<Subscription> subs, Map<String, Pet> pets) async {
    var n = 0;
    final now = DateTime.now();
    for (final s in dueSubscriptions(subs, now)) {
      final raw = (await _subs.doc(s.id).get()).data();
      final addr = Address.fromMap((raw?['address'] as Map?) ?? const {}, name: owner.name, phone: owner.phone ?? '');
      final slot = deliverySlots(addWorkingDays(Fmt.dayOnly(now), 2), now).first;
      try {
        final group = await place(
          owner: owner,
          pet: s.petId == null ? null : pets[s.petId],
          lines: [CartLine(s.productId, s.qty)],
          address: addr,
          slot: slot,
          paymentMethod: 'cod',
          paymentStatus: 'cod',
          source: 'subscription',
          subscriptionId: s.id,
        );
        await _subs.doc(s.id).update({'nextAt': nextSubscriptionDate(now, s.everyWeeks), 'lastOrderGroup': group, 'lastRunAt': now});
        await _notify(owner.uid, (l) => l.ntfSubscriptionOrdered(s.productName), '/shop/orders');
        n++;
      } on OrderException {
        await _subs.doc(s.id).update({'nextAt': DateTime(now.year, now.month, now.day + 1, 9)});
      }
    }
    return n;
  }

  // ---------- expenses ----------

  CollectionReference<Map<String, dynamic>> get _exp => _db.collection('expenses');

  Stream<List<Expense>> watchExpenses(String uid) =>
      _exp.where('ownerId', isEqualTo: uid).snapshots().map((s) => [for (final d in s.docs) Expense(d.id, d.data())]..sort((a, b) => b.date.compareTo(a.date)));

  Future<void> addExpense({required String uid, String? petId, required String category, required int amount, required DateTime date, String note = ''}) => _exp.add({
        'ownerId': uid,
        'petId': petId,
        'category': category,
        'amount': amount,
        'date': date,
        'note': note.trim(),
        'source': 'manual',
        'createdAt': DateTime.now(),
      });

  Future<void> updateExpense(String id, Map<String, dynamic> fields) => _exp.doc(id).update(fields);

  Future<void> deleteExpense(String id) => _exp.doc(id).delete();
}

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final cfg = ref.watch(appConfigProvider);
  return OrderRepository(
    ref.watch(firestoreProvider),
    ref.watch(messagingServiceProvider),
    functions: cfg.isStandalone ? null : FirebaseFunctions.instanceFor(region: 'asia-south1'),
  );
});

final myOrdersProvider = StreamProvider<List<ShopOrder>>((ref) {
  final u = ref.watch(currentUserProvider);
  if (u == null) return Stream.value(const []);
  return ref.watch(orderRepositoryProvider).watchOwner(u.uid);
});

final sellerOrdersProvider = StreamProvider<List<ShopOrder>>((ref) {
  final u = ref.watch(currentUserProvider);
  if (u == null) return Stream.value(const []);
  return ref.watch(orderRepositoryProvider).watchSeller(u.uid);
});

final orderProvider = StreamProvider.family<ShopOrder?, String>((ref, id) => ref.watch(orderRepositoryProvider).watchOne(id));

final orderGroupProvider = StreamProvider.family<List<ShopOrder>, String>((ref, groupId) {
  final u = ref.watch(currentUserProvider);
  if (u == null) return Stream.value(const []);
  return ref.watch(orderRepositoryProvider).watchGroup(u.uid, groupId);
});

final mySubscriptionsProvider = StreamProvider<List<Subscription>>((ref) {
  final u = ref.watch(currentUserProvider);
  if (u == null) return Stream.value(const []);
  return ref.watch(orderRepositoryProvider).watchSubscriptions(u.uid);
});

final myExpensesProvider = StreamProvider<List<Expense>>((ref) {
  final u = ref.watch(currentUserProvider);
  if (u == null) return Stream.value(const []);
  return ref.watch(orderRepositoryProvider).watchExpenses(u.uid);
});
