import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/app_user.dart';
import '../../../core/providers.dart';
import '../domain/shop_models.dart';
import '../domain/shop_rules.dart';

/// Catalogue, cart, address book, partner-store clicks and product reviews.
class ShopRepository {
  ShopRepository(this._db, {this.standalone = true});
  final FirebaseFirestore _db;

  /// Standalone demo: no Cloud Functions, so counters are updated here.
  final bool standalone;

  // ---------- catalogue ----------

  Stream<List<Product>> watchProducts() =>
      _db.collection('products').snapshots().map((s) => [for (final d in s.docs) Product(d.id, d.data())]);

  Stream<Product?> watchProduct(String id) => _db.collection('products').doc(id).snapshots().map((d) => d.exists ? Product(d.id, d.data()!) : null);

  Stream<List<Seller>> watchSellers() => _db.collection('sellers').snapshots().map((s) => [for (final d in s.docs) Seller(d.id, d.data())]);

  Stream<List<PartnerStore>> watchPartners() => _db.collection('partners').snapshots().map((s) => [for (final d in s.docs) PartnerStore(d.id, d.data())]);

  Future<Coupon?> coupon(String code) async {
    final c = normaliseCoupon(code);
    if (c.isEmpty) return null;
    final d = await _db.collection('coupons').doc(c).get();
    return d.exists ? Coupon(d.id, d.data()!) : null;
  }

  Stream<List<Coupon>> watchCoupons() =>
      _db.collection('coupons').snapshots().map((s) => [for (final d in s.docs) Coupon(d.id, d.data())]);

  // ---------- cart ----------

  DocumentReference<Map<String, dynamic>> _cart(String uid) => _db.collection('carts').doc(uid);

  Stream<List<CartLine>> watchCart(String uid) => _cart(uid).snapshots().map((d) => [
        for (final i in (d.data()?['items'] as List?) ?? const [])
          if (i is Map) CartLine.fromMap(i),
      ]);

  Future<List<CartLine>> _readCart(String uid) async {
    final d = await _cart(uid).get();
    return [
      for (final i in (d.data()?['items'] as List?) ?? const [])
        if (i is Map) CartLine.fromMap(i),
    ];
  }

  Future<void> _writeCart(String uid, List<CartLine> lines, {String? coupon}) => _cart(uid).set({
        'items': [for (final l in lines) l.toMap()],
        'updatedAt': DateTime.now(),
        'coupon': ?coupon,
      }, SetOptions(merge: true));

  /// Adds [qty] (or sets it with [replace]). Quantity 0 removes the line.
  Future<void> setQty(String uid, String productId, int qty, {bool replace = true}) async {
    final lines = await _readCart(uid);
    final i = lines.indexWhere((l) => l.productId == productId);
    final next = replace ? qty : (i >= 0 ? lines[i].qty : 0) + qty;
    if (i >= 0) lines.removeAt(i);
    if (next > 0) lines.insert(i >= 0 ? i : lines.length, CartLine(productId, next.clamp(1, 20)));
    await _writeCart(uid, lines);
  }

  Future<void> addToCart(String uid, String productId, {int qty = 1}) => setQty(uid, productId, qty, replace: false);

  Future<void> removeLines(String uid, Iterable<String> productIds) async {
    final ids = productIds.toSet();
    final lines = await _readCart(uid);
    await _writeCart(uid, lines.where((l) => !ids.contains(l.productId)).toList());
  }

  Future<void> setCartCoupon(String uid, String? code) => _cart(uid).set({'coupon': code}, SetOptions(merge: true));

  Stream<String?> watchCartCoupon(String uid) => _cart(uid).snapshots().map((d) => d.data()?['coupon'] as String?);

  // ---------- address book ----------

  Stream<List<Address>> watchAddresses(AppUser u) => _db.collection('users').doc(u.uid).snapshots().map((d) {
        final data = d.data() ?? const {};
        return [
          for (final a in (data['addresses'] as List?) ?? const [])
            if (a is Map) Address.fromMap(a, name: u.name, phone: u.phone ?? ''),
        ];
      });

  Future<void> saveAddress(String uid, Address a, List<Address> current) async {
    final list = [for (final x in current) x.id == a.id ? a : x];
    if (!current.any((x) => x.id == a.id)) list.add(a);
    await _db.collection('users').doc(uid).update({'addresses': [for (final x in list) x.toMap()]});
  }

  Future<void> deleteAddress(String uid, String id, List<Address> current) =>
      _db.collection('users').doc(uid).update({'addresses': [for (final x in current) if (x.id != id) x.toMap()]});

  // ---------- partner stores ----------

  /// Records a click on a partner-store (affiliate) listing (spec 8:
  /// affiliate clicks tracked). With Firebase, a trigger adds it to the
  /// partner's click count.
  Future<void> trackAffiliateClick({required String uid, required Product p}) async {
    await _db.collection('affiliateClicks').add({'uid': uid, 'productId': p.id, 'partnerId': p.partnerId, 'at': DateTime.now()});
    if (standalone && p.partnerId != null) {
      await _db.collection('partners').doc(p.partnerId).update({'clicks': FieldValue.increment(1)});
    }
  }

  // ---------- reviews ----------

  /// Verified product review after delivery; updates the average rating.
  Future<void> addProductReview({required Product p, required String orderId, required AppUser by, required int rating, required String text}) async {
    await _db.collection('reviews').add({
      'targetType': 'product',
      'targetId': p.id,
      'sellerId': p.sellerId,
      'ownerId': by.uid,
      'ownerName': by.name,
      'orderId': orderId,
      'rating': rating,
      'text': text.trim(),
      'status': 'visible',
      'createdAt': DateTime.now(),
    });
    if (standalone) {
      final n = p.reviewCount + 1;
      final avg = (p.rating * p.reviewCount + rating) / n;
      await _db.collection('products').doc(p.id).update({'rating': double.parse(avg.toStringAsFixed(1)), 'reviewCount': n});
    }
    await _db.collection('orders').doc(orderId).update({'reviewed.${p.id}': true});
  }

  // ---------- seller products ----------

  Stream<List<Product>> watchSellerProducts(String sellerId) =>
      _db.collection('products').where('sellerId', isEqualTo: sellerId).snapshots().map((s) => [for (final d in s.docs) Product(d.id, d.data())]);

  Future<void> updateProduct(String id, Map<String, dynamic> fields) => _db.collection('products').doc(id).update({...fields, 'updatedAt': DateTime.now()});

  Future<String> addProduct(String sellerId, Map<String, dynamic> fields) async {
    final ref = await _db.collection('products').add({
      'lifeStages': ['all'],
      'breedSizes': ['all'],
      'rating': 0,
      'reviewCount': 0,
      'deliveryDays': 3,
      'returnable': fields['category'] != 'food' && fields['category'] != 'treats',
      'active': true,
      'imageSeed': DateTime.now().millisecond % 8,
      ...fields,
      'sellerId': sellerId,
      'partnerId': null,
      'affiliateUrl': null,
      'createdAt': DateTime.now(),
    });
    return ref.id;
  }

  /// Adds the valid rows of a CSV upload. Returns how many were added.
  Future<int> importProducts(String sellerId, List<CsvRow> rows) async {
    var n = 0;
    final batch = _db.batch();
    for (final r in rows.where((r) => r.ok)) {
      final ref = _db.collection('products').doc();
      final cat = r.data['category'] as String;
      batch.set(ref, {
        ...r.data,
        'lifeStages': ['all'],
        'breedSizes': ['all'],
        'rating': 0,
        'reviewCount': 0,
        'deliveryDays': 3,
        'returnable': cat != 'food' && cat != 'treats',
        'active': true,
        'imageSeed': n % 8,
        'sellerId': sellerId,
        'partnerId': null,
        'affiliateUrl': null,
        'source': 'csv',
        'createdAt': DateTime.now(),
      });
      n++;
    }
    await batch.commit();
    return n;
  }
}

final shopRepositoryProvider = Provider<ShopRepository>((ref) => ShopRepository(ref.watch(firestoreProvider), standalone: ref.watch(appConfigProvider).isStandalone));

final productsProvider = StreamProvider<List<Product>>((ref) => ref.watch(shopRepositoryProvider).watchProducts());

final productMapProvider = Provider<Map<String, Product>>((ref) => {for (final p in ref.watch(productsProvider).value ?? const <Product>[]) p.id: p});

final productProvider = StreamProvider.family<Product?, String>((ref, id) => ref.watch(shopRepositoryProvider).watchProduct(id));

final sellersProvider = StreamProvider<List<Seller>>((ref) => ref.watch(shopRepositoryProvider).watchSellers());

final sellerMapProvider = Provider<Map<String, Seller>>((ref) => {for (final s in ref.watch(sellersProvider).value ?? const <Seller>[]) s.id: s});

final partnerStoresProvider = StreamProvider<List<PartnerStore>>((ref) => ref.watch(shopRepositoryProvider).watchPartners());

final cartProvider = StreamProvider<List<CartLine>>((ref) {
  final u = ref.watch(currentUserProvider);
  if (u == null) return Stream.value(const []);
  return ref.watch(shopRepositoryProvider).watchCart(u.uid);
});

final cartCouponProvider = StreamProvider<String?>((ref) {
  final u = ref.watch(currentUserProvider);
  if (u == null) return Stream.value(null);
  return ref.watch(shopRepositoryProvider).watchCartCoupon(u.uid);
});

/// Number of items in the cart (badge).
final cartCountProvider = Provider<int>((ref) => (ref.watch(cartProvider).value ?? const <CartLine>[]).fold(0, (s, l) => s + l.qty));

final addressesProvider = StreamProvider<List<Address>>((ref) {
  final u = ref.watch(currentUserProvider);
  if (u == null) return Stream.value(const []);
  return ref.watch(shopRepositoryProvider).watchAddresses(u);
});

final shopSettingsProvider = Provider<ShopSettings>((ref) => ShopSettings.fromConfig(ref.watch(appSettingsDocProvider).value));

/// The seller this account manages (seller demo account: Tail Treats Traders).
final mySellerProvider = Provider<Seller?>((ref) {
  final u = ref.watch(currentUserProvider);
  if (u == null) return null;
  final sellers = ref.watch(sellersProvider).value ?? const <Seller>[];
  return sellers.where((s) => s.uid == u.uid || s.id == u.partnerId).firstOrNull;
});

final sellerProductsProvider = StreamProvider.family<List<Product>, String>((ref, sellerId) => ref.watch(shopRepositoryProvider).watchSellerProducts(sellerId));
