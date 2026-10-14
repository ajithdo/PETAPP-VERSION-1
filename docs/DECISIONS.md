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

## Phase 6

**How it was built.** Phases 6 and 7 were started by parallel agents in separate git worktrees; a usage limit stopped them mid-way. Their code was saved as WIP commits and finished in the main branch (strings, demo data, server functions, tests, browser checks).

**One chat model for everything.** `conversations` + `messages` (top-level). Thread ids are deterministic so there is one thread per booking (`chat_<bookingId>`), enquiry (`enq_<placeId>_<uid>`), tele-vet consultation (`tv_<consultationId>`) and Ask PawSetu history (`ai_<uid>`, hidden from the inbox). Unread counts live on the conversation (`unread.<uid>`), which drives the top-bar badge.

**Safety in chats.** Phone numbers typed into a chat are hidden before saving (Indian mobile and landline formats). Calls go through a masked number (demo dialog in demo mode). Messages that look like payment details (UPI ID, card number, OTP or PIN, also in Hindi and Telugu) get a "pay only inside PawSetu" warning before sending. Report, block and mute per chat; reports go to the admin moderation queue (`reports`).

**Voice notes.** Recorded as 16-bit PCM with the `record` package on every platform, including the web, and wrapped as WAV; played with `audioplayers`. Two minutes maximum. Where the microphone is unavailable the app offers a clearly labelled demo voice note.

**Tele-vet limits.** All numbers come from `config/app` limits per plan (messages, words per message, hours open, consultations a month, video). The allowance is copied onto the consultation when it starts, so an admin change does not alter running chats. The same rules (`televet_rules.dart`) run on the device in the standalone demo and in the callable functions `startConsultation` and `sendTeleVetMessage` (`functions/src/phase6.ts`) with Firebase. Vets are never limited; the owner's side closes when the window ends while the vet can still wrap up.

**Video calls.** `VideoCallService` with a simulated demo call (no camera, microphone or network). The real provider is chosen in Live phase L4.

**E-prescriptions.** Built by the vet in a form, previewed and saved as a PDF rendered from Flutter widgets (Hindi and Telugu shape correctly). Saving also writes a Health "vet visit" entry, a vault document, a follow-up reminder and a notification in the pet parent's language (on the device in the demo; by the `onPrescriptionCreated` trigger with Firebase).

**Ask PawSetu.** 20 scripted topics answered from the strings files (so answers follow the reader's language), keyword matching in English, Hindi and Telugu, and red-flag detection checked first (breathing trouble, collapse, seizures, poisoning, heavy bleeding, bloat, heatstroke, not passing urine, serious injury), which shows SOS and "Talk to a vet now". Red-flag questions are always answered and never counted against the monthly allowance (free 5, Plus unlimited; admin-configurable). Version 2 replaces the matcher with Gemini behind the same reply shape.

## Phase 7

**Vault lock.** A 4–6 digit vault PIN on every platform, stored on the device only as a salted PBKDF2-SHA256 hash (`pin_hash.dart`) tied to the signed-in person; easy PINs (1234, 1111) are refused. Fingerprint/face unlock on Android and iOS uses `local_auth` (MainActivity is a `FlutterFragmentActivity` for it); the website has no biometrics and always asks for the PIN. The vault locks after 2 minutes in the background or without vault activity, and 5 wrong PINs pause the pad for 30 seconds. "Forgot PIN" forgets the PIN on this device and asks the person to sign in again.

**Nothing left behind.** Vault files are drawn in the app from memory, never saved to the gallery; decoded images are cleared from Flutter's image cache when the vault locks. Encryption in transit and at rest is Firebase's own; envelope encryption with Cloud KMS is Live phase L4.

**Auto-read.** `DocumentReader` with a simulated reader in Version 1: the sample documents (rabies, DHPPi and FVRCP certificates, insurance policy, lab report, invoice, licence, adoption papers, travel certificate, prescription) are drawn from realistic printed values and stamped SAMPLE, and "reading" one returns exactly those values. Real uploads are not read in the demo: the type is guessed from the file name and the owner fills the rest. Nothing is saved until the owner confirms on "We found these details"; a vaccine certificate is then recorded in Health in the right schedule row (`matchVaccineTemplate`) and linked to the document. Version 2 swaps in Gemini via Firebase AI Logic behind the same interface.

**Camera scan.** Edges are found in pure Dart from the photo's brightness (`scan_bounds.dart`) so it works the same on the web and on phones; the owner can adjust the corners.

**Share links.** The link token is a random 22-character document id in `shareLinks`; an optional PIN is stored only as a hash. Security rules let only the owner read their links. With Firebase, people who open a link go through the `openShareLink` function (`functions/src/phase7.ts`), which checks revocation, expiry and the PIN (5 wrong tries in 15 minutes lock it), writes the access log, and returns only the chosen documents with file URLs that expire in 15 minutes. The standalone demo runs the same rules on the device. Revoking is final (rules allow only `revoked: true`). A unit test checks that the server accepts the PIN hash the app makes.

**Insurance.** `insurance` collection: provider, plan, policy number, cover, premium, start and renewal (with a reminder 14 days before), and claims with status steps (draft → submitted → in review → approved → paid, or rejected), settled amount and a checklist of the documents insurers usually ask for, each linkable to a vault file. "Cover left" counts paid claims.

**Album.** `album` collection (photos, videos and photo-less milestones), grouped by month, "On this day", milestone badges and timeline, named albums and favourites, a full-screen swipe viewer (arrow keys on the web). Videos are limited by plan (60 s free, 3 min Plus) and played with `video_player`; demo clips are simulated. Photos are compressed on upload. Family links reuse share links (`kind: album`). Sharing to WhatsApp and other apps uses the system share sheet, with an optional "Made with PawSetu" watermark on photos.

**Storage quota.** Free 1 GB and Plus 25 GB from `config/app` limits. The app shows usage (vault + album) and blocks uploads over the limit; with Firebase, the `enforceStorageQuota` trigger removes a file that takes a person over and notifies them.

**Riverpod 3 one-off reads.** Riverpod 3 pauses providers nobody listens to, so `ref.read(streamProvider.future)` can wait forever for data that is not on screen. One-off reads in callbacks use `readOnce` (`lib/core/utils/read_once.dart`), which keeps a listener open until the value arrives.

**Packages added.** `local_auth` (biometrics; Android/iOS, web falls back to the PIN), `crypto` (PBKDF2), `record` and `audioplayers` (voice notes, Phase 6), `file_picker` (PDFs), `video_player` (album videos; web uses the browser player), `qr_flutter`. All support Android, iOS and web or have a web fallback.
