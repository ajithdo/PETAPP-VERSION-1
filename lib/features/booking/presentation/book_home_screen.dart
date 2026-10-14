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
    final tiles = [
      (Icons.local_hospital_rounded, l.kindVet, '/book/find/clinic', context.colors.primary),
      (Icons.video_call_rounded, l.teleVet, '/televet', context.paw.accent),
      (Icons.content_cut_rounded, l.kindGrooming, '/book/find/groomer', const Color(0xFFF472B6)),
      (Icons.sports_rounded, l.kindTraining, '/book/find/trainer', const Color(0xFF0EA5E9)),
      (Icons.house_rounded, l.kindBoarding, '/book/find/boarder', const Color(0xFF9B8AFB)),
      (Icons.directions_walk_rounded, l.kindWalking, '/book/find/walker', const Color(0xFF34D399)),
    ];
    return PageBody(
      children: [
        const SizedBox(height: Space.sm),
        Text(l.bookTitle, style: context.text.headlineSmall),
        const SizedBox(height: Space.md),
        GridView.count(
          crossAxisCount: context.isPhone ? 2 : 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: Space.md,
          crossAxisSpacing: Space.md,
          childAspectRatio: 1.45,
          children: [for (final t in tiles) QuickActionTile(icon: t.$1, label: t.$2, color: t.$4, onTap: () => context.push(t.$3))],
        ),
        const SizedBox(height: Space.md),
        PawCard(
          onTap: () => context.push('/book/find/clinic?map=1'),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: context.paw.primaryContainer,
                child: Icon(Icons.map_rounded, color: context.colors.primary),
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
              const Icon(Icons.chevron_right_rounded),
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
    return PawCard(
      onTap: () => context.push(partnerView ? '/partner/booking/${b.id}' : '/book/bookings/${b.id}'),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: context.paw.primaryContainer,
            child: Icon(kindIcon(b.kind), color: context.colors.primary),
          ),
          const SizedBox(width: Space.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  partnerView ? '${b.petName} · ${b.ownerName}' : b.providerName,
                  style: context.text.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${serviceLabel(context, b.serviceId)} · ${partnerView ? '' : '${b.petName} · '}${Fmt.dateTime(b.start, context.lang)}',
                  style: context.text.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
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
