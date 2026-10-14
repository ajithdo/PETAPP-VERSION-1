import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import 'layout.dart';

/// The clear "Demo" dialog shown instead of calling a real service.
Future<void> showDemoDialog(BuildContext context, {required String title, required String body}) {
  return showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      icon: Icon(Icons.science_rounded, color: ctx.paw.accent, size: 32),
      title: Text(title),
      content: Text(body),
      actions: [FilledButton(onPressed: () => Navigator.pop(ctx), child: Text(ctx.l10n.ok))],
    ),
  );
}

/// Asks before anything destructive. Always used in Easy mode, and for
/// deletes everywhere.
Future<bool> confirmAction(
  BuildContext context, {
  required String title,
  String? body,
  String? confirmLabel,
  bool danger = true,
}) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: body == null ? null : Text(body),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(ctx.l10n.cancel)),
        FilledButton(
          style: danger ? FilledButton.styleFrom(backgroundColor: ctx.paw.error, foregroundColor: Colors.white) : null,
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(confirmLabel ?? ctx.l10n.confirm),
        ),
      ],
    ),
  );
  return ok ?? false;
}

void showToast(BuildContext context, String message, {String? actionLabel, VoidCallback? onAction}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text(message),
      action: actionLabel == null ? null : SnackBarAction(label: actionLabel, onPressed: onAction ?? () {}),
    ));
}

/// Standard bottom sheet with 28 px top corners and safe padding.
Future<T?> showPawSheet<T>(BuildContext context, {required Widget Function(BuildContext) builder, bool scroll = true}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    constraints: const BoxConstraints(maxWidth: 640),
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(ctx).bottom),
      child: scroll
          ? SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(Space.lg, 0, Space.lg, Space.xl),
              child: builder(ctx),
            )
          : builder(ctx),
    ),
  );
}
