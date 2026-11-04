import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import 'cards.dart';

/// Design 2 "pass": a deep forest-teal card that sums up a pet or a booking
/// (Health tab, medical card, booking confirmed). Light text on the brand
/// colour in light mode; a deep teal surface in dark mode.
class PassCard extends StatelessWidget {
  const PassCard({
    super.key,
    required this.title,
    this.overline,
    this.overlineIcon,
    this.subtitle,
    this.leading,
    this.badges = const [],
    this.rows = const [],
    this.actions = const [],
    this.titleIsHeader = false,
    this.footnote,
  });

  final String title;

  /// Small uppercase line above the title.
  final String? overline;
  final IconData? overlineIcon;
  final String? subtitle;

  /// Avatar or icon beside the title.
  final Widget? leading;

  /// Small pills under the title (see [PassCard.badge]).
  final List<Widget> badges;

  /// Label and value rows on a darker panel.
  final List<PassRow> rows;

  /// Buttons at the bottom (see [PassCard.action]).
  final List<Widget> actions;

  /// Marks the title as the page heading for screen readers.
  final bool titleIsHeader;

  /// Small muted line at the very bottom ("Updated 4 Nov, 10:30").
  final String? footnote;

  static ({Color bg, Color fg, Color muted, Color panel}) colorsOf(BuildContext context) {
    final paw = context.paw;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final bg = dark ? paw.primaryContainer : paw.brand;
    final fg = dark ? paw.onPrimaryContainer : paw.onBrand;
    return (
      bg: bg,
      fg: fg,
      muted: readableOn(fg.withValues(alpha: Opacities.onDarkMuted), [bg]),
      panel: Color.alphaBlend(paw.ink.withValues(alpha: Opacities.tintStrong), bg),
    );
  }

  /// A small pill for the pass ("All up to date", "3 need attention").
  static Widget badge(BuildContext context, String label, {IconData? icon, ChipTone tone = ChipTone.success}) {
    final c = colorsOf(context);
    final paw = context.paw;
    final dot = switch (tone) {
      ChipTone.warning => paw.accent,
      ChipTone.error => paw.error,
      _ => paw.success,
    };
    final bg = Color.alphaBlend(c.fg.withValues(alpha: Opacities.chip), c.bg);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Space.sm + Space.xxs, vertical: Space.xs),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(Radii.full)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon ?? Icons.circle, size: icon == null ? Space.sm : IconSizes.xs, color: readableOn(dot, [bg], ratio: 3)),
        const SizedBox(width: Space.xs + Space.xxs),
        Flexible(
          child: Text(label, style: context.text.labelSmall?.copyWith(color: c.fg, fontWeight: FontWeight.w700)),
        ),
      ]),
    );
  }

  /// A light pill button that reads on the dark pass.
  static Widget action(BuildContext context, {required String label, required IconData icon, required VoidCallback? onPressed}) {
    final c = colorsOf(context);
    return FilledButton.icon(
      onPressed: onPressed,
      style: FilledButton.styleFrom(backgroundColor: c.fg, foregroundColor: c.bg, iconColor: c.bg),
      icon: Icon(icon, size: IconSizes.md),
      label: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = colorsOf(context);
    final light = Theme.of(context).brightness == Brightness.light;
    Widget titleText = Text(title, style: context.text.titleLarge?.copyWith(color: c.fg));
    if (titleIsHeader) titleText = Semantics(header: true, child: titleText);
    return Container(
      padding: const EdgeInsets.all(Space.lg),
      decoration: BoxDecoration(
        color: c.bg,
        borderRadius: BorderRadius.circular(Radii.card),
        boxShadow: light ? Shadows.card(context.paw.ink) : null,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        if (overline != null) ...[
          Row(children: [
            if (overlineIcon != null) ...[
              Icon(overlineIcon, size: IconSizes.sm, color: c.fg),
              const SizedBox(width: Space.xs + Space.xxs),
            ],
            Expanded(child: Text(overline!.toUpperCase(), style: context.textX.overline.copyWith(color: c.fg))),
          ]),
          const SizedBox(height: Space.md),
        ],
        Row(children: [
          if (leading != null) ...[leading!, const SizedBox(width: Space.md)],
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              titleText,
              if (subtitle != null) ...[
                const SizedBox(height: Space.xxs),
                Text(subtitle!, style: context.text.bodySmall?.copyWith(color: c.muted)),
              ],
              if (badges.isNotEmpty) ...[
                const SizedBox(height: Space.sm),
                Wrap(spacing: Space.sm, runSpacing: Space.sm, children: badges),
              ],
            ]),
          ),
        ]),
        if (rows.isNotEmpty) ...[
          const SizedBox(height: Space.lg),
          Container(
            padding: const EdgeInsets.all(Space.md),
            decoration: BoxDecoration(color: c.panel, borderRadius: BorderRadius.circular(Radii.lg)),
            child: Column(children: [
              for (var i = 0; i < rows.length; i++) ...[
                if (i > 0) const SizedBox(height: Space.sm),
                rows[i],
              ],
            ]),
          ),
        ],
        if (actions.isNotEmpty) ...[
          const SizedBox(height: Space.lg),
          Wrap(spacing: Space.sm, runSpacing: Space.sm, children: actions),
        ],
        if (footnote != null) ...[
          const SizedBox(height: Space.md),
          Text(footnote!, style: context.text.labelSmall?.copyWith(color: c.muted)),
        ],
      ]),
    );
  }
}

/// A label on the left and its value on the right, inside a [PassCard].
class PassRow extends StatelessWidget {
  const PassRow({super.key, required this.label, required this.value, this.mono = false});
  final String label;
  final String value;

  /// Show the value in the monospace face (IDs, doses, batch numbers).
  final bool mono;

  @override
  Widget build(BuildContext context) {
    final c = PassCard.colorsOf(context);
    final valueStyle = mono
        ? context.textX.mono.copyWith(color: c.fg)
        : context.text.bodyMedium?.copyWith(color: c.fg, fontWeight: FontWeight.w600);
    return Semantics(
      label: '$label: $value',
      excludeSemantics: true,
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: Text(label, style: context.text.bodySmall?.copyWith(color: c.muted))),
        const SizedBox(width: Space.md),
        Flexible(child: Text(value, textAlign: TextAlign.end, style: valueStyle)),
      ]),
    );
  }
}
