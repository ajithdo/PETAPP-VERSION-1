# Product

<!-- impeccable:product-schema 1 -->

Source: docs/PROJECT_SPEC.md (the owner's spec) and the owner's answers on
3 Nov 2026 ("full redesign, a new look; design from scratch, the best look like
a premium app; colours: you decide; start now"). Facts marked *(inferred)* were
derived from the spec and code and still need the owner's confirmation.

## Platform

android

One Flutter codebase ships an Android app (primary), a responsive website and
an iOS app. Material 3 governs structure, navigation and controls on every
build; the website and iPhone builds use the same Material language.
*(inferred: Android-first because the market is India and the APK is the main
deliverable; iPhone builds still owe safe areas, Reduce Motion and edge-swipe
back.)*

## Users

- **Pet parents in Indian cities** (primary): people looking after one to a
  few dogs, cats, birds or rabbits, often sharing the care with family or a
  sitter. They open the app many times a day for small jobs (log a meal, tick
  a walk, check what is due) and rarely for big ones (book a vet, reorder food,
  an emergency). Many are not technical; some prefer Hindi or Telugu; some
  older users rely on Easy mode.
- **Family members and pet sitters** with limited, sometimes time-boxed access.
- **Partners**: clinic admins, vets, groomers, trainers, boarding and walkers,
  and sellers, who run their bookings, chats and stock in a web-first portal.
- **The platform admin**, who approves partners, sets prices and limits, and
  watches the business.

## Product Purpose

PawSetu ("setu" = bridge) is the bridge between pet parents, vets and every pet
service: one place for daily care, health records, bookings, tele-vet, a shop,
documents, memories and emergency help. Success: the daily care habit takes
seconds, nothing due is forgotten, and in an emergency the nearest open clinic
is one hold of a button away.

## Positioning

One app for the whole life of an Indian household's pets, in English, Hindi and
Telugu, where daily care, medical history and every service share the same pet
record, so a vet, a groomer or a sitter sees what they need without the owner
retelling it.

## Operating Context

- Mostly phones, one-handed, many short visits a day; partners and the admin
  mostly on laptops.
- Indian conventions: ₹ with Indian digit grouping, +91 numbers, IST, dates
  like 13 Oct 2026, 12-hour time, km and kg.
- Weak or no network happens; the medical card, first aid, today's tasks and
  nearby emergency clinics must stay readable offline.
- Version 1 is a demo: every outside service is simulated and labelled "Demo".

## Capabilities and Constraints

- Feature set in docs/PROJECT_SPEC.md sections 5–10 (all built in Version 1).
- Three scripts on every screen: Latin, Devanagari, Telugu; fonts are bundled.
- Every user-facing string lives in the en/hi/te translation files.
- Owner tabs: Home, Health, Book, Shop, Me; top bar with pet switcher,
  messages, notifications and the red SOS button.
- At most 4 steps for any booking or purchase; one clear main action per
  screen.

## Brand Commitments

- Name **PawSetu**; tagline "Every care your pet needs, in one place"; the
  bridge meaning.
- The app icon (a bridge arc over a paw) stays as a mark; its colours may follow
  the new visual world *(inferred)*.
- SOS is always red with white text.
- Original illustration only: no copyrighted characters, real brand logos or
  stock photos.
- The owner asked for a premium, from-scratch look; the previous look (teal,
  apricot, Plus Jakarta Sans, cream background) is not binding.

## Evidence on Hand

- Demo data only (section 12 of the spec): 14 demo accounts, 9 pets, fictional
  clinics, vets, providers, sellers and products. No real customers,
  testimonials, ratings or press may be invented as real.

## Product Principles

1. The pet comes first: every screen speaks about a named pet ("Bruno's next
   vaccine is due in 3 days"), not about the app.
2. Seconds, not minutes: the daily job (log, tick, check) is two taps from
   Home.
3. Calm until it matters: quiet by default; urgency (overdue, SOS, lost pet)
   is unmistakable and rare.
4. Trust through clarity: medical and money screens are plain, exact and
   honest about what is indicative or simulated.
5. Nobody left out: three languages, Easy mode, large text and screen readers
   are first-class, not afterthoughts.

## Accessibility & Inclusion

- WCAG AA contrast in light, dark and high-contrast themes.
- Layouts hold at 200% text; Easy mode adds 25% text and 56 px targets.
- Touch targets at least 48 px; screen-reader labels on every control and image.
- Respect the system Reduce Motion setting.
