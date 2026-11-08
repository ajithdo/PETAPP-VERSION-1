# UI Design 5 — run log

Read this first after a usage reset, a restart or a context summary, then continue from **Next step**.

## Status

- **Phase:** 1 (brief) done. Waiting for the owner's GO, which they queued.
- **Work branch:** `claude/happy-wozniak-68a4q2` (push only this branch).
- **Next step:** after GO → Phase 2: three directions. Mock Home, Health, Book and one portal screen as HTML with the app's real text, at 390 px and 1440 px, light and dark; screenshot with Playwright into `docs/ui-designs/ui-design-5-directions/`; make one compare page; check contrast, 13 px minimum, SOS-only red, Hindi/Telugu fit; run Impeccable critique on each; score and pick (rules in the brief, section 5); log the scores.

## Plan (from the owner's prompt)

| Phase | What | State |
|---|---|---|
| A | Check the Claude setup | done |
| B | Names and branch | done |
| 1 | Brief (`docs/ui-designs/ui-design-5-brief.md`) | done |
| 2 | Three directions, pick one | next |
| 3 | Design rules: DESIGN.md, PRODUCT.md, PROJECT_SPEC section 4, CLAUDE.md line | — |
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
- **Checks before the merge:** `flutter analyze` clean, 204 of 204 tests pass.

## Decisions (and why)

- 8 Nov: Work branch based on `ui-revamp` (UI Design 4 + setup), because UI Design 5 must build on the current app, and the session had started on UI Design 1.
- 8 Nov: Owner's answers recorded in the brief (feel, Home, tabs, colours, fonts, pictures, how to pick, order of work, Plus fix).
- 8 Nov: Design ideas that would change how the app works are not built; they go in the morning report as suggestions.

## Problems

- None open.

## Check-ins

- 16 one-time check-in messages are scheduled into this session, one every 60 minutes for 16 hours (ids listed below once made). Cancel any left when the work is finished.

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
