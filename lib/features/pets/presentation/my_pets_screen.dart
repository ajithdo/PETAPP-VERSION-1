import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/widgets.dart';
import '../data/pets_repository.dart';
import '../domain/pet.dart';
import 'pet_labels.dart';

/// All my pets, with archived pets under "In loving memory".
class MyPetsScreen extends ConsumerWidget {
  const MyPetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final user = ref.watch(currentUserProvider);
    final limit = (ref.watch(planLimitsProvider)['pets'] as num?)?.toInt() ?? 3;
    return Scaffold(
      appBar: AppBar(title: Text(l.myPets)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/pets/new'),
        icon: const Icon(Icons.add_rounded),
        label: Text(l.addPet),
      ),
      body: AsyncView(
        value: ref.watch(myPetsProvider),
        data: (pets) {
          final active = pets.where((p) => !p.archived).toList();
          final memorial = pets.where((p) => p.archived).toList();
          final owned = active.where((p) => p.ownerId == user?.uid).length;
          if (pets.isEmpty) {
            return EmptyState(
              scene: Scene.welcomeCare,
              title: l.noPetsTitle,
              message: l.noPetsBody,
              actionLabel: l.addPet,
              onAction: () => context.push('/pets/new'),
            );
          }
          return PageBody(children: [
            if (!(user?.isPlus ?? false))
              Padding(
                padding: const EdgeInsets.only(top: Space.sm),
                child: InfoNote(l.petsUsed(owned, limit), icon: Icons.workspace_premium_rounded),
              ),
            const SizedBox(height: Space.md),
            ResponsiveGrid(minItemWidth: 300, children: [for (final p in active) _PetTile(pet: p, uid: user?.uid ?? '')]),
            if (memorial.isNotEmpty) ...[
              SectionHeader(l.inLovingMemory),
              ResponsiveGrid(minItemWidth: 300, children: [for (final p in memorial) _PetTile(pet: p, uid: user?.uid ?? '')]),
            ],
            const SizedBox(height: 80),
          ]);
        },
      ),
    );
  }
}

class _PetTile extends StatelessWidget {
  const _PetTile({required this.pet, required this.uid});
  final Pet pet;
  final String uid;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final role = pet.roleOf(uid);
    return PawCard(
      onTap: () => context.push('/pets/${pet.id}'),
      color: pet.archived ? context.paw.surface.withValues(alpha: 0.8) : null,
      child: Row(children: [
        Opacity(
          opacity: pet.archived ? 0.75 : 1,
          child: PetAvatar(species: pet.species, colorTag: pet.colorTag, photoUrl: pet.photoUrl, size: 60, name: pet.name),
        ),
        const SizedBox(width: Space.md),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(pet.name, style: context.text.titleMedium),
            Text(
              pet.archived
                  ? (pet.memorial ? l.inLovingMemory : l.rehomed)
                  : [pet.breedName(context.lang), petAgeLabel(context, pet)].where((s) => s.isNotEmpty).join(' · '),
              style: context.text.bodySmall,
            ),
            if (role != PetRole.owner) ...[
              const SizedBox(height: Space.xs),
              StatusChip(l.sharedWithYou(petRoleLabel(context, role.name)), tone: ChipTone.info),
            ],
          ]),
        ),
        Icon(pet.archived ? Icons.favorite_rounded : Icons.chevron_right_rounded,
            color: pet.archived ? context.paw.accent : null),
      ]),
    );
  }
}
