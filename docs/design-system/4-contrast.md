# Contrast checks

Every pair below was calculated from the token values with the WCAG 2 formula (the same maths as `contrastRatio` in `lib/core/theme/tokens.dart` and `test/core/contrast_test.dart`). Targets: 4.5:1 for text, 3:1 for control borders and focus rings, 7:1 for text tokens in the high-contrast themes. All pass.

| Pair | Used for | Target | Light | Dark | Light HC | Dark HC |
|---|---|---|---|---|---|---|
| `text-primary` on `background` | Body text | 4.5:1 | 13.8 | 15.8 | 19.8 | 18.6 |
| `text-primary` on `surface` | Body text | 4.5:1 | 14.7 | 14.0 | 21.0 | 16.4 |
| `text-primary` on `surface-low` | Body text | 4.5:1 | 13.1 | 14.9 | 18.8 | 17.5 |
| `text-secondary` on `background` | Supporting text | 4.5:1 | 5.3 | 8.3 | 12.4 | 13.8 |
| `text-secondary` on `surface` | Supporting text | 4.5:1 | 5.6 | 7.3 | 13.1 | 12.2 |
| `text-secondary` on `surface-low` | Supporting text | 4.5:1 | 5.0 | 7.8 | 11.7 | 13.0 |
| `primary` on `background` | Links, text buttons | 4.5:1 | 5.2 | 10.0 | 5.2 | 10.0 |
| `primary` on `surface` | Links, text buttons | 4.5:1 | 5.5 | 8.8 | 5.5 | 8.8 |
| `on-primary` on `primary` | Primary button label | 4.5:1 | 5.5 | 9.2 | 5.5 | 9.2 |
| `on-primary-container` on `primary-container` | Selected chip, tonal button | 4.5:1 | 11.1 | 8.4 | 11.1 | 8.4 |
| `on-accent` on `accent` | Promo banner, streak badge | 4.5:1 | 7.4 | 9.1 | 7.4 | 9.1 |
| `on-accent-container` on `accent-container` | Warm tonal button, hero card | 4.5:1 | 11.3 | 10.4 | 11.3 | 10.4 |
| `accent-text` on `background` | Apricot words | 4.5:1 | 5.4 | 11.1 | 5.4 | 11.1 |
| `accent-text` on `surface` | Apricot words | 4.5:1 | 5.8 | 9.8 | 5.8 | 9.8 |
| `accent-text` on `accent-container` | Apricot words | 4.5:1 | 4.8 | 7.4 | 4.8 | 7.4 |
| `success` on `background` | Done, discount | 4.5:1 | 4.7 | 10.7 | 4.7 | 10.7 |
| `success` on `surface` | Done, discount | 4.5:1 | 5.0 | 9.4 | 5.0 | 9.4 |
| `success` on `success-container` | Done, discount | 4.5:1 | 4.6 | 8.6 | 4.6 | 8.6 |
| `warning` on `background` | Due soon | 4.5:1 | 4.7 | 11.1 | 4.7 | 11.1 |
| `warning` on `surface` | Due soon | 4.5:1 | 5.0 | 9.8 | 5.0 | 9.8 |
| `warning` on `warning-container` | Due soon | 4.5:1 | 4.5 | 9.0 | 4.5 | 9.0 |
| `error` on `background` | Overdue, field error | 4.5:1 | 6.1 | 6.7 | 6.1 | 6.7 |
| `error` on `surface` | Overdue, field error | 4.5:1 | 6.5 | 5.9 | 6.5 | 5.9 |
| `error` on `error-container` | Overdue, field error | 4.5:1 | 5.3 | 5.8 | 5.3 | 5.8 |
| `on-danger` on `danger` | Delete button | 4.5:1 | 6.5 | 4.8 | 6.5 | 4.8 |
| `on-sos` on `sos` | SOS label | 4.5:1 | 4.8 | 4.8 | 4.8 | 4.8 |
| `outline-strong` on `background` | Field and control borders | 3.0:1 | 3.4 | 5.2 | 8.0 | 11.1 |
| `outline-strong` on `surface` | Field and control borders | 3.0:1 | 3.6 | 4.6 | 8.4 | 9.8 |
| `focus-ring` on `background` | Focus ring | 3.0:1 | 5.2 | 12.6 | 5.2 | 12.6 |
| `focus-ring` on `surface` | Focus ring | 3.0:1 | 5.5 | 11.1 | 5.5 | 11.1 |
| `outline` on `surface` | Hairline (decorative, no minimum) | none | 1.3 | 1.3 | 5.6 | 7.3 |

## Pairs that never appear

These fail and are ruled out by the colour rules:

- White text on `accent` (apricot-400): 2.1:1. Use `on-accent`.
- `accent` or `apricot-500` as text on white: 2.1:1 and 2.8:1. Use `accent-text`.
- `apricot-600` as body text on white: 4.2:1. Large icons only.
- `outline` as the only border of a control: 1.3:1 in light and dark. Use `outline-strong`.
- `text-secondary` on `surface-container` or darker sand: 4.8:1 on `sand-200` passes, but it drops below 4.5:1 on `sand-300` and darker. Keep secondary text on `background`, `surface` or `surface-low`.

## Known gap

In the high-contrast themes, `primary` used as text (links, "See all") stays at the app's teal: 5.2:1 in light high contrast. That passes AA but not the 7:1 the other high-contrast text meets. `teal-800` (#115E59) would give 7.2:1; it is listed in **Changes from today's app**.
