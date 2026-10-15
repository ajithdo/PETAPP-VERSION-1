import 'dart:math' as math;

import 'seed.dart';

/// Phase 10: 90 days of platform numbers for the admin dashboard
/// (analyticsDaily/{yyyy-mm-dd}). Made-up but believable: slow growth, busier
/// weekends for bookings, a festival bump in orders. Today is left to the
/// live counters.
void seedAnalytics(Add add, DateTime now) {
  final r = math.Random(90);
  final today = DateTime(now.year, now.month, now.day);
  for (var ago = 90; ago >= 1; ago--) {
    final d = today.subtract(Duration(days: ago));
    final growth = 1 + (90 - ago) / 90 * 0.8; // +80% over the quarter
    final weekend = d.weekday >= DateTime.saturday ? 1.35 : 1.0;
    final festival = (ago >= 20 && ago <= 26) ? 1.6 : 1.0; // a festive week
    int n(double base, [double spread = 0.25]) => math.max(0, (base * (1 - spread + r.nextDouble() * 2 * spread)).round());
    final bookings = n(38 * growth * weekend);
    final orders = n(52 * growth * festival);
    final avgOrder = 780 + r.nextInt(420);
    final orderValue = orders * avgOrder;
    final bookingValue = bookings * (520 + r.nextInt(260));
    final commission = (bookingValue * 0.10 + orderValue * 0.11).round();
    add('analyticsDaily', analyticsDay(d), {
      'date': d,
      'users': n(64 * growth),
      'pets': n(71 * growth),
      'bookings': bookings,
      'bookingValue': bookingValue,
      'orders': orders,
      'orderValue': orderValue,
      'commission': commission,
      'subscriptions': n(6 * growth, 0.5),
      'sos': n(2.2, 0.9),
      'demo': true,
    });
  }
}

/// Document id for a day: yyyy-mm-dd.
String analyticsDay(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
