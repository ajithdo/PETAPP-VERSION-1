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

## Phase 8

**One set of shop rules, used twice.** `lib/features/shop/domain/shop_rules.dart` holds the pure pricing rules (commission, coupons, delivery fee, splitting a cart into one order per seller, sharing a discount or fee across sellers with largest-remainder `allocate`, invoice and short order numbers, order steps, cancel/return windows, payout states, expense split, search, picks, CSV parsing). `functions/src/phase8.ts` mirrors the money parts in TypeScript, and unit tests on both sides use the same examples. In the standalone demo the app prices the cart with the Dart rules; with Firebase the `createOrder` callable prices it again on the server from the product documents (client prices are ignored), checks stock and the coupon, writes the orders and decrements stock in one transaction.

**Orders.** One `orders` document per seller with a shared `groupId` for the checkout. Money fields (prices, discount, fee, commission, total) can never be changed by a client: rules let the owner only cancel, ask for a return or move a pending payment to paid; the seller only moves the status forward (placed → packed → shipped → delivered) and handles returns. Refunds are recorded by the server (`onOrderUpdated`) in Firebase mode and locally in the demo. Payment is the Phase 5 `PaymentService` (demo sheet in Version 1).

**Food running low.** Each pet can have a food product, bag size, daily portion (suggested from species, weight and life stage, e.g. a 29 kg Labrador ≈ 400 g a day) and the date the bag was opened (`food_stock.dart`). Days left = bag ÷ portion − days since opening; 7 days or less shows the Home card. When a food order is delivered the bag date resets. The 2-tap reorder uses the saved address and pay on delivery by default; it can be changed in the sheet.

**Subscriptions.** `subscriptions` collection (product, quantity, every N weeks, next date, address). With Firebase, `runSubscriptions` runs daily at 06:00 India time and places due orders; the standalone demo runs due subscriptions when the shop opens.

**Sellers and payouts.** Sellers manage only their own products (rules check `ownsSeller`; the rating field is server-only and recomputed by `onProductReview`). CSV upload uses `file_picker` bytes and `parseProductCsv`, shows each row's problems before importing, and never imports a row with errors. Payouts: delivered orders become "ready" after the return window; the seller's weekly payout run (`runSellerPayouts` with Firebase, simulated in Version 1) marks them paid.

**Affiliate partner stores.** Partner store links open in the browser; each tap is written to `affiliateClicks` (create-only for clients) and counted by `onAffiliateClick`.

**Expenses.** `expenses` collection. Orders add `exp_<orderId>_food` and `exp_<orderId>_supplies` (food and treats vs everything else), bookings add theirs (Phase 5), people can add or edit manual ones. Charts use `fl_chart` (already in the project).

**Packages.** No new packages: `pdf`/`printing` (invoices), `file_picker` (CSV), `fl_chart` and `url_launcher` were already added and support Android, iOS and web.

## Phase 9

**SOS never waits.** The 2-second hold (and the Easy-mode confirm, also for screen readers) opens a full-screen page with exactly two big options. The page shows clinics at once from a location remembered in the last 6 hours or the chosen area (the person's city, or the area picked with "Change area"), and switches to GPS only if it answers within 10 seconds: a location prompt nobody answers must not hold up an emergency. Clinics are ranked open-now and 24x7 first, then nearest; the emergency line is called when a clinic has one. In demo mode a call shows "Demo: this would call +91 90000 000xx" and never dials.

**Weak internet.** After each SOS the nearest 20 clinics are saved on the device (SharedPreferences, `sos_rules.dart`). If the live list does not arrive within 3 seconds, SOS shows the saved list with the date it was saved.

**Activation log.** Every SOS writes `sosLogs` (uid, pet, time, latitude and longitude rounded to 3 decimals, about 100 m, area, source gps/last_known/chosen). `onSosLogged` adds it to `analyticsDaily/{date}.sos` for the admin dashboard.

**First aid and the toxic checker.** All text is in the ARB files (`10_firstaid.json`, `10_toxic.json`), so it ships inside the app and works offline. Guides have signs, numbered steps, "don't" and "when to see a vet". The checker has 42 foods, plants and household items, each rated per species (Dangerous / Be careful / Safe in small amounts); search matches names in the three languages plus Hinglish keywords, with English words matched as whole words ("rat" is not in "carrot"). Everything is labelled "Draft, to be reviewed by a vet" in Version 1.

**QR tags and the public page.** Each pet's tag id (`pets.qrToken`) is 16 random characters from an alphabet without look-alike characters (about 92 bits); new pets also get `qr_<random document id>`. The tag links to `<website>#/lost/<tag>`, a public route. With Firebase, finders never read the database: `openLostPage` returns only `publicPetView()` (name, species, breed, colour, photo, markings, lost details), and `contactPetFamily` / `shareFinderLocation` pass the message or location to everyone who looks after the pet as a notification, push and SMS (Demo Outbox in demo mode). The family's number is never shown. A tag accepts at most 5 messages an hour (`tagRelays/{tag}`, server only). The standalone demo runs the same rules on the device.

**Lost pet mode.** "Mark as lost" writes `lostReports` and `pets.lost` (carers can do this too). The opt-in alert goes to people who turned on lost-pet alerts (`users.consents.lostPetAlerts`) and live within 5 km, using `users.homeLat/homeLng` (Version 1: the home area; Live: the geocoded address). Sightings and alert counts are written only by the server. The tag sheet and the poster are A4 PDFs drawn from Flutter widgets (so Hindi and Telugu render correctly) with `qr_flutter`.

**Connected devices.** `DeviceProvider` (`lib/features/sos/data/device_provider.dart`) has `scan`, `watch`, `read` and `command`. `DemoDeviceProvider` works readings out from the clock and the device id, so every family member sees the same numbers, and has a "walk out of the safe zone" control for demos; `LiveDeviceProvider` is a Version 2 stub. `DEVICES_MODE` (or `APP_MODE`) picks one. The safe zone is a 100–2000 m circle around home. The app records the collar's zone state on the device (`data.inside`); going out alerts everyone who looks after the pet (notification, push, SMS), and coming back sends a calmer note. With Firebase, `onDeviceUpdated` sends these. Walks and play noticed by a collar or tracker are written once into the routine tracker (log id `dev_<device>_<date>_<n>`, `data.source = 'device'`).

**Adding a real device vendor (Version 2).**
1. Write a `DeviceProvider` for the vendor: `scan` signs in to the vendor account (cloud devices) or scans Bluetooth LE (phones only; hide Bluetooth vendors on the website); `watch` reads `devices/{id}` snapshots; `command` calls a callable function that talks to the vendor API.
2. Add a Cloud Functions webhook (`onRequest`) that checks the vendor's signature (secret in Secret Manager, never in code), maps the payload to `devices/{id}.data` (lat, lng, battery, steps, feeding events) and lets `onDeviceUpdated` raise safe-zone alerts.
3. Register the provider for that vendor in `deviceProviderProvider` and add the vendor to the admin settings.

**Rules.** `devices`: family reads; carers and up pair, rename, change the zone or remove; any family member may update `data` only (latest reading). `sosLogs`: people log only their own activations with a known source; they and admins read. `lostReports`: family and admins read; carers and up create with no alerts or sightings, and may change status and note only. `tagRelays`: server only.

**Packages.** No new packages: `qr_flutter` (already in pubspec), `geolocator`, `flutter_map`, `share_plus` and `printing` support Android, iOS and the web.

## Phase 10

**One place for every number.** Prices, trial length, plan limits (pets, family, tele-vet chats, messages, words and hours, Ask PawSetu questions, storage, video length), booking commission (default, per type and per provider), shop margins (food, other, per category, per seller), delivery fees, the Plus video discount, feature switches, the referral reward, vaccine timings and the vet-review status of content all live in `config/app`. The admin writes them with dotted paths (`limits.free.teleVetMessages`) so one change never overwrites its neighbours, every change is in the audit log, and the app picks it up at once because `appSettingsDocProvider` streams the document. Vaccine timing changes are copied into `VaccineOverrides` by `configSyncProvider` and applied by `templatesFor()`.

**Admin access.** The admin panel is only reachable with the `admin` role; with Firebase that role is a custom claim, and `firestore.rules` checks the claim, not the profile. Approving a partner (`reviewPartner`), pausing an account (`setUserSuspended`, which also disables sign-in) and changing roles (`setUserRole`) run in Cloud Functions so the sign-in claims change too. A rejection or suspension needs a reason, which the partner sees. Registration numbers get a format check (DEMO-VC-0001, a state council code such as TSVC-12345, or VCI) and a reminder to check the council register; the admin still decides.

**Paused accounts.** `users.suspended` sends the person to an "account paused" page with a contact-support button; public pages such as a lost pet's page still open.

**PawSetu Plus.** Free, `trial` (7 days, once per person, `trialUsedAt`) and `plus` (`planRenewsAt`, `planPeriod` monthly/yearly, `autoRenew`). An ended trial or period counts as free straight away (`effectivePlan`, in Dart and in the functions), and the nightly `expirePlans` job switches it back or renews it with a demo payment. Buying during a trial or an active period starts when that ends. People can't change their own plan, trial, suspension or referral code (rules); `startTrial`, `buyPlus` and `redeemReferral` do it on the server with prices from `config/app`. All payments in Version 1 are simulated and recorded in `payments` (kind plus or refund, `demo: true`, tax placeholder).

**Plan limits on the server.** Tele-vet, Ask PawSetu and storage were already checked in Phase 6 and 7 functions. Phase 10 adds triggers for the rest: a pet over the limit (`onPetCreatedLimit`), family members over the limit (`onPetMembersLimit`) and album videos longer than the plan allows (`onAlbumVideoLimit`) are taken off again and the person is told why. The app checks first, so this only catches changed apps.

**Referrals.** Every account gets a code (up to 4 letters of the name and 4 random characters; `PAWS…` for names in Hindi or Telugu script). A friend can enter one code once; both get a personal ₹100 coupon (`coupons.forUid`) that only they can use, checked in the cart, in the order repository and in `createOrder`.

**Help and complaints.** `tickets` hold the whole conversation (`messages[]`). Pet parents raise them at `/me/help`, partners at `/help` (the owner area is closed to partner accounts) or from the Help section of their portal; links from a booking, order or chat fill in what it is about. Support sets status (open, in progress, resolved), assigns, replies and gives demo refunds up to the amount paid. A reply from the person reopens a resolved ticket. Notifications go out in each person's language (`onTicketWritten` with Firebase, `SafetyNotifier` in the standalone demo). Rules let the person add only their own message and never touch status, assignee or refund.

**Moderation.** Reported reviews can be hidden (and shown again); reported chats and content are marked handled or dismissed. Hidden reviews disappear from clinic and product pages.

**Privacy centre.** Consents (lost-pet alerts, anonymous usage, offers, sharing a health summary with clinics you book), "Download my data" (a JSON file with the profile and 27 kinds of records; `exportMyData` on the server) and "Delete my account" with a 30-day grace period. `purgeDeletedAccounts` deletes personal records and the sign-in after 30 days; bookings, orders, payments, reviews and chats are kept for accounts and disputes but lose the person's name and address.

**Dashboard numbers.** `analyticsDaily/{yyyy-mm-dd}` holds the daily totals (90 seeded days in the demo; with Firebase the Phase 8 and 9 triggers add to it). The dashboard groups them by day (last 14), Monday-starting week (last 12) or month (last 3) and compares only periods that have ended, so the running week never looks like a drop. The commission report adds booking commission, shop margin, Plus payments and refunds per month and per partner, with a CSV download.

**Banners and featured products.** Banners show on Home or in the Shop, to everyone, Free-plan people only or Plus members only. Featured products get their own Shop row.

**Content review.** First-aid guides, the toxic checker and vaccine schedules say "Draft, to be reviewed by a vet" until the admin records the reviewing vet's name and registration number; then they say "Reviewed by …".

**Packages.** No new packages: `fl_chart` (charts) and `share_plus` (CSV and JSON files; it downloads the file on the web) were already in use and support Android, iOS and the web.
