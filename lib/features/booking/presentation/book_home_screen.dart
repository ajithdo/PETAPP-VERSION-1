import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../data/booking_repository.dart';
import 'booking_labels.dart';
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
    // UI Design 6: the two most-used kinds of care as big cards first, then
    // the other four as quieter rows.
    Widget big(IconData icon, Color tone, String title, String sub, String route) => PawCard(
      onTap: () => context.push(route),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _IconTile(icon: icon, color: tone, size: Sizes.thumb),
        const SizedBox(height: Space.md),
        Text(title, style: context.text.titleMedium),
        const SizedBox(height: Space.xxs),
        Text(sub, style: context.text.bodySmall),
      ]),
    );
    Widget small(IconData icon, String title, String sub, String route) => PawCard(
      flat: true,
      color: paw.background,
      padding: const EdgeInsets.all(Space.sm + Space.xxs),
      onTap: () => context.push(route),
      child: Row(children: [
        _IconTile(icon: icon, color: paw.textPrimary, size: TapTarget.min - Space.xxs),
        const SizedBox(width: Space.md),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: context.text.titleSmall),
            if (wide) Text(sub, style: context.text.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
          ]),
        ),
      ]),
    );
    final services = Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      TileGrid(columns: 2, children: [
        big(Ph.firstAid, paw.accent, l.kindVet, l.bookVetSub, '/book/find/clinic'),
        big(Ph.videoCamera, paw.success, l.teleVet, l.bookTeleSub, '/televet'),
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
        const MapSketch(height: Sizes.mapSmall - Space.xxl - Space.sm),
        Padding(
          padding: const EdgeInsets.all(Space.lg),
          child: Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(l.clinicFinderMap, style: context.text.titleSmall),
                Text(l.clinicFinderHint, style: context.text.bodySmall),
              ]),
            ),
            Icon(Ph.caretRight, color: paw.textSecondary),
          ]),
        ),
      ]),
    );
    final mine = [
      SectionHeader(l.myBookings, action: l.seeAll, onAction: () => context.push('/book/bookings'), padding: wide ? const EdgeInsets.only(bottom: Space.sm) : null),
      if (upcoming.isEmpty)
        PawCard(child: Text(l.noUpcomingBookings))
      else
        for (final b in upcoming.take(3))
          Padding(
            padding: const EdgeInsets.only(bottom: Space.sm),
            child: BookingCard(booking: b),
          ),
    ];
    final head = [
      const SizedBox(height: Space.sm),
      Semantics(header: true, child: Text(l.bookTitle, style: context.text.headlineLarge)),
      const SizedBox(height: Space.xxs),
      Text(l.bookIntro, style: context.text.bodyMedium?.copyWith(color: paw.textSecondary)),
      const SizedBox(height: Space.lg),
    ];
    if (context.screenSize == ScreenSize.desktop) {
      return PageBody(children: [
        ...head,
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(flex: 7, child: services),
          const SizedBox(width: Space.xl),
          Expanded(flex: 5, child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [...mine, const SizedBox(height: Space.md), map])),
        ]),
      ]);
    }
    return PageBody(
      children: [...head, services, ...mine, const SizedBox(height: Space.md), map],
    );
  }
}

/// A rounded tile with an icon, tinted in [color] (places and things are
/// tiles in UI Design 6).
class _IconTile extends StatelessWidget {
  const _IconTile({required this.icon, required this.color, required this.size});
  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(color: color.withValues(alpha: Opacities.chip), borderRadius: BorderRadius.circular(size * 0.3)),
    child: Icon(icon, color: color, size: size * 0.5),
  );
}

class BookingCard extends StatelessWidget {
  const BookingCard({super.key, required this.booking, this.partnerView = false, this.trailing});
  final Booking booking;
  final bool partnerView;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final s = bookingStatus(context, booking.status);
    final b = booking;
    final past = b.end.isBefore(DateTime.now());
    // A request still waiting for an answer is a quiet outlined ticket; a
    // confirmed booking is a white one (UI Design 6).
    final waiting = b.status == 'pending' || b.status == 'suggested';
    return PawCard(
      onTap: () => context.push(partnerView ? '/partner/booking/${b.id}' : '/book/bookings/${b.id}'),
      flat: waiting,
      color: waiting ? context.paw.background : null,
      borderColor: waiting ? context.paw.controlBorder.withValues(alpha: Opacities.half) : null,
      child: Row(
        children: [
          DateBadge(day: '${b.start.day}', month: Fmt.monthShort(b.start, context.lang), muted: past, tone: past ? null : ChipTone.warning),
          const SizedBox(width: Space.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  partnerView ? '${b.petName} · ${b.ownerName}' : b.providerName,
                  style: context.text.titleSmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${serviceLabel(context, b.serviceId)}${partnerView ? '' : ' · ${b.petName}'}',
                  style: context.text.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: Space.xxs),
                Row(children: [
                  Icon(kindIcon(b.kind), size: IconSizes.sm, color: context.paw.textSecondary),
                  const SizedBox(width: Space.xs),
                  Flexible(
                    child: Text(
                      Fmt.time(b.start, context.lang),
                      style: context.text.labelMedium?.copyWith(color: context.paw.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ]),
              ],
            ),
          ),
          const SizedBox(width: Space.sm),
          trailing ?? StatusChip(s.$1, tone: s.$2),
        ],
      ),
    );
  }
}
