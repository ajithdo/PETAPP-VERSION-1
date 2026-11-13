import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';
import '../../../core/widgets/widgets.dart';
import '../domain/shop_models.dart';
import '../domain/shop_rules.dart';
import '../../../core/theme/ph.dart';

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
      'food' => Ph.bowlFood,
      'treats' => Ph.bone,
      'toys' => Ph.tennisBall,
      'grooming' => Ph.scissors,
      'health_hygiene' => Ph.firstAidKit,
      'beds' => Ph.couch,
      'collars_leashes' => Ph.dog,
      'bowls_feeders' => Ph.bowlSteam,
      'litter_cat' => Ph.cat,
      'bird_food_cages' => Ph.bird,
      'rabbit_care' => Ph.rabbit,
      'clothing' => Ph.tShirt,
      'travel' => Ph.suitcaseRolling,
      _ => Ph.bag,
    };

Color categoryColor(String c) => const {
      'food': CategoryColors.amber,
      'treats': CategoryColors.gold,
      'toys': CategoryColors.sky,
      'grooming': CategoryColors.rose,
      'health_hygiene': CategoryColors.teal,
      'beds': CategoryColors.plum,
      'collars_leashes': CategoryColors.teal,
      'bowls_feeders': CategoryColors.clay,
      'litter_cat': CategoryColors.slate,
      'bird_food_cages': CategoryColors.olive,
      'rabbit_care': CategoryColors.olive,
      'clothing': CategoryColors.rose,
      'travel': CategoryColors.ocean,
    }[c] ??
    CategoryColors.teal;

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
    'placed' => (l.ordPlaced, ChipTone.info, Ph.receipt),
    'packed' => (l.ordPacked, ChipTone.info, Ph.package),
    'shipped' => (l.ordShipped, ChipTone.accent, Ph.truck),
    'out_for_delivery' => (l.ordOutForDelivery, ChipTone.accent, Ph.moped),
    'delivered' => (l.ordDelivered, ChipTone.success, Ph.checkCircleFill),
    'cancelled' => (l.ordCancelled, ChipTone.neutral, Ph.xCircle),
    'return_requested' => (l.ordReturnRequested, ChipTone.warning, Ph.arrowUUpLeft),
    'returned' => (l.ordReturned, ChipTone.neutral, Ph.arrowUDownLeft),
    'return_rejected' => (l.ordReturnRejected, ChipTone.error, Ph.prohibit),
    _ => (s, ChipTone.neutral, Ph.circle),
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
      'vet' => Ph.firstAid,
      'grooming' => Ph.scissors,
      'training' => Ph.graduationCap,
      'boarding' => Ph.houseLine,
      'walking' => Ph.personSimpleWalk,
      'food' => Ph.bowlFood,
      'supplies' => Ph.bag,
      'insurance' => Ph.shieldPlus,
      _ => Ph.receipt,
    };

Color expenseColor(String c) => const {
      'vet': CategoryColors.teal,
      'grooming': CategoryColors.rose,
      'training': CategoryColors.ocean,
      'boarding': CategoryColors.plum,
      'walking': CategoryColors.teal,
      'food': CategoryColors.amber,
      'supplies': CategoryColors.clay,
      'insurance': CategoryColors.violet,
    }[c] ??
    CategoryColors.slate;

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
