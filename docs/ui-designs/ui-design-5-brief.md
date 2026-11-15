# UI Design 5 — the brief

Agreed with the owner on 8 Nov 2026, before the overnight run (Impeccable `shape`, two question rounds). UI Design 5 is a **new look** for DEMO VERSION 1, not a polish of UI Design 4. UI Design 4 stays live until the owner approves UI Design 5. The running log is `docs/ui-designs/ui-design-5-log.md`.

The owner gave no screens, notes or reference pictures of their own (`docs/ui-designs/ui-design-5-screens/`, `-source/` and `-refs/` don't exist), so everything is designed from this brief.

## 1. Who it's for and how they arrive

- **Pet parents in India** (Priya with Bruno the Labrador, in the demo) open the app many times a day: to tick off today's walk and meals, see what's due, book a vet or groomer, reorder food, or get help fast in an emergency. Many use phones; some use Hindi or Telugu; some use Easy mode (bigger text and buttons).
- **Partners** (clinic, vet, groomer, trainer, boarding, walker, seller) and the **admin** work in the portals, often on a laptop: lists, bookings, payouts, approvals.
- **Demo visitors** (the website) see the sign-in page and the demo accounts first.
- Mode (Impeccable): **Operate** everywhere — people come to get something done. Brand shows in precise details, not decoration.

## 2. The feel

- **Calm and trustworthy** (like Apple Health and Practo) **plus warm and friendly** (like Headspace).
- **Calm and serious** on Health, records (vault, medical card, prescriptions, reports), tele-vet and SOS.
- **Warm and kind** on Home, empty states, onboarding, the album and birthdays.
- **Shop** can feel like Supertails *in how it works only*: shop by pet and by category, clean product cards with the ₹ price and the discount **shown once**, delivery time shown clearly, easy reorder ("buy again") and cart, and a quick "Talk to a vet" entry. **Not** its brand: no Supertails colours, logo, mascot or illustration style, and no deal-heavy banners.
- Reference apps are studied for patterns only, never branding: Apple Health, Headspace, Rover, Fi, Airbnb, Practo, Blinkit/Zepto, Supertails, Google Pay India (Easy mode), Shopify admin and Stripe Dashboard (portals).

## 3. What each main screen is for

- **Home = my pet's day first.** From the top: greeting with the person's first name, the selected pet (Bruno), today's tasks, the next reminder or vaccine, then 3–4 big quick actions (for example Book, Tele-vet, Shop) and SOS. Clinics, offers and discovery go lower down.
- **Tabs stay exactly as they are:** Home, Health, Book, Shop, Me (same names, same order).
- **Health:** a calm summary first (what's due, what's done), then the records. "Medical card" appears once.
- **Book:** choose the kind of service, then clear cards for clinics and providers with photos, ratings and ₹ prices.
- **Shop:** see above.
- **Me:** profile, plan and settings, grouped so the menu is easy to scan.

## 4. Colours, fonts and pictures

- **A new main colour**: not UI Design 4's forest green and coral, not UI Design 1's teal, and **nothing red, coral or orange-red**. It must feel calm, warm and trustworthy and pass contrast in light and dark mode.
- **SOS is the only red in the app.** Warnings use amber or similar, never red; discounts and badges never look like SOS.
- **Fonts:** free Google Fonts that look good together in English, Hindi and Telugu (for example the Noto, Mukta or Hind families), **bundled inside the app**, not loaded from the internet. Hindi and Telugu at line height 1.6.
- **Pictures:** photos for pets, clinics, providers and products (keep the 28 demo photos); simple drawings only for empty states, onboarding and errors. No copyrighted characters, brand logos or watermarked stock images.

## 5. How the direction is chosen (Phase 2)

Three clearly different directions are mocked up (Home, Health, Book and one portal screen; 390 px and 1440 px; light and dark; real demo content). I pick one and build it overnight; all three stay on the compare page. They are scored in this order:

1. **Readability checks:** text contrast 4.5:1, borders 3:1, no text under 13 px, Hindi and Telugu fit, Easy mode works, SOS the only red.
2. **Fit with the owner's answers:** Home is the pet's day first; calm on health, records and SOS; warm everywhere else.
3. **Distinct:** it must not look like UI Design 4, or like a copy of Supertails.

If two are close, choose **the warmer one**, as long as health, records and SOS still feel calm and serious. Scores and the reason go in the log.

## 6. Order of work (if time runs out, the first items exist)

1. Design rules (DESIGN.md, PRODUCT.md) → foundation (tokens, theme, shared widgets, design gallery).
2. Shell: navigation, top bar, pet switcher, SOS.
3. The five tabs: Home, Health, Book, Shop, Me.
4. **Sign-in and the demo accounts screen** (the first thing any demo visitor sees).
5. Most-used pet-parent flows: booking (clinic page, booking confirmed), pet profile and routine, SOS, tele-vet.
6. The rest of the pet-parent screens: vault, album, messages, notifications, family, plans, settings, onboarding.
7. Partner portals and admin — **unless** the audit finds them much weaker than everything else; then they move before step 6 and the log says why.
8. Motion and app icons; finish (critique, polish, fresh-eyes review, compare page, store screenshots).

## 7. Must not repeat (UI Design 4 problems seen on the live site, 8 Nov)

1. Coral buttons and a red "24×7" badge that look like SOS.
2. Home on phones: tall clinic cards before the pet's day; greeting halfway down.
3. Repetition: "Due soon" on every row, "Medical card" twice on Health, "13% off" twice per product.
4. Two stacked buttons of uneven width (Health pass); the Tele-vet chip alone on a second line (Home).
5. Shop: placeholder product pictures and a loud promo banner.
6. The "Powered by Netlify" badge over the bottom tabs on phones (a Netlify setting, not our code; the fix goes in the owner's to-do list).
7. From the Stitch files: text under 13 px, low contrast, an SOS title that broke on phones, desktop menu items wrapping onto two lines.

## 8. Boundaries

- **Look only.** No changes to features, data, Firestore or Storage rules, Cloud Functions or demo data. The one agreed exception: the demo Plus renewal fix from `claude/serene-pascal-kjqctd` is merged (owner's choice, 8 Nov).
- If a design idea would change how the app works, it is **not** built; it goes into the morning report as a suggestion for the owner.
- All text in the en, hi and te ARB files, in natural, simple words.
- Every colour, size, spacing, corner, shadow and font comes from the tokens. Printed pages and drawn artwork keep their own values, as the token check allows.
- Keep what works: WCAG AA contrast, 48 px touch targets (56 px in Easy mode), layouts that survive 200% text, light, dark and high contrast, reduce motion.
- One primary action per screen; at most one chip or badge per row; no mid-phrase line breaks.
- States everywhere: loading skeletons, empty states with one action, errors in plain words with "Try again".
- Platforms: Flutter 3.47 for web, Android and iPhone. Checked in Chrome at 360 px and 1280 px (the Android emulator isn't available in the cloud). No deploys.
- Earlier proposals ("Neel" in `docs/design-proposals`, "Warm Clinical Trust" on `claude/nifty-brahmagupta-paz0cr`) and the old Figma file are not reused.
