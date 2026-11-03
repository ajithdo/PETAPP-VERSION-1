import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';

import 'tokens.dart';

/// Builds the Material 3 theme from the design tokens (Design 2,
/// lib/core/theme/tokens.dart). No colour or size is typed here directly.
class AppTheme {
  static bool _indic(String locale) => locale == 'hi' || locale == 'te';

  /// Body font for a language.
  static String fontFor(String locale) => switch (locale) {
        'hi' => FontFamilies.devanagari,
        'te' => FontFamilies.telugu,
        _ => FontFamilies.body,
      };

  static List<String> fallbackFor(String locale) => switch (locale) {
        'hi' => const [FontFamilies.body, FontFamilies.heading, FontFamilies.telugu],
        'te' => const [FontFamilies.body, FontFamilies.heading, FontFamilies.devanagari],
        _ => const [FontFamilies.heading, FontFamilies.devanagari, FontFamilies.telugu],
      };

  /// A text style for [t] in [locale]: headings in Plus Jakarta Sans and body
  /// in Inter for English; Noto Sans with taller lines for Hindi and Telugu.
  static TextStyle styleFor(TypeToken t, String locale, Color color, {String? family}) {
    final indic = _indic(locale);
    final f = family ?? (indic ? fontFor(locale) : (t.heading ? FontFamilies.heading : FontFamilies.body));
    final lh = t.lineHeight / t.size;
    return TextStyle(
      fontFamily: f,
      fontFamilyFallback: [if (family != null) fontFor(locale), ...fallbackFor(locale)],
      fontSize: t.size,
      fontWeight: t.weight,
      height: indic && lh < TypeScale.indicLineHeight ? TypeScale.indicLineHeight : lh,
      letterSpacing: indic && t.tracking < 0 ? 0 : t.tracking,
      color: color,
    );
  }

  static ThemeData build({
    required Brightness brightness,
    required String locale,
    bool highContrast = false,
    bool easyMode = false,
  }) {
    final light = brightness == Brightness.light;
    var paw = light ? PawColors.light : PawColors.dark;
    if (highContrast) paw = paw.highContrast(brightness);

    final scheme = ColorScheme(
      brightness: brightness,
      primary: paw.brand,
      onPrimary: paw.onBrand,
      primaryContainer: paw.primaryContainer,
      onPrimaryContainer: paw.onPrimaryContainer,
      secondary: paw.action,
      onSecondary: paw.onAction,
      secondaryContainer: paw.actionContainer,
      onSecondaryContainer: paw.onActionContainer,
      tertiary: paw.accent,
      onTertiary: paw.onAccent,
      error: paw.error,
      onError: light ? paw.surface : paw.errorContainer,
      errorContainer: paw.errorContainer,
      onErrorContainer: paw.onErrorContainer,
      surface: paw.surface,
      onSurface: paw.textPrimary,
      onSurfaceVariant: paw.textSecondary,
      surfaceContainerLowest: paw.surface,
      surfaceContainerLow: paw.background,
      surfaceContainer: paw.surfaceSubtle,
      surfaceContainerHigh: paw.surfaceSubtle,
      surfaceContainerHighest: paw.surfaceSubtle,
      outline: paw.controlBorder,
      outlineVariant: paw.outline,
      shadow: paw.ink,
      scrim: paw.ink,
      inverseSurface: paw.inverseSurface,
      onInverseSurface: paw.onInverseSurface,
      inversePrimary: light ? PawColors.dark.brand : PawColors.light.brand,
    );

    final tp = paw.textPrimary;
    final ts = paw.textSecondary;
    TextStyle s(TypeToken t, [Color? c]) => styleFor(t, locale, c ?? tp);
    final textTheme = TextTheme(
      displayLarge: s(TypeScale.display),
      displayMedium: s(TypeScale.headlineLarge),
      displaySmall: s(TypeScale.displayPhone),
      headlineLarge: s(TypeScale.headlineLarge),
      headlineMedium: s(TypeScale.headline),
      headlineSmall: s(TypeScale.headlineMedium),
      titleLarge: s(TypeScale.title),
      titleMedium: s(TypeScale.titleMedium),
      titleSmall: s(TypeScale.titleSmall),
      bodyLarge: s(TypeScale.bodyLarge),
      bodyMedium: s(TypeScale.body),
      bodySmall: s(TypeScale.bodySmall, ts),
      labelLarge: s(TypeScale.label),
      labelMedium: s(TypeScale.labelMedium),
      labelSmall: s(TypeScale.overline, ts),
    );
    final extraText = PawTextStyles(
      mono: styleFor(TypeScale.mono, locale, tp, family: FontFamilies.mono),
      overline: s(TypeScale.overline, ts),
    );

    final target = easyMode ? TapTarget.easy : TapTarget.min;
    const pill = StadiumBorder();
    const buttonPadding = EdgeInsets.symmetric(horizontal: Space.xl - 4, vertical: Space.md);
    final focusRing = BorderSide(color: paw.focus, width: 2);
    final controlSide = BorderSide(color: paw.controlBorder);
    RoundedRectangleBorder rounded(double r, [BorderSide side = BorderSide.none]) =>
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(r), side: side);
    OutlineInputBorder field(Color c, [double w = 1]) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.input),
          borderSide: BorderSide(color: c, width: w),
        );
    WidgetStateProperty<T> byState<T>(T normal, {T? selected, T? disabled}) =>
        WidgetStateProperty.resolveWith((st) {
          if (disabled != null && st.contains(WidgetState.disabled)) return disabled;
          if (selected != null && st.contains(WidgetState.selected)) return selected;
          return normal;
        });
    final disabledFill = paw.surfaceSubtle;
    final disabledText = ts;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: paw.background,
      canvasColor: paw.background,
      fontFamily: fontFor(locale),
      fontFamilyFallback: fallbackFor(locale),
      textTheme: textTheme,
      extensions: [paw, extraText],
      visualDensity: VisualDensity.standard,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      splashFactory: InkSparkle.splashFactory,
      focusColor: paw.focus.withValues(alpha: 0.16),
      hoverColor: paw.textPrimary.withValues(alpha: 0.04),
      highlightColor: paw.textPrimary.withValues(alpha: 0.06),
      dividerColor: paw.outline,
      iconTheme: IconThemeData(color: tp, size: IconSizes.lg),
      appBarTheme: AppBarTheme(
        backgroundColor: paw.background,
        foregroundColor: tp,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
        shape: Border(bottom: BorderSide(color: paw.outline)),
      ),
      cardTheme: CardThemeData(
        color: paw.surface,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: rounded(Radii.card, BorderSide(color: paw.outline)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          minimumSize: WidgetStatePropertyAll(Size(64, target)),
          padding: const WidgetStatePropertyAll(buttonPadding),
          shape: const WidgetStatePropertyAll(pill),
          textStyle: WidgetStatePropertyAll(textTheme.labelLarge),
          elevation: const WidgetStatePropertyAll(0),
          backgroundColor: WidgetStateProperty.resolveWith((st) {
            if (st.contains(WidgetState.disabled)) return disabledFill;
            if (st.contains(WidgetState.pressed)) return paw.actionPressed;
            return paw.action;
          }),
          foregroundColor: byState(paw.onAction, disabled: disabledText),
          iconColor: byState(paw.onAction, disabled: disabledText),
          overlayColor: WidgetStatePropertyAll(paw.onAction.withValues(alpha: 0.08)),
          side: WidgetStateProperty.resolveWith(
              (st) => st.contains(WidgetState.focused) ? BorderSide(color: tp, width: 2) : null),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          minimumSize: WidgetStatePropertyAll(Size(64, target)),
          padding: const WidgetStatePropertyAll(buttonPadding),
          shape: const WidgetStatePropertyAll(pill),
          textStyle: WidgetStatePropertyAll(textTheme.labelLarge),
          backgroundColor: WidgetStatePropertyAll(paw.surface),
          foregroundColor: byState(tp, disabled: disabledText),
          iconColor: byState(paw.brand, disabled: disabledText),
          overlayColor: WidgetStatePropertyAll(paw.brand.withValues(alpha: 0.06)),
          side: WidgetStateProperty.resolveWith((st) {
            if (st.contains(WidgetState.focused)) return focusRing;
            if (st.contains(WidgetState.disabled)) return BorderSide(color: paw.outline);
            return controlSide;
          }),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          minimumSize: WidgetStatePropertyAll(Size(TapTarget.min, target)),
          padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: Space.md)),
          shape: const WidgetStatePropertyAll(pill),
          textStyle: WidgetStatePropertyAll(textTheme.labelLarge),
          foregroundColor: byState(paw.brand, disabled: disabledText),
          iconColor: byState(paw.brand, disabled: disabledText),
          overlayColor: WidgetStatePropertyAll(paw.brand.withValues(alpha: 0.08)),
          side: WidgetStateProperty.resolveWith((st) => st.contains(WidgetState.focused) ? focusRing : null),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(64, target),
          padding: buttonPadding,
          shape: pill,
          elevation: 0,
          backgroundColor: paw.surface,
          foregroundColor: paw.brand,
          textStyle: textTheme.labelLarge,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          minimumSize: WidgetStatePropertyAll(Size.square(target)),
          foregroundColor: byState(tp, selected: paw.brand, disabled: disabledText),
          side: WidgetStateProperty.resolveWith((st) => st.contains(WidgetState.focused) ? focusRing : null),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: paw.action,
        foregroundColor: paw.onAction,
        elevation: 2,
        focusElevation: 2,
        hoverElevation: 3,
        highlightElevation: 1,
        shape: pill,
        extendedTextStyle: textTheme.labelLarge,
      ),
      chipTheme: ChipThemeData(
        shape: StadiumBorder(side: BorderSide(color: paw.outline)),
        side: WidgetStateBorderSide.resolveWith((st) {
          if (st.contains(WidgetState.focused)) return focusRing;
          if (st.contains(WidgetState.selected)) return BorderSide(color: paw.brand);
          return BorderSide(color: paw.outline);
        }),
        color: byState(paw.surface, selected: paw.brand, disabled: disabledFill),
        labelStyle: textTheme.labelMedium?.copyWith(color: WidgetStateColor.resolveWith(
            (st) => st.contains(WidgetState.selected) ? paw.onBrand : (st.contains(WidgetState.disabled) ? ts : tp))),
        secondaryLabelStyle: textTheme.labelMedium?.copyWith(color: paw.onBrand),
        checkmarkColor: paw.onBrand,
        iconTheme: IconThemeData(color: paw.brand, size: IconSizes.md - 2),
        deleteIconColor: ts,
        // 48 px tall with the default label: an easy finger-sized target.
        padding: const EdgeInsets.symmetric(horizontal: Space.sm + 2, vertical: Space.sm),
        showCheckmark: true,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: paw.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.lg),
        border: field(paw.controlBorder),
        enabledBorder: field(paw.controlBorder),
        focusedBorder: field(paw.focus, 2),
        errorBorder: field(paw.error),
        focusedErrorBorder: field(paw.error, 2),
        disabledBorder: field(paw.outline),
        labelStyle: textTheme.bodyMedium?.copyWith(color: ts),
        floatingLabelStyle: textTheme.labelMedium?.copyWith(color: tp),
        hintStyle: textTheme.bodyMedium?.copyWith(color: ts),
        helperStyle: textTheme.bodySmall,
        errorStyle: textTheme.bodySmall?.copyWith(color: paw.error),
        prefixIconColor: ts,
        suffixIconColor: ts,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: paw.brand,
        selectionColor: paw.brand.withValues(alpha: 0.24),
        selectionHandleColor: paw.brand,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: paw.surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: paw.controlBorder,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.sheet)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: paw.surface,
        surfaceTintColor: Colors.transparent,
        shape: rounded(Radii.card),
        titleTextStyle: textTheme.titleLarge,
        contentTextStyle: textTheme.bodyMedium,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: paw.surface,
        surfaceTintColor: Colors.transparent,
        shape: rounded(Radii.md, BorderSide(color: paw.outline)),
        textStyle: textTheme.bodyMedium,
      ),
      menuTheme: MenuThemeData(
        style: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(paw.surface),
          surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
          shape: WidgetStatePropertyAll(rounded(Radii.md, BorderSide(color: paw.outline))),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: paw.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        indicatorColor: paw.primaryContainer,
        indicatorShape: pill,
        height: easyMode ? 76 : 68,
        iconTheme: WidgetStateProperty.resolveWith((st) => IconThemeData(
              color: st.contains(WidgetState.selected) ? paw.brand : ts,
              size: easyMode ? IconSizes.xl - 2 : IconSizes.lg,
            )),
        labelTextStyle: WidgetStateProperty.resolveWith((st) => st.contains(WidgetState.selected)
            ? textTheme.labelMedium!.copyWith(color: paw.brand, fontWeight: FontWeight.w700)
            : textTheme.labelMedium!.copyWith(color: ts, fontWeight: FontWeight.w500)),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: paw.surface,
        indicatorColor: paw.primaryContainer,
        indicatorShape: pill,
        selectedIconTheme: IconThemeData(color: paw.brand),
        unselectedIconTheme: IconThemeData(color: ts),
        selectedLabelTextStyle: textTheme.labelLarge?.copyWith(color: paw.brand, fontWeight: FontWeight.w700),
        unselectedLabelTextStyle: textTheme.labelLarge?.copyWith(color: ts, fontWeight: FontWeight.w500),
      ),
      navigationDrawerTheme: NavigationDrawerThemeData(
        backgroundColor: paw.surface,
        indicatorColor: paw.primaryContainer,
        surfaceTintColor: Colors.transparent,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: paw.brand,
        unselectedLabelColor: ts,
        indicatorColor: paw.brand,
        dividerColor: paw.outline,
        labelStyle: textTheme.labelLarge,
        unselectedLabelStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          minimumSize: WidgetStatePropertyAll(Size(TapTarget.min, target)),
          shape: const WidgetStatePropertyAll(pill),
          side: WidgetStatePropertyAll(controlSide),
          backgroundColor: byState(paw.surface, selected: paw.brand),
          foregroundColor: byState(tp, selected: paw.onBrand),
          iconColor: byState(tp, selected: paw.onBrand),
          textStyle: WidgetStatePropertyAll(textTheme.labelMedium),
        ),
      ),
      dividerTheme: DividerThemeData(color: paw.outline, space: 1, thickness: 1),
      listTileTheme: ListTileThemeData(
        minVerticalPadding: Space.md,
        minTileHeight: easyMode ? 64 : 56,
        iconColor: ts,
        titleTextStyle: textTheme.bodyLarge,
        subtitleTextStyle: textTheme.bodySmall,
        shape: rounded(Radii.md),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: paw.inverseSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: paw.onInverseSurface),
        actionTextColor: light ? PawColors.dark.brand : PawColors.light.brand,
        shape: rounded(Radii.md),
        elevation: 0,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(color: paw.inverseSurface, borderRadius: BorderRadius.circular(Radii.sm)),
        textStyle: textTheme.bodySmall?.copyWith(color: paw.onInverseSurface),
      ),
      badgeTheme: BadgeThemeData(backgroundColor: paw.sos, textColor: paw.onSos),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: paw.brand,
        linearTrackColor: paw.surfaceSubtle,
        circularTrackColor: Colors.transparent,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: byState(paw.controlBorder, selected: paw.onBrand),
        trackColor: byState(paw.surfaceSubtle, selected: paw.brand),
        trackOutlineColor: byState(paw.controlBorder, selected: paw.brand),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: byState(Colors.transparent, selected: paw.brand),
        checkColor: WidgetStatePropertyAll(paw.onBrand),
        side: BorderSide(color: paw.controlBorder, width: 1.5),
        shape: rounded(Radii.sm - 2),
      ),
      radioTheme: RadioThemeData(fillColor: byState(paw.controlBorder, selected: paw.brand)),
      sliderTheme: SliderThemeData(
        activeTrackColor: paw.brand,
        inactiveTrackColor: paw.surfaceSubtle,
        thumbColor: paw.brand,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      }),
    );
  }
}
