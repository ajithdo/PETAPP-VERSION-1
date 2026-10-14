import 'package:flutter_test/flutter_test.dart';
import 'package:pawsetu/features/booking/domain/booking_rules.dart';

void main() {
  final hours = {
    for (final d in ['mon', 'tue', 'wed', 'thu', 'fri', 'sat']) d: ['09:00', '12:00'],
    'sun': ['10:00', '11:00'],
  };
  final open24 = {for (final d in weekdayKeys) d: ['00:00', '24:00']};
  // 14 Oct 2026 is a Wednesday.
  final now = DateTime(2026, 10, 14, 8, 0);

  test('open now', () {
    expect(isOpenNow(hours, DateTime(2026, 10, 14, 10)), isTrue);
    expect(isOpenNow(hours, DateTime(2026, 10, 14, 13)), isFalse);
    expect(isOpenNow(open24, DateTime(2026, 10, 14, 23, 30)), isTrue);
  });

  test('slots respect length, buffer and lead time', () {
    final s = generateSlots(hours: hours, day: now, slotMinutes: 20, bufferMinutes: 10, now: DateTime(2026, 10, 14, 9, 10));
    // 30-minute lead time from 9:10 means the first slot is 10:00.
    expect(s.first.start, DateTime(2026, 10, 14, 10, 0));
    expect(s.last.start, DateTime(2026, 10, 14, 11, 30));
    expect(s.every((x) => x.end.difference(x.start).inMinutes == 20), isTrue);
  });

  test('capacity and existing bookings', () {
    final s = generateSlots(
      hours: hours,
      day: DateTime(2026, 10, 15),
      slotMinutes: 30,
      capacity: 2,
      bookedStarts: [DateTime(2026, 10, 15, 9), DateTime(2026, 10, 15, 9), DateTime(2026, 10, 15, 10)],
      now: now,
    );
    expect(s.firstWhere((x) => x.start.hour == 9 && x.start.minute == 0).available, isFalse);
    expect(s.firstWhere((x) => x.start.hour == 10 && x.start.minute == 0).free, 1);
  });

  test('holidays and blocked time', () {
    expect(generateSlots(hours: hours, day: DateTime(2026, 10, 15), slotMinutes: 30, holidays: [DateTime(2026, 10, 15)], now: now), isEmpty);
    final s = generateSlots(
      hours: hours,
      day: DateTime(2026, 10, 15),
      slotMinutes: 30,
      blocks: [(start: DateTime(2026, 10, 15, 10), end: DateTime(2026, 10, 15, 11))],
      now: now,
    );
    expect(s.any((x) => x.start.hour == 10), isFalse);
  });

  test('price and commission', () {
    final p = priceBooking(servicePrice: 1499, homeVisit: true, travelFee: 150, commissionPercent: 10);
    expect(p.total, 1649);
    expect(p.commission, 150);
    expect(p.payout, 1499);
    final d = priceBooking(servicePrice: 800, commissionPercent: 10, discountPercent: 10);
    expect(d.total, 720);
    expect(d.commission, 72);
  });

  test('refunds follow the cancellation policy', () {
    final start = DateTime(2026, 10, 15, 10);
    expect(refundAmount(paid: 800, start: start, now: DateTime(2026, 10, 14, 10), cancellationHours: 4), 800);
    expect(refundAmount(paid: 800, start: start, now: DateTime(2026, 10, 15, 8), cancellationHours: 4), 400);
    expect(refundAmount(paid: 800, start: start, now: DateTime(2026, 10, 15, 11), cancellationHours: 4), 0);
  });

  test('request window', () {
    expect(requestExpired(createdAt: DateTime(2026, 10, 14, 8), windowHours: 2, now: DateTime(2026, 10, 14, 9)), isFalse);
    expect(requestExpired(createdAt: DateTime(2026, 10, 14, 8), windowHours: 2, now: DateTime(2026, 10, 14, 10, 1)), isTrue);
  });

  test('calendar file', () {
    final ics = icsFor(uid: 'b1', title: 'Vet visit', start: DateTime.utc(2026, 10, 15, 4, 30), end: DateTime.utc(2026, 10, 15, 4, 50), location: 'Clinic');
    expect(ics, contains('DTSTART:20261015T043000Z'));
    expect(ics, contains('BEGIN:VALARM'));
  });
}
