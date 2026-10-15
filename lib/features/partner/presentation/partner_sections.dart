import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/auth/app_user.dart';
import '../../../core/providers.dart';
import '../../../core/services/service_providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/photo_picker.dart';
import '../../../core/widgets/widgets.dart';
import '../../booking/data/booking_repository.dart';
import '../../booking/data/places_repository.dart';
import '../../booking/domain/booking_rules.dart';
import '../../booking/presentation/book_home_screen.dart';
import '../../booking/presentation/booking_labels.dart';
import '../../admin/admin_slots.dart' show HelpListBody;
import 'partner_extra_sections.dart';

/// The clinic or provider this partner account manages. Vets resolve to
/// their clinic.
final partnerPlaceProvider = StreamProvider<Place?>((ref) async* {
  final u = ref.watch(currentUserProvider);
  if (u == null || u.partnerId == null) {
    yield null;
    return;
  }
  var id = u.partnerId!;
  if (u.role == UserRole.vet) {
    final v = await ref.watch(firestoreProvider).collection('vets').doc(id).get();
    id = (v.data()?['clinicId'] as String?) ?? id;
  }
  yield* ref.watch(placesRepositoryProvider).watchPlace(id);
});

/// Returns the body for a partner portal section, or null if that section
/// is built in a later phase.
Widget? partnerSectionBody(BuildContext context, WidgetRef ref, AppUser user, String section) {
  if (section == 'help') return const HelpListBody(embedded: true);
  if (user.role == UserRole.seller) return sellerSectionBody(context, ref, user, section);
  return switch (section) {
    'dashboard' => const _Dashboard(),
    'calendar' => const _Calendar(),
    'requests' => const _Requests(),
    'services' => const _Services(),
    'staff' => const _Staff(),
    'reviews' => const _PartnerReviews(),
    'payouts' => const _Payouts(),
    'profile' => const _Profile(),
    'emergency' => const _Emergency(),
    _ => partnerLaterSection(context, ref, user, section),
  };
}

Widget _needsPlace(WidgetRef ref, Widget Function(Place p) build) {
  final p = ref.watch(partnerPlaceProvider);
  return AsyncView<Place?>(
    value: p,
    data: (place) => place == null ? Builder(builder: (c) => EmptyState(title: c.l10n.noBusinessLinked)) : build(place),
  );
}

class _Dashboard extends ConsumerWidget {
  const _Dashboard();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final user = ref.watch(currentUserProvider)!;
    final bookings = ref.watch(partnerBookingsProvider).value ?? const <Booking>[];
    final now = DateTime.now();
    final today = bookings
        .where((b) => Fmt.sameDay(b.start, now) && (b.status == 'confirmed' || b.status == 'in_progress' || b.status == 'completed'))
        .toList();
    final requests = bookings.where((b) => b.status == 'pending').toList();
    final month = bookings.where((b) => b.status == 'completed' && b.start.month == now.month && b.start.year == now.year);
    final earnings = month.fold<int>(0, (s, b) => s + b.payout);
    return _needsPlace(
      ref,
      (place) => PageBody(
        children: [
          const SizedBox(height: Space.md),
          Text(l.helloPartner(user.name.split(' ').first), style: context.text.headlineSmall),
          Text(place.name, style: context.text.bodyMedium?.copyWith(color: context.paw.textSecondary)),
          if (place.status != 'approved') ...[const SizedBox(height: Space.md), InfoNote(l.waitingApproval, tone: ChipTone.warning)],
          const SizedBox(height: Space.lg),
          ResponsiveGrid(
            minItemWidth: 200,
            children: [
              StatTile(label: l.todaysBookings, value: '${today.length}', icon: Icons.event_available_rounded),
              StatTile(label: l.requestsWaiting, value: '${requests.length}', icon: Icons.inbox_rounded, color: requests.isEmpty ? null : context.paw.warning),
              StatTile(label: l.earningsThisMonth, value: Fmt.inr(earnings), icon: Icons.account_balance_wallet_rounded),
              StatTile(
                label: l.rating,
                value: place.reviewCount == 0 ? '–' : '★ ${place.rating.toStringAsFixed(1)}',
                icon: Icons.star_rounded,
                color: context.paw.accent,
              ),
            ],
          ),
          if (requests.isNotEmpty) ...[
            SectionHeader(l.requestsWaiting, action: l.seeAll, onAction: () => context.go('/partner/requests')),
            for (final b in requests.take(3))
              Padding(
                padding: const EdgeInsets.only(bottom: Space.sm),
                child: BookingCard(booking: b, partnerView: true),
              ),
          ],
          SectionHeader(l.todaysBookings, action: l.pCalendar, onAction: () => context.go('/partner/calendar')),
          if (today.isEmpty) PawCard(child: Text(l.noBookingsToday)),
          for (final b in today)
            Padding(
              padding: const EdgeInsets.only(bottom: Space.sm),
              child: BookingCard(booking: b, partnerView: true),
            ),
        ],
      ),
    );
  }
}

class _Calendar extends ConsumerStatefulWidget {
  const _Calendar();
  @override
  ConsumerState<_Calendar> createState() => _CalendarState();
}

class _CalendarState extends ConsumerState<_Calendar> {
  DateTime _day = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final bookings = ref.watch(partnerBookingsProvider).value ?? const <Booking>[];
    return _needsPlace(ref, (place) {
      final dayList = bookings.where((b) => Fmt.sameDay(b.start, _day) && b.status != 'declined' && b.status != 'expired').toList()
        ..sort((a, b) => a.start.compareTo(b.start));
      final slots = generateSlots(
        hours: place.hours,
        day: _day,
        slotMinutes: place.slotMinutes,
        bufferMinutes: place.bufferMinutes,
        capacity: place.capacity,
        holidays: place.holidays,
        blocks: place.blocks,
        bookedStarts: bookings.where((b) => b.isActive).map((b) => b.start).toList(),
        now: DateTime(2000),
      );
      final isHoliday = place.holidays.any((h) => Fmt.sameDay(h, _day));
      return PageBody(
        children: [
          const SizedBox(height: Space.md),
          SizedBox(
            height: 64,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (var i = -1; i < 13; i++)
                  () {
                    final d = DateTime.now().add(Duration(days: i));
                    return Padding(
                      padding: const EdgeInsets.only(right: Space.sm),
                      child: ChoiceChip(
                        showCheckmark: false,
                        label: Text(Fmt.weekdayDate(d, context.lang)),
                        selected: Fmt.sameDay(d, _day),
                        onSelected: (_) => setState(() => _day = d),
                      ),
                    );
                  }(),
              ],
            ),
          ),
          Wrap(
            spacing: Space.sm,
            runSpacing: Space.sm,
            children: [
              OutlinedButton.icon(
                icon: Icon(isHoliday ? Icons.event_available_rounded : Icons.event_busy_rounded),
                label: Text(isHoliday ? l.removeHoliday : l.markHoliday),
                onPressed: () {
                  final hs = place.holidays.where((h) => !Fmt.sameDay(h, _day)).toList();
                  if (!isHoliday) hs.add(Fmt.dayOnly(_day));
                  ref.read(placesRepositoryProvider).updatePlace(place, {'holidays': hs});
                },
              ),
              OutlinedButton.icon(
                icon: const Icon(Icons.block_rounded),
                label: Text(l.blockTime),
                onPressed: () async {
                  final t = await showTimePicker(context: context, initialTime: const TimeOfDay(hour: 13, minute: 0));
                  if (t == null) return;
                  final start = DateTime(_day.year, _day.month, _day.day, t.hour, t.minute);
                  final blocks = [
                    for (final b in place.blocks) {'start': b.start, 'end': b.end},
                    {'start': start, 'end': start.add(const Duration(hours: 1))},
                  ];
                  await ref.read(placesRepositoryProvider).updatePlace(place, {'blocks': blocks});
                  if (context.mounted) showToast(context, l.timeBlocked(Fmt.time(start, context.lang)));
                },
              ),
              OutlinedButton.icon(icon: const Icon(Icons.schedule_rounded), label: Text(l.workingHours), onPressed: () => _hours(context, place)),
            ],
          ),
          SectionHeader(l.bookingsOn(Fmt.weekdayDate(_day, context.lang))),
          if (dayList.isEmpty) PawCard(child: Text(isHoliday ? l.holidayNoBookings : l.noBookingsThisDay)),
          for (final b in dayList)
            Padding(
              padding: const EdgeInsets.only(bottom: Space.sm),
              child: BookingCard(booking: b, partnerView: true),
            ),
          SectionHeader(l.openSlots),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final s in slots)
                Chip(
                  label: Text('${Fmt.time(s.start, context.lang)} · ${s.free}/${place.capacity}'),
                  backgroundColor: s.available ? context.paw.primaryContainer : context.paw.outline,
                ),
            ],
          ),
          const SizedBox(height: Space.sm),
          Text(l.slotSettings(place.slotMinutes, place.bufferMinutes, place.capacity), style: context.text.bodySmall),
        ],
      );
    });
  }

  Future<void> _hours(BuildContext context, Place place) async {
    final l = context.l10n;
    var slot = place.slotMinutes;
    var buffer = place.bufferMinutes;
    var cap = place.capacity;
    final open = hoursOn(place.hours, DateTime.now());
    var from = open == null ? const TimeOfDay(hour: 9, minute: 0) : TimeOfDay.fromDateTime(open.open);
    var to = open == null ? const TimeOfDay(hour: 20, minute: 0) : TimeOfDay.fromDateTime(open.close);
    final ok = await showPawSheet<bool>(
      context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, set) {
          String t(TimeOfDay x) => Fmt.time(DateTime(2000, 1, 1, x.hour, x.minute), ctx.lang);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l.workingHours, style: ctx.text.titleMedium),
              const SizedBox(height: Space.md),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final x = await showTimePicker(context: ctx, initialTime: from);
                        if (x != null) set(() => from = x);
                      },
                      child: Text('${l.opens} ${t(from)}'),
                    ),
                  ),
                  const SizedBox(width: Space.sm),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final x = await showTimePicker(context: ctx, initialTime: to);
                        if (x != null) set(() => to = x);
                      },
                      child: Text('${l.closes} ${t(to)}'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Space.md),
              Text('${l.slotLength}: $slot min'),
              Slider(value: slot.toDouble(), min: 10, max: 120, divisions: 22, label: '$slot', onChanged: (v) => set(() => slot = v.round())),
              Text('${l.bufferTime}: $buffer min'),
              Slider(value: buffer.toDouble(), min: 0, max: 30, divisions: 6, label: '$buffer', onChanged: (v) => set(() => buffer = v.round())),
              Text('${l.capacityPerSlot}: $cap'),
              Slider(value: cap.toDouble(), min: 1, max: 6, divisions: 5, label: '$cap', onChanged: (v) => set(() => cap = v.round())),
              InfoNote(l.hoursAppliesMonSat),
              const SizedBox(height: Space.md),
              PrimaryButton(label: l.save, onPressed: () => Navigator.pop(ctx, true)),
            ],
          );
        },
      ),
    );
    if (ok != true) return;
    String f(TimeOfDay x) => '${x.hour.toString().padLeft(2, '0')}:${x.minute.toString().padLeft(2, '0')}';
    final hours = Map<String, dynamic>.from(place.hours);
    for (final d in weekdayKeys.take(6)) {
      hours[d] = [f(from), f(to)];
    }
    await ref.read(placesRepositoryProvider).updatePlace(place, {'hours': hours, 'slotMinutes': slot, 'bufferMinutes': buffer, 'capacityPerSlot': cap});
  }
}

class _Requests extends ConsumerWidget {
  const _Requests();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final all = ref.watch(partnerBookingsProvider).value ?? const <Booking>[];
    final pending = all.where((b) => b.status == 'pending').toList();
    final waiting = all.where((b) => b.status == 'suggested').toList();
    if (pending.isEmpty && waiting.isEmpty) return EmptyState(title: l.noRequestsPartner, scene: Scene.empty);
    return PageBody(
      maxWidth: 800,
      children: [
        const SizedBox(height: Space.md),
        for (final b in pending)
          Padding(
            padding: const EdgeInsets.only(bottom: Space.md),
            child: RequestCard(booking: b),
          ),
        if (waiting.isNotEmpty) ...[
          SectionHeader(l.waitingForOwner),
          for (final b in waiting)
            Padding(
              padding: const EdgeInsets.only(bottom: Space.sm),
              child: BookingCard(booking: b, partnerView: true),
            ),
        ],
      ],
    );
  }
}

class RequestCard extends ConsumerWidget {
  const RequestCard({super.key, required this.booking});
  final Booking booking;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final b = booking;
    final repo = ref.read(bookingRepositoryProvider);
    return PawCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('${b.petName} · ${b.ownerName}', style: context.text.titleMedium),
          Text('${serviceLabel(context, b.serviceId)} · ${Fmt.inr(b.total)}', style: context.text.bodySmall),
          if (b.notes?.isNotEmpty == true) Padding(padding: const EdgeInsets.only(top: 4), child: Text('"${b.notes}"')),
          if (b.respondBy != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(l.replyBefore(Fmt.time(b.respondBy!, context.lang)), style: context.text.bodySmall?.copyWith(color: context.paw.warning)),
            ),
          const SizedBox(height: Space.sm),
          Text(l.chooseTimeToAccept, style: context.text.titleSmall),
          Wrap(
            spacing: Space.sm,
            runSpacing: Space.sm,
            children: [
              for (final t in b.proposedTimes)
                ActionChip(
                  avatar: Icon(Icons.check_circle_rounded, color: context.paw.success, size: 18),
                  label: Text(Fmt.dateTime(t, context.lang)),
                  onPressed: () async {
                    await repo.accept(b, t);
                    if (context.mounted) showToast(context, l.requestAccepted(b.petName));
                  },
                ),
            ],
          ),
          const SizedBox(height: Space.sm),
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  label: l.suggestTime,
                  icon: Icons.schedule_send_rounded,
                  onPressed: () async {
                    final d = await showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 30)),
                      initialDate: b.start,
                    );
                    if (d == null || !context.mounted) return;
                    final t = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(b.start));
                    if (t == null) return;
                    await repo.suggest(b, DateTime(d.year, d.month, d.day, t.hour, t.minute));
                    if (context.mounted) showToast(context, l.suggestionSent);
                  },
                ),
              ),
              const SizedBox(width: Space.sm),
              Expanded(
                child: SecondaryButton(
                  label: l.decline,
                  icon: Icons.close_rounded,
                  onPressed: () async {
                    final ok = await confirmAction(context, title: l.declineRequestQ(b.petName), confirmLabel: l.decline);
                    if (ok) await repo.decline(b);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Services extends ConsumerWidget {
  const _Services();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return _needsPlace(
      ref,
      (place) => PageBody(
        maxWidth: 800,
        children: [
          const SizedBox(height: Space.md),
          InfoNote(l.servicesHelp),
          const SizedBox(height: Space.md),
          for (final s in place.services)
            Padding(
              padding: const EdgeInsets.only(bottom: Space.sm),
              child: PawCard(
                onTap: () => _edit(context, ref, place, s),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(serviceLabel(context, s.id), style: context.text.titleSmall),
                          Text(
                            '${l.minutesShort(s.durationMin)} · ${s.mode == 'instant' ? l.instantBooking : l.requestBooking} · ${s.payments.map((x) => x == 'online' ? l.payOnline : l.payAtCentre).join(' / ')}',
                            style: context.text.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Text(Fmt.inr(s.price), style: context.text.titleMedium),
                    const Icon(Icons.edit_rounded),
                  ],
                ),
              ),
            ),
          if (place.packages.isNotEmpty) ...[
            SectionHeader(l.packages),
            for (final p in place.packages)
              PawCard(
                child: Row(
                  children: [
                    Expanded(child: Text(p['name'] as String)),
                    Text(Fmt.inr(p['price'] as num)),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }

  Future<void> _edit(BuildContext context, WidgetRef ref, Place place, PlaceService s) async {
    final l = context.l10n;
    final price = TextEditingController(text: '${s.price}');
    var mode = s.mode;
    final pays = {...s.payments};
    final ok = await showPawSheet<bool>(
      context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, set) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(serviceLabel(ctx, s.id), style: ctx.text.titleMedium),
            const SizedBox(height: Space.md),
            PawTextField(label: l.priceRupees, controller: price, keyboardType: TextInputType.number),
            Text(l.bookingMode, style: ctx.text.titleSmall),
            SegmentedButton<String>(
              segments: [
                ButtonSegment(value: 'instant', label: Text(l.instantBooking)),
                ButtonSegment(value: 'request', label: Text(l.requestBooking)),
              ],
              selected: {mode},
              onSelectionChanged: (x) => set(() => mode = x.first),
            ),
            const SizedBox(height: Space.md),
            Text(l.paymentOptions, style: ctx.text.titleSmall),
            CheckboxListTile(
              value: pays.contains('online'),
              onChanged: (v) => set(() => v! ? pays.add('online') : pays.remove('online')),
              title: Text(l.payOnline),
            ),
            CheckboxListTile(
              value: pays.contains('at_clinic'),
              onChanged: (v) => set(() => v! ? pays.add('at_clinic') : pays.remove('at_clinic')),
              title: Text(l.payAtCentre),
            ),
            const SizedBox(height: Space.md),
            PrimaryButton(label: l.save, onPressed: pays.isEmpty ? null : () => Navigator.pop(ctx, true)),
          ],
        ),
      ),
    );
    if (ok != true) return;
    final services = [
      for (final x in place.services) x.id == s.id ? {...x.raw, 'price': int.tryParse(price.text) ?? s.price, 'mode': mode, 'payments': pays.toList()} : x.raw,
    ];
    await ref.read(placesRepositoryProvider).updatePlace(place, {'services': services});
  }
}

class _Staff extends ConsumerWidget {
  const _Staff();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return _needsPlace(ref, (place) {
      final vets = ref.watch(vetsProvider(place.id)).value ?? const <Vet>[];
      return PageBody(
        maxWidth: 800,
        children: [
          const SizedBox(height: Space.md),
          for (final v in vets)
            ListTile(
              leading: CircleAvatar(
                backgroundColor: context.paw.primaryContainer,
                child: Icon(Icons.medical_services_rounded, color: context.colors.primary),
              ),
              title: Text(v.name),
              subtitle: Text('${v.qualification}\n${l.regNo(v.regNo)}'),
              isThreeLine: true,
              trailing: StatusChip(v.teleVet ? l.teleVet : l.inClinic),
            ),
          const SizedBox(height: Space.md),
          SecondaryButton(
            label: l.addVet,
            icon: Icons.person_add_rounded,
            onPressed: () async {
              final name = TextEditingController();
              final reg = TextEditingController();
              final ok = await showPawSheet<bool>(
                context,
                builder: (ctx) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(l.addVet, style: ctx.text.titleMedium),
                    const SizedBox(height: Space.md),
                    PawTextField(label: l.vetName, controller: name),
                    PawTextField(label: l.vcRegNumber, controller: reg, helper: l.vcRegHelp),
                    PrimaryButton(label: l.save, onPressed: () => Navigator.pop(ctx, true)),
                  ],
                ),
              );
              if (ok == true && name.text.trim().isNotEmpty) {
                await ref.read(firestoreProvider).collection('vets').add({
                  'clinicId': place.id,
                  'clinicName': place.name,
                  'name': name.text.trim(),
                  'regNo': reg.text.trim(),
                  'qualification': 'BVSc & AH',
                  'experienceYears': 1,
                  'languages': place.languages,
                  'species': place.species,
                  'teleVet': false,
                  'status': 'pending',
                });
                if (context.mounted) showToast(context, l.vetAddedPending);
              }
            },
          ),
        ],
      );
    });
  }
}

class _PartnerReviews extends ConsumerWidget {
  const _PartnerReviews();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return _needsPlace(ref, (place) {
      final reviews = ref.watch(reviewsProvider(place.id)).value ?? const <Review>[];
      if (reviews.isEmpty) return EmptyState(title: l.noReviewsYet);
      return PageBody(
        maxWidth: 800,
        children: [
          const SizedBox(height: Space.md),
          for (final r in reviews)
            Padding(
              padding: const EdgeInsets.only(bottom: Space.sm),
              child: PawCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Wrap(
                      spacing: Space.sm,
                      runSpacing: 2,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text('★' * r.rating, style: TextStyle(color: context.paw.accent)),
                        Text(r.ownerName),
                        Text(Fmt.date(r.createdAt, context.lang), style: context.text.bodySmall),
                      ],
                    ),
                    if (r.text.isNotEmpty) Text(r.text),
                    if (r.reply != null) Text('${l.yourReply}: ${r.reply}', style: context.text.bodySmall),
                    if (r.reply == null)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          icon: const Icon(Icons.reply_rounded),
                          label: Text(l.reply),
                          onPressed: () async {
                            final c = TextEditingController();
                            final ok = await showPawSheet<bool>(
                              context,
                              builder: (ctx) => Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  PawTextField(label: l.yourReply, controller: c, maxLines: 3, autofocus: true),
                                  PrimaryButton(label: l.postReply, onPressed: () => Navigator.pop(ctx, true)),
                                ],
                              ),
                            );
                            if (ok == true && c.text.trim().isNotEmpty) await ref.read(placesRepositoryProvider).replyToReview(r.id, c.text.trim());
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
        ],
      );
    });
  }
}

class _Payouts extends ConsumerWidget {
  const _Payouts();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final done = (ref.watch(partnerBookingsProvider).value ?? const <Booking>[]).where((b) => b.status == 'completed').toList()
      ..sort((a, b) => b.start.compareTo(a.start));
    final total = done.fold<int>(0, (s, b) => s + b.payout);
    final commission = done.fold<int>(0, (s, b) => s + b.commission);
    return PageBody(
      maxWidth: 900,
      children: [
        const SizedBox(height: Space.md),
        DemoBanner(l.demoPayoutsNote),
        const SizedBox(height: Space.md),
        ResponsiveGrid(
          minItemWidth: 220,
          children: [
            StatTile(label: l.totalPayouts, value: Fmt.inr(total), icon: Icons.account_balance_rounded),
            StatTile(label: l.platformCommission, value: Fmt.inr(commission), icon: Icons.percent_rounded),
            StatTile(label: l.completedBookings, value: '${done.length}', icon: Icons.task_alt_rounded),
          ],
        ),
        SectionHeader(l.payoutHistory),
        PawCard(
          padding: const EdgeInsets.symmetric(vertical: Space.xs),
          child: Column(
            children: [
              if (done.isEmpty) Padding(padding: const EdgeInsets.all(Space.md), child: Text(l.noPayoutsYet)),
              for (final b in done)
                ListTile(
                  title: Text('${b.petName} · ${serviceLabel(context, b.serviceId)}'),
                  subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('${Fmt.date(b.start, context.lang)} · ${l.commissionLine(Fmt.inr(b.commission))}'),
                    const SizedBox(height: 4),
                    StatusChip(
                      b.start.isBefore(DateTime.now().subtract(const Duration(days: 3))) ? l.settled : l.payoutPending,
                      tone: b.start.isBefore(DateTime.now().subtract(const Duration(days: 3))) ? ChipTone.success : ChipTone.warning,
                    ),
                  ]),
                  trailing: Text(Fmt.inr(b.payout), style: context.text.titleSmall),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Profile extends ConsumerWidget {
  const _Profile();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return _needsPlace(
      ref,
      (place) => PageBody(
        maxWidth: 800,
        children: [
          const SizedBox(height: Space.md),
          PawCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(place.name, style: context.text.titleLarge),
                Text(place.address, style: context.text.bodySmall),
                Text(place.phone, style: context.text.bodySmall),
                const SizedBox(height: Space.sm),
                StatusChip(
                  place.status == 'approved' ? l.statusApproved : (place.status == 'pending' ? l.statusPendingApproval : place.status),
                  tone: place.status == 'approved' ? ChipTone.success : ChipTone.warning,
                ),
              ],
            ),
          ),
          SectionHeader(l.kycDocuments),
          PawCard(
            padding: const EdgeInsets.symmetric(vertical: Space.xs),
            child: Column(
              children: [
                for (final d in ((place.raw['kycDocs'] as List?) ?? const []).cast<String>())
                  ListTile(
                    leading: const Icon(Icons.description_rounded),
                    title: Text(d),
                    trailing: Icon(Icons.verified_rounded, color: context.paw.success),
                  ),
              ],
            ),
          ),
          const SizedBox(height: Space.sm),
          SecondaryButton(
            label: l.uploadKyc,
            icon: Icons.upload_file_rounded,
            onPressed: () async {
              final pick = await pickImage(context, ImageSource.gallery);
              if (pick == null) return;
              final uid = ref.read(currentUserProvider)!.uid;
              await ref.read(storageServiceProvider).upload(pick.bytes, path: 'users/$uid/kyc/${pick.name}', contentType: 'image/jpeg');
              final docs = [...((place.raw['kycDocs'] as List?) ?? const []).cast<String>(), pick.name];
              await ref.read(placesRepositoryProvider).updatePlace(place, {'kycDocs': docs});
              if (context.mounted) showToast(context, l.kycUploaded);
            },
          ),
          const SizedBox(height: Space.lg),
          SwitchListTile(
            value: place.enquiriesEnabled,
            onChanged: (v) => ref.read(placesRepositoryProvider).updatePlace(place, {'enquiriesEnabled': v}),
            title: Text(l.allowEnquiries),
            subtitle: Text(l.allowEnquiriesHint),
          ),
        ],
      ),
    );
  }
}

class _Emergency extends ConsumerWidget {
  const _Emergency();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return _needsPlace(ref, (place) {
      final phone = TextEditingController(text: place.emergencyPhone ?? '');
      return PageBody(
        maxWidth: 720,
        children: [
          const SizedBox(height: Space.md),
          InfoNote(l.emergencySettingsHelp),
          SwitchListTile(
            value: place.is24x7,
            onChanged: (v) => ref.read(placesRepositoryProvider).updatePlace(place, {
              'is24x7': v,
              if (v)
                'hours': {
                  for (final d in weekdayKeys) d: ['00:00', '24:00'],
                },
            }),
            title: Text(l.open24x7Long),
          ),
          PawTextField(label: l.emergencyPhone, controller: phone, keyboardType: TextInputType.phone),
          PrimaryButton(
            label: l.save,
            onPressed: () async {
              await ref.read(placesRepositoryProvider).updatePlace(place, {'emergencyPhone': phone.text.trim()});
              if (context.mounted) showToast(context, l.saved);
            },
          ),
        ],
      );
    });
  }
}

/// Partner actions on a booking (shown on the partner booking page).
class PartnerBookingActions extends ConsumerWidget {
  const PartnerBookingActions({super.key, required this.booking});
  final Booking booking;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final b = booking;
    final repo = ref.read(bookingRepositoryProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (b.status == 'pending') RequestCard(booking: b),
        if (b.status == 'confirmed') ...[
          PrimaryButton(
            label: b.kind == 'walker' || b.kind == 'boarder' ? l.startService : l.markCompleted,
            onPressed: () => repo.setStatus(b, b.kind == 'walker' || b.kind == 'boarder' ? 'in_progress' : 'completed'),
          ),
          const SizedBox(height: Space.sm),
        ],
        if (b.status == 'in_progress') ...[
          PrimaryButton(label: l.markCompleted, onPressed: () => repo.setStatus(b, 'completed')),
          const SizedBox(height: Space.sm),
        ],
        if ((b.status == 'in_progress' || b.status == 'confirmed') && (b.kind == 'walker' || b.kind == 'boarder' || b.kind == 'groomer'))
          SecondaryButton(
            label: l.sendPhotoUpdate,
            icon: Icons.add_a_photo_rounded,
            onPressed: () async {
              final text = TextEditingController(text: l.defaultUpdateText(b.petName));
              final pick = await pickImage(context, ImageSource.gallery);
              String? url;
              if (pick != null) {
                url = await ref
                    .read(storageServiceProvider)
                    .upload(pick.bytes, path: 'users/${ref.read(currentUserProvider)!.uid}/updates/${pick.name}', contentType: 'image/jpeg');
              }
              await repo.addUpdate(b, text.text, url ?? 'seed:album:${b.petSpecies}:${DateTime.now().second}');
              if (context.mounted) showToast(context, l.updateSent(b.ownerName.split(' ').first));
            },
          ),
        if (b.isActive && b.status != 'pending')
          TextButton(
            onPressed: () async {
              final ok = await confirmAction(context, title: l.cancelBookingQ, body: l.partnerCancelNote, confirmLabel: l.cancelBooking);
              if (ok) await repo.cancel(b, cancellationHours: 0, byOwner: false);
            },
            child: Text(l.cancelBooking, style: TextStyle(color: context.paw.error)),
          ),
        TextButton(onPressed: () => context.push('/messages/new?booking=${b.id}'), child: Text(l.messageOwner)),
      ],
    );
  }
}
