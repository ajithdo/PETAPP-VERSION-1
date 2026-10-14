import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Rounded card (20 px radius) with soft shadow in light mode, tonal in dark.
class PawCard extends StatelessWidget {
  const PawCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(Space.lg),
    this.color,
    this.semanticLabel,
    this.borderColor,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final String? semanticLabel;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final card = Card(
      color: color,
      clipBehavior: Clip.antiAlias,
      shape: borderColor == null
          ? null
          : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Radii.card),
              side: BorderSide(color: borderColor!, width: 1.5),
            ),
      child: onTap == null
          ? Padding(padding: padding, child: child)
          : InkWell(onTap: onTap, child: Padding(padding: padding, child: child)),
    );
    if (semanticLabel == null) return card;
    return Semantics(label: semanticLabel, button: onTap != null, child: card);
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key, this.action, this.onAction, this.padding});
  final String title;
  final String? action;
  final VoidCallback? onAction;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(top: Space.xl, bottom: Space.sm),
      child: Row(
        children: [
          Expanded(
            child: Semantics(header: true, child: Text(title, style: context.text.titleMedium)),
          ),
          if (action != null) TextButton(onPressed: onAction, child: Text(action!)),
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

  @override
  Widget build(BuildContext context) {
    final p = context.paw;
    final c = switch (tone) {
      ChipTone.success => p.success,
      ChipTone.warning => p.warning,
      ChipTone.error => p.error,
      ChipTone.info => context.colors.primary,
      ChipTone.accent => p.accent,
      ChipTone.neutral => p.textSecondary,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 14, color: c), const SizedBox(width: 4)],
          Flexible(
            child: Text(label,
                style: context.text.labelSmall?.copyWith(color: c, fontWeight: FontWeight.w700),
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
      child: PawCard(
        padding: const EdgeInsets.all(Space.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null) Icon(icon, color: color ?? context.colors.primary, size: 22),
            if (icon != null) const SizedBox(height: Space.sm),
            Text(value, style: context.text.titleLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
            Text(label, style: context.text.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
          ],
        ),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: Space.md, vertical: Space.sm),
      decoration: BoxDecoration(
        color: context.paw.accent.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(Radii.button),
      ),
      child: Row(
        children: [
          Icon(Icons.science_rounded, size: 18, color: context.paw.onAccent),
          const SizedBox(width: Space.sm),
          Expanded(child: Text(text, style: context.text.bodySmall?.copyWith(color: context.paw.textPrimary))),
        ],
      ),
    );
  }
}

/// "Indicative, always confirm with your vet" style note.
class InfoNote extends StatelessWidget {
  const InfoNote(this.text, {super.key, this.icon = Icons.info_outline_rounded, this.tone = ChipTone.info});
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
        color: c.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(Radii.button),
        border: Border.all(color: c.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: c),
          const SizedBox(width: Space.sm),
          Expanded(child: Text(text, style: context.text.bodySmall?.copyWith(color: context.paw.textPrimary))),
        ],
      ),
    );
  }
}
