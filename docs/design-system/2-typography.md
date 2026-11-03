# Typography in three scripts

## The pairing

| Script | Family | Why it fits |
|---|---|---|
| English (Latin) | **Plus Jakarta Sans** 400 / 500 / 600 / 700 | Geometric but soft: round bowls and open shapes feel friendly, while the even strokes keep medical facts looking precise. Large x-height (536 of 1000 units) keeps 14 px text readable on phones. Has tabular figures (`tnum`) for prices and timers. |
| Hindi (Devanagari) | **Noto Sans Devanagari** 400 / 500 / 600 / 700 | Drawn to sit with Latin sans faces; the same four weights let one design work in both. |
| Telugu | **Noto Sans Telugu** 400 / 500 / 600 / 700 | Same family logic; clear, open letterforms at small sizes. |

The pairing is **one family per script**, not a display face plus a body face. A second display font would need matching Hindi and Telugu versions; without them, English headings would look different from Hindi and Telugu ones. Hierarchy comes from size and weight instead. All fonts are bundled with the app (`assets/fonts/`), never loaded from the internet.

## What the font files say

Measured from the bundled files (units per 1000 em):

| | Plus Jakarta Sans | Noto Sans Devanagari | Noto Sans Telugu |
|---|---|---|---|
| Main letter height | x-height 536, capitals 745 | headline bar at 622 (क, म) | letters reach 725 (క, మ) |
| Marks above | – | up to 896 | vowel sign ి up to 773 |
| Marks below | descenders to −222 | down to −408 | stacked consonants to −483 |
| Natural line box | 1.26 em | 1.30 em | 1.35 em |

So:

- **Same font size in every language.** Devanagari's headline (622) and Telugu's letters (725) already look as big as English lowercase (536) or bigger. Making them larger would push layouts further.
- **Taller lines for Hindi and Telugu.** Vowel signs above and stacked consonants below need room, so Indic line heights are about 1.5 to 1.65 times the size (English: about 1.25 to 1.5).
- **No letter-spacing in Hindi or Telugu.** Spacing letters apart breaks the headline bar that joins Devanagari letters and separates Telugu vowel signs from their consonants. The negative tracking on large English sizes is English only.
- **Expect long words.** Telugu labels often run 2 to 4 times the English length. Buttons, chips and tabs wrap to a second line; they never shrink the text or cut it.

## The scale

Sizes in px. "Line" is the line height. Hindi and Telugu use the `hi-` and `te-` styles.

| Style | Size | Weight | Line (English) | Line (Hindi, Telugu) | Tracking (English) | Flutter slot | Use |
|---|---|---|---|---|---|---|---|
| `hero` | 40 | 700 | 48 | 56 | −0.5 | displayLarge | Celebrations, one big number |
| `display` | 32 | 700 | 40 | 48 | −0.4 | displaySmall | Onboarding headlines, desktop greeting |
| `headline` | 26 | 700 | 32 | 40 | −0.25 | headlineMedium | Screen titles on tablet and desktop, sheet titles |
| `title` | 22 | 700 | 28 | 34 | −0.2 | titleLarge | Screen titles on phones, pet name, product price |
| `heading` | 18 | 600 | 24 | 28 | 0 | titleMedium | Section headers, card titles |
| `body` | 16 | 400 | 24 | 26 | 0 | bodyLarge, bodyMedium | Reading text, list titles, field input |
| `body-strong` | 16 | 600 | 24 | 26 | 0 | titleSmall | Emphasis, prices in lists |
| `label` | 16 | 600 | 20 | 24 | 0 | labelLarge | Buttons |
| `support` | 14 | 400 | 20 | 22 | 0 | bodySmall | Second lines, helper text, descriptions |
| `label-sm` | 14 | 600 | 20 | 22 | 0 | labelMedium | Chips, nav labels, tabs, status chips |
| `caption` | 13 | 500 | 18 | 20 | +0.1 | labelSmall | Timestamps, credits, map attribution |
| `micro` | 12 | 700 | 16 | 18 | +0.2 | (badges) | Unread counts, "13% off" on photos |

The spec's five sizes (display 32, title 22, heading 18, body 16, caption 13) are all here. `hero`, `headline`, `support`, `label-sm` and `micro` name sizes the app already uses or needs; see **Changes from today's app** for the three that move.

## Rules

- Screen titles: `title` on phones, `headline` from `bp-tablet`. One per screen.
- Card titles: `heading`. Section headers ("Next up", "Vaccinations"): `heading` with a text button on the right.
- Anything a person must read to act (a due date, a dose, a price, a clinic address) is `body` or `support`, in `text-primary` or `text-secondary`, never `caption`.
- Text that carries meaning wraps (up to 3 lines in a list row, then "Show more"); only names that repeat elsewhere (a product title in a grid) may be cut after 2 lines.
- Money: `₹3,899` in `body-strong` or `title`; struck-through MRP in `support` `text-secondary`; discount in `label-sm` `success`. Use tabular figures in lists and carts.
- Dates and times: "13 Oct 2026", "8:05 PM", "Due in 10 days". In Hindi and Telugu the words come from the translation files; digits stay Western Arabic (0 to 9).
- Easy mode multiplies every size by 1.25; line heights scale with it. The text-size slider goes up to 200%, and layouts must hold.
