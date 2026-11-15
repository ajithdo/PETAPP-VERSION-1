# Batch B — Home, Health, Book, Shop, Me: Impeccable audit (8 Nov 2026)

Method: code-level audit of a native (Flutter) app against the Android / Material 3 reference and DESIGN.md; no browser detector applies.
Screenshots: this folder (UI Design 5) next to `../ui-design-4-baseline/` (UI Design 4, same names: `phone360-home.jpg`, `desktop1280-shop.jpg`, `phone360-dark-health.jpg`, `phone360-te-book.jpg`, `phone360-easy-me.jpg`…). `phone360-tall-*.jpg` show the whole tab on a phone.

| # | Dimension | Score | Key finding |
|---|---|---|---|
| 1 | Accessibility | 4 | The Genda band is one screen-reader item ("Bruno's day. 2 of 5 done"); 200% text sweep passes in en/hi/te |
| 2 | Performance | 3 | No new lists; the band repaints only when today's logs change |
| 3 | Appearance and theming | 4 | Tokens only; promo cards, category tiles and product art no longer use loud fills or gradients |
| 4 | Platform conformance | 4 | Standard list tiles, tonal icon buttons, outlined secondary buttons; one filled action per screen |
| 5 | Adaptivity | 4 | Home and Health use two columns on desktop; Shop rows scroll sideways; Easy mode shows the short Home |
| **Total** | | **19/20** | **Excellent** |

## UI Design 4 problems from the owner's list — status
1. **Coral buttons and red "24×7" badge look like SOS** — fixed: buttons cocoa, "24x7" a calm label (white on photos, green chip in lists); SOS is the only red.
2. **Home on phones: clinic cards before the pet's day, greeting halfway down** — fixed: greeting → Genda band → today → next up → quick actions → near you.
3. **Repetition** — fixed: "Due soon" only where it matters (rows lead with a date; a chip only when overdue), "Medical card" once on Health, the discount once per product.
4. **Uneven stacked buttons on the Health pass; Tele-vet chip alone on a line** — fixed: pass buttons share the width or stack at full width; the chip row is gone (Tele-vet is a quick action).
5. **Shop: placeholder pictures and a loud promo banner** — fixed: a calm category drawing on warm grey when there is no photo; offers are quiet cards below the pet's picks.
6. **"Powered by Netlify" badge** — a Netlify setting, not our code: steps in the owner's to-do list.
7. **Small text, low contrast, broken SOS title, wrapping desktop menu** — 13 px minimum, contrast tested, SOS pill one line, desktop side navigation on one line.

## Findings fixed in this batch
- **[P1] Eyebrow labels above headings** (alert cards, health pass, Home health card): the short line now follows the title (Impeccable craft floor bans labels above headings).
- **[P1] Emergency info tinted SOS red** — now a plain card (calm register).
- **[P2] Microchip ID broke across two lines** — IDs shrink to fit, never wrap.
- **[P2] Clinic and booking names cut with "…"** — booking names get two lines.
- **[P2] Second set of pet chips in Shop** — removed; the top-bar pet pills choose the pet.
- **[P2] Monospace used as decoration** (distance, slot times, booking times) — normal type now; mono stays for IDs and doses.

## Left for later batches
- Clinic page, booking flow and booking confirmed (Batch C) still carry some UI Design 4 detail.
- Product page and cart (Batch C/D sweep).

## Positive findings
- Home now opens on the pet: Bruno's photo in his garland with today's progress, then the checklist.
- One quiet style for all six kinds of care on Book.
- Me is three short groups instead of 14 links in one list.
