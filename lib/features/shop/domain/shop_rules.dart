/// Marketplace rules (spec 7.10 and 8): cart pricing, coupons, delivery,
/// commission, splitting a multi-seller cart into orders, delivery dates and
/// slots, cancel and return windows, search, personalised picks, Buy again,
/// subscriptions and expenses. Pure Dart: the standalone demo runs these on
/// the device, and the createOrder Cloud Function (functions/src/phase8.ts)
/// applies the same rules on the server.
library;

import 'shop_models.dart';

// ---------- money settings (config/app, admin-configurable) ----------

class ShopSettings {
  const ShopSettings({
    this.foodMarginPercent = 8,
    this.otherMarginPercent = 15,
    this.categoryPercent = const {},
    this.deliveryFee = 49,
    this.freeDeliveryAbove = 999,
    this.plusFreeDeliveryAbove = 499,
  });

  /// Default margin on food (spec 8: 8%) and on other categories (15%).
  final num foodMarginPercent;
  final num otherMarginPercent;

  /// Per-category overrides set in the admin panel.
  final Map<String, num> categoryPercent;
  final int deliveryFee;
  final int freeDeliveryAbove;

  /// Plus perk: free delivery above ₹499.
  final int plusFreeDeliveryAbove;

  static ShopSettings fromConfig(Map<String, dynamic>? cfg) {
    final c = (cfg?['commission'] as Map?) ?? const {};
    final s = (cfg?['shop'] as Map?) ?? const {};
    final cats = (c['categoryPercent'] as Map?) ?? const {};
    return ShopSettings(
      foodMarginPercent: (c['foodMarginPercent'] as num?) ?? 8,
      otherMarginPercent: (c['otherMarginPercent'] as num?) ?? 15,
      categoryPercent: {for (final e in cats.entries) '${e.key}': (e.value as num)},
      deliveryFee: (s['deliveryFee'] as num?)?.toInt() ?? 49,
      freeDeliveryAbove: (s['freeDeliveryAbove'] as num?)?.toInt() ?? 999,
      plusFreeDeliveryAbove: (c['freeDeliveryAbove'] as num?)?.toInt() ?? 499,
    );
  }
}

/// Commission percent for one item: seller override first (a number or a
/// per-category map), then the admin's per-category rate, then the default.
num commissionPercent(String category, ShopSettings s, {Object? sellerOverride}) {
  if (sellerOverride is num) return sellerOverride;
  if (sellerOverride is Map && sellerOverride[category] is num) return sellerOverride[category] as num;
  final c = s.categoryPercent[category];
  if (c != null) return c;
  return category == 'food' ? s.foodMarginPercent : s.otherMarginPercent;
}

int commissionAmount(int amount, num percent) => (amount * percent / 100).round();

// ---------- coupons ----------

enum CouponResult { ok, notFound, inactive, expired, minOrder, usedUp }

/// Checks a coupon against a cart subtotal and returns the discount.
({CouponResult result, int discount}) checkCoupon(Coupon? c, {required int subtotal, required DateTime now}) {
  if (c == null) return (result: CouponResult.notFound, discount: 0);
  if (!c.active) return (result: CouponResult.inactive, discount: 0);
  final till = c.validTill;
  if (till != null && till.isBefore(now)) return (result: CouponResult.expired, discount: 0);
  if (c.maxUses != null && c.uses >= c.maxUses!) return (result: CouponResult.usedUp, discount: 0);
  if (subtotal < c.minOrder) return (result: CouponResult.minOrder, discount: 0);
  var d = 0;
  if (c.percent != null) d = (subtotal * c.percent! / 100).round();
  if (c.flat != null) d = c.flat!;
  if (c.maxDiscount != null && d > c.maxDiscount!) d = c.maxDiscount!;
  if (d > subtotal) d = subtotal;
  return (result: CouponResult.ok, discount: d);
}

String normaliseCoupon(String code) => code.trim().toUpperCase().replaceAll(RegExp(r'\s+'), '');

// ---------- delivery ----------

/// Delivery fee: free above ₹999, or above ₹499 for Plus (spec 8).
int deliveryFeeFor(int amountAfterDiscount, {required bool plus, ShopSettings s = const ShopSettings()}) {
  if (amountAfterDiscount <= 0) return 0;
  final freeAbove = plus ? s.plusFreeDeliveryAbove : s.freeDeliveryAbove;
  return amountAfterDiscount >= freeAbove ? 0 : s.deliveryFee;
}

/// Indian PIN codes are 6 digits and never start with 0.
bool isValidPinCode(String pin) => RegExp(r'^[1-9][0-9]{5}$').hasMatch(pin.trim());

/// Big-city PIN prefixes deliver at the product's normal speed; elsewhere
/// adds two days.
const _fastPinPrefixes = ['110', '120', '122', '201', '400', '401', '411', '500', '560', '600'];

/// Delivery window for [pin]: (earliest, latest) dates, skipping Sundays.
({DateTime from, DateTime to})? deliveryEstimate(String pin, int deliveryDays, DateTime now) {
  if (!isValidPinCode(pin)) return null;
  final fast = _fastPinPrefixes.any(pin.trim().startsWith);
  final days = deliveryDays + (fast ? 0 : 2);
  final from = addWorkingDays(DateTime(now.year, now.month, now.day), days);
  return (from: from, to: addWorkingDays(from, 1));
}

DateTime addWorkingDays(DateTime d, int days) {
  var out = d;
  var left = days;
  while (left > 0) {
    out = DateTime(out.year, out.month, out.day + 1);
    if (out.weekday != DateTime.sunday) left--;
  }
  return out;
}

/// Delivery time windows (24 h clock).
const deliveryWindows = ['09-12', '12-15', '15-18', '18-21'];

/// Three delivery days with four windows each, starting at [earliest].
/// Today's windows that start within 2 hours are left out.
List<({DateTime date, String window})> deliverySlots(DateTime earliest, DateTime now, {int days = 3}) {
  final out = <({DateTime date, String window})>[];
  var d = DateTime(earliest.year, earliest.month, earliest.day);
  while (out.length < days * deliveryWindows.length) {
    if (d.weekday != DateTime.sunday) {
      for (final w in deliveryWindows) {
        final startHour = int.parse(w.split('-').first);
        final start = DateTime(d.year, d.month, d.day, startHour);
        if (start.isAfter(now.add(const Duration(hours: 2)))) out.add((date: d, window: w));
      }
    }
    d = DateTime(d.year, d.month, d.day + 1);
  }
  return out.take(days * deliveryWindows.length).toList();
}

// ---------- cart → orders ----------

class PricedLine {
  const PricedLine({required this.product, required this.qty, required this.commissionPercent});
  final Product product;
  final int qty;
  final num commissionPercent;
  int get amount => product.price * qty;
  int get mrpAmount => product.mrp * qty;
  int get commission => commissionAmount(amount, commissionPercent);
}

class SellerGroup {
  SellerGroup(this.sellerId, this.lines);
  final String sellerId;
  final List<PricedLine> lines;
  int get subtotal => lines.fold(0, (s, l) => s + l.amount);
  int get commission => lines.fold(0, (s, l) => s + l.commission);
  int get deliveryDays => lines.fold(0, (m, l) => l.product.deliveryDays > m ? l.product.deliveryDays : m);

  /// Set by [priceCart]: this group's share of the coupon and delivery fee.
  int discount = 0;
  int deliveryFee = 0;
  int get total => subtotal - discount + deliveryFee;
}

class CartPrice {
  CartPrice({required this.groups, required this.skipped, required this.subtotal, required this.mrpTotal, required this.discount, required this.deliveryFee, required this.coupon});
  final List<SellerGroup> groups;

  /// Affiliate or out-of-stock lines that cannot be checked out here.
  final List<CartLine> skipped;
  final int subtotal;
  final int mrpTotal;
  final int discount;
  final int deliveryFee;
  final ({CouponResult result, int discount})? coupon;
  int get total => subtotal - discount + deliveryFee;
  int get savings => mrpTotal - subtotal + discount;
  int get commission => groups.fold(0, (s, g) => s + g.commission);
  bool get isEmpty => groups.isEmpty;
  int get itemCount => groups.fold(0, (s, g) => s + g.lines.fold(0, (a, l) => a + l.qty));
}

/// Prices a cart. Lines are grouped by seller (one order per seller, as a
/// multi-vendor marketplace ships separately); the coupon and the delivery
/// fee are shared across the groups in proportion to their value, so the
/// orders add up exactly to what the customer pays.
CartPrice priceCart(
  List<CartLine> cart,
  Map<String, Product> products, {
  required bool plus,
  ShopSettings settings = const ShopSettings(),
  Map<String, Object?> sellerOverrides = const {},
  Coupon? coupon,
  required DateTime now,
}) {
  final bySeller = <String, List<PricedLine>>{};
  final skipped = <CartLine>[];
  for (final c in cart) {
    final p = products[c.productId];
    if (p == null || p.isAffiliate || !p.active || c.qty <= 0 || p.sellerId == null) {
      skipped.add(c);
      continue;
    }
    final stock = p.stock ?? 0;
    if (stock <= 0) {
      skipped.add(c);
      continue;
    }
    final qty = c.qty > stock ? stock : c.qty;
    final pct = commissionPercent(p.category, settings, sellerOverride: sellerOverrides[p.sellerId]);
    (bySeller[p.sellerId!] ??= []).add(PricedLine(product: p, qty: qty, commissionPercent: pct));
  }
  final groups = [for (final e in bySeller.entries) SellerGroup(e.key, e.value)];
  final subtotal = groups.fold(0, (s, g) => s + g.subtotal);
  final mrpTotal = groups.fold(0, (s, g) => s + g.lines.fold(0, (a, l) => a + l.mrpAmount));
  final couponCheck = coupon == null ? null : checkCoupon(coupon, subtotal: subtotal, now: now);
  final discount = couponCheck?.result == CouponResult.ok ? couponCheck!.discount : 0;
  final fee = deliveryFeeFor(subtotal - discount, plus: plus, s: settings);
  final weights = [for (final g in groups) g.subtotal];
  final d = allocate(discount, weights);
  final f = allocate(fee, weights);
  for (var i = 0; i < groups.length; i++) {
    groups[i].discount = d[i];
    groups[i].deliveryFee = f[i];
  }
  return CartPrice(groups: groups, skipped: skipped, subtotal: subtotal, mrpTotal: mrpTotal, discount: discount, deliveryFee: fee, coupon: couponCheck);
}

/// Splits [amount] in proportion to [weights] so the parts add up exactly
/// (largest remainders get the leftover rupees).
List<int> allocate(int amount, List<int> weights) {
  final total = weights.fold(0, (s, w) => s + w);
  if (weights.isEmpty) return const [];
  if (total <= 0) return [amount, for (var i = 1; i < weights.length; i++) 0];
  final exact = [for (final w in weights) amount * w / total];
  final out = [for (final e in exact) e.floor()];
  var left = amount - out.fold(0, (s, v) => s + v);
  final order = List.generate(weights.length, (i) => i)..sort((a, b) => (exact[b] - out[b]).compareTo(exact[a] - out[a]));
  for (final i in order) {
    if (left <= 0) break;
    out[i]++;
    left--;
  }
  return out;
}

/// Invoice number in the Indian financial-year style: PS/26-27/00123.
String invoiceNumber(DateTime at, int sequence) {
  final fyStart = at.month >= 4 ? at.year : at.year - 1;
  String yy(int y) => (y % 100).toString().padLeft(2, '0');
  return 'PS/${yy(fyStart)}-${yy(fyStart + 1)}/${sequence.toString().padLeft(5, '0')}';
}

/// A short order number people can read out on the phone.
String shortOrderNo(String orderId) {
  var h = 0;
  for (final c in orderId.codeUnits) {
    h = (h * 31 + c) & 0x7fffffff;
  }
  return 'PS${(h % 900000 + 100000)}';
}

// ---------- order life ----------

/// Statuses a seller can move an order to next.
List<String> sellerNextStatuses(String status) => switch (status) {
      'placed' => ['packed', 'cancelled'],
      'packed' => ['shipped', 'cancelled'],
      'shipped' => ['out_for_delivery'],
      'out_for_delivery' => ['delivered'],
      'return_requested' => ['returned', 'return_rejected'],
      _ => const [],
    };

/// Customers can cancel until the order ships.
bool canCancel(ShopOrder o) => o.status == 'placed' || o.status == 'packed';

/// Return window after delivery.
const returnWindowDays = 7;

/// Returns are allowed within 7 days of delivery for returnable items
/// (food and treats are not returnable once delivered).
bool canReturn(ShopOrder o, DateTime now) {
  if (o.status != 'delivered') return false;
  final at = o.deliveredAt ?? o.timeline.where((t) => t.status == 'delivered').map((t) => t.at).firstOrNull;
  if (at == null) return false;
  if (now.difference(at) > const Duration(days: returnWindowDays)) return false;
  return o.items.any((i) => i.returnable);
}

/// Index of the current step in [orderSteps] for the tracking timeline.
int stepIndex(String status) {
  final i = orderSteps.indexOf(status);
  if (i >= 0) return i;
  return switch (status) { 'return_requested' || 'returned' || 'return_rejected' => orderSteps.length - 1, _ => 0 };
}

/// Seller payout state: held during the return window, then paid in the
/// weekly payout (simulated in Version 1).
String payoutState(ShopOrder o, DateTime now) {
  if (o.status == 'cancelled' || o.status == 'returned') return 'none';
  if (o.payoutStatus == 'paid') return 'paid';
  if (o.status != 'delivered' && o.status != 'return_rejected') return 'pending';
  final at = o.deliveredAt ?? now;
  return now.difference(at).inDays >= returnWindowDays ? 'ready' : 'on_hold';
}

// ---------- expenses ----------

/// Splits an order into expense entries: food (food and treats) and
/// supplies (everything else), sharing the order total in proportion.
List<({String category, int amount})> orderExpenseSplit(ShopOrder o) {
  var food = 0;
  var other = 0;
  for (final i in o.items) {
    if (i.category == 'food' || i.category == 'treats') {
      food += i.amount;
    } else {
      other += i.amount;
    }
  }
  final parts = allocate(o.total, [food, other]);
  return [
    if (food > 0) (category: 'food', amount: parts[0]),
    if (other > 0) (category: 'supplies', amount: parts[1]),
  ];
}

class MonthTotal {
  MonthTotal(this.month, this.byCategory);
  final DateTime month;
  final Map<String, int> byCategory;
  int get total => byCategory.values.fold(0, (s, v) => s + v);
}

/// Totals for the last [months] months (oldest first), optionally for one pet.
List<MonthTotal> monthlyTotals(Iterable<Expense> expenses, DateTime now, {int months = 6, String? petId}) {
  final out = <MonthTotal>[];
  for (var i = months - 1; i >= 0; i--) {
    final m = DateTime(now.year, now.month - i);
    final next = DateTime(m.year, m.month + 1);
    final map = <String, int>{};
    for (final e in expenses) {
      if (petId != null && e.petId != petId) continue;
      if (e.date.isBefore(m) || !e.date.isBefore(next)) continue;
      map[e.category] = (map[e.category] ?? 0) + e.amount;
    }
    out.add(MonthTotal(m, map));
  }
  return out;
}

Map<String, int> categoryTotals(Iterable<Expense> expenses, {DateTime? from, DateTime? to, String? petId}) {
  final map = <String, int>{};
  for (final e in expenses) {
    if (petId != null && e.petId != petId) continue;
    if (from != null && e.date.isBefore(from)) continue;
    if (to != null && !e.date.isBefore(to)) continue;
    map[e.category] = (map[e.category] ?? 0) + e.amount;
  }
  return map;
}

// ---------- search, filters, picks ----------

class ProductFilter {
  const ProductFilter({this.query = '', this.species, this.category, this.minPrice, this.maxPrice, this.brands = const {}, this.minRating, this.sellerOnly = false});
  final String query;
  final String? species;
  final String? category;
  final int? minPrice;
  final int? maxPrice;
  final Set<String> brands;
  final double? minRating;

  /// Hide partner-store (affiliate) listings.
  final bool sellerOnly;

  int get activeCount =>
      (species != null ? 1 : 0) + (category != null ? 1 : 0) + (minPrice != null || maxPrice != null ? 1 : 0) + (brands.isNotEmpty ? 1 : 0) + (minRating != null ? 1 : 0) + (sellerOnly ? 1 : 0);

  ProductFilter copyWith({
    String? query,
    String? Function()? species,
    String? Function()? category,
    int? Function()? minPrice,
    int? Function()? maxPrice,
    Set<String>? brands,
    double? Function()? minRating,
    bool? sellerOnly,
  }) =>
      ProductFilter(
        query: query ?? this.query,
        species: species != null ? species() : this.species,
        category: category != null ? category() : this.category,
        minPrice: minPrice != null ? minPrice() : this.minPrice,
        maxPrice: maxPrice != null ? maxPrice() : this.maxPrice,
        brands: brands ?? this.brands,
        minRating: minRating != null ? minRating() : this.minRating,
        sellerOnly: sellerOnly ?? this.sellerOnly,
      );
}

enum ProductSort { popular, priceLow, priceHigh, rating, discount, newest }

/// [labels] maps a product to extra searchable words (translated category
/// names) so "खाना" or "ఆహారం" finds food.
List<Product> searchProducts(Iterable<Product> all, ProductFilter f, {ProductSort sort = ProductSort.popular, String Function(Product p)? labels}) {
  final words = f.query.toLowerCase().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
  final out = all.where((p) {
    if (!p.active) return false;
    if (f.species != null && !p.species.contains(f.species)) return false;
    if (f.category != null && p.category != f.category) return false;
    if (f.minPrice != null && p.price < f.minPrice!) return false;
    if (f.maxPrice != null && p.price > f.maxPrice!) return false;
    if (f.brands.isNotEmpty && !f.brands.contains(p.brand)) return false;
    if (f.minRating != null && p.rating < f.minRating!) return false;
    if (f.sellerOnly && p.isAffiliate) return false;
    if (words.isEmpty) return true;
    final hay = [p.name, p.brand, p.category.replaceAll('_', ' '), p.subcategory ?? '', p.description, ...p.species, if (labels != null) labels(p)].join(' ').toLowerCase();
    return words.every(hay.contains);
  }).toList();
  int byPopular(Product a, Product b) => (b.rating * b.reviewCount).compareTo(a.rating * a.reviewCount);
  out.sort(switch (sort) {
    ProductSort.popular => byPopular,
    ProductSort.priceLow => (a, b) => a.price.compareTo(b.price),
    ProductSort.priceHigh => (a, b) => b.price.compareTo(a.price),
    ProductSort.rating => (a, b) => b.rating != a.rating ? b.rating.compareTo(a.rating) : b.reviewCount.compareTo(a.reviewCount),
    ProductSort.discount => (a, b) => b.discountPercent.compareTo(a.discountPercent),
    ProductSort.newest => (a, b) => b.createdAt.compareTo(a.createdAt),
  });
  return out;
}

/// Shop life stage for a pet: puppy (also kittens and young pets), adult, senior.
String shopLifeStage(String petLifeStage) => petLifeStage == 'young' ? 'puppy' : petLifeStage;

/// True when the product contains something the pet is allergic to.
/// Reads the ingredients when given; otherwise the name and description,
/// ignoring "chicken-free", "no chicken" and "chicken allergy".
bool hasAllergen(Product p, List<String> allergies) {
  for (final raw in allergies) {
    final a = raw.trim().toLowerCase();
    if (a.isEmpty) continue;
    final text = (p.ingredients ?? '${p.name}. ${p.description}').toLowerCase();
    final re = RegExp('(?<!no |without |non-)\\b${RegExp.escape(a)}\\b(?!-free| free| allergy| allergies)');
    if (re.hasMatch(text)) return true;
  }
  return false;
}

/// Personalised picks for a pet (spec 7.10 "For Bruno: Labrador, adult"):
/// matching species, then life stage and breed size, then rating. Products
/// with the pet's allergens are left out.
List<Product> picksFor(
  Iterable<Product> all, {
  required String species,
  required String lifeStage,
  required String breedSize,
  List<String> allergies = const [],
  int max = 10,
}) {
  final stage = shopLifeStage(lifeStage);
  int score(Product p) {
    var s = 0;
    if (p.lifeStages.contains(stage)) s += 6;
    if (p.lifeStages.contains('all')) s += 2;
    if (species == 'dog') {
      if (p.breedSizes.contains(breedSize)) s += 4;
      if (p.breedSizes.contains('all')) s += 1;
    }
    if (p.isFood) s += 3;
    if (p.inStock) s += 1;
    return s * 10 + (p.rating * 2).round();
  }

  final list = all.where((p) => p.active && p.species.contains(species) && !hasAllergen(p, allergies)).toList()
    ..sort((a, b) => score(b).compareTo(score(a)));
  return list.take(max).toList();
}

/// "Buy again": products from delivered orders, most recent first, still
/// on sale.
List<String> buyAgainIds(Iterable<ShopOrder> orders, {int max = 10}) {
  final delivered = orders.where((o) => o.status == 'delivered' || o.status == 'return_rejected').toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  final seen = <String>[];
  for (final o in delivered) {
    for (final i in o.items) {
      if (!seen.contains(i.productId)) seen.add(i.productId);
    }
  }
  return seen.take(max).toList();
}

// ---------- subscriptions ----------

const subscriptionWeeks = [2, 4, 6];

DateTime nextSubscriptionDate(DateTime from, int everyWeeks) => DateTime(from.year, from.month, from.day + everyWeeks * 7, 9);

List<Subscription> dueSubscriptions(Iterable<Subscription> subs, DateTime now) => subs.where((s) => s.active && !s.nextAt.isAfter(now)).toList();

// ---------- seller CSV upload ----------

class CsvRow {
  CsvRow(this.line, this.data, this.errors);
  final int line;
  final Map<String, dynamic> data;

  /// Error keys: name, category, species, price, mrp, stock, packKg.
  final List<String> errors;
  bool get ok => errors.isEmpty;
}

const productCsvColumns = ['name', 'brand', 'category', 'species', 'price', 'mrp', 'stock', 'packKg', 'description'];

/// Parses a seller's product CSV (header row first). Quoted fields may hold
/// commas; species are separated by "|" or ";".
List<CsvRow> parseProductCsv(String text) {
  final lines = _csvRecords(text);
  if (lines.isEmpty) return const [];
  final header = [for (final h in lines.first) h.trim()];
  final out = <CsvRow>[];
  for (var n = 1; n < lines.length; n++) {
    final cells = lines[n];
    if (cells.every((c) => c.trim().isEmpty)) continue;
    String cell(String k) {
      final i = header.indexOf(k);
      return i >= 0 && i < cells.length ? cells[i].trim() : '';
    }

    final errors = <String>[];
    final name = cell('name');
    if (name.isEmpty || name.length > 120) errors.add('name');
    final category = cell('category');
    if (!shopCategories.contains(category)) errors.add('category');
    final species = cell('species').split(RegExp(r'[|;]')).map((s) => s.trim().toLowerCase()).where((s) => s.isNotEmpty).toList();
    if (species.isEmpty || species.any((s) => !shopSpecies.contains(s))) errors.add('species');
    final price = int.tryParse(cell('price').replaceAll(',', ''));
    if (price == null || price <= 0) errors.add('price');
    final mrpText = cell('mrp').replaceAll(',', '');
    final mrp = mrpText.isEmpty ? price : int.tryParse(mrpText);
    if (mrp == null || (price != null && mrp < price)) errors.add('mrp');
    final stock = int.tryParse(cell('stock'));
    if (stock == null || stock < 0) errors.add('stock');
    final packText = cell('packKg');
    final pack = packText.isEmpty ? null : double.tryParse(packText);
    if (packText.isNotEmpty && (pack == null || pack <= 0)) errors.add('packKg');
    out.add(CsvRow(n + 1, {
      'name': name,
      'brand': cell('brand'),
      'category': category,
      'species': species,
      'price': price ?? 0,
      'mrp': mrp ?? price ?? 0,
      'stock': stock ?? 0,
      'packKg': pack,
      'description': cell('description'),
    }, errors));
  }
  return out;
}

List<List<String>> _csvRecords(String text) {
  final records = <List<String>>[];
  var row = <String>[];
  final cell = StringBuffer();
  var quoted = false;
  for (var i = 0; i < text.length; i++) {
    final ch = text[i];
    if (quoted) {
      if (ch == '"') {
        if (i + 1 < text.length && text[i + 1] == '"') {
          cell.write('"');
          i++;
        } else {
          quoted = false;
        }
      } else {
        cell.write(ch);
      }
      continue;
    }
    if (ch == '"') {
      quoted = true;
    } else if (ch == ',') {
      row.add(cell.toString());
      cell.clear();
    } else if (ch == '\n' || ch == '\r') {
      if (ch == '\r' && i + 1 < text.length && text[i + 1] == '\n') i++;
      row.add(cell.toString());
      cell.clear();
      records.add(row);
      row = <String>[];
    } else {
      cell.write(ch);
    }
  }
  if (cell.isNotEmpty || row.isNotEmpty) {
    row.add(cell.toString());
    records.add(row);
  }
  return records;
}

/// A sample CSV sellers can download and fill in.
const sampleProductCsv = 'name,brand,category,species,price,mrp,stock,packKg,description\n'
    '"Peanut Butter Dog Biscuits 500 g",Tail Treats,treats,dog,249,299,40,0.5,"Baked, no added sugar"\n'
    '"Catnip Mouse Toy (2 pack)",Tail Treats,toys,cat,199,249,60,,"Soft plush with catnip"\n';
