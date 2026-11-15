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
import 'place_finder_screen.dart' show searchOriginProvider;
import '../../routine/domain/routine.dart' show distanceKm;
import '../../../core/theme/ph.dart';

/// Calls a phone number, or shows the demo dialog in demo mode (never dials).
Future<void> callNumber(BuildContext context, WidgetRef ref, String phone) async {
  if (ref.read(appConfigProvider).isDemo) {
    await showDemoDialog(context, title: context.l10n.demoTitle, body: context.l10n.demoCallBody(phone));
    return;
  }
  await launchUrl(Uri.parse('tel:${phone.replaceAll(' ', '')}'));
}

/// Clinic or provider page (spec 7.5), UI Design 2: the photo, the clinic's
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
          final hoursText = p.is24x7
              ? l.open24x7Long
              : today == null
              ? l.closedToday
              : l.todayHours(Fmt.time(today.open, context.lang), Fmt.time(today.close, context.lang));
          final wide = context.screenSize == ScreenSize.desktop;
          final photo = SeedArt(seed: p.artSeed);
          final panel = BookingPanel(key: _panel, place: p);
          final header = <Widget>[
            // UI Design 6: the photo is a rounded picture in the page on
            // every screen size.
            const SizedBox(height: Space.md),
            _PhotoCard(place: p, photo: photo, open: open, hours: hoursText),
            const SizedBox(height: Space.lg),
            Semantics(header: true, child: Text(p.name, style: wide ? context.text.headlineLarge : context.text.displaySmall)),
            const SizedBox(height: Space.xs),
            Builder(builder: (context) {
              final o = ref.watch(searchOriginProvider);
              return Text(
                l.placeWhere(kindLabel(context, p.kind), p.area, p.city, Fmt.km(distanceKm(o.lat, o.lng, p.lat, p.lng))),
                style: context.text.bodyMedium?.copyWith(color: context.paw.textSecondary),
              );
            }),
            const SizedBox(height: Space.md),
            // One tag (open now / 24x7 / closed), the rating as text, and
            // what they offer on the same quiet line.
            Wrap(spacing: Space.sm, runSpacing: Space.xs, crossAxisAlignment: WrapCrossAlignment.center, children: [
              p.is24x7
                  ? StatusChip(l.open24x7, tone: ChipTone.success, icon: Ph.clockFill)
                  : StatusChip(open ? l.openNowChip : l.closedChip, tone: open ? ChipTone.success : ChipTone.neutral, icon: open ? Ph.circleFill : null),
              if (p.reviewCount > 0)
                Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Ph.starFill, size: IconSizes.xs, color: context.tint.star),
                  const SizedBox(width: Space.xxs + Strokes.hairline),
                  Text(p.rating.toStringAsFixed(1), style: context.text.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: context.paw.textPrimary)),
                  Text('  ${l.reviewsCount(p.reviewCount)}', style: context.text.bodySmall?.copyWith(color: context.paw.textSecondary)),
                ]),
              Text(
                [
                  if (p.teleVet) l.teleVet,
                  for (final s in p.species)
                    switch (s) {
                      'cat' => l.speciesCat,
                      'bird' => l.speciesBird,
                      'rabbit' => l.speciesRabbit,
                      _ => l.speciesDog,
                    },
                ].join(', '),
                style: context.text.bodySmall?.copyWith(color: context.paw.textSecondary),
              ),
            ]),
            if (p.about != null) ...[const SizedBox(height: Space.md), Text(p.about!, style: context.text.bodyLarge)],
            const SizedBox(height: Space.lg),
            // Call, Directions and Message as three equal soft buttons.
            Builder(builder: (context) {
              Widget soft(IconData icon, String label, VoidCallback onTap) => PawButton(label: label, icon: icon, kind: BtnKind.soft, size: BtnSize.regular, block: true, onPressed: onTap);
              final buttons = [
                soft(Ph.phone, l.call, () => callNumber(context, ref, p.phone)),
                soft(Ph.navigationArrow, l.directions, () => openDirections(p.lat, p.lng, label: p.name)),
                soft(Ph.chatCircleDots, l.message, () => context.push('/messages/new?place=${p.id}')),
              ];
              if (MediaQuery.textScalerOf(context).scale(1) > 1.3) {
                return Wrap(spacing: Space.sm, runSpacing: Space.sm, children: buttons);
              }
              return Row(children: [
                for (var i = 0; i < buttons.length; i++) ...[if (i > 0) const SizedBox(width: Space.md), Expanded(child: buttons[i])],
              ]);
            }),
          ];
          final details = <Widget>[
            if (p.kind == 'clinic') _VetsList(clinicId: p.id),
            if (p.packages.isNotEmpty) ...[
              const SizedBox(height: Sizes.sectionGap),
              SecHead(l.packages),
              PawPanel(
                padding: PawPanel.listPadding,
                child: PawList(children: [
                  for (final pk in p.packages)
                    PawItem(
                      lead: const PawTile(icon: Ph.package),
                      title: pk['name'] as String,
                      noTrailing: false,
                      trailing: Text(Fmt.inr(pk['price'] as num), style: context.text.labelLarge?.copyWith(fontWeight: FontWeight.w700)),
                    ),
                ]),
              ),
            ],
            _Reviews(place: p),
            const SizedBox(height: Sizes.sectionGap),
            SecHead(l.whereToFind),
            PawCard(
              padding: EdgeInsets.zero,
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(Radii.xl)),
                  child: SizedBox(
                    height: Sizes.mapSketch - Space.sm,
                    child: PawMap(
                      center: LatLng(p.lat, p.lng),
                      zoom: 15,
                      interactive: false,
                      markers: [pinMarker(LatLng(p.lat, p.lng), color: context.colors.primary, label: p.name)],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(Space.lg, Space.md + Space.xxs, Space.lg, Space.md + Space.xxs),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(p.address, style: context.text.labelLarge),
                    Text(
                      [hoursText, if (p.homeVisit) '${l.homeVisitAvailable(p.radiusKm)}, + ${Fmt.inr(p.homeVisitFee)}'].join('. '),
                      style: context.text.bodySmall?.copyWith(color: context.paw.textSecondary),
                    ),
                    if (p.emergencyPhone != null) Text(l.emergencyLine(p.emergencyPhone!), style: context.text.bodySmall?.copyWith(color: context.paw.error)),
                  ]),
                ),
              ]),
            ),
            const SizedBox(height: Space.xxl),
          ];
          Widget column(List<Widget> c) => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: c);
          return CustomScrollView(
            slivers: [
              SliverAppBar(pinned: true, title: Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis)),
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

/// The place's photo as a rounded picture with its area and distance at the
/// bottom left and today's hours at the bottom right (tablets and desktops).
class _PhotoCard extends ConsumerWidget {
  const _PhotoCard({required this.place, required this.photo, required this.open, required this.hours});
  final Place place;
  final Widget photo;
  final bool open;
  final String hours;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: Sizes.placePhotoMaxHeight),
      child: AspectRatio(
        aspectRatio: Sizes.placePhotoAspect + 0.18,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Radii.xxl),
          child: Stack(fit: StackFit.expand, children: [
            ExcludeSemantics(child: photo),
            // Today's hours, as a tag on the picture.
            Positioned(left: Space.sm, bottom: Space.sm, child: PawTag(hours, kind: open ? TagKind.green : TagKind.neutral, icon: Ph.clockFill)),
          ]),
        ),
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
        const SizedBox(height: Sizes.sectionGap),
        SecHead(l.vetsHere),
        // One panel: each vet's initials, name, degrees, then years and
        // registration number.
        PawPanel(
          padding: PawPanel.listPadding,
          child: PawList(children: [
            for (final (i, v) in vets.indexed)
              PawItem(
                lead: PersonDot(v.name, size: Sizes.avatarMd, gold: i == 0),
                title: v.name,
                sub: '${v.qualification}\n${l.vetYearsReg(v.experienceYears, v.regNo)}',
                subMaxLines: 4,
                noTrailing: true,
              ),
          ]),
        ),
      ],
    );
  }
}

/// The rating at a glance (the number, stars and a bar per star), then the
/// newest review; "See all" opens the rest.
class _Reviews extends ConsumerStatefulWidget {
  const _Reviews({required this.place});
  final Place place;

  @override
  ConsumerState<_Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends ConsumerState<_Reviews> {
  bool _all = false;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final paw = context.paw;
    final place = widget.place;
    final reviews = [...(ref.watch(reviewsProvider(place.id)).value ?? const <Review>[])]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final shown = reviews.take(_all ? 10 : 1).toList();
    Widget review(Review r) => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            PersonDot(r.ownerName, size: Sizes.buttonSmall),
            const SizedBox(width: Space.md),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Wrap(spacing: Space.sm, runSpacing: Space.xxs, crossAxisAlignment: WrapCrossAlignment.center, children: [
                  Text(r.ownerName, style: context.text.labelLarge),
                  PawTag(l.verifiedVisit, kind: TagKind.green, icon: Ph.sealCheckFill),
                ]),
                Row(children: [
                  RatingStars(r.rating, size: IconSizes.xs),
                  const SizedBox(width: Space.sm),
                  Flexible(child: Text(Fmt.date(r.createdAt, context.lang), style: context.text.bodySmall?.copyWith(color: paw.textSecondary))),
                ]),
              ]),
            ),
          ]),
          if (r.text.isNotEmpty) Padding(padding: const EdgeInsets.only(top: Space.sm), child: Text(r.text, style: context.text.bodyMedium)),
          if (r.reply != null) Padding(padding: const EdgeInsets.only(top: Space.md), child: InfoNote(r.reply!, lead: l.replyFromClinic, icon: Ph.arrowBendDownRight)),
        ]);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: Sizes.sectionGap),
        SecHead(
          l.reviews,
          action: reviews.length <= 1 ? null : (_all ? l.showFewer : l.seeAllCount(place.reviewCount > reviews.length ? place.reviewCount : reviews.length)),
          onAction: reviews.length <= 1 ? null : () => setState(() => _all = !_all),
        ),
        if (reviews.isEmpty)
          PawPanel(child: Text(l.noReviewsYet, style: context.text.bodyMedium?.copyWith(color: paw.textSecondary)))
        else
          PawCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Flexible(
                  child: Column(children: [
                    Text(place.rating.toStringAsFixed(1), style: context.text.displaySmall?.copyWith(height: TypeScale.tightLineHeight)),
                    const SizedBox(height: Space.xs),
                    FittedBox(fit: BoxFit.scaleDown, child: RatingStars(place.rating.round())),
                    const SizedBox(height: Space.xxs),
                    Text(l.verifiedVisits(place.reviewCount), style: context.text.bodySmall?.copyWith(color: paw.textSecondary), textAlign: TextAlign.center),
                  ]),
                ),
                const SizedBox(width: Space.lg + Space.xs),
                Expanded(
                  child: Column(children: [
                    for (var star = 5; star >= 1; star--)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: Space.xxs),
                        child: Row(children: [
                          SizedBox(width: Space.md, child: Text('$star', style: context.text.labelSmall?.copyWith(color: paw.textSecondary, fontWeight: FontWeight.w500))),
                          const SizedBox(width: Space.sm),
                          Expanded(child: LevelBar(value: reviews.where((r) => r.rating == star).length / reviews.length)),
                        ]),
                      ),
                  ]),
                ),
              ]),
              for (final r in shown) ...[
                const Padding(padding: EdgeInsets.symmetric(vertical: Space.lg), child: Divider(height: Strokes.hairline)),
                review(r),
              ],
            ]),
          ),
      ],
    );
  }
}
