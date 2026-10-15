import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';
import '../../../core/widgets/widgets.dart';
import '../domain/shop_models.dart';
import '../domain/shop_rules.dart';

String categoryLabel(BuildContext context, String c) {
  final l = context.l10n;
  return switch (c) {
    'food' => l.catFood,
    'treats' => l.catTreats,
    'toys' => l.catToys,
    'grooming' => l.catGrooming,
    'health_hygiene' => l.catHealthHygiene,
    'beds' => l.catBeds,
    'collars_leashes' => l.catCollars,
    'bowls_feeders' => l.catBowls,
    'litter_cat' => l.catLitter,
    'bird_food_cages' => l.catBird,
    'rabbit_care' => l.catRabbit,
    'clothing' => l.catClothing,
    'travel' => l.catTravel,
    _ => c,
  };
}

IconData categoryIcon(String c) => switch (c) {
      'food' => Icons.set_meal_rounded,
      'treats' => Icons.cookie_rounded,
      'toys' => Icons.sports_baseball_rounded,
      'grooming' => Icons.shower_rounded,
      'health_hygiene' => Icons.health_and_safety_rounded,
      'beds' => Icons.bed_rounded,
      'collars_leashes' => Icons.link_rounded,
      'bowls_feeders' => Icons.rice_bowl_rounded,
      'litter_cat' => Icons.cleaning_services_rounded,
      'bird_food_cages' => Icons.flutter_dash_rounded,
      'rabbit_care' => Icons.grass_rounded,
      'clothing' => Icons.checkroom_rounded,
      'travel' => Icons.luggage_rounded,
      _ => Icons.shopping_bag_rounded,
    };

Color categoryColor(String c) => const {
      'food': Color(0xFFF4A261),
      'treats': Color(0xFFD6B98C),
      'toys': Color(0xFF38BDF8),
      'grooming': Color(0xFFF472B6),
      'health_hygiene': Color(0xFF34D399),
      'beds': Color(0xFF9B8AFB),
      'collars_leashes': Color(0xFF0F766E),
      'bowls_feeders': Color(0xFFF59E0B),
      'litter_cat': Color(0xFF64748B),
      'bird_food_cages': Color(0xFF22C55E),
      'rabbit_care': Color(0xFF84CC16),
      'clothing': Color(0xFFEC4899),
      'travel': Color(0xFF0EA5E9),
    }[c] ??
    const Color(0xFF0F766E);

String speciesName(BuildContext context, String s) {
  final l = context.l10n;
  return switch (s) { 'dog' => l.speciesDog, 'cat' => l.speciesCat, 'rabbit' => l.speciesRabbit, 'bird' => l.speciesBird, _ => s };
}

String lifeStageTag(BuildContext context, String s) {
  final l = context.l10n;
  return switch (s) { 'puppy' => l.shopStageYoung, 'adult' => l.shopStageAdult, 'senior' => l.shopStageSenior, _ => l.shopStageAll };
}

String breedSizeTag(BuildContext context, String s) {
  final l = context.l10n;
  return switch (s) { 'small' => l.shopSizeSmall, 'medium' => l.shopSizeMedium, 'large' => l.shopSizeLarge, 'giant' => l.shopSizeGiant, _ => l.shopSizeAll };
}

String sortLabel(BuildContext context, ProductSort s) {
  final l = context.l10n;
  return switch (s) {
    ProductSort.popular => l.sortPopular,
    ProductSort.priceLow => l.sortPriceLow,
    ProductSort.priceHigh => l.sortPriceHigh,
    ProductSort.rating => l.sortRating,
    ProductSort.discount => l.sortDiscount,
    ProductSort.newest => l.sortNewest,
  };
}

(String, ChipTone, IconData) orderStatusInfo(BuildContext context, String s) {
  final l = context.l10n;
  return switch (s) {
    'placed' => (l.ordPlaced, ChipTone.info, Icons.receipt_long_rounded),
    'packed' => (l.ordPacked, ChipTone.info, Icons.inventory_2_rounded),
    'shipped' => (l.ordShipped, ChipTone.accent, Icons.local_shipping_rounded),
    'out_for_delivery' => (l.ordOutForDelivery, ChipTone.accent, Icons.delivery_dining_rounded),
    'delivered' => (l.ordDelivered, ChipTone.success, Icons.check_circle_rounded),
    'cancelled' => (l.ordCancelled, ChipTone.neutral, Icons.cancel_rounded),
    'return_requested' => (l.ordReturnRequested, ChipTone.warning, Icons.assignment_return_rounded),
    'returned' => (l.ordReturned, ChipTone.neutral, Icons.assignment_returned_rounded),
    'return_rejected' => (l.ordReturnRejected, ChipTone.error, Icons.block_rounded),
    _ => (s, ChipTone.neutral, Icons.circle_outlined),
  };
}

String paymentLabel(BuildContext context, ShopOrder o) {
  final l = context.l10n;
  return switch (o.paymentStatus) {
    'paid' => l.payPaidOnline,
    'pending' => l.payPending,
    'cod' => l.payOnDelivery,
    'refunded' => l.payRefunded,
    _ => o.paymentStatus,
  };
}

/// "9 am – 12 pm" style label for a delivery window like "09-12".
String windowLabel(BuildContext context, String w) {
  final parts = w.split('-');
  if (parts.length != 2) return w;
  String h(String s) {
    final n = int.tryParse(s) ?? 0;
    final d = DateTime(2000, 1, 1, n);
    return MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(d), alwaysUse24HourFormat: false);
  }

  return '${h(parts[0])} – ${h(parts[1])}';
}

String expenseCategoryLabel(BuildContext context, String c) {
  final l = context.l10n;
  return switch (c) {
    'vet' => l.expVet,
    'grooming' => l.expGrooming,
    'training' => l.expTraining,
    'boarding' => l.expBoarding,
    'walking' => l.expWalking,
    'food' => l.expFood,
    'supplies' => l.expSupplies,
    'insurance' => l.expInsurance,
    _ => l.expOther,
  };
}

IconData expenseIcon(String c) => switch (c) {
      'vet' => Icons.local_hospital_rounded,
      'grooming' => Icons.content_cut_rounded,
      'training' => Icons.sports_rounded,
      'boarding' => Icons.house_rounded,
      'walking' => Icons.directions_walk_rounded,
      'food' => Icons.set_meal_rounded,
      'supplies' => Icons.shopping_bag_rounded,
      'insurance' => Icons.health_and_safety_rounded,
      _ => Icons.receipt_rounded,
    };

Color expenseColor(String c) => const {
      'vet': Color(0xFF0F766E),
      'grooming': Color(0xFFF472B6),
      'training': Color(0xFF0EA5E9),
      'boarding': Color(0xFF9B8AFB),
      'walking': Color(0xFF34D399),
      'food': Color(0xFFF4A261),
      'supplies': Color(0xFFF59E0B),
      'insurance': Color(0xFF6D5BD0),
    }[c] ??
    const Color(0xFF94A3B8);

String couponMessage(BuildContext context, CouponResult r, {int minOrder = 0}) {
  final l = context.l10n;
  return switch (r) {
    CouponResult.ok => l.couponApplied,
    CouponResult.notFound => l.couponNotFound,
    CouponResult.inactive => l.couponNotFound,
    CouponResult.expired => l.couponExpired,
    CouponResult.minOrder => l.couponMinOrder(minOrder),
    CouponResult.usedUp => l.couponUsedUp,
  };
}

/// Colour for the sale price.
Color priceColor(BuildContext context) => context.paw.textPrimary;
