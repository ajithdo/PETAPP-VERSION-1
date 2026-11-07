// WCAG AA contrast (4.5:1 for text) for every colour pair the design system
// puts text on, in light and dark, with and without high contrast. Exact
// colour maths, so it doesn't depend on how a screenshot anti-aliases.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawsetu/core/theme/app_theme.dart';
import 'package:pawsetu/core/theme/tokens.dart';
import 'package:pawsetu/core/widgets/cards.dart';

void main() {
  for (final b in Brightness.values) {
    for (final hc in [false, true]) {
      test('${b.name}${hc ? ', high contrast' : ''}: text meets WCAG AA', () {
        final theme = AppTheme.build(brightness: b, locale: 'en', highContrast: hc);
        final p = theme.extension<PawColors>()!;
        final cs = theme.colorScheme;
        final low = <String>[];
        void aa(Color fg, Color bg, String what) {
          final r = contrastRatio(fg, bg);
          if (r < 4.5) low.add('$what ${r.toStringAsFixed(2)}');
        }

        for (final (name, bg) in [('page', p.background), ('card', p.surface), ('sand', p.surfaceSubtle)]) {
          aa(p.textPrimary, bg, 'text on $name');
          aa(p.textSecondary, bg, 'secondary text on $name');
          aa(cs.primary, bg, 'links and text buttons on $name');
          aa(p.error, bg, 'error text on $name');
          aa(p.success, bg, 'success text on $name');
          aa(p.warning, bg, 'warning text on $name');
          for (final tone in ChipTone.values) {
            final c = StatusChip.colorsFor(p, cs.primary, tone);
            aa(c.text, Color.alphaBlend(c.tint, bg), '${tone.name} chip on $name');
          }
        }
        // UI Design 2 pairs.
        aa(p.onAction, p.action, 'coral main buttons');
        aa(p.onAction, p.actionPressed, 'coral main buttons, pressed');
        aa(p.onBrand, p.brand, 'brand-teal fills');
        aa(p.onActionContainer, p.actionContainer, 'text on coral tint');
        aa(p.onSosContainer, p.sosContainer, 'SOS pill');
        aa(p.onWarningContainer, p.warningContainer, 'warning alert card');
        aa(p.onSuccessContainer, p.successContainer, 'success alert card');
        aa(p.onErrorContainer, p.errorContainer, 'error alert card');
        aa(p.textPrimary, p.warningContainer, 'title on warning alert card');
        aa(p.textPrimary, p.errorContainer, 'title on error alert card');
        aa(p.onAccentContainer, Color.alphaBlend(p.accent.withValues(alpha: Opacities.chip), p.surface), 'icons on amber tint');
        aa(p.onAccent, p.warning, 'icon on the warning alert circle');
        aa(cs.onError, p.error, 'icon on the error alert circle');
        // The health pass (deep teal card): title, secondary text, values on
        // its darker panel, and the light buttons on it.
        final dark = b == Brightness.dark;
        final passBg = dark ? p.primaryContainer : p.brand;
        final passFg = dark ? p.onPrimaryContainer : p.onBrand;
        final passPanel = Color.alphaBlend(p.ink.withValues(alpha: Opacities.tintStrong), passBg);
        final passMuted = readableOn(passFg.withValues(alpha: Opacities.onDarkMuted), [passBg]);
        aa(passFg, passBg, 'title on the health pass');
        aa(Color.alphaBlend(passMuted, passBg), passBg, 'secondary text on the health pass');
        aa(passFg, passPanel, 'values on the health pass panel');
        aa(passBg, passFg, 'buttons on the health pass');
        // Option cards and the price summary.
        aa(p.onActionContainer, p.actionContainer, 'chosen option card');
        aa(p.onActionContainer, p.surfaceSubtle, 'total in the price summary');
        aa(p.onActionContainer, p.surface, 'total in the cart bill');
        // Choice tiles (chosen species).
        aa(p.onPrimaryContainer, p.primaryContainer, 'chosen choice tile');
        // Borders of inputs and the focus ring need 3:1 (WCAG 1.4.11).
        void ui(Color fg, Color bg, String what) {
          final r = contrastRatio(fg, bg);
          if (r < 3) low.add('$what ${r.toStringAsFixed(2)}');
        }

        for (final (name, bg) in [('page', p.background), ('card', p.surface)]) {
          ui(p.controlBorder, bg, 'input border on $name');
          ui(p.focus, bg, 'focus ring on $name');
        }
        aa(cs.onPrimary, cs.primary, 'filled buttons');
        aa(p.onAccent, p.accent, 'accent buttons');
        aa(Colors.white, b == Brightness.light ? p.error : p.sos, 'danger buttons');
        aa(p.onSos, p.sos, 'SOS button');
        aa(cs.onPrimaryContainer, cs.primaryContainer, 'text on highlighted cards');
        aa(cs.onSecondaryContainer, cs.secondaryContainer, 'text on warm cards');
        aa(cs.onInverseSurface, cs.inverseSurface, 'messages at the bottom');
        expect(low, isEmpty);
      });
    }
  }

  test('readableOn darkens on light backgrounds and lightens on dark ones', () {
    const orange = Color(0xFFF4A261);
    final onLight = readableOn(orange, [const Color(0xFFFFF4EB)]);
    expect(contrastRatio(onLight, const Color(0xFFFFF4EB)), greaterThanOrEqualTo(4.5));
    expect(onLight.computeLuminance(), lessThan(orange.computeLuminance()));
    final onDark = readableOn(const Color(0xFF15803D), [const Color(0xFF0E1415)]);
    expect(contrastRatio(onDark, const Color(0xFF0E1415)), greaterThanOrEqualTo(4.5));
  });
}
