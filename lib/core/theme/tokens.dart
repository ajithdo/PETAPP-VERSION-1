import 'dart:math' as math;

import 'package:flutter/material.dart';

// Design tokens: UI Design 5, "Genda" (DESIGN.md at the project root).
// Every colour, font, size, gap, corner, shadow and timing in the app comes
// from this file. Never hard-code these values in widgets.
//
// Genda is the marigold garland of an Indian home: cocoa ink and cocoa
// buttons on white and warm-grey grounds, marigold only for flowers,
// progress and celebration. Two registers: warm (Home, empty states,
// onboarding, album) and calm (Health, records, tele-vet, SOS, portals).
// - SOS red is the only red in the app. Errors are berry, warnings
//   amber-brown, badges cocoa.
// - Marigold is a fill, never text on a light ground; use [PawColors.accent]
//   (marigold ink) for marigold-family text and icons.
// - Every pair is checked in test/core/contrast_test.dart: text 4.5:1,
//   borders, icons and focus 3:1, in light, dark and high contrast.
// - The smallest text is 13 px.

/// Colours for one brightness. Read with `context.paw`.
class PawColors extends ThemeExtension<PawColors> {
  const PawColors({
    required this.brand,
    required this.onBrand,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.action,
    required this.onAction,
    required this.actionPressed,
    required this.actionContainer,
    required this.onActionContainer,
    required this.accent,
    required this.onAccent,
    required this.onAccentContainer,
    required this.background,
    required this.surface,
    required this.surfaceSubtle,
    required this.outline,
    required this.controlBorder,
    required this.focus,
    required this.textPrimary,
    required this.textSecondary,
    required this.success,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.warning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.warningBorder,
    required this.error,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.sos,
    required this.onSos,
    required this.sosContainer,
    required this.onSosContainer,
    required this.sosBorder,
    required this.inverseSurface,
    required this.onInverseSurface,
    required this.ink,
    required this.marigold,
    required this.onMarigold,
    required this.accentContainer,
    required this.band,
    required this.onBand,
    required this.onBandMuted,
    required this.done,
  });

  /// Cocoa (marigold in dark mode): the brand, selected navigation, links,
  /// selected chips, verified and health information.
  final Color brand;
  final Color onBrand;

  /// Soft cocoa tint behind brand information (verified tags, life stage, tips).
  final Color primaryContainer;
  final Color onPrimaryContainer;

  /// Cocoa (marigold in dark mode): the one main action on a screen (Book,
  /// Confirm, Save).
  final Color action;
  final Color onAction;
  final Color actionPressed;
  final Color actionContainer;
  final Color onActionContainer;

  /// Marigold ink: text and icons in the marigold family (ratings, Plus,
  /// streaks, birthdays). Readable on white (4.5:1+).
  final Color accent;
  final Color onAccent;

  /// Icons and text on an amber tint.
  final Color onAccentContainer;

  /// Warm-grey page behind cards.
  final Color background;

  /// White cards and sheets.
  final Color surface;

  /// Warm grey for grouped areas, date blocks and neutral chips.
  final Color surfaceSubtle;

  /// Hairline dividers and the 1 px card edge in dark mode (decorative).
  final Color outline;

  /// Border of inputs, outlined buttons and chips (3:1 on the page).
  final Color controlBorder;

  /// Keyboard focus ring.
  final Color focus;

  final Color textPrimary;
  final Color textSecondary;

  final Color success;
  final Color successContainer;
  final Color onSuccessContainer;
  final Color warning;
  final Color warningContainer;
  final Color onWarningContainer;
  final Color warningBorder;
  final Color error;
  final Color errorContainer;
  final Color onErrorContainer;

  /// Emergency only. Nothing else in the app is this red.
  final Color sos;
  final Color onSos;
  final Color sosContainer;
  final Color onSosContainer;
  final Color sosBorder;

  /// Snackbars and tooltips.
  final Color inverseSurface;
  final Color onInverseSurface;

  /// Shadow colour (warm cocoa in light mode).
  final Color ink;

  /// Marigold: garland flowers, progress bars, celebration, the Plus badge.
  /// A fill, never text on a light ground.
  final Color marigold;
  final Color onMarigold;

  /// Pale marigold behind marigold-family information (Plus, streaks).
  final Color accentContainer;

  /// The Genda band on Home and dark hero panels (health pass).
  final Color band;
  final Color onBand;

  /// Quieter text and open garland flowers on the band.
  final Color onBandMuted;

  /// Filled "done" tick on everyday tasks (warm register). The calm register
  /// uses [success].
  final Color done;

  static const light = PawColors(
    brand: Color(0xFF2B1A12),
    onBrand: Color(0xFFFBF7F1),
    primaryContainer: Color(0xFFF4ECE0),
    onPrimaryContainer: Color(0xFF2B1A12),
    action: Color(0xFFF8A80C),
    onAction: Color(0xFF2B1A12),
    actionPressed: Color(0xFFE89A00),
    actionContainer: Color(0xFFFDEFCC),
    onActionContainer: Color(0xFF7A4400),
    accent: Color(0xFF8A4F00),
    onAccent: Color(0xFFFFFFFF),
    onAccentContainer: Color(0xFF744000),
    background: Color(0xFFFBF7F1),
    surface: Color(0xFFFFFFFF),
    surfaceSubtle: Color(0xFFF4ECE0),
    outline: Color(0xFFEADFD0),
    controlBorder: Color(0xFF8C7A6A),
    focus: Color(0xFFB26F00),
    textPrimary: Color(0xFF2B1A12),
    textSecondary: Color(0xFF66554A),
    success: Color(0xFF2C6A43),
    successContainer: Color(0xFFDDEDDD),
    onSuccessContainer: Color(0xFF22553A),
    warning: Color(0xFF8A4B00),
    warningContainer: Color(0xFFFDEFCC),
    onWarningContainer: Color(0xFF6B3B00),
    warningBorder: Color(0xFFF1C978),
    error: Color(0xFFB4201B),
    errorContainer: Color(0xFFFCE4E0),
    onErrorContainer: Color(0xFF8E1712),
    sos: Color(0xFFDC2626),
    onSos: Color(0xFFFFFFFF),
    sosContainer: Color(0xFFFCE4E0),
    onSosContainer: Color(0xFFB4201B),
    sosBorder: Color(0xFFF2B3AA),
    inverseSurface: Color(0xFF2B1A12),
    onInverseSurface: Color(0xFFFBF7F1),
    ink: Color(0xFF2B1A12),
    marigold: Color(0xFFF8A80C),
    onMarigold: Color(0xFF2B1A12),
    accentContainer: Color(0xFFFDEFCC),
    band: Color(0xFF2F1D14),
    onBand: Color(0xFFFBF2E3),
    onBandMuted: Color(0xFFD7C3AC),
    done: Color(0xFFC77700),
  );

  static const dark = PawColors(
    brand: Color(0xFFF8EFDF),
    onBrand: Color(0xFF17100C),
    primaryContainer: Color(0xFF2E2219),
    onPrimaryContainer: Color(0xFFF8EFDF),
    action: Color(0xFFFBB431),
    onAction: Color(0xFF2B1A12),
    actionPressed: Color(0xFFFFC64F),
    actionContainer: Color(0xFF3A290E),
    onActionContainer: Color(0xFFFCC864),
    accent: Color(0xFFFCC864),
    onAccent: Color(0xFF2B1A12),
    onAccentContainer: Color(0xFFFCC864),
    background: Color(0xFF17100C),
    surface: Color(0xFF241A13),
    surfaceSubtle: Color(0xFF2E2219),
    outline: Color(0xFF3A2C21),
    controlBorder: Color(0xFF8E7C6A),
    focus: Color(0xFFFBB431),
    textPrimary: Color(0xFFF8EFDF),
    textSecondary: Color(0xFFCDBBA6),
    success: Color(0xFF8AD0A0),
    successContainer: Color(0xFF1D3325),
    onSuccessContainer: Color(0xFFBFE8CC),
    warning: Color(0xFFFFC861),
    warningContainer: Color(0xFF3A290E),
    onWarningContainer: Color(0xFFFFE2A3),
    warningBorder: Color(0xFF5C4410),
    error: Color(0xFFFF9285),
    errorContainer: Color(0xFF3E1A15),
    onErrorContainer: Color(0xFFFFC9C1),
    sos: Color(0xFFDC2626),
    onSos: Color(0xFFFFFFFF),
    sosContainer: Color(0xFF3E1A15),
    onSosContainer: Color(0xFFFF9285),
    sosBorder: Color(0xFF7F1D1D),
    inverseSurface: Color(0xFFF8EFDF),
    onInverseSurface: Color(0xFF17100C),
    ink: Color(0xFF000000),
    marigold: Color(0xFFFBB431),
    onMarigold: Color(0xFF2B1A12),
    accentContainer: Color(0xFF3A290E),
    band: Color(0xFF2C1E15),
    onBand: Color(0xFFFBF2E3),
    onBandMuted: Color(0xFFD7C3AC),
    done: Color(0xFFFBB431),
  );

  /// High-contrast variants: darker text and borders for low vision.
  PawColors highContrast(Brightness b) {
    final light = b == Brightness.light;
    return copyWith(
      textPrimary: light ? const Color(0xFF000000) : const Color(0xFFFFFFFF),
      textSecondary: light ? const Color(0xFF3D2C22) : const Color(0xFFEFE3D2),
      outline: light ? const Color(0xFF8C7A6A) : const Color(0xFF8E7C6A),
      controlBorder: light ? const Color(0xFF4F3F33) : const Color(0xFFCDBBA6),
    );
  }

  @override
  PawColors copyWith({
    Color? brand,
    Color? onBrand,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    Color? action,
    Color? onAction,
    Color? actionPressed,
    Color? actionContainer,
    Color? onActionContainer,
    Color? accent,
    Color? onAccent,
    Color? onAccentContainer,
    Color? background,
    Color? surface,
    Color? surfaceSubtle,
    Color? outline,
    Color? controlBorder,
    Color? focus,
    Color? textPrimary,
    Color? textSecondary,
    Color? success,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? warning,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? warningBorder,
    Color? error,
    Color? errorContainer,
    Color? onErrorContainer,
    Color? sos,
    Color? onSos,
    Color? sosContainer,
    Color? onSosContainer,
    Color? sosBorder,
    Color? inverseSurface,
    Color? onInverseSurface,
    Color? ink,
    Color? marigold,
    Color? onMarigold,
    Color? accentContainer,
    Color? band,
    Color? onBand,
    Color? onBandMuted,
    Color? done,
  }) => PawColors(
    brand: brand ?? this.brand,
    onBrand: onBrand ?? this.onBrand,
    primaryContainer: primaryContainer ?? this.primaryContainer,
    onPrimaryContainer: onPrimaryContainer ?? this.onPrimaryContainer,
    action: action ?? this.action,
    onAction: onAction ?? this.onAction,
    actionPressed: actionPressed ?? this.actionPressed,
    actionContainer: actionContainer ?? this.actionContainer,
    onActionContainer: onActionContainer ?? this.onActionContainer,
    accent: accent ?? this.accent,
    onAccent: onAccent ?? this.onAccent,
    onAccentContainer: onAccentContainer ?? this.onAccentContainer,
    background: background ?? this.background,
    surface: surface ?? this.surface,
    surfaceSubtle: surfaceSubtle ?? this.surfaceSubtle,
    outline: outline ?? this.outline,
    controlBorder: controlBorder ?? this.controlBorder,
    focus: focus ?? this.focus,
    textPrimary: textPrimary ?? this.textPrimary,
    textSecondary: textSecondary ?? this.textSecondary,
    success: success ?? this.success,
    successContainer: successContainer ?? this.successContainer,
    onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
    warning: warning ?? this.warning,
    warningContainer: warningContainer ?? this.warningContainer,
    onWarningContainer: onWarningContainer ?? this.onWarningContainer,
    warningBorder: warningBorder ?? this.warningBorder,
    error: error ?? this.error,
    errorContainer: errorContainer ?? this.errorContainer,
    onErrorContainer: onErrorContainer ?? this.onErrorContainer,
    sos: sos ?? this.sos,
    onSos: onSos ?? this.onSos,
    sosContainer: sosContainer ?? this.sosContainer,
    onSosContainer: onSosContainer ?? this.onSosContainer,
    sosBorder: sosBorder ?? this.sosBorder,
    inverseSurface: inverseSurface ?? this.inverseSurface,
    onInverseSurface: onInverseSurface ?? this.onInverseSurface,
    ink: ink ?? this.ink,
    marigold: marigold ?? this.marigold,
    onMarigold: onMarigold ?? this.onMarigold,
    accentContainer: accentContainer ?? this.accentContainer,
    band: band ?? this.band,
    onBand: onBand ?? this.onBand,
    onBandMuted: onBandMuted ?? this.onBandMuted,
    done: done ?? this.done,
  );

  @override
  PawColors lerp(PawColors? other, double t) {
    if (other == null) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return PawColors(
      brand: l(brand, other.brand),
      onBrand: l(onBrand, other.onBrand),
      primaryContainer: l(primaryContainer, other.primaryContainer),
      onPrimaryContainer: l(onPrimaryContainer, other.onPrimaryContainer),
      action: l(action, other.action),
      onAction: l(onAction, other.onAction),
      actionPressed: l(actionPressed, other.actionPressed),
      actionContainer: l(actionContainer, other.actionContainer),
      onActionContainer: l(onActionContainer, other.onActionContainer),
      accent: l(accent, other.accent),
      onAccent: l(onAccent, other.onAccent),
      onAccentContainer: l(onAccentContainer, other.onAccentContainer),
      background: l(background, other.background),
      surface: l(surface, other.surface),
      surfaceSubtle: l(surfaceSubtle, other.surfaceSubtle),
      outline: l(outline, other.outline),
      controlBorder: l(controlBorder, other.controlBorder),
      focus: l(focus, other.focus),
      textPrimary: l(textPrimary, other.textPrimary),
      textSecondary: l(textSecondary, other.textSecondary),
      success: l(success, other.success),
      successContainer: l(successContainer, other.successContainer),
      onSuccessContainer: l(onSuccessContainer, other.onSuccessContainer),
      warning: l(warning, other.warning),
      warningContainer: l(warningContainer, other.warningContainer),
      onWarningContainer: l(onWarningContainer, other.onWarningContainer),
      warningBorder: l(warningBorder, other.warningBorder),
      error: l(error, other.error),
      errorContainer: l(errorContainer, other.errorContainer),
      onErrorContainer: l(onErrorContainer, other.onErrorContainer),
      sos: l(sos, other.sos),
      onSos: l(onSos, other.onSos),
      sosContainer: l(sosContainer, other.sosContainer),
      onSosContainer: l(onSosContainer, other.onSosContainer),
      sosBorder: l(sosBorder, other.sosBorder),
      inverseSurface: l(inverseSurface, other.inverseSurface),
      onInverseSurface: l(onInverseSurface, other.onInverseSurface),
      ink: l(ink, other.ink),
      marigold: l(marigold, other.marigold),
      onMarigold: l(onMarigold, other.onMarigold),
      accentContainer: l(accentContainer, other.accentContainer),
      band: l(band, other.band),
      onBand: l(onBand, other.onBand),
      onBandMuted: l(onBandMuted, other.onBandMuted),
      done: l(done, other.done),
    );
  }
}

/// The toran (UI Design 6): the marigold garland over a pet's doorway on
/// Home and the routine page. Drawn colours, the same in light and dark (the
/// garland always hangs on the dark kaapi band). Checked for 3:1 on the band
/// in test/core/contrast_test.dart.
class GarlandColors {
  /// Outer petals (lighter) and inner petals of an open flower.
  static const petalLight = Color(0xFFFFCB52);
  static const petal = Color(0xFFF8A80C);

  /// The heart of an open flower.
  static const heart = Color(0xFFE08600);

  /// The string the flowers hang on, and the mango leaves between them.
  static const stem = Color(0xFF7DB56F);
  static const leaf = Color(0xFF6DA862);

  /// A bud (a task not done yet): a dark knot with a light edge.
  static const bud = Color(0xFF4A3224);
  static const budEdge = Color(0xB3FBF2E3);

  /// The faint doorway outlines behind the arch.
  static const doorway = Color(0x14FBF2E3);
}

/// The drawn map preview ([MapSketch]): a quiet, OpenStreetMap-like palette,
/// the same in light and dark (it is a picture of a map).
class MapColors {
  static const land = Color(0xFFEFE7DA);
  static const park = Color(0xFFD9E9CF);
  static const water = Color(0xFFCFE3EE);
  static const road = Color(0xFFFFFFFF);
  static const you = Color(0xFF1F7FA8);
  static const pin = Color(0xFF2F1D14);
}

/// Drawn product pictures ([PackShot]): a strong colour on its pale tint,
/// the same in light and dark (they are pictures of packs).
class PackColors {
  static const pairs = <(Color, Color)>[
    (Color(0xFFC2552D), Color(0xFFF9E2D2)),
    (Color(0xFF2C6A43), Color(0xFFDDEDDD)),
    (Color(0xFFF8A80C), Color(0xFFFDEFCC)),
    (Color(0xFF7C6FD0), Color(0xFFE7E3FB)),
    (Color(0xFFDC2626), Color(0xFFFCE4E0)),
    (Color(0xFF1F7FA8), Color(0xFFDDECF5)),
  ];
  static const label = Color(0xFFFBF2E3);
  static const strap = Color(0xFF2B1A12);
  static const shade = Color(0x24000000);
  static const shadow = Color(0x142B1A12);
  static const lid = Color(0xFFD9D2C8);
  static const lidInner = Color(0xFFEFEAE2);
  static const ring = Color(0xFF9A897C);
  static const kibble = Color(0xFF8A4F00);
}

/// Pet colour tags (section 4). Stored on the pet as the tag key.
class PetTagColors {
  static const Map<String, Color> all = {
    'amber': Color(0xFFF4A261),
    'lavender': Color(0xFF9B8AFB),
    'sky': Color(0xFF38BDF8),
    'rose': Color(0xFFF472B6),
    'mint': Color(0xFF34D399),
    'sand': Color(0xFFD6B98C),
  };

  static Color of(String? key) => all[key] ?? all['amber']!;
}

/// Colours that tell kinds of things apart (routine log types, chart
/// series, document kinds). Muted mid-tones that sit with UI Design 5's cocoa
/// and marigold; none of them reads as red (SOS is the only red). Use them for icons and tints, not for body text; pass them
/// through [readableOn] when they colour text or sit on a dark surface.
class CategoryColors {
  /// Text or icons drawn on top of a category colour.
  static const onCategory = Color(0xFFFFFFFF);

  static const teal = Color(0xFF2F7D6D);
  static const amber = Color(0xFFB7791F);
  static const clay = Color(0xFF8E6343);
  static const sky = Color(0xFF3B82A6);
  static const olive = Color(0xFF5F7F2A);
  static const plum = Color(0xFF7C5CBF);
  static const rose = Color(0xFFA24D86);
  static const ocean = Color(0xFF2B6CB0);
  static const gold = Color(0xFFA77B06);
  static const slate = Color(0xFF64748B);
  static const violet = Color(0xFF6D4FC2);
}

/// Soft two-colour washes for the illustrated placeholder photos in the demo
/// (light tone first, deep tone second).
class SeedArtColors {
  /// Mixed into a category colour for the placeholder product art.
  static const light = Color(0xFFFFFFFF);
  static const shadow = Color(0xFF000000);

  static const pairs = [
    [Color(0xFFF4ECE3), Color(0xFF4A2A12)],
    [Color(0xFFFDE7D3), Color(0xFFF4A261)],
    [Color(0xFFDDD6FE), Color(0xFF9B8AFB)],
    [Color(0xFFBAE6FD), Color(0xFF38BDF8)],
    [Color(0xFFFBCFE8), Color(0xFFF472B6)],
    [Color(0xFFBBF7D0), Color(0xFF34D399)],
    [Color(0xFFF5E6CC), Color(0xFFD6B98C)],
    [Color(0xFFEFECE7), Color(0xFF8F5A00)],
  ];
}

/// Fixed colours for printed or shared documents (health report, invoice,
/// prescription, sample documents, lost poster, QR tag). They stay the same
/// in dark mode, because paper is always white.
class PrintColors {
  static const paper = Color(0xFFFFFFFF);
  static const ink = Color(0xFF231B12);
  static const muted = Color(0xFF5B5044);
  static const brand = Color(0xFF2F1D14);
  static const brandTint = Color(0xFFF4ECE0);
  static const alert = Color(0xFFB91C1C);
  static const rule = Color(0xFFE6E1DA);

  /// Every other row in a printed table.
  static const zebra = Color(0xFFF6F5F3);

  /// "Demo" note on printed pages.
  static const note = Color(0xFFFFFBEB);
  static const onNote = Color(0xFF78350F);
}

/// Photo and video screens (crop, viewer, video call) stay dark in both
/// themes so pictures look true.
class MediaColors {
  static const background = Color(0xFF000000);
  static const foreground = Color(0xFFFFFFFF);

  /// Hints and secondary labels on photos (white at 70%).
  static const foregroundMuted = Color(0xB3FFFFFF);

  /// Dark wash behind text or buttons laid over a photo (black at 54%).
  static const scrim = Color(0x8A000000);

  /// Soft shadow under map pins (black at 26%).
  static const mapShadow = Color(0x42000000);

  /// Light panel behind a small badge on a photo (white at 88%).
  static const photoPanel = Color(0xE0FFFFFF);

  /// Round buttons over video (white at 24%), and switched-off ones.
  static const control = Color(0x3DFFFFFF);
  static const controlDisabled = Color(0x1AFFFFFF);

  /// Video call: page, the cocoa glow behind the other person, the
  /// picture-in-picture tile, the avatar and its icon, and the small lines.
  static const callBackground = Color(0xFF14110D);
  static const callGlow = Color(0xFF2F1D14);
  static const callTile = Color(0xFF1F1A14);
  static const callAvatar = Color(0xFFF8A80C);
  static const onCallAvatar = Color(0xFF2A1A00);
  static const callSubtitle = Color(0xFFEAD7BA);
  static const callWarning = Color(0xFFFFC861);
  static const callGood = Color(0xFF6FD49A);
  static const callDemo = Color(0x33FFC861);
  static const onCallDemo = Color(0xFFFFE2A3);
}

/// WCAG contrast ratio between two opaque colours (1 to 21).
double contrastRatio(Color a, Color b) {
  final la = a.computeLuminance(), lb = b.computeLuminance();
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
}

/// [fg], made darker on light backgrounds (lighter on dark ones) until it
/// reads at [ratio] on every one of [backgrounds] (WCAG AA for text: 4.5).
Color readableOn(Color fg, List<Color> backgrounds, {double ratio = 4.5}) {
  var c = fg;
  for (final bg in backgrounds) {
    final toward = bg.computeLuminance() > 0.18 ? Colors.black : Colors.white;
    for (var i = 0; i < 20 && contrastRatio(c, bg) < ratio; i++) {
      c = Color.lerp(c, toward, 0.08)!;
    }
  }
  return c;
}

/// Font families (bundled in assets/fonts; all SIL OFL).
///
/// UI Design 6 "Toran": one family, Bricolage Grotesque, in two cuts made
/// from the variable font. Hindi and Telugu letters come from Noto Sans
/// (Bricolage has none), so mixed text like "Simba రోజు" keeps Latin in
/// Bricolage and Telugu in Noto.
class FontFamilies {
  /// Titles: Bricolage Grotesque, narrower and heavier (600, 700, 800).
  static const heading = 'BricolageDisplay';

  /// Titles in Telugu: the same title font; Telugu letters fall back to Noto.
  static const headingTelugu = heading;

  /// Text and labels: Bricolage Grotesque at full width (400 to 700).
  static const body = 'Bricolage';

  /// Text in Telugu: the same text font; Telugu letters fall back to Noto.
  static const bodyTelugu = body;

  /// Times, IDs, batch numbers and doses: the text font with tabular figures
  /// (see [TypeScale.mono]); no separate monospace font.
  static const mono = body;

  /// Hindi letters.
  static const devanagari = 'NotoSansDevanagari';

  /// Telugu letters.
  static const telugu = 'NotoSansTelugu';
}

/// One step of the type scale. [tracking] is in logical pixels.
class TypeToken {
  const TypeToken(this.size, this.lineHeight, this.weight, {this.tracking = 0, this.heading = false});
  final double size;
  final double lineHeight;
  final FontWeight weight;
  final double tracking;

  /// Set in the title font (Bricolage Grotesque, the narrow heavy cut).
  final bool heading;
}

/// The type scale (UI Design 6, DESIGN.md "Typography"). A small set of steps:
/// rank comes from these sizes and weights, never ad-hoc sizes. Hindi and
/// Telugu use line height 1.6 or more ([indicLineHeight]), no letter-spacing
/// and secondary text one step up ([indicSmallBump]). Nothing is under 13 px.
class TypeScale {
  static const display = TypeToken(40, 42, FontWeight.w800, tracking: -0.6, heading: true);
  static const displayPhone = TypeToken(34, 36, FontWeight.w800, tracking: -0.5, heading: true);
  static const headlineLarge = TypeToken(30, 33, FontWeight.w800, tracking: -0.4, heading: true);
  static const headline = TypeToken(26, 29, FontWeight.w800, tracking: -0.3, heading: true);
  static const headlineMedium = TypeToken(24, 28, FontWeight.w700, tracking: -0.2, heading: true);
  static const title = TypeToken(21, 25, FontWeight.w700, tracking: -0.2, heading: true);
  static const titleMedium = TypeToken(18, 22, FontWeight.w700, tracking: -0.1, heading: true);
  static const titleSmall = TypeToken(17, 22, FontWeight.w600, heading: true);
  static const bodyLarge = TypeToken(16, 23, FontWeight.w400);
  static const body = TypeToken(15, 22, FontWeight.w400);
  static const bodySmall = TypeToken(13, 18, FontWeight.w400);
  static const label = TypeToken(15, 20, FontWeight.w600);
  static const labelMedium = TypeToken(14, 20, FontWeight.w600);

  /// Badges, chart axes, small tags (12 px, the design's smallest text).
  static const labelSmall = TypeToken(12, 16, FontWeight.w600);

  /// The title of a sub-page, beside its back arrow.
  static const appBar = TypeToken(19, 24, FontWeight.w700, tracking: -0.2, heading: true);

  /// Labels under the dock icons (11 px in the design).
  static const dock = TypeToken(11, 13, FontWeight.w500);

  /// Small section labels ("Next for Bruno"). Sentence case, never
  /// upper-cased or letter-spaced (Hindi and Telugu can't be).
  static const overline = TypeToken(13, 18, FontWeight.w700);

  /// Monospace for IDs, batch numbers and doses.
  static const mono = TypeToken(14, 20, FontWeight.w500);

  /// The day number in a date block ("13" over "Fri").
  static const dateNumber = TypeToken(20, 28, FontWeight.w800, heading: true);

  /// The month on a date leaf's strip.
  static const dateMonth = TypeToken(11, 14, FontWeight.w600);

  static const double indicLineHeight = 1.6;

  /// Hindi and Telugu letters sit smaller than Latin at the same size, so
  /// text under 16 px gets this much more.
  static const double indicSmallBump = 1;

  /// Line height for big numbers stacked tight (date squares).
  static const double tightLineHeight = 1.0;
}

/// 4 px spacing grid.
class Space {
  /// Hairline gap (2 px) for fine optical adjustments.
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double x3l = 48;

  /// Side margin of a page on phones and on wider screens.
  static const double pagePhone = 16;
  static const double pageWide = 24;

  static const double maxContentWidth = 1200;

  /// Reading width for single-column pages (Home, lists, forms) on desktop.
  static const double readingWidth = 840;

  /// Narrower pages: forms, settings and step-by-step flows.
  static const double formWidth = 720;

  /// Wider single-column pages with charts or two-up cards.
  static const double wideWidth = 960;

  /// Room left under a list so a floating button never covers the last row.
  static const double fabClearance = 80;
}

/// Corners.
class Radii {
  /// Checkboxes.
  static const double xs = 4;
  static const double sm = 8;

  /// Inputs, search fields, date boxes.
  static const double md = 12;
  static const double lg = 16;

  /// Cards.
  static const double xl = 22;

  /// Bottom sheets and dialogs.
  static const double xxl = 28;

  /// Pills: buttons, chips, tags, avatars.
  static const double full = 999;

  static const double card = xl;
  static const double button = full;
  static const double input = lg;
  static const double sheet = xxl;
}

/// Icon sizes.
class IconSizes {
  /// Inside chips and tags.
  static const double xs = 14;
  static const double sm = 16;
  static const double md = 20;
  static const double lg = 24;

  /// Round "log" and "play" buttons in lists.
  static const double action = 28;
  static const double xl = 32;
  static const double xxl = 36;

  /// Icon in a big emergency option.
  static const double xxxl = 40;

  /// Leading icon inside a chip (Material's chip size).
  static const double chip = 18;

  /// Large icon above an empty, error or success message.
  static const double hero = 56;
}

/// Fixed sizes of a few components.
class Sizes {
  /// Home quick-action tiles (normal and Easy mode).
  static const double quickTile = 108;
  static const double quickTileEasy = 140;

  /// Pet photo on the Home pet card.
  static const double heroAvatar = 72;

  /// Smallest height of a quick-action tile at any text size.
  static const double quickTileMin = 96;

  /// Loading placeholder for a card.
  static const double skeletonCard = 120;

  /// Widest a bottom sheet gets on tablets and desktop.
  static const double sheetMaxWidth = 640;

  /// Today card progress ring (normal and Easy mode).
  static const double todayRing = 68;
  static const double todayRingEasy = 84;

  /// Avatars inside chips, and in rows and headers.
  static const double avatarChip = 24;
  static const double avatarXs = 28;
  static const double avatarSm = 40;
  static const double avatarMd = 48;
  static const double avatarLg = 60;

  /// Pet profile header: base height, extra height per step of text size,
  /// and the photo (smaller at very large text).
  static const double profileHeader = 220;
  static const double profileHeaderPerText = 60;
  static const double profileAvatar = 132;
  static const double profileAvatarSm = 104;

  /// Birthday screen: the glow behind the photo, and the photo.
  static const double birthdayGlow = 168;
  static const double birthdayAvatar = 128;

  /// Square product or photo thumbnails, smallest to largest.
  static const double thumbSm = 44;
  static const double thumb = 56;
  static const double thumbLg = 64;
  static const double thumbXl = 72;

  /// Shop: a compact product card in a row, the text block under a product
  /// picture, the picture's width-to-height ratio, the buy-again tile and
  /// the reorder card.
  static const double productCardCompact = 158;
  static const double productTextBlock = 128;
  static const double productArtAspect = 1.08;

  /// A "buy again" card in the Shop's row.
  static const double buyAgainCard = 248;
  static const double buyAgainTile = 112;
  static const double reorderCard = 300;

  /// Pin code box (6 digits).
  static const double pinField = 160;

  /// Order progress: the rail and its round step marker.
  static const double stepRail = 28;
  static const double stepDot = 22;

  /// Colour key square beside a chart label.
  static const double legendDot = 10;

  /// Taller chart (money over time).
  static const double chartHeightLg = 220;

  /// Strip of day buttons in the booking flow.
  static const double dateStrip = 76;

  /// Narrow centred pages (booking done, success screens).
  static const double narrowPage = 480;

  /// Big success picture.
  static const double successArt = 180;

  /// Widest an empty or error message gets.
  static const double emptyStateWidth = 420;

  /// Bar and line charts.
  static const double chartHeight = 200;

  /// The weight chart on Health.
  static const double chartHeightSm = 150;
  static const double chartAxisLeft = 36;
  static const double chartAxisLeftWide = 40;
  static const double chartAxisBottom = 28;
  static const double barThin = 6;
  static const double barWide = 18;

  /// Tiny trend line beside a label.
  static const double sparklineWidth = 120;
  static const double sparklineHeight = 40;

  /// Video call: the other person's avatar, the self view, the round
  /// buttons (end call is bigger) and the label under each button.
  static const double callAvatar = 128;
  static const double selfViewWidth = 104;
  static const double selfViewHeight = 140;
  static const double callButton = 58;
  static const double callButtonEnd = 68;
  static const double callLabel = 76;

  /// Photo tile in an attachment grid.
  static const double photoTile = 84;

  /// Chat: widest message bubble, the unread dot, the list pane on wide
  /// screens, and the side panels in the vet's consult screen.
  static const double bubbleMaxWidth = 460;
  static const double dot = 8;
  static const double listPane = 380;
  static const double sidePanel = 340;
  static const double sidePanelWide = 360;

  /// Narrow label column (short labels).
  static const double labelColumnSm = 96;

  /// Voice note waveform width.
  static const double voiceWave = 120;

  /// The logo in headers, and the bigger one on sign-in.
  static const double logo = 36;
  static const double logoLg = 56;

  /// Document type badge (in rows, and big on a preview).
  static const double docBadge = 36;
  static const double docBadgeLg = 64;

  /// Document preview inside a page (normal and smaller).
  static const double docPreview = 300;
  static const double docPreviewSm = 220;

  /// Round drag handle on the scan crop frame.
  static const double handle = 22;

  /// Vault PIN pad: a dot, a key, and a key with its padding.
  static const double pinDot = 16;
  static const double pinKey = 68;
  static const double pinKeyCell = 80;

  /// Plan comparison column.
  static const double planColumn = 88;

  /// Album: the photo picker preview, a memory tile, the memory card, the
  /// badge cell under a milestone and the share card picture.
  static const double albumPick = 160;
  static const double memoryTile = 120;
  static const double memoryCard = 112;
  static const double badgeCell = 76;
  static const double shareCard = 200;

  /// The logo on the splash screen.
  static const double logoXl = 72;

  /// Side menu width in the partner, seller and admin portals.
  static const double portalNav = 280;

  /// Desktop side navigation (DESIGN.md: 256 px, labels on one line).
  static const double sideNav = 256;

  /// Sign-in card width on wide screens.
  static const double authCard = 440;

  /// Previews in the design gallery.
  static const double galleryPreview = 300;
  static const double galleryPreviewSm = 260;

  /// Floating bottom bar on phones, and the top bar on wide screens.
  static const double dock = 68;
  static const double header = 72;

  /// Floating dock (phones): the marigold pill behind the current tab's
  /// icon, the icon, the dock's corners and its gap from the screen edge.
  static const double dockPillWidth = 48;
  static const double dockPillHeight = 30;
  static const double dockIcon = 22;
  static const double dockRadius = 24;

  /// Top bar: round buttons, the SOS pill and the pet pills are this tall;
  /// the PawSetu mark; the pet's arch inside a pill (its width).
  static const double topControl = 44;
  static const double topLogo = 32;
  static const double pillArch = 28;
  static const double topIcon = 22;

  /// Space between two sections of a page.
  static const double sectionGap = 28;

  /// Rounded tiles (places, things, features): the usual size, the corner
  /// and the icon as shares of the size.
  static const double tile = 44;
  static const double tileLg = 52;
  static const double tileXl = 68;
  static const double tileCorner = 0.3;
  static const double tileIcon = 0.48;

  /// Tags, chips, list rows and small buttons (heights).
  static const double tag = 24;
  static const double chip = 40;
  static const double item = 56;
  static const double buttonSmall = 36;

  /// Search pills and one-line fields.
  static const double field = 52;

  /// The pet's arch on the health pass (its height with the ring; the
  /// picture inside is 64 px wide).
  static const double passArch = 89;

  /// A pet's arch on Me (its height with the ring; the picture is 60 px wide).
  static const double meArch = 84;

  /// Welcome: the side arches and the middle garland.
  static const double welcomeArch = 84;
  static const double welcomeGarland = 168;

  /// The pet's arch on its profile cover (the picture's width).
  static const double coverArch = 152;

  /// Quick-action circles on Home.
  static const double quickCircle = 56;

  /// The walk strip on the weather card, and the marker for "now".
  static const double walkBar = 10;
  static const double walkNow = 18;

  /// The memory print on Home (a small instant photo).
  static const double print = 152;

  /// How far the print leans (radians; about 2.5 degrees).
  static const double printTilt = 0.0436;

  /// Big tappable SOS option.
  static const double sosOption = 96;

  /// Small spinner beside a line of text.
  static const double spinner = 22;

  /// Small map inside a card.
  /// The drawn map on the Book tab's map card.
  static const double mapSketch = 136;

  static const double mapSmall = 180;

  /// Medium map inside a page.
  static const double mapMedium = 200;

  /// QR code shown on screen.
  static const double qr = 180;

  /// Map pin for a place.
  static const double mapPin = 44;

  /// Photo on the left of a place card.
  static const double placePhotoWidth = 92;
  static const double placePhotoHeight = 112;

  /// Narrowest small card in a grid (deworming and flea/tick, side by side).
  static const double miniCardMin = 260;

  /// Picture on top of a place card in a list, and the narrowest card in a
  /// grid of them.
  static const double placeCardPhoto = 168;
  static const double placeCardMinWidth = 320;

  /// Photo header on a place page (phones: full width under the app bar).
  static const double placeHeader = 200;

  /// Rounded photo on a place page on tablets and desktops: width-to-height
  /// ratio, and the tallest it gets.
  static const double placePhotoAspect = 16 / 10;
  static const double placePhotoMaxHeight = 440;

  /// Date square at the start of a booking row.
  static const double dateBadge = 48;

  /// Date leaf: the month strip and the day row.
  static const double dateStripRow = 18;
  static const double dateDayRow = 28;

  /// Minimum list row height (DESIGN.md: 64 px; 76 px in Easy mode).
  static const double listRow = 64;

  /// Below this width the health pass stacks its buttons.
  static const double passActionsRow = 320;
  static const double listRowEasy = 76;

  /// The garland on the Genda band (Home): full and compact (narrow screens,
  /// big text). The pet photo inside is [garlandPhotoShare] of it.
  static const double garland = 152;
  static const double garlandLarge = 176;
  static const double garlandCompact = 120;
  static const double garlandPhotoShare = 0.63;

  /// The pet's arch: height = width × [archAspect] (a half circle on top).
  static const double archAspect = 1.24;

  /// Height of the progress bar on the Genda band.
  static const double gendaBar = 10;

  /// Width of the label column in label/value rows.
  static const double labelColumn = 120;

  /// Photo beside an update in a list.
  static const double updatePhoto = 96;

  /// Live map inside a booking.
  static const double liveMap = 240;

  /// Walk route map inside a sheet, and the smaller one in a card.
  static const double routeMap = 280;
  static const double routeMapSmall = 220;

  /// Smallest height of a form box, and of a picker that looks like one.
  static const double fieldHeight = 52;

  /// Choice tiles (species picker): narrowest tile and smallest height.
  static const double choiceTileMin = 88;
  static const double choiceTileHeight = 84;

  /// Photo circle on the add/edit pet form.
  static const double formAvatar = 112;

  /// Thin progress bar for steps in a flow, and the thicker level meter
  /// (food hopper, battery).
  static const double progressBar = 6;
  static const double meterBar = 12;

  /// Timeline rail width and the dot on it.
  static const double timelineRail = 24;
  static const double timelineDot = 12;

  /// Width of the number between a stepper's minus and plus buttons.
  static const double stepperValue = 40;

  /// Illustrations above empty states (compact and normal).
  static const double illustrationSm = 110;
  static const double illustration = 160;

  /// The square photo crop frame stays between these sizes.
  static const double cropMin = 200;
  static const double cropMax = 520;
}

/// Minimum touch target (48 px; 56 px in Easy mode).
class TapTarget {
  static const double min = 48;
  static const double easy = 56;
}

/// Shadows: a 1 px warm border does most of the work; shadows stay soft.
class Shadows {
  /// Cards (light mode only; dark mode uses surface tones and the border).
  static List<BoxShadow> card(Color ink) => [
    BoxShadow(color: ink.withValues(alpha: 0.04), offset: const Offset(0, 1)),
    BoxShadow(color: ink.withValues(alpha: 0.28), blurRadius: 28, spreadRadius: -16, offset: const Offset(0, 10)),
  ];

  /// The floating dock and other raised dark panels (the design's shadow-2).
  static List<BoxShadow> raised(Color ink) => [
    BoxShadow(color: ink.withValues(alpha: 0.05), offset: const Offset(0, 2)),
    BoxShadow(color: ink.withValues(alpha: 0.45), blurRadius: 48, spreadRadius: -24, offset: const Offset(0, 24)),
  ];

  /// Sheets, dialogs and menus.
  static List<BoxShadow> overlay(Color ink) => [BoxShadow(color: ink.withValues(alpha: 0.14), blurRadius: 48, spreadRadius: -8, offset: const Offset(0, 20))];
}

/// Line widths.
class Strokes {
  static const double hairline = 1;

  /// Selected or highlighted borders.
  static const double strong = 1.5;

  /// Focus rings and the selected pill.
  static const double focus = 2;

  /// Loading spinners inside buttons.
  static const double spinner = 2.5;

  /// The SOS hold ring.
  static const double ring = 4;

  /// Pet avatar ring (normal and selected).
  static const double avatarRing = 2;
  static const double avatarRingSelected = 3;

  /// Lines in charts and trend lines, and walk routes on maps.
  static const double chart = 3;
  static const double route = 5;

  /// Dashed goal lines in charts (dash, gap).
  static const List<int> dash = [6, 4];
}

/// Letter spacing for short all-caps or brand words ("SOS").
class Tracking {
  static const double wide = 0.5;

  /// IDs and coupon codes, and big codes people read out or type.
  static const double id = 1;
  static const double code = 4;
}

/// Opacities for tints, overlays and soft borders.
class Opacities {
  static const double hover = 0.04;
  static const double highlight = 0.06;
  static const double pressed = 0.08;
  static const double focus = 0.16;
  static const double selection = 0.24;

  /// Soft background behind an icon or a note.
  static const double tint = 0.10;

  /// Background of a status chip.
  static const double chip = 0.14;
  static const double tintStrong = 0.22;

  /// Border of a tinted note.
  static const double border = 0.30;

  /// Dimmed part of a loading placeholder, and disabled art.
  static const double muted = 0.40;

  /// Archived or paused items (cards and their photos).
  static const double faded = 0.80;
  static const double fadedArt = 0.75;

  /// Light wash of a container colour.
  static const double half = 0.50;

  /// Secondary text on the dark pass card (checked for 4.5:1 in use).
  static const double onDarkMuted = 0.78;
}

/// Motion timings.
class Motion {
  static const tap = Duration(milliseconds: 100);
  static const toggle = Duration(milliseconds: 150);
  static const enter = Duration(milliseconds: 250);
  static const exit = Duration(milliseconds: 200);
  static const Curve standard = Cubic(0.4, 0, 0.2, 1);
  static const Curve emphasized = Cubic(0.16, 1, 0.3, 1);

  /// Pressed cards and buttons shrink to this scale.
  static const double pressScale = 0.98;
}

/// Extra text styles that Material's TextTheme has no slot for.
class PawTextStyles extends ThemeExtension<PawTextStyles> {
  const PawTextStyles({required this.mono, required this.overline, required this.dateNumber});
  final TextStyle mono;
  final TextStyle overline;

  /// The day number in a date block.
  final TextStyle dateNumber;

  @override
  PawTextStyles copyWith({TextStyle? mono, TextStyle? overline, TextStyle? dateNumber}) =>
      PawTextStyles(mono: mono ?? this.mono, overline: overline ?? this.overline, dateNumber: dateNumber ?? this.dateNumber);

  @override
  PawTextStyles lerp(PawTextStyles? other, double t) => other == null
      ? this
      : PawTextStyles(
          mono: TextStyle.lerp(mono, other.mono, t)!,
          overline: TextStyle.lerp(overline, other.overline, t)!,
          dateNumber: TextStyle.lerp(dateNumber, other.dateNumber, t)!,
        );
}

/// Extra UI Design 6 "Toran" tints that only need a light and a dark value
/// (the design kit's line-2, paper-3, ink-3, sky and the darker kaapi tones).
class ToranTints {
  const ToranTints._({
    required this.line2,
    required this.paper3,
    required this.ink3,
    required this.sky,
    required this.skyWash,
    required this.band2,
    required this.bandLine,
    required this.heat,
    required this.star,
  });

  /// Edge of chips, pet pills and date leaves (decorative; the label carries
  /// the meaning).
  final Color line2;

  /// The deepest paper: empty bars, photo placeholders.
  final Color paper3;

  /// Quietest text and chevrons.
  final Color ink3;

  /// Sky: weather, video and information tiles.
  final Color sky;
  final Color skyWash;

  /// On the kaapi band: a lighter panel and hairlines.
  final Color band2;
  final Color bandLine;

  /// "Too hot" hours on the walk strip.
  final Color heat;

  /// Rating stars.
  final Color star;

  static const light = ToranTints._(
    line2: Color(0xFFD8C9B5),
    paper3: Color(0xFFECE1D1),
    ink3: Color(0xFF7A6A5E),
    sky: Color(0xFF1F5B80),
    skyWash: Color(0xFFDDECF5),
    band2: Color(0xFF422B1E),
    bandLine: Color(0xFF5A4031),
    heat: Color(0xFFE9756C),
    star: Color(0xFFC77700),
  );

  static const dark = ToranTints._(
    line2: Color(0xFF4E3D2F),
    paper3: Color(0xFF2B2018),
    ink3: Color(0xFF978573),
    sky: Color(0xFF9CCDEA),
    skyWash: Color(0xFF16303F),
    band2: Color(0xFF3A281C),
    bandLine: Color(0xFF54402F),
    heat: Color(0xFFE9756C),
    star: Color(0xFFFBB431),
  );
}

extension PawThemeX on BuildContext {
  PawColors get paw => Theme.of(this).extension<PawColors>()!;

  /// The extra Toran tints for the current brightness.
  ToranTints get tint => Theme.of(this).brightness == Brightness.light ? ToranTints.light : ToranTints.dark;
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get text => Theme.of(this).textTheme;
  PawTextStyles get textX => Theme.of(this).extension<PawTextStyles>()!;
}
