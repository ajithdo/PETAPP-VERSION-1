import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/tokens.dart';
import '../../../core/widgets/widgets.dart';

/// Gentle upgrade prompt shown when a free-plan limit is reached.
Future<void> showPlusPrompt(BuildContext context, {required String title, required String body}) {
  return showPawSheet<void>(context, builder: (ctx) {
    final l = ctx.l10n;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Row(children: [
        Icon(Icons.workspace_premium_rounded, color: ctx.paw.accent, size: 32),
        const SizedBox(width: Space.md),
        Expanded(child: Text(title, style: ctx.text.titleMedium)),
      ]),
      const SizedBox(height: Space.md),
      Text(body, style: ctx.text.bodyMedium),
      const SizedBox(height: Space.lg),
      for (final perk in [l.plusPerkPets, l.plusPerkVideo, l.plusPerkAi, l.plusPerkStorage])
        Padding(
          padding: const EdgeInsets.only(bottom: Space.sm),
          child: Row(children: [
            Icon(Icons.check_circle_rounded, color: ctx.paw.success, size: 20),
            const SizedBox(width: Space.sm),
            Expanded(child: Text(perk)),
          ]),
        ),
      const SizedBox(height: Space.md),
      PrimaryButton(
        label: l.seePlus,
        icon: Icons.workspace_premium_rounded,
        onPressed: () {
          Navigator.pop(ctx);
          context.push('/me/plus');
        },
      ),
      const SizedBox(height: Space.sm),
      TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l.notNow)),
    ]);
  });
}
