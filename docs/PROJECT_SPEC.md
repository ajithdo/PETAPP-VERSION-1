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
