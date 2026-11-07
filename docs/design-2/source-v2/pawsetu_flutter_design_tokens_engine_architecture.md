# PawSetu Flutter & Web Engineering Architecture Guide

This document establishes the official front-end performance, hydration lifecycle, and Dart design tokens generated directly from `DESIGN.md` for the live Flutter web and mobile codebase.

---

## 1. PawSetu Dart Design Tokens (`pawsetu_tokens.dart`)

Copy and paste this token class directly into your Flutter project at `lib/theme/pawsetu_tokens.dart`:

```dart
import 'package:flutter/material.dart';

/// PawSetu Design System Tokens: "Warm Clinical Trust & Playful Care"
abstract final class PawSetuTokens {
  // Brand & Semantic Accents
  static const Color coral = Color(0xFFE05A47);
  static const Color forestTeal = Color(0xFF18453E);
  static const Color softSage = Color(0xFFE6F0ED);
  static const Color softSand = Color(0xFFF3EFEA);
  static const Color warmBorder = Color(0xFFE7E2DA);

  // Status & Urgency Tokens
  static const Color statusUpcoming = Color(0xFFD97706);
  static const Color statusCompleted = Color(0xFF15803D);
  static const Color statusEmergency = Color(0xFFDC2626);

  // Light Theme Surfaces & Text (WCAG AA Compliant)
  static const Color lightSurface = Color(0xFFFAF8F5);
  static const Color lightSurfaceElevated = Color(0xFFFFFFFF);
  static const Color lightSurfaceSubtle = Color(0xFFF3EFEA);
  static const Color lightOnSurface = Color(0xFF1C1917);
  static const Color lightOnSurfaceSubtle = Color(0xFF78716C);
  static const Color lightPrimary = Color(0xFFC84735);
  static const Color lightOnPrimary = Color(0xFFFFFFFF);

  // Dark Theme Surfaces & Text
  static const Color darkSurface = Color(0xFF141517);
  static const Color darkSurfaceElevated = Color(0xFF1C1D21);
  static const Color darkSurfaceSubtle = Color(0xFF24262B);
  static const Color darkOnSurface = Color(0xFFF5F5F4);
  static const Color darkPrimary = Color(0xFFFF7A66);

  // Radii
  static const BorderRadius radiusSm = BorderRadius.all(Radius.circular(6.0));
  static const BorderRadius radiusMd = BorderRadius.all(Radius.circular(12.0));
  static const BorderRadius radiusLg = BorderRadius.all(Radius.circular(16.0));
  static const BorderRadius radiusXl = BorderRadius.all(Radius.circular(20.0));
  static const BorderRadius radiusFull = BorderRadius.all(Radius.circular(9999.0));

  // Multi-Stop Ambient Card Elevation
  static const List<BoxShadow> cardElevation = [
    BoxShadow(
      color: Color.fromRGBO(28, 25, 23, 0.04),
      blurRadius: 3.0,
      offset: Offset(0, 1),
    ),
    BoxShadow(
      color: Color.fromRGBO(28, 25, 23, 0.06),
      blurRadius: 20.0,
      offset: Offset(0, 8),
      spreadRadius: -4.0,
    ),
  ];

  // Micro-interaction Durations
  static const Duration tapDuration = Duration(milliseconds: 100);
  static const Duration filterToggleDuration = Duration(milliseconds: 150);
  static const Duration drawerEnterDuration = Duration(milliseconds: 250);
}
```

---

## 2. Web Hydration & Zero-Jank Initialization (`web/index.html`)

To eliminate the raw white screen and "PawSetu is loading" text delay during Flutter web hydration, replace the root loader in `web/index.html` with our branded CSS skeleton:

```html
<!-- In web/index.html before flutter_bootstrap.js -->
<style>
  #splash {
    position: fixed; inset: 0; display: flex; flex-direction: column;
    align-items: center; justify-content: center; gap: 16px;
    background: #FAF8F5; color: #1C1917; font-family: system-ui, sans-serif;
    transition: opacity .35s ease-out; z-index: 9999;
  }
  .mark {
    width: 72px; height: 72px; border-radius: 20px; background: #18453E;
    color: white; display: flex; align-items: center; justify-content: center;
    box-shadow: 0 8px 24px -4px rgba(24, 69, 62, 0.25);
  }
  .bar { width: 140px; height: 4px; border-radius: 9999px; background: #E7E2DA; overflow: hidden; position: relative; }
  .bar::after {
    content: ""; position: absolute; left: 0; top: 0; width: 45%; height: 100%;
    background: #C84735; animation: swipe 1.2s infinite ease-in-out; border-radius: 9999px;
  }
  @keyframes swipe { 0% { transform: translateX(-100%); } 100% { transform: translateX(350%); } }
</style>
<div id="splash" role="status" aria-label="PawSetu is loading">
  <div class="mark"><svg width="36" height="36" viewBox="0 0 24 24" fill="currentColor"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2z"/></svg></div>
  <strong style="font-size: 24px; font-weight: 800; letter-spacing: -0.02em;">PawSetu</strong>
  <div class="bar"></div>
</div>
<script>
  window.addEventListener('flutter-first-frame', function () {
    var s = document.getElementById('splash');
    if (s) { s.style.opacity = '0'; setTimeout(function () { s.remove(); }, 350); }
  });
</script>
```

---

## 3. Web-to-Mobile Responsive Container Contract

To guarantee zero horizontal overflow and eliminate edge-to-edge stretching on ultra-wide desktop displays:

1. **Primary Screen Shells:** Constrain top-level layout with `ConstrainedBox(constraints: BoxConstraints(maxWidth: 1240))` and center with `Center()`.
2. **Mobile Nav Dock:** On viewports under `768px`, render the floating bottom navigation bar with `minHeight: 48` touch targets.
3. **Desktop Nav Rail:** On viewports `768px` and wider, render the persistent navigation bar or sidebar rail.
4. **Image CLS Prevention:** Always set an explicit `aspectRatio: 16 / 9` on clinic feed cards before network image resolution.
