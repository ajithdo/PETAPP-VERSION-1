import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/data/converters.dart';
import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/paw_map.dart';
import '../../../core/widgets/widgets.dart';
import '../../routine/domain/routine.dart';
import '../data/booking_repository.dart';
import '../data/places_repository.dart';
import '../domain/booking_rules.dart';
import 'book_home_screen.dart';
import 'booking_labels.dart';
import 'place_screen.dart';

class MyBookingsScreen extends ConsumerWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.myBookings),
          bottom: TabBar(
            tabs: [
              Tab(text: l.upcoming),
              Tab(text: l.requests),
              Tab(text: l.past),
            ],
          ),
        ),
        body: AsyncView(
          value: ref.watch(myBookingsProvider),
          data: (all) {
            final now = DateTime.now();
            final upcoming = all.where((b) => (b.status == 'confirmed' || b.status == 'in_progress') && b.end.isAfter(now)).toList()
              ..sort((a, b) => a.start.compareTo(b.start));
            final requests = all.where((b) => b.status == 'pending' || b.status == 'suggested').toList();
            final past = all.where((b) => !upcoming.contains(b) && !requests.contains(b)).toList();
            Widget list(List<Booking> items, String empty) => items.isEmpty
                ? EmptyState(scene: Scene.empty, title: empty, actionLabel: l.bookSomething, onAction: () => context.go('/book'))
                : PageBody(
                    maxWidth: 800,
                    children: [
                      const SizedBox(height: Space.md),
                      for (final b in items)
                        Padding(
                          padding: const EdgeInsets.only(bottom: Space.sm),
                          child: BookingCard(booking: b),
                        ),
                    ],
                  );
            return TabBarView(children: [list(upcoming, l.noUpcomingBookings), list(requests, l.noRequests), list(past, l.noPastBookings)]);
          },
        ),
      ),
    );
  }
}

class BookingDetailScreen extends ConsumerWidget {
  const BookingDetailScreen({super.key, required this.bookingId, this.partnerView = false, this.partnerActions});
  final String bookingId;
  final bool partnerView;

  /// Partner-side buttons (accept, start, complete, photo update).
  final Widget Function(Booking b)? partnerActions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.bookingDetails)),
      body: AsyncView<Booking?>(
        value: ref.watch(bookingProvider(bookingId)),
        data: (b) {
          if (b == null) return EmptyState(title: l.notFoundTitle);
          final place = ref.watch(placeProvider(b.providerId)).value;
          final s = bookingStatus(context, b.status);
          Widget row(String k, String v) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 120, child: Text(k, style: context.text.bodySmall)),
                Expanded(child: Text(v, style: context.text.bodyMedium)),
              ],
            ),
          );
          return PageBody(
            maxWidth: 800,
            children: [
              const SizedBox(height: Space.md),
              PawCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
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
                              Text(partnerView ? '${b.petName} · ${b.ownerName}' : b.providerName, style: context.text.titleMedium),
                              Text(serviceLabel(context, b.serviceId), style: context.text.bodySmall),
                            ],
                          ),
                        ),
                        StatusChip(s.$1, tone: s.$2),
                      ],
                    ),
                    const Divider(height: Space.xl),
                    row(l.when, Fmt.dateTime(b.start, context.lang)),
                    if (!partnerView) row(l.pet, b.petName),
                    if (b.vetName != null) row(l.vet, b.vetName!),
                    if (b.homeVisit) row(l.homeVisit, l.yes),
                    if (b.notes?.isNotEmpty == true) row(l.notes, b.notes!),
                    if (b.status == 'pending' && b.proposedTimes.isNotEmpty)
                      row(l.preferredTimes, b.proposedTimes.map((t) => Fmt.dateTime(t, context.lang)).join('\n')),
                    if (b.status == 'pending' && b.respondBy != null) row(l.replyBy, Fmt.dateTime(b.respondBy!, context.lang)),
                    const Divider(height: Space.xl),
                    row(l.totalToPay, Fmt.inr(b.total)),
                    row(l.payment, switch (b.paymentStatus) {
                      'paid' => l.paidOnline,
                      _ => b.paymentOption == 'online' ? l.paymentPending : l.payAtVisit,
                    }),
                    if (partnerView) ...[row(l.platformCommission, Fmt.inr(b.commission)), row(l.yourPayout, Fmt.inr(b.payout))],
                    if (b.refund > 0) row(l.refund, l.refundDemo(Fmt.inr(b.refund))),
                  ],
                ),
              ),
              if (b.status == 'suggested' && b.suggestedTime != null && !partnerView) ...[
                const SizedBox(height: Space.md),
                PawCard(
                  color: context.paw.accent.withValues(alpha: 0.15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(l.providerSuggested(b.providerName, Fmt.dateTime(b.suggestedTime!, context.lang))),
                      const SizedBox(height: Space.md),
                      Row(
                        children: [
                          Expanded(
                            child: SecondaryButton(
                              label: l.decline,
                              onPressed: () => ref.read(bookingRepositoryProvider).cancel(b, cancellationHours: 0, byOwner: true),
                            ),
                          ),
                          const SizedBox(width: Space.sm),
                          Expanded(
                            child: PrimaryButton(label: l.accept, onPressed: () => ref.read(bookingRepositoryProvider).acceptSuggestion(b)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
              if (b.kind == 'walker' && (b.status == 'in_progress' || b.walkRoute.isNotEmpty)) ...[SectionHeader(l.liveWalk), _LiveWalk(booking: b)],
              if (b.updates.isNotEmpty) ...[
                SectionHeader(b.kind == 'boarder' ? l.dailyUpdates : l.updates),
                for (final u in b.updates.reversed)
                  Padding(
                    padding: const EdgeInsets.only(bottom: Space.sm),
                    child: PawCard(
                      padding: EdgeInsets.zero,
                      child: Row(
                        children: [
                          if (u['photoUrl'] != null) SizedBox(width: 96, height: 96, child: MediaImage(url: u['photoUrl'] as String, width: 96, height: 96)),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(Space.md),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(u['text'] as String? ?? ''),
                                  Text(Fmt.dateTime(parseDate(u['at']) ?? DateTime.now(), context.lang), style: context.text.bodySmall),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
              const SizedBox(height: Space.md),
              if (!partnerView) ..._ownerActions(context, ref, b, place),
              if (partnerView && partnerActions != null) partnerActions!(b),
              const SizedBox(height: Space.sm),
              TextButton.icon(
                onPressed: () => context.push('${partnerView ? '/help' : '/me/help'}/new?booking=${b.id}'),
                icon: const Icon(Icons.support_agent_rounded),
                label: Text(context.l10n.hpGetHelpBooking),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _ownerActions(BuildContext context, WidgetRef ref, Booking b, Place? place) {
    final l = context.l10n;
    final repo = ref.read(bookingRepositoryProvider);
    return [
      if (b.status == 'confirmed') ...[
        SecondaryButton(
          label: l.addToCalendar,
          icon: Icons.event_rounded,
          onPressed: () {
            final ics = icsFor(
              uid: b.id,
              title: '${serviceLabel(context, b.serviceId)} · ${b.petName} · ${b.providerName}',
              start: b.start,
              end: b.end,
              location: (b.raw['providerAddress'] as String?) ?? b.providerName,
            );
            SharePlus.instance.share(
              ShareParams(
                files: [XFile.fromData(Uint8List.fromList(utf8.encode(ics)), mimeType: 'text/calendar', name: 'pawsetu-booking.ics')],
                fileNameOverrides: const ['pawsetu-booking.ics'],
              ),
            );
          },
        ),
        const SizedBox(height: Space.sm),
      ],
      if (place != null) ...[
        Row(
          children: [
            Expanded(
              child: SecondaryButton(label: l.call, icon: Icons.call_rounded, onPressed: () => callNumber(context, ref, place.phone)),
            ),
            const SizedBox(width: Space.sm),
            Expanded(
              child: SecondaryButton(label: l.message, icon: Icons.chat_rounded, onPressed: () => context.push('/messages/new?booking=${b.id}')),
            ),
          ],
        ),
        const SizedBox(height: Space.sm),
      ],
      if (b.status == 'confirmed' && b.start.isAfter(DateTime.now()) && place != null) ...[
        SecondaryButton(label: l.reschedule, icon: Icons.edit_calendar_rounded, onPressed: () => _reschedule(context, ref, b, place)),
        const SizedBox(height: Space.sm),
      ],
      if (b.isActive && b.start.isAfter(DateTime.now()))
        TextButton(
          onPressed: () async {
            final hours = place?.cancellationHours ?? 4;
            final refund = b.paymentStatus == 'paid' ? refundAmount(paid: b.total, start: b.start, now: DateTime.now(), cancellationHours: hours) : 0;
            final ok = await confirmAction(
              context,
              title: l.cancelBookingQ,
              body: b.paymentStatus == 'paid' ? l.cancelRefundInfo(Fmt.inr(refund)) : l.cancellationPolicy(hours),
              confirmLabel: l.cancelBooking,
            );
            if (ok) {
              final r = await repo.cancel(b, cancellationHours: hours, byOwner: true);
              if (context.mounted) showToast(context, r > 0 ? l.cancelledWithRefund(Fmt.inr(r)) : l.bookingCancelled);
            }
          },
          child: Text(l.cancelBooking, style: TextStyle(color: context.paw.error)),
        ),
      if (b.status == 'completed' && !b.reviewed && place != null)
        PrimaryButton(label: l.writeReview, icon: Icons.star_rounded, onPressed: () => _review(context, ref, b, place)),
    ];
  }

  Future<void> _reschedule(BuildContext context, WidgetRef ref, Booking b, Place place) async {
    final l = context.l10n;
    final svc = place.service(b.serviceId);
    if (svc == null) return;
    var day = DateTime.now();
    DateTime? chosen;
    final booked = (ref.read(providerBookingsProvider(place.id)).value ?? const <Booking>[])
        .where((x) => x.isActive && x.id != b.id)
        .map((x) => x.start)
        .toList();
    final ok = await showPawSheet<bool>(
      context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, set) {
          final slots = generateSlots(
            hours: place.hours,
            day: day,
            slotMinutes: place.slotMinutes,
            serviceMinutes: svc.durationMin,
            bufferMinutes: place.bufferMinutes,
            capacity: place.capacity,
            bookedStarts: booked,
            now: DateTime.now(),
          );
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l.reschedule, style: ctx.text.titleMedium),
              const SizedBox(height: Space.sm),
              Wrap(
                spacing: Space.sm,
                children: [
                  for (var i = 0; i < 7; i++)
                    () {
                      final d = DateTime.now().add(Duration(days: i));
                      return ChoiceChip(label: Text(Fmt.dateShort(d, ctx.lang)), selected: Fmt.sameDay(d, day), onSelected: (_) => set(() => day = d));
                    }(),
                ],
              ),
              const SizedBox(height: Space.md),
              Wrap(
                spacing: Space.sm,
                runSpacing: Space.sm,
                children: [
                  for (final s in slots.where((s) => s.available))
                    ChoiceChip(label: Text(Fmt.time(s.start, ctx.lang)), selected: chosen == s.start, onSelected: (_) => set(() => chosen = s.start)),
                ],
              ),
              const SizedBox(height: Space.lg),
              PrimaryButton(label: l.confirm, onPressed: () => chosen == null ? null : Navigator.pop(ctx, true)),
            ],
          );
        },
      ),
    );
    if (ok == true && chosen != null) {
      await ref.read(bookingRepositoryProvider).reschedule(b, chosen!);
      if (context.mounted) showToast(context, l.rescheduledTo(Fmt.dateTime(chosen!, context.lang)));
    }
  }

  Future<void> _review(BuildContext context, WidgetRef ref, Booking b, Place place) async {
    final l = context.l10n;
    var rating = 5;
    final text = TextEditingController();
    final ok = await showPawSheet<bool>(
      context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, set) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l.rateProvider(place.name), style: ctx.text.titleMedium),
            const SizedBox(height: Space.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 1; i <= 5; i++)
                  IconButton(
                    tooltip: l.starsLabel(i),
                    iconSize: 40,
                    onPressed: () => set(() => rating = i),
                    icon: Icon(i <= rating ? Icons.star_rounded : Icons.star_border_rounded, color: ctx.paw.accent),
                  ),
              ],
            ),
            PawTextField(label: l.reviewText, controller: text, maxLines: 4),
            PrimaryButton(label: l.postReview, onPressed: () => Navigator.pop(ctx, true)),
          ],
        ),
      ),
    );
    if (ok == true) {
      final user = ref.read(currentUserProvider)!;
      await ref
          .read(placesRepositoryProvider)
          .addReview(place: place, bookingId: b.id, ownerId: user.uid, ownerName: user.name, rating: rating, text: text.text.trim());
      if (context.mounted) showToast(context, l.thanksForReview);
    }
  }
}

/// Walker's live GPS route. In demo mode the walker's movement is simulated.
class _LiveWalk extends StatefulWidget {
  const _LiveWalk({required this.booking});
  final Booking booking;
  @override
  State<_LiveWalk> createState() => _LiveWalkState();
}

class _LiveWalkState extends State<_LiveWalk> {
  late final List<({double lat, double lng})> _full;
  int _shown = 2;
  Timer? _t;

  @override
  void initState() {
    super.initState();
    final b = widget.booking;
    _full = b.walkRoute.isNotEmpty ? b.walkRoute : demoLoopRoute(17.4126, 78.4482, seed: b.id.hashCode, km: 2, points: 60);
    _shown = widget.booking.status == 'in_progress' ? (_full.length * 0.4).round() : _full.length;
    if (widget.booking.status == 'in_progress') {
      _t = Timer.periodic(const Duration(seconds: 2), (_) {
        if (_shown < _full.length) setState(() => _shown++);
      });
    }
  }

  @override
  void dispose() {
    _t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pts = [for (final p in _full.take(_shown)) LatLng(p.lat, p.lng)];
    final km = routeKm(_full.take(_shown).toList());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 240,
          child: PawMap(
            center: pts.last,
            zoom: 15,
            routes: [pts],
            markers: [dotMarker(pts.first, context.paw.success), dotMarker(pts.last, context.colors.primary)],
          ),
        ),
        const SizedBox(height: Space.sm),
        Text(context.l10n.walkSoFar(Fmt.km(km)), style: context.text.bodySmall),
        if (widget.booking.status == 'in_progress') DemoBanner(context.l10n.liveWalkDemo),
      ],
    );
  }
}
