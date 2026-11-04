# PawSetu UI revamp: running plan

Branch: `ui-revamp`.

> **Owner instruction, 3 Nov 2026: "Don't consider the Figma designs."** The Figma file and the design-system proposal in section 2 below are **not used** for anything. Design 2 is the owner's Stitch design in `docs/design-2/`. Figma steps are dropped from this work. The Figma file still exists, unused: [PawSetu – Design System v2](https://www.figma.com/design/RdduLVvn2mYCDQjCcIMBg8). It should only be deleted if the owner asks.

PawSetu is an all-in-one pet care app for pet parents in India: health and vaccines, daily routines, vet and grooming bookings, a pet shop and emergency help, in English, Hindi and Telugu.

**Look and feel:** friendly, warm and trustworthy. Clean and modern, not cartoonish.

**Names we use (set by the owner, 3 Nov 2026):**
- **Design 1** is the look the app has today: the code on branch `claude/inspiring-lovelace-1eo1xz` at commit `97c1346`. The Netlify demo shows the same look if it was last published from this code (not checked). The screenshots in `docs/ui-revamp/before/` are Design 1. To get Design 1 back at any time, use the app code from that commit.
- **Design 2** is the design the owner made in Google Stitch and shared on 3 Nov 2026. The files, pictures and review are in `docs/design-2/` (see `docs/design-2/REVIEW.md`). It is **not in the app yet**. Build it only when the owner says go, on its own branch, keeping Design 1 safe.
- The design system proposed in section 2 of this plan (and its Figma board) is **not** Design 2 and is **dropped**. Do not use it.
- The earlier "Neel" proposal (`docs/design-proposals/`) was turned down and is neither Design 1 nor Design 2.

**Live now (4 Nov 2026): Design 2.** The owner said "be on Design 2 but put Design 1 in hold. I will improve Design 2". https://pawsetu-demo.netlify.app shows Design 2 (Netlify deploy `6aeb4edc6809a9e375d86932`, from `ui-revamp`). Design 1 is on hold: Netlify deploy `6ae91e4fc7fd9b9bf45ac64f` and Git commit `97c1346`.

**Design 1 is the permanent backup (owner's rule, 3 Nov 2026).** The owner is making a new design (Design 2). If Design 2 turns out worse and the owner says "go back to Design 1", the app must return to Design 1 and work fully, with no errors.
- **Where Design 1 is saved:** commit `97c1346` on GitHub. It is the tip of branch `claude/inspiring-lovelace-1eo1xz` and is also in the history of `ui-revamp`. The screenshots in `docs/ui-revamp/before/` show how it looks. (A `design-1` Git tag was tried, but GitHub refused tag pushes from this session; the commit itself is the backup.)
- **Checked working on 3 Nov 2026:** `flutter analyze` found no issues, all 204 tests passed (including the layout sweep across roles, languages and screen sizes), and the web build succeeded.
- **Rules while Design 2 is built:** Design 2 work goes on its own branch, never onto Design 1's commit. Never delete, rewrite or force-push the commit or branch that holds Design 1.
- **How to go back when the owner asks:** put the app's look back to `97c1346`. Keep any features or fixes added since then, unless the owner says to drop them. Then run `flutter analyze`, all tests and a web build, and click through the main screens in light and dark, English and Telugu, Easy mode, and at 360 px and desktop widths. Only report "done" when all of these pass.

## Status

| Step | State |
|---|---|
| 1. Audit (read-only) | ✅ Done 3 Nov 2026 |
| 2. Proposal (tokens, components, order) + Figma "Foundations" frame | ❌ Dropped 3 Nov 2026: the owner said not to consider the Figma designs. Replaced by the owner's Design 2 (`docs/design-2/`) |
| 2b. Review of the owner's Design 2 | ✅ Done 3 Nov 2026: `docs/design-2/REVIEW.md`. The owner said "GO" (with Claude's 6 picks) on 3 Nov 2026 |
| 3. Build the foundation from Design 2 (one token file, shared components; no Figma) | ✅ Done 4 Nov 2026 (see "Design 2 build notes" below) |
| 4. Redesign screen by screen | ✅ Done 4 Nov 2026: every screen group in the checklist below. Before/after pictures in `docs/ui-revamp/compare/screens/` |

**Rules for this work:** UI/UX only (no business logic, API calls, data models or routing). Commit after each screen. No Figma work (owner, 3 Nov 2026). Ask before adding any library, font or tool. Keep features and content; suggest copy and flow changes in the list at the bottom instead of making them.

**Relation to earlier decisions:** On 3 Nov 2026 the owner turned down the full "Neel" redesign (`docs/design-proposals/`). Later that day the owner made their own Design 2 in Google Stitch and said "GO" to build it, with Claude's 6 picks (`docs/design-2/REVIEW.md`). Sections 1 and 2 below are the earlier audit and the dropped proposal, kept as a record.

## Design 2 build notes (4 Nov 2026)

**The owner's 6 picks (approved with "GO"):**
1. Colours and text sizes are adjusted slightly so everything is readable.
2. The app keeps its 5 tabs, styled the Design 2 way.
3. Features the app doesn't have (blood group, ambulance, live hospital status, Kannada) are left out.
4. Screens Design 2 doesn't cover are designed in its style.
5. Inter and JetBrains Mono are added. Hindi and Telugu keep Noto Sans.
6. Flutter's built-in icons are used, with no new icon package.

**Where things live:**
- Every value (colours for light, dark and high contrast; fonts; type scale; spacing; corners; icon sizes; strokes; opacities; shadows; motion; component sizes) is in one file, `lib/core/theme/tokens.dart`.
- `lib/core/theme/app_theme.dart` builds the Material theme from those tokens only.
- Proof search: `bash docs/ui-revamp/check_design2_tokens.sh`. It lists any typed-in style value in the files moved to Design 2; it came back empty on 4 Nov 2026.

**Colour roles:**
- Brand is deep forest teal `#18453E`, used for navigation, links, selected chips, progress and verified/health information.
- Main actions use terracotta coral `#B9532E` (Book, Confirm, Save, Reorder).
- SOS red `#DC2626` is used only for emergencies.
- Amber is for ratings, Plus, streaks and "due soon"; green for done.
- Readability changes from Stitch's values:
  - coral `#C84735` became `#B9532E`, so it no longer looks like the SOS red
  - grey text `#78716C` became `#6B635D`
  - inputs got a 3:1 border `#8F877F`
  - amber and green are a little darker
  - no text is under 12 px

**Shared pieces restyled (every screen gets these):**
- buttons: coral pill main button, white pill secondary, round icon buttons
- cards (white, 20 px corners, warm border, soft shadow; they shrink slightly when pressed)
- the new alert card (Design 2's "Booster due" card), status chips and the new pet pills
- the SOS pill (same press-and-hold safety), dialogs and the dark-mode delete-button fix
- bottom tabs and the desktop side menu
- the logo in Design 2 colours
- a visible coral focus ring for keyboard users

**Home (screen 1), same content as before:**
- New top bar: logo, messages, bell and SOS, with pet pills below (All pets, each pet, Add pet).
- Greeting, then the pet card.
- Today card, with a smaller Log button that no longer stretches.
- "Next up": the most urgent item is an alert card, and up to 2 more follow as rows.
- Quick actions, walk weather, food running low and "On this day".
- On desktop the page has 2 columns (your day on the left; Next up and tips on the right), instead of one 1,040 px-wide column.
- Easy mode stays one column with bigger text.

**Checks on 4 Nov 2026:**
- `flutter analyze`: no issues.
- All 204 tests pass. The layout sweep covers every main screen in 3 languages at 360 px with double text, tablet, desktop, Easy mode and dark mode. The colour test now also checks the Design 2 pairs, plus a 3:1 check for borders and the focus ring.
- The web build succeeded.
- Pictures:
  - after, phone 390 / 360 Telugu / Easy mode / dark, and desktop light / dark: `docs/ui-revamp/after/`
  - side by side with Design 1: `docs/ui-revamp/compare/`

**Not done yet (later screens):**
- The other screens already use the new colours, fonts, buttons and cards, but their layouts are still Design 1. Each one gets its turn in the checklist.
- Field labels above the box (Design 2 forms) come with the forms screens.
- The app icon and the website loading screen still use Design 1 colours. They can change with the final sweep.

**Fixes to other screens:** the new font made a few rows too wide at double text size. These were fixed with layout-only changes: place reviews, seller reviews, the notifications "Mark all read" button, the food-running-low buttons, and chip and link widths.

---

## Design 2.1: match the owner's finished pictures (from 4 Nov 2026, evening)

The owner sent finished pictures of the 12 Design 2 screens (`docs/design-2/screens-v2/`, Stitch files in `docs/design-2/source-v2/`; 4 of them changed a little: clinic list, clinic page, booking confirmed, SOS) and said: "make UI like this". The live website is on Design 2; Design 1 is on hold (see above).

**Owner's answers (4 Nov 2026):**
1. Home: **both**. The top of Home looks like the picture (location pill, search, chips, dark booster card, nearby vets); the pet's day (Today card, Next up) stays below.
2. Menus: **both like the pictures**. Desktop gets a top bar with pill buttons; phones get a floating dark bottom bar. The 5 tabs stay (Home, Health, Book, Shop, Me).
3. Booking: **on the clinic page**. Pet, reason, date, time and price on the clinic page; notes, photos and payment on one short confirm screen after it.
4. Photos: **keep drawn pictures** (no new image files).

Left out (features the app doesn't have): blood group, ambulance, live ICU/blood-bank status, QR kiosk check-in, WhatsApp pass, Kannada, "verified" claims.

**Checklist (tick as each is committed):**
- [x] A. Menus: desktop top bar with pill buttons; phone floating dark bottom bar (4 Nov 2026)
- [x] B. Home: picture-style top (location, search, chips, dark booster card, nearby vets), pet's day below (4 Nov 2026; Easy mode keeps the simple Home)
- [x] C. Clinic list: photo-top cards with badges, rating, next slot box, price and Book visit (4 Nov 2026; 2 or 3 columns on wide screens; the map preview keeps a compact card)
- [x] D. Clinic page: photo header, rating pill, action pills, vet on duty, booking panel (right column on desktop) and a short confirm screen (4 Nov 2026). Facility tiles left out: the app has no facility data. Tapping a service picks it in the booking card. The old 4-step booking still works when opened without a chosen time (e.g. from other links)
- [x] E. Booking confirmed: booking pass with When / Where / Vet / Amount tiles, clinic row with Directions, Add to calendar (4 Nov 2026)
- [x] F. Health: 2 columns on desktop (pass, emergency info, weight, reminders | next up with Book on vaccines, timeline with Certificate buttons, deworming cards side by side, medicines, visits, symptoms) (4 Nov 2026). No tabs: every section stays visible
- [ ] G. SOS: red alert card, dark pet card, hospital cards with dark call button and Map
- [ ] H. Map: list beside the map on desktop
- [ ] I. Account: profile card, family with role badges, preferences card
- [ ] J. Add pet: form in one card, two boxes per row on desktop
- [ ] K. Tele-vet: video card, doctor card, notes panel
- [ ] L. Certificate: medical card and health report like the certificate picture
- [ ] M. Clinic portal: dark top bar, number tiles, queue table
- [ ] N. Checks, pictures, preview link for the owner

## Design 2 everywhere (4 Nov 2026)

**What changed on every screen:** outlined icons; labels above form boxes; red only for emergencies; times, prices, IDs and codes in JetBrains Mono; every colour, size and gap from `tokens.dart`.

**New shared pieces** (`lib/core/widgets/`): `PassCard` (health pass, medical card, booking confirmed), `TimelineTile` (vaccines), `ChoiceTiles` (species), `OptionCard` (service and payment), `PriceSummary`, `DateBadge` (bookings), `RatingStars`, `FieldLabel`, `LabeledField`, `PawPickerField`.

**Files that keep fixed values on purpose** (listed at the top of the proof search): the token and theme files, generated translations, printed A4 pages (they use `PrintColors`) and drawn artwork.

**Checks:** `flutter analyze` clean; 204 tests pass (layout sweep in 3 languages at 360 px with double text, tablet, desktop, Easy mode and dark mode; colour test including the pass, option cards and price summary); web build with no page errors on the 17 main screens.

### Further improvements (not done; owner to decide)
1. **App icon pictures** on phones and in the browser tab are still the Design 1 artwork. New icons need image files for Android, iOS and the web. The logo inside the app already uses Design 2 colours.
2. **Shop "For Bruno" filter** still uses Material choice chips; it could use the pet pills from the top bar for consistency.
3. **Family and caregiver access** could follow Design 2's role cards with on/off switches per permission (today it is a list).
4. **Clinic portal queue** could follow Design 2's queue manager layout (today it uses the shared cards and tokens only).
5. **Health pass buttons** stack on small phones; a single "Share" button that opens Medical card / Health report would keep the pass shorter.
6. **Photo headers** on clinic pages are the demo's placeholder art; real clinic photos would make Design 2's photo-led cards shine.

## 1. Audit

### Stack and where styles live
- **Flutter 3.47 / Dart 3.13**, Material 3, one codebase for Android, iOS and web. State: Riverpod 3; navigation: go_router 18.
- **Tokens:** `lib/core/theme/tokens.dart` (`PawColors` light/dark, `PetTagColors`, `Space`, `Radii`, contrast helpers).
  **Theme:** `lib/core/theme/app_theme.dart` (Material `ColorScheme`, `TextTheme`, component themes). The brand teal and about 25 other colours are typed directly in `app_theme.dart`, not in the token file.
- **Fonts (bundled):** Plus Jakarta Sans for English, Noto Sans Devanagari for Hindi and Noto Sans Telugu for Telugu, in weights 400, 500, 600 and 700 (`assets/fonts`).
- **Icons:** Flutter's built-in Material Icons, "rounded" style (1,060 uses; 10 non-rounded leftovers).
- **Shared widgets:** `lib/core/widgets/` holds 17 files:
  - buttons: `PrimaryButton`, `SecondaryButton`, `QuickActionTile`
  - cards: `PawCard`, `SectionHeader`, `StatusChip`, `StatTile`, `DemoBanner`, `InfoNote`
  - inputs: `PawTextField`, `ChoiceRow`
  - states: `EmptyState`, `ErrorState`, `Skeleton`, `SkeletonList`, `AsyncView`
  - dialogs: `showDemoDialog`, `confirmAction`, `showToast`, `showPawSheet`
  - media: `PetAvatar`, `MediaImage`/`SeedArt`, `Illustration`/`PetFace`, `PawSetuLogo`
  - layout: `PageBody`, `ResponsiveGrid`, `TileGrid`, `ChipStrip`, `ShowMoreButton`, `Gap`, breakpoints
  - other: `ProgressRing`, `SosButton`, `OfflineBanner`, `PawMap`, photo picker, `DocumentPreviewScreen`/`A4Page`
- **Missing shared pieces:** a list row, top bar, filter chip, badge, ghost and destructive buttons, button sizes, bottom-sheet layout, photo frame with fixed aspect ratios, and focus styling.

### Every screen (61 screen files, about 120 routes)
The full route list is in `docs/APP_OVERVIEW.md` §3. In short:
- **Start:** splash, welcome, sign in, sign up, forgot password, phone code, demo accounts, verify email, setup (preferences, first pet, notifications), partner sign-up, account paused.
- **Five tabs:** Home, Health, Book, Shop, Me.
- **Book:** clinic/provider finder (list and map), clinic page, booking flow, booking done, my bookings, booking detail.
- **Shop:** search, product, cart, order placed, orders, order detail, addresses, expenses, invoice.
- **Pets:** my pets, add/edit pet, pet profile, routine, walk tracker, health report, medical card, birthday, family, join invite.
- **Talk:** messages inbox, new chat, chat, tele-vet home/new/consent/call, Ask PawSetu, prescription.
- **Documents and photos:** vault (PIN gate), document, read details, share links, insurance, public share page, album, album viewer.
- **Safety:** SOS, first aid list and guide, "Is it safe?", lost pet list and detail, public lost page, devices list/add/detail.
- **Account:** notifications, settings, notification settings, Plus, refer a friend, privacy, help (list, new, detail), design gallery, coming soon.
- **Partner portal and seller portal:** dashboard, calendar, requests, services, staff, reviews, payouts, profile, emergency, chat, tele-vet queue, products, orders, returns, CSV upload, consultation, prescription builder.
- **Admin panel:** dashboard, approvals, users, catalogue, complaints, moderation, plans and settings, Demo Outbox, audit log, commission report.

### Figma
There was no Figma file for PawSetu, so there is nothing to compare the code against yet. A new file was created for this work (link at the top).

### Screenshots (before)
`docs/ui-revamp/before/`: 17 screens at 390 px (phone, 2×) and 1440 px (desktop), plus Home in dark mode. Taken from a local build of this branch in the standalone demo, signed in as Priya.

### Counts: hard-coded style values in screen code
Counted with `python3 docs/ui-revamp/count_hardcoded.py .` over `lib/` (245 Dart files), **leaving out** the token/theme files, printable documents (prescription, health report, invoice, sample documents, A4 preview) and vector artwork (illustrations, logo), where fixed values are correct:

| What | Count | Distinct values |
|---|---|---|
| Hex colours `Color(0x…)` | 79 | **40** (brand teal typed by hand 9×) |
| Material palette `Colors.white/black…` | 77 | 9 |
| One-off transparent tints `.withValues(alpha:)` | 62 | – |
| `fontSize:` literals | 27 | **14** (9 to 72) |
| `FontWeight` overrides | 37 | 4 (incl. 800 and 900) |
| Gaps `SizedBox(height/width: N)` | 146 | **43** |
| `EdgeInsets` with literal numbers | 78 | 20 |
| Corner radius literals | 61 | **12** (2, 3, 4, 6, 8, 10, 12, 14, 16, 18, 24, 100) |
| Icon size literals | 118 | **20** |
| Pet avatar sizes | 34 | **16** (24 to 200) |
| Theme text sizes | 15 styles | **10** sizes (12, 13, 16, 18, 22, 24, 28, 32, 36, 40) + 4 weights |

**Components built by hand instead of shared:** 101 `ListTile`, 86 `AppBar`, 86 `Chip`/`ChoiceChip`/`FilterChip`, 33 `FilledButton`, 39 `OutlinedButton`, 67 `TextButton`, 17 `TextField`, 18 spinners.
**Already shared and used well:** `PawCard` ×222, `PrimaryButton` ×135, `PawTextField` ×132, `StatusChip` ×129, `EmptyState` ×77, `AsyncView` ×59.

### Top 10 problems, ranked by impact

1. **No shared list row, top bar or chip, so every screen builds its own.** That is 101 hand-made list rows, 86 top bars, 86 chips and 139 raw buttons. *Example:* the Health tab shows two different row styles on one screen: "Next up" has icons in tinted circles, while "Vaccinations" has bare icons (`lib/features/health/presentation/health_screen.dart`). The Messages search icon is smaller than the Shop search icon (`inbox_screen.dart` vs `shop_home_screen.dart`).
2. **Too many colours compete; nothing reads as "the main thing".**
   - There are 40 hard-coded colours in screen code. The six Book tiles each use a different colour (`booking/presentation/book_home_screen.dart:22-27`). Shop categories add 23 more (`shop_labels.dart`) and routine items 11 (`routine_labels.dart`).
   - Cards are tinted with the pet's colour (`home/presentation/home_screen.dart:68`), the Health tab's "Health report" and "Medical card" are loud apricot pills, and the Shop opens with a full apricot banner.
   - The brand teal lives in `app_theme.dart:36`, not in the token file.
3. **Text sizes are uncontrolled and the important details are small and grey.**
   - The theme has 10 sizes: `bodyLarge` and `bodyMedium` are both 16, and `titleLarge` and `headlineSmall` are both 22 (`core/theme/app_theme.dart:69-85`).
   - Screens add 14 more sizes and 800/900 weights.
   - The 13 px grey `bodySmall` is used 235 times, often for key facts (age and weight, due dates, prices per km). This is harder still in Hindi and Telugu.
4. **Contrast failures.**
   - Star ratings are apricot text at **2.1:1** (`booking/presentation/place_screen.dart:237`, `partner/presentation/partner_sections.dart:599`, product cards).
   - Apricot icons sit on their own tint at **1.9:1** (Home "Add photo", Book "Tele-vet").
   - Input, chip and outlined-button borders (#E5E1DA) are **1.2:1** against the page. Form fields need 3:1 (`app_theme.dart:139-147, 155`).
   - **Bug:** in dark mode the "Delete?" confirm button is white on #F87171 at **2.8:1** (`core/widgets/dialogs.dart:36`). `PrimaryButton` already has the fix, but `confirmAction` doesn't use it.
5. **There's no visible keyboard focus.** The theme defines no focus colours and the whole app has 3 focus references. On the website, someone using Tab can't see where they are.
6. **Spacing, corners and icon sizes are improvised.** There are 43 different gap sizes, 12 corner sizes and 20 icon sizes (chat bubbles `messaging/presentation/chat_widgets.dart`, `assistant/presentation/ask_screen.dart`, `album/presentation/album_screen.dart`, `sos/presentation/lost_screens.dart`). Cards are 20 px, but tiles, bubbles, banners and thumbnails each choose their own.
7. **The selected tab is brown on mint.** In light mode the active icon in the bottom bar and side menu is brown (#4A2508) on a mint pill, because `navigationBarTheme` and `navigationRailTheme` don't set icon colours (`app_theme.dart:198-215`). It shows on every tab screen.
8. **Too many competing actions on key screens.**
   - The product page's bottom bar has a quantity stepper, "Add to cart" and "Buy now", and "Add to cart" wraps onto two lines at 390 px (`shop/presentation/product_screen.dart`).
   - The Today card has 3 filled round buttons, a full-width "+ Log" and "See all" (`routine/presentation/today_card.dart`).
   - Shop puts orders and cart icons under a top bar that already has messages, bell and SOS: 5 icons.
9. **Photos and placeholders are inconsistent.** Pet avatars come in 16 sizes. Album tiles are 1.3:1, product cards 1.3 / 1.15 / 1:1 and device images 16:9. Clinic results use pink and purple gradient placeholders that stop short of the card's bottom edge (`booking/presentation/place_finder_screen.dart`). Products use gradient art (`shop/presentation/product_widgets.dart:125`). Pet photos are never the hero: the pet profile shows a small circle on an apricot band.
10. **The desktop layout stretches.** At 1440 px the Home content is about 1,150 px wide. The checklist's action buttons sit about 1,000 px from their labels and "+ Log" is 1,040 px wide (`core/widgets/layout.dart` `maxContentWidth: 1200`). Side-menu labels are 13 px.

Also noted:
- Two card styles sit on one screen (shadowed cards next to outlined tiles on Book).
- Discounts are shown twice on product cards ("13% off" badge and "13% off" text).
- Ratings use a "★" text character instead of an icon (8 places).
- Skeletons are generic grey 84 px blocks that don't match the content.
- There are no hover, pressed or disabled designs beyond Material defaults.
- Long demo-account descriptions are cut off with "…".

---

## 2. Proposal (DROPPED: owner said not to consider it; kept only as a record)

### Colour
One brand colour (the current teal) with a full tint scale, one neutral scale, and status colours. Apricot stays only as a small **highlight** because it is in the logo: streaks, birthdays, offers. It is never used for text, buttons or card backgrounds.

**Brand (teal):** 50 `#F0FDFA` · 100 `#CCFBF1` · 200 `#99F6E4` · 300 `#5EEAD4` · 400 `#2DD4BF` · 500 `#14B8A6` · 600 `#0D9488` · **700 `#0F766E` (primary)** · 800 `#115E59` (pressed) · 900 `#134E4A` · 950 `#042F2E`

**Neutral (warm paper + teal-grey ink):**

| Step | Hex | Use |
|---|---|---|
| 0 | `#FFFFFF` | surfaces |
| 50 | `#FAF8F5` | page |
| 100 | `#F3F0EB` | subtle fills, hover, skeleton |
| 200 | `#E5E1DA` | dividers |
| 400 | `#8A9799` | disabled |
| 500 | `#6F7F82` | control borders (3.9:1) |
| 600 | `#5B6B6E` | secondary text (5.3:1) |
| 700 | `#3E4D50` | icons |
| 900 | `#1C2B2D` | primary text (13.8:1) |

**Status:**

| Status | Light | Tint | Dark |
|---|---|---|---|
| Success | `#15803D` | `#F0FDF4` | `#4ADE80` |
| Warning | `#B45309` | `#FFFBEB` | `#FBBF24` |
| Error | `#B91C1C` | `#FEF2F2` | `#F87171` |
| SOS | `#DC2626` | – | `#DC2626` (both modes, always with white text, 4.8:1) |

- Destructive buttons: `#B91C1C` in light mode, `#DC2626` in dark.
- **Highlight (apricot):** 100 `#FDF1E7` · 500 `#F4A261` (logo, illustration and streak fill only) · 700 `#9A4A17` (text and icons on the tint, 5.6:1). Star ratings use highlight-700.
- **Pet tags** (the owner's choice per pet) stay as they are, but only on the avatar ring and small dots. They are no longer card backgrounds.
- **Dark mode** keeps today's dark values (page `#0E1415`, surface `#172124`, border `#2A3639`, text `#E8EEEE` / `#9FB0B2`, primary `#2DD4BF`). Control borders become `#6B7C7F` (4.3:1).
- **Focus ring:** 2 px brand-700 (brand-300 in dark), 2 px away from the element.

### Type: one family, 6 sizes, 3 weights
Plus Jakarta Sans. Noto Sans Devanagari and Noto Sans Telugu are the same styles for Hindi and Telugu, not extra families.

| Token | Size / line | Weight | Use |
|---|---|---|---|
| `display` | 32 / 40 | Bold 700 | big numbers, celebrations, SOS |
| `title` | 22 / 28 | Bold 700 | screen titles, pet name |
| `heading` | 18 / 24 | SemiBold 600 | section headers, card titles |
| `body` | 16 / 24 | Regular 400 (SemiBold 600 for buttons and emphasis) | text, list titles, inputs |
| `small` | 14 / 20 | Regular 400 / SemiBold 600 | secondary text, list subtitles, chips, badges, tab labels |
| `micro` | 12 / 16 | Bold 700 | count badges and map labels only |

Hindi and Telugu keep the taller 1.6 line height. The smallest everyday text grows from 13 to 14 px (spec §4 says caption 13; this changes it to 14 for readability).

### Spacing (4 px scale)
`xs 4 · sm 8 · md 12 · lg 16 · xl 24 · x2l 32 · x3l 48 · x4l 64`. The phone gutter is 16 and tablet 24. Card padding is 16, sections are 24 apart, list rows have 12 vertical and 16 horizontal padding, and inline gaps are 8.

### Corners (3 values + round)
- `sm 8`: thumbnails, small tags, tooltips
- `md 12`: buttons, inputs, toasts
- `lg 20`: cards, dialogs, sheets, photos
- plus `full` for pills and circles

### Shadows (light mode only; dark mode uses surface tones and a 1 px border)
- `raised`: 0 1 2 / 6% + 0 2 6 / 4% (cards)
- `floating`: 0 4 12 / 10% (FAB, sticky bars, menus, toasts)
- `overlay`: 0 12 32 / 16% (dialogs, sheets)

All shadows use ink `#1C2B2D`.

### Icons
One set: the built-in Material Icons **Rounded** (no new package), filled, with the outlined version only for unselected tabs. 4 sizes: `16` (inline with small text), `20` (in buttons and chips), `24` (default: bars, lists, nav), `32` (feature tiles). Ratings use the star icon, not "★".

### Pet photos
- **Avatar:** 1:1 circle in the pet-tag ring, in 4 sizes (`24 / 40 / 56 / 120`).
- **Pet cover** (profile header, Home pet card): 4:3, `lg` corners, cropped to fill.
- **Album grid:** 1:1. **Memory card:** 4:3. **Products:** 1:1. **Clinics and providers:** 4:3 in cards, 1:1 thumbnails in lists.
- **Missing photo:** pets get the illustrated face on a light tint of their tag colour. Products and clinics get a neutral-100 panel with a 32 px category icon. No gradients.

### Components (code name = Figma name)
| Component | Variants / sizes | States |
|---|---|---|
| `PawButton` | primary, secondary (outlined), ghost (text), destructive; `lg 56` (Easy mode, sticky CTA), `md 48` (default), `sm 40` visual with 48 tap area; optional leading icon | default, hover, pressed, focus, disabled, loading |
| `PawIconButton` | standard, filled, tonal; 48 tap / 24 icon; always has a tooltip | default, hover, pressed, focus, disabled |
| `PawTextField` | text, multiline, search, with prefix/suffix; label above the field; 48 (56 Easy) | default, focus, filled, error, disabled |
| `PawCard` | default (raised), interactive, outlined/selectable, highlight (brand-50, one per screen) | default, hover, pressed, focus, selected |
| `PawChip` | filter (single/multi), input (removable), pet chip (avatar + name) | default, selected, hover, focus, disabled |
| `PawAvatar` | pet (photo / illustrated face, tag ring), person (initials); 24/40/56/120 | default, selected |
| `PawBadge` | status (success, warning, error, info, neutral, highlight), count (number/dot) | – |
| `PawListItem` | leading: icon in a 40 px brand-100 circle (brand-700 icon) / avatar / thumbnail; title + up to 2-line subtitle; trailing: chevron / badge / switch / action; grouped in a card with inset dividers | default, hover, pressed, focus, disabled |
| `PawTopBar` | tab bar (pet switcher, messages, bell, SOS), page bar (back, title, ≤2 actions), large title | – |
| `PawNavBar` | bottom bar (phone), rail (tablet), sidebar (desktop); selected = brand-700 icon on brand-100 pill | default, selected, hover, focus |
| `PawSheet` / `PawDialog` | sheet with handle, title, content, pinned primary action; dialog with title, body, ghost + primary/destructive | – |
| `PawToast` | ink background, white text, optional action | – |
| `EmptyState` | illustration 120, heading, one line, one primary action | – |
| `Skeleton` | row, card, photo (matches the real aspect ratio) | still when "reduce motion" is on |
| `PetPhoto` | avatar, cover 4:3, grid 1:1 | loading, missing (placeholder) |

### Screen order (most-used flows first)
See the checklist below.

---

## 3. Screen checklist

Tick a screen when it is rebuilt with shared components and tokens, its loading/empty/error states are covered, it has been checked at 360/390 px and desktop in light/dark, English/Telugu and Easy mode, and it is committed with before/after screenshots.

- [x] 0. Foundation: one token file (Design 2 values), shared components (4 Nov 2026)
- [x] 1. Home (pet parent), 4 Nov 2026. The owner approved the direction on 4 Nov 2026 ("implement Design 2 in app")
- [x] Icons: the whole app now uses outlined icons (Design 2). Icons that show a state stay filled: rating stars, done ticks, liked hearts, verified badges, filled play/pause, and the selected bottom tab (4 Nov 2026)
- [x] 2. Today and routine: Today card, quick log sheet, routine screen, walk tracker (4 Nov 2026). Log types use the new muted category colours; walk stats sit in one card with small uppercase labels; charts and widths use tokens
- [x] 3. Health tab and its sheets (vaccines, medicines, deworming, vet visits, weight, symptoms), medical card (4 Nov 2026). New shared `PassCard` (Design 2 health pass) and `TimelineTile`. Health opens with the pet's pass (age, weight, microchip, "All up to date" or "N need attention", Medical card and Health report buttons); Next up leads with an alert card; vaccines are a timeline; deworming and flea/tick are soft sand cards; the medical card is a pass
- [x] 4. Pet profile, my pets, add/edit pet, breed picker, birthday (4 Nov 2026). Forms app-wide now have the label above the box (`PawTextField`, new `FieldLabel`, `LabeledField`, `PawPickerField`); the add/edit pet form has big species tiles (`ChoiceTiles`), a "Step 1 of 2" label and picker boxes for breed and birthday; pet care tiles keep red for emergencies only
- [x] 5. Book tab, clinic finder (list and map), clinic page, booking flow, booking done, my bookings, booking detail (4 Nov 2026). New shared `OptionCard` (coral radio cards), `PriceSummary` (sand box, total in coral, prices in mono), `DateBadge` and `RatingStars`. Booking flow: step label, pet pills, service and payment option cards, mono time slots; booking done shows a pass; booking rows start with a date square; clinic page puts Book first with Call / Directions / Message pills; amber filled stars; brand map pins
- [x] 6. SOS, first aid, "Is it safe?" (the SOS look stays instantly recognisable) (4 Nov 2026). The main SOS option stays solid red; the second is a soft red card with a red border (Design 2 emergency card); pet pills; distances in mono; lost pet, devices and first aid use tokens. Printed pages (health report, prescription, invoice, sample documents, lost poster, QR tag) now use new `PrintColors` in the Design 2 forest instead of the Design 1 teal
- [x] 7. Shop home, search, product, cart, order placed, orders, order detail, addresses, food-low card (4 Nov 2026). Product and expense colours come from the category palette; cart amounts in mono with the total in coral; order progress uses brand and token sizes; the 34 px "Reorder" button now has a full tap area; the invoice uses print colours
- [x] 8. Messages inbox, chat, tele-vet (home, new, consent, call), Ask PawSetu, prescription (4 Nov 2026). All values from tokens; the video call stays dark in both themes with a forest glow (new call colours in `MediaColors`), the call timer in mono; photo viewer uses media colours
- [x] 9. Me, settings, notification settings, notifications centre (4 Nov 2026). Tokens only; form labels above the box and outlined icons from the shared pieces
- [x] 10. Sign-in, sign-up, forgot password, phone code, demo accounts, verify email, welcome, setup (4 Nov 2026). Tokens only (logo sizes, sign-in card width, welcome dots, setup species tiles); fields have labels above the box
- [x] 11. Vault (gate, list, document, read details, shares, insurance, public share) (4 Nov 2026). Tokens only; document kinds use readable category colours (the old pastel icons were below 3:1); PIN pad, scan frame and viewers use tokens and media colours
- [x] 12. Album, album viewer, memory card (4 Nov 2026). Tokens only; labels and buttons over photos use media colours so they read on any picture; the birthday screen uses tokens except its confetti artwork
- [x] 13. Family, join invite, lost pet (list, detail, public page), devices (list, add, detail) (4 Nov 2026). Tokens only (lost pet and devices were done with SOS)
- [x] 14. Expenses, Plus, refer a friend, privacy, help and complaints (4 Nov 2026). Tokens only; referral and coupon codes in mono
- [x] 15. Partner portal and seller portal (4 Nov 2026). Tokens only; product thumbnails, order rows and the vet consult panels use size tokens
- [x] 16. Admin panel (4 Nov 2026). Tokens only; coupon codes in mono
- [x] 17. Final sweep: hard-coded-value search is clean, Design 1 still restorable, before/after summary (4 Nov 2026). `bash docs/ui-revamp/check_design2_tokens.sh` checks all 238 Dart files that should use tokens and finds none. Design 1 is still commit `97c1346`. Website loading screen and browser colours are Design 2. Before/after for all 17 screens at phone and desktop width: `docs/ui-revamp/compare/screens/`; after pictures alone: `docs/ui-revamp/after/screens/`

---

## Choices in this proposal that change today's look (owner to confirm)

1. **Apricot becomes a small highlight only.** No more apricot buttons ("Health report", "Medical card"), apricot banners or pet-colour card backgrounds.
2. **Smallest everyday text goes from 13 to 14 px.** Spec §4 says caption 13, so the spec would change too.
3. **Field labels move above the box** instead of floating inside it.
4. **The pet profile header becomes a 4:3 photo** (or the illustrated face on a tint) instead of a small circle on an apricot band.
5. **Fewer corner sizes:** buttons and inputs 14 → 12, sheets 28 → 20.
6. **Desktop reading width:** Home and lists max 1,040 px, grids 1,200 px.

## Suggested copy and flow changes (not made; for the owner to decide)

1. **Keep the bottom bar / side menu on detail screens.** Pet profile, messages, notifications, settings and the vault are outside the tab frame, so the navigation disappears (`core/routing/extra_routes.dart:77`). This is a routing change, so it's out of scope for this work.
2. **Pages opened from a web link have no back button** (pet profile, messages). An "up" button to the parent tab would avoid a dead end. This is also a routing change.
3. **Group the "Me" list** (14 flat links) into "My pets and family", "Safety and documents", "Shopping and money" and "Account and help".
4. Product page: the top bar says only "Product". Suggest the product's short name, or no title.
5. Product page: show **one** main button ("Add to cart"), with "Buy now" as a secondary option.
6. Product cards: show the discount once (the badge only).
7. Demo account tiles: shorten the descriptions so they fit without "…" (e.g. "Bengaluru · Plus · Bruno and Misty").
8. Clinic finder: an unknown kind in the address shows the raw word ("vet"); suggest falling back to "Find care near you".
9. Health tab: "Health report" and "Medical card" are now buttons on the health pass. They could move into one "Share" sheet so the pass is shorter.
10. Health pass: Design 2 shows "PawSetu verified health pass". The app doesn't verify records, so the pass is titled "Bruno's health". A new label like "Health pass" could be added if wanted.
