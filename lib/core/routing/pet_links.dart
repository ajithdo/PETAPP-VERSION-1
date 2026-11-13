import 'package:flutter/material.dart';

import '../../features/pets/domain/pet.dart';
import '../../features/vault/vault_slots.dart';

export '../../features/sos/sos_slots.dart' show petQrLink;
import '../theme/tokens.dart';
import '../widgets/layout.dart';
import '../theme/ph.dart';

/// Links from a pet's profile to the per-pet sections. Each later phase
/// replaces its coming-soon link with the real screen.
class PetSection {
  const PetSection(this.icon, this.title, this.subtitle, this.route, this.color);
  final IconData icon;
  final String title;
  final String subtitle;
  final String route;
  final Color color;
}

List<PetSection> petSections(BuildContext context, Pet pet) {
  final l = context.l10n;
  return [
    // Red stays for emergencies (UI Design 2), so Health uses the brand teal.
    PetSection(Ph.heart, l.tabHealth, l.petSectionHealth, '/health?pet=${pet.id}', context.paw.brand),
    PetSection(Ph.personSimpleWalk, l.routine, l.petSectionRoutine, '/pets/${pet.id}/routine', context.paw.success),
    PetSection(Ph.lockKey, l.documentVault, l.petSectionDocs, petVaultLink(pet.id), context.paw.accent),
    PetSection(Ph.images, l.memoryAlbum, l.petSectionMemories, petAlbumLink(pet.id), readableOn(CategoryColors.rose, [context.paw.surface], ratio: 3)),
  ];
}
