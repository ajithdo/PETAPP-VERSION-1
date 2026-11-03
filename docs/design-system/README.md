# PawSetu design system

**Status (3 Nov 2026):** a reference written from the current app, plus proposed changes in `5-changes.md` that are not in the app until the owner approves them. Until then, section 4 of `docs/PROJECT_SPEC.md` and `lib/core/theme/` stay the rules for code.

- `framer-prompt.md`: a prompt to paste into Framer AI
- `tokens.json`: every colour (light, dark, high contrast), type style, spacing, radius, shadow and size
- `1-product.md` to `5-changes.md`: product and audience, typography, spacing matrix, contrast checks, proposed changes
- `assets/`: logo SVGs (wordmark outlined from Plus Jakarta Sans Bold), and the app's illustrations and pet faces rendered to PNG from `lib/core/widgets/illustrations.dart`

---

PawSetu is one app for everything about looking after a pet in India: daily routines, health records, vet and grooming bookings, online vet chats, a pet shop, a document safe and emergency SOS. It is used in English, Hindi and Telugu, on phones, tablets and the web. This system describes the look the app already has (teal and apricot, Plus Jakarta Sans, soft cards) and adds what was missing: full colour ramps, a type scale for three scripts, a spacing matrix and component rules. The few places where it changes today's app are listed in **Changes from today's app**; nothing there is in the app until the owner approves it.

## Principles

1. **Calm before clever.** The page is `background`, cards are `surface`, text is `text-primary`. Colour is spent on meaning: the main action, a status, a celebration, an emergency.
2. **One clear main action per screen.** Exactly one `Button` in the primary style per view. Everything else is secondary, tonal or text.
3. **Clinical when it matters.** Health, vault and tele-vet screens use teal, neutrals and status colours only. No apricot, no playful illustration, no celebration.
4. **Warmth in small doses.** Apricot (`accent`) marks streaks, birthdays, deals and the hero pet card. If more than one apricot area is on screen, remove one.
5. **Three scripts are equal.** Every layout must hold Hindi and Telugu text, which runs up to four times longer than English ("Add pet" is "పెంపుడు జంతువును జోడించండి"). Text wraps; it is never cut with "…" when it carries meaning.
6. **Easy mode is a real layout, not a zoom.** Bigger targets (`touch-easy`), 25% larger text, a simpler Home and a confirm step before anything destructive.

## Zones: one app, five moods

The app's personality changes with what the person is doing. Each screen belongs to one zone.

| Zone | Screens | Colour | Density | Words |
|---|---|---|---|---|
| Everyday | Home, routine, album, pet profile | `primary` plus one `accent` area; pet tag colours on avatars | Comfortable: `space-lg` card padding, `space-md` between cards | Warm, uses the pet's name: "Bruno's day" |
| Health | Health tab, vaccines, medicines, vault, medical card, tele-vet | `primary`, neutrals, `success` / `warning` / `error` chips. No `accent` | Comfortable; facts in `body`, never `caption` | Precise and calm: "Due in 10 days", "Indicative, always confirm with your vet" |
| Emergency | SOS sheet, first aid, lost pet | `sos` header, `error-container` option cards, `text-primary` on `surface` | Spacious: `touch-easy` targets for everyone, two big options | Short imperatives: "Call nearest clinic" |
| Shop | Shop, product, cart, orders | `primary` for Add to cart and Pay; `accent` for deal banners; `success` for "13% off" and "You save" | Grid of `ProductCard` | Plain prices: "₹3,899 ~~₹4,499~~" |
| Workspace | Partner portal, seller portal, admin | `primary` and neutrals; status chips | Dense: tables with 48 px rows, `SideNav` always open on desktop | Neutral and exact: "2 requests waiting" |

## Voice and words

- Talk like a friendly clinic receptionist: short, plain, kind. Use the pet's name: "Bruno's next vaccine is due in 3 days."
- Sentence case everywhere ("Book vet", not "Book Vet"). Buttons start with a verb: "Confirm booking", "Add photo", "Try again".
- Errors say what happened and what to do: "Payment failed. Your cart is saved; please try again." Never "Oops" or error codes.
- Exclamation marks only in celebrations: "Happy birthday, Bruno!", "All done for today. Good job with Bruno!"
- Medical screens carry "Indicative, always confirm with your vet" in an `InfoNote`.
- Demo mode is always labelled: "Demo: this would call +91 90000 00012."
- No emoji in the interface. Icons do that job.
- India formats: ₹ with Indian grouping (₹1,24,999), 13 Oct 2026, 8:05 PM, km, kg (grams for birds), +91 numbers.
- Hindi and Telugu are written naturally, not word for word. Keep familiar English loan words where people use them ("हेल्थ रिपोर्ट", "మెడికల్ కార్డ్").

## Colour

- **Two brand hues.** Teal (`teal-*`) is trust and action; apricot (`apricot-*`) is warmth. Teal leads; apricot never covers more of a screen than teal.
- **Sand is the paper, ink is what you read and touch.** Warm `sand-*` greys make the page and cards (`background`, `surface`, `surface-low`…); cool `ink-*` greys are text, icons and control borders.
- **Main action:** `primary` fill with `on-primary` text. Links and text buttons: `primary` on `background` or `surface`.
- **Selected things** (nav item, chip, segmented option): `primary-container` with `on-primary-container`.
- **Apricot rules.** `accent` is a fill only; text on it is `on-accent`, never white (white on apricot is 2.1:1). For apricot-coloured words use `accent-text`. Warm tonal buttons (`accent-container`) belong to Shop and celebrations only; in Health use teal tonal.
- **Status** always pairs a colour with a word or icon: `success` (Done, Paid), `warning` (Due soon, Pending), `error` (Overdue, Failed). Chips use the matching `*-container` behind the coloured text.
- **SOS red** (`sos`, `on-sos`) is for emergencies only. Destructive buttons use `danger`, which is a different token even where the value matches.
- **Pet colour tags** (`pet-amber`, `pet-lavender`, `pet-sky`, `pet-rose`, `pet-mint`, `pet-sand`) mark which pet something belongs to: avatar rings, switcher dots, chart lines. They are never text, never a status and never a large fill.
- **Borders.** `outline` is a decorative hairline (dividers, card edges in dark mode). Anything someone operates (text field, outlined button, checkbox, unselected chip) uses `outline-strong`, which meets 3:1.
- **Dark mode** is tonal: cards are `surface` with a 1 px `outline` instead of a shadow. Do not invert apricot or teal by hand; use the tokens, which already swap.
- **High contrast** (Settings → Accessibility) uses the `light-hc` and `dark-hc` themes: black or white text, stronger outlines, no shadows.

## Typography

- One family per script, all bundled with the app: **Plus Jakarta Sans** (English), **Noto Sans Devanagari** (Hindi), **Noto Sans Telugu** (Telugu). Weights 400, 500, 600 and 700 only.
- Use the styles in the Typography view: `hero`, `display`, `headline`, `title`, `heading`, `body`, `body-strong`, `label`, `support`, `label-sm`, `caption`, `micro`. Hindi and Telugu use the `hi-` and `te-` versions: same sizes, taller lines, no letter-spacing.
- Anything a person needs to act on is `body` (16) or `support` (14). `caption` (13) is for timestamps and credits; `micro` (12) is for badge numbers only.
- Numbers that line up or change (prices in lists, timers, weights, counters) use tabular figures (`font-feature-settings: "tnum"`; Flutter `FontFeature.tabularFigures()`).
- At most two weights in one card: usually 700 or 600 for the title and 400 for the rest.
- Details and the measured reasons are in **Typography in three scripts**.

## Spacing and layout

- Everything sits on a 4 px grid: `space-xs` 4, `space-sm` 8, `space-md` 12, `space-lg` 16, `space-xl` 24, `space-xxl` 32, plus `space-xxs`, `space-3xl` and `space-4xl`.
- Screen gutter is `space-lg` on phones and `space-xl` from `bp-tablet` up. Cards in a list are `space-md` apart; a section header has `space-xl` above it and `space-sm` below.
- Pages use one of three widths: `width-narrow` (forms and steps), `width-reading` (detail pages, chat) or `width-max` (Home, grids, dashboards), centred.
- Navigation follows the screen: `BottomNav` under 640 px, `SideNav` in rail form from 640 px, full `SideNav` from 1024 px.
- The full table for every size and for Easy mode is in **Spacing matrix**.

## Shape and depth

- Corners: `radius-card` (20) for cards and dialogs, `radius-button` (14) for buttons, fields and notes, `radius-sheet` (28) for bottom-sheet tops, `radius-pill` for chips, `radius-inner` (12) for photos inset in a card, `radius-sm` (8) for small thumbnails.
- Nested corners shrink: an element inset by 8 px inside a 20 px card uses 12 px.
- Depth in light mode: `shadow-card` for cards, `shadow-raised` for things floating over content, `shadow-overlay` for sheets and dialogs. Dark and high-contrast themes replace shadows with `surface` steps and an `outline`.

## Motion

- Default `duration-fast` to `duration-slow` (200 to 300 ms) with `easing-out`. Pet photos fly between the pet card and the profile (a hero transition).
- Celebrate real progress, once: ticking the last checklist item, recording a vaccine, a streak milestone. Use `duration-celebrate` (a check burst and a ring pulse in `accent`) and a light haptic. Never on errors, never in Health's clinical screens, never looping.
- When the system asks to reduce motion, everything snaps and skeletons stop pulsing.
- The SOS ring fills over `duration-sos-hold` (2 s) with haptic ticks; this one is not removed by reduce motion, because the fill is the feedback.

## Iconography

- Material Symbols **Rounded**, outlined at 24 px for inactive and filled for selected nav items. In code these are Flutter's built-in `Icons.*_rounded` (same family).
- 20 px inside buttons and chips, 24 px in bars and rows, 26 px in quick-action tiles, 56 px for error states.
- Icon colour is `text-secondary` in rows, `primary` when it signals the action, status colour inside status chips. Icon-only buttons always have a spoken label.
- Domain icons: vaccines (vaccines), medicines (medication), walk (directions_walk), meal (restaurant), play (sports_baseball), clinic (local_hospital), SOS (text "SOS", never an icon).

## Illustration and imagery

- One original illustration style (`lib/core/widgets/illustrations.dart`): soft, flat, rounded shapes in teal and apricot. Only for onboarding, empty states and success screens.
- Pets without a photo get an illustrated face in their tag colour inside a `pet-*` ring.
- Product and clinic images without a photo use `apricot-200` / `teal-100` tinted placeholders with a simple icon, never stock photos or real brand logos.
- Sample documents are stamped "SAMPLE".

## States

- **Empty:** illustration, one `heading` line, one `support` line, one primary button. "You're all caught up."
- **Loading:** skeleton blocks in `surface-container` with `radius-card`, pulsing unless reduce motion is on. No spinners for whole pages.
- **Error:** "Something went wrong", a plain reason, and a secondary "Try again" button.
- **Offline:** a slim strip under the top bar; readable data stays on screen.
- **Demo:** `DemoBanner` in `accent-container` with a flask icon.

## Accessibility and Easy mode

- Every target is at least `touch-min` (48 px); in Easy mode `touch-easy` (56 px). Layouts must hold at 200% text size without overlap or cut text.
- Keyboard focus: a 2 px `focus-ring` with a 2 px gap in the background colour.
- Every text token in this system passes WCAG AA (4.5:1) in light and dark, and 7:1 in the high-contrast themes; see **Contrast checks**.
- Easy mode: text +25%, `touch-easy` buttons, `list-row` 64 px, a Home with only Today, Next due, 4 quick actions and SOS; no swipe-only actions; a confirm dialog before deleting; SOS opens on tap with a confirm.

## In code

Tokens live in `lib/core/theme/tokens.dart` (`PawColors`, `PetTagColors`, `Space`, `Radii`) and the Material 3 theme in `lib/core/theme/app_theme.dart`. Shared widgets are in `lib/core/widgets/`: `PrimaryButton`, `SecondaryButton`, `QuickActionTile`, `SosButton`, `PawTextField`, `ChoiceRow`, `PawCard`, `StatusChip`, `StatTile`, `InfoNote`, `DemoBanner`, `PetAvatar`, `ProgressRing`, `EmptyState`, `ErrorState`, `Skeleton`. Build every screen from these; no one-off colours, sizes or radii in feature code.
