import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/paw_map.dart';
import '../../../core/widgets/widgets.dart';
import '../data/places_repository.dart';
import '../domain/booking_rules.dart';
import 'booking_labels.dart';

/// Calls a phone number, or shows the demo dialog in demo mode (never dials).
Future<void> callNumber(BuildContext context, WidgetRef ref, String phone) async {
  if (ref.read(appConfigProvider).isDemo) {
    await showDemoDialog(context, title: context.l10n.demoTitle, body: context.l10n.demoCallBody(phone));
    return;
  }
  await launchUrl(Uri.parse('tel:${phone.replaceAll(' ', '')}'));
}

/// Clinic or provider page (spec 7.5).
class PlaceScreen extends ConsumerWidget {
  const PlaceScreen({super.key, required this.placeId});
  final String placeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return Scaffold(
      body: AsyncView<Place?>(
        value: ref.watch(placeProvider(placeId)),
        data: (p) {
          if (p == null) {
            return Scaffold(appBar: AppBar(), body: EmptyState(title: l.notFoundTitle));
          }
          final open = isOpenNow(p.hours, DateTime.now());
          final today = hoursOn(p.hours, DateTime.now());
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 200,
                flexibleSpace: FlexibleSpaceBar(background: SeedArt(seed: 'seed:${p.kind == 'clinic' ? 'clinic' : 'provider'}:${p.photoSeed}')),
              ),
              SliverToBoxAdapter(
                child: ContentWidth(
                  maxWidth: 900,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: Space.lg),
                      Text(p.name, style: context.text.headlineSmall),
                      Text('${kindLabel(context, p.kind)} · ${p.area}, ${p.city}', style: context.text.bodyMedium?.copyWith(color: context.paw.textSecondary)),
                      const SizedBox(height: Space.sm),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          if (p.reviewCount > 0) StatusChip('★ ${p.rating.toStringAsFixed(1)} · ${l.reviewsCount(p.reviewCount)}', tone: ChipTone.accent),
                          StatusChip(open ? l.openNowChip : l.closedChip, tone: open ? ChipTone.success : ChipTone.neutral),
                          if (p.is24x7) StatusChip(l.open24x7, tone: ChipTone.error, icon: Icons.emergency_rounded),
                          if (p.teleVet) StatusChip(l.teleVet, tone: ChipTone.info, icon: Icons.video_call_rounded),
                          for (final s in p.species)
                            StatusChip(switch (s) {
                              'cat' => l.speciesCat,
                              'bird' => l.speciesBird,
                              'rabbit' => l.speciesRabbit,
                              _ => l.speciesDog,
                            }),
                        ],
                      ),
                      const SizedBox(height: Space.lg),
                      Row(
                        children: [
                          Expanded(
                            child: SecondaryButton(label: l.call, icon: Icons.call_rounded, onPressed: () => callNumber(context, ref, p.phone)),
                          ),
                          const SizedBox(width: Space.sm),
                          Expanded(
                            child: SecondaryButton(
                              label: l.directions,
                              icon: Icons.directions_rounded,
                              onPressed: () => openDirections(p.lat, p.lng, label: p.name),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Space.sm),
                      PrimaryButton(label: l.bookNow, icon: Icons.event_available_rounded, onPressed: () => context.push('/book/new/${p.id}')),
                  const SizedBox(height: Space.sm),
                  SecondaryButton(label: l.message, icon: Icons.chat_rounded, onPressed: () => context.push('/messages/new?place=${p.id}')),
                      if (p.about != null) ...[const SizedBox(height: Space.lg), Text(p.about!)],
                      SectionHeader(l.hoursTitle),
                      PawCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.is24x7
                                  ? l.open24x7Long
                                  : today == null
                                  ? l.closedToday
                                  : l.todayHours(Fmt.time(today.open, context.lang), Fmt.time(today.close, context.lang)),
                            ),
                            const SizedBox(height: Space.xs),
                            Text(p.address, style: context.text.bodySmall),
                            if (p.emergencyPhone != null)
                              Text(l.emergencyLine(p.emergencyPhone!), style: context.text.bodySmall?.copyWith(color: context.paw.error)),
                          ],
                        ),
                      ),
                      SectionHeader(l.servicesAndPrices),
                      PawCard(
                        padding: const EdgeInsets.symmetric(vertical: Space.xs),
                        child: Column(
                          children: [
                            for (final s in p.services)
                              ListTile(
                                title: Text(serviceLabel(context, s.id)),
                                subtitle: Text(
                                  [
                                    l.minutesShort(s.durationMin),
                                    s.mode == 'instant' ? l.instantBooking : l.requestBooking,
                                    s.payments.map((x) => x == 'online' ? l.payOnline : l.payAtCentre).join(' / '),
                                  ].join(' · '),
                                ),
                                trailing: Text(Fmt.inr(s.price), style: context.text.titleSmall),
                                onTap: () => context.push('/book/new/${p.id}?service=${s.id}'),
                              ),
                            if (p.homeVisit)
                              ListTile(
                                leading: const Icon(Icons.home_rounded),
                                title: Text(l.homeVisitAvailable(p.radiusKm)),
                                trailing: Text('+ ${Fmt.inr(p.homeVisitFee)}'),
                              ),
                          ],
                        ),
                      ),
                      if (p.packages.isNotEmpty) ...[
                        SectionHeader(l.packages),
                        for (final pk in p.packages)
                          PawCard(
                            child: Row(
                              children: [
                                Expanded(child: Text(pk['name'] as String)),
                                Text(Fmt.inr(pk['price'] as num), style: context.text.titleSmall),
                              ],
                            ),
                          ),
                      ],
                      if (p.kind == 'clinic') _VetsList(clinicId: p.id),
                      SectionHeader(l.location),
                      SizedBox(
                        height: 200,
                        child: PawMap(
                          center: LatLng(p.lat, p.lng),
                          zoom: 15,
                          interactive: false,
                          markers: [pinMarker(LatLng(p.lat, p.lng), color: context.colors.primary, label: p.name)],
                        ),
                      ),
                      _Reviews(place: p),
                      const SizedBox(height: Space.xxl),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _VetsList extends ConsumerWidget {
  const _VetsList({required this.clinicId});
  final String clinicId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final vets = ref.watch(vetsProvider(clinicId)).value ?? const <Vet>[];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(l.vetsHere),
        PawCard(
          padding: const EdgeInsets.symmetric(vertical: Space.xs),
          child: Column(
            children: [
              for (final v in vets)
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: context.paw.primaryContainer,
                    child: Icon(Icons.medical_services_rounded, color: context.colors.primary),
                  ),
                  title: Text(v.name),
                  subtitle: Text('${v.qualification} · ${l.yearsExperience(v.experienceYears)}\n${l.regNo(v.regNo)}'),
                  isThreeLine: true,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Reviews extends ConsumerWidget {
  const _Reviews({required this.place});
  final Place place;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final reviews = ref.watch(reviewsProvider(place.id)).value ?? const <Review>[];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(l.reviews),
        if (reviews.isEmpty) PawCard(child: Text(l.noReviewsYet)),
        for (final r in reviews.take(10))
          Padding(
            padding: const EdgeInsets.only(bottom: Space.sm),
            child: PawCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('★' * r.rating, style: TextStyle(color: context.paw.accent)),
                      const SizedBox(width: Space.sm),
                      Expanded(child: Text(r.ownerName, style: context.text.labelMedium)),
                      Text(Fmt.date(r.createdAt, context.lang), style: context.text.bodySmall),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.verified_rounded, size: 14, color: context.paw.success),
                      const SizedBox(width: 4),
                      Text(l.verifiedBooking, style: context.text.labelSmall),
                    ],
                  ),
                  if (r.text.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 4), child: Text(r.text)),
                  if (r.reply != null)
                    Container(
                      margin: const EdgeInsets.only(top: Space.sm),
                      padding: const EdgeInsets.all(Space.sm),
                      decoration: BoxDecoration(color: context.paw.primaryContainer.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(10)),
                      child: Text('${l.replyFrom(place.name)}: ${r.reply}', style: context.text.bodySmall),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
