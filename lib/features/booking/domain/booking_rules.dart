/// Booking engine rules (spec 7.6): opening hours, slot generation,
/// pricing with platform commission, cancellation and request windows.
/// Pure Dart and unit tested; the createBooking Cloud Function mirrors it.
library;

const weekdayKeys = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];

String weekdayKey(DateTime d) => weekdayKeys[d.weekday - 1];

({int h, int m}) _hm(String s) {
  final p = s.split(':');
  return (h: int.parse(p[0]), m: int.parse(p[1]));
}

/// Opening hours for a day: hours map like {"mon": ["09:00", "20:00"]}.
({DateTime open, DateTime close})? hoursOn(Map<String, dynamic> hours, DateTime day) {
  final v = hours[weekdayKey(day)];
  if (v is! List || v.length < 2) return null;
  final o = _hm(v[0] as String);
  final c = _hm(v[1] as String);
  final open = DateTime(day.year, day.month, day.day, o.h, o.m);
  final close = c.h >= 24 ? DateTime(day.year, day.month, day.day + 1) : DateTime(day.year, day.month, day.day, c.h, c.m);
  return (open: open, close: close);
}

bool isOpenNow(Map<String, dynamic> hours, DateTime now) {
  final h = hoursOn(hours, now);
  return h != null && !now.isBefore(h.open) && now.isBefore(h.close);
}

class Slot {
  const Slot(this.start, this.end, this.free);
  final DateTime start;
  final DateTime end;

  /// Places left in this slot.
  final int free;
  bool get available => free > 0;
}

/// Slots for one day. Slots in the past (with a 30-minute lead time),
/// on holidays or in blocked time are not offered; each slot holds up to
/// [capacity] bookings.
List<Slot> generateSlots({
  required Map<String, dynamic> hours,
  required DateTime day,
  required int slotMinutes,
  int bufferMinutes = 0,
  int capacity = 1,
  int serviceMinutes = 0,
  List<DateTime> holidays = const [],
  List<({DateTime start, DateTime end})> blocks = const [],
  List<DateTime> bookedStarts = const [],
  required DateTime now,
}) {
  final d = DateTime(day.year, day.month, day.day);
  if (holidays.any((h) => h.year == d.year && h.month == d.month && h.day == d.day)) return const [];
  final open = hoursOn(hours, d);
  if (open == null) return const [];
  final length = serviceMinutes > slotMinutes ? serviceMinutes : slotMinutes;
  final step = slotMinutes + bufferMinutes;
  final out = <Slot>[];
  var t = open.open;
  final earliest = now.add(const Duration(minutes: 30));
  // Day-long services (boarding, day care): one slot at opening time.
  if (length >= 600) {
    final booked = bookedStarts.where((b) => b == t).length;
    if (!t.isBefore(earliest) || d.isAfter(DateTime(now.year, now.month, now.day))) {
      out.add(Slot(t, t.add(Duration(minutes: length)), (capacity - booked).clamp(0, capacity)));
    }
    return out;
  }
  while (!t.add(Duration(minutes: length)).isAfter(open.close)) {
    final end = t.add(Duration(minutes: length));
    final blocked = blocks.any((b) => t.isBefore(b.end) && end.isAfter(b.start));
    if (!t.isBefore(earliest) && !blocked) {
      final booked = bookedStarts.where((b) => b == t).length;
      out.add(Slot(t, end, (capacity - booked).clamp(0, capacity)));
    }
    t = t.add(Duration(minutes: step));
    if (out.length > 60) break;
  }
  return out;
}

/// Money for one booking. All amounts in whole rupees.
class BookingPrice {
  const BookingPrice({required this.service, required this.travelFee, required this.platformFee, required this.discount, required this.commission});
  final int service;
  final int travelFee;
  final int platformFee;
  final int discount;

  /// Platform commission, taken from the provider's share.
  final int commission;

  int get total => service + travelFee + platformFee - discount;
  int get payout => service + travelFee - commission;
}

BookingPrice priceBooking({
  required int servicePrice,
  bool homeVisit = false,
  int travelFee = 0,
  num commissionPercent = 10,
  int platformFee = 0,
  num discountPercent = 0,
}) {
  final travel = homeVisit ? travelFee : 0;
  final discount = (servicePrice * discountPercent / 100).round();
  return BookingPrice(
    service: servicePrice,
    travelFee: travel,
    platformFee: platformFee,
    discount: discount,
    commission: ((servicePrice - discount) * commissionPercent / 100).round(),
  );
}

/// Full refund when cancelled at least [cancellationHours] before the start;
/// half after that; nothing once it has started.
int refundAmount({required int paid, required DateTime start, required DateTime now, required int cancellationHours}) {
  if (!now.isBefore(start)) return 0;
  if (start.difference(now).inMinutes >= cancellationHours * 60) return paid;
  return (paid / 2).round();
}

/// A request booking expires if the provider doesn't answer in time.
bool requestExpired({required DateTime createdAt, required int windowHours, required DateTime now}) => now.isAfter(createdAt.add(Duration(hours: windowHours)));

/// .ics calendar file for "Add to calendar".
String icsFor({required String uid, required String title, required DateTime start, required DateTime end, required String location}) {
  String f(DateTime d) {
    final u = d.toUtc();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${u.year}${two(u.month)}${two(u.day)}T${two(u.hour)}${two(u.minute)}00Z';
  }

  return [
    'BEGIN:VCALENDAR',
    'VERSION:2.0',
    'PRODID:-//PawSetu//Bookings//EN',
    'BEGIN:VEVENT',
    'UID:$uid@pawsetu.app',
    'DTSTAMP:${f(DateTime.now())}',
    'DTSTART:${f(start)}',
    'DTEND:${f(end)}',
    'SUMMARY:$title',
    'LOCATION:$location',
    'BEGIN:VALARM',
    'TRIGGER:-PT2H',
    'ACTION:DISPLAY',
    'DESCRIPTION:$title',
    'END:VALARM',
    'END:VEVENT',
    'END:VCALENDAR',
  ].join('\r\n');
}

/// Booking commission in percent (spec 8): the provider's own rate if the
/// admin set one, else the rate for its type (clinic, groomer, trainer,
/// boarder, walker), else the default rate (10%).
num bookingCommissionPercent(Map<String, dynamic>? cfg, {required String kind, Object? providerRate}) {
  if (providerRate is num) return providerRate;
  final c = (cfg?['commission'] as Map?) ?? const {};
  final byType = (c['bookingTypePercent'] as Map?) ?? const {};
  final t = byType[kind];
  if (t is num) return t;
  return (c['bookingPercent'] as num?) ?? 10;
}
