import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/tokens.dart';

/// The one main action on a screen.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
    this.expand = true,
    this.danger = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool loading;
  final bool expand;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final style = danger
        ? FilledButton.styleFrom(backgroundColor: context.paw.error, foregroundColor: Colors.white)
        : null;
    final child = loading
        ? SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2.5, color: context.colors.onPrimary),
          )
        : Text(label, textAlign: TextAlign.center);
    final onTap = loading || onPressed == null
        ? null
        : () {
            HapticFeedback.lightImpact();
            onPressed!();
          };
    final btn = icon != null && !loading
        ? FilledButton.icon(onPressed: onTap, icon: Icon(icon), label: child, style: style)
        : FilledButton(onPressed: onTap, style: style, child: child);
    return expand ? SizedBox(width: double.infinity, child: btn) : btn;
  }
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({super.key, required this.label, required this.onPressed, this.icon, this.expand = true});
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final btn = icon != null
        ? OutlinedButton.icon(onPressed: onPressed, icon: Icon(icon), label: Text(label))
        : OutlinedButton(onPressed: onPressed, child: Text(label));
    return expand ? SizedBox(width: double.infinity, child: btn) : btn;
  }
}

/// Big square quick-action tile (Home quick actions, Easy mode).
class QuickActionTile extends StatelessWidget {
  const QuickActionTile({super.key, required this.icon, required this.label, required this.onTap, this.color});
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? context.colors.primary;
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: context.paw.surface,
        borderRadius: BorderRadius.circular(Radii.card),
        child: InkWell(
          borderRadius: BorderRadius.circular(Radii.card),
          onTap: () {
            HapticFeedback.selectionClick();
            onTap();
          },
          child: Container(
            constraints: const BoxConstraints(minHeight: 96),
            padding: const EdgeInsets.all(Space.md),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Radii.card),
              border: Border.all(color: context.paw.outline),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: c.withValues(alpha: 0.12), shape: BoxShape.circle),
                  child: Icon(icon, color: c, size: 26),
                ),
                const SizedBox(height: Space.sm),
                Text(label,
                    textAlign: TextAlign.center,
                    style: context.text.labelMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
