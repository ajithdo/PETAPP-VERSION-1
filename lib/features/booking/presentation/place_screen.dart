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
                expandedHeight: Sizes.placeHeader,
                flexibleSpace: FlexibleSpaceBar(background: SeedArt(seed: 'seed:${p.kind == 'clinic' ? 'clinic' : 'provider'}:${p.photoSeed}')),
              ),
              SliverToBoxAdapter(
                child: ContentWidth(
                  maxWidth: Space.wideWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: Space.lg),
                      Text(p.name, style: context.text.headlineSmall),
                      Text('${kindLabel(context, p.kind)} · ${p.area}, ${p.city}', style: context.text.bodyMedium?.copyWith(color: context.paw.textSecondary)),
                      const SizedBox(height: Space.sm),
                      Wrap(
                        spacing: Space.xs + Space.xxs,
                        runSpacing: Space.xs + Space.xxs,
                        children: [
                          if (p.reviewCount > 0) StatusChip('${p.rating.toStringAsFixed(1)} · ${l.reviewsCount(p.reviewCount)}', tone: ChipTone.accent, icon: Icons.star_rounded),
                          StatusChip(open ? l.openNowChip : l.closedChip, tone: open ? ChipTone.success : ChipTone.neutral),
                          if (p.is24x7) StatusChip(l.open24x7, tone: ChipTone.error, icon: Icons.emergency_outlined),
                          if (p.teleVet) StatusChip(l.teleVet, tone: ChipTone.info, icon: Icons.video_call_outlined),
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
                      PrimaryButton(label: l.bookNow, icon: Icons.event_available_outlined, onPressed: () => context.push('/book/new/${p.id}')),
                      const SizedBox(height: Space.md),
                      Wrap(
                        spacing: Space.sm,
                        runSpacing: Space.sm,
                        children: [
                          PawPill(
                            label: l.call,
                            outlined: true,
                            leading: Icon(Icons.call_outlined, size: IconSizes.md, color: context.paw.brand),
                            onTap: () => callNumber(context, ref, p.phone),
                          ),
                          PawPill(
                            label: l.directions,
                            outlined: true,
                            leading: Icon(Icons.directions_outlined, size: IconSizes.md, color: context.paw.brand),
                            onTap: () => openDirections(p.lat, p.lng, label: p.name),
                          ),
                          PawPill(
                            label: l.message,
                            outlined: true,
                            leading: Icon(Icons.chat_outlined, size: IconSizes.md, color: context.paw.brand),
                            onTap: () => context.push('/messages/new?place=${p.id}'),
                          ),
                        ],
                      ),
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
                                trailing: Text(Fmt.inr(s.price), style: context.textX.mono.copyWith(fontWeight: FontWeight.w700, color: context.paw.textPrimary)),
                                onTap: () => context.push('/book/new/${p.id}?service=${s.id}'),
                              ),
                            if (p.homeVisit)
                              ListTile(
                                leading: const Icon(Icons.home_outlined),
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
                                Text(Fmt.inr(pk['price'] as num), style: context.textX.mono.copyWith(fontWeight: FontWeight.w700, color: context.paw.textPrimary)),
                              ],
                            ),
                          ),
                      ],
                      if (p.kind == 'clinic') _VetsList(clinicId: p.id),
                      SectionHeader(l.location),
                      SizedBox(
                        height: Sizes.placeHeader,
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
                    child: Icon(Icons.medical_services_outlined, color: context.colors.primary),
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
                  Wrap(
                    spacing: Space.sm,
                    runSpacing: Space.xxs,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      RatingStars(r.rating),
                      Text(r.ownerName, style: context.text.labelMedium),
                      Text(Fmt.date(r.createdAt, context.lang), style: context.text.bodySmall),
                    ],
                  ),
                  const SizedBox(height: Space.xs),
                  Row(
                    children: [
                      Icon(Icons.verified_rounded, size: IconSizes.xs, color: context.paw.success),
                      const SizedBox(width: Space.xs),
                      Flexible(child: Text(l.verifiedBooking, style: context.text.labelSmall)),
                    ],
                  ),
                  if (r.text.isNotEmpty) Padding(padding: const EdgeInsets.only(top: Space.xs), child: Text(r.text)),
                  if (r.reply != null)
                    Container(
                      margin: const EdgeInsets.only(top: Space.sm),
                      padding: const EdgeInsets.all(Space.sm),
                      decoration: BoxDecoration(color: context.paw.primaryContainer.withValues(alpha: Opacities.half), borderRadius: BorderRadius.circular(Radii.md)),
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
