import 'package:flutter/material.dart';

import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../data/booking_repository.dart';
import '../data/places_repository.dart';
import '../domain/booking_rules.dart';

/// Bookable slots for [service] at [place] on [day], leaving out times that
/// are already taken (the same rules the booking screen uses).
List<Slot> slotsFor(Place place, PlaceService service, DateTime day, List<Booking> bookings, DateTime now) => generateSlots(
      hours: place.hours,
      day: day,
      slotMinutes: service.durationMin >= 600 ? service.durationMin : place.slotMinutes,
      serviceMinutes: service.durationMin,
      bufferMinutes: place.bufferMinutes,
      capacity: place.capacity,
      holidays: place.holidays,
      blocks: place.blocks,
      bookedStarts: bookings.where((b) => b.isActive).map((b) => b.start).toList(),
      now: now,
    );

/// The first free slot in the next week for the place's first service, or
/// null when nothing is free (shown on clinic cards as "Next free slot").
DateTime? nextFreeSlot(Place place, List<Booking> bookings, DateTime now) {
  final s = place.services.firstOrNull;
  if (s == null) return null;
  for (var i = 0; i < 7; i++) {
    final day = DateTime(now.year, now.month, now.day + i);
    final free = slotsFor(place, s, day, bookings, now).where((x) => x.available).firstOrNull;
    if (free != null) return free.start;
  }
  return null;
}

/// "Today, 4:30 PM" or "Wed, 5 Nov, 4:30 PM".
String slotLabel(BuildContext context, DateTime t) {
  final day = Fmt.sameDay(t, DateTime.now()) ? context.l10n.today : Fmt.weekdayDate(t, context.lang);
  return '$day, ${Fmt.time(t, context.lang)}';
}
