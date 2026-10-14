import 'package:flutter/material.dart';

import '../../features/pets/domain/pet.dart';
import '../theme/tokens.dart';
import '../widgets/layout.dart';

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

String _soon(int phase, String title) => '/coming-soon?phase=$phase&title=${Uri.encodeComponent(title)}';

List<PetSection> petSections(BuildContext context, Pet pet) {
  final l = context.l10n;
  return [
    PetSection(Icons.favorite_rounded, l.tabHealth, l.petSectionHealth, _soon(4, l.tabHealth), context.paw.error),
    PetSection(Icons.directions_walk_rounded, l.routine, l.petSectionRoutine, '/pets/${pet.id}/routine', context.colors.primary),
    PetSection(Icons.lock_rounded, l.documentVault, l.petSectionDocs, _soon(7, l.documentVault), context.paw.warning),
    PetSection(Icons.photo_library_rounded, l.memoryAlbum, l.petSectionMemories, _soon(7, l.memoryAlbum), context.paw.accent),
  ];
}

String petQrLink(String petId) => _soon(9, 'QR');
