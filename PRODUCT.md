# Product

<!-- impeccable:product-schema 1 -->

## Platform

android

One Flutter 3.47 codebase (Material 3) ships to Android, iOS and the web. Android phones are the main device for pet parents in India; partners and the admin often use the web on a laptop. The design language is one custom PawSetu language on every platform (it does not switch to Cupertino on iOS). Checked in Chrome at 360 px and 1280 px in cloud sessions.

## Users

- **Pet parents in Indian cities** and their families (the demo's Priya Sharma with Bruno, a Labrador, in Bengaluru). They open the app several times a day for small jobs: tick off a walk or a meal, check what's due, book a vet or groomer, reorder food, message a clinic. Rarely, in an emergency, they need help in seconds (SOS, first aid, nearest open clinic).
- Many read **Hindi or Telugu**; some are older or less confident with phones and use **Easy mode** (bigger text and buttons, simpler screens).
- **Family members and pet sitters** with limited access to a pet.
- **Partners**: vet clinics, vets (incl. online consults), groomers, trainers, boarding, walkers and sellers, working through portals: today's bookings, requests, calendar, services, chat, reviews, payouts, products and orders.
- **The PawSetu admin**: approvals, users, catalogue, complaints, moderation, settings, the Demo Outbox and audit log.
- **Demo visitors** on https://pawsetu-demo.netlify.app, who start at sign-in and the list of demo accounts.

## Product Purpose

One app for everything about looking after a pet in India: daily routine, health records and vaccines, booking vets and other services, online vet (tele-vet), a pet shop, emergency SOS and first aid, lost-pet tags, a PIN-locked document vault, a memory album, family sharing and a scripted assistant (Ask PawSetu). Success: the pet's day is looked after with little effort, health records are trusted and findable, help is one tap away in an emergency, and booking and shopping feel clear and fair.

## Positioning

Built around the pet, not the shop or the clinic: the pet's day and health come first, and booking, tele-vet and shopping hang off that. Made for India: ₹ prices, Indian cities and clinics, English, Hindi and Telugu, and Easy mode for people who find apps hard.

## Operating Context

- Phones held in one hand, often outdoors on a walk or in a clinic waiting room; bright daylight and night-time use (dark mode matters).
- Emergencies (SOS, first aid, toxic-food check) happen under stress: no reading, one obvious action.
- Partners and admin work at a desk on wide screens with lists and tables.
- Printed and shared documents (prescription, health report, invoice, medical card, lost-pet poster) leave the app and must look official.

## Capabilities and Constraints

- **DEMO VERSION 1** is built (Phases 1–11). All data is fictional; payments, SMS, WhatsApp, email and calls are pretend, shown with a clear "Demo" dialog and logged to the Demo Outbox. **FINAL VERSION** (real services) has not started.
- Five pet-parent tabs, fixed: **Home, Health, Book, Shop, Me**.
- Languages: English, Hindi, Telugu (ARB files); no others.
- Modes that must keep working: light, dark, high contrast, Easy mode, text size up to 200%, reduce motion.
- Accessibility floor: WCAG AA contrast (text 4.5:1, borders and focus 3:1), no text under 13 px, 48 px touch targets (56 px in Easy mode).
- A redesign changes the look only: no changes to features, data, Firestore or Storage rules, Cloud Functions or demo data.
- Things the app does **not** have and must not show: pet blood group, ambulance dispatch, live hospital status, QR kiosk check-in, WhatsApp pass, Kannada, "verified" claims beyond what the data says.

## Brand Commitments

- Name: **PawSetu** ("setu" = bridge: between pet parents and the people who care for pets).
- Voice: plain, warm, short sentences; buttons say exactly what they do ("Book for Bruno", "Try again"); people are greeted by first name.
- **SOS is the only red in the app.** Nothing else (buttons, badges, discounts, warnings) may look like it.
- Owner's binding choices for UI Design 5 (8 Nov 2026): calm and trustworthy on health, records, tele-vet and SOS; warm and friendly on Home, empty states and onboarding; Home is the pet's day first; no green or teal as the main colour, nothing coral, red or orange-red besides SOS; free Google Fonts that work in English, Hindi and Telugu, bundled in the app; photos for pets, clinics and products, a few drawings for empty states and onboarding. Shop works like an Indian pet shop (by pet and category, price and discount shown once, delivery time, buy again), without copying any shop's brand.

## Evidence on Hand

- Demo data in `lib/core/demo/seed/`: people (Priya, Ravi, Anjali, Arjun…), pets (Bruno…), clinics (Gulmohar Vet Studio…), providers, products, bookings, health records.
- 28 public-domain (CC0) demo photos in `assets/images/demo/` (credits in `docs/ui-designs/demo-photo-credits.md`).
- Product pictures in the shop are placeholders today; no real product photos or brand logos may be used.
- No real reviews, customers or ratings exist; demo ratings are labelled demo data.

## Product Principles

1. The pet first: every screen answers "what does my pet need now?" before anything else.
2. Calm where it matters: health, records and emergencies are quiet, clear and serious; warmth lives in the everyday.
3. One clear next step: one main action per screen, in plain words.
4. Works for everyone: Hindi, Telugu, Easy mode, big text and dark mode are first-class, not afterthoughts.
5. Honest by default: prices up front, demo clearly labelled, no invented claims.

## Accessibility & Inclusion

WCAG AA as above, checked by `test/core/contrast_test.dart`; layouts survive 200% text (`test/qa/layout_sweep_test.dart`); Hindi and Telugu at line height 1.6; Easy mode with 56 px targets; reduce motion respected; high-contrast theme.
