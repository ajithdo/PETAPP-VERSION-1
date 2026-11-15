# PawSetu redesign proposal: "Toran"

Made on 10 November 2026 from the 85 screenshots of the current app
("ui-design-5-final"). This is a **design proposal only**. The app's code is
unchanged, and nothing here has been published or put online.

## How to look at it

1. Open the `boards` folder and look at the 14 pictures in order. `01-overview`
   explains the idea, `02-before-and-after` puts today's app next to the new one.
2. Open the `screens` folder to see every page at full length:
   - `phone` and `desktop`: all 34 pages, at phone width and laptop width
   - `dark-mode`, `easy-mode`, `telugu`: the five main tabs in each mode
   - `first-view`: what you see before scrolling on the five main tabs
3. For a clickable gallery, open `index.html` in a web browser (double-click it).
4. To try a page at any size, open `source/app.html` in a browser. Add the page
   name to the address, for example `app.html?screen=health`. Extras:
   `&theme=dark`, `&easy=1`, `&lang=te&user=ravi`.

## The idea

A **toran** is the marigold garland hung over a doorway. In this design, each
pet stands in an arched doorway, and the garland over it has one flower for
each task of the day. Finish a task and a flower opens. A full garland is a
good day. It grows out of the flowers around the pet photo in today's app.

Three rules hold the whole thing together:

- **A shape for everything.** Pets are always in arches, people in circles,
  places and products in rounded tiles.
- **Colour means something.** Coffee brown for records and anything medical,
  marigold for the one main action on a page, leaf green for "done" and "open",
  red only for SOS and danger.
- **One voice in three scripts.** Bricolage Grotesque for English, Noto Sans
  for Hindi and Telugu. Big, tight headings and quiet, readable text.

## What is better than today

| Today | In this design |
|---|---|
| The bottom bar disappears on many pages | It stays on every page; on a laptop the side menu stays |
| "Me" is one long list of 14 links | Everyday things are tiles that show their status; the rest is in two short groups |
| Home shows many white cards of the same weight | One dark hero, one checklist, then smaller pieces that each look like what they are |
| Ticking a task only changes a number | A flower opens on the garland; a week of flowers shows the streak |
| Lots of small grey text, cut off with "…" | Bigger text, darker greys, fewer cut-offs; long details moved to their own lines |
| Grey boxes for product pictures | Drawn pack shots, clinics and pets in one style |

## Nothing removed

Every feature visible in the 85 screenshots is still there. A few are easier to
reach. Additions are marked "new".

| Feature | Where it is now |
|---|---|
| Pet switcher, messages, notifications, SOS | Top of every main tab, same as today |
| Greeting, pet's day, streak | Home hero with the garland |
| Today checklist, Log, See all | Home "Today" card |
| Next up (vaccines, medicines) | Home and Health, with "Mark given" on the first row |
| Quick actions | Home: Book vet, Log walk, Ask a vet, Add photo |
| Walk weather | Home, with a strip showing the cool hours (new) |
| Food running low, Reorder | Home, with a level bar |
| Memories, Near you | Home |
| Health summary, Medical card, Health report | Health header |
| Emergency info, vaccinations, weight chart | Health; vaccines are grouped by dose |
| Medicines, deworming, vet visits, symptom diary, reminders | Health "Records" list |
| Six booking types, clinics on the map, my bookings | Book tab |
| Search, Buy again, picks for your pet, Ask a vet | Shop tab, plus categories and partner stores from the spec |
| Profile, plan, all 14 Me links | Me tab |
| Welcome slides, language, demo accounts | Welcome, Sign in and Demo pages |
| Two SOS options, clinic list, change area, medical summary | SOS page |
| First-aid guides, offline and draft labels | First aid page, plus the "Is it safe?" checker entry |
| Tele-vet start, plan limits, open and past consultations | Tele-vet page |
| Ask PawSetu, not-a-diagnosis note, suggestions | Ask page, with a red-flag answer shown |
| Chats, filters, Ask a vet button | Messages; on a laptop the open chat sits beside the list |
| Notification list, filters, mark all read | Notifications, grouped by day |
| Clinic search, filters, map, cards | Find a vet page |
| Clinic details, pet, service, vets | Clinic page, plus day and time on the same card |
| Booking details, call, message, get help | Booking details, plus review, invoice and book again |
| Upcoming, Requests, Past | My bookings |
| Product details, quantity, add to cart, buy now | Product page |
| Cart | Cart with items (new picture) and the empty cart |
| Pet facts, care links, details | Pet profile |
| Log, Charts, Behaviour, Daily plan | Routine |
| Offline medical card | Medical card, with allergies in a red band |
| Vault PIN | Vault PIN page, plus the unlocked vault (new picture) |
| Photos, Timeline, Albums, Favourites, On this day | Memory album |
| People, Activity, roles, invite | Family and sharing |
| Free and Plus comparison, renewal | PawSetu Plus |
| Language, appearance, Easy mode, text size | Settings |
| Clinic, vet and seller dashboards | Partner portals |
| Admin numbers, charts, commission report | Admin panel, plus a "waiting for you" list |
| Light, dark, Easy mode, English and Telugu | All included; Hindi uses the same fonts and sizes as Telugu |

## What you should know

- **34 pages are drawn, not the whole app.** These are the 32 pages in your
  screenshots plus two extras (cart with items, unlocked vault). The app has
  about 80 more pages (sign up, walk tracker, orders, lost pet, devices,
  expenses and so on). They would follow the same rules but are not drawn yet.
- **The pets, products and clinics are drawings.** Photo websites could not be
  reached while making this, so an original illustrated set stands in. Real
  photos fit the same arch and tile frames.
- **Telugu:** 82 phrases come from the app's own Telugu file. Another 94 were
  written for this proposal and should be read by a Telugu speaker before use.
- **Not checked on a real phone.** These are web pages drawn to look like the
  app. Text contrast was checked with numbers for the main colour pairs
  (all 4.8:1 or better for text). Screen readers and 200% text size were not
  tested.
- **Motion is described, not shown:** a flower opens in about 250 ms when a
  task is ticked, with a light buzz on phones; nothing else moves on its own.

## For whoever builds it

Everything is in `source/`. The mocks are plain web pages (no build step).

- `toran.css`: all colours, sizes and components. The colour and size values
  at the top are the ones to copy into `lib/core/theme/tokens.dart`.
- `kit.js`: the drawings (pets, garland, products, clinics, map, charts) and
  the app frame. `screens/*.js`: one small function per page.
- `te.js`: Telugu strings. `screens-info.js`: page names and notes.
- `tools/render.js` and `tools/render-boards.js` remake the pictures (they need
  Node and Playwright).

| Token | Light | Dark |
|---|---|---|
| Paper (page) | `#FBF7F1` | `#17100C` |
| Surface (cards) | `#FFFFFF` | `#241A13` |
| Ink (text) | `#2B1A12` | `#F8EFDF` |
| Ink 2 (secondary text) | `#66554A` | `#CDBBA6` |
| Line | `#EADFD0` | `#3A2C21` |
| Kaapi (dark surfaces, menu) | `#2F1D14` | `#2C1E15` |
| Genda (marigold, main action) | `#F8A80C` | `#FBB431` |
| Marigold text on light | `#8A4F00` | `#FCC864` |
| Aam patta (leaf green) | `#2C6A43` | `#8AD0A0` |
| Kumkum (SOS) | `#DC2626` | `#DC2626` |

- **Type:** Bricolage Grotesque variable (weight 200 to 800, width 75 to 100).
  Headings use weight about 750 and width about 80; text uses weight 420 at
  full width. Hindi and Telugu use Noto Sans (already in the app) with line
  height 1.6 and slightly smaller headings. Sizes: 34, 26, 21, 17, 15, 13.
- **Shapes:** cards 22 px corners, hero cards 28 px, buttons and chips fully
  round, arch = width × 1.24 tall with a half-circle top.
- **Easy mode:** everything scales by 1.25; rows with a button stack instead
  of squeezing; Home keeps only the hero, Today, Next up, four big actions and
  a full-width SOS button.
- **Flutter notes:** variable fonts work through `fontVariations`. Icons here
  are Phosphor (there is a `phosphor_flutter` package); Material Symbols
  Rounded would also fit. Check both on pub.dev before choosing.

## Licences

- Bricolage Grotesque and Noto Sans: SIL Open Font License (files in
  `source/fonts`).
- Phosphor Icons: MIT.
- All drawings were made for this proposal.
