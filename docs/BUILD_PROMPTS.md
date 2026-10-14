# Pet Care App — Antigravity Build Prompts

Oct 13, 2026 · @gohitha

## How to use this document

Paste Prompt 0 once, then one phase prompt at a time, in order, each in a new Antigravity conversation. The master spec gets saved inside your project, so every phase can re-read it instead of you pasting it again.

1. Install Antigravity and sign in with your Google account.
2. Make an empty folder on your computer, for example `pet-app`. In Antigravity choose **File → Open Folder** and pick that folder (the folder itself, not one above it).
3. Pick the app name from the next section. If you choose a different one, change the single `App name:` line near the top of Prompt 0.
4. Copy all of **Prompt 0 — Master spec** in its two parts: paste Part 1 into the agent panel, wait for the reply "Part 1 saved", then paste Part 2 into the same conversation. Together they will:
   - save the spec as `docs/PROJECT_SPEC.md`
   - create an `AGENTS.md` rules file that Antigravity reads automatically on every task
   - check and install the tools needed (Flutter, Node.js, Firebase tools, Java)
   - set up the empty project
5. Open a **new conversation** and paste **Phase 1**. Read the plan it shows you. If it looks right, click **Proceed** (or type "go ahead"). If your Antigravity has a `/plan` command, you can type `/plan` before the prompt for an even more careful plan.
6. When a phase finishes, the agent gives you a short summary and a "what to test" list. Try those things in the app. If something is wrong, use the helper prompts near the end of this document.
7. Repeat for Phase 2 to Phase 11. Never skip a phase, and never paste two phases at once.
8. Only after Phase 11 works, start **Version 2** with the Live prompts. Saying "Start Version 2" or "actual final version 2" also triggers the switch, because the rules file tells the agent what that means.

Things the agent will ask **you** to do, because they need your accounts:

- Approve terminal commands. Read the one-line description before approving. Deny anything that deletes files outside your project.
- Create a free Firebase project at console.firebase.google.com and log in when the Firebase tool asks.
- Install Android Studio to run the Android app.
- iPhone apps can only be built on a Mac with Xcode. On Windows you can build the website and Android app now and handle iOS later, from a Mac or a cloud build service.

Tip: the agent saves your work with Git after every phase. If a phase goes badly, say "undo everything from this phase and go back to the last checkpoint".

## App name

My pick is **PawSetu**. "Setu" means bridge in Hindi and Sanskrit, and Telugu speakers know it as *sethuvu*. The app bridges pet parents, vets, groomers, trainers and sellers, so the name says what it does in all three of your languages. Prompt 0 uses PawSetu; change that one line if you prefer another.

| Name | Meaning | Why it fits | What my search found (13 Oct 2026) |
| --- | --- | --- | --- |
| **PawSetu** (recommended) | Setu = bridge | Connects owners with vets, services and shops; easy to say in English, Hindi and Telugu | No pet app or brand found |
| **PawKosh** | Kosh = treasury, safe store | Your pet's whole life kept safe in one place; fits the vault and records | No pet app or brand found |
| **PawMitra** | Mitra = friend | Warm and simple; a friend for your pet's care | No exact pet app found; several "Paw…" brands exist, so it is the least distinctive |

Names I checked and dropped because they are already in use: [PetSaathi](https://apps.apple.com/us/app/-/id6755908927) (an Indian pet-care app), [Pawsome](https://apps.apple.com/in/app/pawsome-indias-1-pet-app/id6746558452) (an Indian pet super-app) and [Tailwise](https://www.cbinsights.com/compare/tailwise-vs-tipaw) (a UK pet startup).

A web search is only a first check. Before you spend money on branding, do these five checks:

- [x] Search the name in the Google Play Store and the Apple App Store.
- [x] Search IP India's public trademark search for classes 9 (apps), 35 (online selling), 42 (software services) and 44 (veterinary services).
- [x] Check that the domain is free, for example pawsetu.in, pawsetu.com or pawsetu.app.
- [x] Check the Instagram and X handles.
- [ ] Register the trademark yourself once you're sure. A trademark agent in India can file it for you.

## Decisions I made for you

I chose **Flutter + Firebase**: one codebase gives you the Android app, the iPhone app and the website. Everything below is already written into Prompt 0, so you don't need to repeat it to Antigravity.

### Tech stack

| Part | Choice | Why |
| --- | --- | --- |
| App (Android, iOS, website) | Flutter | One codebase for all three. It's Google's toolkit, so it pairs naturally with Antigravity and Firebase. |
| Backend | Firebase: login, database, file storage, server functions, push notifications, website hosting | Your choice; region set to Mumbai (asia-south1) for speed in India |
| Version 1 running cost | Firebase emulators on your own computer | Free; no card needed while you build the demo |
| Maps | OpenStreetMap via flutter\_map; directions open the phone's Maps app | Free, and works on Android, iOS and web. Version 2 moves to a paid map-tile provider because OpenStreetMap's free servers aren't meant for busy apps |
| Payments (Version 2) | Razorpay, with Route for splitting money to clinics and sellers | Indian, supports UPI, handles marketplace payouts |
| Video calls (Version 2) | Chosen by the agent from Agora, 100ms or ZEGOCLOUD | Each needs a Flutter SDK that supports all three platforms |
| SMS / WhatsApp / email (Version 2) | SMS provider with DLT registration, WhatsApp Business Platform, a transactional email service | In Version 1 these go to a "demo outbox" so nothing real is sent |
| Reading certificates and the AI assistant (Version 2) | Gemini through Firebase AI Logic | Same Google ecosystem; simulated in Version 1 |

One cost to know about: since 3 Feb 2026, Firebase file storage requires the pay-as-you-go **Blaze** plan, even if you stay inside its free allowance ([Firebase FAQ](https://firebase.google.com/docs/storage/faqs-storage-changes-announced-sept-2024)). You only need it when you put the app online. Set a budget alert when you do.

### Design

It's a mix of all three styles you saw. The layout is clean like Apple Health. The colours are warm, the cards are rounded, and friendly illustrations appear only in onboarding and empty screens. Medical screens stay calm and clinical.

- **Colours:** deep teal for main buttons and links, a warm apricot accent, a soft off-white background, and red only for SOS and errors. Each pet gets its own colour tag, so a multi-pet home never gets confusing.
- **Fonts:** Plus Jakarta Sans for English, and Noto Sans fonts for Hindi and Telugu, so all three languages look equally good.
- **Theme:** Light, Dark or System default, in Settings.
- **Easy mode:** a switch in Settings, also offered during sign-up. It gives bigger text and buttons, a simpler home screen and plain wording. There's also a separate text-size slider.

### Home screen and navigation

The bottom tabs are **Home · Health · Book · Shop · Me**. Every main screen has a pet switcher, messages, notifications and the red SOS button in its top bar.

Home shows, in this order:

1. The selected pet's card
2. Today's routine checklist with a progress ring
3. What's due next (vaccines, medicines, appointments)
4. Four quick actions: Book vet, Log walk, Ask a vet, Add photo
5. A walk-weather tip
6. A "food running low, reorder?" card when needed

### Money (all editable later in your admin panel)

| Item | Starting value |
| --- | --- |
| Premium plan "PawSetu Plus" | ₹99 a month or ₹799 a year, 7-day free trial |
| Booking commission | 10% of each vet, grooming, training, boarding or walking booking |
| Marketplace margin | 8% on food, 15% on other categories |
| Free tele-vet | 1 chat a month, up to 20 messages, 60 words each, chat only |
| Plus tele-vet | Longer chats (100 messages, 300 words), video calls, the vet sees the full history, 10% off video fees |

One store rule applies in Version 2. Google Play and the App Store usually require their own billing for in-app subscriptions like Plus. Razorpay still handles bookings, products and the website. Prompt 0 tells the agent to follow those store rules.

### Features I added beyond your 13

| Added feature | Why it's worth it | Phase |
| --- | --- | --- |
| Lost pet mode + QR tag | A finder scans the tag and contacts you without seeing your number; nearby app users get an alert | 9 |
| Pet sitting, boarding and dog walking | Indian rivals offer these, and they reuse your booking engine; walks show a live GPS route and photo updates | 5 |
| AI pet assistant | Answers care questions any time. It always points to a vet, and to SOS for danger signs | 6 |
| Health report PDF + offline medical card | One tap to share with a vet, a boarding centre or for travel | 4 |
| First-aid guides + toxic food checker | Work offline; chocolate, grapes, onion and lilies are common emergencies | 9 |
| Heat warnings for walks | Indian summers are dangerous for pugs, shih tzus and Persians | 3 |
| Food-running-low prediction + one-tap reorder | Your Zomato/Swiggy-style reorder, made smarter: bag size ÷ daily portion | 8 |
| Expense tracker | Bookings and orders log themselves; owners see monthly pet spending | 8 |
| Verified reviews | Only after a real booking or purchase, to build trust | 5, 8 |
| Insurance tracker | Renewal reminders and a claim checklist, inside the vault | 7 |
| Privacy centre | Download my data, delete my account; needed under India's data protection law | 10 |
| Coupons and referral codes | Helps you grow; managed from admin | 10 |

Two things I left out on purpose: a public community feed and pet adoption listings. Both need full-time moderation and are better added after launch.

One legal guard I built in: native Indian birds such as the rose-ringed (Indian ringneck) and Alexandrine parakeets are protected wildlife and can't legally be kept as pets. The bird breed list leaves them out and shows a short note.

## Prompt 0 — Master spec (paste first, in two parts)

Prompt 0 is too long for one message, so it comes in two parts. Paste **Part 1** into a new Antigravity conversation and wait for the reply "Part 1 saved". Then paste **Part 2** into the same conversation. The agent saves the full spec into your project, sets up the tools and the empty app, shows you a plan and waits. No features get built yet.

### Prompt 0 — Part 1

```text
You are the lead engineer and product designer for my new app. I am not a programmer.

This is PART 1 of 2 of my project spec. Do nothing yet except: create docs/PROJECT_SPEC.md and save everything below the line "=== PROJECT SPEC ===" into it exactly as written. Then reply only: "Part 1 saved. Please paste Part 2."

=== PROJECT SPEC ===

# 1. PRODUCT
App name: PawSetu
Meaning: "Setu" means bridge (Hindi/Sanskrit; Telugu "sethuvu"). The app is the bridge between pet parents, vets and every pet service.
Tagline: Every care your pet needs, in one place.
What it is: an all-in-one pet care app for India. Pet parents manage several pets, track daily routines and health, book vets, tele-vet, grooming, training, boarding, sitting and walking, store documents securely, shop for supplies, chat with providers, keep a memory album, get emergency help fast, and connect smart pet devices.
Platforms: Android app, iOS app and a responsive website, all from one Flutter codebase. Partner portals and the admin panel are web-first but also work on tablets and phones.
Market: India first. Currency INR (₹, Indian digit grouping e.g. ₹1,24,999), +91 phone numbers, IST, dates like 13 Oct 2026, 12-hour time, kilometres, kilograms (grams for birds).
Languages: English (default), Hindi, Telugu. Switchable any time in Settings → Language, applied instantly. Every user-facing string is translated naturally (not word-by-word), including notifications, emails and PDFs.
Versions:
- Version 1 = DEMO MODE. Every feature works end to end with realistic fake data (section 12) and simulated outside services (payments, SMS, WhatsApp, email, video calls, document reading, AI, smart devices). No real money, no real messages, never dial real phone numbers.
- Version 2 = LIVE MODE. Same app with real services switched on, done only when I say "Start Version 2" or "actual final version 2" (section 13).
User experience goal: very easy and never clumsy. One clear main action per screen, at most 4 steps for any booking or purchase, friendly words, nothing hidden behind confusing menus.

# 2. AGENT RULES (copy into AGENTS.md)
- Work one phase at a time. Never start the next phase until I paste its prompt.
- Before coding a phase: read the relevant spec sections and docs/PROGRESS.md, then show me a short plain-English plan and wait for my OK.
- Talk to me as a non-programmer. When you need me to do something, give numbered click-by-click steps.
- Every outside service sits behind an interface with a Demo implementation and a Live implementation (e.g. PaymentService -> DemoPaymentService / RazorpayPaymentService). A single config value APP_MODE = demo | live (overridable per service) chooses which one runs. Never call a real service in demo mode.
- Demo mode never charges money, never sends real SMS/WhatsApp/email and never dials a real number. Show a clear "Demo" dialog instead and log every simulated message to the Demo Outbox (visible in the admin panel).
- No hard-coded user-facing text. All strings go into the ARB files for en, hi and te. Keep translations natural and simple.
- Follow the design system in section 4 everywhere. Build shared widgets once in lib/core and reuse them; no one-off styling.
- Security: Firestore and Storage security rules for every collection (deny by default); roles enforced with Firebase custom claims on the server, not only in the UI; validate prices, limits and permissions in Cloud Functions. No secrets or API keys in app code or Git.
- Packages: use well-maintained packages that support Android, iOS AND web. Check pub.dev for the latest stable version and platform support before adding one. If a package lacks web support, give web a graceful fallback. Record choices in docs/DECISIONS.md.
- After finishing each phase: run the app on Chrome and the Android emulator; click through every new screen in light and dark mode, in English and Telugu, with Easy mode on, at 360 px phone width and at desktop width; fix all errors and layout overflows; run flutter analyze and all tests until clean; take screenshots of key screens.
- Then update docs/PROGRESS.md, commit to Git ("Phase N complete: ..."), and give me: (a) a 5-line summary, (b) a "what to test" checklist I can follow, (c) anything I must do.
- If you are stuck on the same error after 3 attempts, stop, explain it in plain words and offer 2 options.
- Never delete files outside this project. Ask me before anything destructive (force push, deleting data or Firebase projects, resetting Git).
- Version 2 trigger: if I say "Start Version 2" or "actual final version 2", read section 13 and follow the Live plan, one Live phase (L1-L5) at a time, starting with a plan.

# 3. TECH STACK
- Flutter (latest stable), Dart, Material 3 with a custom theme.
- State management: Riverpod. Navigation: go_router (proper web URLs and deep links). Models: freezed + json_serializable.
- Firebase: Authentication, Cloud Firestore, Cloud Storage, Cloud Functions (TypeScript, Node LTS), Cloud Messaging, App Check, Remote Config (limits and feature flags), Analytics, Crashlytics (mobile), Hosting (website). Region asia-south1 (Mumbai).
- Version 1 runs on the Firebase Local Emulator Suite with a seed script (section 12).
- Maps: OpenStreetMap via flutter_map; location via geolocator; directions open the phone's maps app by URL (no paid routing API). Show "© OpenStreetMap contributors" and follow the OSM tile usage policy (caching, proper user agent).
- Notifications: firebase_messaging + flutter_local_notifications (scheduled reminders must work offline).
- Biometrics: local_auth on mobile; vault PIN on all platforms.
- Media: image_picker, file_picker, video player, image compression before upload, a PDF viewer that works on web.
- PDFs: pdf + printing packages (health report, prescriptions, invoices, QR tag, lost poster).
- Charts: fl_chart. QR: a QR generator package.
- Localization: Flutter gen-l10n with ARB files en, hi, te.
- Tests: unit tests for business logic (vaccine schedule generator, slot availability, pricing and commission, tele-vet limits, food-running-low prediction), widget tests for key screens, one integration test for the vet booking flow.
- Folders: lib/core (theme, shared widgets, services, l10n, routing, config) and lib/features/<feature>/{data,domain,presentation}. Cloud Functions in functions/. Seed data in tools/seed/.

# 4. DESIGN SYSTEM
Personality: calm, warm, trustworthy. Clean like Apple Health, warm like a friendly pet clinic, clinical and serious on medical screens. Never cluttered.
Theme: Light, Dark, System default (Settings → Appearance). Default = System.
Colour tokens (light / dark):
- Primary teal #0F766E / #2DD4BF; on-primary #FFFFFF / #04201D
- Primary container #CCFBF1 / #134E4A
- Warm accent apricot #F4A261 / #F6BD8A (highlights, celebrations, marketplace badges)
- Background #FAF8F5 / #0E1415; Surface (cards) #FFFFFF / #172124; Outline #E5E1DA / #2A3639
- Text primary #1C2B2D / #E8EEEE; text secondary #5B6B6E / #9FB0B2
- Success #15803D / #4ADE80; Warning #B45309 / #FBBF24; Error #B91C1C / #F87171
- SOS red #DC2626 in both modes, always with white text
- Pet colour tags: amber #F4A261, lavender #9B8AFB, sky #38BDF8, rose #F472B6, mint #34D399, sand #D6B98C (user picks one per pet)
All text must meet WCAG AA contrast in both modes.
Fonts (bundled, not loaded from the internet): Plus Jakarta Sans for English; Noto Sans Devanagari for Hindi; Noto Sans Telugu for Telugu. Sizes: display 32, title 22, heading 18, body 16, caption 13. Line height 1.4 (1.6 for Hindi and Telugu).
Shapes: cards 20 px radius, buttons 14 px, chips fully rounded, bottom sheets 28 px top corners. Soft shadows in light mode, tonal surfaces in dark mode.
Spacing: 4-point grid. Screen padding 16 (phone) / 24 (tablet). Desktop content max width 1200 px, centred.
Icons: Material Symbols Rounded.
Illustrations: one consistent original style (soft, flat, rounded shapes in teal and apricot) for onboarding, empty states and success screens only. Generate them or draw simple vector art. Never use copyrighted characters, real brand logos or watermarked stock photos.
Motion: 200-300 ms ease-out; hero animation for pet photos; respect the system "reduce motion" setting.
Touch targets at least 48 px (56 px in Easy mode). Light haptic feedback on key actions (mobile).
States: every list has a friendly empty state with one call to action; loading uses skeleton placeholders; errors say what happened in plain words and offer "Try again".
Forms: short, one topic per step, smart defaults, inline validation, never lose what the user typed.
Easy mode (Settings → Accessibility, also offered during onboarding): text 25% larger, bigger buttons, a simpler Home (Today, Next due, 4 big quick actions, SOS), plain-language labels, no swipe-only actions, confirmation before deleting anything. Also: a text-size slider and a high-contrast option. Layouts must not break at 200% text size.
Responsive: phone = bottom navigation; tablet = navigation rail; desktop/web = side navigation. Partner portals and admin use a sidebar with data tables, filters and search.

# 5. NAVIGATION AND KEY SCREENS (pet owner)
Bottom tabs: Home · Health · Book · Shop · Me.
Top bar on every main tab: pet switcher (avatar chips + "All pets"), messages icon with unread badge, notifications bell, red SOS button.
Home (in this order): greeting + selected pet card (photo, name, age, weight, colour tag); "Today" card with routine checklist and progress ring; "Next up" (vaccines, medicines, appointments due soonest); quick actions (Book vet, Log walk, Ask a vet, Add photo); walk-weather tip; "food running low, reorder?" card when relevant; latest memory.
Health: vaccinations, medicines, deworming and flea/tick, vet visits, weight chart, symptom diary, reminders, health report.
Book: vet at clinic, tele-vet, grooming, training, boarding and pet sitting, dog walking, clinic finder map, my bookings.
Shop: marketplace home, categories, search, cart, orders, Buy again.
Me: my pets, family and sharing, document vault, memory album, connected devices, lost pet mode and QR tag, expenses, PawSetu Plus, settings, help and complaints, privacy centre.
Onboarding (under 60 seconds): 3 short welcome slides → sign in → choose language, theme and Easy mode → add first pet (only name and species required) → explain why notifications help, then ask permission → Home.
Sign-in: email + password (with email verification and password reset), Google, phone OTP (+91 default), Apple (iOS and web). Demo mode adds an "Explore as demo user" screen with one-tap logins for every role.

# 6. ROLES AND PERMISSIONS
- Pet owner: owns pets, invites family.
- Family member, invited per pet by phone, email or link: Viewer (see everything, log routine), Carer (log routine and medicines, book services), Co-owner (everything except deleting the pet or removing the owner). Pet sitters and walkers can get Carer access that expires automatically on a chosen date.
- Vet (belongs to a clinic): own schedule, consultations, chat, prescriptions, medical notes for pets with an active booking or consultation.
- Clinic admin: clinic profile, vets, services, prices, slots, booking mode, payment options, bookings dashboard, emergency info.
- Service providers (groomer, trainer, boarding/sitter, walker): profile, services, packages, slots, bookings, chat.
- Seller: products, stock, orders, returns, payouts.
- Platform admin (me): section 10.
All partners complete onboarding with KYC documents and need admin approval before they appear in the app. Vets must give their Veterinary Council registration number and certificate. Enforce roles with custom claims and security rules.

# 7. FEATURES (all part of Version 1)

7.1 Multi-pet profiles
- Several pets per account (free plan limit 3, Plus unlimited; admin-configurable). An "All pets" view merges today's tasks.
- Species: Dog, Cat, Bird, Rabbit, with built-in searchable, translated breed lists plus "Mixed / Indie" and "Other (type it)":
  Dogs: Indian Pariah (Indie), Labrador Retriever, Golden Retriever, German Shepherd, Beagle, Pug, Shih Tzu, Pomeranian, Rottweiler, Dobermann, Siberian Husky, Boxer, Dachshund, Cocker Spaniel, Great Dane, Lhasa Apso, Maltese, Chihuahua, French Bulldog, English Bulldog, Dalmatian, Saint Bernard, Border Collie, Poodle, Yorkshire Terrier, Jack Russell Terrier, Belgian Malinois, Cane Corso, Shiba Inu, Akita, Samoyed, Tibetan Mastiff, Rajapalayam, Mudhol Hound, Kombai, Chippiparai, Kanni, Rampur Hound, Gaddi Kutta, Bakharwal, Himalayan Sheepdog, Jonangi, Pandikona.
  Cats: Indian Domestic (Indie), Persian, Siamese, Himalayan, Maine Coon, Bengal, British Shorthair, Ragdoll, Scottish Fold, Sphynx, Russian Blue, Abyssinian, Exotic Shorthair, American Shorthair, Birman, Bombay.
  Birds: Budgerigar, Cockatiel, Lovebird, African Grey, Sun Conure, Green-cheeked Conure, Cockatoo, Macaw, Eclectus, Canary, Zebra Finch, Java Sparrow, Domestic Pigeon. Do NOT list native Indian wild birds (e.g. rose-ringed/Indian ringneck, Alexandrine and plum-headed parakeets, munias, mynas). They are protected under the Wild Life (Protection) Act, 1972. Show a short info note explaining this.
  Rabbits: Holland Lop, Netherland Dwarf, Lionhead, Mini Rex, Mini Lop, Dutch, New Zealand White, Flemish Giant, Angora, Rex, Himalayan.
- Fields: required = name, species. Recommended = breed, birthday (or approximate age), gender, weight, photo. "More details" (collapsed): colour/markings, microchip ID, neutered/spayed, allergies, diet type, regular clinic, insurance (links to vault), temperament notes.
- Show age in friendly form ("2 yrs 3 mo") and life stage (puppy/kitten/young, adult, senior by species).
- Archive a pet (passed away or rehomed) with a gentle "In loving memory" option that keeps memories and records.

7.2 Family sharing
Invite by phone, email or link; roles from section 6; activity feed of who did what ("Ravi gave Bruno his medicine at 8:05 PM").

7.3 Daily routine tracker
- Log types: walk/exercise, play session, meal, water, potty, sleep/nap, grooming, training session, mood and behaviour, weight. Each log has time, who logged it, optional note and photo. Logging anything takes at most 2 taps from Home.
- GPS walks: start/pause/stop; distance, duration, pace; route on the OSM map; keeps tracking in the background on mobile with a visible notification; works offline and syncs later. Web: manual walk entry.
- Behaviour and traits: tags (playful, calm, anxious, leash pulling, barking, aggression with dogs, separation anxiety, scratching furniture, etc.) with intensity, trends over time, shareable with trainer or vet.
- Daily plan per pet (e.g. 2 walks, 2 meals, 20 min play) shown as Home checklist with reminders.
- Suggested goals by species, breed size and age (editable), streaks, weekly and monthly charts.
- Heat safety: show the temperature (demo values in V1) and warn when it is too hot to walk; stronger warnings for flat-faced breeds (Pug, Shih Tzu, Bulldogs, Persian); suggest early morning or evening.

7.4 Health
- Vaccinations: auto-generate an indicative schedule from species + birthday (templates in section 11). Status chips: Done, Due soon, Overdue. Record date, vaccine brand, batch number, vet, clinic, next due; attach certificate (saved to vault); edit anything. Unknown history → "Ask your vet for a catch-up plan" and let the user enter past vaccines.
- Medicines: name, dose, unit, frequency (once/twice daily, every X hours, weekly, custom), start/end dates, with or without food; notification actions Given / Skip / Snooze; stock count with refill reminder.
- Deworming and flea/tick prevention reminders (tick fever is common in India).
- Vet visits, diagnoses, lab reports (linked to vault), tele-vet prescriptions.
- Weight chart with an indicative healthy range by species and breed size.
- Symptom diary (vomiting, diarrhoea, not eating, limping, itching, coughing, etc.) with severity and photos; "Share with vet".
- Custom reminders: licence renewal, insurance renewal, grooming due, nail trim, birthday.
- Reminder channels: for each reminder type the user picks push, email, SMS and/or WhatsApp in Settings → Notifications, plus quiet hours. Default = push. V1: push and local notifications are real; email, SMS and WhatsApp go to the Demo Outbox.
- Health report: one-tap PDF (profile, vaccines, medicines, allergies, recent visits, weight chart) to share, and an offline "medical card" screen.
- Show "Indicative, always confirm with your vet" on schedules, ranges and AI answers.

7.5 Clinic finder (OpenStreetMap)
- Map and list views; ask for location with a one-line reason first; fallback: pick city and area.
- Filters: distance (1/3/5/10/25 km), open now, 24x7 emergency, rating 4+, species treated (dog/cat/bird/rabbit; exotic vets are rare, so this matters), services (vaccination, surgery, dental, lab tests, X-ray/ultrasound, grooming, boarding, home visit), consultation fee range, tele-vet available, languages spoken (English/Hindi/Telugu).
- Sort: nearest, top rated, earliest available slot, lowest fee.
- Clinic page: photos, hours, vets with registration numbers, services and prices, reviews, map, Call, Directions (opens phone's maps app), Book.

7.6 Booking engine (vets at clinic, grooming, training, boarding/pet sitting, dog walking)
- Each provider chooses per service: Instant booking (user picks an open slot and it is confirmed) or Request booking (user proposes times; provider accepts, declines or suggests another time within a set window, default 2 hours, else auto-cancel and notify the user).
- Each provider chooses per service which payment options to allow: Pay online, Pay at clinic/centre, or both.
- Flow (max 4 screens): pet → service and provider → date and slot → notes, symptoms, photos, payment option → confirm. Show the full price including any platform fee before confirming.
- At-centre or home visit (provider sets service radius and travel fee).
- Packages and subscriptions (e.g. monthly grooming).
- Reschedule and cancel under the provider's cancellation policy; refunds to the original method (simulated in V1).
- Reminders 24 h and 2 h before; add to calendar (.ics).
- Provider calendar: working hours, breaks, holidays, slot length, buffer time, capacity per slot, block time.
- Dog walks booked in the app show the walker's live GPS route and photo updates; boarding shows daily photo updates.
- Verified reviews only after a completed booking; providers can reply; admin moderates.
- Platform commission recorded on every booking (section 8).
```

### Prompt 0 — Part 2

```text
This is PART 2 of 2. First append everything below the line "=== PROJECT SPEC (continued) ===" to the end of docs/PROJECT_SPEC.md exactly as written. Then do the setup tasks below. Explain everything in plain English, give me click-by-click steps whenever you need me to do something, and ask before anything risky.

SETUP TASKS (setup only, no feature code yet):
1. Create AGENTS.md in the project root. Put section 2 (AGENT RULES) of the spec in it, plus this line at the top: "The full product spec is in @docs/PROJECT_SPEC.md. Read the sections relevant to the task before every task."
2. Create docs/PROGRESS.md (a checklist of Phases 1-11 and Live phases L1-L5) and docs/DECISIONS.md (a log of technical choices and why).
3. Check what is installed: Git, Flutter (stable), Node.js (LTS), Java 21 (for Firebase emulators), Firebase CLI, FlutterFire CLI, Android Studio + Android SDK + an Android emulator, Google Chrome. Install what is missing one at a time and tell me in one line what each is for. If something needs me (download, account, password, restart), stop and give me numbered steps.
4. Create the Flutter project for Android, iOS and web, named after the app in section 1 (lowercase, e.g. pawsetu; bundle id com.pawsetu.app). Set up the folder structure from section 3. Initialise Git and commit.
5. Guide me step by step to create a Firebase project and connect it (flutterfire configure). Set up the Firebase Local Emulator Suite (Auth, Firestore, Storage, Functions) so Version 1 runs fully on my computer for free. Create the Cloud Functions folder (TypeScript).
6. Write an implementation plan for Phases 1-11, show it to me, and wait. Do not build features until I paste the Phase 1 prompt.

=== PROJECT SPEC (continued) ===

7.7 Tele-vet (chat and video)
- Start: choose pet → describe the problem (+ photos/videos) → "Chat now" (next available vet) or choose a vet and time.
- Free plan (chat only), admin-configurable limits: 1 free consultation a month, up to 20 owner messages per consultation, up to 60 words per message, chat open 24 h. Show remaining allowance gently ("12 messages left").
- Plus plan: longer chats (100 messages, 300 words, open 72 h), the vet sees the pet's full history (more context), video calls, priority queue, 10% off vet video fees. Show any vet fee before booking.
- Video call screen: mute, camera on/off, switch camera, speaker, end, timer, weak-network indicator. V1: simulated call with a placeholder video; V2: real provider.
- Vet side: queue, accept, pet history panel, private notes, e-prescription builder (medicine, dose, frequency, duration, instructions, follow-up date) → PDF with vet name, qualification, Veterinary Council registration number, clinic, date and signature; saved to the pet's records and vault.
- Consent screen before the first consultation. Consultations are never anonymous. Vets can recommend an in-person visit or emergency care. Red-flag symptoms show SOS.
- Rating after each consultation.

7.8 Messaging (owner ↔ vet/clinic, owner ↔ groomer/trainer/boarding/walker)
- Conversations open from a booking, consultation or pre-booking enquiry (providers can turn enquiries off).
- Text, photos, PDF files, voice notes (up to 2 minutes), read receipts, typing indicator, push notifications, unread badges, search, mute.
- Safety: report and block; admin reviews reported chats; phone numbers stay masked; a warning against sharing payment details.
- Free-plan limits apply only to tele-vet chats.

7.9 Document vault
- Types: vaccination certificate, insurance policy, lab report, prescription, invoice, licence/registration, adoption/purchase papers, travel document, other. Stored per pet, with tags, search and expiry dates with reminders.
- Lock: fingerprint/face (mobile) or a 4-6 digit vault PIN (all platforms). Auto-lock after 2 minutes in background. Reset PIN by signing in again.
- Encryption: in transit and at rest. Previews generated securely. Nothing from the vault left in the gallery or cache. V2 adds envelope encryption with Cloud KMS (section 13).
- Upload: camera scan with auto-crop, gallery, PDF. Auto-read: extract type, pet name, vaccine name, date given, next due, vet, policy number, expiry, then show "We found these details. Save them?" for the user to confirm before updating health records. V1: simulated extraction with realistic values for the sample documents; V2: Gemini via Firebase AI Logic.
- Share with a vet: expiring view-only link (1 hour / 24 hours / 7 days, optional PIN), revoke anytime, access log. Share via WhatsApp, SMS, email or copy.
- Insurance tracker: policy details, cover, renewal date, claims with status and a claim-document checklist.

7.10 Marketplace
- Two clearly labelled listing types: (a) sold by PawSetu sellers (multi-vendor cart, checkout, delivery tracking) and (b) partner store links (affiliate; opens the partner site with "You will buy on <partner>").
- Categories: food (dry, wet, puppy/kitten, senior), treats, toys, grooming, health and hygiene (non-prescription only), beds, collars/leashes/harnesses, bowls and feeders, litter and cat care, bird food and cages, rabbit hay and care, clothing, travel. No prescription-only medicines.
- Product page: photos, price in ₹ with MRP and discount, seller, rating and reviews, "suitable for" (species, life stage, breed size), ingredients/specs, delivery estimate by PIN code, return policy.
- Shop home: personalised picks per pet ("For Bruno: Labrador, adult") using species, breed size, age and allergies.
- Search with filters (species, category, price, brand, rating) and sorting.
- Cart, coupons, address book with PIN code, delivery slot, order tracking timeline, cancel and return, PDF invoices.
- Buy again like Zomato/Swiggy: a "Buy again" row with one-tap Reorder; a Home card "Bruno's food may run out in about 5 days. Reorder?" calculated from bag size ÷ daily portion (editable); optional auto-reorder every 2/4/6 weeks.
- Seller portal: products (with CSV bulk upload), stock, orders, returns, payouts, reviews.
- Commission per category and seller (section 8); affiliate clicks and estimated commission tracked.
- V1 checkout: a Demo payment sheet ("Demo payment, no money is charged") with success, failure and pending outcomes. V2: Razorpay.

7.11 Memory album
- Photos and videos per pet (video up to 60 s on free, 3 min on Plus), captions, date taken, auto-grouped by month, "On this day" memories.
- Milestones: birthday, adoption (gotcha) day, first walk, first vaccine, custom; milestone badges and a timeline view; birthday reminder with a small celebration screen.
- Albums, favourites, grid and timeline views, full-screen swipe viewer.
- Sharing: private family link (view-only, optional expiry), and WhatsApp, Instagram or any app via the system share sheet; optional "Made with PawSetu" watermark.
- Storage quota per plan (free 1 GB, Plus 25 GB, admin-configurable); compress on upload.

7.12 Emergency SOS
- Red SOS button in the top bar of every main screen and on the medical card.
- Hold for 2 seconds to activate (a ring fills up, with haptic feedback). A quick tap shows "Hold to activate". In Easy mode a tap opens a simple confirm dialog instead.
- After activation: a full-screen sheet with exactly two big options:
  1) Call nearest clinic: open-now and 24x7 emergency clinics first, sorted by distance; shows name, distance, open status; one tap calls.
  2) Get nearest clinic address: name, full address, distance, mini map, "Open in Maps" for directions, Copy, Share.
  Below them, smaller: the pet's medical summary to show the vet, and a link to the first-aid guides.
- Uses current location; falls back to last known location or a chosen area. Cache nearby emergency clinics so it works on weak internet.
- Log every activation (time, pet, location) for admin analytics.
- Demo mode: "Demo: this would call +91 90000 00012". Never dial.

7.13 Smart devices ("Connected devices")
- Types: GPS collar, activity tracker, smart feeder, water fountain, pet camera, smart litter box.
- V1: demo pairing flow and demo live data: collar location on the map with a "safe zone" geofence alert, steps and active minutes, feeding events, water level, camera placeholder, litter visits. Activity data flows into the routine tracker automatically.
- Architecture: a DeviceProvider interface with DemoDeviceProvider; real vendors plug in later (cloud APIs via Cloud Functions webhooks, or Bluetooth LE). Document how to add one in docs/DECISIONS.md.

7.14 Added features
- Lost pet mode + QR tag: each pet gets a QR code (printable tag PDF). Scanning opens a public web page with the pet's photo, name, a "Contact my family" button (relay; real phone stays hidden) and "Share my location". The owner can mark the pet lost: opt-in alert to app users within 5 km, a printable poster PDF, and a "Found" status.
- AI pet assistant ("Ask PawSetu"): care questions and symptom triage. Always says it is not a diagnosis, suggests a vet when unsure, and immediately shows SOS + tele-vet for red flags (breathing trouble, collapse, seizures, suspected poisoning, heavy bleeding, swollen belly, heatstroke, not passing urine). Free: 5 questions a month; Plus: unlimited. V1: scripted demo answers for 20 common questions; V2: Gemini.
- First-aid guides (work offline): choking, poisoning, heatstroke, bleeding, fractures, seizures, burns, snake or insect bite, tick removal. Toxic food and plant checker (chocolate, grapes/raisins, onion/garlic, xylitol, alcohol, caffeine, avocado for birds, lilies for cats, etc.). Mark as "Draft, to be reviewed by a vet" in V1.
- Expense tracker: bookings and orders added automatically, manual entries, monthly totals per pet and category, chart.
- Notification centre: history, filters, mark all read.
- Coupons and referral codes (created in admin).
- Privacy centre: download my data, delete my account, manage consents.

# 8. PLANS AND MONEY (all admin-configurable)
- Free plan and "PawSetu Plus": ₹99 a month or ₹799 a year, 7-day free trial.
- Plus perks: unlimited pets; video tele-vet + longer chats + full-history context; 10% off vet video fees; unlimited AI assistant; 25 GB storage; family sharing up to 8 people (free: 2); longer videos; priority support; free delivery above ₹499.
- Booking commission default 10% (per service type and per provider). Marketplace margin default 8% on food, 15% on other categories (per category and per seller). Affiliate commission per partner.
- Every transaction stores gross amount, platform fee/commission, tax fields (placeholder), payout amount and status.
- V1: Plus purchase and all payments are simulated.

# 9. PARTNER PORTALS (web-first, responsive)
- Clinic / provider portal: dashboard (today's bookings, requests waiting, earnings), calendar and slots, booking requests (accept / decline / suggest time), services and prices, booking mode and payment options per service, staff and vets, chat inbox, tele-vet queue and prescriptions (vets), reviews and replies, payouts, profile and KYC documents, emergency settings (24x7 flag, emergency phone).
- Seller portal: products, stock, orders, returns, payouts, reviews.

# 10. ADMIN PANEL (platform owner)
- Dashboard: users, pets, bookings, order value, commission earned, subscriptions, SOS activations, top clinics and products; charts by day, week and month.
- Approvals queue: clinics, vets (check registration numbers), groomers, trainers, boarding/sitters, walkers, sellers. View KYC documents; approve, reject with a reason, suspend.
- Users: search, view, suspend, change roles.
- Catalogue: products, categories, sellers, affiliate partners and links, featured products and banners.
- Complaints and support tickets from users and partners, linked to the booking, order or chat; status (open, in progress, resolved); assign; reply; refunds (simulated in V1).
- Moderation: reviews, reported chats and reported content.
- Settings: commission rates, plan prices and limits (pets, tele-vet messages and words, AI questions, storage, family members), vaccine schedule templates, first-aid content, coupons, banners, feature flags.
- Demo Outbox: every simulated SMS, WhatsApp, email and push message.
- Audit log of admin actions. Admin access only with the admin custom claim.

# 11. VACCINATION SCHEDULE TEMPLATES (indicative; admin-editable; to be reviewed by a vet before launch)
Dog:
- 6-8 weeks: DHPPi (distemper, adenovirus/hepatitis, parvovirus, parainfluenza) + Leptospirosis, dose 1
- 9-11 weeks: DHPPi + Lepto, dose 2
- 12-16 weeks: DHPPi + Lepto, dose 3; Anti-rabies, dose 1 (from 12 weeks)
- Rabies booster: as advised by vet (show "Ask your vet")
- Every year: DHPPi + Lepto booster; Anti-rabies booster
- Optional (vet advises): Kennel cough for boarding/daycare
- Deworming: every 2 weeks until 12 weeks, monthly until 6 months, then every 3 months
- Tick and flea prevention: monthly (or per product)
Cat:
- 6-8 weeks: FVRCP (rhinotracheitis, calicivirus, panleukopenia), dose 1
- 10-12 weeks: FVRCP, dose 2
- 14-16 weeks: FVRCP, dose 3; Anti-rabies, dose 1 (from 12 weeks)
- 1 year: FVRCP + rabies boosters; then rabies yearly and FVRCP every 1-3 years as the vet advises
- Optional (vet advises): FeLV for outdoor cats
- Deworming: same pattern as dogs
Rabbit: no standard routine vaccine schedule widely available in India; show "Check with an exotic-animal vet"; health check every 6-12 months; deworming as advised; monthly nail trim.
Bird: no routine vaccines for common pet birds; annual avian vet check; deworming as advised; nail and beak checks.

# 12. DEMO DATA (Version 1)
Build a seed script in tools/seed/ that loads all of this into the emulators and can reset it with one command. Each phase adds the demo data for its own features.
Rules: all people, clinics, sellers, phone numbers, emails and addresses are fictional. Phone numbers use +91 90000 000xx. Emails use @example.com. Clinic and brand names must not match real businesses. Registration numbers use the format DEMO-VC-0001. Use real city areas with approximate coordinates so maps work. Images: generated or simple illustrated placeholders, no copyrighted photos or logos. Sample documents are clearly stamped "SAMPLE".
- 15 vet clinics: 3 each in Hyderabad, Bengaluru and Mumbai; 2 each in Chennai, Pune and Delhi NCR. Each has photos, address, coordinates, hours (5 are 24x7 emergency), rating 3.6-4.9 with 5-30 reviews, species treated (3 also treat birds and rabbits), services and prices (consultation ₹300-₹900), a mix of instant and request booking, a mix of payment options, languages spoken, and 1-4 vets (about 30 vets in total).
- 8 groomers (salon and home visit), 6 trainers, 5 boarding/pet sitters, 6 dog walkers across these cities, with services, packages, prices, slots and reviews.
- 6 sellers and 3 affiliate partner stores (fictional names; affiliate links point to example.com).
- 40 products across every category and all 4 species, ₹99-₹6,999, with MRP, discount, stock, ratings, reviews, specs and "suitable for" tags; 10 of them are affiliate listings.
- 4 pet-owner accounts:
  1. Priya (English, Bengaluru, Plus): Bruno (Labrador, 3 yrs, 29 kg), Misty (Persian cat, 5 yrs); her husband as Carer.
  2. Ravi (Telugu, Hyderabad, Free): Simba (Indie dog, 5 months, puppy vaccines with one overdue), Kiwi (Cockatiel).
  3. Anjali (Hindi, Delhi NCR, Free, Easy mode on): Coco (Holland Lop rabbit), Tiger (Indie cat, 11 yrs, senior, on daily medicine).
  4. Arjun (English, Mumbai, Plus): Max (German Shepherd, 7 yrs, arthritis medicine), Luna (Beagle, 4 months); a pet sitter with access that expires in 3 days; an archived pet "In loving memory".
  For every pet: 30 days of routine logs (walks with GPS routes, meals, play, mood), vaccine history matching age (some due, one overdue), medicines where relevant, weight history, 2-5 vault documents, 10-20 album photos/videos with captions and milestones. Bruno and Max each have one demo connected device.
- Bookings in every state (upcoming, pending request, completed, cancelled); tele-vet consultations with chat history and prescriptions; message threads with photos and a voice note.
- Orders: delivered, in transit, returned; one auto-reorder subscription; Bruno's food running low.
- Admin: pending approvals (2 clinics, 1 seller, 1 groomer), 6 complaints in different states, 1 reported review, Demo Outbox messages, 90 days of analytics.
- Partner demo accounts: 1 clinic admin, 1 vet, 1 groomer, 1 trainer, 1 seller, 1 walker, each with matching data.
- Demo login screen with one-tap buttons for every role, clearly labelled "Demo".

# 13. VERSION 2: LIVE PLAN (do NOT start until I say "Start Version 2" or "actual final version 2")
Switch each service to live one Live phase at a time (L1-L5), starting each with a plan. Keep a separate demo/dev Firebase project (e.g. pawsetu-dev) and a production project (pawsetu-prod).
- L1 Production base: Blaze plan with budget alerts, App Check enforced, security-rule tests, backups, production sign-in (phone OTP abuse protection, Google and Apple configured), admin 2-step verification, no demo data in production.
- L2 Payments: Razorpay Orders + Checkout, webhook verification in Cloud Functions, refunds, Razorpay Route for partner payouts with partner KYC, payment options enforced on the server. For the Plus subscription inside the Android and iOS apps, follow current Google Play and Apple App Store billing rules (store billing where required); Razorpay on the website.
- L3 Notifications: FCM push; transactional email provider with templates in en/hi/te; SMS through an Indian provider with DLT-registered sender ID and templates; WhatsApp Business Platform (Cloud API or an approved provider) with pre-approved templates; respect opt-ins and quiet hours.
- L4 Video, AI and vault security: video provider with an official Flutter SDK for Android, iOS and web (compare Agora, 100ms, ZEGOCLOUD; justify in DECISIONS.md), tokens from Cloud Functions, recording off by default; Gemini via Firebase AI Logic for document reading (structured output) and the assistant (safety prompt, per-plan limits, no personal data in logs); Cloud KMS envelope encryption and signed expiring URLs for the vault; upload size and type checks.
- L5 Launch: commercial OpenStreetMap-based tiles and place search with a free tier (e.g. MapTiler or Stadia Maps); real partner onboarding; legal pages (privacy policy and terms under India's DPDP Act 2023 and DPDP Rules 2025, refund and cancellation policy, tele-vet consent and disclaimer, seller terms, grievance officer contact); Play Store and App Store releases (data safety form, privacy labels, Sign in with Apple); website on Firebase Hosting with a custom domain.

# 14. QUALITY BAR (every phase)
- No dead ends; Back always works; web URLs and deep links work.
- App opens in under 2 seconds on a mid-range Android phone; lists paginate; images are cached and compressed.
- Offline: pet profiles, today's tasks, vaccine records, medical card, first-aid guides and nearby emergency clinics stay readable; logs made offline sync later.
- Accessibility: screen-reader labels on every button and image, logical focus order, AA contrast, layouts work at 200% text.
- Ask for permissions only when needed, with a one-line reason first.
- Words: friendly, short, plain; use the pet's name ("Bruno's next vaccine is due in 3 days").
```

## Version 1 (demo) phase prompts

Paste each prompt into a **new conversation**, in order. The agent shows a plan first. Read it, then say "go ahead". Each prompt ends with a "Done when" list: test those things yourself before moving to the next phase.

### Phase 1 — Foundation

```text
PHASE 1: FOUNDATION. Read AGENTS.md and docs/PROJECT_SPEC.md sections 1-6, 12 and 14. Build only this phase:
- Theme from section 4 (Light, Dark, System), bundled fonts, and a shared widget library: buttons, cards, chips, inputs, bottom sheets, empty state, skeleton loader, error state, pet avatar with colour ring, SOS button (placeholder action). Add a hidden "Design gallery" screen that shows every widget in both themes.
- Localization (en, hi, te) with instant switching in Settings; Easy mode, text-size slider and high-contrast option.
- Responsive app shell: bottom navigation (phone), navigation rail (tablet), side navigation (desktop); the top bar from section 5; go_router routes for every section, with friendly "Coming in Phase N" screens for anything not built yet.
- Sign-in with email/password, Google, phone OTP and Apple against the Auth emulator; onboarding from section 5; the demo login screen with one-tap buttons for every role; roles via custom claims set by a Cloud Function; route guards per role; empty shells for the partner portal and admin panel.
- Document the Firestore data model for the WHOLE app in docs/DATA_MODEL.md (collections, fields, indexes, who can read and write), plus security rules and rules tests for what exists now.
- Seed script in tools/seed/: all demo accounts and roles, the 4 owners' pets (basic profile), 15 clinics with vets, all service providers, sellers and the 40 products. One command to reset.
- Settings screen: language, theme, Easy mode, text size, notifications (placeholder), about.
Done when: I can open the app on Chrome and Android, switch language, theme and Easy mode, log in as each demo role and land in the right shell, and open the design gallery.
Show me your plan first and wait for my OK. When finished, do the full end-of-phase check from AGENTS.md.
```

### Phase 2 — Pets and family

```text
PHASE 2: PETS AND FAMILY. Read AGENTS.md and docs/PROJECT_SPEC.md sections 7.1, 7.2, 6 and 12. Build only this phase:
- Add/edit pet in 2 short steps (only name and species required): searchable breed picker per species, the bird legal note, photo with crop, colour tag, birthday or approximate age, life stage, friendly age display.
- Pet profile screen: hero photo, quick stats, and sections that later phases fill (Health, Routine, Documents, Memories).
- Pet switcher in the top bar plus an "All pets" view.
- Archive a pet with the gentle "In loving memory" option.
- Family sharing: invite by phone, email or link (in demo, the invite appears in the other demo account), Viewer / Carer / Co-owner roles, sitter access that expires on a date, and an activity feed. Security rules enforce every role.
- Free plan limit of 3 pets with a gentle Plus prompt.
- Seed full pet details, family members and the sitter from section 12.
Done when: Ravi (in Telugu) adds a pet in under 30 seconds; Priya's husband can see Bruno but cannot delete him; Arjun's sitter shows an expiry date; the archived pet appears under "In loving memory".
Show me your plan first and wait for my OK. When finished, do the full end-of-phase check from AGENTS.md.
```

### Phase 3 — Daily routine tracker

```text
PHASE 3: DAILY ROUTINE TRACKER. Read AGENTS.md and docs/PROJECT_SPEC.md sections 7.3, 5 and 12. Build only this phase:
- Quick-log sheet reachable in 2 taps from Home for every log type, with note, photo and who logged it.
- GPS walk tracker: start, pause, stop, distance, duration, pace, route on the OpenStreetMap map; background tracking with a visible notification on Android and iOS; offline queue that syncs later; manual walk entry on web.
- Behaviour and trait tags with intensity and trend charts.
- Daily plan per pet, which drives the Home "Today" checklist and progress ring, with reminders.
- Suggested goals by species, breed size and age; streaks; weekly and monthly charts.
- Heat-safety card with demo temperatures and stronger warnings for flat-faced breeds.
- Build the real Home screen from section 5 using everything that exists so far.
- Seed 30 days of logs and GPS walk routes for every demo pet.
Done when: on the Android emulator I start a walk with simulated location, stop it and see the route and distance; the Home ring updates after I log a meal; the charts show 30 days of history.
Show me your plan first and wait for my OK. When finished, do the full end-of-phase check from AGENTS.md.
```

### Phase 4 — Health and reminders

```text
PHASE 4: HEALTH AND REMINDERS. Read AGENTS.md and docs/PROJECT_SPEC.md sections 7.4, 11 and 12. Build only this phase:
- Vaccine schedule generator from section 11 (unit tested): Done, Due soon, Overdue; record a vaccine with brand, batch, vet and certificate photo. Save certificates into the documents collection that the vault (Phase 7) will use.
- Medicines with schedules, notification actions Given / Skip / Snooze, stock count and refill reminder.
- Deworming and flea/tick, vet visits, weight chart with indicative range, symptom diary with photos, custom reminders.
- Notifications: scheduled local reminders that work offline, Firebase Cloud Messaging set up, a notification centre, per-type channel choices (push, email, SMS, WhatsApp) and quiet hours. Simulated email, SMS and WhatsApp go to the Demo Outbox collection.
- Health report PDF and the offline medical card.
- The Home "Next up" card.
- Seed vaccine histories, medicines and weights from section 12.
Done when: Simba shows one overdue vaccine in red, and marking it done schedules the next one; a medicine reminder fires on the emulator with working Given / Skip / Snooze; Tiger's health report PDF opens and looks professional.
Show me your plan first and wait for my OK. When finished, do the full end-of-phase check from AGENTS.md.
```

### Phase 5 — Clinic finder, bookings and partner portal

```text
PHASE 5: CLINIC FINDER, BOOKINGS AND PARTNER PORTAL. Read AGENTS.md and docs/PROJECT_SPEC.md sections 7.5, 7.6, 9, 6 and 12. Build only this phase:
- Clinic finder: map and list, every filter and sort from 7.5, and the clinic page.
- One booking engine for vets, grooming, training, boarding/pet sitting and dog walking: instant and request modes, payment options per service, slot generation (unit tested), home-visit radius and fee, packages, reschedule and cancel policies, 24 h and 2 h reminders, add to calendar.
- Demo payment sheet (success, failure, pending) and commission recorded on every booking.
- Partner portal (web-first) for clinic admin, vet, groomer, trainer, boarding/sitter and walker: dashboard, calendar and availability, requests inbox (accept / decline / suggest time), services, prices and modes, staff, reviews with replies, demo payouts, KYC documents, emergency settings.
- Walk bookings show the walker's live GPS route (simulated movement in demo) and photo updates; boarding shows daily photo updates.
- Verified reviews after completed bookings.
- Partner sign-up flow ending in "Waiting for approval" (approval screens come in Phase 10).
- Seed bookings in every state and reviews from section 12.
Done when: Priya books an instant vet slot; Ravi sends a grooming request, I accept it from the groomer demo account, and Ravi gets notified; filtering clinics by "24x7" and "birds" shows the right ones.
Show me your plan first and wait for my OK. When finished, do the full end-of-phase check from AGENTS.md.
```

### Phase 6 — Messaging, tele-vet and AI assistant

```text
PHASE 6: MESSAGING, TELE-VET AND AI ASSISTANT. Read AGENTS.md and docs/PROJECT_SPEC.md sections 7.7, 7.8, 7.14 (AI assistant), 8 and 12. Build only this phase:
- Chat: text, photos, PDFs, voice notes, read receipts, typing indicator, unread badges, search, mute, report and block, masked phone numbers.
- Tele-vet: start flow, vet queue, free vs Plus limits enforced in a Cloud Function and shown gently in the chat, consent screen, simulated video call screen, vet tools (history panel, notes) and the e-prescription PDF saved to the pet's records.
- "Ask PawSetu" assistant: scripted demo answers for 20 common questions, red-flag detection that shows SOS and tele-vet, monthly limits per plan.
- Seed chat threads, consultations and prescriptions from section 12.
Done when: as Ravi (free) a 61-word message gets a friendly limit notice; as Priya (Plus) I start a demo video call; the vet demo account writes a prescription that appears in Bruno's health records.
Show me your plan first and wait for my OK. When finished, do the full end-of-phase check from AGENTS.md.
```

### Phase 7 — Document vault and memory album

```text
PHASE 7: DOCUMENT VAULT AND MEMORY ALBUM. Read AGENTS.md and docs/PROJECT_SPEC.md sections 7.9, 7.11 and 12. Build only this phase:
- Vault: document types per pet, tags, search, expiry reminders; fingerprint/face or PIN lock with auto-lock; secure previews; upload by camera scan, gallery or PDF; simulated auto-read with a confirm screen that updates health records; expiring share links with optional PIN, revoke and access log; insurance tracker with claims.
- Memory album: photo and video upload, captions, monthly grouping, "On this day", milestones and timeline, birthday celebration screen, albums and favourites, full-screen viewer, private family link, system share sheet (WhatsApp and others), optional watermark, storage quota per plan.
- Seed documents and album items from section 12.
Done when: the vault asks for a PIN on web and a fingerprint on Android; uploading the sample rabies certificate fills in the vaccine record after I confirm; a share link stops working after I revoke it; Bruno's album groups photos by month.
Show me your plan first and wait for my OK. When finished, do the full end-of-phase check from AGENTS.md.
```

### Phase 8 — Marketplace and expenses

```text
PHASE 8: MARKETPLACE AND EXPENSES. Read AGENTS.md and docs/PROJECT_SPEC.md sections 7.10, 7.14 (expense tracker), 8 and 12. Build only this phase:
- Shop home with personalised picks per pet, categories, search with filters and sort, product page, affiliate label and redirect, cart, coupons, addresses with PIN code, delivery slot, demo checkout, order tracking timeline, cancel and return, PDF invoices.
- "Buy again" row, the Home "food running low" card (prediction unit tested) and auto-reorder subscriptions.
- Seller portal with CSV bulk upload, stock, orders, returns and demo payouts.
- Commission per category and seller recorded on every order; affiliate clicks tracked.
- Expense tracker: automatic entries from bookings and orders, manual entries, monthly chart per pet and category.
- Seed orders, the subscription and Bruno's low food from section 12.
Done when: I reorder Bruno's food from the Home card in 2 taps; the seller demo account sees the new order; the expense chart includes it.
Show me your plan first and wait for my OK. When finished, do the full end-of-phase check from AGENTS.md.
```

### Phase 9 — SOS, first aid, lost pet and smart devices

```text
PHASE 9: SOS, FIRST AID, LOST PET AND SMART DEVICES. Read AGENTS.md and docs/PROJECT_SPEC.md sections 7.12, 7.13, 7.14 and 12. Build only this phase:
- SOS exactly as described in 7.12: hold for 2 seconds, the two big options, pet medical summary, first-aid link, cached nearby clinics, activation log, demo call dialog.
- First-aid guides that work offline, plus the toxic food and plant checker (searchable, species-aware), labelled "Draft, to be reviewed by a vet".
- Lost pet mode: QR tag PDF, public pet page (a web route anyone can open) with demo contact relay and share-location, "mark as lost" with a demo nearby alert, poster PDF, "Found" status.
- Connected devices: demo pairing, demo live data, safe-zone geofence alert, activity flowing into the routine tracker, DeviceProvider interface documented.
- Seed devices and SOS logs.
Done when: holding SOS on Android with location turned off falls back to a chosen area; opening Bruno's QR link in a browser shows his lost page; Max's collar leaving the safe zone triggers an alert.
Show me your plan first and wait for my OK. When finished, do the full end-of-phase check from AGENTS.md.
```

### Phase 10 — Admin panel, plans and privacy

```text
PHASE 10: ADMIN PANEL, PLANS AND PRIVACY. Read AGENTS.md and docs/PROJECT_SPEC.md sections 8, 10, 7.14 and 12. Build only this phase:
- Admin panel from section 10: dashboard with charts, approvals queue, users, catalogue, complaints and tickets with demo refunds, moderation, settings for every configurable value (stored so the app picks up changes without an update), Demo Outbox, audit log.
- PawSetu Plus: plan screen comparing Free and Plus, demo purchase and 7-day trial, and plan limits enforced on the server everywhere (pets, tele-vet, AI, storage, family size).
- Commission reports; coupons and referral codes.
- Help and complaints for users and partners (raise a ticket from a booking, order or chat).
- Privacy centre: download my data, delete my account (with a grace period), manage consents.
- Seed approvals, complaints and 90 days of analytics.
Done when: I approve a pending clinic and it appears in the clinic finder; changing the free tele-vet limit to 30 messages in admin takes effect in the app; a complaint from Ravi appears in admin and my reply reaches him.
Show me your plan first and wait for my OK. When finished, do the full end-of-phase check from AGENTS.md.
```

### Phase 11 — Polish and full test

```text
PHASE 11: POLISH AND FULL TEST. Read AGENTS.md and docs/PROJECT_SPEC.md sections 4 and 14. Do this phase:
- Full QA pass: every screen in light and dark, English, Hindi and Telugu, Easy mode, 200% text, phone, tablet and desktop widths. Fix everything you find.
- Translation review: natural wording and no cut-off text in Hindi and Telugu. List any words I should check with a native speaker.
- Performance (start-up time, image caching, pagination), offline behaviour and screen-reader labels.
- Security: rules tests for every collection and tests that each role cannot do what it shouldn't.
- App icon, splash screen, store-style screenshots.
- README.md: how to start the demo with one command (emulators + seed + app) and a table of demo accounts.
- A browser recording walking through the main journeys.
- Write docs/QA_REPORT.md listing what you checked and fixed.
Done when: all tests pass and the QA report shows no open critical issues.
Show me your plan first and wait for my OK.
```

## Version 2 (live) prompts

Start these only after Phase 11 passes. Each one switches a group of services from demo to real, and most need an account or documents from you. The agent will tell you exactly what and when. The demo version keeps working in a separate project, so you can always show it to people.

### L1 — Production base

```text
START VERSION 2. LIVE PHASE L1: PRODUCTION BASE. Read AGENTS.md and docs/PROJECT_SPEC.md section 13. Build only this phase:
- Create a production Firebase project (pawsetu-prod), separate from the demo one. Walk me through upgrading it to the Blaze plan and setting a monthly budget alert (ask me the amount).
- Two environments: dev (demo mode, demo data) and prod (live mode, no demo data, no demo login, no "Demo" labels). Separate build flavours and configs.
- Enforce App Check (Play Integrity on Android, App Attest on iOS, reCAPTCHA Enterprise on web).
- Production sign-in: Google and Apple configured for real; phone OTP limited to India with abuse protection; email templates in en, hi and te; 2-step verification for admin accounts.
- Full security-rules test suite run against production rules; Firestore backups and point-in-time recovery; Crashlytics and error alerts on.
- Deploy Cloud Functions to asia-south1 and the website to Firebase Hosting on a staging URL.
- Real partner sign-up with KYC upload and admin approval.
- Tell me which accounts I must create (e.g. Apple Developer, Google Play Console) and walk me through each one.
Done when: I can sign up as a real user on the staging website and on Android with every sign-in method, and no demo data or demo screens appear.
Show me your plan first and wait for my OK.
```

### L2 — Real payments

```text
LIVE PHASE L2: REAL PAYMENTS. Read AGENTS.md and docs/PROJECT_SPEC.md sections 8 and 13 (L2). Build only this phase:
- Walk me through creating a Razorpay account and completing KYC. Use test mode first; live keys go in Secret Manager, never in the app.
- Razorpay Orders + Checkout on Android, iOS and web (UPI, cards, netbanking, wallets). Orders are created and payment signatures verified in Cloud Functions; webhooks (captured, failed, refunded) are verified and idempotent.
- Bookings: pay online vs pay at clinic enforced on the server; refunds follow each provider's cancellation policy.
- Marketplace: multi-seller orders; Razorpay Route linked accounts for clinics, providers and sellers with their KYC; automatic split after commission; payout reports in the partner portal and admin.
- PawSetu Plus: follow current Google Play and Apple App Store billing rules for the in-app subscription on Android and iOS; Razorpay Subscriptions on the website; one entitlement system on the server.
- Invoices with GST fields (ask me for my GSTIN; leave placeholders if I don't have one yet).
Done when: in Razorpay test mode I complete a booking payment, a marketplace order split between 2 sellers, a refund and a Plus purchase, and the admin panel shows the correct commission for each.
Show me your plan first and wait for my OK.
```

### L3 — Real notifications

```text
LIVE PHASE L3: REAL NOTIFICATIONS. Read AGENTS.md and docs/PROJECT_SPEC.md sections 7.4 and 13 (L3). Build only this phase:
- Push: Firebase Cloud Messaging on Android, iOS (guide me through the Apple push key) and web.
- Email: compare 2 transactional email providers with a free tier and recommend one; verify my sending domain (guide me through SPF and DKIM); templates in en, hi and te for bookings, reminders and receipts.
- SMS: an Indian SMS provider. Guide me through DLT registration (entity, sender header, templates); SMS stays off until templates are approved. Templates in all 3 languages.
- WhatsApp: WhatsApp Business Platform (Meta Cloud API or an approved provider). Guide me through business verification; submit reminder and booking templates for approval; record user opt-in.
- Respect each user's channel choices, quiet hours and opt-outs (including STOP for SMS); rate limits; a delivery log in admin replacing the Demo Outbox in production.
Done when: a vaccine reminder reaches me by push, email, SMS and WhatsApp in my chosen language, and quiet hours delay it correctly.
Show me your plan first and wait for my OK.
```

### L4 — Video calls, AI and vault security

```text
LIVE PHASE L4: VIDEO CALLS, AI AND VAULT SECURITY. Read AGENTS.md and docs/PROJECT_SPEC.md sections 7.7, 7.9, 7.14 and 13 (L4). Build only this phase:
- Video: compare Agora, 100ms and ZEGOCLOUD on current Flutter SDK support (Android, iOS, web), call quality in India, free minutes and price per minute. Explain in plain words, recommend one and wait for my choice. Then integrate it with tokens from Cloud Functions, reconnect handling and recording off by default.
- Document auto-read: Gemini via Firebase AI Logic with structured output for certificates, policies and prescriptions; the user confirms before anything is saved; manual entry as fallback.
- AI assistant: Gemini with a safety system prompt (never a diagnosis, never medicine doses, red flags show SOS and tele-vet), answers in the user's language, per-plan limits, abuse protection. Build a test set of 50 questions including 15 red-flag cases that must all trigger SOS.
- Vault: Cloud KMS envelope encryption for files, decryption only in Cloud Functions for authorised users and valid share links, signed expiring URLs, file size and type checks, audit log.
Done when: a real video consult works between two phones; a real vaccine certificate fills in its fields correctly; all 15 red-flag test questions trigger SOS.
Show me your plan first and wait for my OK.
```

### L5 — Launch

```text
LIVE PHASE L5: LAUNCH. Read AGENTS.md and docs/PROJECT_SPEC.md section 13 (L5). Build only this phase:
- Maps: compare MapTiler and Stadia Maps for OpenStreetMap tiles and place search (free tier, price after); switch to the one I choose with restricted API keys; keep "Open in Maps" for directions.
- Production content: only vet-reviewed first-aid guides and vaccine templates; a checklist for me to onboard real clinics.
- Draft legal pages in en, hi and te: privacy policy and terms (India's DPDP Act 2023 and DPDP Rules 2025: notice, specific consent, withdrawal, deletion, breach process), refund and cancellation policy, tele-vet consent and disclaimer, seller terms, grievance officer contact. Mark each clearly as "Draft: a lawyer must review".
- Android: app bundle, Play Console listing in 3 languages, Data safety form, content rating, closed testing first (check the current Play rules for new developer accounts).
- iOS: build (needs a Mac or a cloud build service; explain my options), App Store privacy labels, Sign in with Apple, review notes with a test account, TestFlight.
- Website on Firebase Hosting with my custom domain.
- Write docs/LAUNCH_CHECKLIST.md and tick off everything done.
Done when: the website is live on my domain, the Android app is in Play closed testing, the iOS app is in TestFlight, and the checklist is complete.
Show me your plan first and wait for my OK.
```

## Helper prompts

Use these whenever you need them. Fill in the parts in \[square brackets\].

**Something is broken**

```text
Something is broken. What I did: [steps]. What happened: [what you saw, or paste the red error text]. What I expected: [what should happen]. Find the real cause, fix it, re-test this flow and anything related, then tell me in plain words what was wrong.
```

**Coming back after a break, or a new conversation**

```text
Read AGENTS.md, docs/PROJECT_SPEC.md and docs/PROGRESS.md. Tell me in 5 lines where we are and what is left in the current phase, then continue from there.
```

**Run the app for me**

```text
Start the Firebase emulators, load the demo data and run the app in Chrome and on the Android emulator. Then write down the exact steps (or one command) so I can do this myself next time.
```

**Put it on my Android phone**

```text
Help me install the app on my own Android phone step by step (developer options, USB debugging, run). Make sure it can still reach the demo data.
```

**I don't like how something looks**

```text
I want to change the [screen name] screen: [what you don't like, or what you want instead]. Show me 2 options as screenshots before changing any code. Keep the design system in section 4 consistent everywhere.
```

**Strict quality check**

```text
Act as a strict QA tester. Click through every screen built so far in light and dark mode, English, Hindi and Telugu, Easy mode, and phone and desktop widths. List every problem by severity (critical, major, minor), then fix them all and show me before/after screenshots of the important ones.
```

**Undo a bad phase**

```text
This phase went wrong. Undo all changes since the last Git checkpoint, tell me exactly what was removed, and suggest what to do differently before we try again.
```

**Add a new idea later**

```text
I want a new feature: [describe it]. First update docs/PROJECT_SPEC.md with it and show me the change. Then tell me which phase it belongs to, plan it and wait for my OK.
```

## Before you launch

Version 1 costs nothing to build; costs start in Version 2. The bigger work before launch is legal: a registered business, a lawyer-reviewed privacy policy, and vet review of the medical content.

### Costs to expect

These prices are from memory and change often, so check each provider's pricing page before paying.

| Item | Approximate cost | When you need it |
| --- | --- | --- |
| Antigravity | Usage limits or AI credits depending on your plan; a build this size may hit them | From Prompt 0 |
| Firebase Blaze plan | A free monthly allowance, then pay per use. Set a budget alert | When you put the app online (Version 2, or to share the demo) |
| Google Play developer account | About US$25, one time | L5 |
| Apple Developer Program | About US$99 a year | L1 (Sign in with Apple), L5 |
| Domain name (.in / .com / .app) | Roughly ₹800–₹2,000 a year | L5 |
| Razorpay | A percentage of each payment | L2 |
| SMS, WhatsApp, email, video calls, map tiles, Gemini | Free tiers, then pay per use | L3–L5 |

### Launch checklist (India)

- [ ] Register a business (proprietorship, LLP or private limited). Razorpay KYC, payouts to partners and store accounts in a company name all need it.
- [ ] Get GST registration and ask a chartered accountant about a marketplace operator's GST duties.
- [ ] Follow the Consumer Protection (E-Commerce) Rules: show seller details, return policies and a grievance officer's contact.
- [ ] Be ready for India's data protection law. The DPDP Rules were notified on 14 Nov 2025, and the main duties apply from 14 May 2027: clear notice, specific consent, deletion on withdrawal, breach reporting ([Hogan Lovells summary](https://www.hoganlovells.com/en/publications/indias-digital-personal-data-protection-act-2023-brought-into-force-), [timeline](https://anantamias.com/current-affairs/dpdp-rules-2025-notified/?pdf=1)). Your app will likely launch close to that date, so build it in from day one.
- [ ] Tele-vet: I couldn't find vet-specific telemedicine rules in India. The human-doctor Telemedicine Practice Guidelines (2020) are a sensible model: consent, no anonymous consults, signed e-prescriptions ([PSA Legal FAQ](https://psalegal.com/telemedicine-guidelines-2020-faq/)). Check every vet's council registration, and have a lawyer confirm.
- [ ] Keep prescription-only medicines out of the marketplace.
- [ ] Complete DLT registration before sending any SMS, and Meta business verification before using WhatsApp.
- [ ] Have a vet review the vaccine schedules, first-aid guides, toxic-food list and the AI assistant's 15 red-flag tests.
- [ ] Have a lawyer review the privacy policy, terms, refund policy, tele-vet consent and seller terms that the agent drafts.
- [ ] Register the trademark for your app name.
- [ ] Plan the Play Store rollout: new personal developer accounts must run a closed test with a set number of testers for a period before going public. The agent checks the current rule in L5.

### Sources

- [Antigravity docs: Rules (AGENTS.md, .agents/rules, size limits)](https://www.antigravity.google/docs/rules?tab=ide)
- [Antigravity docs: /plan command](https://www.antigravity.google/docs/plan/)
- [Firebase: Cloud Storage pricing and default bucket changes](https://firebase.google.com/docs/storage/faqs-storage-changes-announced-sept-2024)
- [Hogan Lovells: DPDP Act brought into force](https://www.hoganlovells.com/en/publications/indias-digital-personal-data-protection-act-2023-brought-into-force-)
- [Anantam IAS: DPDP Rules 2025 phased rollout](https://anantamias.com/current-affairs/dpdp-rules-2025-notified/?pdf=1)
- [PSA Legal: Telemedicine Guidelines 2020 FAQ](https://psalegal.com/telemedicine-guidelines-2020-faq/)
- Name checks: [PetSaathi (App Store)](https://apps.apple.com/us/app/-/id6755908927), [Pawsome (App Store)](https://apps.apple.com/in/app/pawsome-indias-1-pet-app/id6746558452), [Tailwise (CB Insights)](https://www.cbinsights.com/compare/tailwise-vs-tipaw)
