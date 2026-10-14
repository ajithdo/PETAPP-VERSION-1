import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/providers.dart';
import '../../../core/services/payment_service.dart';
import '../../../core/services/service_providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/photo_picker.dart';
import '../../../core/widgets/widgets.dart';
import '../../pets/data/pets_repository.dart';
import '../../pets/domain/pet.dart';
import '../data/booking_repository.dart';
import '../data/places_repository.dart';
import '../domain/booking_rules.dart';
import 'booking_labels.dart';

/// Booking in at most 4 screens (spec 7.6): pet and service → date and
/// slot → notes, photos and payment → confirm with the full price.
class BookingFlowScreen extends ConsumerStatefulWidget {
  const BookingFlowScreen({super.key, required this.placeId, this.serviceId, this.petId});
  final String placeId;
  final String? serviceId;
  final String? petId;
  @override
  ConsumerState<BookingFlowScreen> createState() => _BookingFlowScreenState();
}

class _BookingFlowScreenState extends ConsumerState<BookingFlowScreen> {
  int _step = 0;
  String? _petId;
  String? _serviceId;
  String? _vetId;
  bool _homeVisit = false;
  DateTime _day = DateTime.now();
  DateTime? _slot;
  final Set<DateTime> _proposed = {};
  final _notes = TextEditingController();
  final _photos = <String>[];
  String _payment = 'online';
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _petId = widget.petId;
    _serviceId = widget.serviceId;
  }

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final place = ref.watch(placeProvider(widget.placeId)).value;
    if (place == null) return const Scaffold(body: SkeletonList());
    final user = ref.watch(currentUserProvider)!;
    final pets = ref.watch(activePetsProvider).where((p) => p.canCare(user.uid) && (place.species.isEmpty || place.species.contains(p.species))).toList();
    _petId ??= pets.where((p) => p.id == ref.read(selectedPetProvider)?.id).firstOrNull?.id ?? pets.firstOrNull?.id;
    _serviceId ??= place.services.firstOrNull?.id;
    final service = _serviceId == null ? null : place.service(_serviceId!);
    final pet = pets.where((p) => p.id == _petId).firstOrNull;
    if (service != null && !service.payments.contains(_payment)) _payment = service.payments.first;
    final titles = [l.stepWhoWhat, l.stepWhen, l.stepDetails, l.stepConfirm];

    return PopScope(
      canPop: _step == 0,
      onPopInvokedWithResult: (did, _) {
        if (!did) setState(() => _step--);
      },
      child: Scaffold(
        appBar: AppBar(title: Text(place.name, overflow: TextOverflow.ellipsis)),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.gutter),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Semantics(
                      label: l.stepOf(_step + 1, 4),
                      child: LinearProgressIndicator(value: (_step + 1) / 4, minHeight: 6, borderRadius: BorderRadius.circular(3)),
                    ),
                    const SizedBox(height: Space.sm),
                    Text('${l.stepOf(_step + 1, 4)} · ${titles[_step]}', style: context.text.titleMedium),
                  ],
                ),
              ),
              Expanded(
                child: pets.isEmpty
                    ? EmptyState(title: l.noPetForPlace, actionLabel: l.addPet, onAction: () => context.push('/pets/new'))
                    : PageBody(
                        maxWidth: 720,
                        children: [
                          const SizedBox(height: Space.md),
                          if (_step == 0) ..._whoWhat(context, place, pets, service),
                          if (_step == 1 && service != null) ..._when(context, place, service),
                          if (_step == 2 && service != null) ..._details(context, place, service),
                          if (_step == 3 && service != null && pet != null) ..._confirm(context, place, service, pet),
                        ],
                      ),
              ),
              if (pets.isNotEmpty)
                Padding(
                  padding: EdgeInsets.all(context.gutter),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: Row(
                      children: [
                        if (_step > 0) ...[
                          Expanded(
                            child: SecondaryButton(label: l.back, onPressed: () => setState(() => _step--)),
                          ),
                          const SizedBox(width: Space.md),
                        ],
                        Expanded(
                          flex: 2,
                          child: PrimaryButton(
                            label: _step == 3 ? (service?.mode == 'request' ? l.sendRequest : l.confirmBooking) : l.next,
                            loading: _busy,
                            onPressed: _canNext(service) ? () => _next(place, service!, pet!) : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  bool _canNext(PlaceService? s) {
    if (s == null || _petId == null) return false;
    if (_step == 1) return s.mode == 'instant' ? _slot != null : _proposed.isNotEmpty;
    return true;
  }

  Future<void> _next(Place place, PlaceService s, Pet pet) async {
    if (_step < 3) {
      setState(() => _step++);
      return;
    }
    final l = context.l10n;
    final user = ref.read(currentUserProvider)!;
    final cfg = ref.read(appSettingsDocProvider).value ?? const {};
    final pct = ((cfg['commission'] as Map?)?['bookingPercent'] as num?) ?? 10;
    final price = priceBooking(servicePrice: s.price, homeVisit: _homeVisit, travelFee: place.homeVisitFee, commissionPercent: pct);
    var paid = false;
    if (_payment == 'online') {
      final outcome = await ref.read(paymentServiceProvider).pay(context, amount: price.total, description: '${serviceLabel(context, s.id)} · ${place.name}');
      if (!mounted) return;
      if (outcome == PaymentOutcome.failure) {
        showToast(context, l.paymentFailed);
        return;
      }
      if (outcome == PaymentOutcome.cancelled) return;
      if (outcome == PaymentOutcome.pending) {
        showToast(context, l.paymentPendingNote);
      }
      paid = outcome == PaymentOutcome.success;
    }
    setState(() => _busy = true);
    final vets = place.kind == 'clinic' ? (ref.read(vetsProvider(place.id)).value ?? const <Vet>[]) : const <Vet>[];
    final vet = vets.where((v) => v.id == _vetId).firstOrNull;
    final start = s.mode == 'instant' ? _slot! : (_proposed.toList()..sort()).first;
    final id = await ref
        .read(bookingRepositoryProvider)
        .create(
          owner: user,
          pet: pet,
          place: place,
          service: s,
          serviceName: serviceLabel(context, s.id),
          vetId: vet?.id,
          vetName: vet?.name,
          start: start,
          proposedTimes: (_proposed.toList()..sort()),
          paymentOption: _payment,
          paidOnline: paid,
          homeVisit: _homeVisit,
          notes: _notes.text.trim(),
          photos: _photos,
          commissionPercent: pct,
        );
    if (mounted) context.pushReplacement('/book/done/$id');
  }

  List<Widget> _whoWhat(BuildContext context, Place place, List<Pet> pets, PlaceService? service) {
    final l = context.l10n;
    final vets = place.kind == 'clinic' ? (ref.watch(vetsProvider(place.id)).value ?? const <Vet>[]) : const <Vet>[];
    return [
      Text(l.whichPet, style: context.text.titleSmall),
      const SizedBox(height: Space.sm),
      Wrap(
        spacing: Space.sm,
        runSpacing: Space.sm,
        children: [
          for (final p in pets)
            ChoiceChip(
              avatar: PetAvatar(species: p.species, colorTag: p.colorTag, photoUrl: p.photoUrl, size: 28),
              label: Text(p.name),
              selected: _petId == p.id,
              showCheckmark: false,
              onSelected: (_) => setState(() => _petId = p.id),
            ),
        ],
      ),
      const SizedBox(height: Space.lg),
      Text(l.whichService, style: context.text.titleSmall),
      RadioGroup<String>(
        groupValue: _serviceId,
        onChanged: (v) => setState(() {
          _serviceId = v;
          _slot = null;
          _proposed.clear();
        }),
        child: Column(
          children: [
            for (final s in place.services)
              RadioListTile<String>(
                value: s.id,
                title: Text(serviceLabel(context, s.id)),
                subtitle: Text('${l.minutesShort(s.durationMin)} · ${s.mode == 'instant' ? l.instantBooking : l.requestBooking}'),
                secondary: Text(Fmt.inr(s.price), style: context.text.titleSmall),
              ),
          ],
        ),
      ),
      if (vets.isNotEmpty) ...[
        const SizedBox(height: Space.md),
        DropdownButtonFormField<String?>(
          initialValue: _vetId,
          isExpanded: true,
          decoration: InputDecoration(labelText: l.chooseVet),
          items: [
            DropdownMenuItem<String?>(value: null, child: Text(l.anyVet)),
            for (final v in vets)
              DropdownMenuItem(
                value: v.id,
                child: Text('${v.name} · ${v.regNo}', overflow: TextOverflow.ellipsis),
              ),
          ],
          onChanged: (v) => setState(() => _vetId = v),
        ),
      ],
      if (place.homeVisit) ...[
        const SizedBox(height: Space.md),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: _homeVisit,
          onChanged: (v) => setState(() => _homeVisit = v),
          title: Text(l.homeVisit),
          subtitle: Text(l.homeVisitHint(place.radiusKm, Fmt.inr(place.homeVisitFee))),
        ),
      ],
    ];
  }

  List<Widget> _when(BuildContext context, Place place, PlaceService s) {
    final l = context.l10n;
    final now = DateTime.now();
    final booked = (ref.watch(providerBookingsProvider(place.id)).value ?? const <Booking>[]).where((b) => b.isActive).map((b) => b.start).toList();
    final slots = generateSlots(
      hours: place.hours,
      day: _day,
      slotMinutes: s.durationMin >= 600 ? s.durationMin : place.slotMinutes,
      serviceMinutes: s.durationMin,
      bufferMinutes: place.bufferMinutes,
      capacity: place.capacity,
      holidays: place.holidays,
      blocks: place.blocks,
      bookedStarts: booked,
      now: now,
    );
    final request = s.mode == 'request';
    return [
      if (request) ...[InfoNote(l.requestExplainer(place.requestWindowHours)), const SizedBox(height: Space.md)],
      SizedBox(
        height: 76,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            for (var i = 0; i < 14; i++)
              () {
                final d = DateTime(now.year, now.month, now.day + i);
                final sel = Fmt.sameDay(d, _day);
                return Padding(
                  padding: const EdgeInsets.only(right: Space.sm),
                  child: ChoiceChip(
                    showCheckmark: false,
                    selected: sel,
                    label: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(i == 0 ? l.today : Fmt.weekdayDate(d, context.lang).split(',').first),
                        Text(Fmt.dateShort(d, context.lang), style: context.text.labelSmall),
                      ],
                    ),
                    onSelected: (_) => setState(() {
                      _day = d;
                      _slot = null;
                    }),
                  ),
                );
              }(),
          ],
        ),
      ),
      const SizedBox(height: Space.md),
      if (slots.isEmpty)
        PawCard(child: Text(l.noSlotsThatDay))
      else
        Wrap(
          spacing: Space.sm,
          runSpacing: Space.sm,
          children: [
            for (final slot in slots)
              ChoiceChip(
                label: Text(Fmt.time(slot.start, context.lang)),
                selected: request ? _proposed.contains(slot.start) : _slot == slot.start,
                onSelected: !slot.available
                    ? null
                    : (_) => setState(() {
                        if (request) {
                          if (_proposed.contains(slot.start)) {
                            _proposed.remove(slot.start);
                          } else if (_proposed.length < 3) {
                            _proposed.add(slot.start);
                          }
                        } else {
                          _slot = slot.start;
                        }
                      }),
              ),
          ],
        ),
      if (request && _proposed.isNotEmpty) ...[
        const SizedBox(height: Space.md),
        Text(l.yourPreferredTimes, style: context.text.titleSmall),
        for (final t in (_proposed.toList()..sort())) Text('• ${Fmt.dateTime(t, context.lang)}'),
      ],
    ];
  }

  List<Widget> _details(BuildContext context, Place place, PlaceService s) {
    final l = context.l10n;
    return [
      PawTextField(
        label: place.kind == 'clinic' ? l.symptomsNotes : l.notesForProvider,
        controller: _notes,
        maxLines: 4,
        hint: place.kind == 'clinic' ? l.symptomsHint : null,
      ),
      Wrap(
        spacing: Space.sm,
        runSpacing: Space.sm,
        children: [
          for (final p in _photos)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: MediaImage(url: p, width: 64, height: 64),
            ),
          ActionChip(
            avatar: const Icon(Icons.add_a_photo_rounded, size: 18),
            label: Text(l.addPhoto),
            onPressed: () async {
              final pick = await pickImage(context, ImageSource.gallery);
              if (pick == null) return;
              final uid = ref.read(currentUserProvider)!.uid;
              final url = await ref
                  .read(storageServiceProvider)
                  .upload(pick.bytes, path: 'users/$uid/bookings/${DateTime.now().millisecondsSinceEpoch}.jpg', contentType: 'image/jpeg');
              setState(() => _photos.add(url));
            },
          ),
        ],
      ),
      const SizedBox(height: Space.lg),
      Text(l.howToPay, style: context.text.titleSmall),
      RadioGroup<String>(
        groupValue: _payment,
        onChanged: (v) => setState(() => _payment = v!),
        child: Column(
          children: [
            if (s.payments.contains('online')) RadioListTile<String>(value: 'online', title: Text(l.payOnline), subtitle: Text(l.payOnlineHint)),
            if (s.payments.contains('at_clinic'))
              RadioListTile<String>(value: 'at_clinic', title: Text(place.kind == 'clinic' ? l.payAtClinic : l.payAtCentre), subtitle: Text(l.payLaterHint)),
          ],
        ),
      ),
    ];
  }

  List<Widget> _confirm(BuildContext context, Place place, PlaceService s, Pet pet) {
    final l = context.l10n;
    final cfg = ref.watch(appSettingsDocProvider).value ?? const {};
    final pct = ((cfg['commission'] as Map?)?['bookingPercent'] as num?) ?? 10;
    final p = priceBooking(servicePrice: s.price, homeVisit: _homeVisit, travelFee: place.homeVisitFee, commissionPercent: pct);
    Widget row(String k, String v, {bool bold = false}) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(k, style: bold ? context.text.titleSmall : context.text.bodyMedium)),
          Text(v, style: bold ? context.text.titleMedium : context.text.bodyMedium),
        ],
      ),
    );
    final when = s.mode == 'instant' ? Fmt.dateTime(_slot!, context.lang) : (_proposed.toList()..sort()).map((t) => Fmt.dateTime(t, context.lang)).join('\n');
    return [
      PawCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                PetAvatar(species: pet.species, colorTag: pet.colorTag, photoUrl: pet.photoUrl, size: 44),
                const SizedBox(width: Space.md),
                Expanded(child: Text('${pet.name} · ${serviceLabel(context, s.id)}', style: context.text.titleSmall)),
              ],
            ),
            const Divider(height: Space.xl),
            row(l.where, place.name),
            row(s.mode == 'instant' ? l.when : l.preferredTimes, when),
            row(l.payment, _payment == 'online' ? l.payOnline : (place.kind == 'clinic' ? l.payAtClinic : l.payAtCentre)),
            if (_homeVisit) row(l.homeVisit, l.yes),
          ],
        ),
      ),
      const SizedBox(height: Space.md),
      PawCard(
        child: Column(
          children: [
            row(serviceLabel(context, s.id), Fmt.inr(p.service)),
            if (p.travelFee > 0) row(l.travelFee, Fmt.inr(p.travelFee)),
            row(l.platformFee, p.platformFee == 0 ? l.free : Fmt.inr(p.platformFee)),
            const Divider(),
            row(l.totalToPay, Fmt.inr(p.total), bold: true),
          ],
        ),
      ),
      const SizedBox(height: Space.md),
      InfoNote(l.cancellationPolicy(place.cancellationHours)),
      if (ref.watch(appConfigProvider).isDemo) ...[const SizedBox(height: Space.sm), DemoBanner(l.demoBookingNote)],
    ];
  }
}

/// Booking done: confirmed or request sent, with add-to-calendar.
class BookingDoneScreen extends ConsumerWidget {
  const BookingDoneScreen({super.key, required this.bookingId});
  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final b = ref.watch(bookingProvider(bookingId)).value;
    if (b == null) return const Scaffold(body: SkeletonList());
    final request = b.status == 'pending';
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: EdgeInsets.all(context.gutter),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Illustration(Scene.success, size: 180),
                  const SizedBox(height: Space.lg),
                  Text(request ? l.requestSentTitle : l.bookingConfirmedTitle, style: context.text.headlineSmall, textAlign: TextAlign.center),
                  const SizedBox(height: Space.sm),
                  Text(
                    request ? l.requestSentBody(b.providerName) : l.bookingConfirmedBody(b.petName, b.providerName, Fmt.dateTime(b.start, context.lang)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: Space.xl),
                  PrimaryButton(label: l.viewBooking, onPressed: () => context.pushReplacement('/book/bookings/${b.id}')),
                  const SizedBox(height: Space.sm),
                  SecondaryButton(label: l.backToBook, onPressed: () => context.go('/book')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
