import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../core/routing/pet_links.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../data/pets_repository.dart';
import '../domain/pet.dart';
import 'archive_sheet.dart';
import 'pet_labels.dart';

/// Pet profile (spec 7.1): hero photo, quick stats, details, family, and
/// sections that later phases fill (Health, Routine, Documents, Memories).
class PetProfileScreen extends ConsumerWidget {
  const PetProfileScreen({super.key, required this.petId});
  final String petId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petAsync = ref.watch(petProvider(petId));
    return Scaffold(
      body: AsyncView<Pet?>(
        value: petAsync,
        onRetry: () => ref.invalidate(petProvider(petId)),
        data: (pet) {
          if (pet == null) {
            return Scaffold(
              appBar: AppBar(),
              body: EmptyState(
                scene: Scene.search,
                title: context.l10n.petNotFound,
                actionLabel: context.l10n.goHome,
                onAction: () => context.go('/home'),
              ),
            );
          }
          return _Profile(pet: pet);
        },
      ),
    );
  }
}

class _Profile extends ConsumerWidget {
  const _Profile({required this.pet});
  final Pet pet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final user = ref.watch(currentUserProvider)!;
    final tag = PetTagColors.of(pet.colorTag);
    final canEdit = pet.canEdit(user.uid);
    final myRole = pet.roleOf(user.uid);
    final age = petAgeLabel(context, pet);
    final weight = pet.weightKg == null ? '–' : Fmt.weight(pet.weightKg!, grams: pet.isBird);

    return CustomScrollView(slivers: [
      SliverAppBar(
        pinned: true,
        expandedHeight: 280,
        backgroundColor: Color.alphaBlend(tag.withValues(alpha: 0.18), context.paw.background),
        actions: [
          if (canEdit)
            IconButton(
              tooltip: l.editPet,
              icon: const Icon(Icons.edit_rounded),
              onPressed: () => context.push('/pets/${pet.id}/edit'),
            ),
          PopupMenuButton<String>(
            tooltip: l.moreOptions,
            onSelected: (v) async {
              switch (v) {
                case 'family':
                  context.push('/me/family?pet=${pet.id}');
                case 'archive':
                  await showArchiveSheet(context, ref, pet);
                case 'restore':
                  await ref.read(petsRepositoryProvider).restorePet(pet.id);
                case 'qr':
                  context.push(petQrLink(pet.id));
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(value: 'family', child: Text(l.familySharing)),
              if (!pet.archived) PopupMenuItem(value: 'qr', child: Text(l.qrTag)),
              if (pet.canDelete(user.uid) && !pet.archived) PopupMenuItem(value: 'archive', child: Text(l.archivePet)),
              if (pet.canDelete(user.uid) && pet.archived) PopupMenuItem(value: 'restore', child: Text(l.restorePet)),
            ],
          ),
        ],
        flexibleSpace: FlexibleSpaceBar(
          background: SafeArea(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SizedBox(height: 32),
              PetAvatar(
                species: pet.species,
                colorTag: pet.colorTag,
                photoUrl: pet.photoUrl,
                size: 132,
                heroTag: 'pet-${pet.id}',
                name: pet.name,
              ),
              const SizedBox(height: Space.md),
              Text(pet.name, style: context.text.headlineMedium),
              Text(
                [pet.breedName(context.lang), if (age.isNotEmpty) age].join(' · '),
                style: context.text.bodyMedium?.copyWith(color: context.paw.textSecondary),
              ),
            ]),
          ),
        ),
      ),
      SliverToBoxAdapter(
        child: ContentWidth(
          maxWidth: 900,
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            const SizedBox(height: Space.lg),
            if (pet.archived) ...[
              _MemorialBanner(pet: pet),
              const SizedBox(height: Space.lg),
            ],
            Wrap(spacing: Space.sm, runSpacing: Space.sm, children: [
              StatusChip(lifeStageLabel(context, pet), tone: ChipTone.info),
              StatusChip(petRoleLabel(context, myRole.name), tone: ChipTone.accent, icon: Icons.person_rounded),
              if (pet.flatFaced) StatusChip(l.flatFacedChip, tone: ChipTone.warning, icon: Icons.thermostat_rounded),
            ]),
            const SizedBox(height: Space.lg),
            ResponsiveGrid(minItemWidth: 150, children: [
              StatTile(label: l.age, value: age.isEmpty ? '–' : age, icon: Icons.cake_rounded),
              StatTile(label: l.weight, value: weight, icon: Icons.monitor_weight_rounded),
              StatTile(label: l.gender, value: genderLabel(context, pet.gender), icon: Icons.transgender_rounded),
              StatTile(label: l.neutered, value: pet.neutered ? l.yes : l.no, icon: Icons.health_and_safety_rounded),
            ]),
            SectionHeader(l.petCare),
            ResponsiveGrid(minItemWidth: 260, children: [
              for (final s in petSections(context, pet))
                PawCard(
                  onTap: () => context.push(s.route),
                  child: Row(children: [
                    CircleAvatar(
                      backgroundColor: s.color.withValues(alpha: 0.15),
                      child: Icon(s.icon, color: s.color),
                    ),
                    const SizedBox(width: Space.md),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(s.title, style: context.text.titleSmall),
                        Text(s.subtitle, style: context.text.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                      ]),
                    ),
                    const Icon(Icons.chevron_right_rounded),
                  ]),
                ),
            ]),
            SectionHeader(l.details),
            PawCard(
              padding: const EdgeInsets.symmetric(vertical: Space.sm),
              child: Column(children: [
                _row(context, Icons.palette_rounded, l.markings, pet.markings),
                _row(context, Icons.memory_rounded, l.microchip, pet.microchip),
                _row(context, Icons.no_food_rounded, l.allergies, pet.allergies.isEmpty ? null : pet.allergies.join(', ')),
                _row(context, Icons.restaurant_rounded, l.dietType, pet.dietType),
                _row(context, Icons.local_hospital_rounded, l.regularClinic, ref.watch(_clinicNameProvider(pet.clinicId)).value),
                _row(context, Icons.psychology_rounded, l.temperament, pet.temperament),
              ]),
            ),
            SectionHeader(l.family, action: l.manage, onAction: () => context.push('/me/family?pet=${pet.id}')),
            PawCard(
              padding: const EdgeInsets.symmetric(vertical: Space.sm),
              child: Column(children: [
                for (final e in pet.members.entries)
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: context.paw.primaryContainer,
                      child: Text(e.value.name.isEmpty ? '?' : e.value.name.characters.first),
                    ),
                    title: Text(e.value.name + (e.key == user.uid ? ' (${l.you})' : '')),
                    subtitle: e.value.expiresAt == null
                        ? null
                        : Text(l.accessUntil(Fmt.dateTime(e.value.expiresAt!, context.lang))),
                    trailing: StatusChip(petRoleLabel(context, e.value.role)),
                  ),
              ]),
            ),
            const SizedBox(height: Space.xxl),
          ]),
        ),
      ),
    ]);
  }

  Widget _row(BuildContext context, IconData icon, String label, String? value) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label, style: context.text.bodySmall),
      subtitle: Text(value == null || value.isEmpty ? context.l10n.notAdded : value, style: context.text.bodyLarge),
    );
  }
}

final _clinicNameProvider = FutureProvider.family<String?, String?>((ref, id) async {
  if (id == null) return null;
  final d = await ref.watch(firestoreProvider).collection('clinics').doc(id).get();
  return d.data()?['name'] as String?;
});

class _MemorialBanner extends StatelessWidget {
  const _MemorialBanner({required this.pet});
  final Pet pet;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final memorial = pet.memorial;
    return PawCard(
      color: context.paw.accent.withValues(alpha: 0.14),
      child: Row(children: [
        Icon(memorial ? Icons.favorite_rounded : Icons.home_rounded, color: context.paw.accent, size: 32),
        const SizedBox(width: Space.md),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(memorial ? l.inLovingMemory : l.rehomed, style: context.text.titleMedium),
            if (pet.birthday != null && pet.archivedAt != null)
              Text('${pet.birthday!.year} – ${pet.archivedAt!.year}', style: context.text.bodySmall),
            if (pet.memorialNote != null) ...[
              const SizedBox(height: Space.xs),
              Text(pet.memorialNote!, style: context.text.bodyMedium?.copyWith(fontStyle: FontStyle.italic)),
            ],
          ]),
        ),
      ]),
    );
  }
}
