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
import 'home_sections.dart';

/// Home (spec 5). Sections fill in as later phases land.
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
        return PageBody(children: [
          const SizedBox(height: Space.sm),
          Text('$greet${user?.firstName.isNotEmpty == true ? ', ${user!.firstName}' : ''}', style: context.text.headlineSmall),
          const SizedBox(height: Space.md),
          if (pet != null) PetHeroCard(pet: pet) else AllPetsCard(pets: active),
          ...homeSections(context, ref, pet: pet, pets: active, easy: easy),
        ]);
      },
    );
  }
}

/// Selected pet's card: photo, name, age, weight, colour tag.
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
    final tag = PetTagColors.of(pet.colorTag);
    return PawCard(
      onTap: () => context.push('/pets/${pet.id}'),
      semanticLabel: l.openPetProfile(pet.name),
      color: Color.alphaBlend(tag.withValues(alpha: 0.12), context.paw.surface),
      child: Row(children: [
        PetAvatar(
          species: pet.species,
          colorTag: pet.colorTag,
          photoUrl: pet.photoUrl,
          size: 76,
          heroTag: 'pet-${pet.id}',
          name: pet.name,
        ),
        const SizedBox(width: Space.lg),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(pet.name, style: context.text.titleLarge),
            const SizedBox(height: 2),
            Text(facts.join(' · '), style: context.text.bodySmall),
            const SizedBox(height: Space.sm),
            StatusChip(lifeStageLabel(context, pet), tone: ChipTone.info),
          ]),
        ),
        const Icon(Icons.chevron_right_rounded),
      ]),
    );
  }
}

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
            InkWell(
              borderRadius: BorderRadius.circular(Radii.card),
              onTap: () => ref.read(settingsProvider.notifier).selectPet(p.id),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Column(children: [
                  PetAvatar(species: p.species, colorTag: p.colorTag, photoUrl: p.photoUrl, size: 56, name: p.name),
                  const SizedBox(height: 4),
                  Text(p.name, style: context.text.labelMedium),
                ]),
              ),
            ),
        ]),
      ]),
    );
  }
}
