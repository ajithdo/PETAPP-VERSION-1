# PawSetu progress

Tick a box only when the phase's "Done when" list works and the end-of-phase checks pass.

## Setup
- [x] Prompt 0: spec saved, AGENTS.md, Flutter project (Android, iOS, web), Firebase emulator config (project `demo-pawsetu`), Cloud Functions folder (TypeScript)

## Version 1 (demo)
- [x] Phase 1 — Foundation
- [x] Phase 2 — Pets and family
- [x] Phase 3 — Daily routine tracker
- [x] Phase 4 — Health and reminders
- [ ] Phase 5 — Clinic finder, bookings and partner portal
- [ ] Phase 6 — Messaging, tele-vet and AI assistant
- [ ] Phase 7 — Document vault and memory album
- [ ] Phase 8 — Marketplace and expenses
- [ ] Phase 9 — SOS, first aid, lost pet and smart devices
- [ ] Phase 10 — Admin panel, plans and privacy
- [ ] Phase 11 — Polish and full test

## Version 2 (live) — do not start until the owner says "Start Version 2"
- [ ] L1 — Production base
- [ ] L2 — Real payments
- [ ] L3 — Real notifications
- [ ] L4 — Video calls, AI and vault security
- [ ] L5 — Launch

## Log
- **14 Oct 2026 — Phase 1 complete.** Theme (light/dark/system, high contrast), bundled fonts, shared widget library and hidden design gallery (Settings → About, tap 5 times), English/Hindi/Telugu with instant switching, Easy mode and text-size slider, responsive shell (bottom bar / rail / side nav) with pet switcher, messages, notifications and SOS in the top bar, sign-in (email + verification, password reset, phone OTP, Google, Apple) in demo and Firebase versions, onboarding (3 slides, preferences, first pet, notifications), one-tap demo login for every role, role guards, partner portal and admin shells, data model for the whole app (docs/DATA_MODEL.md), Firestore and Storage rules with 12 rules tests, demo seed (14 accounts, 9 pets, 15 clinics + 2 pending, 34 vets, 25 providers + 1 pending, 6 sellers + 1 pending, 3 affiliate stores, 40 products) for the standalone demo and the emulators (`npm --prefix functions run seed`). Standalone demo database uses a patched copy of fake_cloud_firestore (third_party/) so it runs in release builds.
- **14 Oct 2026 — Phase 2 complete.** Add/edit pet in 2 steps (only name and species required) with searchable breed lists in 3 languages, "Mixed / Indie" and "Other", the protected-bird note, square photo crop (works on web and mobile without native croppers), colour tags, exact or approximate birthday, life stage and friendly age. Pet profile with hero photo, quick stats, details, family and care sections. Pet switcher and "All pets". Archive as "In loving memory" or rehomed (records kept). Family sharing: invite by phone, email or link (demo: the invite shows up in the other demo account and the SMS/email goes to the Demo Outbox), Viewer/Carer/Co-owner roles, sitter access that ends on a date, change role, remove access, activity feed. Free plan limits (3 pets, 2 family members) with a gentle Plus prompt. 5 new family tests.
- **14 Oct 2026 — Phase 3 complete.** Quick log from Home in 1–2 taps (checklist "+" buttons, or Log → type) for walk, play, meal, water, potty, sleep, grooming, training, mood, weight and behaviour, each with time, who logged it, note and photo. GPS walk tracker on OpenStreetMap (start, pause, stop, distance, time, pace); background tracking with a visible notification on Android and iOS (geolocator foreground service / background location); website: manual entry plus a demo walk. Behaviour tags with intensity and trend lines, shareable with a trainer or vet. Daily plan per pet driving the Home "Today" checklist and progress ring, suggested goals by species/size/age, streaks, weekly and monthly charts. Heat-safety card with demo temperatures and stronger warnings for flat-faced breeds. Real Home screen (Today, quick actions, walk weather; Easy mode and "All pets" versions). 30 days of seeded logs and GPS routes for every pet plus 90 days of weight history. Reminders for the plan are delivered by the Phase 4 notification system. Offline: Firestore queues writes made offline in the Firebase versions; the standalone demo is always local.
- **14 Oct 2026 — Phase 4 complete.** Vaccine schedule generator from spec section 11 (dogs, cats; rabbits and birds get the "no routine vaccines" guidance) with Done / Due soon / Overdue / Upcoming / Ask your vet, catch-up note for adults with no history, recording with brand, batch, vet, clinic and certificate photo (saved to the documents collection for the vault). Medicines with once/twice/every X hours/weekly/custom schedules, Given / Skip / Snooze (in app and as phone notification actions), stock count and refill reminder. Deworming (age-based interval) and flea/tick, vet visits, weight chart with indicative healthy band, symptom diary with photos and "Share with vet", custom reminders. Reminder engine: scheduled local notifications that work offline on Android/iOS, notification centre (filters, mark all read), per-type channels (push/email/SMS/WhatsApp; non-push go to the Demo Outbox) and quiet hours (medicines always on time). Health report PDF and offline medical card. Home "Next up". 10 new unit tests (vaccine schedules, deworming, medicine doses). Note: medicine notification actions are verified in code; they need a phone to try (the website shows reminders in the notification centre instead).
