import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/tokens.dart';
import '../../../core/widgets/widgets.dart';
import '../../booking/data/places_repository.dart';
import '../../booking/presentation/place_finder_screen.dart';
import '../../health/data/health_repository.dart';
import '../../health/domain/vaccine_schedule.dart';
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

/// Home "Near you" (UI Design 5): below the pet's day, never above it
/// (DESIGN.md, the Pet First rule). A section title with the map link, where
/// you are and a search box, then the nearest clinics (2 on phones).
List<Widget> homeNearby(BuildContext context, WidgetRef ref, {required bool wide}) {
  final l = context.l10n;
  final origin = ref.watch(searchOriginProvider);
  final clinics = ref.watch(clinicsProvider).value ?? const <Place>[];
  final nearest = [for (final c in clinics) (c, distanceKm(origin.lat, origin.lng, c.lat, c.lng))]..sort((a, b) => a.$2.compareTo(b.$2));
  final shown = nearest.take(2).toList();
  void find({bool map = false}) => context.push(map ? '/book/find/clinic?map=1' : '/book/find/clinic');
  return [
    SectionHeader(l.nearYou, action: l.mapView, onAction: () => find(map: true), padding: wide ? const EdgeInsets.only(top: Space.xl, bottom: Space.sm) : null),
    Align(alignment: Alignment.centerLeft, child: _LocationPill(label: origin.label, onTap: find)),
    const SizedBox(height: Space.sm),
    _SearchBox(hint: l.findAVet, onTap: find, onMap: () => find(map: true), wide: false),
    const SizedBox(height: Space.md),
    if (shown.isEmpty)
      const Skeleton(height: Sizes.placeCardPhoto, radius: Radii.card)
    else
      // Compact rows with a small photo: clinics stay below the pet's day and
      // never outshine the pet's own photo.
      for (final e in shown) Padding(padding: const EdgeInsets.only(bottom: Space.sm), child: PlaceCard(place: e.$1, km: e.$2, compact: true)),
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
        color: paw.surfaceSubtle,
        shape: const StadiumBorder(),
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
                Icon(Icons.expand_more_rounded, size: IconSizes.md, color: paw.textSecondary),
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
        borderRadius: BorderRadius.circular(Radii.full),
        boxShadow: light ? Shadows.card(paw.ink) : null,
      ),
      child: Material(
        color: paw.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.full),
          side: light ? BorderSide.none : BorderSide(color: paw.outline),
        ),
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
                  borderRadius: BorderRadius.circular(Radii.full),
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
