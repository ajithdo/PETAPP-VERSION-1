import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../core/routing/extra_routes.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../admin/admin_slots.dart' show meItemVisible;
import '../../pets/data/pets_repository.dart';
import '../../pets/presentation/pet_labels.dart';

/// "Me" tab: everything about the owner's account and pets (spec 5).
class MeScreen extends ConsumerWidget {
  const MeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final user = ref.watch(currentUserProvider);
    final items = meMenu(context).where((m) => meItemVisible(ref, m.route)).toList();
    final pets = ref.watch(activePetsProvider);
    return PageBody(children: [
      const SizedBox(height: Space.sm),
      // Account card: initials in a cocoa circle, the name and plan, where
      // you are, and your pets.
      PawCard(
        padding: const EdgeInsets.all(Space.lg),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          CircleAvatar(
            radius: Sizes.heroAvatar / 2,
            backgroundColor: context.paw.brand,
            child: Text(
              initials(user?.name ?? ''),
              style: context.text.headlineSmall?.copyWith(color: context.paw.onBrand),
            ),
          ),
          const SizedBox(width: Space.lg),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Wrap(spacing: Space.sm, runSpacing: Space.xs, crossAxisAlignment: WrapCrossAlignment.center, children: [
                Text(user?.name.isNotEmpty == true ? user!.name : l.petParent, style: context.text.headlineSmall),
                StatusChip(user?.isPlus == true ? l.planPlus : l.planFree, tone: user?.isPlus == true ? ChipTone.accent : ChipTone.neutral),
              ]),
              const SizedBox(height: Space.xxs),
              // One fact per line: no "Bengaluru ·" left hanging.
              for (final line in [?user?.city, user?.email ?? user?.phone].whereType<String>().where((x) => x.isNotEmpty))
                Text(line, style: context.text.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
              if (pets.isNotEmpty) ...[
                const SizedBox(height: Space.xs),
                Text(
                  '${l.myPets}: ${pets.map((p) => '${p.name} (${speciesLabel(context, p.species)})').join(', ')}',
                  style: context.text.bodySmall,
                ),
              ],
            ]),
          ),
        ]),
      ),
      // The menu in three short groups instead of one long list.
      for (final (g, title) in [(0, l.meGroupPets), (1, l.meGroupMoney), (2, l.meGroupHelp)])
        if (items.any((m) => m.group == g)) ...[
          SectionHeader(title),
          _MenuCard(items: items.where((m) => m.group == g).toList()),
        ],
      const SizedBox(height: Space.lg),
      SecondaryButton(
        label: l.signOut,
        icon: Icons.logout_outlined,
        onPressed: () async {
          final ok = await confirmAction(context, title: l.signOutConfirm, danger: false, confirmLabel: l.signOut);
          if (ok) await ref.read(authServiceProvider).signOut();
        },
      ),
    ]);
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({required this.items});
  final List<MeMenuItem> items;

  @override
  Widget build(BuildContext context) {
    final paw = context.paw;
    return PawCard(
      padding: EdgeInsets.zero,
      child: Column(children: [
        for (var i = 0; i < items.length; i++) ...[
          ListTile(
            leading: CircleAvatar(
              radius: Sizes.avatarSm / 2,
              backgroundColor: paw.surfaceSubtle,
              child: Icon(items[i].icon, color: paw.textPrimary, size: IconSizes.md),
            ),
            title: Text(items[i].label),
            trailing: Icon(Icons.chevron_right_rounded, color: paw.textSecondary),
            onTap: () => context.push(items[i].route),
          ),
          if (i < items.length - 1) const Divider(indent: Space.lg + Sizes.avatarSm + Space.lg, height: Strokes.hairline),
        ],
      ]),
    );
  }
}
