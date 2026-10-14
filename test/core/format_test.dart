import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pawsetu/core/utils/format.dart';

void main() {
  setUpAll(() => initializeDateFormatting());

  test('rupees use Indian digit grouping', () {
    expect(Fmt.inr(124999), '₹1,24,999');
    expect(Fmt.inr(799), '₹799');
    expect(Fmt.inr(1500000), '₹15,00,000');
  });

  test('dates look like 13 Oct 2026 with 12-hour time', () {
    final d = DateTime(2026, 10, 13, 20, 5);
    expect(Fmt.date(d), '13 Oct 2026');
    expect(Fmt.time(d), '8:05 PM');
  });

  test('age parts count whole months', () {
    expect(ageParts(DateTime(2023, 7, 20), DateTime(2026, 10, 14)), (years: 3, months: 2));
    expect(ageParts(DateTime(2026, 5, 14), DateTime(2026, 10, 14)), (years: 0, months: 5));
  });

  test('distances and bird weights', () {
    expect(Fmt.km(0.45), '450 m');
    expect(Fmt.km(3.24), '3.2 km');
    expect(Fmt.weight(0.09, grams: true), '90 g');
  });
}
