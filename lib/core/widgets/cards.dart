import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import 'buttons.dart';

/// White card with 20 px corners, a 1 px warm border and a soft shadow in
/// light mode (Design 2). Tappable cards shrink slightly when pressed.
class PawCard extends StatelessWidget {
  const PawCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(Space.lg),
    this.color,
    this.semanticLabel,
    this.borderColor,
    this.flat = false,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  /// Fill; defaults to the white card surface.
  final Color? color;
  final String? semanticLabel;

  /// A stronger 1.5 px border (selected or highlighted cards).
  final Color? borderColor;

  /// No shadow (cards inside cards, or tinted cards).
  final bool flat;

  @override
  Widget build(BuildContext context) {
    final paw = context.paw;
    final radius = BorderRadius.circular(Radii.card);
    final lightMode = Theme.of(context).brightness == Brightness.light;
    final shadow = lightMode && !flat && (color == null || color == paw.surface);
    Widget card = DecoratedBox(
      decoration: BoxDecoration(borderRadius: radius, boxShadow: shadow ? Shadows.card(paw.ink) : null),
      child: Material(
        color: color ?? paw.surface,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: borderColor == null ? BorderSide(color: paw.outline) : BorderSide(color: borderColor!, width: Strokes.strong),
        ),
        child: onTap == null
            ? Padding(padding: padding, child: child)
            : InkWell(onTap: onTap, child: Padding(padding: padding, child: child)),
      ),
    );
    if (onTap != null) card = PressScale(child: card);
    if (semanticLabel == null) return card;
    return Semantics(label: semanticLabel, button: onTap != null, child: card);
  }
}

/// Section title with an optional link on the right ("See all").
class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key, this.action, this.onAction, this.padding, this.trailing});
  final String title;
  final String? action;
  final VoidCallback? onAction;
  final EdgeInsetsGeometry? padding;

  /// Small text on the right instead of a link (e.g. a count).
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(top: Space.xl, bottom: Space.sm),
      child: Row(
        children: [
          Expanded(
            child: Semantics(header: true, child: Text(title, style: context.text.titleMedium)),
          ),
          if (trailing != null) Text(trailing!, style: context.text.labelMedium?.copyWith(color: context.paw.brand)),
          if (action != null)
            ConstrainedBox(
              // Keeps room for the title at large text sizes.
              constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * StatusChip.maxWidthShare),
              child: TextButton(onPressed: onAction, child: Text(action!, textAlign: TextAlign.end)),
            ),
        ],
      ),
    );
  }
}

/// Small coloured status chip: Done, Due soon, Overdue, Pending …
enum ChipTone { neutral, success, warning, error, info, accent }

class StatusChip extends StatelessWidget {
  const StatusChip(this.label, {super.key, this.tone = ChipTone.neutral, this.icon});
  final String label;
  final ChipTone tone;
  final IconData? icon;

  /// The tint behind a chip of [tone] and its text colour, which reads at
  /// WCAG AA (4.5:1) whether the chip sits on the page or on a card.
  static ({Color tint, Color text}) colorsFor(PawColors p, Color primary, ChipTone tone) {
    final c = switch (tone) {
      ChipTone.success => p.success,
      ChipTone.warning => p.warning,
      ChipTone.error => p.error,
      ChipTone.info => primary,
      ChipTone.accent => p.accent,
      ChipTone.neutral => p.textSecondary,
    };
    final tint = c.withValues(alpha: Opacities.chip);
    return (
      tint: tint,
      text: readableOn(c, [
        Color.alphaBlend(tint, p.background),
        Color.alphaBlend(tint, p.surface),
        Color.alphaBlend(tint, p.surfaceSubtle),
      ]),
    );
  }

  /// A chip never takes more than this share of the screen width, so it fits
  /// beside a title even at large text sizes (the label then shortens).
  static const double maxWidthShare = 0.45;

  @override
  Widget build(BuildContext context) {
    final c = colorsFor(context.paw, context.colors.primary, tone);
    return Container(
      constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * maxWidthShare),
      padding: const EdgeInsets.symmetric(horizontal: Space.sm + Space.xxs, vertical: Space.xs),
      decoration: BoxDecoration(
        color: c.tint,
        borderRadius: BorderRadius.circular(Radii.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: IconSizes.xs, color: c.text), const SizedBox(width: Space.xs)],
          Flexible(
            child: Text(label,
                style: context.text.labelSmall?.copyWith(color: c.text, fontWeight: FontWeight.w700),
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}

/// Number + label tile used on dashboards and pet profile quick stats.
class StatTile extends StatelessWidget {
  const StatTile({super.key, required this.label, required this.value, this.icon, this.color});
  final String label;
  final String value;
  final IconData? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$label: $value',
      excludeSemantics: true,
      // Design 2 number tile: a small uppercase label over a big number.
      child: PawCard(
        padding: const EdgeInsets.all(Space.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              if (icon != null) ...[Icon(icon, color: color ?? context.paw.brand, size: IconSizes.sm), const SizedBox(width: Space.xs + Space.xxs)],
              Expanded(
                child: Text(label.toUpperCase(), maxLines: 2, overflow: TextOverflow.ellipsis, style: context.textX.overline.copyWith(color: context.paw.textSecondary)),
              ),
            ]),
            const SizedBox(height: Space.sm),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(value, style: context.text.headlineMedium?.copyWith(color: color == null ? context.paw.textPrimary : readableOn(color!, [context.paw.surface])), maxLines: 1),
            ),
          ],
        ),
      ),
    );
  }
}

/// Design 2 alert card (e.g. "Booster due in 10 days"): a tinted card with
/// an icon in a solid circle, a small uppercase line, a title, an optional
/// message and an optional button.
class PawAlertCard extends StatelessWidget {
  const PawAlertCard({
    super.key,
    required this.icon,
    required this.title,
    this.overline,
    this.message,
    this.actionLabel,
    this.onAction,
    this.onTap,
    this.tone = ChipTone.warning,
    this.semanticLabel,
  });

  final IconData icon;
  final String title;
  final String? overline;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback? onTap;
  final ChipTone tone;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final paw = context.paw;
    final (bg, border, solid, onSolid, ink) = switch (tone) {
      ChipTone.error => (paw.errorContainer, paw.sosBorder, paw.error, context.colors.onError, paw.onErrorContainer),
      ChipTone.success => (paw.successContainer, paw.successContainer, paw.success, paw.surface, paw.onSuccessContainer),
      ChipTone.info => (paw.primaryContainer, paw.primaryContainer, paw.brand, paw.onBrand, paw.onPrimaryContainer),
      _ => (paw.warningContainer, paw.warningBorder, paw.warning, paw.onAccent, paw.onWarningContainer),
    };
    final wide = MediaQuery.sizeOf(context).width >= 480;
    final button = actionLabel == null || onAction == null
        ? null
        : PrimaryButton(label: actionLabel!, onPressed: onAction, expand: !wide);
    final text = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (overline != null)
        Text(overline!.toUpperCase(), style: context.textX.overline.copyWith(color: ink)),
      if (overline != null) const SizedBox(height: Space.xxs),
      Text(title, style: context.text.titleSmall?.copyWith(color: paw.textPrimary)),
      if (message != null) ...[
        const SizedBox(height: Space.xs),
        Text(message!, style: context.text.bodySmall?.copyWith(color: paw.textPrimary)),
      ],
    ]);
    return PawCard(
      color: bg,
      flat: true,
      borderColor: border,
      onTap: onTap,
      semanticLabel: semanticLabel,
      padding: const EdgeInsets.all(Space.lg),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Container(
            width: IconSizes.xl + Space.sm,
            height: IconSizes.xl + Space.sm,
            decoration: BoxDecoration(color: solid, shape: BoxShape.circle),
            child: Icon(icon, color: onSolid, size: IconSizes.md),
          ),
          const SizedBox(width: Space.md),
          Expanded(child: text),
          if (button != null && wide) ...[const SizedBox(width: Space.md), button],
          if (button == null && onTap != null) ...[
            const SizedBox(width: Space.sm),
            Icon(Icons.chevron_right_outlined, color: paw.textSecondary),
          ],
        ]),
        if (button != null && !wide) ...[const SizedBox(height: Space.md), button],
      ]),
    );
  }
}

/// A banner that marks demo-only behaviour.
class DemoBanner extends StatelessWidget {
  const DemoBanner(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    final paw = context.paw;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: Space.md, vertical: Space.sm),
      decoration: BoxDecoration(
        color: paw.warningContainer,
        borderRadius: BorderRadius.circular(Radii.md),
        border: Border.all(color: paw.warningBorder),
      ),
      child: Row(
        children: [
          Icon(Icons.science_outlined, size: IconSizes.sm, color: paw.onAccentContainer),
          const SizedBox(width: Space.sm),
          Expanded(child: Text(text, style: context.text.bodySmall?.copyWith(color: paw.textPrimary))),
        ],
      ),
    );
  }
}

/// "Indicative, always confirm with your vet" style note.
class InfoNote extends StatelessWidget {
  const InfoNote(this.text, {super.key, this.icon = Icons.info_outlined, this.tone = ChipTone.info});
  final String text;
  final IconData icon;
  final ChipTone tone;

  @override
  Widget build(BuildContext context) {
    final c = switch (tone) {
      ChipTone.warning => context.paw.warning,
      ChipTone.error => context.paw.error,
      _ => context.colors.primary,
    };
    return Container(
      padding: const EdgeInsets.all(Space.md),
      decoration: BoxDecoration(
        color: c.withValues(alpha: Opacities.pressed),
        borderRadius: BorderRadius.circular(Radii.md),
        border: Border.all(color: c.withValues(alpha: Opacities.border)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: IconSizes.md, color: c),
          const SizedBox(width: Space.sm),
          Expanded(child: Text(text, style: context.text.bodySmall?.copyWith(color: context.paw.textPrimary))),
        ],
      ),
    );
  }
}

/// A small sage square with the day number over the short month ("13 /
/// NOV"), at the start of a booking or event row (Design 2).
class DateBadge extends StatelessWidget {
  const DateBadge({super.key, required this.day, required this.month, this.muted = false});

  /// Day of the month, e.g. "13".
  final String day;

  /// Short month name, e.g. "Nov".
  final String month;

  /// Past items use the sand background.
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final paw = context.paw;
    final fg = muted ? paw.textSecondary : paw.onPrimaryContainer;
    return Container(
      constraints: const BoxConstraints(minWidth: Sizes.dateBadge, minHeight: Sizes.dateBadge),
      padding: const EdgeInsets.symmetric(horizontal: Space.xs, vertical: Space.xs),
      decoration: BoxDecoration(
        color: muted ? paw.surfaceSubtle : paw.primaryContainer,
        borderRadius: BorderRadius.circular(Radii.md),
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
        Text(day, style: context.text.titleLarge?.copyWith(color: fg, height: TypeScale.tightLineHeight)),
        const SizedBox(height: Space.xxs),
        Text(month.toUpperCase(), style: context.textX.overline.copyWith(color: fg)),
      ]),
    );
  }
}

/// Five stars for a review, filled in amber up to [rating] (out of 5).
class RatingStars extends StatelessWidget {
  const RatingStars(this.rating, {super.key, this.size = IconSizes.sm});
  final int rating;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = context.paw.accent;
    return Semantics(
      label: '$rating/5',
      excludeSemantics: true,
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        for (var i = 0; i < 5; i++) Icon(i < rating ? Icons.star_rounded : Icons.star_border_rounded, size: size, color: c),
      ]),
    );
  }
}
