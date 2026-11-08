# UI Design 5 — run log

Read this first after a usage reset, a restart or a context summary, then continue from **Next step**.

## Status

- **Phase:** 4 done, Batch A done. Now Batch B (Home, Health, Book, Shop, Me).
- **Work branch:** `claude/happy-wozniak-68a4q2` (push only this branch).
- **Next step:** Batch B. Home first (`lib/features/home/presentation/`): greeting with date → GendaBand (photo with Hero tag `pet-<id>`, tap → `/pets/<id>`; flowers = walks goal + meals goal + 1 for play; done counted per goal) → TodayCard without its ring header (title Today + streak chip; rows: done tick, type, progress, log button) → Next up (no skipFirst; DueTile: date block, chip only when overdue) → 4 quick actions (Book a vet, Ask a vet, Shop, Add photo) → Near you (location pill, search box, 2 nearest clinics; no health-status card, no chip row) → tips. Desktop: left = band, today, quick actions; right = next up, near you, tips. Then Health (calm), Book, Shop, Me.

## Plan (from the owner's prompt)

| Phase | What | State |
|---|---|---|
| A | Check the Claude setup | done |
| B | Names and branch | done |
| 1 | Brief (`docs/ui-designs/ui-design-5-brief.md`) | done |
| 2 | Three directions, pick one | done: Genda |
| 3 | Design rules: DESIGN.md, PRODUCT.md, PROJECT_SPEC section 4, CLAUDE.md line | done |
| 4 | Foundation | done |
| 5A | Shell: navigation, top bar, pet switcher, SOS | done (audit 19/20) |
| 5B | Home, Health, Book, Shop, Me | next |
| 5C | Sign-in + demo accounts first; then booking, pet profile + routine, SOS, tele-vet; then vault, album, messages, notifications, family, plans, settings, onboarding | — |
| 5D | Partner portals and admin (before the rest of 5C only if the audit finds them much weaker) | — |
| 5E | Motion and app icons | — |
| 6 | Finish: critique, polish, fresh-eyes review, compare page, docs, store screenshots, web build | — |
| — | Morning report (`docs/ui-designs/ui-design-5-morning-report.md`) | — |

After each batch: Impeccable audit and fixes; screenshots (360 px and 1280 px, light/dark, English/Telugu, Easy mode) in `docs/ui-revamp/ui-design-5-<batch>/` beside the UI Design 4 ones; token check empty; `flutter analyze` clean; all tests pass (including `test/qa/layout_sweep_test.dart` and the contrast test); commit, push, and the AGENTS.md summary here.

## Done so far

- **Part A (8 Nov).** The session had started on the old UI Design 1 branch, so the work branch was moved forward onto `ui-revamp` (fast-forward, nothing lost) and the setup branch's last commit (push rule) was merged in. Found and fixed: `skills-lock.json` listed 35 of the 37 skills; `netlify-deploy` and `netlify-config` were reinstalled from Netlify's own repo (`netlify/context-and-tools`) and its MIT LICENSE copied back. Everything else was already right (see the table in the owner's chat summary). After the worker restarted, the session loaded the new `.mcp.json`: the Dart and Firebase servers connected.
- **Part B (8 Nov).** The naming branch `claude/modest-dijkstra-q2x165` was **already merged into `ui-revamp`** (by pull request #2, commit `b884e3a`), so it is in the work branch too; `docs/ui-designs` and `docs/ui-revamp/check_ui_design_tokens.sh` exist. UI Design 5 added to the Names table in `docs/PROGRESS.md`.
- **Plus fix merged (owner's choice).** `claude/serene-pascal-kjqctd` merged into the work branch. Conflicts in `docs/DECISIONS.md` and `docs/PROGRESS.md` were settled by keeping both sets of notes; `test/core/demo_auth_test.dart` keeps both fixes (demo data made as of today; Priya checked as Plus on that date and by the real clock).
- **Phase 2 (8 Nov).** GO received. Wrote `PRODUCT.md` (Impeccable needs it before any new look). Ran Impeccable's direction roll (seed:b45978419bb7395c): seven ideas from Indian pet parents' everyday world; the roll assigned the wall calendar. Mocked three directions with the app's real content (Home, Health, Book, clinic portal; 390 and 1440 px; light and dark; plus Hindi, Telugu and Easy mode): **A. Deewar** (wall calendar, ballpoint blue), **B. Muhar** (vaccination booklet, violet stamp), **C. Genda** (marigold garland, cocoa). Compare page `docs/ui-designs/ui-design-5-directions/index.html`; critique and scores in `CRITIQUE.md` there. Picked **Genda** (53 vs 50 vs 43.5). Direction contract in `.impeccable/surfaces/lib-app-dart.md`.
- **UI Design 4 "before" pictures:** `tools/screens/capture.cjs` (Playwright on the web build; signs in by tapping the demo account) captured 84 screens of the unchanged UI Design 4 build into `docs/ui-revamp/ui-design-4-baseline/` (360 px and 1280 px; main tabs also dark, Telugu and Easy mode), for the side-by-side comparisons later.
- **Phase 3 (8 Nov).** `DESIGN.md` written (frontmatter tokens for light and dark plus prose rules: two registers, colours and states, type scale and the Indic rule, layout, elevation, shapes, every component, states, Easy mode, motion, writing numbers, do's and don'ts). Colour roles checked by script in light, dark and both high-contrast themes: every text pair 4.5:1+, borders, icons and focus 3:1+. `docs/PROJECT_SPEC.md` section 4 now summarises UI Design 5; `CLAUDE.md` has the line "Design rules: DESIGN.md (UI Design 5)".
- **Phase 4 (8 Nov).** Fonts bundled (Baloo 2 / Baloo Tammudu 2 static 600/700 cut with fonttools; Hind / Hind Guntur 400–700; OFL licences). `tokens.dart`: Genda colours (light, dark, high contrast), new type scale (13 px minimum, Indic bump), 22 px cards, warm shadow, date block 56 px, garland sizes, side nav 256 px; category, print and video-call colours without red or teal. `app_theme.dart`: Baloo titles / Hind text per language, no Indic letter-spacing, cocoa count badges (were SOS red), navigation indicator, chips, list rows. Widgets restyled (cards, buttons, pills, date block, health pass on the band, skeletons, timeline, drawings recoloured); danger buttons berry in both themes (dark used SOS red). New `GendaBand`/`Garland` with previews and 5 widget tests. Design gallery rebuilt (light/dark/high contrast switch); screenshots in `docs/ui-designs/ui-design-5-gallery/`. Contrast test has the new pairs and passes; analyzer clean; token check clean.
- **Batch A (8 Nov), built.** `owner_shell.dart`: Material navigation bar on phones (labels always shown, cocoa pill), navigation rail on tablets, rail extended to 256 px side navigation on desktop (logo + 5 tabs); top bar with pet pills, messages, notifications and SOS on every size. SOS pill solid red with white text. Screenshots in `docs/ui-revamp/ui-design-5-A-shell/` (Home and Health hosts: 360/1280, light/dark, Telugu, Easy mode, tablet 800).
- **Checks:** before the merge `flutter analyze` clean, 204 of 204 tests pass; after the merge `flutter analyze` clean, 210 of 210 tests pass.

### Batch A summary (AGENTS.md format)
(a) Five lines:
1. New foundation: Genda colours, Baloo + Hind fonts (bundled), 13 px minimum, 22 px cards, warm shadows, one red (SOS).
2. Shared widgets restyled; new Genda band (pet photo in a marigold garland, one flower per task) with tests and previews.
3. Shell: standard Material bottom bar on phones, rail on tablets, side navigation on desktop; SOS solid red; badges cocoa.
4. Design gallery shows every component in light, dark and high contrast (`docs/ui-designs/ui-design-5-gallery/`).
5. Checks: analyzer clean, 215 of 215 tests pass (incl. 200% text sweep in en/hi/te), token check clean, audit 19/20.

(b) What to test: open the app on a phone width → the bottom bar has 5 labelled tabs with a dark pill on the selected one; the red SOS pill is top right; message and bell badges are brown, not red. Widen the window past 640 px → a rail on the left; past 1024 px → side navigation with the logo. Settings → Appearance → Dark and High contrast → everything stays readable. Settings → About → tap 5 times → the design gallery.

(c) Anything you must do: nothing for this batch.

## Decisions (and why)

- 8 Nov: Work branch based on `ui-revamp` (UI Design 4 + setup), because UI Design 5 must build on the current app, and the session had started on UI Design 1.
- 8 Nov: Owner's answers recorded in the brief (feel, Home, tabs, colours, fonts, pictures, how to pick, order of work, Plus fix).
- 8 Nov: Design ideas that would change how the app works are not built; they go in the morning report as suggestions.

- 8 Nov, Phase 2: **Genda chosen** by the owner's scoring order: readability (A 9, B 7.5, C 9), fit (A 7, B 6, C 9), distinct (A 9, B 9, C 8); weighted 50 / 43.5 / 53. The owner's tie-break (warmer) agrees. The roll had assigned A; the owner's own rules beat the roll (Impeccable allows this).
- 8 Nov, Phase 2: **Supertails check.** Read Supertails' live site in a browser: theme colour `#EF6C00`, buttons `#FF9A16` (orange), plus navy and pastel lavender. Genda's first marigold header band was too close, so the band became cocoa and marigold is kept to the garland, progress and highlights.
- 8 Nov, Phase 2: **Never letter-space or upper-case Hindi or Telugu** (it broke Telugu words in A and B). Goes into DESIGN.md.
- 8 Nov, Phase 2: Impeccable's "decision page" (which waits for the owner to click) was not opened, because the owner is offline and delegated the choice; the three directions and the pick are on the compare page instead. Critique ran as a design review only (Flutter = native platform for Impeccable; its web detector doesn't apply).
- 8 Nov, Phase 2: platform recorded as `android` in PRODUCT.md (one Flutter Material 3 app for Android, iOS and web; Android phones are the main device).

- 8 Nov, Phase 3: **form errors are berry (`#8C1D6E`), not red**, to keep SOS the only red (owner's rule 1). Errors always carry an icon and words.
- 8 Nov, Phase 3: DESIGN.md is written now (owner's Phase 3), although Impeccable normally writes it after the build; at the finish the Impeccable documenter checks it against the built app and fixes any drift.
- 8 Nov, Phase 3: desktop uses Material side navigation (256 px) instead of UI Design 4's top bar with pill tabs (that pattern wrapped menu items in UI Design 2); tablets a navigation rail; phones the standard bottom bar (not UI Design 4's floating dark bar).
- 8 Nov, Phase 3: the smallest text rises from 12 px (UI Design 4's labelSmall and overline) to 13 px; Hindi and Telugu secondary text one step up (15 px).

- 8 Nov, Phase 4: the translation merge tool (`tools/l10n/merge.dart`) rebuilds the ARB files from `lib/core/l10n/src/*.json`, but 5 strings had been added to the ARB files only (`bookFor`, `nextFreeSlot`, `healthAllClear`, `certificate`, `emergencyInfo`), so a merge dropped them. They were added to the source files; their translator notes ("@" descriptions) were lost, because the source format has no place for them.
- 8 Nov, Phase 4: `dart format` is run only on files I write, at `--page-width 160` (the project's style); a whole-folder format reflowed 14 untouched files, which were restored.
- 8 Nov, Batch A: desktop side navigation holds only the 5 tabs; messages, notifications and SOS stay in the top bar so nothing appears twice (DESIGN.md corrected). No global search was added (the app has none; inventing it would be a feature).
- 8 Nov, Batch A: **not done (owner's decision):** keeping the navigation visible on screens opened outside the tabs (pet profile, messages, SOS…). It would change how navigation and Back work; listed in the morning report as a suggestion.

## Problems

- None open.

## Check-ins

- 16 one-time check-in messages are scheduled into this session (made 8 Nov 08:31 UTC), one about every 60 minutes for 16 hours: 09:31, 10:31 … 18:31, 19:28, 20:31 … 23:31 UTC on 8 Nov and 00:31 UTC on 9 Nov (15:01 to 06:01 India time). Each one runs once and then switches itself off. **When everything is finished, cancel the ones still waiting** (delete_trigger with these ids):
  trig_01GyXhDHLDF9HFyqoptmsMTx, trig_01N7AurCA82it4v85v12ZxkY, trig_01CqZegs7EGEQNWvTj6caRMu, trig_01VsukHhrUVJEKw2HkDhFX1a, trig_01WL1eFtwpAhYKspo4QyxLHC, trig_01UFd94XDNd24NvxD1sy3q1B, trig_01XXfmDa8HjuHiV5sAA1guuz, trig_019FUsZHf3tHS8mzF5jDHjaK, trig_01KPWG2zQc3uwXYeNN99ZYvB, trig_014kCgcC7ej8h6Apwy384BCq, trig_019S7wRYF6G2bjnpk1EGKdwm, trig_01HZfFdUPp1Cns1mmqq4ayLh, trig_017go7DTGAVSPN7S6twKjc6n, trig_013agTCzKiTc45neTJfg6q6M, trig_01GXZsgGZsGv5b2bv6oYeND9, trig_01749Wmtj2wsNgZus1rAQomB
- A check-in that arrives while I'm working waits until the current step ends; it never interrupts.

## For you when you're back

1. **The naming changes are already in `ui-revamp`.** Nothing to do: pull request #2 merged them on 7 Nov (commit `b884e3a`).
2. **Make `ui-revamp` GitHub's default branch** (so new cloud sessions start from it; UI Design 1 stays saved on `claude/zen-ramanujan-4g7djn`):
   1. Open https://github.com/ajithdo/PETAPP-VERSION-1 and click **Settings** (top right of the repo menu).
   2. On the **General** page, find **Default branch**.
   3. Click the **⇄ switch** button next to `claude/zen-ramanujan-4g7djn`.
   4. Pick **ui-revamp** and click **Update**.
   5. Click **I understand, update the default branch**.
3. **Put the Plus fix on the live site (UI Design 4) now**, so returning visitors see Priya on Plus. It needs a merge with small conflicts and a deploy, so let a new Claude session do it:
   1. Open https://claude.ai/code and start a new session on **ajithdo/PETAPP-VERSION-1**, branch **ui-revamp**.
   2. Paste: *"Merge claude/serene-pascal-kjqctd into ui-revamp. Settle the conflicts the way commit 'Merge the demo Plus fix' on claude/happy-wozniak-68a4q2 did (keep both sets of notes; in test/core/demo_auth_test.dart keep both fixes). Run flutter analyze and all tests. I approve pushing ui-revamp. Then build the web app and deploy it to the live pawsetu-demo Netlify site; I approve that deploy."*
   3. Approve the push and the deploy when it asks.
4. **On your own computer, once** (only needed for local Claude Code sessions, not cloud ones):
   1. Open a terminal in the project folder and run: `claude plugin install security-guidance@claude-plugins-official --scope project`
   2. Start `claude` in the project folder. It asks to approve the 5 tool servers (dart, firebase, playwright, chrome-devtools, context7): choose **Yes** for each.
   3. Optional: run `npx -y firebase-tools@latest login` if you want the Firebase tools to see your real Firebase project.
