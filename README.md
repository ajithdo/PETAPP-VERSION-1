# PawSetu

Every care your pet needs, in one place. A pet care app for India in
English, Hindi and Telugu, built with Flutter (Android, iPhone and website)
and Firebase.

This is **Version 1, demo mode**: every person, clinic and shop is fictional,
no money is charged, and no real SMS, WhatsApp, email or phone call goes out.
Simulated messages appear in the admin panel's Demo Outbox.

## Start the demo

### One command, no setup (recommended)

```sh
flutter run -d chrome
```

The whole demo runs inside the app with its own demo database, so you don't
need Firebase or an internet connection apart from map tiles. On the first
screen tap **Skip**, then **Explore as demo user** and pick an account.

On a phone: `flutter run` with an Android phone or emulator connected.

### With the Firebase emulators

Runs the same demo against the Firebase Local Emulator Suite (Auth,
Firestore, Storage, Cloud Functions), with the real security rules:

```sh
tools/demo.sh
```

The script starts the emulators, loads the demo data and opens the app in
Chrome with `BACKEND=emulator`. The emulator dashboard is at
http://localhost:4000. To reload fresh demo data later, run
`npm --prefix functions run seed`.

Needs: Flutter 3.47 or newer, Node.js 22, the Firebase CLI
(`npm install -g firebase-tools`) and Java 21 for the emulators.

## Demo accounts

Every account uses the password `demo1234`. Phone sign-in uses the number
shown and the code `123456`. The **Explore as demo user** screen signs in
with one tap.

| Account | Role | Email | Phone | Try this |
|---|---|---|---|---|
| Priya Sharma | Pet parent, Plus, Bengaluru | priya@example.com | +91 90000 00001 | Bruno (Labrador) and Misty (Persian cat). Book an instant vet slot, start a demo video call, reorder Bruno's food from Home. |
| Ravi Teja | Pet parent, Free, Hyderabad, Telugu | ravi@example.com | +91 90000 00002 | Simba's overdue vaccine, a grooming request, the live walk with Imran Walks, the free tele-vet word limit. |
| Anjali Verma | Pet parent, Free, Delhi, Hindi, Easy mode | anjali@example.com | +91 90000 00003 | Easy mode, Coco the rabbit, Tiger's health report in Hindi. |
| Arjun Mehta | Pet parent, Plus, Mumbai | arjun@example.com | +91 90000 00004 | Max and Luna, Sheru in memory, Max's smart collar and safe zone. |
| Rohan Sharma | Family member (Carer for Priya's pets) | rohan@example.com | +91 90000 00005 | Logs walks and medicines for Bruno; can't delete pets. |
| Meera Pillai | Pet sitter for Arjun (access ends on a date) | meera@example.com | +91 90000 00006 | Sitter access with an end date. |
| Kavya Rao | Clinic admin, Golconda Gate Pet Clinic | clinic@example.com | +91 90000 00007 | Partner portal: today's bookings, calendar, staff and vets, reviews, payouts. |
| Dr. Sameer Khan | Vet at Golconda Gate | vet@example.com | +91 90000 00008 | Tele-vet queue, consultation notes, e-prescriptions. |
| Lakshmi Groom Studio | Groomer, Hyderabad | groomer@example.com | +91 90000 00009 | Accept Ravi's grooming request, send a photo update. |
| Vikram Desai | Dog trainer, Hyderabad | trainer@example.com | +91 90000 00010 | Requests, calendar, services. |
| Nisha Home Boarding | Boarding and pet sitting, Hyderabad | boarding@example.com | +91 90000 00011 | A dog boarding right now with daily updates. |
| Imran Walks | Dog walker, Hyderabad | walker@example.com | +91 90000 00013 | Simba's walk in progress. |
| Tail Treats Traders | Seller | seller@example.com | +91 90000 00014 | Seller portal: products, orders, returns, payouts. |
| PawSetu Admin | Platform admin | admin@example.com | +91 90000 00015 | Approvals, complaints, settings, Demo Outbox, analytics. |

You can also create your own account (email, phone, Google or Apple; demo
versions in demo mode), or join as a partner from the sign-in screen
("Run a pet business? Join as a partner").

## Run modes

Chosen with `--dart-define` flags (see `lib/core/config/app_config.dart`):

| Flag | Values | Default |
|---|---|---|
| `APP_MODE` | `demo`, `live` | `demo` |
| `BACKEND` | `standalone` (in-app demo database), `emulator` (Firebase emulators), `firebase` (a real project) | `standalone` |

## Build

```sh
flutter build web --release --no-web-resources-cdn   # website in build/web
flutter build apk --release --split-per-abi          # Android APKs in build/app/outputs/flutter-apk
```

## Checks

```sh
flutter analyze
flutter test
firebase emulators:exec --only firestore --project demo-pawsetu "npm --prefix functions test"   # security rules tests
```

## Project map

- `lib/core`: configuration, theme and design system, shared widgets,
  languages (`lib/core/l10n/src/*.json`, merged with
  `dart run tools/l10n/merge.dart && flutter gen-l10n`), routing, services
  (each with a Demo and a Live version), demo data (`lib/core/demo/seed`).
- `lib/features`: one folder per feature (pets, family, routine, health,
  booking, partner, messaging, vault, shop, sos, admin...).
- `functions`: Cloud Functions (region asia-south1) and security rules tests.
- `firestore.rules`, `storage.rules`: security rules.
- `docs`: the product spec, build prompts, progress log, decisions and the
  data model.
