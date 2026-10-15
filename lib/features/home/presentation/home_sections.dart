import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/tokens.dart';
import '../../../core/widgets/widgets.dart';
import '../../admin/admin_slots.dart' show adminHomeSection;
import '../../pets/domain/pet.dart';
import '../../routine/data/routine_repository.dart';
import '../../routine/presentation/heat_card.dart';
import '../../routine/presentation/quick_log_sheet.dart';
import '../../routine/presentation/today_card.dart';
import 'home_extras.dart';

/// Home sections after the pet card, in spec order (section 5): Today,
/// Next up, quick actions, walk-weather tip, food running low, latest memory.
/// Easy mode shows a simpler Home: Today, Next due and 4 big quick actions.
List<Widget> homeSections(BuildContext context, WidgetRef ref,
    {required Pet? pet, required List<Pet> pets, required bool easy}) {
  final l = context.l10n;
  final focus = pet ?? pets.first;
  final quick = GridView.count(
    crossAxisCount: context.isPhone ? 2 : 4,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    mainAxisSpacing: Space.md,
    crossAxisSpacing: Space.md,
    childAspectRatio: easy ? 1.15 : 1.5,
    children: [
      QuickActionTile(icon: Icons.medical_services_rounded, label: l.qaBookVet, onTap: () => context.go('/book')),
      QuickActionTile(
        icon: focus.species == 'dog' ? Icons.directions_walk_rounded : Icons.edit_note_rounded,
        label: focus.species == 'dog' ? l.qaLogWalk : l.logSomething,
        onTap: () => focus.species == 'dog' ? context.push('/walk/${focus.id}') : showQuickLog(context, ref, focus),
      ),
      QuickActionTile(icon: Icons.support_agent_rounded, label: l.qaAskVet, onTap: () => context.push(askVetLink)),
      QuickActionTile(
        icon: Icons.add_a_photo_rounded,
        label: l.qaAddPhoto,
        color: context.paw.accent,
        onTap: () => context.push(addPhotoLink(focus.id)),
      ),
    ],
  );

  if (pet == null) {
    // "All pets": merged today's tasks.
    return [
      ...lostPetSection(context, ref, pets),
      ...adminHomeSection(context, ref),
      SectionHeader(l.todayAllPets),
      for (final p in pets) Padding(padding: const EdgeInsets.only(bottom: Space.md), child: _MiniToday(pet: p)),
      ...nextUpSection(context, ref, pets: pets),
      SectionHeader(l.quickActions),
      quick,
    ];
  }

  return [
    ...lostPetSection(context, ref, [pet]),
    ...adminHomeSection(context, ref),
    const SizedBox(height: Space.lg),
    TodayCard(pet: pet, big: easy),
    ...nextUpSection(context, ref, pets: [pet]),
    SectionHeader(l.quickActions),
    quick,
    if (!easy && pet.species == 'dog') ...[
      SectionHeader(l.walkWeather),
      HeatCard(pet: pet),
    ],
    if (!easy) ...foodLowSection(context, ref, pet),
    if (!easy) ...latestMemorySection(context, ref, pet),
  ];
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
        PetAvatar(species: pet.species, colorTag: pet.colorTag, photoUrl: pet.photoUrl, size: 48),
        const SizedBox(width: Space.md),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(pet.name, style: context.text.titleSmall),
            Text(open == 0 ? context.l10n.allDoneToday(pet.name) : context.l10n.tasksLeft(open), style: context.text.bodySmall),
          ]),
        ),
        ProgressRing(progress: p.fraction, size: 44, stroke: 6),
        IconButton(
          tooltip: context.l10n.logSomething,
          icon: Icon(Icons.add_circle_rounded, color: context.colors.primary),
          onPressed: () => showQuickLog(context, ref, pet),
        ),
      ]),
    );
  }
}
