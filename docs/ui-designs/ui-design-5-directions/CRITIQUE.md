# UI Design 5 — the three directions, critiqued and scored (8 Nov 2026)

Method: design review only (detector not applicable, native platform). The app is Flutter (PRODUCT.md platform: android), so Impeccable's critique runs as a design review of the mock-ups; its web detector reads HTML/CSS and has no verdict on Flutter.

Mock-ups: `mock/mock.html` (source), screenshots in `shots/` (`<direction>-<screen>-<phone|desktop>-<light|dark>[-hi|-te][-easy].png`), compare page `index.html`. Every mock uses the app's real demo content (Priya, Bruno, Misty, Gulmohar Vet Studio, Golconda Gate Pet Clinic, real prices and dates).

## How the three were found

Impeccable's `new-work` flow: seven ideas from the everyday world of Indian pet parents, ordered by resonance, then its dice roll (`concept-seed`, seed:b45978419bb7395c) picked which one leads.

1. The vet's vaccination booklet and its rubber stamp → **B. Muhar** (my own top pick)
2. The marigold garland and an evening at home → **C. Genda**
3. Steel tiffin and chai
4. The family wall calendar with dates circled in pen → **A. Deewar** (the roll's assignment)
5. Monsoon on the balcony
6. The neighbourhood park walk
7. Indian Railways ticket and platform board

Six catalogue challengers were dealt and weighed on audience fit and product clarity; all six were declined (a scholarly reference page, an airline timetable, Japanese high-density web, a record-sleeve catalogue, a convention catalogue, a type specimen). What each still taught the chosen direction is listed under "Raises" below.

Already ruled out before mocking: the rejected "Neel" (indigo + turmeric, Anek, kolam motifs), "Warm Clinical Trust" (coral + forest teal), UI Design 4 (forest + coral, Plus Jakarta Sans/Inter), green or teal as the main colour, and anything red, coral or orange-red besides SOS.

## The three directions

| | A. Deewar — the wall calendar | B. Muhar — the health booklet | C. Genda — the marigold garland |
|---|---|---|---|
| Idea | Every dated thing (vaccine, booking, dose) leads with its date in big calendar numerals; today and the next due date are circled in ballpoint blue | Done tasks and given vaccines get a violet rubber stamp with the date; records read like the vet's booklet | Bruno's photo wears a garland: one marigold flower per task today, opening as it's done; warm on Home, quiet on Health |
| Main colour | Ballpoint blue `#2A3FBF` (dark `#9AABFF`) | Stamp violet `#6328A8` (dark `#CDB2FF`) | Cocoa `#4A2A12` buttons and `#3A2416` band, marigold `#F3A712` flowers (dark: marigold `#F5B53F` on `#14110D`) |
| Ground | Cool paper grey `#F3F4F8`, white cards | Pale violet-grey `#F6F4F8`, white cards | White, warm-grey groups `#F6F3EE` |
| Fonts | Hind + Hind Guntur (text), Barlow Condensed (numerals) | Noto Sans + Noto Sans Devanagari + Noto Sans Telugu; stamps in Noto Sans condensed | Baloo 2 + Baloo Tammudu 2 (titles), Hind + Hind Guntur (text) |
| Corners | 10 px | 4 px | 22 px cards, round buttons |
| Shadows | None, 1 px rules | None, ruled lines | Soft warm two-layer shadow |
| Icons | Material Symbols outlined | Material Symbols outlined, light | Material Symbols rounded |

## Hard checks (all three pass)

| Check | A | B | C |
|---|---|---|---|
| Text contrast 4.5:1 (every text pair, light and dark; `palettes.json` checked by script) | pass | pass | pass |
| Borders and state marks 3:1 | pass | pass | pass (marigold "done" marks darkened to `#B26F00` on white) |
| No text under 13 px (measured in every screenshot) | pass | pass | pass |
| Nothing overflows, no sideways scroll at 390 and 1440 px | pass | pass | pass |
| Hindi and Telugu fit (Home and Book) | pass after fix | pass after fix | pass |
| Easy mode (bigger text, 56 px buttons, 2×2 actions) | pass | pass | pass |
| SOS the only red | pass | pass | pass |

Fix found and applied during the check: letter-spaced and upper-case labels pulled Telugu and Hindi letters apart in A and B. Rule for the design system: never letter-space or upper-case Indic text.

## Design review (Nielsen heuristics, 0–4)

| # | Heuristic | A | B | C | Note |
|---|---|---|---|---|---|
| 1 | Visibility of system status | 3 | 3 | 4 | C shows today's progress three ways (flowers, bar, "2 of 4 done") |
| 2 | Match with the real world | 4 | 3 | 3 | The wall calendar is the most familiar object; the booklet is familiar to clinic-goers |
| 3 | User control and freedom | 3 | 3 | 3 | "Mark as given" needs an undo snackbar in all three |
| 4 | Consistency and standards | 3 | 3 | 3 | Standard Material navigation and controls in all three |
| 5 | Error prevention | 2 | 2 | 2 | No confirm/undo shown yet |
| 6 | Recognition over recall | 3 | 3 | 4 | C leads with the pet's face: whose day it is is never in doubt |
| 7 | Flexibility and efficiency | 2 | 2 | 2 | Quick actions only |
| 8 | Aesthetic and minimalist design | 3 | 2 | 3 | B's stamps repeat on every row and get noisy in lists |
| 9 | Error recovery | 2 | 2 | 2 | Not mocked; comes from DESIGN.md states |
| 10 | Help and documentation | 2 | 2 | 2 | First aid and Ask PawSetu sit one tap away |
| | **Total** | **27/40** | **25/40** | **28/40** | |

**Design specificity.** All three are authored for PawSetu rather than category-interchangeable: none could be swapped onto another pet app unchanged. A owns dates; B owns records; C owns the pet's day. A risks reading as a scheduling tool (cool, efficient, little warmth). B risks reading as a government office (square, purple, stamped). C risks sweetness on serious screens, which DESIGN.md has to prevent with a calm register.

### What works
- A: the week strip and date-led rows make "what's due when" instant; Barlow numerals are very legible at a glance.
- B: stamps make "given" unmistakable and look official on the medical card and records; Noto gives the most even Hindi and Telugu.
- C: the garland turns the daily checklist into a small daily ritual (Headspace-like warmth) and puts Bruno's face first; Easy mode feels like Google Pay India.

### Priority issues
- **[P1] B: stamps everywhere.** On a list of 4 tasks plus 3 vaccines, 7 rotated stamps compete; the 13 px condensed rotated text is the hardest text on any screen. Fix: stamps only on records, never on daily tasks.
- **[P1] C: warmth leaking into health.** Marigold "done" ticks on the vaccination list feel playful. Fix: a calm register for Health, records, tele-vet and SOS: no marigold fills, no garland, green "given" ticks, Hind titles at the same size.
- **[P1] C as first drawn: a marigold header band read like Supertails' orange** (Supertails' theme colour is `#EF6C00`, its buttons `#FF9A16`, checked on its live site on 8 Nov). Fixed before scoring: the band is now cocoa and marigold lives only in the garland, progress and highlights.
- **[P2] A: low warmth.** Blue, rules and numerals feel like an office calendar; the hand-drawn circle is the only human mark.
- **[P2] All: "Mark as given" needs an undo** (snackbar), and every list needs its empty and error state (DESIGN.md).

### Persona red flags
- **Priya (busy parent, phone in one hand on a walk):** A pushes today's tasks below the calendar strip (one extra scroll); C and B put tasks first.
- **Anjali (Hindi, Easy mode, less confident):** B's small rotated stamp text is hard; A's condensed numerals are fine; C's round buttons and big photo are the easiest.
- **Kavya (clinic admin, laptop):** all three portal tables read cleanly; B's ruled table is the most "office"; C needs a compact density for tables so rounded cards don't waste space.

Questions skipped: the owner delegated the choice before the overnight run (scoring rules in the brief, section 5).

## Owner's scoring (in the owner's order)

| Rule | A. Deewar | B. Muhar | C. Genda |
|---|---|---|---|
| 1. Readability checks (all pass; quality 0–10) | 9 | 7.5 | 9 |
| 2. Fit: Home is the pet's day first; calm on health, records, SOS; warm elsewhere (0–10) | 7 | 6 | 9 |
| 3. Not like UI Design 4, not like Supertails (0–10) | 9 | 9 | 8 |
| Weighted (×3, ×2, ×1) | 50 | 43.5 | **53** |

**Pick: C. Genda.** It ties A on readability, clearly wins on fit (the pet's face and day come first; it's the warmest), and after the cocoa fix it doesn't look like Supertails or UI Design 4. The owner's tie-break (choose the warmer one) points the same way. The roll had assigned A; the owner's own decision rule beats the roll, as Impeccable's rules require.

## Raises (what Genda takes from the others; discipline, not decoration)
- **From A (Deewar):** every scheduled thing leads with a date block (weekday + big numeral) in one fixed position; clinic list numbers match the map pins.
- **From B (Muhar):** records are a strict ruled list with "Given on" dates; a calm register for health and records (green ticks, no marigold).
- **From the airline timetable:** a small type scale; rank by weight and size steps from one table, never ad-hoc sizes.
- **From the record-sleeve catalogue:** nothing labelled twice (no "Due soon" on every row; one "Medical card"; the discount shown once).
- **From the scholarly page:** one hairline weight and one colour for every divider.
- **From Japanese high-density web:** a compact density for partner and admin tables.
