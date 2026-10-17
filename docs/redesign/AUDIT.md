# PawSetu redesign: baseline audit (Phase 1)

17 October 2026, branch `claude/gifted-hypatia-640t3h`. Everything below was measured in the Claude Code cloud environment (Linux, Flutter 3.47.7, Chromium 141). This is the "before" picture the redesign is judged against.

## 1. How it was measured

| What | How | Where |
|---|---|---|
| Golden screenshots | 17 key screens × 11 combinations (4 sizes in light/English; on a 390 × 844 phone: dark, high contrast, Hindi, Telugu, 200% text; on a 1280 × 800 desktop: dark, Telugu) = 187 images, real bundled fonts and real shadows | `test/goldens/baseline_golden_test.dart`, images in `test/goldens/baseline/`, copies in `docs/redesign/before/` |
| Flutter accessibility guidelines | Labelled tap targets, Android tap size (48 px), iOS tap size (44 px), text contrast; 60 screens (38 pet parent, 11 admin, 11 clinic) in light, dark and high contrast; report only | Layout sweep: `accessibility audit (report only)` |
| Exact text audit | Every on-screen paragraph's own colour against the colour actually painted behind it; small text; text cut off with "…"; 60 screens in English, Hindi and Telugu (light), English dark, high contrast and 200% text; report only | Layout sweep: `text audit (report only)`, logic in `test/support/text_audit.dart` |
| Web size and load time | `flutter build web --release`, served with gzip like Firebase Hosting; cold load in Chromium with the Lighthouse mobile profile (150 ms latency, 1.6 Mbps, 4× slower CPU) and a desktop broadband profile (40 ms, 10 Mbps); time until Flutter's first frame (`flutter-first-frame` event); 3 runs each, median | Chrome DevTools Protocol via Playwright; trace via the Chrome DevTools MCP server |
| Code facts | Counts of routes, animations, truncation, hard-coded styles | `lib/` |
| Design critique | Impeccable's critique method (Nielsen heuristics, cognitive load, personas) applied to the goldens. Impeccable's automatic detector reads web markup only, so it doesn't apply to Flutter (its "native platform" path) | Section 4 |

Caveats:
- Goldens tolerate up to 3% changed pixels because the app reads the real clock (301 `DateTime.now()` calls in 104 files) and the demo data is built relative to today, so the greeting and printed dates change between runs. See "Decision needed" at the end.
- Flutter's own text-contrast check is not trustworthy here: it samples the whole tappable area of a merged item (a list tile, a card), so it often compares two backgrounds instead of text and background. The same counts appeared at 1 and 3 pixels per point. The exact text audit replaces it for decisions.
- Chrome's Largest Contentful Paint reads 98 ms, but that is the HTML loading screen in `web/index.html`; Flutter draws the app on a canvas that LCP ignores. The first-frame time is the meaningful number.

## 2. Baseline numbers

### Tests and checks

| Check | Result |
|---|---|
| `flutter analyze` | 0 issues |
| App tests | 203 passed (plus the new report-only audits and 44 golden comparisons) |
| Server and security tests | 170 passed (Firestore and Storage emulators) |
| Layout sweep overflow errors | 0 (but see problem 6: clipping that doesn't raise an overflow error) |

### Accessibility (60 screens, phone, English)

| Check | Light | Dark | High contrast |
|---|---|---|---|
| Labelled tap targets (Flutter guideline) | 0 failures | 0 | 0 |
| Android tap targets, 48 px | 0 | 0 | 0 |
| iOS tap targets, 44 px | 0 | 0 | 0 |
| Text contrast, Flutter's pixel sampler (unreliable, see caveats) | 105 failures on 20 screens | 35 on 7 | 90 on 17 |
| **Text contrast, exact** (4.5:1, large text 3:1; disabled buttons exempt) | **9** | **8** | **7** |
| **Icon contrast, exact** (3:1) | **34** | **21** | **35** |

### Text size and cut-off text (exact text audit, 60 screens, phone)

| | English | Hindi | Telugu | English, 200% text |
|---|---|---|---|---|
| Text runs checked | 1,522 | 1,510 | 1,489 | 1,165 |
| Smaller than 14 px | 820 (54%) | 813 (54%) | 803 (54%) | 610 (52%) |
| 12 px or smaller | 214 (14%) | 210 (14%) | 207 (14%) | 139 (12%) |
| Cut off ("…", fade or clip) | 80 | 62 | 85 | 113 |

### Web performance

| Measure | Value |
|---|---|
| `build/web` on disk | 50 MB (37 MB of it is engine variants the browser picks one of) |
| `main.dart.js` | 10.1 MB, 2.43 MB gzipped |
| First visit download | 4.8 MB in 24 requests: app code 2.37 MB (49%), CanvasKit engine from Google's CDN 1.61 MB (33%), Hindi and Telugu fonts 644 KB (13%, downloaded by every user, including English), Plus Jakarta Sans 126 KB, icons 31 KB |
| **First frame, budget phone on slow 4G** | **31.7 s** median (31.3–32.5 s) |
| First frame, desktop broadband | 5.8 s median (5.7–5.8 s) |
| Layout shift (CLS) | 0.00 |
| Console errors on load | 0 |
| Small issue | `<meta charset>` sits on line 19 after a long comment, so the browser sees it late (DevTools "CharacterSet" insight) |

### Code facts behind the five problems

| Fact | Count |
|---|---|
| Pet-parent screens outside the shared frame (no tab bar or side menu) | 32 (`rootRoutes` in `lib/core/routing/extra_routes.dart:77`): pet profile and its edit, routine, report and card pages; messages (3); online vet (4); Ask PawSetu; prescription; per-pet safe and album; birthday; document pages (2); shares; insurance (2); SOS; first aid (2); toxic check; help; notifications; settings; add pet; walk tracker |
| Screens opened without their own web address | 12: per-pet album page, memory picker, invoice PDF, QR tag PDF, lost poster PDF, prescription PDF, full-screen document viewer, shared-media viewer, change PIN, photo crop, chat photo viewer, scan crop |
| Me tab | 14 equal links in one list (`extra_routes.dart:140`) |
| Motion | 1 `Hero`, 0 `AnimatedSwitcher`, 4 implicit `Animated…` widgets, 6 `AnimationController`s, 1 `TweenAnimationBuilder`; 2 checks of the reduce-motion setting; 19 haptic calls |
| Truncation in code | 89 `TextOverflow.ellipsis`, 107 `maxLines` |
| Smallest text styles | 283 uses of `bodySmall`/`labelSmall` |
| Hard-coded styling in feature code | 98 `Color(0x…)` (mostly shop/routine category colours, sample documents, video call, PDFs), 17 named `Colors.…` other than white/black/transparent, 62 literal font sizes |
| Shared components | `PawCard` 222 uses, `PrimaryButton` 135 |
| State widgets | `EmptyState` 76 uses, `Skeleton` 35, bare spinners 16, `ErrorState` only 6 |

## 3. Design critique (Impeccable method)

Method: design review only (Impeccable's detector reads web markup; Flutter draws to a canvas).

### Design health score (pet-parent app)

| # | Heuristic | Score | Key issue |
|---|---|---|---|
| 1 | Visibility of system status | 3 | Offline strip, skeletons and the day ring are good; finishing a task gives almost no feedback |
| 2 | Match with the real world | 3 | Plain words, ₹, Indian breeds, three scripts; a few internal terms ("Tele-vet", "Vault") |
| 3 | User control and freedom | 2 | Deep screens lose the frame, and opened from a link they have no way back |
| 4 | Consistency and standards | 2 | Same components everywhere, but the frame appears on some screens and not others; two "Log" buttons on Routine |
| 5 | Error prevention | 3 | Disabled actions until input is valid, PIN on the safe |
| 6 | Recognition rather than recall | 2 | Features hidden in Me; key details cut off with "…" |
| 7 | Flexibility and efficiency | 2 | Quick actions exist; desktop space and keyboard use are unexploited |
| 8 | Aesthetic and minimalist design | 2 | Clean but generic, flat hierarchy, too much small text |
| 9 | Error recovery | 2 | A designed error state on only 6 screens |
| 10 | Help and documentation | 3 | First-aid guides, Ask PawSetu, help and complaints, inline explanations |
| | **Total** | **24/40** | **Acceptable**: a solid base that needs real improvement before users are delighted |

### Design specificity verdict

Category-interchangeable. The palette (deep teal and warm peach) and the pet illustrations are pleasant, and the content is genuinely local (₹ prices, Indian names and breeds, a monsoon offer, walk weather at 31 °C, Hindi and Telugu everywhere). But the structure is the generic "card kit": every section is a white rounded card with a pastel icon circle and the same weight, the same grid of six tiles on Book, the same list rows on Me. Remove the words and it could be any booking or wellness app. The local character lives in the copy, not in the design.

### Cognitive load (Home, phone)

Fails 4 of 8 checks (high): single focus, visual hierarchy, one thing at a time, minimal choices (top bar 4 actions, checklist 5, quick actions 4, plus up to 8 sections). Passes chunking, grouping, working memory and progressive disclosure ("See all"). Me fails "minimal choices" with 14 options at one level.

### Emotional journey

The everyday peak moments are flat: ticking off a walk, giving a dose or finishing a vaccine just changes a number, and a 30-day streak is a small chip. The highest-stakes moment, SOS, is visually strong and well engineered, though the first seconds show grey placeholders instead of something to tap.

### What's working

1. **A sound foundation.** Shared components are used consistently (cards 222 times, main button 135), all three scripts render with bundled fonts, every one of 60 screens passes tap-size and label checks in light, dark and high contrast, and the layout sweep finds no overflow errors.
2. **Careful safety engineering.** SOS shows clinics from the last known place or a chosen area within about 2 seconds, never waits more than 10 seconds for GPS, and falls back to clinics saved on the phone. The medical card works offline.
3. **Real local content and inclusion.** Three languages, Easy mode, a text-size slider, ₹ pricing, walk weather and local offers: the raw material for a distinctly Indian product is already there.

### Personas

- **Casey, distracted, on a budget phone with patchy data:** waits about 32 seconds for the first screen; on Home has to scan up to 8 equal cards to find the one thing due; ticks off a walk with a small "+" and gets no confirmation beyond a number.
- **Sam, who needs 200% text and high contrast:** the notification badge covers the SOS button ("2S"), "33%" breaks onto two lines inside the progress ring, page titles like "Notifications" and "Connected devices" are cut off, 113 pieces of text are cut off in total, and high-contrast mode looks almost the same as the normal theme.
- **Jordan, a first-timer:** Me is a wall of 14 links; Book offers six equal tiles; "Tele-vet" and "Document vault" need explaining.
- **Kamala, 62, Priya's mother-in-law (from the brief: older family member, Hindi, Easy mode, budget Android):** reads Hindi where labels run longer: the clinic finder's own title "पास का पशु-चिकित्सक ढूँढें" is cut off at normal text size; due dates and ages sit in 12–13 px grey; nothing tells her "give Bruno his tablet now".

## 4. Top 20 problems, ranked by user impact

Severity: P0 blocks a task, P1 major, P2 minor with a workaround, P3 polish. The last column maps each problem to the brief's five problems (1 navigation, 2 Me, 3 Home, 4 feedback and delight, 5 small and cut-off text) or names a new area.

| # | Sev | Problem | Evidence | Brief |
|---|---|---|---|---|
| 1 | P1 | **Dead ends on deep screens.** 32 pet-parent screens drop the tab bar and side menu. Opened from a link, a notification or a web refresh, the pet profile has no back button at all, so the only way out is the browser's back button | `extra_routes.dart:77`; pet profile goldens at 390 and 1280 px | 1 |
| 2 | P1 | **32 seconds to the first screen on a budget phone over slow 4G** (5.8 s on desktop broadband). 4.8 MB on first visit, including 644 KB of Hindi and Telugu fonts every user downloads | Section 2, web performance | New: performance |
| 3 | P1 | **Home has no "do this first".** Up to 8 sections of equal weight; three "Due soon" items look identical; checklist, next up, weather, food and memory compete | Home goldens; cognitive load 4/8 failed | 3 |
| 4 | P1 | **Small text everywhere.** 54% of all text is under 14 px and 14% is 12 px or less; due dates, ages, breeds and secondary prices sit in the smallest grey style | Text audit | 5 |
| 5 | P1 | **Important text cut off.** 80 truncations in English, 62 in Hindi, 85 in Telugu at normal size: product and clinic names, the demo account descriptions, message previews, even the Hindi clinic-finder title | Text audit examples | 5 |
| 6 | P1 | **Large text breaks the layout without an error.** At 200% text: the notification badge covers SOS ("2S"), "33%" wraps inside the day ring, and page titles are cut off (113 truncations). None raise an overflow error, so the sweep can't see them | `home_390x844_light_en_2x.png`; text audit | 5 |
| 7 | P1 | **Me is a junk drawer.** 14 equal links; the document safe, album, lost-pet mode and devices sit among addresses, refer-a-friend and privacy | `me_390x844_light_en_1x.png`; `extra_routes.dart:140` | 2 |
| 8 | P1 | **12 screens have no web address.** PDF previews, viewers, change PIN, album page: refreshing or sharing loses them, and browser back behaves unexpectedly | Section 2, code facts | 1 |
| 9 | P2 | **Brand orange and pastel icons fail contrast.** "Plus" badge and rating stars in #F4A261 on white = 2.06:1; 34 category icons on pastel circles at 1.8–2.9:1; in dark mode the green "% off" badges are 1.74:1 and two icons on Album and Devices are nearly invisible (1.08:1) | Exact text audit | New: contrast |
| 10 | P2 | **High contrast mode barely changes anything.** It looks almost identical to the normal theme and still has 7 text and 35 icon contrast failures | `home_390x844_hc_en_1x.png` | New: accessibility |
| 11 | P2 | **No reward for daily habits.** 1 shared-element transition, no animated switches, 4 small animations; finishing a walk, a dose or a vaccine just changes a number; a 30-day streak is a tiny chip | Code facts; routine and home goldens | 4 |
| 12 | P2 | **Generic look.** Interchangeable card kit: white rounded cards with pastel icon circles everywhere, equal weights; the Indian character lives only in the words | Design specificity verdict | 3 |
| 13 | P2 | **Desktop and tablet waste space.** Home on desktop is one ~790 px column with about a quarter of the screen empty; tablet is the phone layout plus a rail | `home_1280x800`, `home_800x1280` goldens | New: responsive |
| 14 | P2 | **Thin error handling.** A designed error state on 6 screens versus 76 empty states and 35 skeletons; 16 bare spinners | Code facts | New: states |
| 15 | P2 | **SOS's first seconds offer nothing to tap.** While locating (up to about 2 s from a saved place, 10 s for GPS) the big red card says "Finding clinics near you…" over grey placeholders. A call button for the pet's own vet or the last saved clinic could be ready instantly | `sos_390x844_light_en_1x.png`; `sos_screen.dart:102` | New: safety |
| 16 | P2 | **Pet profile spends its first screen on four static facts** (age, weight, gender, neutered) as big tiles; there's no "today" status for the pet, and care actions sit below the fold | `pet_profile` goldens | 2, 3 |
| 17 | P2 | **Competing main actions.** Routine shows "+ Log" in the day card and again as a floating button; on Home the day card has a "+" on every row plus "+ Log" and "See all", five actions in one card | Routine and home goldens | 3 |
| 18 | P3 | **Notifications aren't grouped.** No grouping by day or urgency; the filter chips run off the right edge with no cue; timestamps in small grey | `notifications` goldens | 5 |
| 19 | P3 | **Shop placeholders look broken.** Without product photos, cards show a generic icon on peach, and product names cut off after two lines | `shop` goldens | 5 |
| 20 | P3 | **Late character-set declaration** in `web/index.html` (line 19, after a long comment) | DevTools trace | New: performance |

Count by brief problem: navigation 2 (#1, #8), Me 2 (#7, #16), Home 4 (#3, #12, #16, #17), feedback 1 (#11), text 5 (#4, #5, #6, #18, #19). New areas the brief didn't name: load time (#2, #20), contrast and high contrast (#9, #10), responsive use of space (#13), error states (#14), SOS first seconds (#15).

## 5. To do on a computer with the Android SDK

- `flutter build apk --release` and `--split-per-abi`: APK size baseline.
- Frame times (build and raster, 90th and 99th percentile) on a budget Android phone for: cold start to Home, scrolling Home, opening the pet profile, logging a walk, the booking flow, shop to cart.
- Integration tests on an Android emulator or device (none exist yet).
- Android back button and predictive back on deep screens.

## 6. Decision needed

**Make goldens independent of the clock.** Today the goldens allow 3% changed pixels because the app reads the real time in 301 places. The clean fix reads time through one replaceable clock (`clock.now()` from `package:clock`, already in the dependency tree from Flutter's own test tools) so tests can freeze it. It changes no behaviour, but it touches business-logic files, which the brief says to ask about first. Recommended: do it in Phase 3, then drop the tolerance to zero.
