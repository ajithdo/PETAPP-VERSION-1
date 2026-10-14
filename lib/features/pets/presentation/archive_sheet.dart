import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/settings/settings_controller.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/widgets.dart';
import '../data/pets_repository.dart';
import '../domain/pet.dart';

/// Archive a pet gently: passed away ("In loving memory") or rehomed.
/// Memories and records are kept.
Future<void> showArchiveSheet(BuildContext context, WidgetRef ref, Pet pet) async {
  String reason = 'passed_away';
  final note = TextEditingController();
  final done = await showPawSheet<bool>(context, builder: (ctx) {
    final l = ctx.l10n;
    return StatefulBuilder(builder: (ctx, setState) {
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(l.archiveTitle(pet.name), style: ctx.text.titleMedium),
        const SizedBox(height: Space.sm),
        Text(l.archiveBody, style: ctx.text.bodyMedium),
        const SizedBox(height: Space.lg),
        RadioGroup<String>(
          groupValue: reason,
          onChanged: (v) => setState(() => reason = v!),
          child: Column(children: [
            RadioListTile<String>(value: 'passed_away', title: Text(l.passedAway), subtitle: Text(l.passedAwayHint)),
            RadioListTile<String>(value: 'rehomed', title: Text(l.rehomed), subtitle: Text(l.rehomedHint)),
          ]),
        ),
        if (reason == 'passed_away')
          PawTextField(label: l.memorialNote, controller: note, maxLines: 3, hint: l.memorialNoteHint),
        const SizedBox(height: Space.sm),
        PrimaryButton(label: l.archivePet, onPressed: () => Navigator.pop(ctx, true)),
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
      ]);
    });
  });
  if (done != true) return;
  await ref.read(petsRepositoryProvider).archivePet(pet.id,
      reason: reason, note: note.text.trim().isEmpty ? null : note.text.trim());
  ref.read(settingsProvider.notifier).selectPet(null);
  if (context.mounted) {
    showToast(context, reason == 'passed_away' ? context.l10n.archivedMemorial(pet.name) : context.l10n.archivedRehomed(pet.name));
    context.go('/me/pets');
  }
}
