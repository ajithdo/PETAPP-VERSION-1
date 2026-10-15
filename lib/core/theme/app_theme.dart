import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';

import 'tokens.dart';

/// Builds the Material 3 theme from the design tokens (spec section 4).
class AppTheme {
  static const _jakarta = 'PlusJakartaSans';
  static const _deva = 'NotoSansDevanagari';
  static const _telugu = 'NotoSansTelugu';

  static String fontFor(String locale) => switch (locale) {
        'hi' => _deva,
        'te' => _telugu,
        _ => _jakarta,
      };

  static List<String> fallbackFor(String locale) => switch (locale) {
        'hi' => const [_jakarta, _telugu],
        'te' => const [_jakarta, _deva],
        _ => const [_deva, _telugu],
      };

  static ThemeData build({
    required Brightness brightness,
    required String locale,
    bool highContrast = false,
    bool easyMode = false,
  }) {
    final light = brightness == Brightness.light;
    var paw = light ? PawColors.light : PawColors.dark;
    if (highContrast) paw = paw.highContrast(brightness);

    final primary = light ? const Color(0xFF0F766E) : const Color(0xFF2DD4BF);
    final onPrimary = light ? const Color(0xFFFFFFFF) : const Color(0xFF04201D);

    final scheme = ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: paw.primaryContainer,
      onPrimaryContainer: light ? const Color(0xFF053B36) : const Color(0xFFCCFBF1),
      secondary: paw.accent,
      onSecondary: paw.onAccent,
      secondaryContainer: light ? const Color(0xFFFDE7D3) : const Color(0xFF4A2E14),
      onSecondaryContainer: light ? const Color(0xFF4A2508) : const Color(0xFFFDE7D3),
      tertiary: const Color(0xFF9B8AFB),
      onTertiary: const Color(0xFF1B1240),
      error: paw.error,
      onError: light ? Colors.white : const Color(0xFF3B0A0A),
      surface: paw.surface,
      onSurface: paw.textPrimary,
      onSurfaceVariant: paw.textSecondary,
      surfaceContainerLowest: paw.background,
      surfaceContainerLow: light ? const Color(0xFFF5F2EE) : const Color(0xFF131B1D),
      surfaceContainer: light ? const Color(0xFFF1EDE8) : const Color(0xFF1B2629),
      surfaceContainerHigh: light ? const Color(0xFFEBE6E0) : const Color(0xFF213033),
      surfaceContainerHighest: light ? const Color(0xFFE5E1DA) : const Color(0xFF2A3639),
      outline: paw.outline,
      outlineVariant: paw.outline,
      shadow: Colors.black,
      inverseSurface: light ? const Color(0xFF1C2B2D) : const Color(0xFFE8EEEE),
      onInverseSurface: light ? const Color(0xFFE8EEEE) : const Color(0xFF1C2B2D),
      inversePrimary: light ? const Color(0xFF2DD4BF) : const Color(0xFF0F766E),
    );

    final family = fontFor(locale);
    final height = (locale == 'hi' || locale == 'te') ? 1.6 : 1.4;
    TextStyle s(double size, FontWeight w, Color c) => TextStyle(
          fontFamily: family,
          fontFamilyFallback: fallbackFor(locale),
          fontSize: size,
          fontWeight: w,
          height: height,
          color: c,
        );
    final tp = paw.textPrimary;
    final ts = paw.textSecondary;
    final textTheme = TextTheme(
      displayLarge: s(40, FontWeight.w700, tp),
      displayMedium: s(36, FontWeight.w700, tp),
      displaySmall: s(32, FontWeight.w700, tp),
      headlineLarge: s(28, FontWeight.w700, tp),
      headlineMedium: s(24, FontWeight.w700, tp),
      headlineSmall: s(22, FontWeight.w700, tp),
      titleLarge: s(22, FontWeight.w700, tp),
      titleMedium: s(18, FontWeight.w600, tp),
      titleSmall: s(16, FontWeight.w600, tp),
      bodyLarge: s(16, FontWeight.w400, tp),
      bodyMedium: s(16, FontWeight.w400, tp),
      bodySmall: s(13, FontWeight.w400, ts),
      labelLarge: s(16, FontWeight.w600, tp),
      labelMedium: s(13, FontWeight.w600, tp),
      labelSmall: s(12, FontWeight.w500, ts),
    );

    final minButton = Size(64, easyMode ? 56 : 48);
    final buttonShape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.button));
    final cardShadow = light ? Colors.black.withValues(alpha: 0.06) : Colors.transparent;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: paw.background,
      canvasColor: paw.background,
      fontFamily: family,
      fontFamilyFallback: fallbackFor(locale),
      textTheme: textTheme,
      extensions: [paw],
      visualDensity: VisualDensity.standard,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: paw.background,
        foregroundColor: tp,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: paw.surface,
        elevation: light ? 2 : 0,
        shadowColor: cardShadow,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.card),
          side: light ? BorderSide.none : BorderSide(color: paw.outline),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: minButton,
          shape: buttonShape,
          textStyle: textTheme.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: minButton,
          shape: buttonShape,
          side: BorderSide(color: highContrast ? paw.textPrimary : paw.outline, width: 1.5),
          foregroundColor: primary,
          textStyle: textTheme.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: Size(48, easyMode ? 56 : 48),
          shape: buttonShape,
          textStyle: textTheme.labelLarge,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(minimumSize: Size.square(easyMode ? 56 : 48)),
      ),
      chipTheme: ChipThemeData(
        shape: const StadiumBorder(),
        side: BorderSide(color: paw.outline),
        backgroundColor: paw.surface,
        selectedColor: paw.primaryContainer,
        labelStyle: textTheme.labelMedium,
        // 48 px tall with the default label: an easy finger-sized target.
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: paw.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.button),
          borderSide: BorderSide(color: paw.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.button),
          borderSide: BorderSide(color: highContrast ? paw.textSecondary : paw.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.button),
          borderSide: BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.button),
          borderSide: BorderSide(color: paw.error),
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(color: ts),
        hintStyle: textTheme.bodyMedium?.copyWith(color: ts),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: paw.surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.sheet)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: paw.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.card)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: paw.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: paw.primaryContainer,
        height: easyMode ? 76 : 68,
        labelTextStyle: WidgetStatePropertyAll(textTheme.labelMedium),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: paw.surface,
        indicatorColor: paw.primaryContainer,
        selectedLabelTextStyle: textTheme.labelMedium?.copyWith(color: primary),
        unselectedLabelTextStyle: textTheme.labelMedium?.copyWith(color: ts),
      ),
      navigationDrawerTheme: NavigationDrawerThemeData(
        backgroundColor: paw.surface,
        indicatorColor: paw.primaryContainer,
        surfaceTintColor: Colors.transparent,
      ),
      dividerTheme: DividerThemeData(color: paw.outline, space: 1, thickness: 1),
      listTileTheme: ListTileThemeData(
        minVerticalPadding: 12,
        minTileHeight: easyMode ? 64 : 56,
        iconColor: ts,
        titleTextStyle: textTheme.bodyLarge,
        subtitleTextStyle: textTheme.bodySmall,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.button)),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected) ? onPrimary : paw.textSecondary),
        trackColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected) ? primary : paw.outline),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      }),
    );
  }
}
