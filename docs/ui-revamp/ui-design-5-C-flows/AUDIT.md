# Batch C — sign-in and pet-parent flows: Impeccable audit (8 Nov 2026)

Method: code-level audit of a native (Flutter) app against the Android / Material 3 reference and DESIGN.md; no browser detector applies.
Screenshots: this folder (UI Design 5) next to `../ui-design-4-baseline/` (UI Design 4, same names where both exist: `phone360-signin.jpg`, `phone360-clinic-page.jpg`, `phone360-sos.jpg`, `phone360-televet.jpg`, `phone360-album.jpg`, `phone360-settings.jpg`…). `phone360-tall-*.jpg` show whole screens.

Order followed (owner's priority): sign-in and demo accounts → clinic page, booking, booking details → pet profile, routine → SOS, first aid → tele-vet → vault, album, messages, notifications, family, Plus, settings, Ask PawSetu, product, cart, onboarding.

| # | Dimension | Score | Key finding |
|---|---|---|---|
| 1 | Accessibility | 4 | Demo rows are single screen-reader items; SOS call buttons say which clinic they call; 200% sweep passes |
| 2 | Performance | 3 | Demo pet photos are the bundled assets (no network) |
| 3 | Appearance and theming | 4 | Red only for emergencies; tokens only |
| 4 | Platform conformance | 4 | Standard buttons, lists and chips; one filled action per screen |
| 5 | Adaptivity | 4 | SOS call buttons stack on phones; clinic page two columns on desktop |
| **Total** | | **19/20** | **Excellent** |

## Fixed in this batch
- **[P1] SOS phone numbers were cut off** ("Call · +91 90000…") — the number shrinks to fit; on phones Call and Map stack at full width.
- **[P1] Red outside emergencies** — SOS screen title, second option, first-aid list and map pins neutral; clinic page "24x7" chip calm; video-call hang-up and recording dot berry.
- **[P2] Six chips in a row on the clinic page** — one chip, rating as text, the rest on a quiet line.
- **[P2] Demo account descriptions cut with "…" and a "Demo" chip on every row** — full text, no repeated chip, each family's pet photo.
- **[P2] Upper-cased labels** (booking steps, booking tiles, walk tracker, video call) — sentence case (Hindi and Telugu can't be upper-cased).
- **[P2] Monospace for prices and times** — normal type; mono stays for IDs (registration numbers, microchips).

## Not changed (owner's decisions or out of scope)
- Screens opened outside the tabs still hide the bottom bar or side navigation (changing it changes navigation; suggestion in the morning report).
- Printed pages (prescription, health report, invoice, sample documents, lost-pet poster) keep their own print look, as DESIGN.md allows.

## Positive findings
- The first thing a demo visitor sees is four families with their pets' photos.
- SOS reads calm: one red action, plain words, the pet's medical card on the cocoa panel.
