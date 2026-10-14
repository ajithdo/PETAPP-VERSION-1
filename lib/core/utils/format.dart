import 'package:intl/intl.dart';

/// India-first formatting (spec section 1): ₹ with Indian digit grouping,
/// dates like 13 Oct 2026, 12-hour time, km and kg.
class Fmt {
  static String _l(String locale) => switch (locale) { 'hi' => 'hi', 'te' => 'te', _ => 'en_IN' };

  static String inr(num amount, [String locale = 'en']) =>
      NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: amount % 1 == 0 ? 0 : 2)
          .format(amount);

  static String number(num n, [String locale = 'en']) =>
      NumberFormat.decimalPattern('en_IN').format(n);

  static String date(DateTime d, [String locale = 'en']) => DateFormat('d MMM yyyy', _l(locale)).format(d);
  static String dateShort(DateTime d, [String locale = 'en']) => DateFormat('d MMM', _l(locale)).format(d);
  static String weekdayDate(DateTime d, [String locale = 'en']) =>
      DateFormat('EEE, d MMM', _l(locale)).format(d);
  static String monthYear(DateTime d, [String locale = 'en']) => DateFormat('MMMM yyyy', _l(locale)).format(d);
  static String time(DateTime d, [String locale = 'en']) =>
      DateFormat('h:mm a', locale == 'en' ? 'en' : _l(locale)).format(d);
  static String dateTime(DateTime d, [String locale = 'en']) => '${date(d, locale)}, ${time(d, locale)}';

  static String km(double km) => km < 1 ? '${(km * 1000).round()} m' : '${km.toStringAsFixed(1)} km';

  /// Birds are weighed in grams.
  static String weight(double kg, {bool grams = false}) =>
      grams ? '${(kg * 1000).round()} g' : '${kg.toStringAsFixed(kg < 10 ? 1 : 0)} kg';

  static String duration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    final s = d.inSeconds % 60;
    if (h > 0) return '${h}h ${m.toString().padLeft(2, '0')}m';
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  static DateTime dayOnly(DateTime d) => DateTime(d.year, d.month, d.day);
  static bool sameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;
}

/// Years and months between [from] and [to].
({int years, int months}) ageParts(DateTime from, DateTime to) {
  var months = (to.year - from.year) * 12 + to.month - from.month;
  if (to.day < from.day) months--;
  if (months < 0) months = 0;
  return (years: months ~/ 12, months: months % 12);
}
