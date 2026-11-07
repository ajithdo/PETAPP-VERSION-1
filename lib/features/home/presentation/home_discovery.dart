import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/tokens.dart';
import '../../../core/widgets/widgets.dart';
import '../../booking/data/places_repository.dart';
import '../../booking/presentation/place_finder_screen.dart';
import '../../health/data/health_repository.dart';
import '../../health/domain/vaccine_schedule.dart';
import '../../health/presentation/health_labels.dart';
import '../../health/presentation/health_screen.dart';
import '../../pets/domain/pet.dart';
import '../../routine/domain/routine.dart';

/// The most urgent care item across [pets] (overdue first, then due soon,
/// earliest first), or null when nothing needs attention.
(Pet, DueItem)? mostUrgentDue(WidgetRef ref, List<Pet> pets) {
  final items = <(Pet, DueItem)>[];
  for (final p in pets) {
    for (final i in ref.watch(petDueProvider(p)).value ?? const <DueItem>[]) {
      if (i.status == DoseStatus.overdue || i.status == DoseStatus.dueSoon) items.add((p, i));
    }
  }
  if (items.isEmpty) return null;
  items.sort((a, b) {
    int rank(DoseStatus s) => s == DoseStatus.overdue ? 0 : 1;
    final r = rank(a.$2.status).compareTo(rank(b.$2.status));
    return r != 0 ? r : (a.$2.at ?? DateTime.now()).compareTo(b.$2.at ?? DateTime.now());
  });
  return items.first;
}

/// UI Design 2 top of Home ("Explore"): where you are, a search box, quick
/// links, the pet's health status and the nearest vets. The pet's day
/// follows below it (owner's choice, 4 Nov 2026).
List<Widget> homeDiscoveryTop(BuildContext context, WidgetRef ref, {required Pet? pet, required List<Pet> pets, required bool wide}) {
  final l = context.l10n;
  final origin = ref.watch(searchOriginProvider);
  final clinics = ref.watch(clinicsProvider).value ?? const <Place>[];
  final nearest = [for (final c in clinics) (c, distanceKm(origin.lat, origin.lng, c.lat, c.lng))]..sort((a, b) => a.$2.compareTo(b.$2));
  final shown = nearest.take(wide ? 3 : 2).toList();
  void find({bool map = false}) => context.push(map ? '/book/find/clinic?map=1' : '/book/find/clinic');

  final location = _LocationPill(label: origin.label, onTap: find);
  final search = _SearchBox(hint: l.findAVet, onTap: find, onMap: () => find(map: true), wide: wide);
  final chips = Wrap(spacing: Space.sm, runSpacing: Space.sm, children: [
    PawPill(
      label: l.kindVet,
      selected: true,
      leading: Icon(Icons.local_hospital_outlined, size: IconSizes.md, color: context.paw.brand),
      onTap: find,
    ),
    PawPill(
      label: l.vaccinations,
      outlined: true,
      leading: Icon(Icons.vaccines_outlined, size: IconSizes.md, color: context.paw.brand),
      onTap: () => context.go('/health'),
    ),
    PawPill(
      label: l.teleVet,
      outlined: true,
      leading: Icon(Icons.videocam_outlined, size: IconSizes.md, color: context.paw.brand),
      onTap: () => context.push('/televet'),
    ),
  ]);
  final status = _HealthStatusCard(pet: pet, pets: pets);
  final vets = [
    SectionHeader(l.nearYou, action: l.mapView, onAction: () => find(map: true)),
    if (shown.isEmpty)
      const Skeleton(height: Sizes.placeCardPhoto, radius: Radii.card)
    else if (wide)
      ResponsiveGrid(minItemWidth: Sizes.placeCardMinWidth, children: [for (final e in shown) PlaceCard(place: e.$1, km: e.$2)])
    else
      for (final e in shown) Padding(padding: const EdgeInsets.only(bottom: Space.md), child: PlaceCard(place: e.$1, km: e.$2)),
  ];

  if (wide) {
    return [
      const SizedBox(height: Space.lg),
      Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Expanded(child: Semantics(header: true, child: Text(l.findAVet, style: context.text.displayMedium))),
        const SizedBox(width: Space.lg),
        location,
      ]),
      const SizedBox(height: Space.lg),
      search,
      const SizedBox(height: Space.md),
      chips,
      ...vets,
      const SizedBox(height: Space.xl),
      status,
    ];
  }
  return [
    const SizedBox(height: Space.sm),
    Align(alignment: Alignment.centerLeft, child: location),
    const SizedBox(height: Space.md),
    search,
    const SizedBox(height: Space.md),
    chips,
    const SizedBox(height: Space.lg),
    status,
    ...vets,
  ];
}

class _LocationPill extends StatelessWidget {
  const _LocationPill({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final paw = context.paw;
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: paw.surface,
        shape: StadiumBorder(side: BorderSide(color: paw.outline)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: TapTarget.min),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Space.lg),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  width: Sizes.dot,
                  height: Sizes.dot,
                  decoration: BoxDecoration(color: paw.success, shape: BoxShape.circle),
                ),
                const SizedBox(width: Space.sm),
                Flexible(child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: context.text.labelLarge)),
                const SizedBox(width: Space.xs),
                Icon(Icons.expand_more_outlined, size: IconSizes.md, color: paw.textSecondary),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

/// A box that looks like a search field and opens the clinic finder.
class _SearchBox extends StatelessWidget {
  const _SearchBox({required this.hint, required this.onTap, required this.onMap, required this.wide});
  final String hint;
  final VoidCallback onTap;
  final VoidCallback onMap;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final paw = context.paw;
    final l = context.l10n;
    final light = Theme.of(context).brightness == Brightness.light;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Radii.card),
        boxShadow: light ? Shadows.card(paw.ink) : null,
      ),
      child: Material(
        color: paw.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.card), side: BorderSide(color: paw.outline)),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(Space.xs + Space.xxs),
          child: Row(children: [
            Expanded(
              child: Semantics(
                button: true,
                label: hint,
                excludeSemantics: true,
                child: InkWell(
                  borderRadius: BorderRadius.circular(Radii.lg),
                  onTap: onTap,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: TapTarget.min),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Space.md),
                      child: Row(children: [
                        Icon(Icons.search_outlined, color: paw.textSecondary),
                        const SizedBox(width: Space.md),
                        Expanded(
                          child: Text(hint, maxLines: 1, overflow: TextOverflow.ellipsis, style: context.text.bodyLarge?.copyWith(color: paw.textSecondary)),
                        ),
                      ]),
                    ),
                  ),
                ),
              ),
            ),
            if (wide) ...[
              PawPill(
                label: l.mapView,
                leading: Icon(Icons.map_outlined, size: IconSizes.md, color: paw.textPrimary),
                onTap: onMap,
              ),
              const SizedBox(width: Space.sm),
              PrimaryButton(label: l.shopSearchTitle, expand: false, onPressed: onTap),
            ] else
              PawIconButton(icon: Icons.map_outlined, tooltip: l.clinicFinderMap, onPressed: onMap),
          ]),
        ),
      ),
    );
  }
}

/// UI Design 2 dark card on Home: the most urgent care item ("Booster due in 10
/// days") with a coral Book button, or "All up to date".
class _HealthStatusCard extends ConsumerWidget {
  const _HealthStatusCard({required this.pet, required this.pets});
  final Pet? pet;
  final List<Pet> pets;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = PassCard.colorsOf(context);
    final focus = pet == null ? pets : [pet!];
    final urgent = mostUrgentDue(ref, focus);
    final who = urgent?.$1 ?? pet;
    final overline = who == null ? l.nextUp : l.healthOf(who.name);
    final title = urgent == null ? l.healthAllClear : dueTitle(context, urgent.$2);
    final when = urgent == null ? l.nothingDueAll : dueWhen(context, urgent.$2);
    final isVaccine = urgent?.$2.kind == 'vaccine';
    final button = urgent == null
        ? PassCard.action(context, label: l.tabHealth, icon: Icons.favorite_border, onPressed: () => context.go('/health'))
        : isVaccine
            ? PrimaryButton(label: l.bookNow, expand: false, onPressed: () => context.push('/book/find/clinic'))
            : PassCard.action(context, label: l.tabHealth, icon: Icons.arrow_forward_outlined, onPressed: () => openDueItem(context, ref, urgent.$1, urgent.$2));
    final text = Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
      Row(children: [
        Icon(Icons.verified_user_outlined, size: IconSizes.sm, color: c.fg),
        const SizedBox(width: Space.xs + Space.xxs),
        Flexible(child: Text(overline.toUpperCase(), style: context.textX.overline.copyWith(color: c.fg))),
      ]),
      const SizedBox(height: Space.sm),
      Text(title, style: context.text.titleLarge?.copyWith(color: c.fg)),
      if (when.isNotEmpty) ...[
        const SizedBox(height: Space.xxs),
        Text(when, style: context.text.bodyMedium?.copyWith(color: c.muted)),
      ],
    ]);
    return Semantics(
      container: true,
      child: Container(
        padding: const EdgeInsets.all(Space.lg),
        decoration: BoxDecoration(
          color: c.bg,
          borderRadius: BorderRadius.circular(Radii.card),
          boxShadow: Theme.of(context).brightness == Brightness.light ? Shadows.card(context.paw.ink) : null,
        ),
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: Space.lg,
          runSpacing: Space.md,
          children: [text, button],
        ),
      ),
    );
  }
}
