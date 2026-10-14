import 'package:flutter/material.dart';

/// Design tokens from section 4 of docs/PROJECT_SPEC.md.
/// Every colour in the app comes from here; never hard-code colours in widgets.
class PawColors extends ThemeExtension<PawColors> {
  const PawColors({
    required this.accent,
    required this.onAccent,
    required this.background,
    required this.surface,
    required this.outline,
    required this.textPrimary,
    required this.textSecondary,
    required this.success,
    required this.warning,
    required this.error,
    required this.sos,
    required this.onSos,
    required this.primaryContainer,
  });

  final Color accent;
  final Color onAccent;
  final Color background;
  final Color surface;
  final Color outline;
  final Color textPrimary;
  final Color textSecondary;
  final Color success;
  final Color warning;
  final Color error;
  final Color sos;
  final Color onSos;
  final Color primaryContainer;

  static const light = PawColors(
    accent: Color(0xFFF4A261),
    onAccent: Color(0xFF3B1F06),
    background: Color(0xFFFAF8F5),
    surface: Color(0xFFFFFFFF),
    outline: Color(0xFFE5E1DA),
    textPrimary: Color(0xFF1C2B2D),
    textSecondary: Color(0xFF5B6B6E),
    success: Color(0xFF15803D),
    warning: Color(0xFFB45309),
    error: Color(0xFFB91C1C),
    sos: Color(0xFFDC2626),
    onSos: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFCCFBF1),
  );

  static const dark = PawColors(
    accent: Color(0xFFF6BD8A),
    onAccent: Color(0xFF3B1F06),
    background: Color(0xFF0E1415),
    surface: Color(0xFF172124),
    outline: Color(0xFF2A3639),
    textPrimary: Color(0xFFE8EEEE),
    textSecondary: Color(0xFF9FB0B2),
    success: Color(0xFF4ADE80),
    warning: Color(0xFFFBBF24),
    error: Color(0xFFF87171),
    sos: Color(0xFFDC2626),
    onSos: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFF134E4A),
  );

  /// High-contrast variants: darker text and outlines for low vision.
  PawColors highContrast(Brightness b) => copyWith(
        textPrimary: b == Brightness.light ? const Color(0xFF000000) : const Color(0xFFFFFFFF),
        textSecondary: b == Brightness.light ? const Color(0xFF243336) : const Color(0xFFD5E0E1),
        outline: b == Brightness.light ? const Color(0xFF5B6B6E) : const Color(0xFF9FB0B2),
      );

  @override
  PawColors copyWith({
    Color? accent,
    Color? onAccent,
    Color? background,
    Color? surface,
    Color? outline,
    Color? textPrimary,
    Color? textSecondary,
    Color? success,
    Color? warning,
    Color? error,
    Color? sos,
    Color? onSos,
    Color? primaryContainer,
  }) =>
      PawColors(
        accent: accent ?? this.accent,
        onAccent: onAccent ?? this.onAccent,
        background: background ?? this.background,
        surface: surface ?? this.surface,
        outline: outline ?? this.outline,
        textPrimary: textPrimary ?? this.textPrimary,
        textSecondary: textSecondary ?? this.textSecondary,
        success: success ?? this.success,
        warning: warning ?? this.warning,
        error: error ?? this.error,
        sos: sos ?? this.sos,
        onSos: onSos ?? this.onSos,
        primaryContainer: primaryContainer ?? this.primaryContainer,
      );

  @override
  PawColors lerp(PawColors? other, double t) {
    if (other == null) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return PawColors(
      accent: l(accent, other.accent),
      onAccent: l(onAccent, other.onAccent),
      background: l(background, other.background),
      surface: l(surface, other.surface),
      outline: l(outline, other.outline),
      textPrimary: l(textPrimary, other.textPrimary),
      textSecondary: l(textSecondary, other.textSecondary),
      success: l(success, other.success),
      warning: l(warning, other.warning),
      error: l(error, other.error),
      sos: l(sos, other.sos),
      onSos: l(onSos, other.onSos),
      primaryContainer: l(primaryContainer, other.primaryContainer),
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

/// 4-point spacing grid and shape radii.
class Space {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double maxContentWidth = 1200;
}

class Radii {
  static const double card = 20;
  static const double button = 14;
  static const double sheet = 28;
}

extension PawThemeX on BuildContext {
  PawColors get paw => Theme.of(this).extension<PawColors>()!;
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get text => Theme.of(this).textTheme;
}
