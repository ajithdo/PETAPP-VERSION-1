import 'dart:math' as math;

import 'package:flutter/material.dart';

// Design tokens: Design 2, "Warm Clinical Trust & Playful Care"
// (docs/design-2/). Every colour, font, size, gap, corner, shadow and timing
// in the app comes from this file. Never hard-code these values in widgets.
//
// Changes from the Stitch design rules, made so everything stays readable
// (docs/design-2/REVIEW.md):
// - The coral moves slightly towards terracotta (#C84735 to #B9532E), so the
//   everyday "Book" buttons no longer look like the SOS red.
// - Secondary grey is #6B635D, not #78716C, which was too faint on sand.
// - Inputs and outlined controls get a darker border (3:1); the warm
//   #E7E2DA border is kept for cards only.
// - Amber and green buttons use the darker shades so white text reads.
// - The smallest text is 12 px (uppercase labels); everything else is 13 px+.

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
  });

  /// Deep forest teal: the brand, navigation, links, selected chips,
  /// verified and health information.
  final Color brand;
  final Color onBrand;

  /// Soft sage behind brand information (verified tags, life stage, tips).
  final Color primaryContainer;
  final Color onPrimaryContainer;

  /// Terracotta coral: the one main action on a screen (Book, Confirm, Save).
  final Color action;
  final Color onAction;
  final Color actionPressed;
  final Color actionContainer;
  final Color onActionContainer;

  /// Amber highlight: ratings, Plus membership, streaks, birthdays.
  final Color accent;
  final Color onAccent;

  /// Icons and text on an amber tint.
  final Color onAccentContainer;

  /// Warm alabaster page.
  final Color background;

  /// White cards and sheets.
  final Color surface;

  /// Soft sand for grouped areas and neutral chips.
  final Color surfaceSubtle;

  /// Warm 1 px card border (decorative).
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

  /// Toasts and the dark health-pass card.
  final Color inverseSurface;
  final Color onInverseSurface;

  /// Shadow colour.
  final Color ink;

  static const light = PawColors(
    brand: Color(0xFF18453E),
    onBrand: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFE6F0ED),
    onPrimaryContainer: Color(0xFF18453E),
    action: Color(0xFFB9532E),
    onAction: Color(0xFFFFFFFF),
    actionPressed: Color(0xFF9A4224),
    actionContainer: Color(0xFFFBEDE7),
    onActionContainer: Color(0xFF9A3412),
    accent: Color(0xFFB45309),
    onAccent: Color(0xFFFFFFFF),
    onAccentContainer: Color(0xFF78350F),
    background: Color(0xFFFAF8F5),
    surface: Color(0xFFFFFFFF),
    surfaceSubtle: Color(0xFFF3EFEA),
    outline: Color(0xFFE7E2DA),
    controlBorder: Color(0xFF8F877F),
    focus: Color(0xFFB9532E),
    textPrimary: Color(0xFF1C1917),
    textSecondary: Color(0xFF6B635D),
    success: Color(0xFF15803D),
    successContainer: Color(0xFFDCFCE7),
    onSuccessContainer: Color(0xFF166534),
    warning: Color(0xFFB45309),
    warningContainer: Color(0xFFFFFBEB),
    onWarningContainer: Color(0xFF78350F),
    warningBorder: Color(0xFFFDE68A),
    error: Color(0xFFB91C1C),
    errorContainer: Color(0xFFFEF2F2),
    onErrorContainer: Color(0xFF991B1B),
    sos: Color(0xFFDC2626),
    onSos: Color(0xFFFFFFFF),
    sosContainer: Color(0xFFFEF2F2),
    onSosContainer: Color(0xFFB91C1C),
    sosBorder: Color(0xFFFECACA),
    inverseSurface: Color(0xFF292524),
    onInverseSurface: Color(0xFFF5F5F4),
    ink: Color(0xFF1C1917),
  );

  static const dark = PawColors(
    brand: Color(0xFF52B7A5),
    onBrand: Color(0xFF0A2923),
    primaryContainer: Color(0xFF1D3A35),
    onPrimaryContainer: Color(0xFFCDEAE3),
    action: Color(0xFFFF8A65),
    onAction: Color(0xFF45120B),
    actionPressed: Color(0xFFFFA586),
    actionContainer: Color(0xFF3A1C12),
    onActionContainer: Color(0xFFFFC9B5),
    accent: Color(0xFFFBBF24),
    onAccent: Color(0xFF3B2405),
    onAccentContainer: Color(0xFFFDE68A),
    background: Color(0xFF141517),
    surface: Color(0xFF1C1D21),
    surfaceSubtle: Color(0xFF24262B),
    outline: Color(0xFF2E3138),
    controlBorder: Color(0xFF6B6F78),
    focus: Color(0xFFFF8A65),
    textPrimary: Color(0xFFF5F5F4),
    textSecondary: Color(0xFFB5AFAA),
    success: Color(0xFF4ADE80),
    successContainer: Color(0xFF12321F),
    onSuccessContainer: Color(0xFFBBF7D0),
    warning: Color(0xFFFBBF24),
    warningContainer: Color(0xFF3A2A0A),
    onWarningContainer: Color(0xFFFDE68A),
    warningBorder: Color(0xFF5C4410),
    error: Color(0xFFF87171),
    errorContainer: Color(0xFF3B1212),
    onErrorContainer: Color(0xFFFECACA),
    sos: Color(0xFFDC2626),
    onSos: Color(0xFFFFFFFF),
    sosContainer: Color(0xFF3B1212),
    onSosContainer: Color(0xFFFCA5A5),
    sosBorder: Color(0xFF7F1D1D),
    inverseSurface: Color(0xFFE7E5E4),
    onInverseSurface: Color(0xFF1C1917),
    ink: Color(0xFF000000),
  );

  /// High-contrast variants: darker text and borders for low vision.
  PawColors highContrast(Brightness b) {
    final light = b == Brightness.light;
    return copyWith(
      textPrimary: light ? const Color(0xFF000000) : const Color(0xFFFFFFFF),
      textSecondary: light ? const Color(0xFF3F3A36) : const Color(0xFFE7E5E4),
      outline: light ? const Color(0xFF8F877F) : const Color(0xFF6B6F78),
      controlBorder: light ? const Color(0xFF57534E) : const Color(0xFFA8A29E),
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
  }) =>
      PawColors(
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
    );
  }
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

/// Font families (bundled in assets/fonts).
class FontFamilies {
  /// Headings in English.
  static const heading = 'PlusJakartaSans';

  /// Body text and labels in English.
  static const body = 'Inter';

  /// Times, IDs, batch numbers and doses.
  static const mono = 'JetBrainsMono';

  /// Hindi.
  static const devanagari = 'NotoSansDevanagari';

  /// Telugu.
  static const telugu = 'NotoSansTelugu';
}

/// One step of the type scale. [tracking] is in logical pixels.
class TypeToken {
  const TypeToken(this.size, this.lineHeight, this.weight, {this.tracking = 0, this.heading = false});
  final double size;
  final double lineHeight;
  final FontWeight weight;
  final double tracking;

  /// Set in the heading font (Plus Jakarta Sans) in English.
  final bool heading;
}

/// The type scale (Design 2). Hindi and Telugu use the same sizes with at
/// least 1.6 line height ([indicLineHeight]) and no negative tracking.
class TypeScale {
  static const display = TypeToken(40, 48, FontWeight.w700, tracking: -0.8, heading: true);
  static const displayPhone = TypeToken(28, 34, FontWeight.w700, tracking: -0.5, heading: true);
  static const headlineLarge = TypeToken(32, 38, FontWeight.w700, tracking: -0.6, heading: true);
  static const headline = TypeToken(24, 30, FontWeight.w700, tracking: -0.4, heading: true);
  static const headlineMedium = TypeToken(24, 30, FontWeight.w600, tracking: -0.3, heading: true);
  static const title = TypeToken(20, 26, FontWeight.w700, tracking: -0.2, heading: true);
  static const titleMedium = TypeToken(18, 24, FontWeight.w700, tracking: -0.2, heading: true);
  static const titleSmall = TypeToken(16, 22, FontWeight.w700, tracking: -0.1, heading: true);
  static const bodyLarge = TypeToken(16, 24, FontWeight.w400);
  static const body = TypeToken(15, 22, FontWeight.w400);
  static const bodySmall = TypeToken(13, 18, FontWeight.w400);
  static const label = TypeToken(15, 20, FontWeight.w600);
  static const labelMedium = TypeToken(13, 18, FontWeight.w600);

  /// Uppercase micro labels ("AVAILABLE SLOT"): the smallest text in the app.
  static const overline = TypeToken(12, 16, FontWeight.w700, tracking: 0.6);

  /// Monospace for times, IDs and doses.
  static const mono = TypeToken(13, 18, FontWeight.w500);

  static const double indicLineHeight = 1.6;
}

/// 4 px spacing grid.
class Space {
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
}

/// Corners.
class Radii {
  static const double sm = 6;

  /// Inputs, search fields, date boxes.
  static const double md = 12;
  static const double lg = 16;

  /// Cards.
  static const double xl = 20;

  /// Bottom sheets and dialogs.
  static const double xxl = 28;

  /// Pills: buttons, chips, tags, avatars.
  static const double full = 999;

  static const double card = xl;
  static const double button = full;
  static const double input = md;
  static const double sheet = xxl;
}

/// Icon sizes.
class IconSizes {
  static const double sm = 16;
  static const double md = 20;
  static const double lg = 24;
  static const double xl = 32;
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
        BoxShadow(color: ink.withValues(alpha: 0.04), blurRadius: 3, offset: const Offset(0, 1)),
        BoxShadow(color: ink.withValues(alpha: 0.06), blurRadius: 24, spreadRadius: -4, offset: const Offset(0, 8)),
      ];

  /// Sheets, dialogs and menus.
  static List<BoxShadow> overlay(Color ink) => [
        BoxShadow(color: ink.withValues(alpha: 0.14), blurRadius: 48, spreadRadius: -8, offset: const Offset(0, 20)),
      ];
}

/// Opacities for tints, overlays and soft borders.
class Opacities {
  static const double hover = 0.04;
  static const double pressed = 0.08;

  /// Soft background behind an icon or a note.
  static const double tint = 0.10;

  /// Background of a status chip.
  static const double chip = 0.14;
  static const double tintStrong = 0.22;

  /// Border of a tinted note.
  static const double border = 0.30;
}

/// Motion timings.
class Motion {
  static const tap = Duration(milliseconds: 100);
  static const toggle = Duration(milliseconds: 150);
  static const enter = Duration(milliseconds: 250);
  static const exit = Duration(milliseconds: 180);
  static const Curve standard = Cubic(0.4, 0, 0.2, 1);
  static const Curve emphasized = Cubic(0.16, 1, 0.3, 1);

  /// Pressed cards and buttons shrink to this scale.
  static const double pressScale = 0.98;
}

/// Extra text styles that Material's TextTheme has no slot for.
class PawTextStyles extends ThemeExtension<PawTextStyles> {
  const PawTextStyles({required this.mono, required this.overline});

  /// Times, IDs, batch numbers and doses.
  final TextStyle mono;

  /// Uppercase micro labels.
  final TextStyle overline;

  @override
  PawTextStyles copyWith({TextStyle? mono, TextStyle? overline}) =>
      PawTextStyles(mono: mono ?? this.mono, overline: overline ?? this.overline);

  @override
  PawTextStyles lerp(PawTextStyles? other, double t) => other == null
      ? this
      : PawTextStyles(mono: TextStyle.lerp(mono, other.mono, t)!, overline: TextStyle.lerp(overline, other.overline, t)!);
}

extension PawThemeX on BuildContext {
  PawColors get paw => Theme.of(this).extension<PawColors>()!;
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get text => Theme.of(this).textTheme;
  PawTextStyles get textX => Theme.of(this).extension<PawTextStyles>()!;
}
