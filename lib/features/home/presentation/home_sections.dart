import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/tokens.dart';
import '../../../core/widgets/widgets.dart';
import '../../pets/domain/pet.dart';

/// Home sections after the pet card, in spec order: Today, Next up, quick
/// actions, walk-weather tip, food running low, latest memory.
List<Widget> homeSections(BuildContext context, WidgetRef ref,
    {required Pet? pet, required List<Pet> pets, required bool easy}) {
  final l = context.l10n;
  return [
    SectionHeader(l.quickActions),
    GridView.count(
      crossAxisCount: context.isPhone ? 2 : 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: Space.md,
      crossAxisSpacing: Space.md,
      childAspectRatio: easy ? 1.2 : 1.5,
      children: [
        QuickActionTile(icon: Icons.medical_services_rounded, label: l.qaBookVet, onTap: () => context.go('/book')),
        QuickActionTile(icon: Icons.directions_walk_rounded, label: l.qaLogWalk, onTap: () => context.push('/coming-soon?phase=3&title=${l.qaLogWalk}')),
        QuickActionTile(icon: Icons.support_agent_rounded, label: l.qaAskVet, onTap: () => context.push('/coming-soon?phase=6&title=${l.qaAskVet}')),
        QuickActionTile(icon: Icons.add_a_photo_rounded, label: l.qaAddPhoto, color: context.paw.accent, onTap: () => context.push('/coming-soon?phase=7&title=${l.qaAddPhoto}')),
      ],
    ),
  ];
}
