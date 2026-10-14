# PawSetu progress

Tick a box only when the phase's "Done when" list works and the end-of-phase checks pass.

## Setup
- [x] Prompt 0: spec saved, AGENTS.md, Flutter project (Android, iOS, web), Firebase emulator config (project `demo-pawsetu`), Cloud Functions folder (TypeScript)

## Version 1 (demo)
- [x] Phase 1 — Foundation
- [ ] Phase 2 — Pets and family
- [ ] Phase 3 — Daily routine tracker
- [ ] Phase 4 — Health and reminders
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
