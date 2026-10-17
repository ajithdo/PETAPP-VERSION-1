# Redesign progress

Branch: `claude/gifted-hypatia-640t3h` (restarted from the default branch `claude/zen-ramanujan-4g7djn` at `47e7510`).

## Done

### Phase 0: environment check (17 Oct 2026)

Environment: Claude Code cloud session, Ubuntu 24.04, Flutter installed by `.claude/hooks/session-start.sh`. All goldens and measurements in this redesign come from this environment.

| Check | Result |
|---|---|
| `flutter --version` | Flutter 3.47.7 stable, Dart 3.13.5 |
| `flutter analyze` | No issues (41 s) |
| `flutter test` | 203 passed, 0 failed (2 min 8 s). APP_OVERVIEW.md's "192" predates later tests. |
| Server and security tests | 170 passed, 0 failed, 75 suites (`npx firebase-tools@14 emulators:exec --only firestore,storage --project demo-pawsetu "npm --prefix functions test"`, 1 min 46 s) |
| `flutter build web --release` | Built in 2 min 22 s. `build/web` 50 MB on disk; `main.dart.js` 10.1 MB (2.42 MB gzipped). |
| Serve and screenshot | Served `build/web` locally with an index.html fallback; Playwright (Chromium 141 at `/opt/pw-browsers/chromium`) screenshots at 360, 800 and 1280 px; 0 console errors. Opens on `/#/signin`. |
| Load on localhost (no throttling) | Flutter view on screen after about 2.8–3.2 s. Throttled numbers come in Phase 1. |

Tools:

| Tool | Status |
|---|---|
| frontend-design, impeccable skills | Available (principles and critique only; Impeccable's checker reads web code, not Flutter). |
| dart-flutter plugin skills (25) | Available. |
| Dart and Flutter MCP server | Works (`analyze_files` checked). |
| Playwright MCP, Chrome DevTools MCP | Failed at first: both looked for Google Chrome. `.mcp.json` now points them at `/opt/pw-browsers/chromium`, headless, isolated, no sandbox (the cloud runs as root). Both tested OK through a direct stdio probe; live in the next session. |
| @playwright/test (Node) | Works; used for scripted screenshots. |
| webapp-testing skill | Its examples use Python Playwright, which isn't installed; the same steps run with Node @playwright/test. |
| Context7 | Monthly free quota used up. Needs a free API key, or use the Dart MCP server's `read_package_uris` / `rip_grep_packages` to read the installed go_router 18 and Riverpod 3 source directly. |
| Semgrep | Not installed; available from PyPI (1.181.0) for Phase 9. |
| /security-review | Available. |

Notes for later phases:
- The web build uses hash URLs (`/#/home`), so refresh and shared links already reach the right route when the route exists.
- No Android SDK here: APK build, APK size, on-device frame times and Android integration tests go under "To do on a computer with the Android SDK".

## Next

Phase 1: baseline audit (goldens, accessibility checks in the layout sweep, performance, critique, AUDIT.md). Waiting for the go-ahead.

## Decisions

- Branch restarted from the default branch because its earlier pull request was already merged.
- Browser MCP servers use the cloud's preinstalled Chromium.
