# Design 2: review (3 Nov 2026)

The owner made Design 2 in Google Stitch and shared it as a zip on 3 Nov 2026. This folder is the record of it.

- `source/`: the files exactly as received. There are 12 screens (`*/code.html`), the design rules (`pawsetu_design_system.md`) and Stitch's Flutter notes (`pawsetu_flutter_design_tokens_engine_architecture.md`).
- `screens/`: pictures of each screen at phone width (390 px, `_m.png`) and desktop width (1440 px, `_d.png`). The photos in the designs are hosted by Google and didn't load, so they show as grey boxes.

**Status:** reviewed, **not built**. Design 1 stays in the app until the owner says go (see `UI_REVAMP.md`).

## What Design 2 is

| | Design 1 (app today) | Design 2 |
|---|---|---|
| Main action colour | Teal `#0F766E` | Terracotta coral `#C84735` (dark mode `#FF7A66`) |
| Trust / verified colour | Teal | Deep forest teal `#18453E` with soft sage `#E6F0ED` |
| Page background | Warm off-white `#FAF8F5` | The same `#FAF8F5`, plus soft sand `#F3EFEA` for groups |
| Fonts | Plus Jakarta Sans, plus Noto Sans for Hindi and Telugu | Plus Jakarta Sans for headings, **Inter** for body text, **JetBrains Mono** for times, IDs and doses |
| Icons | Material Icons, rounded | Material Symbols, outlined |
| Corners | 14 to 28 | 6 / 12 / 16 / 20 / 28 / round |
| Shadows | Light | 1 px warm border plus a soft two-layer shadow |

**The 12 screens:**
1. Mobile home ("Explore")
2. Clinic discovery (desktop)
3. Clinic profile and slot booking
4. Booking confirmed
5. Vet map
6. Health records vault
7. Pet health certificate
8. SOS emergency
9. Tele-vet video call
10. Pet onboarding
11. Family and caregiver access
12. Vet clinic portal queue

## What works well
- Warm and trustworthy, and calm rather than cartoonish, which matches the brief.
- Prices are clear and shown up front ("Consultation ₹750, Facility fee FREE, Total ₹750"), and distance and time badges are easy to read.
- Booking on desktop is split into two columns (clinic on the left, slots and total on the right) with a single main button, "Confirm Booking for Bruno".
- The health pass card, the vaccine timeline with status tags, and the pet switcher pills are strong, reusable patterns.
- Buttons say exactly what they do ("Confirm Booking for Bruno", "Download Signed Digital Prescription").

## Problems to fix before building
1. **Coral buttons look like emergency red.** Coral `#C84735` and SOS red `#DC2626` are almost the same colour. Everyday "Book" buttons look alarming, and real emergencies stand out less.
2. **Hard-to-read colours.** Text needs a contrast of 4.5:1 and borders need 3:1.
   - White on amber ("Book Slot", "Book Booster"): 3.2:1
   - White on green ("Open Now"): 2.5:1
   - White on the `coral` token `#E05A47`: 3.7:1
   - Grey `#78716C` on sand: 4.2:1
   - Card and input borders `#E7E2DA`: 1.2:1
3. **Very small text.** Text is 10 px 35 times and 11 px 82 times. The app's rules say nothing below 13 px, and Easy mode users need it bigger still.
4. **The SOS screen breaks on a phone.** The title "24/7 Veterinary Emergency Line" wraps onto four lines and runs off the top, and the "Alert ER: 080 4422 9988" buttons wrap onto two lines.
5. **The desktop top bar is crowded.** "Vet Clinics", "Health Vault" and "24/7 SOS" wrap onto two lines at 1440 px.
6. **The rules disagree with each other.** There are two corals (`#C84735` / `#E05A47`) and two secondary greys (`#44403C` / `#78716C`). We need one of each.
7. **Not shown:** dark mode, Hindi and Telugu, Easy mode, and loading, empty and error states. The rules describe them, but no screen shows them.

## Things that change how the app works, not just how it looks (owner decides)
- **Bottom tabs.** Design 2 has 4 tabs (Explore, Health, Bookings, Profile). The app has 5 (Home, Health, Book, Shop, Me). Design 2 has no Shop tab, and its home is clinic search instead of the pet's day (Today, routine, reminders).
- **Things in the designs that the app doesn't have:**
  - pet blood group
  - pet ambulance requests and ambulance dispatch
  - live hospital status (ICU beds, blood bank, oxygen)
  - Kannada language (the app has English, Hindi and Telugu)

  These would be new features, not a redesign.
- **Screens Design 2 doesn't cover:**
  - Home / Today and routine
  - Shop (8 screens)
  - Album
  - Messages
  - Plans
  - Assistant
  - Notifications
  - Settings
  - Sign-in
  - Admin
  - Groomer, trainer, boarder and walker partner screens

  These would be designed in the same style from the Design 2 rules.

## New fonts or packages (need the owner's OK)
- **Inter** and **JetBrains Mono** would be bundled in the app (both are free and open-licence). Neither has Hindi or Telugu letters, so those languages keep Noto Sans.
- Material Symbols icons would need a new package. Flutter's built-in outlined Material Icons look almost the same and need nothing new. Recommendation: use the built-in ones.
- Stitch's note suggests a branded loading screen for the website (`web/index.html`). This is a look-only change and is fine to include.
- Stitch's note puts tokens in `lib/theme/pawsetu_tokens.dart`. This project keeps all tokens in one file, `lib/core/theme/tokens.dart`, so Design 2's values would go there instead.
