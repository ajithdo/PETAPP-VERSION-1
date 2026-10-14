# Building Phases 6–10 in parallel

Phases 1–5 are done. Phases 6–10 are built at the same time by separate
agents, each in its own git worktree. This file is the shared brief. Read it
fully before you start, then read your phase's prompt in
`docs/BUILD_PROMPTS.md` ("### Phase N") and the spec sections it names in
`docs/PROJECT_SPEC.md`. The phase prompt's scope and "Done when" are the
acceptance criteria. Build everything it lists for Version 1 (demo mode).

The rule in AGENTS.md about showing a plan and waiting for OK does not apply
to this parallel build: the owner already approved building all phases.

## 1. File ownership (avoid merge conflicts)

Each phase owns:

| Phase | Slot file | Feature folders | Seed file | Strings file |
|---|---|---|---|---|
| 6 Messaging, tele-vet, AI | `lib/features/messaging/messaging_slots.dart` | `lib/features/messaging/`, `lib/features/televet/`, `lib/features/assistant/` | `lib/core/demo/seed/seed_messaging.dart` | `lib/core/l10n/src/07_messaging.json` |
| 7 Vault and album | `lib/features/vault/vault_slots.dart` | `lib/features/vault/`, `lib/features/album/` | `seed_vault.dart` | `08_vault.json` |
| 8 Marketplace and expenses | `lib/features/shop/shop_slots.dart` | `lib/features/shop/`, `lib/features/expenses/` | `seed_orders.dart` (products/sellers are already in `seed_shop.dart`, you may extend it) | `09_shop.json` |
| 9 SOS, first aid, lost pet, devices | `lib/features/sos/sos_slots.dart` | `lib/features/sos/`, `lib/features/lost/`, `lib/features/devices/` | `seed_safety.dart` | `10_safety.json` |
| 10 Admin, plans, privacy | `lib/features/admin/admin_slots.dart` | `lib/features/admin/`, `lib/features/plans/`, `lib/features/help/`, `lib/features/privacy/` | `seed_admin.dart` | `11_admin.json` |

The shared app already calls your slot file: routes (root routes, routes under
`/me`, `/shop`, `/partner/`, `/admin/`), partner/admin section bodies, Home
cards and links, pet-profile links and the SOS button. Fill the slot file and
put the real code in your feature folders. Keep the slot file's existing
names and signatures (the shared code depends on them); you may add new ones
only if you also need nothing else to change.

Do **not** edit: other phases' slot, seed or strings files;
`lib/core/routing/extra_routes.dart`, `router.dart`, `pet_links.dart`;
`lib/features/home/presentation/home_extras.dart`;
`lib/core/demo/seed/seed.dart` and `seed_activity.dart`; other strings files;
`docs/PROGRESS.md`, `docs/DECISIONS.md`, `docs/DATA_MODEL.md`.

If you truly need a change in any other shared file (for example a widget in
`lib/core/widgets`, `owner_shell.dart`, `pubspec.yaml`, `firestore.rules`,
`storage.rules`, `functions/src/index.ts`, Android/iOS config), keep it small
and additive, and list it under "Shared file changes" in your notes file.
For Cloud Functions, prefer a new file `functions/src/phaseN.ts` that you
re-export from `index.ts` with one line.

## 2. What already exists (reuse it)

- **Design system and widgets** (`lib/core/widgets/widgets.dart` barrel):
  PawCard, SectionHeader, StatusChip/ChipTone, StatTile, DemoBanner, InfoNote,
  EmptyState (with Scene illustrations), AsyncView, PrimaryButton,
  SecondaryButton, PawTextField, ChoiceRow, MediaImage (`mem://`, `seed:kind:species:n`,
  network), SeedArt, PetAvatar, PetFace, ProgressRing, SosButton, PageBody,
  ContentWidth, ResponsiveGrid, showPawSheet, showDemoDialog, confirmAction,
  showToast, PawMap/pinMarker/dotMarker/openDirections (`paw_map.dart`),
  DocumentPreviewScreen/A4Page/A4Section/A4Table (`document_preview.dart`),
  pickImage/pickSquarePhoto (`photo_picker.dart`). Tokens: `context.paw`,
  `context.colors`, `context.text`, `Space`, `Radii`. Formatting: `Fmt`
  (`lib/core/utils/format.dart`: inr, date, time, dateTime, km...).
- **PDFs** with Hindi/Telugu: render Flutter widgets with
  `renderWidgetToPng` and wrap with `pngPagesToPdf`
  (`lib/core/utils/widget_capture.dart`); see the Phase 4 health report.
- **Providers** (`lib/core/providers.dart`): currentUserProvider,
  firestoreProvider, appConfigProvider (`isDemo`, `isStandalone`,
  `usesFirebase`), appSettingsDocProvider (`config/app`: plans, limits per
  plan, commission, flags), planLimitsProvider, authServiceProvider.
  Pets: activePetsProvider, myPetsProvider, petProvider, selectedPetProvider
  (`lib/features/pets/data/pets_repository.dart`).
- **Services** (`lib/core/services/`): storageServiceProvider (upload →
  `mem://` URL in the demo), messagingServiceProvider (SMS/email/WhatsApp go
  to the Demo Outbox in demo mode), paymentServiceProvider
  (`pay(context, amount:, description:)` → PaymentOutcome success/failure/
  pending/cancelled), notification service (local notifications).
- **Notifications**: write to the `notifications` collection
  (`uid, title, body, type, link, read, createdAt`) in the recipient's
  language; see `_notify` in `lib/features/booking/data/booking_repository.dart`.
- **Reference feature**: `lib/features/booking/` (repository with Firestore
  streams and Riverpod providers, screens, partner sections).
- **Data**: top-level Firestore collections only (parent ids are fields).
  `docs/DATA_MODEL.md` already lists every collection with fields; follow it
  (record any change in your notes file). `firestore.rules` already has
  rules for every collection.
- **Demo accounts** (`lib/core/demo/seed/seed_people.dart`): u_priya (Bengaluru,
  Plus, Bruno + Misty), u_ravi (Hyderabad, Telugu, Free, Simba + Kiwi),
  u_anjali (Delhi, Hindi, Easy mode, Coco + Tiger), u_arjun (Mumbai, Plus,
  Max + Luna, Sheru in memory), u_rohan (family), u_meera (sitter),
  u_clinicadmin (clinic_hyd_1), u_vet (vet_hyd_1_a, Dr. Sameer Khan),
  u_groomer (prov_groom_1), u_trainer, u_boarder, u_walker (prov_walk_1),
  u_seller (seller_1), u_admin. Demo login: the "Explore as demo user" screen.
- **Seeds**: pure Dart (no Flutter imports), `void seedX(Add add, DateTime now, SeedData data)`,
  dates relative to `now`, fictional people only (phones `demoPhone(n)` =
  +91 90000 000xx, emails `@example.com`). The seed version is bumped at
  merge time; don't touch `seed.dart`.

## 3. Rules

- **Strings**: no hard-coded user-facing text. Add keys only to your strings
  file, with natural, simple English, Hindi and Telugu
  (`{"key": {"en": "...", "hi": "...", "te": "...", "ph": {"name": "String"}}}`).
  Check a key doesn't already exist (`grep '"key"' lib/core/l10n/app_en.arb`).
  Then run `dart run tools/l10n/merge.dart && flutter gen-l10n`. Access via
  `context.l10n`, language code via `context.lang`.
- **Demo mode**: never charge money, never send real SMS/WhatsApp/email,
  never dial. Show the Demo dialog and log to the Demo Outbox.
- **Services**: every outside service sits behind an interface with Demo and
  Live implementations chosen by `appConfigProvider`.
- **Free vs Plus limits** come from `config/app` (`appSettingsDocProvider` /
  `planLimitsProvider`), never hard-coded.
- **Responsive and accessible**: works at 360 px and on desktop, light and
  dark, Easy mode (bigger text), Telugu/Hindi text lengths, 48 px tap targets,
  semantics labels on icon buttons.

## 4. Build, test, commit

- Tools: `export PATH=/opt/flutter/bin:$PATH` (the "running as root" warning
  is fine). The machine has 4 CPUs shared with another agent: run one flutter
  build at a time, never `flutter clean`, never `flutter pub upgrade`.
- In a fresh worktree run `flutter pub get` first.
- `flutter analyze` must report no issues. Add unit tests for your domain
  logic in `test/features/phaseN_*_test.dart`; `flutter test` must pass.
- Website check: `flutter build web --release --no-web-resources-cdn --no-wasm-dry-run`
  (3–5 minutes), serve it with `python3 -m http.server <your port> -d build/web`
  (ports: Phase 6 → 8106, 7 → 8107, 8 → 8108, 9 → 8109, 10 → 8110) in the
  background, and click through your screens with Playwright using the
  harness `/tmp/claude-0/-home-user-PETAPP-VERSION-1/0952e210-8904-5657-8d84-c313fd5f94cb/scratchpad/e2e/smoke.cjs`
  (`node smoke.cjs http://localhost:<port>/ shots pN`, scenario in
  `scenarios/pN.cjs`; see `scenarios/p5.cjs`). Flutter web tips: enable
  semantics first (the harness does it), chips are role `checkbox`, switches
  role `switch`, use `click({force: true})`, use hash routes
  (`base + '#/route'`). The standalone demo keeps its data per browser
  context, so do multi-account flows in one page (sign out, sign in again).
  Save screenshots as `shots/pN-NN-name.png` and look at them: fix layout
  overflows, untranslated text and errors in the browser console.
- Commit on your worktree's branch (don't push, don't switch branches, don't
  touch other checkouts). Message: `Phase N complete: <summary>` and end it
  with these two lines:

      Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>
      Claude-Session: https://claude.ai/code/session_01XZTFniF2sqA6huykf5wZqs

- Write `docs/phase_notes/PHASE_N.md`: 5-line summary; checklist of the phase
  prompt's items with done/partial/not done; decisions; data model changes;
  shared file changes; "what to test" steps; known gaps.
