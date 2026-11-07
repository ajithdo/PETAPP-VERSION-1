import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../core/settings/settings_controller.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/widgets.dart';
import '../../pets/data/pets_repository.dart';
import '../../pets/domain/pet.dart';
import '../../pets/presentation/pet_labels.dart';
import 'home_discovery.dart';
import 'home_sections.dart';

/// Home (spec 5), UI Design 2: greeting, the pet card, today's plan, what's due
/// next and quick actions. One column on phones and in Easy mode; on desktop
/// the day sits on the left and "Next up" and tips on the right.
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
        final s = homeSections(context, ref, pet: pet, pets: active, easy: easy);
        // Outside Easy mode Home opens with the UI Design 2 "explore" top
        // (search, quick links, health status, nearest vets); the pet's day
        // follows under the greeting.
        final discovery = easy ? const <Widget>[] : homeDiscoveryTop(context, ref, pet: pet, pets: active, wide: wide);
        final greeting = Padding(
          padding: EdgeInsets.only(top: easy ? Space.md : Space.xl, bottom: Space.lg),
          child: Semantics(
            header: true,
            child: Text(
              '$greet${user?.firstName.isNotEmpty == true ? ', ${user!.firstName}' : ''}',
              style: easy ? context.text.headlineMedium : context.text.headlineSmall,
            ),
          ),
        );
        final petCard = pet != null ? PetHeroCard(pet: pet) : AllPetsCard(pets: active);

        if (!wide) {
          return PageBody(children: [...s.top, ...discovery, greeting, petCard, ...s.phoneOrder]);
        }
        Widget column(List<Widget> children) =>
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children);
        return PageBody(children: [
          ...s.top,
          ...discovery,
          greeting,
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(flex: 7, child: column([petCard, ...s.main])),
            const SizedBox(width: Space.xl),
            Expanded(flex: 5, child: column(s.side)),
          ]),
        ]);
      },
    );
  }
}

/// Selected pet's card: photo, name, breed, age, weight and life stage.
class PetHeroCard extends StatelessWidget {
  const PetHeroCard({super.key, required this.pet});
  final Pet pet;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final facts = [
      pet.breedName(context.lang),
      petAgeLabel(context, pet),
      if (pet.weightKg != null) l.weightValue(pet.isBird ? '${(pet.weightKg! * 1000).round()} g' : '${pet.weightKg!.toStringAsFixed(1)} kg'),
    ].where((s) => s.isNotEmpty).toList();
    return PawCard(
      onTap: () => context.push('/pets/${pet.id}'),
      semanticLabel: l.openPetProfile(pet.name),
      child: Row(children: [
        PetAvatar(
          species: pet.species,
          colorTag: pet.colorTag,
          photoUrl: pet.photoUrl,
          size: Sizes.heroAvatar,
          heroTag: 'pet-${pet.id}',
          name: pet.name,
        ),
        const SizedBox(width: Space.lg),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(pet.name, style: context.text.titleLarge),
            const SizedBox(height: Space.xxs),
            Text(facts.join(' · '), style: context.text.bodySmall),
            const SizedBox(height: Space.sm),
            StatusChip(lifeStageLabel(context, pet), tone: ChipTone.info),
          ]),
        ),
        Icon(Icons.chevron_right_outlined, color: context.paw.textSecondary),
      ]),
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
        Text(context.l10n.allPets, style: context.text.titleMedium),
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
