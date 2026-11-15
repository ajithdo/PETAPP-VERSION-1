import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../pets/data/pets_repository.dart';
import '../data/booking_repository.dart';
import '../data/places_repository.dart';
import '../domain/booking_rules.dart';
import 'booking_labels.dart';
import 'booking_slots.dart';
import '../../../core/theme/ph.dart';

/// UI Design 2 booking card on the clinic page (owner's choice, 4 Nov 2026):
/// pick the pet, the visit reason, the day and the time, see the price, then
/// continue to one short screen for notes, photos and payment.
class BookingPanel extends ConsumerStatefulWidget {
  const BookingPanel({super.key, required this.place});
  final Place place;

  @override
  ConsumerState<BookingPanel> createState() => BookingPanelState();
}

class BookingPanelState extends ConsumerState<BookingPanel> {
  String? _petId;
  String? _serviceId;
  DateTime _day = DateTime.now();
  DateTime? _slot;
  final Set<DateTime> _proposed = {};

  /// Chooses [serviceId] (from the services list on the page) and scrolls the
  /// card into view.
  void selectService(String serviceId) {
    setState(() {
      _serviceId = serviceId;
      _slot = null;
      _proposed.clear();
    });
    Scrollable.ensureVisible(context, duration: Motion.enter, curve: Motion.standard);
  }

  /// Scrolls the card into view (the "Book now" link on phones).
  void reveal() => Scrollable.ensureVisible(context, duration: Motion.enter, curve: Motion.standard);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final paw = context.paw;
    final place = widget.place;
    final user = ref.watch(currentUserProvider);
    final pets = ref
        .watch(activePetsProvider)
        .where((p) => user != null && p.canCare(user.uid) && (place.species.isEmpty || place.species.contains(p.species)))
        .toList();
    if (pets.isEmpty || place.services.isEmpty) {
      return PawCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(l.bookNow, style: context.text.titleLarge),
          const SizedBox(height: Space.sm),
          Text(l.noPetForPlace, style: context.text.bodyMedium),
          if (pets.isEmpty) ...[
            const SizedBox(height: Space.md),
            SecondaryButton(label: l.addPet, icon: Ph.plus, onPressed: () => context.push('/pets/new')),
          ],
        ]),
      );
    }
    _petId ??= pets.where((p) => p.id == ref.read(selectedPetProvider)?.id).firstOrNull?.id ?? pets.first.id;
    _serviceId ??= place.services.first.id;
    final pet = pets.where((p) => p.id == _petId).firstOrNull ?? pets.first;
    final service = place.service(_serviceId!) ?? place.services.first;
    final request = service.mode == 'request';
    final now = DateTime.now();
    final bookings = ref.watch(providerBookingsProvider(place.id)).value ?? const <Booking>[];
    final slots = slotsFor(place, service, _day, bookings, now);
    final cfg = ref.watch(appSettingsDocProvider).value ?? const {};
    final pct = bookingCommissionPercent(cfg, kind: place.kind, providerRate: place.raw['commissionPercent']);
    final price = priceBooking(servicePrice: service.price, homeVisit: false, travelFee: place.homeVisitFee, commissionPercent: pct);
    final ready = request ? _proposed.isNotEmpty : _slot != null;

    void next() {
      final q = <String, String>{
        'pet': pet.id,
        'service': service.id,
        if (!request && _slot != null) 'slot': _slot!.toIso8601String(),
        if (request) 'times': (_proposed.toList()..sort()).map((t) => t.toIso8601String()).join(','),
      };
      context.push(Uri(path: '/book/new/${place.id}', queryParameters: q).toString());
    }

    return PawCard(
      padding: const EdgeInsets.all(Space.lg),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Wrap(alignment: WrapAlignment.spaceBetween, crossAxisAlignment: WrapCrossAlignment.center, spacing: Space.sm, runSpacing: Space.xs, children: [
          Semantics(header: true, child: Text(l.bookAVisit, style: context.text.titleLarge)),
          request ? PawTag(l.requestBooking, icon: Ph.clockFill) : PawTag(l.instantBooking, kind: TagKind.green, icon: Ph.lightningFill),
        ]),
        const SizedBox(height: Space.lg),
        FieldLabel(l.whichPet),
        Wrap(spacing: Space.sm, runSpacing: Space.sm, children: [
          for (final p in pets)
            PawPill(
              label: p.name,
              leading: PetAvatar(species: p.species, colorTag: p.colorTag, photoUrl: p.photoUrl, size: Sizes.pillArch * Sizes.archAspect, ring: false),
              selected: p.id == pet.id,
              onTap: () => setState(() => _petId = p.id),
            ),
        ]),
        const SizedBox(height: Space.lg),
        FieldLabel(l.whichService),
        for (final s in place.services)
          OptionCard(
            title: serviceLabel(context, s.id),
            subtitle: '${l.minutesShort(s.durationMin)}, ${(s.mode == 'instant' ? l.instantBooking : l.requestBooking).toLowerCase()}',
            trailing: Fmt.inr(s.price),
            selected: s.id == service.id,
            onTap: () => setState(() {
              _serviceId = s.id;
              _slot = null;
              _proposed.clear();
            }),
          ),
        const SizedBox(height: Space.md),
        FieldLabel(l.whenQ),
        // Two weeks of days: the day's name over its number.
        SizedBox(
          height: Sizes.dayTileHeight * MediaQuery.textScalerOf(context).scale(1).clamp(1.0, 1.6),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for (var i = 0; i < 14; i++)
                () {
                  final d = DateTime(now.year, now.month, now.day + i);
                  final sel = Fmt.sameDay(d, _day);
                  final scale = MediaQuery.textScalerOf(context).scale(1).clamp(1.0, 1.6);
                  return Padding(
                    padding: const EdgeInsets.only(right: Space.sm),
                    child: Semantics(
                      button: true,
                      selected: sel,
                      inMutuallyExclusiveGroup: true,
                      label: Fmt.weekdayDate(d, context.lang),
                      excludeSemantics: true,
                      child: Material(
                        color: sel ? paw.textPrimary : paw.surface.withValues(alpha: 0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.lg), side: BorderSide(color: sel ? paw.textPrimary : paw.outline, width: Strokes.strong)),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(Radii.lg),
                          onTap: () => setState(() {
                            _day = d;
                            _slot = null;
                          }),
                          child: SizedBox(
                            width: Sizes.dayTileWidth * scale,
                            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Text(Fmt.weekdayShort(d, context.lang), style: context.text.labelSmall?.copyWith(color: sel ? paw.background.withValues(alpha: Opacities.onDarkMuted) : paw.textSecondary, fontWeight: FontWeight.w400)),
                              const SizedBox(height: Space.xxs),
                              Text('${d.day}', style: context.text.titleMedium?.copyWith(color: sel ? paw.background : paw.textPrimary)),
                            ]),
                          ),
                        ),
                      ),
                    ),
                  );
                }(),
            ],
          ),
        ),
        const SizedBox(height: Space.md),
        if (request) ...[InfoNote(l.requestExplainer(place.requestWindowHours)), const SizedBox(height: Space.md)],
        if (slots.isEmpty)
          Text(l.noSlotsThatDay, style: context.text.bodyMedium?.copyWith(color: paw.textSecondary))
        else
          Wrap(spacing: Space.sm, runSpacing: Space.sm, children: [
            for (final slot in slots)
              Opacity(
                opacity: slot.available ? 1 : Opacities.muted,
                child: PawChip(
                  label: Fmt.time(slot.start, context.lang),
                  selected: request ? _proposed.contains(slot.start) : _slot == slot.start,
                  onTap: !slot.available
                      ? null
                      : () => setState(() {
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
              ),
          ]),
        const Padding(padding: EdgeInsets.only(top: Space.lg + Space.xxs, bottom: Space.md + Space.xxs), child: Divider(height: Strokes.hairline)),
        // What you've picked, and what it costs.
        Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l.serviceForPet(serviceLabel(context, service.id), pet.name), style: context.text.bodySmall?.copyWith(color: paw.textSecondary)),
              Text(
                request
                    ? (_proposed.isEmpty ? l.bookPickTime : (_proposed.toList()..sort()).map((t) => Fmt.time(t, context.lang)).join(', '))
                    : (_slot == null ? l.bookPickTime : '${Fmt.weekdayDate(_slot!, context.lang).replaceFirst(',', '')}, ${Fmt.time(_slot!, context.lang)}'),
                style: context.text.labelLarge,
              ),
            ]),
          ),
          const SizedBox(width: Space.md),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(Fmt.inr(price.total), style: context.text.titleLarge),
            if (price.platformFee > 0) Text('${l.platformFee} ${Fmt.inr(price.platformFee)}', style: context.text.labelSmall?.copyWith(color: paw.textSecondary, fontWeight: FontWeight.w400)),
          ]),
        ]),
        const SizedBox(height: Space.md),
        PawButton(label: l.continueLabel, icon: Ph.arrowRight, size: BtnSize.large, block: true, onPressed: ready ? next : null),
        const SizedBox(height: Space.sm),
        Text(
          place.kind == 'clinic' ? l.bookPayNote(place.cancellationHours) : l.cancellationPolicy(place.cancellationHours),
          textAlign: TextAlign.center,
          style: context.text.bodySmall?.copyWith(color: paw.textSecondary),
        ),
      ]),
    );
  }
}
