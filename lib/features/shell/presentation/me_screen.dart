import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../core/routing/extra_routes.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/widgets.dart';

/// "Me" tab: everything about the owner's account and pets (spec 5).
class MeScreen extends ConsumerWidget {
  const MeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final user = ref.watch(currentUserProvider);
    final items = meMenu(context);
    return PageBody(children: [
      const SizedBox(height: Space.sm),
      PawCard(
        child: Row(children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: context.paw.primaryContainer,
            child: Text(
              (user?.name.isNotEmpty ?? false) ? user!.name.characters.first.toUpperCase() : '?',
              style: context.text.titleLarge?.copyWith(color: context.colors.primary),
            ),
          ),
          const SizedBox(width: Space.lg),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(user?.name.isNotEmpty == true ? user!.name : l.petParent, style: context.text.titleMedium),
              Text(user?.email ?? user?.phone ?? '', style: context.text.bodySmall),
            ]),
          ),
          StatusChip(user?.isPlus == true ? l.planPlus : l.planFree,
              tone: user?.isPlus == true ? ChipTone.accent : ChipTone.neutral),
        ]),
      ),
      const SizedBox(height: Space.lg),
      PawCard(
        padding: EdgeInsets.zero,
        child: Column(children: [
          for (var i = 0; i < items.length; i++) ...[
            ListTile(
              leading: Icon(items[i].icon, color: context.colors.primary),
              title: Text(items[i].label),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.push(items[i].route),
            ),
            if (i < items.length - 1) const Divider(indent: 56),
          ],
        ]),
      ),
      const SizedBox(height: Space.lg),
      SecondaryButton(
        label: l.signOut,
        icon: Icons.logout_rounded,
        onPressed: () async {
          final ok = await confirmAction(context, title: l.signOutConfirm, danger: false, confirmLabel: l.signOut);
          if (ok) await ref.read(authServiceProvider).signOut();
        },
      ),
    ]);
  }
}
