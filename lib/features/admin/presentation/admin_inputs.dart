import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/tokens.dart';
import '../../../core/widgets/widgets.dart';

/// Asks for a reason (reject, suspend). Returns null if cancelled.
Future<String?> askReason(BuildContext context, {required String title, List<String> quick = const []}) {
  final ctrl = TextEditingController();
  return showPawSheet<String>(context, builder: (ctx) {
    final l = ctx.l10n;
    return StatefulBuilder(builder: (ctx, setSheet) {
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(title, style: ctx.text.titleMedium),
        const SizedBox(height: Space.md),
        if (quick.isNotEmpty) ...[
          Wrap(spacing: Space.sm, runSpacing: Space.sm, children: [
            for (final q in quick)
              ActionChip(
                label: Text(q),
                onPressed: () => setSheet(() => ctrl.text = q),
              ),
          ]),
          const SizedBox(height: Space.md),
        ],
        PawTextField(label: l.admReasonLabel, controller: ctrl, maxLines: 3, onChanged: (_) => setSheet(() {})),
        const SizedBox(height: Space.md),
        PrimaryButton(
          label: l.confirm,
          onPressed: ctrl.text.trim().isEmpty ? null : () => Navigator.pop(ctx, ctrl.text.trim()),
        ),
        const SizedBox(height: Space.sm),
        TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l.cancel)),
      ]);
    });
  });
}

/// Asks for a whole number (prices, limits, percentages). Returns null if
/// cancelled; with [allowEmpty], an empty box returns -1 (use the default).
Future<int?> askNumber(BuildContext context, {required String title, int? initial, String? suffix, String? helper, bool allowEmpty = false, int max = 10000000}) {
  final ctrl = TextEditingController(text: initial?.toString() ?? '');
  return showPawSheet<int>(context, builder: (ctx) {
    final l = ctx.l10n;
    return StatefulBuilder(builder: (ctx, setSheet) {
      final v = int.tryParse(ctrl.text.trim());
      final ok = (v != null && v >= 0 && v <= max) || (allowEmpty && ctrl.text.trim().isEmpty);
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(title, style: ctx.text.titleMedium),
        const SizedBox(height: Space.md),
        PawTextField(
          label: title,
          controller: ctrl,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          suffix: suffix == null ? null : Text(suffix),
          helper: helper,
          autofocus: true,
          onChanged: (_) => setSheet(() {}),
        ),
        const SizedBox(height: Space.md),
        PrimaryButton(label: l.save, onPressed: ok ? () => Navigator.pop(ctx, v ?? -1) : null),
        const SizedBox(height: Space.sm),
        TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l.cancel)),
      ]);
    });
  });
}
