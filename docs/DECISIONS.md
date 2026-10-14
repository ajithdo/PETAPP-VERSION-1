# Technical decisions

A running log of choices and why. Newest at the bottom of each section.

## Setup

**Flutter 3.47 stable + Dart 3.13.** One codebase for Android, iOS and web, as the spec asks.

**Two ways to run the Version 1 demo.**
- `BACKEND=standalone` (default): the app carries its own in-memory Firestore (`fake_cloud_firestore`) seeded with the demo data from `lib/core/demo/seed/`. The website and the Android APK work anywhere without a server or a Firebase account. Changes are saved on the device (shared_preferences) and "Reset demo data" in Settings restores the seed.
- `BACKEND=emulator`: the Firebase Local Emulator Suite (Auth, Firestore, Storage, Functions) with project id `demo-pawsetu`. `demo-` project ids need no real Firebase project or card. `tools/seed/seed.dart` loads the same seed data into the emulators.
- Why: the owner wants a shareable website and an installable APK before any Firebase account exists, and the spec says Version 1 must cost nothing.

**One data API.** Repositories talk to the `FirebaseFirestore` API in both modes, so the code paths are the same; only the instance differs (fake vs real/emulator).

**Top-level collections only.** No subcollections; parent ids are stored as fields (`petId`, `ownerId`, `clinicId` …). Makes security rules, queries and standalone persistence simpler.

**Auth behind an interface.** `AuthService` with `DemoAuthService` (standalone: accounts in the demo database, OTP code 123456 shown in a Demo dialog, Google/Apple open a demo account picker) and `FirebaseAuthService` (emulator/live; roles from custom claims).

**Business rules in pure Dart.** Vaccine schedules, slot generation, pricing and commission, tele-vet limits and food-running-low prediction live in `lib/features/*/domain` with unit tests. In standalone mode they run on the device; Cloud Functions in `functions/` enforce the same rules on the server for emulator/live mode.

**Fonts bundled.** Static TTFs (400/500/600/700) of Plus Jakarta Sans, Noto Sans Devanagari and Noto Sans Telugu in `assets/fonts/`, downloaded from Google Fonts (SIL Open Font License).

**Icons.** Flutter's built-in Material "rounded" icon set (`Icons.*_rounded`) instead of an extra icon package.

**State and navigation.** Riverpod 3 and go_router 18. Models: freezed 4 + json_serializable.
