---
name: "PawSetu Design System"
description: "Warm Clinical Trust & Playful Care design system for PawSetu pet healthcare, clinic discovery, appointments, and pet medical records."
---

## Overview

PawSetu embodies **Warm Clinical Trust & Playful Care**. Designed for dedicated pet parents and veterinary professionals, it synthesizes the clarity and warmth of modern consumer health platforms (One Medical, Airbnb) with the precise operational speed of Linear.

The interface rejects sterile hospital greens, harsh borders, and juvenile cartoon overload. Instead, it balances high-trust clinical precision—vital for vaccinations, dosages, and verified vet accreditations—with welcoming, tactile warmth that reassures pet owners in moments of routine care and medical emergencies.

- **Primary Persona:** Anxious or busy pet parents needing immediate triage, seamless appointment booking, and persistent digital health records for multiple pets.
- **Design Philosophy:** Human-centered, warm alabaster canvas, tactile elevation over harsh drop shadows, high information density without visual noise, and zero-compromise responsive fluidity from 375px mobile viewports to 1440px desktop workstations.

## Colors

The color palette grounds veterinary reliability in reassuring earth-derived tones. An editorial terracotta coral drives clear action, while deep forest teal anchors medical authority and verified clinical credentials.

- **Primary Accent (`#C84735` / `#FF7A66`):** Warm Terracotta Coral. Guides users directly to booking CTAs, primary triggers, and active focus points.
- **Trust / Clinical Accent (`#18453E` / `#E6F0ED`):** Deep Forest Teal and Soft Sage. Reserved for verified veterinary accreditation, vaccination status passcards, and official health summaries.
- **Backgrounds & Canvas:** Warm Alabaster (`#FAF8F5`) for the primary canvas, Pure White (`#FFFFFF`) for elevated cards and sheets, and Soft Sand (`#F3EFEA`) for secondary grouping containers and neutral chips.
- **Status Tokens:** Amber (`#D97706`) for upcoming boosters and alerts, Emerald (`#15803D`) for completed treatments and valid immunizations, Crimson (`#DC2626`) for 24/7 SOS and emergency clinic triage.

```yaml
colors:
  coral: "#E05A47"
  forest-teal: "#18453E"
  soft-sage: "#E6F0ED"
  soft-sand: "#F3EFEA"
  warm-border: "#E7E2DA"
  status-upcoming: "#D97706"
  status-completed: "#15803D"
  status-emergency: "#DC2626"
  light:
    primary: "#C84735"
    on-primary: "#FFFFFF"
    secondary: "#18453E"
    on-secondary: "#FFFFFF"
    surface: "#FAF8F5"
    on-surface: "#1C1917"
    surface-elevated: "#FFFFFF"
    on-surface-elevated: "#1C1917"
    surface-subtle: "#F3EFEA"
    on-surface-subtle: "#44403C"
    outline: "#E7E2DA"
    error: "#DC2626"
    on-error: "#FFFFFF"
  dark:
    primary: "#FF7A66"
    on-primary: "#45120B"
    secondary: "#52B7A5"
    on-secondary: "#0A2923"
    surface: "#141517"
    on-surface: "#F5F5F4"
    surface-elevated: "#1C1D21"
    on-surface-elevated: "#F5F5F4"
    surface-subtle: "#24262B"
    on-surface-subtle: "#D6D3D1"
    outline: "#2E3138"
    error: "#F87171"
    on-error: "#450A0A"
```

## Typography

PawSetu pairs **Plus Jakarta Sans** for expressive, warm, editorial headings with **Inter** for ultra-crisp interface legibility across varying densities, and **JetBrains Mono** for medical records, appointment slot times, batch numbers, and dosages.

- **Plus Jakarta Sans (Display & Headlines):** Modern geometric grotesk with friendly curves and high character, set with tight tracking (`-0.02em`) on headings.
- **Inter (Body & Labels):** Neutral, hyper-legible system typography that stays crystal clear down to 11px tags.
- **JetBrains Mono (Monospace):** Tabular numbers for timestamps, vaccination dose counts, and medical IDs.

```yaml
typography:
  display-lg:
    fontFamily: "Plus Jakarta Sans"
    fontSize: 40px
    fontWeight: 700
    lineHeight: 48px
    letterSpacing: -0.8px
  display-lg-mobile:
    fontFamily: "Plus Jakarta Sans"
    fontSize: 28px
    fontWeight: 700
    lineHeight: 34px
    letterSpacing: -0.5px
  headline-lg:
    fontFamily: "Plus Jakarta Sans"
    fontSize: 32px
    fontWeight: 700
    lineHeight: 38px
    letterSpacing: -0.6px
  headline-lg-mobile:
    fontFamily: "Plus Jakarta Sans"
    fontSize: 24px
    fontWeight: 700
    lineHeight: 30px
    letterSpacing: -0.4px
  headline-md:
    fontFamily: "Plus Jakarta Sans"
    fontSize: 24px
    fontWeight: 600
    lineHeight: 30px
    letterSpacing: -0.3px
  headline-sm:
    fontFamily: "Plus Jakarta Sans"
    fontSize: 20px
    fontWeight: 600
    lineHeight: 26px
    letterSpacing: -0.2px
  body-lg:
    fontFamily: "Inter"
    fontSize: 18px
    fontWeight: 400
    lineHeight: 28px
  body-md:
    fontFamily: "Inter"
    fontSize: 15px
    fontWeight: 400
    lineHeight: 22px
  body-sm:
    fontFamily: "Inter"
    fontSize: 13px
    fontWeight: 400
    lineHeight: 18px
  label-lg:
    fontFamily: "Inter"
    fontSize: 15px
    fontWeight: 600
    lineHeight: 20px
  label-md:
    fontFamily: "Inter"
    fontSize: 13px
    fontWeight: 500
    lineHeight: 18px
  label-sm:
    fontFamily: "Inter"
    fontSize: 11px
    fontWeight: 600
    lineHeight: 16px
    letterSpacing: 0.3px
  code-md:
    fontFamily: "JetBrains Mono"
    fontSize: 13px
    fontWeight: 500
    lineHeight: 18px
```

## Layout & Spacing

PawSetu strictly obeys an 8px spatial grid with a 4px half-step for micro-targets (chips, badges, and icon buttons).

- **Mobile Viewports (<768px):** Single-column layout with 16px lateral padding, floating translucent navigation dock at the bottom with 48px touch targets, and sticky location/pet switcher header.
- **Tablet / Desktop (>=768px):** Centered max-width container (`1200px`) framed by a fixed vertical navigation rail or unified header. Discovery cards arrange into 2-column or 3-column bento grids, and appointment booking flows expand into a high-efficiency 2-column split (clinic specs & services on left, interactive slot picker and cart drawer on right).

```yaml
spacing:
  gutter-xs: 4px
  gutter-sm: 8px
  gutter-md: 12px
  gutter-lg: 16px
  gutter-xl: 24px
  section-sm: 32px
  section-md: 48px
  page-margin: 24px
```

## Elevation & Depth

No harsh generic drop shadows. Surfaces layer using:
1. **1px Warm Architectural Outlines:** Subtle `#E7E2DA` border on cards and containers.
2. **Ambient Multi-Stop Diffusion:** Cards elevate with `box-shadow: 0 1px 3px 0 rgba(28, 25, 23, 0.04), 0 8px 24px -4px rgba(28, 25, 23, 0.06)`.
3. **Elevated Modal Sheets & Flyouts:** `box-shadow: 0 20px 48px -8px rgba(28, 25, 23, 0.14)`.

## Shapes

Radii follow a disciplined hierarchy to communicate tactile affordances:

- **12px (`rounded-md`):** Form inputs, search fields, interactive chips, and date selectors.
- **16px–20px (`rounded-lg`, `rounded-xl`):** Clinic discovery cards, pet health passcards, and bottom sheet dialogs.
- **9999px (`rounded-full`):** Category pills, status indicator tags, and avatar badges.

```yaml
rounded:
  sm: 6px
  md: 12px
  lg: 16px
  xl: 20px
  2xl: 28px
  full: 9999px
```

## Motion & Micro-interaction

Micro-interactions feel snappy and physical, preventing the sluggish, disconnected feeling common in cross-platform wrappers.

- **Touch Press / Hover:** Subtle scale down (`scale(0.98)`) with `100ms cubic-bezier(0.4, 0, 0.2, 1)`.
- **Slot Selection:** Instant 150ms spring transition for date and time pill activation with ring elevation.
- **Pet Switcher:** Smooth 200ms opacity and translation reflow between pet health timelines.
- **Hydration / Loading:** Branded skeleton pulse rather than full-blocking blank spinners.

```yaml
motion:
  tap:
    duration: 100ms
    delay: 0ms
    timingFunction: cubic-bezier(0.4, 0, 0.2, 1)
  filter-toggle:
    duration: 150ms
    delay: 0ms
    timingFunction: ease-out
  drawer-enter:
    duration: 250ms
    delay: 0ms
    timingFunction: cubic-bezier(0.16, 1, 0.3, 1)
  drawer-exit:
    duration: 180ms
    delay: 0ms
    timingFunction: cubic-bezier(0.4, 0, 1, 1)
```

## Voice & Content Strategy

- **Tone:** Reassuring, clear, knowledgeable, and calm. Avoid patronizing baby talk while celebrating the bond between pets and humans.
- **Action Verbs:** Explicit and transparent. Use "Book In-Clinic Visit", "Confirm for Bruno", "Download Vaccine Certificate", never vague "OK", "Next", or "Proceed".
- **Medical & Booking Clarity:** Clear prices upfront (e.g., "Consultation ₹750 · No hidden facility fee"), unambiguous distance badges ("1.2 km away · Indiranagar"), and clear time windows ("Today, 4:30 PM - 5:00 PM").
- **States:** Empty states offer constructive one-tap remedies ("No past prescriptions found — Upload your first paper prescription or book an evaluation").

## Components

Component implementations live as individual HTML sticker sheet files in
`components/`. Each file contains the canonical, styled HTML components with
`<!-- COMPONENT: name -->` comment markers. Read each file before use.

- **Badge** → `@components/badge.html`: `badge-numeric`, `badge-dot`
- **Button** → `@components/button.html`: `button-primary`, `button-icon`, `button-with-icon`
- **Card** → `@components/card.html`: `card-elevated`, `card-interactive`, `card-interactive-2`
- **Chip** → `@components/chip.html`: `chip-action`, `chip-input`, `chip-with-icon`
- **Input Field** → `@components/input-field.html`: `input-field-text`, `input-field-icon`
