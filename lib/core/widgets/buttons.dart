import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/tokens.dart';
import 'layout.dart';

/// Red for destructive buttons with white text: the dark theme's error red
/// is too light for white text (2.8:1), so it uses the deeper SOS red.
/// Fill of a destructive button (delete, cancel booking): berry, never red.
/// SOS is the only red in the app.
Color dangerColor(BuildContext context) => context.paw.error;

/// Text and icons on [dangerColor].
Color onDangerColor(BuildContext context) => Theme.of(context).brightness == Brightness.light ? context.paw.surface : context.paw.errorContainer;

/// Shrinks its child slightly while pressed (UI Design 2 "tap" motion).
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
      child: AnimatedScale(scale: _down ? Motion.pressScale : 1, duration: Motion.tap, curve: Motion.standard, child: widget.child),
    );
  }
}

/// The one main action on a screen (cocoa, marigold in dark mode; pill shaped).
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({super.key, required this.label, required this.onPressed, this.icon, this.loading = false, this.expand = true, this.danger = false});

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool loading;
  final bool expand;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final paw = context.paw;
    final onDanger = onDangerColor(context);
    final style = danger ? FilledButton.styleFrom(backgroundColor: dangerColor(context), foregroundColor: onDanger, iconColor: onDanger) : null;
    final child = loading
        ? SizedBox(
            width: IconSizes.md,
            height: IconSizes.md,
            child: CircularProgressIndicator(strokeWidth: Strokes.spinner, color: danger ? onDanger : paw.onAction),
          )
        // A button label never wraps (DESIGN.md): it shrinks to fit instead.
        : FittedBox(fit: BoxFit.scaleDown, child: Text(label, textAlign: TextAlign.center, maxLines: 1));
    final onTap = loading || onPressed == null
        ? null
        : () {
            HapticFeedback.lightImpact();
            onPressed!();
          };
    final btn = icon != null && !loading
        ? FilledButton.icon(
            onPressed: onTap,
            icon: Icon(icon, size: IconSizes.md),
            label: child,
            style: style,
          )
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
        ? OutlinedButton.icon(
            onPressed: onPressed,
            icon: Icon(icon, size: IconSizes.md),
            label: FittedBox(fit: BoxFit.scaleDown, child: Text(label, maxLines: 1)),
          )
        : OutlinedButton(onPressed: onPressed, child: FittedBox(fit: BoxFit.scaleDown, child: Text(label, maxLines: 1)));
    return PressScale(
      enabled: onPressed != null,
      child: expand ? SizedBox(width: double.infinity, child: btn) : btn,
    );
  }
}

/// Round icon button (top bar bell, messages, share): a white circle on the
/// page, with a hairline edge in dark mode.
class PawIconButton extends StatelessWidget {
  const PawIconButton({super.key, required this.icon, required this.tooltip, required this.onPressed, this.badge});
  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  /// Unread count shown as a cocoa badge (hidden when 0). Never red.
  final int? badge;

  @override
  Widget build(BuildContext context) {
    final paw = context.paw;
    final n = badge ?? 0;
    // Screen readers hear the unread count too ("Messages, 2 unread").
    return IconButton(
      tooltip: n > 0 ? context.l10n.withUnread(tooltip, n) : tooltip,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: paw.surface,
        side: Theme.of(context).brightness == Brightness.light ? BorderSide.none : BorderSide(color: paw.outline),
        shape: const CircleBorder(),
        // A 40 px circle with a full 48 px tap area around it.
        minimumSize: const Size.square(TapTarget.min - Space.sm),
        fixedSize: const Size.square(TapTarget.min - Space.sm),
        tapTargetSize: MaterialTapTargetSize.padded,
      ),
      icon: Badge.count(
        count: n,
        isLabelVisible: n > 0,
        child: Icon(icon, size: IconSizes.md),
      ),
    );
  }
}

/// Big quick-action tile (Home quick actions, Easy mode): an icon in a pale
/// marigold circle above a short label, on a white card (warm register).
class QuickActionTile extends StatelessWidget {
  const QuickActionTile({super.key, required this.icon, required this.label, required this.onTap, this.color});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  /// Icon colour; defaults to marigold ink on a pale marigold circle.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final paw = context.paw;
    final c = color ?? paw.onAccentContainer;
    final radius = BorderRadius.circular(Radii.card);
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: PressScale(
        child: DecoratedBox(
          decoration: BoxDecoration(borderRadius: radius, boxShadow: Theme.of(context).brightness == Brightness.light ? Shadows.card(paw.ink) : null),
          child: Material(
            color: paw.surface,
            shape: RoundedRectangleBorder(
              borderRadius: radius,
              side: Theme.of(context).brightness == Brightness.light ? BorderSide.none : BorderSide(color: paw.outline),
            ),
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
                        color: color == null ? paw.accentContainer : c.withValues(alpha: Opacities.tint),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: c, size: IconSizes.lg),
                    ),
                    const SizedBox(height: Space.sm),
                    Text(label, textAlign: TextAlign.center, style: context.text.labelMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
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
