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

/// Round icon button (top bar bell, messages, share): a soft tonal circle
/// on the page (UI Design 6).
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
        backgroundColor: paw.surfaceSubtle,
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

/// Quick action (Home): a big tinted circle with the icon, and a short
/// label under it (UI Design 6). In Easy mode ([wide]) it becomes a white
/// card with the circle beside the label, so the words can be bigger.
class QuickActionTile extends StatelessWidget {
  const QuickActionTile({super.key, required this.icon, required this.label, required this.onTap, this.color, this.wide = false});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  /// Icon colour; defaults to marigold ink on a pale marigold circle.
  final Color? color;

  /// Easy mode: a card, circle on the left, label on the right.
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final paw = context.paw;
    final c = color ?? paw.onAccentContainer;
    final light = Theme.of(context).brightness == Brightness.light;
    final circle = Container(
      width: Sizes.thumb,
      height: Sizes.thumb,
      decoration: BoxDecoration(color: color == null ? paw.accentContainer : c.withValues(alpha: Opacities.chip), shape: BoxShape.circle),
      child: Icon(icon, color: c, size: IconSizes.lg),
    );
    final text = Text(label, textAlign: wide ? TextAlign.start : TextAlign.center, style: context.text.labelMedium, maxLines: 2, overflow: TextOverflow.ellipsis);
    final radius = BorderRadius.circular(Radii.card);
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: PressScale(
        child: DecoratedBox(
          decoration: BoxDecoration(borderRadius: radius, boxShadow: wide && light ? Shadows.card(paw.ink) : null),
          child: Material(
            color: wide ? paw.surface : Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: radius, side: wide && !light ? BorderSide(color: paw.outline) : BorderSide.none),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () {
                HapticFeedback.selectionClick();
                onTap();
              },
              child: Container(
                constraints: BoxConstraints(minHeight: wide ? Sizes.quickTileMin : 0),
                padding: EdgeInsets.all(wide ? Space.md : Space.xs),
                child: wide
                    ? Row(children: [circle, const SizedBox(width: Space.md), Expanded(child: text)])
                    : Column(mainAxisSize: MainAxisSize.min, children: [circle, const SizedBox(height: Space.sm), text]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A quiet text link ("See all", "Map", "Album"): ink text with a marigold
/// underline (UI Design 6). At least 48 px tall to tap.
class LinkButton extends StatelessWidget {
  const LinkButton({super.key, required this.label, required this.onPressed, this.textAlign});
  final String label;
  final VoidCallback? onPressed;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final paw = context.paw;
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(foregroundColor: paw.textPrimary, padding: const EdgeInsets.symmetric(horizontal: Space.sm)),
      child: Text(
        label,
        textAlign: textAlign,
        style: context.text.labelMedium?.copyWith(
          color: paw.textPrimary,
          decoration: TextDecoration.underline,
          decorationColor: paw.marigold,
          decorationThickness: 2,
        ),
      ),
    );
  }
}
