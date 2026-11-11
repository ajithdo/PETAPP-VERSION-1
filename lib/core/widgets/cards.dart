import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import 'buttons.dart';

/// White card with 22 px corners (UI Design 5): a soft warm shadow and no
/// border in light mode, a hairline edge in dark mode and high contrast.
/// Tappable cards shrink slightly when pressed.
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
    final plain = color == null || color == paw.surface;
    final shadow = lightMode && !flat && plain;
    // Light mode: the shadow defines the card. Dark mode (no visible
    // shadows) and tinted or flat cards: a hairline edge.
    final edge = !lightMode || !plain || flat || MediaQuery.highContrastOf(context);
    Widget card = DecoratedBox(
      decoration: BoxDecoration(borderRadius: radius, boxShadow: shadow ? Shadows.card(paw.ink) : null),
      child: Material(
        color: color ?? paw.surface,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: borderColor != null ? BorderSide(color: borderColor!, width: Strokes.strong) : (edge ? BorderSide(color: paw.outline) : BorderSide.none),
        ),
        child: onTap == null
            ? Padding(padding: padding, child: child)
            : InkWell(
                onTap: onTap,
                child: Padding(padding: padding, child: child),
              ),
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
            child: Semantics(header: true, child: Text(title, style: context.text.titleLarge)),
          ),
          if (trailing != null) Text(trailing!, style: context.text.bodySmall?.copyWith(color: context.paw.textSecondary)),
          if (action != null)
            ConstrainedBox(
              // Keeps room for the title at large text sizes.
              constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * StatusChip.maxWidthShare),
              child: LinkButton(label: action!, onPressed: onAction, textAlign: TextAlign.end),
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
      text: readableOn(c, [Color.alphaBlend(tint, p.background), Color.alphaBlend(tint, p.surface), Color.alphaBlend(tint, p.surfaceSubtle)]),
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
      decoration: BoxDecoration(color: c.tint, borderRadius: BorderRadius.circular(Radii.sm)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: IconSizes.xs, color: c.text), const SizedBox(width: Space.xs)],
          Flexible(
            child: Text(
              label,
              style: context.text.labelSmall?.copyWith(color: c.text, fontWeight: FontWeight.w700),
              overflow: TextOverflow.ellipsis,
            ),
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
      // Number tile: a small label over a big number (sentence case: Hindi
      // and Telugu can't be upper-cased).
      child: PawCard(
        padding: const EdgeInsets.all(Space.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) ...[Icon(icon, color: color ?? context.paw.brand, size: IconSizes.sm), const SizedBox(width: Space.xs + Space.xxs)],
                Expanded(
                  child: Text(
                    label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.textX.overline.copyWith(color: context.paw.textSecondary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Space.sm),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: context.text.headlineMedium?.copyWith(color: color == null ? context.paw.textPrimary : readableOn(color!, [context.paw.surface])),
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Alert card (e.g. "Booster due in 10 days"): a tinted card with an icon in
/// a solid circle, a small line, a title, an optional message and an
/// optional button.
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
      ChipTone.error => (paw.errorContainer, paw.error.withValues(alpha: Opacities.border), paw.error, context.colors.onError, paw.onErrorContainer),
      ChipTone.success => (paw.successContainer, paw.successContainer, paw.success, paw.surface, paw.onSuccessContainer),
      ChipTone.info => (paw.primaryContainer, paw.primaryContainer, paw.brand, paw.onBrand, paw.onPrimaryContainer),
      _ => (paw.warningContainer, paw.warningBorder, paw.warning, paw.onAccent, paw.onWarningContainer),
    };
    final wide = MediaQuery.sizeOf(context).width >= 480;
    final button = actionLabel == null || onAction == null ? null : PrimaryButton(label: actionLabel!, onPressed: onAction, expand: !wide);
    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // The short line ("in 5 days", "Overdue") follows the title: no
        // small label above a heading (DESIGN.md).
        Text(title, style: context.text.titleSmall?.copyWith(color: paw.textPrimary)),
        if (overline != null) ...[const SizedBox(height: Space.xxs), Text(overline!, style: context.text.labelMedium?.copyWith(color: ink))],
        if (message != null) ...[const SizedBox(height: Space.xs), Text(message!, style: context.text.bodySmall?.copyWith(color: paw.textPrimary))],
      ],
    );
    return PawCard(
      color: bg,
      flat: true,
      borderColor: border,
      onTap: onTap,
      semanticLabel: semanticLabel,
      padding: const EdgeInsets.all(Space.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: IconSizes.xl + Space.sm,
                height: IconSizes.xl + Space.sm,
                decoration: BoxDecoration(color: solid, shape: BoxShape.circle),
                child: Icon(icon, color: onSolid, size: IconSizes.md),
              ),
              const SizedBox(width: Space.md),
              Expanded(child: text),
              if (button != null && wide) ...[const SizedBox(width: Space.md), button],
              if (button == null && onTap != null) ...[const SizedBox(width: Space.sm), Icon(Icons.chevron_right_outlined, color: paw.textSecondary)],
            ],
          ),
          if (button != null && !wide) ...[const SizedBox(height: Space.md), button],
        ],
      ),
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
          Expanded(
            child: Text(text, style: context.text.bodySmall?.copyWith(color: paw.textPrimary)),
          ),
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
          Expanded(
            child: Text(text, style: context.text.bodySmall?.copyWith(color: context.paw.textPrimary)),
          ),
        ],
      ),
    );
  }
}

/// Date block (DESIGN.md): a 56 px warm-grey square with the short month on
/// top and the day number below ("Nov" / "13"), at the start of every
/// scheduled row (vaccine, dose, booking), always in the same place.
class DateBadge extends StatelessWidget {
  const DateBadge({super.key, required this.day, required this.month, this.muted = false, this.tone});

  /// Day of the month, e.g. "13".
  final String day;

  /// Short month name, e.g. "Nov".
  final String month;

  /// Past items: no fill, a hairline edge and quieter text.
  final bool muted;

  /// [ChipTone.warning] (due soon) gives a marigold strip, [ChipTone.error]
  /// (overdue) the red one. Otherwise the strip is ink.
  final ChipTone? tone;

  @override
  Widget build(BuildContext context) {
    final paw = context.paw;
    final fg = muted ? paw.textSecondary : paw.textPrimary;
    // UI Design 6: a tear-off calendar leaf. The month sits on a strip
    // (ink, marigold when due soon, red when overdue), the day below it.
    final (strip, onStrip) = muted
        ? (paw.surfaceSubtle, paw.textSecondary)
        : switch (tone) {
            ChipTone.warning || ChipTone.accent => (paw.marigold, paw.onMarigold),
            ChipTone.error => (paw.sos, paw.onSos),
            _ => (paw.textPrimary, paw.background),
          };
    final radius = BorderRadius.circular(Radii.md);
    return Container(
      constraints: const BoxConstraints(minWidth: Sizes.dateBadge - Space.sm, minHeight: Sizes.dateBadge),
      decoration: BoxDecoration(
        color: paw.surface,
        border: Border.all(color: muted ? paw.outline : paw.controlBorder.withValues(alpha: Opacities.half)),
        borderRadius: radius,
      ),
      child: ClipRRect(
        borderRadius: radius,
        // Shrinks to fit rather than overflow when the row is short (Hindi
        // and Telugu lines are taller).
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              ColoredBox(
                color: strip,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Space.xs, vertical: Space.xxs),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(month, textAlign: TextAlign.center, style: context.text.labelSmall?.copyWith(color: onStrip, height: TypeScale.tightLineHeight + 0.15)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Space.xs, vertical: Space.xxs),
                child: FittedBox(fit: BoxFit.scaleDown, child: Text(day, textAlign: TextAlign.center, style: context.textX.dateNumber.copyWith(color: fg))),
              ),
            ],
          ),
          ),
        ),
      ),
    );
  }
}

/// Five stars for a review, filled in marigold ink up to [rating] (out of 5).
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [for (var i = 0; i < 5; i++) Icon(i < rating ? Icons.star_rounded : Icons.star_border_rounded, size: size, color: c)],
      ),
    );
  }
}
