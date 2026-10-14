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

## Phases 2–4

**Photo crop without native plugins.** Square crop uses an in-app pinch/drag view captured with a RepaintBoundary, so it works the same on Android, iOS and web.

**PDFs are rendered by Flutter.** The `pdf` package cannot shape Hindi or Telugu text. Health reports (and later prescriptions, invoices, QR tags and posters) are laid out as Flutter widgets, rendered off screen to images (`lib/core/utils/widget_capture.dart`) and wrapped into an A4 PDF. Text is not selectable; Version 2 can move PDF generation to a Cloud Function with proper Indic shaping if needed.

**Reminders.** `flutter_local_notifications` with inexact scheduling (no exact-alarm permission needed). The reminder engine reschedules the next 7 days whenever health data changes and posts due items to the notification centre. Email/SMS/WhatsApp reminders go through `MessagingService` (Demo Outbox in demo mode). Quiet hours delay reminders to the end of the window; medicine reminders always ring on time. On the website, reminders appear in the notification centre only.

**Maps.** OpenStreetMap tiles via flutter_map with the app's package name as user agent and visible attribution. Directions open the phone's maps app (`geo:` or Google Maps URL), no paid routing API.

**Walks in the background.** geolocator's Android foreground service (visible notification) and iOS background location updates. The website offers manual entry and a demo walk.

**Android build machine note.** Maven Central rate-limited this build machine (HTTP 429). A machine-level Gradle init script points Maven Central to Google's official mirror; nothing in the project changes.

## Phase 5

**One booking engine.** Vets, grooming, training, boarding and walking share one `bookings` collection and one set of rules in `lib/features/booking/domain/booking_rules.dart`: slots from working hours, slot length, buffer, capacity, holidays and blocked times (30-minute lead time; services of 10+ hours get one slot a day), pricing (service + travel + platform fee − discount; partner payout = service + travel − commission), refunds (full refund up to the cancellation window, 50% after, none after the start) and request expiry. Instant services confirm straight away; request services wait up to the provider's reply window (default 2 hours) and then expire.

**Partner links.** Each booking stores `partnerUids` (the business owner and, for clinics, the chosen vet), so one query serves the partner calendar and dashboard. Vets see their clinic's portal sections for their own bookings.

**Payments.** `PaymentService` with `DemoPaymentService`: a sheet that lets you pick success, failure or pending. Paid bookings add an expense entry automatically. No money moves in demo mode.

**Calendar export.** "Add to calendar" builds an .ics file and opens the share sheet (works on Android, iOS and web, no calendar permission).

**Notifications in the recipient's language.** Booking notifications are written in the language saved on the recipient's profile (Ravi gets Telugu even when a groomer using English accepts).

**Partner sign-up.** Business type, details, KYC documents and the account in one form. The listing is created with status `pending` (hidden from owners) plus a `partnerApplications` record for the admin queue. In the standalone demo the account switches to the partner portal straight away and the dashboard shows "Waiting for approval"; with Firebase the role is a custom claim that only an admin sets on approval (Phase 10).
