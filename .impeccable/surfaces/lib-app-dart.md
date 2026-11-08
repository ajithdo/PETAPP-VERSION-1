---
version: 1
slug: "lib-app-dart"
primary_target: "lib/app.dart"
related_targets: ["lib/core/theme/tokens.dart","lib/core/theme/app_theme.dart","lib/core/widgets"]
---

## Scope
The whole PawSetu Flutter app (pet-parent tabs and flows, partner portals, admin) for UI Design 5. Visitor mode: Operate. Owner's brief: docs/ui-designs/ui-design-5-brief.md. Directions and scores: docs/ui-designs/ui-design-5-directions/CRITIQUE.md.

## Direction contract
THESIS: The pet's day, made into a small daily ritual. Every pet-parent screen answers "what does Bruno need now?" first, with the pet's own photo leading; it refuses the category default of a clinic-and-offers feed of identical white cards with a teal or coral button.

OWN-WORLD: Genda, the marigold garland of an Indian home at dusk. Cocoa ink and cocoa buttons (#4A2A12, band #3A2416) on white and warm-grey grounds; marigold (#F3A712) only for flowers, progress and celebration; SOS red the only red. Titles in Baloo 2 / Baloo Tammudu 2, text in Hind / Hind Guntur; 22 px cards, round buttons, soft warm shadows, rounded Material Symbols. Two registers: warm (Home, empty states, onboarding, album, birthday) and calm (Health, records, tele-vet, SOS, portals: no marigold fills, green "given" ticks, compact density for tables).

STORY: Priya opens the app, sees Bruno in his garland with "2 of 4 done", ticks the evening walk, sees the next thing due (flea and tick, Fri 13), and reaches booking, tele-vet, shop or SOS in one tap. On health screens she trusts what she reads; in an emergency there is one red button.

FIRST VIEWPORT: Phone: top bar (logo, messages, notifications, red SOS pill); greeting with first name; pet switcher chips; the Genda band (pet photo in a garland of one flower per task, date, "<pet>'s day", "2 of 4 done", progress bar); then today's task rows (time, task, who did it, check). Primary action: ticking the next task. Desktop: navigation rail on the left, pet switcher and SOS in the top bar, the Genda band and tasks in the main column, "Next for <pet>" and quick actions in the side column.

FORM: Candidate 2 of 7 (grounded; chosen over the roll's assignment, candidate 4 "Deewar", by the owner's scoring rules). seed:b45978419bb7395c

FINISH: unreviewed and undocumented is unfinished; this build ends with the finish review, the verdict, DESIGN.md, and every shipping raster carrying its provenance
