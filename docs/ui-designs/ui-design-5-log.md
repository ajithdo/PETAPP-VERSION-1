# UI Design 5 — run log

Read this first after a usage reset, a restart or a context summary, then continue from **Next step**.

## Status

- **Phase:** 2 done (direction chosen: **C. Genda**). Now Phase 3 (design rules).
- **Work branch:** `claude/happy-wozniak-68a4q2` (push only this branch).
- **Next step:** Phase 3: write DESIGN.md (tokens for light, dark, high contrast; components; states; text rules) from Genda, update PRODUCT.md if needed, PROJECT_SPEC.md section 4, and the CLAUDE.md line. Then Phase 4 (bundle fonts, tokens.dart, app_theme.dart, shared widgets, gallery).

## Plan (from the owner's prompt)

| Phase | What | State |
|---|---|---|
| A | Check the Claude setup | done |
| B | Names and branch | done |
| 1 | Brief (`docs/ui-designs/ui-design-5-brief.md`) | done |
| 2 | Three directions, pick one | done: Genda |
| 3 | Design rules: DESIGN.md, PRODUCT.md, PROJECT_SPEC section 4, CLAUDE.md line | next |
| 4 | Foundation: tokens, theme, shared widgets, design gallery | — |
| 5A | Shell: navigation, top bar, pet switcher, SOS | — |
| 5B | Home, Health, Book, Shop, Me | — |
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
- **Checks:** before the merge `flutter analyze` clean, 204 of 204 tests pass; after the merge `flutter analyze` clean, 210 of 210 tests pass.

## Decisions (and why)

- 8 Nov: Work branch based on `ui-revamp` (UI Design 4 + setup), because UI Design 5 must build on the current app, and the session had started on UI Design 1.
- 8 Nov: Owner's answers recorded in the brief (feel, Home, tabs, colours, fonts, pictures, how to pick, order of work, Plus fix).
- 8 Nov: Design ideas that would change how the app works are not built; they go in the morning report as suggestions.

- 8 Nov, Phase 2: **Genda chosen** by the owner's scoring order: readability (A 9, B 7.5, C 9), fit (A 7, B 6, C 9), distinct (A 9, B 9, C 8); weighted 50 / 43.5 / 53. The owner's tie-break (warmer) agrees. The roll had assigned A; the owner's own rules beat the roll (Impeccable allows this).
- 8 Nov, Phase 2: **Supertails check.** Read Supertails' live site in a browser: theme colour `#EF6C00`, buttons `#FF9A16` (orange), plus navy and pastel lavender. Genda's first marigold header band was too close, so the band became cocoa and marigold is kept to the garland, progress and highlights.
- 8 Nov, Phase 2: **Never letter-space or upper-case Hindi or Telugu** (it broke Telugu words in A and B). Goes into DESIGN.md.
- 8 Nov, Phase 2: Impeccable's "decision page" (which waits for the owner to click) was not opened, because the owner is offline and delegated the choice; the three directions and the pick are on the compare page instead. Critique ran as a design review only (Flutter = native platform for Impeccable; its web detector doesn't apply).
- 8 Nov, Phase 2: platform recorded as `android` in PRODUCT.md (one Flutter Material 3 app for Android, iOS and web; Android phones are the main device).

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
