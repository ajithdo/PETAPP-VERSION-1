# Batch A — shell: Impeccable audit (8 Nov 2026)

Method: code-level audit of a native (Flutter) app against the Android / Material 3 reference; no browser detector applies.
Scope: `lib/features/shell/presentation/owner_shell.dart`, `lib/core/widgets/{sos_button,buttons,pills}.dart`, `lib/core/theme/app_theme.dart` (navigation themes).

Screenshots: this folder (UI Design 5) next to `../ui-design-4-baseline/` (UI Design 4, same file names: `phone360-home.jpg`, `desktop1280-home.jpg`, `phone360-dark-home.jpg`, `phone360-te-home.jpg`, `phone360-easy-home.jpg`…). The page content under the shell is still UI Design 4 until Batch B.

| # | Dimension | Score | Key finding |
|---|---|---|---|
| 1 | Accessibility | 3 → 4 | Unread counts on the message and bell buttons were not spoken; fixed ("Messages, 2 unread") |
| 2 | Performance | 3 | No change in this batch; shell rebuilds only on navigation |
| 3 | Appearance and theming | 4 | Every colour from tokens; dark and high contrast first-class; badges no longer SOS red |
| 4 | Platform conformance | 4 | Material navigation bar, rail and extended rail replace UI Design 4's custom floating dock and pill tabs |
| 5 | Adaptivity | 4 | Phone bar under 640 px, rail 640–1023 px, 256 px side navigation from 1024 px; labels one line |
| **Total** | | **19/20** | **Excellent** |

**Platform conformance verdict: pass.** A fluent Android user recognises the bar, rail and side navigation; system Back is untouched.

## Findings
- **[P2, fixed] Badge counts not announced** — `PawIconButton` (buttons.dart): the tooltip now includes the count (new string `withUnread`, en/hi/te).
- **[P2, decided] Mixed icon styles** — feature screens use outlined icons, the shell rounded-filled when selected. DESIGN.md now states the rule the code follows: outlined when idle, filled when selected; no other icon family.
- **[P3, owner's decision] Navigation hidden outside the tabs** — screens opened from elsewhere (pet profile, messages, SOS…) have no bottom bar or side navigation. Changing it changes how navigation and Back work; listed in the morning report.

## Positive findings
- One red: the SOS pill is now solid red with white text; count badges are cocoa, danger buttons berry.
- 48 px touch targets on every control (56 px in Easy mode; the bar grows to 84 px).
- Layout sweep at 200% text in English, Hindi and Telugu passes on phone, tablet and desktop.
