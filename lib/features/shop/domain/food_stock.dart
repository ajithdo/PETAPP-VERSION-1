/// "Food running low" prediction (spec 7.10): bag size ÷ daily portion,
/// counted from the day the bag was opened. The daily portion is editable;
/// this file only suggests a starting value. Pure Dart, unit tested.
library;

/// Show the Home card when this many days or fewer are left.
const foodLowDays = 7;

/// A starting daily portion in grams of dry food, by species, weight and
/// life stage. Owners and vets adjust it; the pack's feeding guide wins.
int suggestedDailyGrams({required String species, double? weightKg, String lifeStage = 'adult'}) {
  final w = (weightKg == null || weightKg <= 0) ? null : weightKg;
  final grams = switch (species) {
    'dog' => w == null
        ? 250
        : switch (lifeStage) {
            'young' => w * 25 + 30,
            'senior' => w * 11 + 40,
            _ => w * 12 + 50,
          },
    'cat' => w == null ? 60 : (lifeStage == 'young' ? w * 25 : w * 14),
    'rabbit' => w == null ? 60 : w * 30,
    'bird' => 15,
    _ => 100,
  };
  // Round to the nearest 10 g (5 g for small amounts).
  final step = grams < 50 ? 5 : 10;
  return ((grams / step).round() * step).clamp(5, 2000).toInt();
}

/// Days of food left (can be negative), or null when the bag, the portion
/// or the opening date is unknown.
double? foodDaysLeft({double? bagKg, int? dailyGrams, DateTime? openedAt, required DateTime now}) {
  if (bagKg == null || bagKg <= 0 || dailyGrams == null || dailyGrams <= 0 || openedAt == null) return null;
  final totalDays = bagKg * 1000 / dailyGrams;
  final used = now.difference(openedAt).inHours / 24;
  return totalDays - used;
}

/// The date the bag is expected to run out.
DateTime? foodRunOutDate({double? bagKg, int? dailyGrams, DateTime? openedAt}) {
  if (bagKg == null || bagKg <= 0 || dailyGrams == null || dailyGrams <= 0 || openedAt == null) return null;
  return openedAt.add(Duration(hours: (bagKg * 1000 / dailyGrams * 24).round()));
}

enum FoodState { unknown, ok, low, out }

FoodState foodState(double? daysLeft) {
  if (daysLeft == null) return FoodState.unknown;
  if (daysLeft <= 0) return FoodState.out;
  if (daysLeft <= foodLowDays) return FoodState.low;
  return FoodState.ok;
}

/// Whole days to show ("about 5 days"): rounded, never below 0.
int roundDays(double daysLeft) => daysLeft <= 0 ? 0 : daysLeft.round().clamp(1, 9999);

/// When a new bag arrives, it is opened when the old one runs out (or on
/// delivery if the old one has already run out).
DateTime newBagOpenedAt({required DateTime deliveredAt, DateTime? oldRunOut}) =>
    oldRunOut != null && oldRunOut.isAfter(deliveredAt) ? oldRunOut : deliveredAt;
