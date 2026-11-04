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
import 'booking_panel.dart';

/// Calls a phone number, or shows the demo dialog in demo mode (never dials).
Future<void> callNumber(BuildContext context, WidgetRef ref, String phone) async {
  if (ref.read(appConfigProvider).isDemo) {
    await showDemoDialog(context, title: context.l10n.demoTitle, body: context.l10n.demoCallBody(phone));
    return;
  }
  await launchUrl(Uri.parse('tel:${phone.replaceAll(' ', '')}'));
}

/// Clinic or provider page (spec 7.5), Design 2: the photo, the clinic's
/// details and the booking card. On desktop the booking card is the right
/// column; on phones it follows the call / directions / message pills.
class PlaceScreen extends ConsumerStatefulWidget {
  const PlaceScreen({super.key, required this.placeId});
  final String placeId;

  @override
  ConsumerState<PlaceScreen> createState() => _PlaceScreenState();
}

class _PlaceScreenState extends ConsumerState<PlaceScreen> {
  final _panel = GlobalKey<BookingPanelState>();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      body: AsyncView<Place?>(
        value: ref.watch(placeProvider(widget.placeId)),
        data: (p) {
          if (p == null) {
            return Scaffold(appBar: AppBar(), body: EmptyState(title: l.notFoundTitle));
          }
          final open = isOpenNow(p.hours, DateTime.now());
          final today = hoursOn(p.hours, DateTime.now());
          final wide = context.screenSize == ScreenSize.desktop;
          final panel = BookingPanel(key: _panel, place: p);
          final header = <Widget>[
            const SizedBox(height: Space.lg),
            Text(p.name, style: context.text.headlineMedium),
            const SizedBox(height: Space.xxs),
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
            if (p.about != null) ...[const SizedBox(height: Space.md), Text(p.about!, style: context.text.bodyLarge)],
            const SizedBox(height: Space.lg),
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
          ];
          final details = <Widget>[
            if (p.kind == 'clinic') _VetsList(clinicId: p.id),
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
                      // Picks this service in the booking card.
                      onTap: () => _panel.currentState?.selectService(s.id),
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
            SectionHeader(l.location),
            ClipRRect(
              borderRadius: BorderRadius.circular(Radii.card),
              child: SizedBox(
                height: Sizes.placeHeader,
                child: PawMap(
                  center: LatLng(p.lat, p.lng),
                  zoom: 15,
                  interactive: false,
                  markers: [pinMarker(LatLng(p.lat, p.lng), color: context.colors.primary, label: p.name)],
                ),
              ),
            ),
            _Reviews(place: p),
            const SizedBox(height: Space.xxl),
          ];
          Widget column(List<Widget> c) => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: c);
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: Sizes.placeHeader,
                flexibleSpace: FlexibleSpaceBar(background: SeedArt(seed: 'seed:${p.kind == 'clinic' ? 'clinic' : 'provider'}:${p.photoSeed}')),
              ),
              SliverToBoxAdapter(
                child: ContentWidth(
                  maxWidth: wide ? Space.maxContentWidth : Space.wideWidth,
                  child: wide
                      ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Expanded(flex: 7, child: column([...header, ...details])),
                          const SizedBox(width: Space.xl),
                          Expanded(flex: 5, child: column([const SizedBox(height: Space.lg), panel])),
                        ])
                      : column([...header, const SizedBox(height: Space.lg), panel, ...details]),
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
    if (vets.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(l.vetsHere),
        for (final v in vets)
          Padding(
            padding: const EdgeInsets.only(bottom: Space.sm),
            child: PawCard(
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                CircleAvatar(
                  radius: Sizes.avatarMd / 2,
                  backgroundColor: context.paw.primaryContainer,
                  child: Icon(Icons.medical_services_outlined, color: context.paw.brand),
                ),
                const SizedBox(width: Space.md),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Wrap(spacing: Space.sm, runSpacing: Space.xs, crossAxisAlignment: WrapCrossAlignment.center, children: [
                      Text(v.name, style: context.text.titleMedium),
                      StatusChip(l.yearsExperience(v.experienceYears), tone: ChipTone.info),
                    ]),
                    const SizedBox(height: Space.xxs),
                    Text(v.qualification, style: context.text.bodyMedium),
                    const SizedBox(height: Space.xxs),
                    Text(l.regNo(v.regNo), style: context.textX.mono.copyWith(color: context.paw.textSecondary)),
                  ]),
                ),
              ]),
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
