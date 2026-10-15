/// PawSetu Plus (spec 8): prices, the 7-day free trial and which plan a
/// person is on right now. All numbers come from config/app (admin
/// settings); the defaults below are only used before it loads.
///
/// Pure Dart: shared by the app, the unit tests and functions/src/phase10.ts.
library;

class PlanPrices {
  const PlanPrices({this.monthly = 99, this.yearly = 799, this.trialDays = 7});
  final int monthly;
  final int yearly;
  final int trialDays;

  factory PlanPrices.fromConfig(Map<String, dynamic>? cfg) {
    final p = (cfg?['plans'] as Map?) ?? const {};
    return PlanPrices(
      monthly: (p['plusMonthly'] as num?)?.toInt() ?? 99,
      yearly: (p['plusYearly'] as num?)?.toInt() ?? 799,
      trialDays: (p['trialDays'] as num?)?.toInt() ?? 7,
    );
  }

  /// How much the yearly plan saves against 12 monthly payments, in percent.
  int get yearlySavingPercent => monthly <= 0 ? 0 : (100 - yearly * 100 / (monthly * 12)).round();
}

/// The plan that applies now: a trial or paid period that has ended counts
/// as free (the server also switches it back each night).
String effectivePlan({required String plan, DateTime? trialEndsAt, DateTime? planRenewsAt, required DateTime now}) {
  if (plan == 'trial') return trialEndsAt != null && trialEndsAt.isAfter(now) ? 'trial' : 'free';
  if (plan == 'plus') return planRenewsAt == null || planRenewsAt.isAfter(now) ? 'plus' : 'free';
  return 'free';
}

bool hasPlus(String effective) => effective == 'plus' || effective == 'trial';

/// The free trial can be taken once per person.
bool canStartTrial({required String plan, DateTime? trialUsedAt}) => plan == 'free' && trialUsedAt == null;

DateTime trialEnd(DateTime start, PlanPrices p) => start.add(Duration(days: p.trialDays));

/// The next renewal for a paid period starting at [start].
DateTime renewalDate(DateTime start, {required bool yearly}) =>
    yearly ? DateTime(start.year + 1, start.month, start.day, start.hour, start.minute) : DateTime(start.year, start.month + 1, start.day, start.hour, start.minute);

/// Whole days left in a trial or period (never negative).
int daysLeft(DateTime? end, DateTime now) => end == null || !end.isAfter(now) ? 0 : (end.difference(now).inHours / 24).ceil();
