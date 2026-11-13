import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../core/settings/settings_controller.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../pets/data/pets_repository.dart';
import '../../pets/domain/pet.dart';
import '../../routine/data/routine_repository.dart';
import '../../routine/domain/routine.dart';
import '../../routine/presentation/quick_log_sheet.dart';
import '../../routine/presentation/routine_labels.dart';
import 'home_sections.dart';
import '../../../core/theme/ph.dart';

/// Home (spec 5), UI Design 5 "Genda" (DESIGN.md): the pet's day first.
/// Greeting → the Genda band (the pet in its garland, today's progress) →
/// today's checklist → what's due next → quick actions → nearby clinics and
/// tips. One column on phones and in Easy mode; on desktop the day sits on
/// the left and "Next up", "Near you" and tips on the right.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final user = ref.watch(currentUserProvider);
    final petsAsync = ref.watch(myPetsProvider);
    final pet = ref.watch(selectedPetProvider);
    final easy = ref.watch(settingsProvider).easyMode;
    final hour = DateTime.now().hour;
    final greet = hour < 12 ? l.goodMorning : (hour < 17 ? l.goodAfternoon : l.goodEvening);

    return AsyncView(
      value: petsAsync,
      onRetry: () => ref.invalidate(myPetsProvider),
      data: (pets) {
        final active = pets.where((p) => !p.archived).toList();
        if (active.isEmpty) {
          return EmptyState(
            scene: Scene.welcomeCare,
            title: l.noPetsTitle,
            message: l.noPetsBody,
            actionLabel: l.addPet,
            onAction: () => context.push('/pets/new'),
          );
        }
        final wide = context.screenSize == ScreenSize.desktop && !easy;
        final s = homeSections(context, ref, pet: pet, pets: active, easy: easy, wide: wide);
        final now = DateTime.now();
        // The date, then the greeting, then the pet's doorway.
        final greeting = Padding(
          padding: const EdgeInsets.only(top: Space.sm, bottom: Space.lg + Space.xs),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              easy ? Fmt.weekdayDate(now, context.lang) : Fmt.weekdayDateLong(now, context.lang),
              style: context.text.bodySmall?.copyWith(color: context.paw.textSecondary),
            ),
            const SizedBox(height: Space.xs),
            Semantics(
              header: true,
              child: Text(
                '$greet${user?.firstName.isNotEmpty == true ? ', ${user!.firstName}' : ''}',
                style: wide ? context.text.displayLarge : context.text.displaySmall,
              ),
            ),
          ]),
        );
        final band = pet != null ? PetDayBand(pet: pet) : AllPetsCard(pets: active);

        if (!wide) {
          return PageBody(children: [...s.top, greeting, band, ...s.phoneOrder]);
        }
        Widget column(List<Widget> children) => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children);
        return PageBody(children: [
          ...s.top,
          greeting,
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(flex: 7, child: column([band, ...s.main])),
            const SizedBox(width: Space.xl),
            Expanded(flex: 5, child: column(s.side)),
          ]),
          // Food, the memory and nearby clinics share a row.
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            for (final (i, group) in s.below.where((g) => g.isNotEmpty).indexed) ...[
              if (i > 0) const SizedBox(width: Space.xl),
              Expanded(child: column(group)),
            ],
          ]),
        ]);
      },
    );
  }
}

/// The Genda band for one pet: its photo in the garland with one flower per
/// thing on today's plan (each walk, each meal, and play), the date, and
/// "2 of 4 done". Tapping it opens the pet's profile (the photo flies there).
class PetDayBand extends ConsumerWidget {
  const PetDayBand({super.key, required this.pet});
  final Pet pet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logs = ref.watch(petLogsProvider(pet.id)).value ?? const [];
    final p = TodayProgress(pet: pet, logs: logs);
    final plan = pet.dailyPlan;
    final walks = plan.walks.toInt(), meals = plan.meals.toInt();
    final total = walks + meals + (plan.playMinutes > 0 ? 1 : 0);
    final done = math.min(p.count(LogType.walk), walks) +
        math.min(p.count(LogType.meal), meals) +
        (plan.playMinutes > 0 && p.playMinutes >= plan.playMinutes ? 1 : 0);
    final archW = Sizes.garland * 104 / 148;
    final archH = archW * Sizes.archAspect;
    final photo = Hero(
      tag: 'pet-${pet.id}',
      child: pet.photoUrl != null
          ? MediaImage(url: pet.photoUrl!, width: archW, height: archH)
          : ColoredBox(
              color: PetTagColors.of(pet.colorTag).withValues(alpha: Opacities.half),
              child: Align(alignment: Alignment.bottomCenter, child: PetFace(species: pet.species, color: PetTagColors.of(pet.colorTag), size: archW)),
            ),
    );
    final l = context.l10n;
    // The next task still open today, for the note beside the band on wide
    // screens ("Next: walk").
    final open = p.items.where((i) => i.$2 < i.$3).toList();
    final next = open.isEmpty ? null : open.first;
    return GendaBand(
      petName: pet.name,
      photo: photo,
      done: done.toInt(),
      total: total,
      streakDays: streak(logs.map((g) => g.at), DateTime.now()),
      aside: next == null
          ? null
          : Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              Text(l.gendaNext(logTypeLabel(context, next.$1)), style: context.text.titleSmall?.copyWith(color: context.paw.onBand)),
              const SizedBox(height: Space.sm),
              FilledButton.icon(
                onPressed: () => showQuickLog(context, ref, pet),
                icon: const Icon(Ph.plus),
                label: Text(l.logSomething),
              ),
            ]),
      onTap: () => context.push('/pets/${pet.id}'),
    );
  }
}

/// "All pets" card: every pet's photo and name; tap one to switch to it.
class AllPetsCard extends ConsumerWidget {
  const AllPetsCard({super.key, required this.pets});
  final List<Pet> pets;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PawCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(context.l10n.allPets, style: context.text.titleLarge),
        const SizedBox(height: Space.md),
        Wrap(spacing: Space.md, runSpacing: Space.md, children: [
          for (final p in pets)
            Semantics(
              button: true,
              label: p.name,
              excludeSemantics: true,
              child: InkWell(
                borderRadius: BorderRadius.circular(Radii.md),
                onTap: () => ref.read(settingsProvider.notifier).selectPet(p.id),
                child: Padding(
                  padding: const EdgeInsets.all(Space.xs),
                  child: Column(children: [
                    PetAvatar(species: p.species, colorTag: p.colorTag, photoUrl: p.photoUrl, size: TapTarget.easy, name: p.name),
                    const SizedBox(height: Space.xs),
                    Text(p.name, style: context.text.labelMedium),
                  ]),
                ),
              ),
            ),
        ]),
      ]),
    );
  }
}
