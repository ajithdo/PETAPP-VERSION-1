import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/paw_map.dart';
import '../../../core/widgets/widgets.dart';
import '../../routine/domain/routine.dart' show distanceKm;
import '../../televet/data/televet_repository.dart';
import '../data/booking_repository.dart';
import '../data/places_repository.dart';
import 'booking_labels.dart';
import 'booking_slots.dart';
import 'place_finder_screen.dart';
import '../../../core/theme/ph.dart';

/// Book tab (spec 5, UI Design 6): vet at clinic and tele-vet first, then
/// grooming, training, boarding and sitting, dog walking; my bookings and
/// the clinic finder map.
class BookHomeScreen extends ConsumerWidget {
  const BookHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final bookings = ref.watch(myBookingsProvider).value ?? const <Booking>[];
    final upcoming = bookings.where((b) => b.isActive && b.end.isAfter(DateTime.now())).toList()..sort((a, b) => a.start.compareTo(b.start));
    final paw = context.paw;
    final wide = !context.isPhone;
    // What is true right now, for the two big cards: the nearest clinic's
    // next free slot, and how many tele-vets are on.
    final origin = ref.watch(searchOriginProvider);
    final clinics = [...(ref.watch(clinicsProvider).value ?? const <Place>[])]
      ..sort((a, b) => distanceKm(origin.lat, origin.lng, a.lat, a.lng).compareTo(distanceKm(origin.lat, origin.lng, b.lat, b.lng)));
    final nearest = clinics.firstOrNull;
    final slot = nearest == null ? null : nextFreeSlot(nearest, ref.watch(providerBookingsProvider(nearest.id)).value ?? const [], DateTime.now());
    final vetsOn = ref.watch(teleVetsProvider).value?.length ?? 0;
    String lowerFirst(String x) => x.isEmpty || context.lang != 'en' ? x : x[0].toLowerCase() + x.substring(1);
    // UI Design 6: the two most-used kinds of care as big cards first, then
    // the other four as quieter rows.
    Widget big(IconData icon, Tone tone, String title, String sub, String? meta, String route) {
      final c = toneColors(context, tone);
      return PawCard(
        onTap: () => context.push(route),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          PawTile(icon: icon, tone: tone, size: Sizes.tileLg),
          const SizedBox(height: Space.md),
          Text(title, style: context.text.titleSmall),
          Text(sub, style: context.text.bodySmall?.copyWith(color: paw.textSecondary)),
          if (meta != null) ...[
            const SizedBox(height: Space.sm),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(padding: const EdgeInsets.only(top: Space.xxs), child: Icon(Ph.circleFill, size: IconSizes.xs - Space.xxs, color: c.ink)),
              const SizedBox(width: Space.xs),
              Expanded(child: Text(meta, style: context.text.labelSmall?.copyWith(color: c.ink, fontWeight: FontWeight.w500))),
            ]),
          ],
        ]),
      );
    }

    Widget small(IconData icon, String title, String sub, String route) => Semantics(
      button: true,
      label: title,
      excludeSemantics: true,
      child: Material(
        type: MaterialType.transparency,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.lg), side: BorderSide(color: paw.outline)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.push(route),
          child: Padding(
            padding: const EdgeInsets.all(Space.sm + Space.xxs),
            child: Row(children: [
              PawTile(icon: icon),
              const SizedBox(width: Space.md),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                  Text(title, style: context.text.labelLarge),
                  if (wide) Text(sub, style: context.text.bodySmall?.copyWith(color: paw.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
                ]),
              ),
            ]),
          ),
        ),
      ),
    );
    final services = Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      TileGrid(columns: 2, children: [
        big(Ph.firstAid, Tone.gold, l.kindVet, l.bookVetSub, slot == null ? null : l.bookNextSlot(lowerFirst(slotLabel(context, slot))), '/book/find/clinic'),
        big(Ph.videoCamera, Tone.green, l.teleVet, l.bookTeleSub, vetsOn == 0 ? null : l.bookVetsOnline(vetsOn), '/televet'),
      ]),
      const SizedBox(height: Space.md),
      // With big text (Easy mode) one per row, so words never break.
      TileGrid(columns: MediaQuery.textScalerOf(context).scale(1) > 1.15 ? 1 : 2, children: [
        small(Ph.scissors, l.kindGrooming, l.bookGroomSub, '/book/find/groomer'),
        small(Ph.graduationCap, l.kindTraining, l.bookTrainSub, '/book/find/trainer'),
        small(Ph.houseLine, l.kindBoarding, l.bookBoardSub, '/book/find/boarder'),
        small(Ph.personSimpleWalk, l.kindWalking, l.bookWalkSub, '/book/find/walker'),
      ]),
    ]);
    final map = PawCard(
      padding: EdgeInsets.zero,
      onTap: () => context.push('/book/find/clinic?map=1'),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const MapSketch(height: Sizes.mapSketch),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.md + Space.xxs),
          child: Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(l.clinicFinderMap, style: context.text.labelLarge),
                Text(l.clinicFinderHint, style: context.text.bodySmall?.copyWith(color: paw.textSecondary)),
              ]),
            ),
            const SizedBox(width: Space.md),
            const Chev(),
          ]),
        ),
      ]),
    );
    final mine = [
      SecHead(l.myBookings, action: l.seeAll, onAction: () => context.push('/book/bookings')),
      if (upcoming.isEmpty)
        PawPanel(child: Text(l.noUpcomingBookings, style: context.text.bodyMedium))
      else
        for (final (i, b) in upcoming.take(3).indexed)
          Padding(
            padding: EdgeInsets.only(top: i == 0 ? 0 : Space.md),
            child: BookingCard(booking: b, actions: true),
          ),
    ];
    final area = origin.label.split(',').first.trim();
    final head = [
      const SizedBox(height: Space.sm),
      Semantics(header: true, child: Text(l.bookTitle, style: context.text.displaySmall)),
      const SizedBox(height: Space.xs),
      Text(area.isEmpty ? l.bookIntro : l.bookIntroNear(area), style: context.text.bodySmall?.copyWith(color: paw.textSecondary)),
      const SizedBox(height: Space.lg + Space.xs),
    ];
    const gap = SizedBox(height: Sizes.sectionGap);
    if (context.screenSize == ScreenSize.desktop) {
      return PageBody(children: [
        ...head,
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(flex: 7, child: services),
          const SizedBox(width: Space.xl),
          Expanded(flex: 5, child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [...mine, gap, map])),
        ]),
      ]);
    }
    return PageBody(
      children: [...head, services, gap, ...mine, gap, map],
    );
  }
}

class BookingCard extends ConsumerWidget {
  const BookingCard({super.key, required this.booking, this.partnerView = false, this.trailing, this.actions = false});
  final Booking booking;
  final bool partnerView;
  final Widget? trailing;

  /// Directions and Reschedule under a dashed rule (an upcoming booking on
  /// the Book tab).
  final bool actions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final paw = context.paw;
    final s = bookingStatus(context, booking.status);
    final b = booking;
    final now = DateTime.now();
    final past = b.end.isBefore(now);
    // A request still waiting for an answer is a quiet outlined ticket; a
    // confirmed booking is a white one (UI Design 6).
    final waiting = b.status == 'pending' || b.status == 'suggested';
    final days = DateTime(b.start.year, b.start.month, b.start.day).difference(DateTime(now.year, now.month, now.day)).inDays;
    final when = [
      '${Fmt.weekdayDate(b.start, context.lang).split(',').first} ${Fmt.time(b.start, context.lang)}',
      if (!past && days >= 0) l.inDaysCount(days),
    ].join(', ');
    final sub = context.text.bodySmall?.copyWith(color: paw.textSecondary);
    final place = actions && !partnerView ? ref.watch(placeProvider(b.providerId)).value : null;
    final showActions = actions && !partnerView && b.isUpcoming;
    return PawCard(
      onTap: () => context.push(partnerView ? '/partner/booking/${b.id}' : '/book/bookings/${b.id}'),
      flat: waiting,
      color: waiting ? paw.background : null,
      borderColor: waiting ? context.tint.line2 : null,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          DateBadge(day: '${b.start.day}', month: Fmt.monthShort(b.start, context.lang), muted: past, tone: past ? null : ChipTone.warning),
          const SizedBox(width: Space.md),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(partnerView ? '${b.petName} · ${b.ownerName}' : b.providerName, style: context.text.labelLarge, maxLines: 2, overflow: TextOverflow.ellipsis),
              Text('${serviceLabel(context, b.serviceId)}${partnerView ? '' : ', ${b.petName}'}', style: sub, maxLines: 2, overflow: TextOverflow.ellipsis),
              Text(when, style: sub),
              const SizedBox(height: Space.sm),
              trailing ?? StatusChip(s.$1, tone: s.$2, icon: b.status == 'confirmed' ? Ph.checkCircleFill : null),
            ]),
          ),
        ]),
        if (showActions) ...[
          const Padding(padding: EdgeInsets.symmetric(vertical: Space.md + Space.xxs), child: DashedRule()),
          Wrap(spacing: Space.sm, runSpacing: Space.sm, children: [
            if (place != null) PawButton(label: l.directions, icon: Ph.navigationArrow, kind: BtnKind.soft, onPressed: () => openDirections(place.lat, place.lng, label: place.name)),
            PawButton(label: l.reschedule, icon: Ph.calendarDots, kind: BtnKind.soft, onPressed: () => context.push('/book/bookings/${b.id}')),
          ]),
        ],
      ]),
    );
  }
}
