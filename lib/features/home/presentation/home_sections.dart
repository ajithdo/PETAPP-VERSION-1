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
import '../../shell/presentation/sos_launcher.dart';
import 'home_discovery.dart';
import 'home_extras.dart';
import '../../../core/theme/ph.dart';

/// Home sections after the toran band (spec 5, UI Design 6): Today, Next up,
/// quick actions, the walk weather, food running low, the latest memory, then
/// "Near you". Easy mode shows a simpler Home: Today, Next up and 4
/// big quick actions.
///
/// [top] goes above everything (lost-pet alert, admin note). On desktop
/// [main] sits under the pet card on the left, [side] on the right and
/// [below] under both; [phoneOrder] is the single-column order used on
/// phones and in Easy mode.
({List<Widget> top, List<Widget> main, List<Widget> side, List<List<Widget>> below, List<Widget> phoneOrder}) homeSections(
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
  const gap = SizedBox(height: Sizes.sectionGap);
  // Offers set by the admin come after the pet's day and the quick actions.
  final nearby = easy ? const <Widget>[] : [const BannerStrip(placement: 'home'), ...homeNearby(context, ref, wide: wide)];
  final focus = pet ?? pets.first;
  final dog = focus.species == 'dog';
  List<Widget> quickActions({bool flush = false}) => [
        if (!flush) gap,
        SecHead(l.quickActions),
        TileGrid(
          columns: easy ? 2 : 4,
          spacing: easy ? Space.md : Space.sm,
          minTileHeight: easy ? Sizes.quickTileMin : 0,
          children: [
            QuickActionTile(icon: Ph.stethoscope, label: l.qaBookVet, wide: easy, tone: Tone.gold, onTap: () => context.go('/book')),
            // Dogs start a walk; other pets open the log sheet.
            dog
                ? QuickActionTile(icon: Ph.personSimpleWalk, label: l.qaLogWalk, wide: easy, tone: Tone.green, onTap: () => context.push('/walk/${focus.id}'))
                : QuickActionTile(icon: Ph.notePencil, label: l.logSomething, wide: easy, tone: Tone.green, onTap: () => showQuickLog(context, ref, focus)),
            QuickActionTile(icon: Ph.videoCamera, label: l.qaAskVet, wide: easy, tone: Tone.sky, onTap: () => context.push(askVetLink)),
            QuickActionTile(icon: Ph.cameraPlus, label: l.qaAddPhoto, wide: easy, tone: Tone.neutral, onTap: () => context.push(addPhotoLink(focus.id))),
          ],
        ),
        // Easy mode: help is one big button away.
        if (easy) ...[
          gap,
          PawButton(label: l.sosEmergencyHelp, icon: Ph.asterisk, kind: BtnKind.sos, size: BtnSize.large, block: true, onPressed: () => openSos(context, ref)),
        ],
      ];

  if (pet == null) {
    // "All pets": merged today's tasks.
    final top = [...lostPetSection(context, ref, pets), ...adminHomeSection(context, ref)];
    final today = [
      gap,
      SecHead(l.todayAllPets),
      for (final p in pets) Padding(padding: const EdgeInsets.only(bottom: Space.md), child: _MiniToday(pet: p)),
    ];
    final next = nextUpSection(context, ref, pets: pets, skipFirst: skip);
    final side = [...nextUpSection(context, ref, pets: pets, flush: true, skipFirst: skip), ...quickActions()];
    return (top: top, main: today, side: side, below: [nearby], phoneOrder: [...today, ...next, ...quickActions(), ...nearby]);
  }

  final top = [...lostPetSection(context, ref, [pet]), ...adminHomeSection(context, ref)];
  final today = [gap, TodayCard(pet: pet, big: easy, header: false)];
  final next = nextUpSection(context, ref, pets: [pet], skipFirst: skip);
  final weather = [if (!easy && pet.species == 'dog') ...[gap, HeatCard(pet: pet)]];
  final food = easy ? const <Widget>[] : foodLowSection(context, ref, pet);
  final memory = easy ? const <Widget>[] : latestMemorySection(context, ref, pet);
  return (
    top: top,
    // Desktop: the day on the left; next up, quick actions and the weather
    // on the right; food, the memory and nearby clinics in a row below.
    main: today,
    side: [...nextUpSection(context, ref, pets: [pet], flush: true, skipFirst: skip), ...quickActions(), ...weather],
    below: [food, memory, nearby],
    phoneOrder: [...today, ...next, ...quickActions(), ...weather, ...food, ...memory, ...nearby],
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
          icon: Icon(Ph.plusCircle, color: context.colors.primary),
          onPressed: () => showQuickLog(context, ref, pet),
        ),
      ]),
    );
  }
}
