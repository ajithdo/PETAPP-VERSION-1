# Product, audience and vibe

## What PawSetu is for

*Setu* means bridge. PawSetu connects pet parents, vets and every pet service in one app, with the tagline **"Every care your pet needs, in one place."** It replaces a phone full of WhatsApp chats, paper vaccine cards, clinic phone numbers and shopping apps with one calm place that knows each pet.

## The niche

- **India first.** ₹ prices with Indian grouping, +91 numbers, IST, monsoon and heat-safety tips, tick fever reminders, Indian dog breeds (Indie, Rajapalayam, Mudhol Hound), a protected-bird note under the Wild Life (Protection) Act.
- **Three languages from day one:** English, Hindi and Telugu, switchable any time.
- **All-in-one rather than single-purpose.** Most pet apps do one job (a shop, a vet chat, a tracker). PawSetu joins records, routine, bookings, shopping and emergencies, so each feature can use what the others know ("Bruno's food may run out in about 5 days").
- **Trust-heavy.** Health records, a PIN-locked document safe, vets with registration numbers, emergency SOS. The look must feel dependable before it feels fun.

## Who uses it

| Person | From the demo | What they need from the design |
|---|---|---|
| Busy city pet parent | Priya, Bengaluru, two pets, Plus plan | Speed: log a walk in 2 taps, see what's next, reorder food |
| First-time parent, Telugu speaker | Ravi, Hyderabad, a 5-month puppy with an overdue vaccine | Plain words in Telugu, clear "Overdue" warnings, guidance not jargon |
| Older parent, Hindi speaker | Anjali, Delhi NCR, Easy mode on, a senior cat on daily medicine | Big text and buttons, a simple Home, nothing hidden behind swipes |
| Experienced owner | Arjun, Mumbai, a German Shepherd with arthritis, a pet sitter with access for 3 days | Family sharing, medicine schedules, records to show the vet |
| Family members and sitters | Priya's husband as Carer | Log routine and medicines without owning the account |
| Partners | Clinic admin, vet, groomer, trainer, walker, seller | Fast, dense web tools: calendar, requests, prescriptions, orders |
| Platform admin | The owner | Approvals, complaints, settings, numbers |

## Key features

- **Pets and family:** several pets, colour tag per pet, breed lists in three languages, family roles (Viewer, Carer, Co-owner), sitter access that ends on a date, "In loving memory".
- **Daily routine:** walks (GPS), meals, play, potty, mood and more, a Today checklist with a progress ring, streaks and charts, heat-safety warnings.
- **Health:** vaccine schedules with Done / Due soon / Overdue, medicines with Given / Skip / Snooze, deworming and flea/tick, weight chart, symptom diary, health report PDF, an offline medical card.
- **Bookings:** clinic finder on OpenStreetMap, vets, grooming, training, boarding and walking, instant or request booking in at most 4 steps.
- **Tele-vet and messages:** chat and (simulated) video with vets, e-prescriptions, provider chats with photos and voice notes; Ask PawSetu for scripted care answers.
- **Document vault:** PIN or fingerprint lock, auto-read of certificates, expiring share links, insurance tracker.
- **Shop:** picks per pet, deals, cart split by seller, order tracking, Buy again, "food running low" reorder.
- **Safety:** hold-to-activate SOS, offline first-aid guides, a toxic food and plant checker, lost-pet mode with a QR tag.
- **Also:** memory album, connected devices, expenses, PawSetu Plus, partner portals and an admin panel.

## The vibe, in design terms

The spec asks for **"calm, warm, trustworthy: clean like Apple Health, warm like a friendly pet clinic, clinical and serious on medical screens; never cluttered."** That gives three rules this system is built around:

1. **Calm is the default**: warm off-white pages, white cards, dark teal-grey text, colour only where it means something.
2. **Warmth is an accent**: apricot appears where something good happens (a streak, a birthday, a deal), so it keeps its meaning.
3. **Seriousness is a zone**: Health, vault and SOS drop the warmth and become precise.

## Where today's app falls short

From the code review in `docs/APP_OVERVIEW.md` (part 9), and what this system does about each:

| Weakness | What this system adds |
|---|---|
| Navigation disappears on screens outside the five tabs | `BottomNav` and `SideNav` rules: navigation stays on every detail screen; only focused tasks hide it |
| "Me" is a flat list of 14 links | `SideNav` and list rules for grouped sections with `heading` labels |
| Home shows many white cards of equal weight | `Card` tiers: one Hero, then Standard, then Quiet, so the eye knows where to start |
| Almost no feedback or delight | `duration-celebrate` and celebration rules in Motion |
| Lots of small grey text, sometimes cut off | `support` 14 px as the smallest readable size, no cut-off text on key information, `text-secondary` only for supporting lines |
