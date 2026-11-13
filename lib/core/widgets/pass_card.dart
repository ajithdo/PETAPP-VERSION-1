import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import 'cards.dart';
import 'layout.dart';
import 'toran.dart';
import '../theme/ph.dart';

/// UI Design 2 "pass": a deep forest-teal card that sums up a pet or a booking
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
    this.alert,
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

  /// A red band under the title for what a vet must see first (allergies on
  /// the medical card): (label, value).
  final (String, String)? alert;

  static ({Color bg, Color fg, Color muted, Color panel}) colorsOf(BuildContext context) {
    // UI Design 5: the pass sits on the deep cocoa band in both themes
    // (calm register: no marigold fills).
    final paw = context.paw;
    final bg = paw.band;
    final fg = paw.onBand;
    return (
      bg: bg,
      fg: fg,
      muted: paw.onBandMuted,
      panel: Color.alphaBlend(paw.ink.withValues(alpha: Opacities.tintStrong), bg),
    );
  }

  /// A small tag for the pass: marigold when something needs attention
  /// ("3 need attention"), quiet on the band for good news.
  static Widget badge(BuildContext context, String label, {IconData? icon, ChipTone tone = ChipTone.success}) {
    final attention = tone == ChipTone.warning || tone == ChipTone.error;
    return PawTag(label, kind: attention ? TagKind.plus : TagKind.onDark, icon: icon ?? (attention ? Ph.clockFill : Ph.checkCircleFill));
  }

  /// A full-width pill button that reads on the dark pass: cream for the
  /// main one, an outline for a [secondary] one.
  static Widget action(BuildContext context, {required String label, required IconData icon, required VoidCallback? onPressed, bool secondary = false}) {
    return PawButton(label: label, icon: icon, kind: secondary ? BtnKind.ghostDark : BtnKind.cream, size: BtnSize.regular, block: true, onPressed: onPressed);
  }

  @override
  Widget build(BuildContext context) {
    final c = colorsOf(context);
    final light = Theme.of(context).brightness == Brightness.light;
    Widget titleText = Text(title, style: context.text.headlineMedium?.copyWith(color: c.fg));
    if (titleIsHeader) titleText = Semantics(header: true, child: titleText);
    return Container(
      padding: const EdgeInsets.all(Space.lg + Space.xxs),
      decoration: BoxDecoration(
        color: c.bg,
        borderRadius: BorderRadius.circular(Radii.xxl),
        boxShadow: light ? Shadows.card(context.paw.ink) : null,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          if (leading != null) ...[leading!, const SizedBox(width: Space.md)],
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              titleText,
              if (subtitle != null) ...[
                const SizedBox(height: Space.xxs),
                Text(subtitle!, style: context.text.bodySmall?.copyWith(color: c.muted)),
              ],
              // What the card is ("Medical card") follows the title, never
              // as a small label above it (DESIGN.md).
              if (overline != null) ...[
                const SizedBox(height: Space.xs),
                Row(children: [
                  if (overlineIcon != null) ...[
                    Icon(overlineIcon, size: IconSizes.sm, color: c.muted),
                    const SizedBox(width: Space.xs + Space.xxs),
                  ],
                  Flexible(child: Text(overline!, style: context.text.labelMedium?.copyWith(color: c.muted))),
                ]),
              ],
            ]),
          ),
        ]),
        // Tags sit on their own line under the name, as in the design.
        if (badges.isNotEmpty) ...[
          const SizedBox(height: Space.md),
          Wrap(spacing: Space.sm, runSpacing: Space.sm, children: badges),
        ],
        if (alert != null) ...[
          const SizedBox(height: Space.lg),
          Semantics(
            label: '${alert!.$1}: ${alert!.$2}',
            excludeSemantics: true,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: Space.md + Space.xxs, vertical: Space.sm + Space.xxs),
              decoration: BoxDecoration(color: context.paw.sos, borderRadius: BorderRadius.circular(Radii.lg)),
              child: Row(children: [
                Icon(Ph.warningFill, color: context.paw.onSos, size: IconSizes.xl - Space.xs),
                const SizedBox(width: Space.md),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(alert!.$1, style: context.text.labelSmall?.copyWith(color: context.paw.onSos)),
                    Text(alert!.$2, style: context.text.titleMedium?.copyWith(color: context.paw.onSos)),
                  ]),
                ),
              ]),
            ),
          ),
        ],
        if (rows.isNotEmpty) ...[
          const SizedBox(height: Space.lg),
          // Up to three short facts sit side by side between hairlines
          // (age, weight, chip ID); longer lists stack, label beside value.
          LayoutBuilder(builder: (context, box) {
            final line = BorderSide(color: context.tint.bandLine);
            final side = rows.length <= 3 && box.maxWidth >= Sizes.miniCardMin && MediaQuery.textScalerOf(context).scale(1) < 1.4;
            if (side) {
              return DecoratedBox(
                decoration: BoxDecoration(border: Border(top: line, bottom: line)),
                child: IntrinsicHeight(
                  child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    for (var i = 0; i < rows.length; i++)
                      Expanded(
                        flex: i == rows.length - 1 && rows.length == 3 ? 5 : 4,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(i == 0 ? 0 : Space.md + Space.xxs, Space.md, Space.xs, Space.md),
                          decoration: BoxDecoration(border: i == 0 ? null : Border(left: line)),
                          child: rows[i].stacked(context),
                        ),
                      ),
                  ]),
                ),
              );
            }
            return DecoratedBox(
              decoration: BoxDecoration(border: Border(top: line)),
              child: Padding(
                padding: const EdgeInsets.only(top: Space.md),
                child: Column(children: [
                  for (var i = 0; i < rows.length; i++) ...[
                    if (i > 0) const SizedBox(height: Space.sm),
                    rows[i],
                  ],
                ]),
              ),
            );
          }),
        ],
        if (actions.isNotEmpty) ...[
          const SizedBox(height: Space.lg),
          // Buttons share the width equally; on narrow screens or with big
          // text they stack at full width (never two uneven buttons).
          LayoutBuilder(builder: (context, box) {
            // English labels fit two across on a phone; Hindi and Telugu
            // need the wider row.
            final roomy = box.maxWidth >= (context.lang == 'en' ? Sizes.miniCardMin : Sizes.passActionsRow) && MediaQuery.textScalerOf(context).scale(1) < 1.2;
            if (actions.length > 1 && roomy) {
              return Row(children: [
                for (var i = 0; i < actions.length; i++) ...[
                  if (i > 0) const SizedBox(width: Space.md),
                  Expanded(child: actions[i]),
                ],
              ]);
            }
            return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              for (var i = 0; i < actions.length; i++) ...[
                if (i > 0) const SizedBox(height: Space.sm),
                actions[i],
              ],
            ]);
          }),
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

  /// Show the value with lined-up figures (IDs, doses, batch numbers).
  final bool mono;

  /// The label over a big value, for the side-by-side facts strip.
  Widget stacked(BuildContext context) {
    final c = PassCard.colorsOf(context);
    return Semantics(
      label: '$label: $value',
      excludeSemantics: true,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: context.text.bodySmall?.copyWith(color: c.muted)),
        const SizedBox(height: Space.xxs),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(value, maxLines: 1, style: (mono ? context.text.bodySmall?.copyWith(fontFamily: FontFamilies.heading, height: 24 / 13) : context.text.titleMedium)?.copyWith(color: c.fg, fontWeight: FontWeight.w700)),
        ),
      ]),
    );
  }

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
        // IDs never break across lines: they shrink to fit instead.
        Flexible(
          child: mono
              ? FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerRight, child: Text(value, maxLines: 1, style: valueStyle))
              : Text(value, textAlign: TextAlign.end, style: valueStyle),
        ),
      ]),
    );
  }
}
