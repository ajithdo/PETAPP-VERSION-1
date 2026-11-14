import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/data/converters.dart';
import '../../../core/data/paging.dart';
import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/paw_map.dart';
import '../../../core/widgets/widgets.dart';
import '../../health/data/health_repository.dart';
import '../../health/domain/vaccine_schedule.dart';
import '../../pets/data/pets_repository.dart';
import '../../pets/domain/pet.dart';
import '../../routine/domain/routine.dart';
import '../data/booking_repository.dart';
import '../data/places_repository.dart';
import '../domain/booking_rules.dart';
import 'book_home_screen.dart';
import 'booking_labels.dart';
import 'place_screen.dart';
import '../../../core/theme/ph.dart';

class MyBookingsScreen extends ConsumerWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final all0 = ref.watch(myBookingsProvider).value ?? const <Booking>[];
    final now0 = DateTime.now();
    final nUp = all0.where((b) => (b.status == 'confirmed' || b.status == 'in_progress') && b.end.isAfter(now0)).length;
    final nReq = all0.where((b) => b.status == 'pending' || b.status == 'suggested').length;
    // A tab's name with how many are in it, as a small marigold tag.
    Widget tab(String label, int n) => Tab(
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Text(label),
            if (n > 0) ...[const SizedBox(width: Space.xs + Space.xxs), PawTag('$n', kind: TagKind.gold)],
          ]),
        );
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.myBookings),
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            padding: EdgeInsets.symmetric(horizontal: context.gutter - Space.sm),
            labelPadding: const EdgeInsets.symmetric(horizontal: Space.md - Space.xxs),
            tabs: [tab(l.upcoming, nUp), tab(l.requests, nReq), Tab(text: l.past)],
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
            Widget list(List<Booking> items, String empty, String key, {List<Widget> after = const []}) {
              if (items.isEmpty && after.isEmpty) {
                return EmptyState(scene: Scene.empty, title: empty, actionLabel: l.bookSomething, onAction: () => context.go('/book'));
              }
              final limit = ref.watch(listLimitProvider(key));
              return PageBody(
                maxWidth: Space.readingWidth,
                children: [
                  const SizedBox(height: Space.lg),
                  for (final b in items.take(limit))
                    Padding(
                      padding: const EdgeInsets.only(bottom: Space.md),
                      child: BookingCard(booking: b, actions: true, showPet: true),
                    ),
                  if (items.length > limit) ShowMoreButton(onPressed: () => ref.read(listLimitProvider(key).notifier).more()),
                  ...after,
                ],
              );
            }

            return TabBarView(children: [
              // Upcoming also shows what is still waiting for an answer, and
              // a nudge when a vaccine is due.
              list([...upcoming, ...requests], l.noUpcomingBookings, 'bookings:upcoming', after: const [_VaccineNudge()]),
              list(requests, l.noRequests, 'bookings:requests'),
              list(past, l.noPastBookings, 'bookings:past'),
            ]);
          },
        ),
      ),
    );
  }
}

/// "Bruno's vaccines are due on 18 Nov": a marigold nudge on My bookings
/// when a pet has a vaccine due soon or overdue.
class _VaccineNudge extends ConsumerWidget {
  const _VaccineNudge();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final pets = ref.watch(activePetsProvider);
    (Pet, DueItem)? first;
    for (final p in pets) {
      for (final i in ref.watch(petDueProvider(p)).value ?? const <DueItem>[]) {
        if (i.kind != 'vaccine' || i.at == null || i.status == DoseStatus.upcoming) continue;
        if (first == null || i.at!.isBefore(first.$2.at!)) first = (p, i);
      }
    }
    if (first == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: Space.md),
      child: Wash(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l.dueBoosters(first.$1.name, Fmt.dateShort(first.$2.at!, context.lang)), style: context.text.labelLarge),
          Text(l.dueBoostersSub, style: context.text.bodySmall?.copyWith(color: context.paw.accent)),
          const SizedBox(height: Space.md),
          PawButton(label: l.bookVaccines, icon: Ph.calendarPlus, onPressed: () => context.push('/book/find/clinic')),
        ]),
      ),
    );
  }
}

/// Shares the booking as a calendar file (.ics) so it can be added to any
/// calendar app.
void shareBookingToCalendar(BuildContext context, Booking b) {
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
          final paw = context.paw;
          final lang = context.lang;
          final pet = partnerView ? null : ref.watch(petProvider(b.petId)).value;
          final service = serviceLabel(context, b.serviceId);
          // "Sun 18 Oct 2026, 11:00 AM"
          final when = '${Fmt.weekdayDate(b.start, lang).split(',').first} ${Fmt.date(b.start, lang)}, ${Fmt.time(b.start, lang)}';
          return PageBody(
            maxWidth: Space.readingWidth,
            children: [
              const SizedBox(height: Space.md),
              PawCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // The place as a tile (its photo when there is one).
                        PawTile(
                          size: Sizes.tileLg,
                          icon: place == null ? kindIcon(b.kind) : null,
                          child: place == null ? null : SeedArt(seed: place.artSeed),
                        ),
                        const SizedBox(width: Space.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Semantics(header: true, child: Text(partnerView ? '${b.petName} · ${b.ownerName}' : b.providerName, style: context.text.titleLarge)),
                              Text(
                                b.vetName != null && !partnerView ? l.serviceWithVet(service, b.vetName!) : service,
                                style: context.text.bodySmall?.copyWith(color: paw.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: Space.sm),
                        StatusChip(s.$1, tone: s.$2, icon: b.status == 'confirmed' || b.status == 'completed' ? Ph.checkCircleFill : null),
                      ],
                    ),
                    // Booked → confirmed → visited, like the stamps on a ticket.
                    if (const ['pending', 'suggested', 'confirmed', 'in_progress', 'completed'].contains(b.status)) ...[
                      const SizedBox(height: Space.lg),
                      _Steps(reached: switch (b.status) { 'pending' || 'suggested' => 1, 'confirmed' || 'in_progress' => 2, _ => 3 }),
                    ],
                    const Padding(padding: EdgeInsets.symmetric(vertical: Space.md + Space.xxs), child: DashedRule()),
                    KvList(rows: [
                      (l.when, when, null),
                      if (b.vetName != null && partnerView) (l.vet, b.vetName!, null),
                      if (b.homeVisit) (l.homeVisit, l.yes, null),
                    ]),
                    if (!partnerView) ...[
                      const SizedBox(height: Space.xs + Space.xxs),
                      // The pet, with its arch beside the name.
                      LayoutBuilder(builder: (context, box) {
                        final k = MediaQuery.textScalerOf(context).scale(1);
                        final w = (box.maxWidth * 0.38).clamp(Sizes.labelColumnSm * k, box.maxWidth * 0.5);
                        return Row(children: [
                          SizedBox(width: w, child: Text(l.pet, style: context.text.bodySmall?.copyWith(color: paw.textSecondary))),
                          const SizedBox(width: Space.md),
                          if (pet != null) ...[
                            PetAvatar(species: pet.species, colorTag: pet.colorTag, photoUrl: pet.photoUrl, size: Space.xl * Sizes.archAspect, ring: false),
                            const SizedBox(width: Space.sm),
                          ],
                          Expanded(child: Text(b.petName, style: context.text.bodyMedium?.copyWith(fontWeight: FontWeight.w600))),
                        ]);
                      }),
                      const SizedBox(height: Space.xs + Space.xxs),
                    ],
                    KvList(rows: [
                      if (b.notes?.isNotEmpty == true) (l.notes, b.notes!, null),
                      if (b.status == 'pending' && b.proposedTimes.isNotEmpty) (l.preferredTimes, b.proposedTimes.map((t) => Fmt.dateTime(t, lang)).join('\n'), null),
                      if (b.status == 'pending' && b.respondBy != null) (l.replyBy, Fmt.dateTime(b.respondBy!, lang), null),
                      (l.bookingIdLabel, b.id.toUpperCase().replaceAll('_', '-'), null),
                    ]),
                    const Padding(padding: EdgeInsets.symmetric(vertical: Space.md + Space.xxs), child: DashedRule()),
                    KvList(rows: [
                      (service, Fmt.inr(b.price), null),
                      if (b.travelFee > 0) (l.homeVisit, Fmt.inr(b.travelFee), null),
                      (l.platformFee, Fmt.inr(b.platformFee), null),
                      if (b.discount > 0) (l.discountWord, '- ${Fmt.inr(b.discount)}', null),
                    ]),
                    const SizedBox(height: Space.sm),
                    // The total stands out.
                    LayoutBuilder(builder: (context, box) {
                      final k = MediaQuery.textScalerOf(context).scale(1);
                      final w = (box.maxWidth * 0.38).clamp(Sizes.labelColumnSm * k, box.maxWidth * 0.5);
                      return Row(crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [
                        SizedBox(width: w, child: Text(l.totalToPay, style: context.text.bodySmall?.copyWith(color: paw.textSecondary))),
                        const SizedBox(width: Space.md),
                        Expanded(child: Text(Fmt.inr(b.total), style: context.text.titleSmall?.copyWith(fontWeight: FontWeight.w700))),
                      ]);
                    }),
                    const SizedBox(height: Space.xs + Space.xxs),
                    KvList(rows: [
                      (
                        l.payment,
                        switch (b.paymentStatus) {
                          'paid' => l.paidOnline,
                          _ => b.paymentOption == 'online' ? l.paymentPending : l.payAtVisit,
                        },
                        null,
                      ),
                      if (partnerView) (l.platformCommission, Fmt.inr(b.commission), null),
                      if (partnerView) (l.yourPayout, Fmt.inr(b.payout), null),
                      if (b.refund > 0) (l.refund, l.refundDemo(Fmt.inr(b.refund)), null),
                    ]),
                  ],
                ),
              ),
              if (b.status == 'suggested' && b.suggestedTime != null && !partnerView) ...[
                const SizedBox(height: Space.md),
                PawCard(
                  color: context.paw.accent.withValues(alpha: Opacities.chip),
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
                          if (u['photoUrl'] != null) SizedBox(width: Sizes.updatePhoto, height: Sizes.updatePhoto, child: MediaImage(url: u['photoUrl'] as String, width: Sizes.updatePhoto, height: Sizes.updatePhoto)),
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
              const SizedBox(height: Space.lg),
              if (!partnerView) ..._ownerActions(context, ref, b, place),
              if (partnerView && partnerActions != null) partnerActions!(b),
              if (partnerView)
                Padding(
                  padding: const EdgeInsets.only(top: Space.md),
                  child: Align(child: TextLink(context.l10n.hpGetHelpBooking, onTap: () => context.push('/help/new?booking=${b.id}'))),
                ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _ownerActions(BuildContext context, WidgetRef ref, Booking b, Place? place) {
    final l = context.l10n;
    final paw = context.paw;
    final repo = ref.read(bookingRepositoryProvider);
    final future = b.start.isAfter(DateTime.now());
    Widget item(IconData icon, Tone tone, String title, String sub, VoidCallback onTap) =>
        PawItem(lead: PawTile(icon: icon, tone: tone), title: title, sub: sub, onTap: onTap);
    return [
      // Call and Message, side by side.
      if (place != null) ...[
        Row(children: [
          Expanded(child: PawButton(label: l.call, icon: Ph.phone, kind: BtnKind.soft, size: BtnSize.regular, block: true, onPressed: () => callNumber(context, ref, place.phone))),
          const SizedBox(width: Space.md),
          Expanded(
            child: PawButton(label: l.message, icon: Ph.chatCircleDots, kind: BtnKind.soft, size: BtnSize.regular, block: true, onPressed: () => context.push('/messages/new?booking=${b.id}')),
          ),
        ]),
        const SizedBox(height: Space.lg),
      ],
      // After the visit: stars to tap for a review.
      if (b.status == 'completed' && !b.reviewed && place != null) ...[
        Wash(
          onTap: () => _review(context, ref, b, place),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(l.howWasVisit, style: context.text.labelLarge),
            const SizedBox(height: Space.sm),
            Semantics(
              button: true,
              label: l.writeReview,
              excludeSemantics: true,
              child: Row(children: [for (var i = 0; i < 5; i++) Padding(padding: const EdgeInsets.only(right: Space.xs), child: Icon(Ph.star, size: IconSizes.action, color: paw.done))]),
            ),
            const SizedBox(height: Space.sm),
            Text(l.reviewWhoCan, style: context.text.bodySmall?.copyWith(color: paw.accent)),
          ]),
        ),
        const SizedBox(height: Space.lg),
      ],
      PawPanel(
        padding: PawPanel.listPadding,
        child: PawList(children: [
          if (b.status == 'confirmed' && future && place != null) item(Ph.calendarDots, Tone.gold, l.reschedule, Fmt.dateTime(b.start, context.lang), () => _reschedule(context, ref, b, place)),
          if (b.status == 'confirmed') item(Ph.calendarPlus, Tone.neutral, l.addToCalendar, l.addToCalendarSub, () => shareBookingToCalendar(context, b)),
          if (place != null && !b.isActive) item(Ph.arrowClockwise, Tone.gold, l.bookAgain, l.bookAgainSub, () => context.push('/book/place/${place.id}')),
          if (place != null) item(Ph.navigationArrow, Tone.neutral, l.directions, place.address, () => openDirections(place.lat, place.lng, label: place.name)),
          item(Ph.headset, Tone.neutral, l.hpGetHelpBooking, l.getHelpSub, () => context.push('/me/help/new?booking=${b.id}')),
        ]),
      ),
      if (b.isActive && future) ...[
        const SizedBox(height: Space.md),
        Align(
          child: TextButton(
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
            child: Text(l.cancelBooking, style: TextStyle(color: paw.error)),
          ),
        ),
      ],
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
                    icon: Icon(i <= rating ? Ph.starFill : Ph.star, color: ctx.paw.accent),
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
/// Three steps of a booking as bars with labels: green up to [reached].
class _Steps extends StatelessWidget {
  const _Steps({required this.reached});
  final int reached;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final labels = [l.stepBooked, l.stepConfirmed, l.stepVisited];
    return Row(children: [
      for (var i = 0; i < labels.length; i++) ...[
        if (i > 0) const SizedBox(width: Space.xs + Space.xxs),
        Expanded(
          child: Semantics(
            label: '${labels[i]}${i < reached ? ', ${l.done}' : ''}',
            excludeSemantics: true,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(height: Space.xs, decoration: BoxDecoration(color: i < reached ? context.paw.success : context.paw.surfaceSubtle, borderRadius: BorderRadius.circular(Radii.full))),
              const SizedBox(height: Space.xs),
              Text(labels[i], style: context.text.labelSmall?.copyWith(color: i < reached ? context.paw.success : context.paw.textSecondary)),
            ]),
          ),
        ),
      ],
    ]);
  }
}

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
          height: Sizes.liveMap,
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
