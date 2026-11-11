import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../data/booking_repository.dart';
import 'booking_labels.dart';

/// Book tab (spec 5): vet at clinic, tele-vet, grooming, training,
/// boarding and sitting, dog walking, clinic finder map, my bookings.
class BookHomeScreen extends ConsumerWidget {
  const BookHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final bookings = ref.watch(myBookingsProvider).value ?? const <Booking>[];
    final upcoming = bookings.where((b) => b.isActive && b.end.isAfter(DateTime.now())).toList()..sort((a, b) => a.start.compareTo(b.start));
    // One quiet style for every kind of care (UI Design 5): the pale
    // marigold circle of the quick actions, not six different colours.
    final tiles = [
      (Icons.local_hospital_outlined, l.kindVet, '/book/find/clinic'),
      (Icons.video_call_outlined, l.teleVet, '/televet'),
      (Icons.content_cut_outlined, l.kindGrooming, '/book/find/groomer'),
      (Icons.sports_outlined, l.kindTraining, '/book/find/trainer'),
      (Icons.house_outlined, l.kindBoarding, '/book/find/boarder'),
      (Icons.directions_walk_outlined, l.kindWalking, '/book/find/walker'),
    ];
    return PageBody(
      children: [
        const SizedBox(height: Space.sm),
        Semantics(header: true, child: Text(l.bookTitle, style: context.text.headlineMedium)),
        const SizedBox(height: Space.md),
        TileGrid(
          columns: context.isPhone ? 2 : 3,
          minTileHeight: Sizes.quickTile,
          children: [for (final t in tiles) QuickActionTile(icon: t.$1, label: t.$2, onTap: () => context.push(t.$3))],
        ),
        const SizedBox(height: Space.md),
        PawCard(
          onTap: () => context.push('/book/find/clinic?map=1'),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: context.paw.surfaceSubtle,
                child: Icon(Icons.map_outlined, color: context.paw.textPrimary),
              ),
              const SizedBox(width: Space.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.clinicFinderMap, style: context.text.titleSmall),
                    Text(l.clinicFinderHint, style: context.text.bodySmall),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_outlined),
            ],
          ),
        ),
        SectionHeader(l.myBookings, action: l.seeAll, onAction: () => context.push('/book/bookings')),
        if (upcoming.isEmpty)
          PawCard(child: Text(l.noUpcomingBookings))
        else
          for (final b in upcoming.take(3))
            Padding(
              padding: const EdgeInsets.only(bottom: Space.sm),
              child: BookingCard(booking: b),
            ),
      ],
    );
  }
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
    return PawCard(
      onTap: () => context.push(partnerView ? '/partner/booking/${b.id}' : '/book/bookings/${b.id}'),
      child: Row(
        children: [
          DateBadge(day: '${b.start.day}', month: Fmt.monthShort(b.start, context.lang), muted: past),
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
