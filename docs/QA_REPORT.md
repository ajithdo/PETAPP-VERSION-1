# PawSetu QA report (Phase 11)

Version 1, demo mode. Checked on 15 October 2026 on the branch
`claude/zen-ramanujan-4g7djn`.

**Result: no open critical issues.** Everything found in this pass was fixed,
except the limits listed at the end, which are not critical for the demo and
are planned for Version 2.

## What was checked

| Area | How | Result |
|---|---|---|
| Every screen, three languages | Automated sweep (`test/qa/layout_sweep_test.dart`) opens every main screen with the real fonts in English, Hindi and Telugu: pet parent (38 screens), admin (11), clinic (11), seller (8), vet (5) and groomer (9) | 471 screen checks, 0 problems |
| 200% text, phone width | Same sweep at 360 px with text at 200%, in all three languages | 36 places where text didn't fit were fixed (earlier in this phase); now 0 |
| Tablet and desktop | Same sweep at 800 px (150% text) and 1280 px | 0 problems |
| Easy mode | Same sweep in Hindi with Easy mode | 0 problems |
| Light and dark | Dark-mode pass of the sweep (pet parent and admin, Telugu); browser screenshots in both themes in every phase | 0 problems |
| Screen readers | Sweep checks that every button and link has a spoken label | All labelled (photos and the album viewer's close button were missing labels; fixed) |
| Tap targets | Sweep checks every tappable is at least 48 × 48 px | Fixed: message filter chips, Ask suggestions, cart + and − buttons, album pet switcher, Ask box |
| Contrast | `test/core/contrast_test.dart` checks every text/background pair of the design system exactly (WCAG AA, 4.5:1), light, dark and high contrast | Fixed: status chips (success, warning, info and rating chips were 1.8–4.3:1) and red buttons in dark mode (2.8:1) |
| Translations | All 2,943 strings have English, Hindi and Telugu with matching placeholders (`tools/l10n/merge.dart` fails otherwise); screens scanned for leftover English | Latin text left on purpose: PawSetu, Plus, NCR, QR, UPI, OpenStreetMap, medicine and vaccine brand names, email addresses. Words to confirm with a native speaker are listed below |
| Security | `functions/src/rules_matrix.test.ts`: all 47 collections, for signed out, a stranger, the family (including a sitter whose access ended), clinic admin, vet, groomer, seller and admin | 77 new cases; 12 gaps closed (see below) |
| Speed | Start-up measured in the browser with the CPU slowed 4× (like a mid-range phone); long lists; images | See "Speed" |
| Offline | Browser with the network switched off mid-session | Pet profile, medical card, vaccines and first aid stay readable; offline strip shows |
| Main journeys | Browser walk-through (recorded, 2.5 min): sign in, food reorder and tracking, health and medical card, booking a vet with demo payment, tele-vet, SOS and first aid, Telugu, clinic portal, admin | All 10 journeys pass |
| Emulator path | `firebase emulators:exec … "npm --prefix functions run seed"` | 14 accounts and 2,534 documents load |

Test totals: 200 app tests (`flutter test`), 170 server and security-rules
tests (`npm --prefix functions test` on the emulator), `flutter analyze`
with no issues.

## What was fixed in this phase

**Layout and accessibility**
- 36 overflows at 200% text: tiles and grids now grow with the text
  (shared `TileGrid`), product rows, place reviews, order cards, Ask header,
  album "on this day", loading skeletons, pet profile header.
- 48 px tap targets everywhere (shared `ChipStrip` for sideways chip rows).
- Spoken labels on photos and the album viewer.
- Contrast: status chips and dark-mode red buttons (above).
- Messages with a button (for example "Order placed! · Track order") stayed
  on screen until tapped, covering the bottom of every screen (a Flutter
  change). They now close after 6 seconds; with a screen reader on they
  stay, with a close button.
- The album's title now says "Bruno's memories" (it said "A moment with
  Bruno" and was cut off on phones).

**Security** (details in `docs/DECISIONS.md`, Phase 11)
1. Reminders, subscriptions and expenses could be overwritten by anyone who
   knew their id. Now only their owner.
2. Vaccines, medicines, health events and logs could be moved to another
   pet. Now they stay with their pet.
3. Clinics, groomers, vets and sellers could change their own commission
   rate, rating or "featured" spot. Now admin-only.
4. Clinic admins could edit any clinic's vets; now only their own, and new
   vets wait for approval.
5. Anyone could post a review for any business. Now only after your own
   completed booking, delivered order or consultation.
6. Any partner could reply to any review. Now only the business reviewed.
7. In a booking, the pet parent could mark it confirmed or paid, and
   either side could change who was on it or refund more than was paid.
8. People in a tele-vet chat could change its kind to skip the message
   limits, add people to a chat, or lift someone else's block.
9. Any vet could read and edit every consultation. Now the waiting queue
   and their own.
10. Anyone could send a notification to anyone. Now only to yourself or
    the other side of your booking or chat.
11. Partners could list every user. Now they can open a customer's profile
    by id only.
12. Family invites were readable and editable by anyone, and accepting one
    from the app couldn't work with the real rules. Now the invite's id is
    its secret token and joining runs in the `acceptPetInvite` function;
    ended sitter access also removes the pet from their list
    (`expireFamilyAccess`).

Also with the real Firebase backend (Version 2): booking expenses are kept in
step by `syncBookingExpense`, clinic, groomer and vet ratings by
`onReviewCreated`, and two vault queries were narrowed so the rules allow
them.

**Speed**
- Lists show 30 items at a time with "Show more" (admin lists 100):
  notifications, chat history, admin audit log and Demo Outbox read one page
  from the database; orders, bookings, expenses, the album and the admin's
  user list page on screen.
- Online photos are cached on the phone (`cached_network_image`); uploads
  were already shrunk to 2000 px at 80% quality.
- Start-up: the demo database loads in batches, essentials first and the
  long history right after the first screen, and is saved every 20 seconds
  and when the app goes to the background (it was every 4 seconds).

| Website, first screen | Before | After |
|---|---|---|
| Desktop, fast network | 2.2 s | 2.3 s (same; the gain is on slower CPUs) |
| CPU 4× slower (mid-range phone), local network | 8.1 s | 7.4 s |
| CPU 4× slower, demo data part of it | 1.7 s | 1.0 s |

Most of the remaining time on a slow phone is the Flutter web engine
starting (about 5 s at 4× slowdown); a loading screen with the PawSetu logo
shows meanwhile. The Android app starts natively and doesn't have this cost;
its start-up should be checked on a real mid-range phone (see "For you to
check").

**Offline**
- A strip at the bottom of every screen says "You're offline…" while there is
  no network.
- Standalone demo: all data is on the device, so everything works offline
  once the app has opened. Checked in the browser: pet profile, medical
  card, vaccines and first aid.
- With Firebase: the offline cache is on for Android and iOS; nearby
  emergency clinics are saved on the device by the SOS screen.

## Words to check with a native speaker

These are correct as far as we can tell but are the ones most worth a
second opinion. Urban pet parents often use English words (vet, booking,
refund), so some are deliberately written in Hindi or Telugu letters.

| English | Hindi | Telugu | Question |
|---|---|---|---|
| Flea and tick prevention | पिस्सू और किलनी से बचाव | ఈగలు, పేలు నివారణ | Telugu: ఈగలు usually means flies. Is there a better everyday word for fleas (or simply ఫ్లీ)? Same in the Ask PawSetu answers (ఈగపురుగులు). |
| Deworming | कृमिनाशक | డీవార్మింగ్ | Hindi is formal: is "पेट के कीड़ों की दवा" clearer? Telugu: is నులిపురుగుల నివారణ more familiar than the English word? |
| Carer (family role) | देखभालकर्ता | సంరక్షకుడు | Telugu form is masculine; is a neutral form (సంరక్షణ చూసేవారు) better? |
| Viewer (family role) | दर्शक | వీక్షకుడు | Hindi दर्शक sounds like "audience". "सिर्फ़ देखने वाले"? Telugu also masculine. |
| Co-owner | सह-मालिक | సహ-యజమాని | Natural? |
| Tele-vet | टेली-वेट | టెలి-వెట్ | Understood, or "ऑनलाइन डॉक्टर" / "ఆన్‌లైన్ వెట్"? |
| Easy mode | आसान मोड | ఈజీ మోడ్ | Telugu: సులభ మోడ్? |
| Streak | लगातार | వరుస | Both read as "continuous"; is "लगातार दिन" / "వరుస రోజులు" better? |
| Payouts (partners) | भुगतान | చెల్లింపులు | Both mean any payment; clear enough for partners receiving money? |
| Document vault | दस्तावेज़ तिजोरी | డాక్యుమెంట్ వాల్ట్ | Hindi literal ("safe"); "डॉक्यूमेंट लॉकर"? Telugu transliterated. |
| Quiet hours | शांत समय | నిశ్శబ్ద సమయం | Natural for "no notifications at night"? |
| Health report | हेल्थ रिपोर्ट | ఆరోగ్య నివేదిక | Telugu నివేదిక is formal; ఆరోగ్య రిపోర్ట్? |
| Bill or invoice | बिल | బిల్లు | Fine? |
| Lost pet mode and QR tag | खोया पालतू मोड और QR टैग | తప్పిపోయిన పెంపుడు జంతువు మోడ్, QR ట్యాగ్ | Natural? |
| On this day (album) | आज के दिन | ఈ రోజున | Reads as "on this date in past years"? |

## Known limits (not critical; planned for Version 2)

| Limit | Why it is not critical now | Plan |
|---|---|---|
| Website opens slowly on low-end phones (≈7 s with the CPU slowed 4×) | Mostly the Flutter web engine; the loading screen covers it; the Android app doesn't have this cost | Load the partner and admin portals and each language only when needed |
| With Firebase, a pet parent's booking notification to a clinic is in English | The pet parent can't read the clinic's profile language; demo mode uses the right language | Move booking and chat notifications to Cloud Functions (as orders, tickets and plans already are) |
| Vets and clinics can read any pet's vaccines and health history | Needed during consultations; groomers and sellers can't | Give access only for pets they have a booking or consultation with |
| A vet's private consultation notes are stored on the consultation, which the pet parent can read through the database (not in the app) | Not shown in the app | Move notes to their own vet-only record |
| Firestore offline cache is off on the website | The standalone demo keeps everything on the device anyway | Switch it on and test with several tabs |
| Any signed-in app can add to the Demo Outbox | Demo-only collection that only admins read; Live mode sends through providers | Not used in Live mode |
| Android start-up not measured on a real phone here | Only the browser could be measured | Check on a mid-range phone (below) |

## For you to check

1. Install the Android APK on a mid-range phone and time how long it takes
   from tapping the icon to seeing Home (target: under 2 seconds).
2. Ask a native Hindi speaker and a native Telugu speaker to look at the
   words above (10 minutes each).
3. Turn on TalkBack (Android) or VoiceOver (iPhone) and move through Home,
   Health and SOS once.
