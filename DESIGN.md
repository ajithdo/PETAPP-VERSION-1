---
name: PawSetu — UI Design 6 "Toran"
description: Each pet stands in an arched doorway under a marigold garland that fills as the day gets done. Kaapi brown, malai paper and genda marigold.
colors:
  kaapi: "#2F1D14"
  ink: "#2B1A12"
  ink-2: "#66554A"
  paper: "#FBF7F1"
  paper-2: "#F4ECE0"
  surface: "#FFFFFF"
  line: "#EADFD0"
  control-border: "#8C7A6A"
  focus: "#B26F00"
  genda: "#F8A80C"
  on-genda: "#2B1A12"
  genda-ink: "#8A4F00"
  genda-wash: "#FDEFCC"
  on-genda-wash: "#744000"
  on-band: "#FBF2E3"
  on-band-muted: "#D7C3AC"
  aam-patta: "#2C6A43"
  aam-patta-wash: "#DDEDDD"
  warning: "#8A4B00"
  error: "#B4201B"
  error-wash: "#FCE4E0"
  kumkum-sos: "#DC2626"
  on-sos: "#FFFFFF"
  dark-paper: "#17100C"
  dark-surface: "#241A13"
  dark-paper-2: "#2E2219"
  dark-line: "#3A2C21"
  dark-ink: "#F8EFDF"
  dark-ink-2: "#CDBBA6"
  dark-band: "#2C1E15"
  dark-genda: "#FBB431"
  dark-genda-ink: "#FCC864"
  dark-aam-patta: "#8AD0A0"
  dark-error: "#FF9285"
typography:
  display:
    fontFamily: "Bricolage Grotesque (display cut), Noto Sans Devanagari, Noto Sans Telugu"
    fontSize: "40px desktop, 34px phone"
    fontWeight: 800
    lineHeight: 1.05
    letterSpacing: "-0.5px (English only)"
  headline:
    fontFamily: "Bricolage Grotesque (display cut)"
    fontSize: "26px"
    fontWeight: 800
    lineHeight: 1.12
  title:
    fontFamily: "Bricolage Grotesque (display cut)"
    fontSize: "21px"
    fontWeight: 700
    lineHeight: 1.2
  title-small:
    fontFamily: "Bricolage Grotesque (display cut)"
    fontSize: "17px"
    fontWeight: 600
    lineHeight: 1.3
  body:
    fontFamily: "Bricolage Grotesque (text cut), Noto Sans Devanagari, Noto Sans Telugu"
    fontSize: "15px (16px for long reading)"
    fontWeight: 400
    lineHeight: 1.47
  body-small:
    fontFamily: "Bricolage Grotesque (text cut)"
    fontSize: "13px"
    fontWeight: 400
    lineHeight: 1.38
  label:
    fontFamily: "Bricolage Grotesque (text cut)"
    fontSize: "15px"
    fontWeight: 600
  label-small:
    fontFamily: "Bricolage Grotesque (text cut)"
    fontSize: "12px"
    fontWeight: 600
rounded:
  card: "22px"
  hero: "28px"
  button: "999px"
  tag: "8px"
  input: "16px"
  arch: "half circle on top, 18% of the width at the feet"
---

# Design System: PawSetu — UI Design 6 "Toran"

UI Design 6 replaces UI Design 5 "Genda" (8 Nov 2026). UI Design 5 stays saved
as a backup (see `UI_REVAMP.md` and `docs/PROGRESS.md`, "Names"). The approved
design boards are in `docs/design-proposals/2026-11-10-toran-redesign/`.

## Overview

**A toran is the marigold garland hung over a doorway.** In PawSetu each pet stands in an arched doorway, and a garland hangs over it with one marigold per task today. Finish a task and a flower opens; a full garland is a good day. Everything else is quiet and warm: kaapi-brown ink on malai paper, white cards, plain words.

Three rules hold the system together:

- **A shape for everything.** Pets are always in arches, people in circles, places and things in rounded tiles. You know what something is before you read it.
- **Colour means something.** Kaapi brown for dark surfaces (Home's band, the health pass, the medical card, navigation); marigold for the one main action and for flowers; mango-leaf green for "done" and "open"; red only for SOS and danger.
- **One voice in three scripts.** Bricolage Grotesque for English, with Noto Sans for Hindi and Telugu letters. Big, tight headings; quiet, readable text.

## Colors

The frontmatter is normative. Every value lives in `lib/core/theme/tokens.dart` (`PawColors.light` / `PawColors.dark`), and every text and background pair is checked by `test/core/contrast_test.dart` (text 4.5:1, borders, icons and focus 3:1) in light, dark and high contrast.

- **Kaapi** (`kaapi`, the band): Home's doorway band, the health pass, the medical card, the floating dock and the side menu. Text on it is `on-band` (14:1) and `on-band-muted` (9:1).
- **Ink** (`ink`): text, the selected pet pill, chosen filter chips, the dark strip of date leaves.
- **Paper** (`paper`) behind everything, **surface** white cards, **paper-2** for grouped areas, tonal buttons and the round top-bar buttons.
- **Genda** (`genda`, marigold): the one main action on a screen (filled buttons with ink text, 8.4:1), the current tab's pill, open marigolds, progress, the Plus card. Text in the marigold family uses `genda-ink` (6:1) or `on-genda-wash` on `genda-wash`.
- **Aam patta** (`aam-patta`, mango-leaf green): done, given, open now, switches that are on.
- **Kumkum** (`kumkum-sos`): SOS, the call button on the SOS page, allergies on the medical card, overdue date leaves. Errors use a darker red (`error`) with an icon and words.
- **Dark mode:** coffee-black paper (`dark-paper`) so marigold still glows and SOS still shouts; the main action stays marigold.
- **Drawn things** keep fixed colours in both themes: the garland (`GarlandColors`), drawn product packs (`PackColors`), the map preview (`MapColors`).

## Typography

- **Bricolage Grotesque** (SIL OFL), cut from the variable font into two static families in `assets/fonts`:
  - `Bricolage` (text cut: full width, optical size 14) in 400, 500, 600, 700 for text, labels and buttons.
  - `BricolageDisplay` (display cut: width 79–90 %, optical size 18–36) in 600, 700, 800 for titles.
- **Hindi and Telugu** letters come from Noto Sans Devanagari and Noto Sans Telugu (fallback fonts, already bundled), so mixed text like "Simba రోజు" keeps the Latin name in Bricolage.
- Numbers line up in columns where it matters (times, IDs, doses) with tabular figures.
- Scale (matched to the design boards on 15 Nov 2026): display 40/34, headline 30/26/24, title 21, title small 17, page title in the top bar 19, body 15 (16 for long reading), body small 13, label 15, label small 12, the dock's tab names 11. Only the dock names, tag text and the small dates on a date leaf go under 13 px; with Easy mode or bigger text they grow like everything else.
- **The Indic Rule.** Hindi and Telugu titles are 12 % smaller with line height 1.42; text uses line height 1.6; never letter-spaced or upper-cased; small text one step up.

## Layout

- 4 px grid; page gutter 16 px on phones, 24 px wider. Content stops at 1200 px.
- **Phone:** a floating dark dock with the 5 tabs at the bottom (marigold pill on the current tab), also on the pages inside a tab (a pet's profile, a clinic, the cart), so you can always jump to another tab. Full-screen flows (SOS, a video call, a walk being tracked, sign-up, adding a pet) hide it. **Tablet:** a dark rail. **Desktop:** a dark side menu with the logo, the 5 tabs and the signed-in person at the bottom.
- Top bar on the main tabs: the PawSetu mark, messages, notifications and SOS; the pet pills below (on desktop, the pet pills on the left of the top bar).
- **Home:** greeting → the doorway band (toran) → Today checklist → Next up → quick actions → nearby and tips. Desktop: band, checklist and tips on the left; next up, quick actions and nearby on the right; the band shows "Next: walk" with a Log button.
- **Book:** vet clinic and tele-vet as two big cards, then grooming, training, boarding and walking as quieter rows; my bookings; the clinic map card.
- **Me:** profile with pets in arches → everyday features as tiles (vault, album, lost pet, devices) → family → orders and money → app and support.

## Icons

Phosphor icons (MIT licence), bundled as two fonts: `Phosphor` (regular, for buttons, rows and the top bar) and `PhosphorFill` (filled, for tags, the current tab and small status marks). Every icon is a constant in `lib/core/theme/ph.dart` (`Ph.bell`, `Ph.bellFill`), made by `tools/icons/gen.py`; to add one, put its Phosphor name in `EXTRA` in `tools/icons/map.py` and run the script.

## Shapes

- **Arches** for pets (`PetAvatar`, `archShape`): a half circle on top, height = width × 1.24, the pet's colour tag as the edge. Everywhere a pet appears.
- **Circles** for people (initials), round top-bar buttons, quick-action circles and category circles.
- **Rounded tiles** for places, things and features (`radius = 30 % of the size`).
- Cards 22 px, hero panels 28 px, tags 8 px, inputs 16 px, buttons and pills fully round.

## Components

- **The toran band** (`GendaBand`, `Garland`): kaapi panel, the pet in its arch with faint doorway outlines behind, the garland of open marigolds and buds, "Bruno's day", "2 of 5 done" (the count big and marigold) and the streak tag.
- **Task tick** (`TaskTick`): empty ring → ring filling with marigold → a full marigold when done (opens in 250 ms, instant with reduce motion).
- **Date leaf** (`DateBadge`): a tear-off calendar leaf, month on a strip (ink; marigold when due soon; red when overdue), day below.
- **Buttons** (`PawButton`, `RoundButton`): filled marigold with ink text (one per screen); ink; outlined with an ink edge; tonal paper-2; text links are ink with a marigold underline (`TextLink`). Small buttons and round buttons are 36–44 px to look at, but always have a 48 px touch area.
- **Lists and panels** (`PawPanel`, `PawList`, `PawItem`, `Wash`, `KvList`): quiet panels with a hairline edge hold rows of a tile, a title, a grey line and a chevron; washes are tinted panels without an edge (gold, green, sky); key–value lists line labels up in one column (or, for a bill, values at the far end).
- **Switches between a few choices** (`SegText`, `SegIcons`): a paper pill with the chosen part white and lifted (list or map, monthly or yearly, by day, week or month).
- **People** (`PersonDot`): initials in a circle, marigold for the first in a list.
- **Number tiles** (`StatTile`): a small label with its icon, a big number, and one quiet line under it (portals and admin).
- **Tags** (`PawTag`, `StatusChip`): 8 px corners, a filled icon, tint and readable text, one per row.
- **Pass card** (`PassCard`): kaapi panel; up to three facts side by side between hairlines; a red allergy band on the medical card; a marigold "needs attention" tag; the main button cream, the second outlined.
- **Quick actions** (`QuickActionTile`): a tinted circle and a short label; in Easy mode a white card with the circle beside the label.
- **Drawn products** (`PackShot`): bags, cans, pouches, toys, beds, harnesses, bottles and bowls on a pale tint, for products without a photo. Never brand logos.
- **Map preview** (`MapSketch`): a drawn map with clinic pins where a picture invites a tap; the real OpenStreetMap opens behind it.
- **Plus card:** a marigold membership card with faint rings; the Plus column of the comparison sits on a marigold wash.
- **SOS:** the red call card glows; each option has a round icon badge and a big title. SOS needs a 2-second hold, or a tap and "Get help?" with Easy mode or the "Tap to confirm SOS" setting.
- **Pictures in the demo** are the design's own drawings (pets, album scenes and shopfronts in `assets/images/demo/`, made from the design boards by `tools/drawings/render.cjs`). Photos people add show as photos.

## Easy mode

Text 25 % bigger, buttons and rows taller, the band stacks (text over the doorway), quick actions become a 2 × 2 grid of cards, Book's tiles go one per row, buttons move under the words where a row would get too tight, SOS asks on a tap instead of a hold, and a full-width SOS button sits on Home.

## Motion

200–300 ms ease-out. Ticking a task opens its marigold (250 ms) and its flower on the garland. The pet's photo moves from Home to its profile. With reduce motion: instant changes only.

## Do's and Don'ts

- **Do** put every pet in an arch, every person in a circle, every place or thing in a tile.
- **Do** keep one marigold button per screen; everything else outlined, tonal or a link.
- **Do** use red only for SOS, danger and allergies.
- **Do** check every new colour pair in `test/core/contrast_test.dart`.
- **Don't** hard-code colours, sizes or fonts in screens: they come from `lib/core/theme/tokens.dart`.
- **Don't** letter-space or upper-case Hindi or Telugu, or set text under 13 px.
- **Don't** use brand logos or copyrighted characters in drawings.
