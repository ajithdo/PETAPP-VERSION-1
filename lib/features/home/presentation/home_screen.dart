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
import 'home_sections.dart';

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
        final greeting = Padding(
          padding: const EdgeInsets.only(top: Space.lg, bottom: Space.md),
          child: Semantics(
            header: true,
            child: Text(
              '$greet${user?.firstName.isNotEmpty == true ? ', ${user!.firstName}' : ''}',
              style: easy || wide ? context.text.headlineLarge : context.text.headlineMedium,
            ),
          ),
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
    final photoSize = Sizes.garland * Sizes.garlandPhotoShare;
    final photo = Hero(
      tag: 'pet-${pet.id}',
      child: pet.photoUrl != null
          ? MediaImage(url: pet.photoUrl!, width: photoSize, height: photoSize)
          : PetFace(species: pet.species, color: PetTagColors.of(pet.colorTag), size: photoSize),
    );
    return GendaBand(
      petName: pet.name,
      dateLabel: Fmt.weekdayDate(DateTime.now(), context.lang),
      photo: photo,
      done: done.toInt(),
      total: total,
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
