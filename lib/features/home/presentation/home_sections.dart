import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/tokens.dart';
import '../../../core/widgets/widgets.dart';
import '../../admin/admin_slots.dart' show adminHomeSection;
import '../../admin/presentation/banners.dart' show BannerStrip;
import '../../pets/domain/pet.dart';
import '../../routine/data/routine_repository.dart';
import '../../routine/presentation/heat_card.dart';
import '../../routine/presentation/quick_log_sheet.dart';
import '../../routine/presentation/today_card.dart';
import 'home_discovery.dart';
import 'home_extras.dart';

/// Home sections after the Genda band (spec 5, UI Design 5): Today, Next up,
/// quick actions, then "Near you" and tips (walk weather, food running low,
/// the latest memory). Easy mode shows a simpler Home: Today, Next up and 4
/// big quick actions.
///
/// [top] goes above everything (lost-pet alert, admin note). On desktop
/// [main] sits under the pet card on the left and [side] on the right;
/// [phoneOrder] is the single-column order used on phones and in Easy mode.
({List<Widget> top, List<Widget> main, List<Widget> side, List<Widget> phoneOrder}) homeSections(
  BuildContext context,
  WidgetRef ref, {
  required Pet? pet,
  required List<Pet> pets,
  required bool easy,
  bool wide = false,
}) {
  // Nothing above repeats the most urgent item any more, so Next up lists it.
  const skip = false;
  final l = context.l10n;
  // Offers set by the admin come after the pet's day and the quick actions.
  final nearby = easy ? const <Widget>[] : [const BannerStrip(placement: 'home'), ...homeNearby(context, ref, wide: wide)];
  final focus = pet ?? pets.first;
  final quickActions = [
    SectionHeader(l.quickActions),
    TileGrid(
      columns: context.isPhone ? 2 : 4,
      minTileHeight: easy ? Sizes.quickTileEasy : Sizes.quickTile,
      children: [
        QuickActionTile(icon: Icons.medical_services_outlined, label: l.qaBookVet, onTap: () => context.go('/book')),
        QuickActionTile(icon: Icons.support_agent_outlined, label: l.qaAskVet, onTap: () => context.push(askVetLink)),
        QuickActionTile(icon: Icons.shopping_bag_outlined, label: l.shopTitle, onTap: () => context.go('/shop')),
        QuickActionTile(icon: Icons.add_a_photo_outlined, label: l.qaAddPhoto, onTap: () => context.push(addPhotoLink(focus.id))),
      ],
    ),
  ];

  if (pet == null) {
    // "All pets": merged today's tasks.
    final top = [...lostPetSection(context, ref, pets), ...adminHomeSection(context, ref)];
    final today = [
      SectionHeader(l.todayAllPets),
      for (final p in pets) Padding(padding: const EdgeInsets.only(bottom: Space.md), child: _MiniToday(pet: p)),
    ];
    final next = nextUpSection(context, ref, pets: pets, skipFirst: skip);
    final side = [...nextUpSection(context, ref, pets: pets, flush: true, skipFirst: skip), ...quickActions, ...nearby];
    return (top: top, main: today, side: side, phoneOrder: [...today, ...next, ...quickActions, ...nearby]);
  }

  final top = [...lostPetSection(context, ref, [pet]), ...adminHomeSection(context, ref)];
  final today = [const SizedBox(height: Space.lg), TodayCard(pet: pet, big: easy, header: false)];
  final next = nextUpSection(context, ref, pets: [pet], skipFirst: skip);
  final tips = [
    if (!easy && pet.species == 'dog') ...[SectionHeader(l.walkWeather), HeatCard(pet: pet)],
    if (!easy) ...foodLowSection(context, ref, pet),
    if (!easy) ...latestMemorySection(context, ref, pet),
  ];
  return (
    top: top,
    // Desktop: the day on the left; next up, quick actions, nearby and tips
    // on the right, so the pet stays the biggest picture.
    main: today,
    side: [...nextUpSection(context, ref, pets: [pet], flush: true, skipFirst: skip), ...quickActions, ...nearby, ...tips],
    phoneOrder: [...today, ...next, ...quickActions, ...nearby, ...tips],
  );
}

class _MiniToday extends ConsumerWidget {
  const _MiniToday({required this.pet});
  final Pet pet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logs = ref.watch(petLogsProvider(pet.id)).value ?? const [];
    final p = TodayProgress(pet: pet, logs: logs);
    final open = p.items.where((i) => i.$2 < i.$3).length;
    return PawCard(
      onTap: () => context.push('/pets/${pet.id}/routine'),
      child: Row(children: [
        PetAvatar(species: pet.species, colorTag: pet.colorTag, photoUrl: pet.photoUrl, size: TapTarget.min),
        const SizedBox(width: Space.md),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(pet.name, style: context.text.titleSmall),
            Text(open == 0 ? context.l10n.allDoneToday(pet.name) : context.l10n.tasksLeft(open), style: context.text.bodySmall),
          ]),
        ),
        ProgressRing(progress: p.fraction, size: TapTarget.min - Space.xs, stroke: Space.xs + Space.xxs),
        IconButton(
          tooltip: context.l10n.logSomething,
          icon: Icon(Icons.add_circle_outlined, color: context.colors.primary),
          onPressed: () => showQuickLog(context, ref, pet),
        ),
      ]),
    );
  }
}
