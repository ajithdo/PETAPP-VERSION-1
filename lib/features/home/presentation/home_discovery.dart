import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../booking/data/places_repository.dart';
import '../../booking/domain/booking_rules.dart';
import '../../booking/presentation/place_finder_screen.dart';
import '../../health/data/health_repository.dart';
import '../../health/domain/vaccine_schedule.dart';
import '../../pets/domain/pet.dart';
import '../../routine/domain/routine.dart';
import '../../../core/theme/ph.dart';

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

/// Home "Near you" (UI Design 6): below the pet's day, never above it. A
/// title with the map link, the two nearest clinics as rows in a hairline
/// panel (drawn shopfront, open or 24x7, distance, a small Book button),
/// and a chip to change the area.
List<Widget> homeNearby(BuildContext context, WidgetRef ref, {required bool wide}) {
  final l = context.l10n;
  final paw = context.paw;
  final origin = ref.watch(searchOriginProvider);
  final clinics = ref.watch(clinicsProvider).value ?? const <Place>[];
  final nearest = [for (final c in clinics) (c, distanceKm(origin.lat, origin.lng, c.lat, c.lng))]..sort((a, b) => a.$2.compareTo(b.$2));
  final shown = nearest.take(2).toList();
  void find({bool map = false}) => context.push(map ? '/book/find/clinic?map=1' : '/book/find/clinic');
  final now = DateTime.now();
  return [
    const SizedBox(height: Sizes.sectionGap),
    SecHead(l.nearYou, action: l.mapView, onAction: () => find(map: true)),
    if (shown.isEmpty)
      const Skeleton(height: Sizes.skeletonCard, radius: Radii.card)
    else
      PawPanel(
        padding: PawPanel.listPadding,
        child: PawList(children: [
          for (final (p, km) in shown)
            () {
              final open = isOpenNow(p.hours, now);
              final state = p.is24x7 ? l.open24x7 : (open ? l.openNowChip : l.closedChip);
              return PawItem(
                lead: PawTile(size: Sizes.tileLg, child: SeedArt(seed: p.artSeed)),
                title: p.name,
                semanticLabel: [p.name, state, Fmt.km(km)].join(', '),
                subWidget: Text.rich(
                  TextSpan(children: [
                    TextSpan(text: state, style: TextStyle(color: p.is24x7 || open ? paw.success : paw.textSecondary, fontWeight: FontWeight.w600)),
                    TextSpan(text: ', ${Fmt.km(km)}'),
                  ]),
                  style: context.text.bodySmall?.copyWith(color: paw.textSecondary),
                ),
                onTap: () => context.push('/book/place/${p.id}'),
                trailing: PawButton(label: l.bookWord, kind: BtnKind.line, onPressed: () => context.push('/book/place/${p.id}')),
              );
            }(),
        ]),
      ),
    const SizedBox(height: Space.md),
    Align(alignment: Alignment.centerLeft, child: PawChip(label: origin.label, icon: Ph.mapPin, trailing: Ph.caretDown, onTap: find)),
  ];
}
