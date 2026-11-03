# Spacing matrix

Every value is a spacing token on the 4 px grid. Columns follow the screen sizes in `lib/core/widgets/layout.dart`: phone under 640 px, tablet 640 to 1023 px, desktop 1024 px and up. "Easy" is Easy mode on any size.

## Page

| Where | Phone | Tablet | Desktop | Easy |
|---|---|---|---|---|
| Side gutter | `space-lg` 16 | `space-xl` 24 | `space-xl` 24 | same as size |
| Content width | full | `width-reading` 760 or full | `width-narrow` 560 / `width-reading` 760 / `width-max` 1200 | same |
| Top of page to first item | `space-sm` 8 | `space-lg` 16 | `space-xl` 24 | same |
| Above a section header | `space-xl` 24 | `space-xl` 24 | `space-xxl` 32 | `space-xxl` 32 |
| Section header to content | `space-sm` 8 | `space-sm` 8 | `space-md` 12 | `space-md` 12 |
| Bottom of page (after last item) | `space-xxl` 32 + safe area | `space-xxl` 32 | `space-xxl` 32 | same |
| Grid columns (cards) | 1 | 2 | 3 (up to 4) | 1 on phone, 2 on tablet |
| Grid gap | `space-md` 12 | `space-md` 12 | `space-lg` 16 | `space-lg` 16 |

## Inside components

| Where | Phone | Tablet | Desktop | Easy |
|---|---|---|---|---|
| Card padding | `space-lg` 16 | `space-lg` 16 | `space-xl` 24 for hero cards, else 16 | `space-xl` 24 |
| Gap between cards in a list | `space-md` 12 | `space-md` 12 | `space-md` 12 | `space-lg` 16 |
| Between items inside a card | `space-md` 12 | `space-md` 12 | `space-md` 12 | `space-lg` 16 |
| Icon to its label | `space-sm` 8 | `space-sm` 8 | `space-sm` 8 | `space-md` 12 |
| Between form fields | `space-md` 12 | `space-md` 12 | `space-lg` 16 | `space-lg` 16 |
| Form fields to the main button | `space-xl` 24 | `space-xl` 24 | `space-xl` 24 | `space-xl` 24 |
| Between chips | `space-sm` 8 | `space-sm` 8 | `space-sm` 8 | `space-md` 12 |
| Button padding (side × top) | 20 × 14 | 20 × 14 | 20 × 14 | 24 × 16 |
| Text field padding | `space-lg` 16 | 16 | 16 | 16 (taller from text size) |
| Status chip padding | 10 × `space-xs` 4 | same | same | 12 × 6 |
| List row padding (side) | `space-lg` 16 | 16 | `space-xl` 24 in tables | 16 |
| Dialog padding | `space-xl` 24 | 24 | 24 | 24 |
| Bottom sheet padding | `space-lg` 16 sides, `space-xl` 24 bottom + safe area | same | shown as a dialog | same |

## Sizes

| Thing | Phone | Tablet | Desktop | Easy |
|---|---|---|---|---|
| Smallest tap target | `touch-min` 48 | 48 | 48 | `touch-easy` 56 |
| Button height | 48 | 48 | 48 | 56 |
| Text field height | `field-height` 56 | 56 | 56 | grows with text |
| List row height | `list-row` 56 | 56 | 52 in portal tables (48 target kept) | 64 |
| Top bar | `top-bar` 64 | 64 | 64 | 72 |
| Navigation | `bottom-nav` 68 | `nav-rail` 80 | `side-nav` 220 (`portal-nav` 280) | bottom-nav 76, icons 30 |
| SOS button | `sos-button` 44 | 44 | 44 | 52 |
| Quick-action tile | min 96 tall, 4 across | 4 across | 4 across | min 120 tall, 2 across |

## How to choose

- Related things are close (`space-xs`, `space-sm`); separate things are far (`space-xl`, `space-xxl`). If two items need a divider to look separate, add space first.
- Never mix two different gaps in one list.
- Set space with gaps between siblings (Flutter `Gap`, `Wrap` spacing, `TileGrid` spacing), not with padding on each child.
- Don't make up values. If a layout seems to need 20 px, use `space-lg` or `space-xl`. Button padding (20 × 14) and chip padding (10 × 4) are fixed component sizes, not spacing choices.
