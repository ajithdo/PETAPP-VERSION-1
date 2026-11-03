---
version: 1.0-proposal
name: PawSetu — Warm Clinical Trust
status: proposal for review (not applied to the app yet)
description: >-
  A calm, editorial, high-trust system for Indian pet parents. Warm alabaster
  canvas, white raised surfaces with a 1px warm border and a soft ambient
  shadow, one terracotta coral voice for booking and active states, and a deep
  forest teal reserved for medical trust (verified vets, vaccination status,
  health records). Plus Jakarta Sans carries headings, DM Sans carries the
  interface, JetBrains Mono carries times, dates, doses and IDs.

colors:
  light:
    canvas: "#FAF8F5"        # Warm Alabaster: page background
    surface: "#FFFFFF"       # cards, sheets, inputs
    sand: "#F3EFEA"          # secondary containers, chips at rest, table bands
    line: "#E7E2DA"          # 1px warm border on every raised surface
    ink: "#23201C"           # primary text (15.3:1 on canvas)
    ink-2: "#6B645B"         # secondary text (5.5:1 on canvas, 5.1:1 on sand)
    coral: "#E05A47"         # brand coral: active pills, selected outlines, map pin, focus ring
    coral-cta: "#C4452F"     # filled booking buttons with white label (4.95:1)
    coral-cta-hover: "#B03C28"
    coral-text: "#B03C28"    # coral words on light surfaces (5.2:1 on sand)
    coral-tint: "#FCEBE7"    # selected chip / slot background
    teal: "#1F4E46"          # Deep Forest Teal: verified, vaccinated, records (9.4:1 on white)
    sage: "#E6F0ED"          # Soft Sage: trust containers (teal text 8.1:1)
    amber: "#D97706"         # upcoming reminders: icons and dots only
    amber-text: "#92400E"    # amber words, always on amber-tint
    amber-tint: "#FDF1DF"
    emerald: "#15803D"       # completed vaccinations (5.0:1 on white)
    emerald-text: "#166534"  # on emerald-tint (6.3:1)
    emerald-tint: "#E7F4EC"
    crimson: "#DC2626"       # emergency care and SOS; white text 4.83:1
    crimson-text: "#B91C1C"  # on crimson-tint (5.7:1)
    crimson-tint: "#FDECEC"
  dark:
    canvas: "#121316"        # warm charcoal, never #000000
    surface: "#1B1C20"
    sand: "#26272C"
    line: "#303238"
    ink: "#F2EEE8"           # 14.7:1 on surface
    ink-2: "#ABA59C"         # 7.0:1 on surface
    coral: "#F07A66"
    coral-cta: "#EE6E5A"     # filled button, label #1A0C08 (6.4:1)
    coral-cta-hover: "#F4826F"
    coral-text: "#F08A78"
    coral-tint: "#3A1E19"
    teal: "#8FD1C1"
    sage: "#173A33"
    amber: "#F5B041"
    amber-text: "#F5C070"
    amber-tint: "#3A2A12"
    emerald: "#5BD68A"
    emerald-text: "#86E0A6"
    emerald-tint: "#15301F"
    crimson: "#DC2626"       # SOS stays the same red in both modes, white text
    crimson-text: "#FCA5A5"
    crimson-tint: "#3A1717"
  pet-tags:                  # unchanged from spec section 4, used only for pet identity rings
    amber: "#F4A261"
    lavender: "#9B8AFB"
    sky: "#38BDF8"
    rose: "#F472B6"
    mint: "#34D399"
    sand: "#D6B98C"

typography:
  families:
    display: "'Plus Jakarta Sans', 'Noto Sans Devanagari', 'Noto Sans Telugu', system-ui, sans-serif"
    body: "'DM Sans', 'Noto Sans Devanagari', 'Noto Sans Telugu', system-ui, sans-serif"
    mono: "'JetBrains Mono', ui-monospace, 'SFMono-Regular', Menlo, monospace"
  scale:                     # size / line height / weight / tracking
    display: [32px, 1.15, 700, -0.02em]   # one per screen at most
    title:   [24px, 1.2,  700, -0.02em]   # screen titles
    heading: [20px, 1.25, 600, -0.015em]  # section heads
    subhead: [17px, 1.35, 600, -0.01em]   # card titles, clinic names
    body:    [16px, 1.5,  400, 0]
    body-sm: [14px, 1.45, 400, 0]
    label:   [14px, 1.3,  500, 0]         # buttons, chips, nav
    caption: [13px, 1.4,  500, 0]         # never below 13px
    mono:    [14px, 1.3,  500, 0]         # times, dates, doses, microchip and registration numbers; tabular figures
  indic:
    line-height: 1.6         # Hindi and Telugu
    tracking: 0              # never negative tracking on Devanagari or Telugu
    families: "Noto Sans Devanagari (hi), Noto Sans Telugu (te), loaded only for that language"

spacing: [4, 8, 12, 16, 20, 24, 32, 40, 48, 64]   # 4px base, 8px rhythm
gutter: { phone: 16px, tablet: 24px, desktop: 32px }
container: 1200px

radius:
  xs: 8px        # tags inside cards, slot pills on phone
  input: 12px    # inputs, chips, slot pills
  card: 16px     # list cards, clinic cards
  panel: 20px    # hero panels, pet passcard, sheets
  pill: 9999px   # category pills, badges, nav indicator

elevation:
  raised:  "1px solid line + 0 4px 20px -2px rgba(24, 24, 27, 0.05)"
  floating: "1px solid line + 0 12px 32px -8px rgba(24, 24, 27, 0.14)"   # bottom nav, sticky booking bar, menus
  dark: "1px solid line, no shadow; floating layers step up to the next surface tone"

motion:
  press: 120ms
  state: 200ms
  sheet: 280ms
  easing: "cubic-bezier(0.2, 0.8, 0.2, 1)"      # ease-out, never overshoots
  reduced-motion: "state changes are instant; the confirmation tick appears without drawing"

breakpoints:
  compact: "< 768px: floating bottom navigation, sticky location header"
  medium: "768–1199px: 80px navigation rail, two-column grids"
  expanded: ">= 1200px: 248px sidebar, 1200px centred container, bento grids"

touch-target: { min: 48px, easy-mode: 56px }
---

# PawSetu design system

## 1. Atmosphere

Warm clinical trust, playful care. The app should feel like a good
neighbourhood clinic: daylight, clean counters, a vet who remembers your dog's
name. Calm and editorial, never busy. Colour is rare and always means
something: coral means "you can book or act here", teal means "a vet or a
record vouches for this", amber, emerald and crimson mean "upcoming",
"done" and "emergency".

## 2. Colour roles

- **Canvas, surface, sand.** The canvas is Warm Alabaster. Everything you can
  touch sits on a white surface with a 1px warm border (`line`) and the soft
  ambient shadow. Sand is for secondary containers: resting chips, the date
  strip, grouped rows. Never put a card inside a card; use sand inside white.
- **Coral** is the only call-to-action colour. One filled coral button per
  screen (Book visit, Confirm booking). Active nav pills and selected chips
  use the coral tint with coral text, not a solid fill.
  `#E05A47` with white text measures 3.67:1, below WCAG AA for button
  labels, so filled buttons use `coral-cta #C4452F` (4.95:1). `#E05A47`
  stays the brand coral for outlines, indicators, the map pin and focus rings.
- **Teal and sage** are medical trust only: verified clinic, vet council
  number checked, vaccination up to date, records and prescriptions. Never
  use teal for decoration or a generic button.
- **Status:** amber (upcoming reminder), emerald (done), crimson (emergency,
  24×7, SOS). Status is always tint background + same-hue text + an icon, so
  it never relies on colour alone. Amber text never sits on white.
- **Pet tags** stay as identity rings around pet avatars, nothing else.

## 3. Typography

- Plus Jakarta Sans 600–700 with −0.02em tracking for titles and headings;
  DM Sans 400–500 for everything you read or tap; JetBrains Mono 500 with
  tabular figures for appointment times, dates in timelines, doses
  ("2 ml, weekly"), microchip and Veterinary Council numbers.
- Minimum text size is 13px. Secondary text uses `ink-2`, never a lighter
  grey. Headings are sentence case. No uppercase tracked labels, no eyebrows
  above headings.
- Hindi and Telugu switch to Noto Sans Devanagari / Noto Sans Telugu with
  line height 1.6 and zero tracking. Layouts are checked in Telugu because
  its words run longest.

## 4. Layout

- **Phone (< 768px):** 16px gutters. A sticky header holds the location
  selector ("Indiranagar, Bengaluru") and the notification bell. A floating,
  translucent bottom bar (16px from the edges, 64px tall, 9999px radius)
  holds Home, Health, Book, Shop and Me with a coral-tint pill behind the
  active item. Content scrolls under it with 96px of bottom padding.
- **Tablet (768–1199px):** an 80px navigation rail on the left; content in
  two columns where the screen has two kinds of thing (feed + today).
- **Desktop (>= 1200px):** a 248px sidebar with the logo, the five
  destinations, the pet switcher and SOS; content in a 1200px centred
  container. Discovery and dashboards use bento grids (2/3 + 1/3, or
  three equal columns of clinic cards). Nothing stretches edge to edge.
- Every screen keeps the navigation, including pet profiles, messages and
  settings.
- Touch targets: every control has a 48px hit area (56px in Easy mode).
  Compact chips, slots and small buttons may draw at 40–44px inside it,
  using Flutter's padded tap target.

## 5. Elevation and shape

- Raised surfaces: 1px `line` border + `0 4px 20px -2px rgba(24,24,27,.05)`.
  Floating layers (bottom bar, sticky booking bar, menus): stronger shadow
  `0 12px 32px -8px rgba(24,24,27,.14)` and a translucent surface with a
  16px backdrop blur. Dark mode drops shadows and steps up surface tones.
- Radii: 12px inputs and chips, 16px cards, 20px hero panels and sheets,
  9999px pills and badges. One radius per nesting level.

## 6. Components

- **Buttons:** primary (coral-cta fill), secondary (white, 1px line, ink
  label), quiet (text only), danger (crimson). 48px tall (56px in Easy mode),
  12px radius, label 14–16px/500. States: hover darkens 6%, pressed scales to
  0.98, focus-visible shows a 2px coral ring offset 2px, disabled at 40%
  opacity with no shadow, loading keeps the label width and swaps in a small
  inline spinner.
- **Category pills:** 44px tall inside a 48px hit area, 9999px radius, icon +
  label. Resting: sand fill. Active: coral tint, coral text, 1px coral border.
  The strip scrolls sideways with snap and a fade at the edge.
- **Clinic card:** 16:9 cover (partner photo; a street map until the partner
  uploads one), floating "Open now" and "Verified" badges, a distance pill,
  name, area, rating with review count, "From ₹750", the next free slot in
  mono, and one "Book visit" button. Whole card is a link; the button books.
- **Slot pill:** 44px tall, mono time. Available: white + line. Selected:
  coral-cta fill, white text, check icon. Booked: sand fill, ink-2 text,
  strikethrough, not focusable, announced as "booked".
- **Badges:** 24px tall pills with an icon: Verified (sage/teal), Open now
  (emerald tint), Due soon (amber tint), Done (emerald tint), 24×7 and
  Emergency (crimson tint).
- **Pet passcard:** 20px radius panel on sage in light mode, with the pet's
  tag ring, breed, age, weight with its 90-day trend, microchip in mono and
  the vaccination status badge.
- **Timeline:** a 2px line on the left with status dots; upcoming items first
  (amber), then done (emerald), each row with date in mono, title, place and
  a download action for its document.

## 7. States

- **Loading:** skeletons in the final layout (same sizes, same radii) with a
  soft shimmer that stops under reduced motion. Never a spinner on a blank
  screen. Images reserve their aspect ratio before they load.
- **Empty:** keep the section frame and title, one plain sentence and one
  action ("No vet visits yet. Add a visit").
- **Error:** inside the block that failed: what failed, when data was last
  good, and "Try again". Offline keeps cached data visible with a strip.
- **Focus:** every control shows the coral focus ring on keyboard focus,
  instantly.

## 8. Motion

200ms ease-out for state changes, 280ms for sheets, 120ms for presses. No
bounce. One authored moment: the booking confirmation tick draws in 400ms.
Haptics on phones: selection click on picking a slot or pet, light impact on
confirming. Reduced motion makes everything instant.

## 9. Do and don't

- Do use the pet's name in copy ("Bruno's booster is due in 10 days").
- Do show prices before the booking button, including fees, in ₹ with Indian
  grouping (₹1,24,999).
- Don't use coral for anything that isn't an action or an active state.
- Don't use teal for anything that isn't medical trust.
- Don't use pure black, pure grey text, gradients on text, emoji as icons or
  stock photos.
- Don't put more than one filled button on a screen.

## 10. Responsive checks

Check every screen at 360, 375, 768, 1024, 1440 and 1920 px, in light and
dark, in English and Telugu, with Easy mode on and at 200% text. No
horizontal scroll at any width.
