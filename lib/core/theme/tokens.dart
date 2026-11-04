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
// - Amber and green are a little darker so white text reads on them and
//   they read as text on the sand background too.
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
    accent: Color(0xFFA84D08),
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
    success: Color(0xFF157A3A),
    successContainer: Color(0xFFDCFCE7),
    onSuccessContainer: Color(0xFF166534),
    warning: Color(0xFFA84D08),
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

/// Colours that tell kinds of things apart (routine log types, chart
/// series, document kinds). Muted mid-tones that sit with Design 2's forest
/// teal and sand. Use them for icons and tints, not for body text; pass them
/// through [readableOn] when they colour text or sit on a dark surface.
class CategoryColors {
  /// Text or icons drawn on top of a category colour.
  static const onCategory = Color(0xFFFFFFFF);

  static const teal = Color(0xFF2F7D6D);
  static const amber = Color(0xFFB7791F);
  static const clay = Color(0xFFB0643C);
  static const sky = Color(0xFF3B82A6);
  static const olive = Color(0xFF5F7F2A);
  static const plum = Color(0xFF7C5CBF);
  static const rose = Color(0xFFC2557A);
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
    [Color(0xFFE6F0ED), Color(0xFF18453E)],
    [Color(0xFFFDE7D3), Color(0xFFF4A261)],
    [Color(0xFFDDD6FE), Color(0xFF9B8AFB)],
    [Color(0xFFBAE6FD), Color(0xFF38BDF8)],
    [Color(0xFFFBCFE8), Color(0xFFF472B6)],
    [Color(0xFFBBF7D0), Color(0xFF34D399)],
    [Color(0xFFF5E6CC), Color(0xFFD6B98C)],
    [Color(0xFFF3EFEA), Color(0xFFB9532E)],
  ];
}

/// Fixed colours for printed or shared documents (health report, invoice,
/// prescription, sample documents, lost poster, QR tag). They stay the same
/// in dark mode, because paper is always white.
class PrintColors {
  static const paper = Color(0xFFFFFFFF);
  static const ink = Color(0xFF1C1917);
  static const muted = Color(0xFF57534E);
  static const brand = Color(0xFF18453E);
  static const brandTint = Color(0xFFE6F0ED);
  static const alert = Color(0xFFB91C1C);
  static const rule = Color(0xFFE7E2DA);

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

  /// Video call: page, the forest glow behind the other person, the
  /// picture-in-picture tile, the avatar and its icon, and the small lines.
  static const callBackground = Color(0xFF0E1715);
  static const callGlow = Color(0xFF18453E);
  static const callTile = Color(0xFF1A2422);
  static const callAvatar = Color(0xFF52B7A5);
  static const onCallAvatar = Color(0xFF0A2923);
  static const callSubtitle = Color(0xFFCDEAE3);
  static const callWarning = Color(0xFFFBBF24);
  static const callGood = Color(0xFF4ADE80);
  static const callDemo = Color(0x33FBBF24);
  static const onCallDemo = Color(0xFFFDE68A);
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

  /// Small labels and tags: the smallest text in the app.
  static const labelSmall = TypeToken(12, 16, FontWeight.w600);

  /// Uppercase micro labels ("AVAILABLE SLOT").
  static const overline = TypeToken(12, 16, FontWeight.w700, tracking: 0.6);

  /// Monospace for times, IDs and doses.
  static const mono = TypeToken(13, 18, FontWeight.w500);

  static const double indicLineHeight = 1.6;

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
  static const double productArtAspect = 1.15;
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

  /// Sign-in card width on wide screens.
  static const double authCard = 440;

  /// Previews in the design gallery.
  static const double galleryPreview = 300;
  static const double galleryPreviewSm = 260;

  /// Floating bottom bar on phones, and the top bar on wide screens.
  static const double dock = 64;
  static const double header = 72;

  /// Big tappable SOS option.
  static const double sosOption = 96;

  /// Small spinner beside a line of text.
  static const double spinner = 22;

  /// Small map inside a card.
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

  /// Picture on top of a place card in a list, and the narrowest card in a
  /// grid of them.
  static const double placeCardPhoto = 168;
  static const double placeCardMinWidth = 320;

  /// Photo header on a place page.
  static const double placeHeader = 200;

  /// Date square at the start of a booking row.
  static const double dateBadge = 52;

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
        BoxShadow(color: ink.withValues(alpha: 0.04), blurRadius: 3, offset: const Offset(0, 1)),
        BoxShadow(color: ink.withValues(alpha: 0.06), blurRadius: 24, spreadRadius: -4, offset: const Offset(0, 8)),
      ];

  /// Sheets, dialogs and menus.
  static List<BoxShadow> overlay(Color ink) => [
        BoxShadow(color: ink.withValues(alpha: 0.14), blurRadius: 48, spreadRadius: -8, offset: const Offset(0, 20)),
      ];
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
