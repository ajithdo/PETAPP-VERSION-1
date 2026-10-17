# PawSetu: what's in the code

Overview of the app as of 17 October 2026 (branch `claude/zen-ramanujan-4g7djn`).

Parts 1–8 come from the code. Part 9 uses the **impeccable** skill in this
repository (its "critique" checklist: standard usability rules and how much a
screen asks the user to take in at once). This was a shortened version of that
skill: its automatic checker only reads web-page code, and Flutter draws the
app as one picture, so the checker can't see it. Its two separate reviewers
were not run either, so treat part 9 as a code-based review, not a full one.

## 1. What the app does and who it's for

PawSetu is one app for everything about looking after a pet in India. It
covers daily routines, health records and vaccines, booking vets and groomers,
online vet chats, a pet shop, emergency SOS, lost-pet tags and a document safe.
It works in English, Hindi and Telugu. It is mainly for city pet parents and
their families, with separate portals for partners (clinics, vets, groomers,
trainers, boarding, walkers, sellers) and one for the people running PawSetu.

## 2. Platforms and versions

- **Targets:** Android, iOS and web. There are no Windows, Mac or Linux app
  folders, so laptops use the website.
- **Flutter** 3.47.7 (stable), **Dart** 3.13.5.

## 3. Every screen

`:id` means "a specific one", such as one pet or one booking. Most of the
screens marked "outside the tabs" lose the bottom bar or side menu when
opened; weakness 1 explains this.

### Start and sign-in

- `/splash`: loading screen while the app starts.
- `/welcome`: three intro slides and a language choice (skipped in the demo).
- `/signin`: sign in by email; in the demo, every demo account is listed on top.
- `/signup`: create an account.
- `/forgot`: reset a forgotten password.
- `/phone`: sign in with a phone code.
- `/demo`: full-page list of demo accounts.
- `/verify-email`: wait for and confirm email verification.
- `/setup`: first-time preferences (theme, Easy mode, text size).
- `/setup/pet`: add your first pet.
- `/setup/notifications`: choose notification settings.
- `/partner-signup`: a business applies to join.
- `/suspended`: "your account is paused" page.

### Pet parent's five tabs

- `/home`: greeting, today's checklist, what's coming up, walk weather, food
  running low, memories, quick actions.
- `/health`: vaccines, medicines, deworming, vet visits, weight and symptoms
  for a pet.
- `/book`: start booking a vet, groomer, trainer, boarding or walker.
- `/shop`: pet shop home with picks for your pets.
- `/me`: profile, plan and a menu of 14 links.

### Booking (inside the Book tab)

- `/book/find/:kind`: search clinics or providers on a list or map, with filters.
- `/book/place/:id`: a clinic's or provider's page (services, vets, reviews, map).
- `/book/new/:placeId`: choose service, pet and time, then pay.
- `/book/done/:id`: booking confirmation.
- `/book/bookings`: my bookings.
- `/book/bookings/:id`: booking details, cancel, reschedule, review.

### Shop (inside the Shop tab)

- `/shop/search`: search and filter products.
- `/shop/product/:id`: product page.
- `/shop/cart`: cart, coupons, delivery slot, checkout.
- `/shop/placed/:groupId`: order placed.
- `/shop/orders`: my orders.
- `/shop/orders/:id`: track, cancel, return, invoice.
- `/shop/expenses`: spending tracker and chart.
- `/shop/addresses`: saved addresses.

### Pets and family

- `/me/pets`: all my pets.
- `/pets/new`: add a pet.
- `/pets/:id`: pet profile.
- `/pets/:id/edit`: edit a pet.
- `/pets/:id/routine`: log walks, meals and more; charts, behaviour and the
  daily plan.
- `/walk/:petId`: GPS walk tracker.
- `/pets/:id/report`: health report as a PDF.
- `/pets/:id/card`: medical card that works offline.
- `/pets/:id/birthday`: birthday celebration.
- `/me/family`: invite family or a pet sitter and set their access.
- `/join/:token`: accept a family invite.

### Messages, vet chat and Ask PawSetu

- `/messages`: inbox of chats with clinics and providers.
- `/messages/new`: start a chat.
- `/messages/:id`: one conversation.
- `/televet`: online vet home.
- `/televet/new`: describe the problem and choose chat or video.
- `/televet/consent`: agree to the online-consultation terms.
- `/televet/call/:id`: video call (simulated in the demo).
- `/ask`: Ask PawSetu, scripted pet-care answers.
- `/prescriptions/:id`: view a prescription.

### Documents and photos

- `/me/vault` and `/pets/:id/vault`: PIN-locked document safe.
- `/vault/doc/:id`: one document.
- `/vault/doc/:id/read`: confirm details read from a document.
- `/vault/shares`: share links.
- `/vault/insurance`: insurance policies.
- `/vault/insurance/:id`: one policy and its claims.
- `/share/:token`: public page for a shared document.
- `/me/album` and `/pets/:id/album`: memory album.
- `.../album/item/:itemId`: full-screen photo or video viewer.

### Safety

- `/sos`: two big options, "call nearest clinic" and "get clinic address".
- `/first-aid`: list of first-aid guides.
- `/first-aid/:id`: one guide.
- `/toxic-check`: "Is it safe?" checker for foods and plants.
- `/me/lost`: lost-pet mode and QR tags.
- `/me/lost/:petId`: one pet's lost report and sightings.
- `/lost/:token`: public page a finder opens by scanning the QR tag.
- `/me/devices`: connected collars, feeders and so on.
- `/me/devices/add`: pair a device.
- `/me/devices/:id`: one device and its safe zone.

### Account

- `/notifications`: notification centre.
- `/me/settings`: app settings.
- `/me/settings/notifications`: notification channels and quiet hours.
- `/me/plus`: PawSetu Plus plan and trial.
- `/me/refer`: refer a friend.
- `/me/privacy`: consents, download my data, delete my account.
- `/me/help`: my complaints.
- `/me/help/new`: raise a complaint.
- `/me/help/:id`: one complaint.

### Partner portal (`/partner/...`)

- **Service partners:** dashboard, calendar, requests, services, staff/vets,
  reviews, payouts, profile, emergency settings, chat, tele-vet queue, help.
- **Sellers:** products, orders, returns, payouts.
- **Detail pages:** booking, order, add/edit product, CSV upload, vet
  consultation, prescription builder.

### Admin panel (`/admin/...`)

- Dashboard, approvals, users, catalogue, complaints (and one complaint),
  moderation, plans and settings, Demo Outbox, audit log, commission report.

### Other

- `/design-gallery`: hidden gallery of the app's design pieces.
- `/coming-soon`: placeholder, also used as the "page not found" screen.

## 4. Main features

- **Sign-in:** email with verification, phone code, Google and Apple, plus
  one-tap demo accounts.
- **Pet profiles:** photos with cropping, family sharing with roles, sitter
  access that ends on a date.
- **Routine:** logging, GPS walks and streaks.
- **Health:** vaccine schedules, medicine reminders, PDF reports.
- **Booking and payments:** booking with payments (demo payment screen), reviews.
- **Vet help:** chat with photos and voice notes, online vet with
  prescriptions, Ask PawSetu.
- **Documents and memories:** document safe with PIN or fingerprint and
  expiring share links; insurance; memory album.
- **Shop:** cart, coupons, orders, returns, subscriptions, "food running low"
  reorder.
- **Safety:** SOS, first aid, toxic checker, lost-pet QR tags, connected devices.
- **Notifications:** on the phone, plus SMS, WhatsApp and email (in the demo
  these go to the Demo Outbox instead of being sent).
- **Plans:** Plus plan, referrals, privacy tools.
- **Back office:** partner portals and the admin panel.
- **Everywhere:** three languages, Easy mode, dark mode and high contrast.

## 5. Technology

- **App state:** Riverpod 3 (`flutter_riverpod` 3.4).
- **Navigation:** go_router 18. The five tabs share one frame (bottom bar or
  side menu).
- **Backend:** Firebase (sign-in, Firestore database, server functions written
  in TypeScript, file storage, push messages).
  - The demo runs entirely inside the app on an in-memory copy of the
    database, saved on the device. The library for this is copied into
    `third_party/` so it can be fixed.
- **Outside services:** each one has a demo and a live version, chosen by a
  setting (`AuthService`, `PaymentService`, `NotificationService`,
  `MessagingService`, `StorageService`).
- **Key packages:** `freezed` and `json_serializable` (data models),
  `flutter_map` (maps), `geolocator` (location), `fl_chart` (charts), `pdf` and
  `printing`, `image_picker`, `file_picker`, `share_plus`, `qr_flutter`,
  `local_auth` (fingerprint), `record` and `audioplayers` (voice notes),
  `video_player`, `flutter_local_notifications`, `cached_network_image`,
  `connectivity_plus`, `intl`.

## 6. Design setup

- **Theme:** yes. `lib/core/theme/app_theme.dart` uses Material 3.
  `lib/core/theme/tokens.dart` holds the brand colours with a light and a dark
  set, spacing steps and corner sizes.
- **Fonts:** Plus Jakarta Sans for English, with Noto Sans Devanagari (Hindi)
  and Noto Sans Telugu. All are bundled in the app.
- **Modes:** light, dark, high contrast, Easy mode and a text-size slider.
- **Shared pieces:** 17 files of reusable widgets in `lib/core/widgets`. For
  example, the standard card is used 220 times and the main button 131 times.
- **Consistency:** high. In the feature code there are about 98 fixed colours
  and 64 fixed text sizes, mostly where they make sense: PDFs, sample
  documents, the dark video-call screen and category colours.

## 7. Responsiveness

Built for all sizes, not just phones. There are three screen sizes, set in
`lib/core/widgets/layout.dart:13-23`:

| Size | Width | Navigation |
|---|---|---|
| Phone | narrower than 640 px | bottom tab bar |
| Tablet | 640–1023 px | slim side bar |
| Desktop | 1024 px and wider | full side menu |

Pages are limited to a sensible width, and grids add columns as the screen
gets wider. The automated checks run at 360, 800 and 1280 px.

## 8. Tests

- **192 app tests in 16 files**, mostly checks of logic and rules.
- **Screen tests** (they open real screens): only 2 files. One is the big
  layout sweep, which opens every main screen in all three languages at
  several sizes (about 470 screen checks). The other covers the SOS button.
- **Golden tests** (compare against saved screenshots): **none**.
- **Integration tests** (the whole app on a device): **none**. Browser checks
  were run with scripts kept outside the repository.
- **Server and security tests:** 12 files with 170 tests.

## 9. The five biggest UI/UX weaknesses

1. **The navigation disappears on many screens.** Most screens outside the
   five tabs (pet profile, messages, notifications, SOS, the document safe,
   online vet, settings) sit outside the shared frame
   (`lib/core/routing/extra_routes.dart:77`). Opening Bruno's profile on a
   laptop removes the side menu, and on a phone it removes the bottom bar. On
   top of that, 12 screens (photo viewers, cropping, invoice and others) open
   without a web address of their own, so refreshing the website or sharing a
   link on them doesn't work.
2. **"Me" is a junk drawer.** It is one flat list of 14 links
   (`extra_routes.dart:140`). Everyday features like the document safe, album,
   lost-pet mode and devices are mixed in with addresses, refer-a-friend and
   privacy, so important features are hard to find.
3. **Home tries to show everything.** Below the greeting it can show the pet
   card, 4 quick actions, a lost-pet banner, today's checklist, what's next,
   walk weather, food running low and a memory. Most of these are white cards
   of the same weight, so nothing stands out as "do this first". The look is
   clean but generic; little of it says "pets in India".
4. **Little feedback or delight.** There is almost no animation: no animated
   switches, one shared-element transition and three small animations in
   total. Ticking off a walk or finishing a vaccine just changes a number. For
   an app built on daily habits and streaks, this is where people should feel
   rewarded.
5. **Lots of small grey text, sometimes cut off.** Much important detail sits
   in the smallest text style in grey, and long descriptions are cut with "…".
   The new demo account tiles show this. It's worse in Hindi and Telugu, where
   words run longer, and for older users, even though Easy mode exists.
