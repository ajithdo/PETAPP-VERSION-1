import 'package:flutter/material.dart';

import '../theme/ph.dart';
import '../theme/tokens.dart';
import 'buttons.dart';

/// The small building blocks of UI Design 6 "Toran", one for each piece of
/// the design kit (docs/design-proposals/2026-11-10-toran-redesign/source):
/// panel, wash, tile, tag, chip, list row, small button, level bar.

/// The colour families the design tints things with.
enum Tone { neutral, gold, green, red, sky, ink, marigold }

/// Fill and ink for a [Tone] (the kit's "-wash" and "-ink" pairs).
({Color fill, Color ink}) toneColors(BuildContext context, Tone tone) {
  final paw = context.paw;
  final tint = context.tint;
  return switch (tone) {
    Tone.neutral => (fill: paw.surfaceSubtle, ink: paw.textPrimary),
    Tone.gold => (fill: paw.accentContainer, ink: paw.accent),
    Tone.green => (fill: paw.successContainer, ink: paw.success),
    Tone.red => (fill: paw.sosContainer, ink: paw.error),
    Tone.sky => (fill: tint.skyWash, ink: tint.sky),
    Tone.ink => (fill: paw.textPrimary, ink: paw.background),
    Tone.marigold => (fill: paw.marigold, ink: paw.onMarigold),
  };
}

/// A hairline-edged panel: groups rows without the weight of a white card.
class PawPanel extends StatelessWidget {
  const PawPanel({super.key, required this.child, this.padding = const EdgeInsets.all(Space.lg), this.onTap, this.semanticLabel});
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final String? semanticLabel;

  /// Padding for a panel that holds a [PawList] (rows bring their own space).
  static const EdgeInsets listPadding = EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.xs + Space.xxs);

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.card), side: BorderSide(color: context.paw.outline));
    final body = Padding(padding: padding, child: child);
    final panel = Material(
      type: MaterialType.transparency,
      shape: shape,
      clipBehavior: Clip.antiAlias,
      child: onTap == null ? body : InkWell(onTap: onTap, child: body),
    );
    if (semanticLabel == null) return panel;
    return Semantics(label: semanticLabel, button: onTap != null, child: panel);
  }
}

/// A tinted panel (marigold by default): tips, low food, the weather.
class Wash extends StatelessWidget {
  const Wash({super.key, required this.child, this.tone = Tone.gold, this.padding = const EdgeInsets.all(Space.lg), this.onTap});
  final Widget child;
  final Tone tone;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final body = Padding(padding: padding, child: child);
    return Material(
      color: toneColors(context, tone).fill,
      borderRadius: BorderRadius.circular(Radii.card),
      clipBehavior: Clip.antiAlias,
      child: onTap == null ? body : InkWell(onTap: onTap, child: body),
    );
  }
}

/// A rounded tile for a place, a thing or a feature: an icon on a tint, or a
/// picture ([child]) clipped to the tile. [round] makes it a circle (quick
/// actions, categories).
class PawTile extends StatelessWidget {
  const PawTile({super.key, this.icon, this.child, this.tone = Tone.neutral, this.size = Sizes.tile, this.round = false, this.fill, this.ink})
      : assert(icon != null || child != null);
  final IconData? icon;
  final Widget? child;
  final Tone tone;
  final double size;
  final bool round;

  /// Override the tone's colours (e.g. on the dark band).
  final Color? fill;
  final Color? ink;

  @override
  Widget build(BuildContext context) {
    final c = toneColors(context, tone);
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: fill ?? c.fill,
        shape: round ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: round ? null : BorderRadius.circular(size * Sizes.tileCorner),
      ),
      child: child ?? Icon(icon, size: size * Sizes.tileIcon, color: ink ?? c.ink),
    );
  }
}

/// A small tag (24 px tall, 8 px corners): a status, a count, a streak.
enum TagKind { neutral, gold, green, red, sky, ink, plus, onDark }

class PawTag extends StatelessWidget {
  const PawTag(this.label, {super.key, this.kind = TagKind.neutral, this.icon});
  final String label;
  final TagKind kind;
  final IconData? icon;

  static ({Color fill, Color ink}) colorsOf(BuildContext context, TagKind kind) {
    final paw = context.paw;
    return switch (kind) {
      TagKind.neutral => (fill: paw.surfaceSubtle, ink: paw.textSecondary),
      TagKind.gold => toneColors(context, Tone.gold),
      TagKind.green => toneColors(context, Tone.green),
      TagKind.red => toneColors(context, Tone.red),
      TagKind.sky => toneColors(context, Tone.sky),
      TagKind.ink => toneColors(context, Tone.ink),
      TagKind.plus => toneColors(context, Tone.marigold),
      TagKind.onDark => (fill: paw.onBand.withValues(alpha: Opacities.chip), ink: paw.onBand),
    };
  }

  @override
  Widget build(BuildContext context) {
    final c = colorsOf(context, kind);
    final k = MediaQuery.textScalerOf(context).scale(1);
    return Container(
      constraints: BoxConstraints(minHeight: Sizes.tag * k),
      padding: const EdgeInsets.symmetric(horizontal: Space.sm),
      decoration: BoxDecoration(color: c.fill, borderRadius: BorderRadius.circular(Radii.sm)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (icon != null) ...[Icon(icon, size: IconSizes.xs * k, color: c.ink), const SizedBox(width: Space.xs)],
        Flexible(
          child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: context.text.labelSmall?.copyWith(color: c.ink)),
        ),
      ]),
    );
  }
}

/// A 40 px chip with a quiet edge: a place, a filter, a choice. Ink-filled
/// when [selected].
class PawChip extends StatelessWidget {
  const PawChip({super.key, required this.label, this.icon, this.trailing, this.selected = false, this.onTap});
  final String label;
  final IconData? icon;
  final IconData? trailing;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final paw = context.paw;
    final fg = selected ? paw.background : paw.textPrimary;
    final k = MediaQuery.textScalerOf(context).scale(1);
    return Semantics(
      button: onTap != null,
      selected: selected,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: selected ? paw.textPrimary : paw.textPrimary.withValues(alpha: 0),
        shape: StadiumBorder(side: BorderSide(color: selected ? paw.textPrimary : context.tint.line2)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: Sizes.chip * k),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Space.md + Space.xxs),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                if (icon != null) ...[Icon(icon, size: IconSizes.sm + Strokes.hairline, color: fg), const SizedBox(width: Space.xs + Space.xxs)],
                Flexible(
                  child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: context.text.labelMedium?.copyWith(color: fg, fontWeight: FontWeight.w500)),
                ),
                if (trailing != null) ...[const SizedBox(width: Space.xs + Space.xxs), Icon(trailing, size: IconSizes.sm + Strokes.hairline, color: fg)],
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

/// The small arrow at the end of a row.
class Chev extends StatelessWidget {
  const Chev({super.key});

  @override
  Widget build(BuildContext context) => Icon(Ph.caretRight, size: IconSizes.sm + Space.xxs, color: context.tint.ink3);
}

/// Rows split by hairlines (the kit's ".list"). With [tight] the first and
/// last rows sit closer to the edges of their panel.
class PawList extends StatelessWidget {
  const PawList({super.key, required this.children, this.tight = false});
  final List<Widget> children;
  final bool tight;

  @override
  Widget build(BuildContext context) {
    final line = Divider(height: Strokes.hairline, thickness: Strokes.hairline, color: context.paw.outline);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
      for (var i = 0; i < children.length; i++) ...[
        if (i > 0) line,
        _ListSlot(first: tight && i == 0, last: tight && i == children.length - 1, child: children[i]),
      ],
    ]);
  }
}

class _ListSlot extends InheritedWidget {
  const _ListSlot({required this.first, required this.last, required super.child});
  final bool first;
  final bool last;

  @override
  bool updateShouldNotify(_ListSlot o) => o.first != first || o.last != last;
}

/// One row (the kit's ".item"): a lead (tile, arch, date leaf, tick), a
/// title with an optional line under it, and something at the end (an arrow
/// unless [trailing] is given; pass [noTrailing] for nothing).
class PawItem extends StatelessWidget {
  const PawItem({
    super.key,
    this.lead,
    required this.title,
    this.sub,
    this.subWidget,
    this.trailing,
    this.noTrailing = false,
    this.onTap,
    this.titleStyle,
    this.subColor,
    this.subMaxLines,
    this.semanticLabel,
    this.titleWidget,
  });

  final Widget? lead;
  final String title;

  /// Instead of the plain [title] text (an icon or a count beside it).
  final Widget? titleWidget;
  final String? sub;

  /// Instead of [sub] when the line needs colour or more than text.
  final Widget? subWidget;
  final Widget? trailing;
  final bool noTrailing;
  final VoidCallback? onTap;
  final TextStyle? titleStyle;
  final Color? subColor;
  final int? subMaxLines;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final slot = context.dependOnInheritedWidgetOfExactType<_ListSlot>();
    final k = MediaQuery.textScalerOf(context).scale(1);
    final end = noTrailing ? null : (trailing ?? (onTap != null ? const Chev() : null));
    final row = ConstrainedBox(
      constraints: BoxConstraints(minHeight: Sizes.item * (k > 1.15 ? k : 1)),
      child: Padding(
        padding: EdgeInsets.only(top: slot?.first == true ? Space.xs : Space.md, bottom: slot?.last == true ? Space.xs : Space.md),
        child: Row(children: [
          if (lead != null) ...[lead!, const SizedBox(width: Space.md)],
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              titleWidget ?? Text(title, style: titleStyle ?? context.text.labelLarge),
              if (subWidget != null)
                subWidget!
              else if (sub != null && sub!.isNotEmpty)
                Text(sub!, maxLines: subMaxLines, overflow: subMaxLines == null ? null : TextOverflow.ellipsis, style: context.text.bodySmall?.copyWith(color: subColor ?? context.paw.textSecondary)),
            ]),
          ),
          if (end != null) ...[const SizedBox(width: Space.md), end],
        ]),
      ),
    );
    if (onTap == null) return row;
    return Semantics(
      button: true,
      label: semanticLabel,
      child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(Radii.md), child: row),
    );
  }
}

/// Button looks from the design kit.
enum BtnKind { primary, ink, line, soft, sos, cream, ghostDark }

/// Button heights: 36 (in rows and footers), 48 and 56.
enum BtnSize { small, regular, large }

/// A pill button in any of the kit's looks and sizes. The app's main
/// buttons ([PrimaryButton], [SecondaryButton]) use the theme; this one is
/// for the small buttons in rows and the looks the theme has no slot for.
class PawButton extends StatelessWidget {
  const PawButton({super.key, required this.label, required this.onPressed, this.icon, this.kind = BtnKind.primary, this.size = BtnSize.small, this.block = false, this.semanticLabel});
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final BtnKind kind;
  final BtnSize size;

  /// Fills the width it is given.
  final bool block;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final paw = context.paw;
    final (Color bg, Color fg, BorderSide side) = switch (kind) {
      BtnKind.primary => (paw.action, paw.onAction, BorderSide.none),
      BtnKind.ink => (paw.textPrimary, paw.background, BorderSide.none),
      BtnKind.line => (paw.textPrimary.withValues(alpha: 0), paw.textPrimary, BorderSide(color: paw.textPrimary, width: Strokes.strong)),
      BtnKind.soft => (paw.surfaceSubtle, paw.textPrimary, BorderSide.none),
      BtnKind.sos => (paw.sos, paw.onSos, BorderSide.none),
      BtnKind.cream => (paw.onBand, paw.onMarigold, BorderSide.none),
      BtnKind.ghostDark => (paw.onBand.withValues(alpha: 0), paw.onBand, BorderSide(color: paw.onBand.withValues(alpha: Opacities.muted), width: Strokes.strong)),
    };
    final k = MediaQuery.textScalerOf(context).scale(1);
    final easy = k > 1.15;
    final (double h, double pad, TextStyle? text, double iconSize) = switch (size) {
      BtnSize.small => (easy ? TapTarget.min : Sizes.buttonSmall, Space.md + Space.xxs, context.text.bodySmall?.copyWith(fontWeight: FontWeight.w600), IconSizes.sm),
      BtnSize.regular => (easy ? TapTarget.easy : TapTarget.min, Space.lg + Space.xs, context.text.labelLarge, IconSizes.md),
      BtnSize.large => (TapTarget.easy, Space.xl, context.text.titleSmall, IconSizes.md),
    };
    final disabled = onPressed == null;
    final button = Material(
      color: disabled ? paw.surfaceSubtle : bg,
      shape: StadiumBorder(side: disabled ? BorderSide.none : side),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: h),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: pad),
            child: Row(mainAxisSize: block ? MainAxisSize.max : MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [
              if (icon != null) ...[Icon(icon, size: iconSize * (easy ? k : 1), color: disabled ? paw.textSecondary : fg), const SizedBox(width: Space.sm)],
              Flexible(
                child: Text(label, maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: text?.copyWith(color: disabled ? paw.textSecondary : fg)),
              ),
            ]),
          ),
        ),
      ),
    );
    return Semantics(
      button: true,
      enabled: !disabled,
      label: semanticLabel ?? label,
      excludeSemantics: true,
      child: PressScale(child: button),
    );
  }
}

/// A round 44 px button with one icon (play, plus) in the kit's looks.
class RoundButton extends StatelessWidget {
  const RoundButton({super.key, required this.icon, required this.tooltip, required this.onPressed, this.kind = BtnKind.soft});
  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final BtnKind kind;

  @override
  Widget build(BuildContext context) {
    final paw = context.paw;
    final (Color bg, Color fg) = switch (kind) {
      BtnKind.primary => (paw.action, paw.onAction),
      BtnKind.ink => (paw.textPrimary, paw.background),
      _ => (paw.surfaceSubtle, paw.textPrimary),
    };
    final k = MediaQuery.textScalerOf(context).scale(1);
    final size = k > 1.15 ? TapTarget.easy : Sizes.topControl;
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: fg,
        shape: const CircleBorder(),
        minimumSize: Size.square(size),
        fixedSize: Size.square(size),
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      icon: Icon(icon, size: IconSizes.md),
    );
  }
}

/// A thin level bar (food left, a goal, a limit).
class LevelBar extends StatelessWidget {
  const LevelBar({super.key, required this.value, this.color, this.track});
  final double value;
  final Color? color;
  final Color? track;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Radii.sm),
      child: SizedBox(
        height: Space.sm,
        child: Stack(fit: StackFit.expand, children: [
          ColoredBox(color: track ?? context.tint.paper3),
          FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: value.clamp(0.0, 1.0),
            child: DecoratedBox(decoration: BoxDecoration(color: color ?? context.paw.marigold, borderRadius: BorderRadius.circular(Radii.sm))),
          ),
        ]),
      ),
    );
  }
}

/// A section's title with an optional link or note on the right, on one
/// baseline (the kit's ".sec").
class SecHead extends StatelessWidget {
  const SecHead(this.title, {super.key, this.action, this.onAction, this.note, this.style});
  final String title;
  final String? action;
  final VoidCallback? onAction;

  /// Quiet text on the right instead of a link ("3 left").
  final String? note;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.md),
      child: Row(crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [
        Expanded(child: Semantics(header: true, child: Text(title, style: style ?? context.text.titleLarge))),
        if (note != null) ...[
          const SizedBox(width: Space.md),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.4),
            child: Text(note!, textAlign: TextAlign.end, style: context.text.bodySmall?.copyWith(color: context.paw.textSecondary)),
          ),
        ],
        if (action != null) ...[const SizedBox(width: Space.md), TextLink(action!, onTap: onAction)],
      ]),
    );
  }
}

/// Ink text with a marigold underline, sized by its text only (the kit's
/// ".link"). The tap area reaches a little past the words.
class TextLink extends StatelessWidget {
  const TextLink(this.label, {super.key, this.onTap, this.color});
  final String label;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final paw = context.paw;
    final text = Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: context.text.labelMedium?.copyWith(
        color: color ?? paw.textPrimary,
        decoration: TextDecoration.underline,
        decorationColor: paw.marigold,
        decorationThickness: 2,
      ),
    );
    if (onTap == null) return text;
    return Semantics(
      link: true,
      label: label,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Radii.sm),
        child: Padding(padding: const EdgeInsets.symmetric(vertical: Space.xs), child: text),
      ),
    );
  }
}
