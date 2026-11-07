import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/tokens.dart';

/// Red for destructive buttons with white text: the dark theme's error red
/// is too light for white text (2.8:1), so it uses the deeper SOS red.
Color dangerColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light ? context.paw.error : context.paw.sos;

/// Shrinks its child slightly while pressed (Design 2 "tap" motion).
/// Does nothing when the system asks for reduced motion.
class PressScale extends StatefulWidget {
  const PressScale({super.key, required this.child, this.enabled = true});
  final Widget child;
  final bool enabled;

  @override
  State<PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<PressScale> {
  bool _down = false;

  void _set(bool v) {
    if (_down != v && mounted) setState(() => _down = v);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled || MediaQuery.of(context).disableAnimations) return widget.child;
    return Listener(
      onPointerDown: (_) => _set(true),
      onPointerUp: (_) => _set(false),
      onPointerCancel: (_) => _set(false),
      child: AnimatedScale(
        scale: _down ? Motion.pressScale : 1,
        duration: Motion.tap,
        curve: Motion.standard,
        child: widget.child,
      ),
    );
  }
}

/// The one main action on a screen (terracotta coral, pill shaped).
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
    final paw = context.paw;
    final style = danger ? FilledButton.styleFrom(backgroundColor: dangerColor(context), foregroundColor: paw.onSos, iconColor: paw.onSos) : null;
    final child = loading
        ? SizedBox(
            width: IconSizes.md,
            height: IconSizes.md,
            child: CircularProgressIndicator(strokeWidth: Strokes.spinner, color: danger ? paw.onSos : paw.onAction),
          )
        : Text(label, textAlign: TextAlign.center);
    final onTap = loading || onPressed == null
        ? null
        : () {
            HapticFeedback.lightImpact();
            onPressed!();
          };
    final btn = icon != null && !loading
        ? FilledButton.icon(onPressed: onTap, icon: Icon(icon, size: IconSizes.md), label: child, style: style)
        : FilledButton(onPressed: onTap, style: style, child: child);
    return PressScale(
      enabled: onTap != null,
      child: expand ? SizedBox(width: double.infinity, child: btn) : btn,
    );
  }
}

/// A quieter action next to the primary one (white pill with a border).
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({super.key, required this.label, required this.onPressed, this.icon, this.expand = true});
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final btn = icon != null
        ? OutlinedButton.icon(onPressed: onPressed, icon: Icon(icon, size: IconSizes.md), label: Text(label))
        : OutlinedButton(onPressed: onPressed, child: Text(label));
    return PressScale(
      enabled: onPressed != null,
      child: expand ? SizedBox(width: double.infinity, child: btn) : btn,
    );
  }
}

/// Round icon button with a warm border (top bar bell, messages, share).
class PawIconButton extends StatelessWidget {
  const PawIconButton({super.key, required this.icon, required this.tooltip, required this.onPressed, this.badge});
  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  /// Unread count shown as a red badge (hidden when 0).
  final int? badge;

  @override
  Widget build(BuildContext context) {
    final paw = context.paw;
    final n = badge ?? 0;
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: paw.surface,
        side: BorderSide(color: paw.outline),
        shape: const CircleBorder(),
        // A 40 px circle with a full 48 px tap area around it.
        minimumSize: const Size.square(TapTarget.min - Space.sm),
        fixedSize: const Size.square(TapTarget.min - Space.sm),
        tapTargetSize: MaterialTapTargetSize.padded,
      ),
      icon: Badge.count(count: n, isLabelVisible: n > 0, child: Icon(icon, size: IconSizes.md)),
    );
  }
}

/// Big quick-action tile (Home quick actions, Easy mode): an icon in a soft
/// circle above a short label, on a white card.
class QuickActionTile extends StatelessWidget {
  const QuickActionTile({super.key, required this.icon, required this.label, required this.onTap, this.color});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  /// Icon colour; defaults to the brand teal.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final paw = context.paw;
    final c = color ?? paw.brand;
    final radius = BorderRadius.circular(Radii.card);
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: PressScale(
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: radius,
            boxShadow: Theme.of(context).brightness == Brightness.light ? Shadows.card(paw.ink) : null,
          ),
          child: Material(
            color: paw.surface,
            shape: RoundedRectangleBorder(borderRadius: radius, side: BorderSide(color: paw.outline)),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () {
                HapticFeedback.selectionClick();
                onTap();
              },
              child: Container(
                constraints: const BoxConstraints(minHeight: Sizes.quickTileMin),
                padding: const EdgeInsets.all(Space.md),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(Space.sm + Space.xxs),
                      decoration: BoxDecoration(
                        color: color == null ? paw.primaryContainer : c.withValues(alpha: Opacities.tint),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: c, size: IconSizes.lg),
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
        ),
      ),
    );
  }
}
