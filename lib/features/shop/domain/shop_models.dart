/// Marketplace models (spec 7.10). Thin wrappers over Firestore maps, the
/// same style as the rest of the app. No Flutter imports.
library;

import '../../../core/data/converters.dart';

/// Shop categories (spec 7.10), in the order the shop shows them.
const shopCategories = [
  'food',
  'treats',
  'toys',
  'grooming',
  'health_hygiene',
  'beds',
  'collars_leashes',
  'bowls_feeders',
  'litter_cat',
  'bird_food_cages',
  'rabbit_care',
  'clothing',
  'travel',
];

const shopSpecies = ['dog', 'cat', 'rabbit', 'bird'];

class Product {
  Product(this.id, this.raw);
  final String id;
  final Map<String, dynamic> raw;

  String get name => (raw['name'] as String?) ?? '';
  String get brand => (raw['brand'] as String?) ?? '';
  String get category => (raw['category'] as String?) ?? 'toys';
  String? get subcategory => raw['subcategory'] as String?;
  List<String> get species => _list('species');
  List<String> get lifeStages => _list('lifeStages', fallback: const ['all']);
  List<String> get breedSizes => _list('breedSizes', fallback: const ['all']);
  int get price => (raw['price'] as num?)?.toInt() ?? 0;
  int get mrp => (raw['mrp'] as num?)?.toInt() ?? price;
  int? get stock => (raw['stock'] as num?)?.toInt();
  String? get sellerId => raw['sellerId'] as String?;
  String? get partnerId => raw['partnerId'] as String?;
  String? get affiliateUrl => raw['affiliateUrl'] as String?;
  double get rating => (raw['rating'] as num?)?.toDouble() ?? 0;
  int get reviewCount => (raw['reviewCount'] as num?)?.toInt() ?? 0;
  String get description => (raw['description'] as String?) ?? '';
  String? get ingredients => raw['ingredients'] as String?;
  double? get packKg => (raw['packKg'] as num?)?.toDouble();
  int get imageSeed => (raw['imageSeed'] as num?)?.toInt() ?? id.hashCode.abs() % 8;
  int get deliveryDays => (raw['deliveryDays'] as num?)?.toInt() ?? 3;
  bool get returnable => (raw['returnable'] as bool?) ?? true;
  bool get active => (raw['active'] as bool?) ?? true;

  /// Picked by the admin (Catalogue → Products) for the Shop home.
  bool get featured => (raw['featured'] as bool?) ?? false;
  String? get photoUrl => raw['photoUrl'] as String?;
  DateTime get createdAt => parseDate(raw['createdAt']) ?? DateTime.fromMillisecondsSinceEpoch(0);

  /// Partner store link (affiliate): bought on the partner's own site.
  bool get isAffiliate => partnerId != null;
  bool get isFood => category == 'food';
  bool get inStock => isAffiliate || (stock ?? 0) > 0;
  int get discountPercent => mrp > price && mrp > 0 ? ((mrp - price) * 100 / mrp).round() : 0;

  List<String> _list(String k, {List<String> fallback = const []}) {
    final v = raw[k];
    if (v is List && v.isNotEmpty) return v.map((e) => '$e').toList();
    return fallback;
  }
}

class Seller {
  Seller(this.id, this.raw);
  final String id;
  final Map<String, dynamic> raw;
  String get name => (raw['name'] as String?) ?? '';
  String get city => (raw['city'] as String?) ?? '';
  String? get uid => raw['uid'] as String?;
  String get status => (raw['status'] as String?) ?? 'pending';
  String get returnPolicy => (raw['returnPolicy'] as String?) ?? '';
  double get rating => (raw['rating'] as num?)?.toDouble() ?? 0;

  /// Optional commission override: a number, or a map per category.
  Object? get commissionPercent => raw['commissionPercent'];
}

/// Affiliate partner store (spec 7.10 b).
class PartnerStore {
  PartnerStore(this.id, this.raw);
  final String id;
  final Map<String, dynamic> raw;
  String get name => (raw['name'] as String?) ?? '';
  String get url => (raw['url'] as String?) ?? '';
  num get commissionPercent => (raw['commissionPercent'] as num?) ?? 0;
  int get clicks => (raw['clicks'] as num?)?.toInt() ?? 0;
}

class CartLine {
  const CartLine(this.productId, this.qty);
  final String productId;
  final int qty;
  Map<String, dynamic> toMap() => {'productId': productId, 'qty': qty};
  static CartLine fromMap(Map m) => CartLine('${m['productId']}', (m['qty'] as num?)?.toInt() ?? 1);
}

/// Order statuses (spec 7.10: tracking timeline, cancel and return).
const orderSteps = ['placed', 'packed', 'shipped', 'out_for_delivery', 'delivered'];
const orderStatuses = [...orderSteps, 'cancelled', 'return_requested', 'returned', 'return_rejected'];

class OrderLine {
  OrderLine(this.raw);
  final Map<String, dynamic> raw;
  String get productId => (raw['productId'] as String?) ?? '';
  String get name => (raw['name'] as String?) ?? '';
  String get brand => (raw['brand'] as String?) ?? '';
  String get category => (raw['category'] as String?) ?? '';
  int get qty => (raw['qty'] as num?)?.toInt() ?? 1;
  int get price => (raw['price'] as num?)?.toInt() ?? 0;
  int get mrp => (raw['mrp'] as num?)?.toInt() ?? price;
  int get commission => (raw['commission'] as num?)?.toInt() ?? 0;
  double? get packKg => (raw['packKg'] as num?)?.toDouble();
  bool get returnable => (raw['returnable'] as bool?) ?? true;
  int get imageSeed => (raw['imageSeed'] as num?)?.toInt() ?? 0;
  int get amount => price * qty;
}

class ShopOrder {
  ShopOrder(this.id, this.raw);
  final String id;
  final Map<String, dynamic> raw;

  String get ownerId => (raw['ownerId'] as String?) ?? '';
  String get ownerName => (raw['ownerName'] as String?) ?? '';
  String? get petId => raw['petId'] as String?;
  String get petName => (raw['petName'] as String?) ?? '';
  String get groupId => (raw['groupId'] as String?) ?? id;
  String get sellerId => (raw['sellerId'] as String?) ?? '';
  String get sellerName => (raw['sellerName'] as String?) ?? '';
  List<String> get sellerUids => ((raw['sellerUids'] as List?) ?? const []).map((e) => '$e').toList();
  List<OrderLine> get items => [for (final i in (raw['items'] as List?) ?? const []) OrderLine((i as Map).cast<String, dynamic>())];
  int get subtotal => (raw['subtotal'] as num?)?.toInt() ?? 0;
  int get discount => (raw['discount'] as num?)?.toInt() ?? 0;
  String? get coupon => raw['coupon'] as String?;
  int get deliveryFee => (raw['deliveryFee'] as num?)?.toInt() ?? 0;
  int get total => (raw['total'] as num?)?.toInt() ?? 0;
  int get commission => (raw['commission'] as num?)?.toInt() ?? 0;

  /// What the seller receives: item amounts less commission. Coupons and
  /// delivery are PawSetu's (spec 8).
  int get payout => (raw['payout'] as num?)?.toInt() ?? (subtotal - commission);
  String get payoutStatus => (raw['payoutStatus'] as String?) ?? 'pending';
  Map<String, dynamic> get address => ((raw['address'] as Map?) ?? const {}).cast<String, dynamic>();
  DateTime? get slotDate => parseDate((raw['slot'] as Map?)?['date']);
  String? get slotWindow => (raw['slot'] as Map?)?['window'] as String?;
  String get status => (raw['status'] as String?) ?? 'placed';
  List<({String status, DateTime at})> get timeline => [
        for (final t in (raw['timeline'] as List?) ?? const [])
          if (t is Map) (status: '${t['status']}', at: parseDate(t['at']) ?? DateTime.fromMillisecondsSinceEpoch(0)),
      ];

  /// paid, pending (payment not confirmed yet), cod (pay on delivery), refunded.
  String get paymentStatus => (raw['paymentStatus'] as String?) ?? 'paid';
  String get paymentMethod => (raw['paymentMethod'] as String?) ?? 'online';
  String get invoiceNo => (raw['invoiceNo'] as String?) ?? '';
  DateTime get createdAt => parseDate(raw['createdAt']) ?? DateTime.fromMillisecondsSinceEpoch(0);
  DateTime? get expectedBy => parseDate(raw['expectedBy']);
  DateTime? get deliveredAt => parseDate(raw['deliveredAt']);
  String? get returnReason => raw['returnReason'] as String?;
  String? get cancelReason => raw['cancelReason'] as String?;

  /// cart, reorder (Home card / Buy again) or subscription.
  String get source => (raw['source'] as String?) ?? 'cart';
  String? get subscriptionId => raw['subscriptionId'] as String?;
  int get itemCount => items.fold(0, (s, i) => s + i.qty);
  bool get isOpen => const ['placed', 'packed', 'shipped', 'out_for_delivery'].contains(status);
}

class Subscription {
  Subscription(this.id, this.raw);
  final String id;
  final Map<String, dynamic> raw;
  String get ownerId => (raw['ownerId'] as String?) ?? '';
  String? get petId => raw['petId'] as String?;
  String get productId => (raw['productId'] as String?) ?? '';
  String get productName => (raw['productName'] as String?) ?? '';
  int get qty => (raw['qty'] as num?)?.toInt() ?? 1;
  int get everyWeeks => (raw['everyWeeks'] as num?)?.toInt() ?? 4;
  DateTime get nextAt => parseDate(raw['nextAt']) ?? DateTime.now();
  bool get active => (raw['active'] as bool?) ?? true;
  String? get lastOrderId => raw['lastOrderId'] as String?;
}

class Coupon {
  Coupon(this.code, this.raw);
  final String code;
  final Map<String, dynamic> raw;
  int? get percent => (raw['percent'] as num?)?.toInt();
  int? get flat => (raw['flat'] as num?)?.toInt();
  int? get maxDiscount => (raw['maxDiscount'] as num?)?.toInt();
  int get minOrder => (raw['minOrder'] as num?)?.toInt() ?? 0;
  DateTime? get validTill => parseDate(raw['validTill']);
  int get uses => (raw['uses'] as num?)?.toInt() ?? 0;
  int? get maxUses => (raw['maxUses'] as num?)?.toInt();
  bool get active => (raw['active'] as bool?) ?? true;
  String get description => (raw['description'] as String?) ?? '';

  /// Set for referral rewards: only this person can use the coupon.
  String? get forUid => raw['forUid'] as String?;
}

/// Expense categories (data model `expenses.category`).
const expenseCategories = ['vet', 'grooming', 'training', 'boarding', 'walking', 'food', 'supplies', 'insurance', 'other'];

class Expense {
  Expense(this.id, this.raw);
  final String id;
  final Map<String, dynamic> raw;
  String get ownerId => (raw['ownerId'] as String?) ?? '';
  String? get petId => raw['petId'] as String?;
  String get category {
    final c = raw['category'] as String?;
    return expenseCategories.contains(c) ? c! : 'other';
  }

  int get amount => (raw['amount'] as num?)?.toInt() ?? 0;
  DateTime get date => parseDate(raw['date']) ?? DateTime.fromMillisecondsSinceEpoch(0);
  String get note => (raw['note'] as String?) ?? '';

  /// booking, order, televet or manual.
  String get source => (raw['source'] as String?) ?? 'manual';
  String? get sourceId => raw['sourceId'] as String?;
}

/// A delivery address from the user's address book (users.addresses).
class Address {
  const Address({required this.id, required this.label, required this.name, required this.phone, required this.line1, this.line2 = '', required this.area, required this.city, required this.pin});
  final String id;
  final String label;
  final String name;
  final String phone;
  final String line1;
  final String line2;
  final String area;
  final String city;
  final String pin;

  static Address fromMap(Map m, {String name = '', String phone = ''}) => Address(
        id: '${m['id'] ?? 'home'}',
        label: '${m['label'] ?? 'Home'}',
        name: '${m['name'] ?? name}',
        phone: '${m['phone'] ?? phone}',
        line1: '${m['line1'] ?? ''}',
        line2: '${m['line2'] ?? ''}',
        area: '${m['area'] ?? ''}',
        city: '${m['city'] ?? ''}',
        pin: '${m['pin'] ?? ''}',
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'label': label,
        'name': name,
        'phone': phone,
        'line1': line1,
        'line2': line2,
        'area': area,
        'city': city,
        'pin': pin,
      };

  String get oneLine => [line1, line2, area, city, pin].where((s) => s.trim().isNotEmpty).join(', ');
}
