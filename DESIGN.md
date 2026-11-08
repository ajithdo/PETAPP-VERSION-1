---
name: PawSetu — UI Design 5 "Genda"
description: The pet's day as a small daily ritual. Cocoa and marigold, warm on Home, calm on health and SOS.
colors:
  cocoa: "#4A2A12"
  cocoa-pressed: "#2F1A0A"
  cocoa-tint: "#F4ECE3"
  band: "#3A2416"
  on-band: "#FFF6E5"
  on-band-muted: "#EAD7BA"
  marigold: "#F3A712"
  on-marigold: "#2A1A00"
  marigold-ink: "#8F5A00"
  marigold-tint: "#FFF0CC"
  on-marigold-tint: "#6B4100"
  done: "#B26F00"
  page: "#F6F5F3"
  surface: "#FFFFFF"
  surface-subtle: "#EFECE7"
  hairline: "#E6E1DA"
  control-border: "#857A6C"
  focus: "#B26F00"
  text: "#231B12"
  text-secondary: "#5B5044"
  success: "#17703F"
  success-tint: "#E3F3E8"
  on-success-tint: "#13582F"
  warning: "#8A4B00"
  warning-tint: "#FFF1D6"
  on-warning-tint: "#6B3B00"
  error: "#8C1D6E"
  error-tint: "#FBEAF5"
  on-error-tint: "#6E1456"
  sos: "#C81E1E"
  on-sos: "#FFFFFF"
  sos-tint: "#FDECEC"
  on-sos-tint: "#A3161A"
  inverse: "#2B231B"
  on-inverse: "#F4EEE5"
  dark-marigold: "#F5B53F"
  dark-on-marigold: "#2A1A00"
  dark-marigold-tint: "#3A2D14"
  dark-on-marigold-tint: "#FFD98A"
  dark-band: "#2B2214"
  dark-page: "#14110D"
  dark-surface: "#1F1A14"
  dark-surface-subtle: "#28221A"
  dark-hairline: "#3A3226"
  dark-control-border: "#8A7F70"
  dark-text: "#F4EEE5"
  dark-text-secondary: "#BDB2A3"
  dark-success: "#6FD49A"
  dark-warning: "#FFC861"
  dark-error: "#F29BD3"
typography:
  display:
    fontFamily: "Baloo 2, Baloo Tammudu 2, sans-serif"
    fontSize: "36px"
    fontWeight: 700
    lineHeight: 1.22
    letterSpacing: "0"
  headline:
    fontFamily: "Baloo 2, Baloo Tammudu 2, sans-serif"
    fontSize: "26px"
    fontWeight: 700
    lineHeight: 1.3
    letterSpacing: "0"
  title:
    fontFamily: "Baloo 2, Baloo Tammudu 2, sans-serif"
    fontSize: "21px"
    fontWeight: 700
    lineHeight: 1.33
    letterSpacing: "0"
  title-small:
    fontFamily: "Baloo 2, Baloo Tammudu 2, sans-serif"
    fontSize: "17px"
    fontWeight: 600
    lineHeight: 1.35
    letterSpacing: "0"
  body-large:
    fontFamily: "Hind, Hind Guntur, sans-serif"
    fontSize: "17px"
    fontWeight: 400
    lineHeight: 1.5
    letterSpacing: "0"
  body:
    fontFamily: "Hind, Hind Guntur, sans-serif"
    fontSize: "16px"
    fontWeight: 400
    lineHeight: 1.5
    letterSpacing: "0"
  body-small:
    fontFamily: "Hind, Hind Guntur, sans-serif"
    fontSize: "14px"
    fontWeight: 400
    lineHeight: 1.43
    letterSpacing: "0"
  label:
    fontFamily: "Hind, Hind Guntur, sans-serif"
    fontSize: "16px"
    fontWeight: 600
    lineHeight: 1.375
    letterSpacing: "0"
  label-small:
    fontFamily: "Hind, Hind Guntur, sans-serif"
    fontSize: "13px"
    fontWeight: 600
    lineHeight: 1.38
    letterSpacing: "0"
  date-number:
    fontFamily: "Baloo 2, sans-serif"
    fontSize: "26px"
    fontWeight: 700
    lineHeight: 1.08
    letterSpacing: "0"
rounded:
  xs: "4px"
  sm: "8px"
  md: "12px"
  lg: "16px"
  card: "22px"
  sheet: "28px"
  pill: "999px"
spacing:
  xxs: "2px"
  xs: "4px"
  sm: "8px"
  md: "12px"
  lg: "16px"
  xl: "24px"
  xxl: "32px"
  page-phone: "16px"
  page-wide: "24px"
components:
  button-primary:
    backgroundColor: "{colors.cocoa}"
    textColor: "{colors.surface}"
    rounded: "{rounded.pill}"
    height: "48px"
    padding: "0 24px"
  button-primary-pressed:
    backgroundColor: "{colors.cocoa-pressed}"
  button-secondary:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.text}"
    rounded: "{rounded.pill}"
    height: "48px"
  button-sos:
    backgroundColor: "{colors.sos}"
    textColor: "{colors.on-sos}"
    rounded: "{rounded.pill}"
    height: "40px"
  card:
    backgroundColor: "{colors.surface}"
    rounded: "{rounded.card}"
    padding: "16px"
  genda-band:
    backgroundColor: "{colors.band}"
    textColor: "{colors.on-band}"
    rounded: "{rounded.card}"
    padding: "18px"
  chip-pet-selected:
    backgroundColor: "{colors.text}"
    textColor: "{colors.surface}"
    rounded: "{rounded.pill}"
    height: "40px"
  chip-status-ok:
    backgroundColor: "{colors.success-tint}"
    textColor: "{colors.on-success-tint}"
    rounded: "{rounded.pill}"
    height: "28px"
  input:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.text}"
    rounded: "{rounded.lg}"
    height: "52px"
  list-row:
    height: "64px"
    padding: "12px 16px"
  nav-indicator:
    backgroundColor: "{colors.text}"
    textColor: "{colors.surface}"
    rounded: "{rounded.pill}"
---

# Design System: PawSetu — UI Design 5 "Genda"

## Overview

**The pet's day, made into a small daily ritual.** Genda is the marigold garland an Indian home hangs for welcomes and festivals. In the app it appears once, where it matters: around the selected pet's photo on Home, one flower per task today, opening as each one is done. Everything else is quiet: cocoa ink on white and warm-grey grounds, soft rounded cards, plain words.

Two registers share one system:

- **Warm register**: Home, empty states, onboarding, the album, birthdays, streaks. Marigold may fill shapes, Baloo titles may be big, drawings appear.
- **Calm register**: Health, records (vault, medical card, prescriptions, reports), tele-vet, SOS and first aid, partner portals and admin. No marigold fills, no garland, no drawings; green "given" ticks; dates and facts lead; tables use compact density.

Material 3 governs structure, navigation and controls on every platform; the world lends only type, palette, density and the one signature move (the garland). SOS red is the only red in the app.

## Colors

The frontmatter is normative. Light and dark values are listed; high contrast darkens text and borders further (see Named Rules).

### Primary
- **Cocoa** (`cocoa`): the one main action on a screen (Book, Save, Confirm), selected navigation text, links, the selected pet chip. Deep enough for white text (13:1). Pressed: `cocoa-pressed`. Tint `cocoa-tint` behind brand information.
- **Band** (`band`): the Genda band on Home and the dark hero panels (health pass). Text on it is `on-band`; its quiet lines use `on-band-muted`.

### Secondary
- **Marigold** (`marigold`): flowers in the garland, progress bars, celebration, the Plus badge, streaks. A fill, never text: on white it is too light to read (2:1). Text in the marigold family uses `marigold-ink` (5.1:1) or `on-marigold-tint` on `marigold-tint`.
- **Done** (`done`): the filled "done" tick on everyday tasks (4.1:1 against white, above the 3:1 rule for symbols).

### Neutral
- `page` for the screen behind cards; `surface` for cards, sheets and bars; `surface-subtle` for grouped areas and neutral chips; `hairline` for dividers (decorative, one weight); `control-border` (3:1) for anything you can tap or type into; `text` and `text-secondary`.
- Dark mode: `dark-page`, `dark-surface`, `dark-surface-subtle`, `dark-hairline`, and marigold becomes the main action colour (`dark-marigold` with `dark-on-marigold` text), because cocoa disappears on a dark ground.

### States
- **Success** green (`success`, tint, on-tint): given vaccines, completed bookings, "up to date". In the calm register this is the "done" colour.
- **Warning** amber-brown (`warning`, tint, on-tint): overdue doses, low stock, "waiting for you". Always with an icon and words, so it never relies on colour next to marigold.
- **Error** berry (`error`, tint, on-tint): form errors and failed actions, always with an icon and a plain sentence. Never red.
- **SOS** red (`sos`, `on-sos`, tint): emergency only.

### Named Rules
**The One Red Rule.** `sos` is the only red in the app. Discounts, badges, errors, warnings, "24×7" labels and destructive actions use berry, amber-brown, cocoa or neutral, never red, coral or orange-red.

**The Marigold Is Not Ink Rule.** Marigold fills shapes (flowers, bars, badges); it is never the colour of text on a light ground.

**The Calm Register Rule.** On Health, records, tele-vet, SOS and the portals, nothing is filled with marigold and nothing celebrates; "given" and "done" use success green.

**High contrast.** `text` becomes pure black (white in dark), `text-secondary` `#3B3127` (dark `#EDE6DC`), dividers take the control-border colour and `control-border` darkens to `#4F453A` (dark `#C9BEAE`).

## Typography

- **Titles**: Baloo 2 (English and Hindi) and Baloo Tammudu 2 (Telugu): round, friendly letters by the Indian foundry Ek Type, at 600–700.
- **Text**: Hind (English and Hindi) and Hind Guntur (Telugu) by Indian Type Foundry, made for screens, at 400 and 600.
- Noto Sans Devanagari and Noto Sans Telugu stay bundled as fallbacks. All fonts are free (SIL OFL) and bundled in `assets/fonts`; nothing loads from the internet.

### Hierarchy
- **Display** (36/44, 700): desktop page heroes only.
- **Headline** (26/34, 700): page titles on phones ("Health", "Book care"); 30/38 on wide screens.
- **Title** (21/28, 700): section titles ("Coming up", "Near you").
- **Title small** (17/23, 600): card and row titles.
- **Body large** (17/26): reading text; Easy mode's base.
- **Body** (16/24): default text.
- **Body small** (14/20): one secondary line under a title.
- **Label** (16/22, 600): buttons. **Label small** (13/18, 600): the smallest text in the app (badges, chart axes).
- **Date number** (Baloo 2, 26/28, 700): the numeral in date blocks ("13" over "Fri").

### Named Rules
**The 13 Rule.** No text is smaller than 13 px, ever, in any language or mode.

**The Indic Rule.** Hindi and Telugu run at line height 1.6 or more, are never letter-spaced and never upper-cased, and secondary text in them is 15 px (one step up), because their letters sit smaller than Latin at the same size.

**The Small Scale Rule.** Use only the steps above. Rank comes from size and weight steps in this table, never from ad-hoc sizes.

**The No Mid-Phrase Break Rule.** Keep amounts, dates, distances and names on one line: "₹750", "Fri 13 Nov", "2.1 km", "Gulmohar Vet Studio" use non-breaking spaces. A title may wrap to 2 lines, a secondary line to 2 lines, a button never wraps.

### Writing numbers
- Rupees: `₹750`, `₹3,899`, `₹1,25,000` (Indian grouping, no ".00" for whole rupees, no space after ₹).
- Dates: `Fri 13 Nov` in lists, `Friday 13 November` in sentences; add the year only when it isn't this year (`18 Nov 2025`).
- Times: `6:30 pm`, `10:00 am`; durations `30 min`; distances `1.2 km`; weights `29.0 kg`.
- Relative words once per item: "in 5 days" on the next thing due, not on every row.
- Ratings: `★ 4.8 (28)`.

## Layout

- 4 px grid. Page gutter 16 px on phones, 24 px on tablet and desktop. 16 px between cards, 12 px inside a group, 24 px between sections.
- Sizes: **phone** under 640 px (bottom navigation bar), **tablet** 640–1023 px (navigation rail), **desktop** 1024 px and up (side navigation, 256 px). Content stops at 1200 px; reading pages at 840 px; forms at 720 px.
- **Home order (phone):** greeting with first name → pet switcher → Genda band → today's tasks → next thing due → 4 quick actions → nearby clinics and offers. Desktop: Genda band and tasks in the main column (wide), next thing due, quick actions and "Near you" in the side column.
- **The Pet First Rule.** On every pet-parent screen, what the pet needs now comes before anything that sells.
- Layouts must survive 200% text: rows grow taller, never clip; side-by-side becomes stacked.

## Elevation & Depth

- Light: cards float on the warm-grey page with a soft warm two-layer shadow (1 px at 6%, 18 px at 7%, tinted cocoa), no border.
- Dark: shadows don't read on dark grounds, so cards get a 1 px `dark-hairline` edge instead.
- Sheets, dialogs and menus use the stronger overlay shadow. Nothing else casts a shadow; no glass, no gradients except the photo scrim.

**The One Shadow Rule.** Cards have one shadow recipe; elevation is never used to decorate.

## Shapes

- Cards and the Genda band: 22 px corners. Photos inside cards: 16 px. Sheets: 28 px top corners. Inputs: 16 px. Buttons, chips, the SOS button, badges and the navigation indicator: fully round (pill).
- Pet avatars are circles; in the pet switcher they sit inside the chip.
- Icons: Material icons, 24 px: outlined when idle, filled (rounded) when selected or for emphasis; one set per screen, never mixed with another icon family.

## Components

### Navigation and top bar
- **Phone:** Material navigation bar with the 5 tabs (Home, Health, Book, Shop, Me), labels always visible, the selected tab marked by a cocoa pill with a white icon (marigold pill, dark icon, in dark mode). Top bar on the main tabs: logo, messages, notifications, then the SOS button at the far end; the pet pills below.
- **Tablet:** navigation rail with icons and labels; top bar as on desktop.
- **Desktop:** side navigation (the navigation rail extended to 256 px) with the logo and the 5 tabs, labels on one line. Top bar: pet switcher on the left; messages, notifications and SOS on the right (they are not repeated in the side navigation).
- **Portals and admin:** the same side navigation with the partner's sections and count badges; on phones a bottom bar with Today, Calendar, Requests, Chat and More. Top bar names the business and role, with a "Demo" tag.
- The navigation is visible on the five tabs and the screens inside them. Screens opened from elsewhere (pet profile, messages, SOS…) currently open on their own with a back arrow; keeping the navigation on them too would change how the app's navigation works, so it is listed as a suggestion for the owner.

### Buttons
- **The One Main Action Rule.** One filled cocoa button per screen (marigold in dark). Other actions are outlined or text buttons.
- Height 48 px (56 px in Easy mode), pill-shaped, label never wraps. Side-by-side buttons share the width equally; on phones under 360 px wide, they stack at full width.
- Destructive actions (cancel booking, delete) are outlined berry with a confirmation.

### Cards
- White, 22 px corners, soft shadow, 16 px padding. A card holds one subject. Card titles use Title small; a "See all" text button may sit on the right of a section title, never inside every card.

### List rows
- At least 64 px tall (76 px in Easy mode). Leading: time, date block, avatar or icon (one of them). Middle: a title and at most one secondary line. Trailing: one check, chevron, or chip.
- **The One Chip Rule.** At most one chip or badge per row. If a row has a date block, it doesn't also say "Due soon".
- Rows inside a card are separated by one hairline.

### Date blocks
- A 56 px rounded square in `surface-subtle`: weekday on top (label small), the day number below (date number style). Every scheduled thing (vaccine, dose, booking) leads with one, in the same position.

### Chips and badges
- **Pet chips:** 40 px, avatar plus name; selected = text-coloured fill with white text and a marigold ring on the avatar; "+" chip to add a pet.
- **Filter chips:** outlined, selected = cocoa tint with cocoa text and a check icon.
- **Status chips:** 28 px, tint background with its on-tint text and an icon: Confirmed (success), Waiting for you (warning), Cancelled (neutral). Never red.
- **Count badges:** cocoa circle with white numbers (13 px), on the icon's top-right.

### Inputs and forms
- Label above the field (label style, text colour), field 52 px tall, 16 px corners, `control-border` 1 px; focus: 2 px `focus` ring; error: berry border, error icon and one plain sentence below.
- Forms are one column, at most 720 px wide, with the main button at the end (sticky at the bottom on phones for long forms).

### Sheets and dialogs
- Bottom sheets on phones (28 px top corners, a drag handle, max 640 px wide, centred on desktop). Dialogs only for decisions that must interrupt (cancel booking, demo notices). Snackbars for "Done" feedback with Undo.

### The Genda band (signature)
- On Home only (warm register). Band colour, 22 px corners, 18 px padding: the pet's photo (88 px) inside a garland (140 px ring) with one marigold flower per task today (open outline = to do, filled = done), small marigold beads between them; next to it the date, "<Pet>'s day" (Title, on-band) and "2 of 4 done", with a marigold progress bar.
- With more than 8 tasks, the garland shows 8 flowers and the count carries the rest. With no tasks, it shows the full garland closed and "Nothing planned today — add a routine".
- When the last task is done, the flowers bloom once (300 ms, skipped with reduce motion) and the line reads "All done for today. Good job with Bruno!".

### The SOS button
- Always in the top bar: red pill, emergency icon and "SOS", 40 px visual height inside a 48 px touch area. The SOS screen is calm register: a short title on one line ("Emergency help"), one big red "Call nearest open clinic" action, then first-aid steps.

### Photos and drawings
- Photos (the 28 demo photos and user photos) for pets, clinics, providers and products; 16 px corners in cards, circles for avatars; a dark scrim only behind text laid on a photo.
- Simple line drawings (cocoa lines with one marigold accent) only for empty states, onboarding and errors. No copyrighted characters, logos or watermarked stock.
- Product pictures without a photo show a calm category drawing on `surface-subtle`, never a loud placeholder.

### States
- **Loading:** skeleton shapes in `surface-subtle` with a slow shimmer (none with reduce motion), matching the layout that will appear.
- **Empty:** a small drawing, one sentence that says what will appear here, and one action ("Add Bruno's first vaccine").
- **Error:** one plain sentence of what happened and what to do ("We couldn't load Bruno's health. Check your internet and try again.") with a "Try again" button. No codes.
- **Offline:** a slim banner at the top; cached content stays readable.

### Easy mode
- Base text 19 px, buttons and rows 56 px (rows 76 px), quick actions in a 2×2 grid, Home shows only the Genda band, today's tasks, the next thing due and the 4 quick actions; every icon has a visible label. Like Google Pay: big, clear, one thing at a time.

### Motion
- 200–300 ms, ease-out (`Cubic(0.16, 1, 0.3, 1)` for entering, standard curve for leaving). Ticking a task fills the check and its garland flower (250 ms). The pet photo moves with a hero animation from Home to the pet's profile. With reduce motion: cross-fades or instant changes only.

## Do's and Don'ts

### Do:
- **Do** lead every pet-parent screen with the selected pet and what it needs now.
- **Do** use the calm register on Health, records, tele-vet, SOS and portals.
- **Do** show prices up front in one place: "₹750 consultation"; show a discount once ("₹3,899, 13% off ₹4,499").
- **Do** write buttons as the action: "Book for Bruno", "Mark as given", "Try again".
- **Do** check every new colour pair: text 4.5:1, borders, icons and focus 3:1, in light, dark and high contrast.

### Don't:
- **Don't** use red, coral or orange-red anywhere but SOS.
- **Don't** use marigold as text, or fill anything with marigold on health, records, SOS or portals.
- **Don't** letter-space or upper-case Hindi or Telugu.
- **Don't** put more than one chip or badge on a row, repeat a label on every row, or show the same link twice on a screen.
- **Don't** set text under 13 px, break a phrase across lines, or let a button label wrap.
- **Don't** add loud promo banners; offers sit below the pet's day, in a normal card.
- **Don't** hard-code colours, sizes, corners, shadows or fonts in screens: they come from `lib/core/theme/tokens.dart`. Printed pages and drawn artwork keep their own values, as the token check allows.
