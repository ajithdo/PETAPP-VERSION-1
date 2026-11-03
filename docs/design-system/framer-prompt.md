# Framer prompt for PawSetu

Copy everything inside the box below and paste it into Framer AI. The logo and illustrations to upload are in `docs/design-system/assets/`.

```text
Design the UI for "PawSetu", an all-in-one pet care app for India. Tagline: "Every care your pet needs, in one place." ("Setu" means bridge: the app connects pet parents, vets and pet services.) Pet parents use it to track daily routines (walks, meals, play), health (vaccines, medicines, vet visits), book vets, groomers and walkers, chat with an online vet, shop for pet food and supplies, keep documents in a locked vault, and get emergency help with an SOS button. Users are city pet parents in India, from busy young professionals to older parents who need big text. Languages: English, Hindi and Telugu.

MOOD
Calm, warm and trustworthy. Clean like Apple Health, warm like a friendly pet clinic, serious and clinical on medical screens. Never cluttered. One clear main action per screen. Warm off-white pages, white cards, dark teal-grey text, and colour only where it means something. Apricot is a small warm accent (streaks, birthdays, deals), never the main colour. Health and document screens use teal and greys only, with no apricot.

COLOURS (create as Framer color styles with Light and Dark values)
- Primary (teal): #0F766E light / #2DD4BF dark. Text on primary: #FFFFFF / #04201D
- Primary container: #CCFBF1 / #134E4A. Text on it: #053B36 / #CCFBF1
- Accent (apricot): #F4A261 / #F6BD8A. Text on accent: #3B1F06 (never white)
- Accent container: #FDE7D3 / #4A2E14. Text on it: #4A2508 / #FDE7D3
- Accent text (apricot-coloured words): #9D5126 / #F6BD8A
- Background (page): #FAF8F5 / #0E1415
- Surface (cards, sheets, inputs): #FFFFFF / #172124
- Surface low (quiet cards): #F5F2EE / #131B1D
- Outline (hairlines, dividers): #E5E1DA / #2A3639
- Outline strong (input and control borders): #798A8C in both modes
- Text primary: #1C2B2D / #E8EEEE
- Text secondary: #5B6B6E / #9FB0B2
- Success: #15803D / #4ADE80, container #DCFCE7 / #052E16
- Warning: #B45309 / #FBBF24, container #FEF3C7 / #451A03
- Error: #B91C1C / #F87171, container #FEE2E2 / #450A0A
- SOS red: #DC2626 with white text, same in both modes, for emergencies only
- Pet colour tags (one per pet, used only for avatar rings and dots): #F4A261, #9B8AFB, #38BDF8, #F472B6, #34D399, #D6B98C
All text must meet WCAG AA contrast (4.5:1).

TYPOGRAPHY (Google Fonts: Plus Jakarta Sans for English; Noto Sans Devanagari for Hindi; Noto Sans Telugu for Telugu. Weights 400, 500, 600, 700 only)
- Hero: 40px, Bold, line height 48px, letter spacing -0.5px (celebrations, one big number)
- Display: 32px, Bold, 40px, -0.4px (onboarding headlines, desktop greeting)
- Headline: 26px, Bold, 32px, -0.25px (screen titles on tablet and desktop)
- Title: 22px, Bold, 28px, -0.2px (screen titles on phone, pet name)
- Heading: 18px, SemiBold, 24px (section headers like "Next up", card titles)
- Body: 16px, Regular, 24px (default text)
- Body strong: 16px, SemiBold, 24px (list titles, prices in lists)
- Button label: 16px, SemiBold, 20px
- Support: 14px, Regular, 20px (second lines, helper text)
- Small label: 14px, SemiBold, 20px (chips, nav labels, status chips)
- Caption: 13px, Medium, 18px (timestamps only)
- Micro: 12px, Bold, 16px (badge numbers only)
Hindi and Telugu use the same sizes with taller lines (body 26px, title 34px, display 48px) and no letter spacing. Use tabular numbers for prices and timers. Sentence case everywhere. Nothing important is smaller than 14px. Text wraps; never cut important text with "...".

SPACING (4px grid)
Steps: 4, 8, 12, 16, 24, 32, 48, 64. Page side padding 16px on phone, 24px on tablet and desktop. Card padding 16px (24px for the hero card). 12px between cards in a list. 24px above a section header, 8px below it. 12px between form fields, 24px before the main button. 8px between chips and between an icon and its label. Content widths: 560px for forms and steps, 760px for detail pages and chat, 1200px max for Home and grids, centred. Minimum tap target 48px (56px in Easy mode).

CORNER RADIUS
Cards and dialogs 20px. Buttons, inputs, search bar and info notes 14px. Photos inside cards 12px. Small thumbnails 8px. Bottom sheets 28px on the top corners. Chips, status chips, nav indicator and avatars fully round.

SHADOWS (light mode only; in dark mode use no shadow and a 1px #2A3639 border instead)
- Card: X 0, Y 1, Blur 2, Spread 0, rgba(28,43,45,0.06) plus X 0, Y 2, Blur 8, Spread 0, rgba(28,43,45,0.05)
- Raised (floating bars, menus): X 0, Y 4, Blur 16, rgba(28,43,45,0.10)
- Overlay (bottom sheets, dialogs): X 0, Y -4, Blur 24, rgba(28,43,45,0.12), with a scrim of rgba(14,20,21,0.5) behind

COMPONENTS (make each a Framer component with variants)
- Button: height 48px, padding 14px 20px, radius 14px, 16px SemiBold label, optional 20px icon with 8px gap. Variants: Primary (teal fill, white text; only one per screen), Secondary (transparent, 1.5px #798A8C border, teal text), Tonal (#CCFBF1 fill, #053B36 text), Warm tonal (#FDE7D3 fill, #4A2508 text; Shop and celebrations only), Text (teal text, no fill), Danger (#B91C1C fill, white text). States: Hover (8% darker overlay), Pressed (12% overlay), Focus (2px teal ring, 2px gap), Disabled (#F1EDE8 fill, #5B6B6E text), Loading (spinner instead of label). Full width on phone forms.
- SOS button: red #DC2626 circle, 44px, white "SOS" 13px Bold. A red ring fills around it while it is held for 2 seconds.
- Quick action tile: white card, radius 20px, 1px #E5E1DA border, at least 96px tall, 46px round icon disc in #CCFBF1 with a teal icon, 14px SemiBold label below. Four in a row: Book vet, Log walk, Ask a vet, Add photo.
- Text field: 56px tall, white fill, 1px #798A8C border, radius 14px, 16px side padding, label 13px floating on the top border. Focus: 2px teal border and teal label. Error: 2px #B91C1C border plus a 14px red message with an error icon below. Phone field shows "+91" prefix.
- Search bar: 56px, radius 14px, 1px #798A8C border, search icon on the left, placeholder "Search food, toys, beds…".
- Chip: fully round, 32px tall (48px tap area), 1px #798A8C border, 14px SemiBold. Selected: #CCFBF1 fill, #053B36 text, check icon. Pet chips show a small pet avatar with its colour ring.
- PIN input: 4 to 6 boxes, 48 by 56px, radius 14px, 22px Bold digits.
- Status chip: fully round, padding 4px 10px, 14px SemiBold, icon 16px. Done (#DCFCE7 fill, #15803D text), Due soon (#FEF3C7, #B45309), Overdue (#FEE2E2, #B91C1C), Info (#CCFBF1, #053B36), Deal (#FDE7D3, #4A2508).
- Top bar (phone, 64px, on the page background): left a pet switcher (40px pet photo in a 2px colour-tag ring, pet name 18px SemiBold, chevron down); right a messages icon, a notifications bell with a red count badge, and the SOS button.
- Bottom navigation (phone, 68px, white, 1px top hairline): Home, Health, Book, Shop, Me. Selected tab: 64 by 32px pill in #CCFBF1 behind a filled icon; labels 14px SemiBold always visible.
- Navigation rail (tablet, 80px wide) and side navigation (desktop, 220px; partner and admin portals 280px with grouped sections): items 56px tall, selected item in a #CCFBF1 pill.
- Card: white, radius 20px, padding 16px, card shadow. Three levels: Hero (one per screen, #FDE7D3 fill, no shadow, padding 24px), Standard (white with shadow), Quiet (#F5F2EE, no shadow) for less important info like weather tips.
- Pet card (hero): 76px pet photo in a colour ring, "Bruno" 22px Bold, "Labrador Retriever · 3 yrs 2 mo · 29.0 kg" 14px, an "Adult" chip, chevron.
- Today card: 72px progress ring (8px teal stroke on #E5E1DA track, "89%" in the centre), "Bruno's day" 18px, "1 thing left today", a "30-day streak" chip in apricot, then checklist rows (Walk 2/2, Meal 2/2, Play 20/30 min) each with a green check or empty circle and a round teal + button.
- Next up list: rows with a 44px #CCFBF1 icon disc (vaccine, medicine), title 16px, "Due in 10 days" 14px grey, status chip on the right; hairline dividers.
- Product card: image area with radius 12px (soft #FBD2AE placeholder with a simple icon if no photo), "13% off" badge, seller 13px grey, name 16px SemiBold (2 lines max), price "₹3,899" 18px Bold with "₹4,499" struck through, star rating.
- Clinic card: name "Gulmohar Vet Studio" 18px SemiBold, rating, distance "2.4 km", "Open now" and "24x7" chips, "Consultation from ₹500", a Tonal "Book" button and Call and Directions icon buttons.
- Stat tile: icon, big number 22px Bold, label 14px.
- Info note: radius 14px, #CCFBF1 fill, info icon, 14px text, e.g. "Indicative, always confirm with your vet". Warning and error versions use the warning and error containers.
- Empty state: illustration, one 18px line, one 14px line, one primary button.

ICONS AND ASSETS
- Icons: Material Symbols Rounded (Framer Icon component, Material set, Rounded style), 24px; outlined when inactive, filled when selected; 20px inside buttons and chips.
- Logo: a rounded teal square (#0F766E, corners 28% of the size) with an apricot bridge arch on top and a white paw print below the arch; wordmark "PawSetu" in Plus Jakarta Sans Bold. (Upload pawsetu-mark.svg and the lockup SVGs.)
- Illustrations: one soft, flat style with rounded shapes in teal and apricot on a pale teal blob. Use them only for onboarding, empty states and success screens. (Upload the PNGs from the illustrations folder.)
- Pets without a photo get a simple illustrated face in their colour tag. No stock photos, no real brand logos, no emoji in the interface.

LAYOUT AND BREAKPOINTS
Phone 390px wide (check at 360px): bottom navigation. Tablet 800px: navigation rail. Desktop 1280px: side navigation, content max 1200px. Make Light and Dark versions. Easy mode: text 25% larger, 56px buttons, a simpler Home with Today, Next due, 4 big quick actions and SOS.

MOTION
200 to 300ms ease-out. A small celebration (check burst, ring pulse) when the last daily task is done. Respect reduced motion.

WORDS
Friendly, short and plain. Use the pet's name: "Bruno's next vaccine is due in 3 days." Buttons start with a verb: "Book vet", "Confirm booking", "Add photo". Indian formats: ₹1,24,999, 13 Oct 2026, 8:05 PM, kg, +91. Example user: Priya in Bengaluru with Bruno (Labrador, 3 years) and Misty (Persian cat).

SCREENS TO DESIGN
1. Home: greeting "Good evening, Priya", hero pet card, Today card, Next up, 4 quick actions, walk weather tip (quiet card), "Bruno's food may run out in about 5 days. Reorder?" card.
2. Health: "Bruno's health", Health report and Medical card buttons (teal tonal), Next up list, Vaccinations list with Done / Due soon / Overdue chips, info note.
3. Book: search, service chips (Vet, Grooming, Training, Boarding, Walking), clinic cards.
4. Shop: search bar, deal banner (apricot fill, dark text), "For Bruno" pet chips, product grid.
5. Me: profile header and grouped lists (My pets, Family, Documents, Album, Settings, Help).
6. SOS sheet: red header, two big options "Call nearest clinic" and "Get nearest clinic address", then the pet's medical summary.
```
