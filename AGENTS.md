# AGENTS.md

The full product spec is in @docs/PROJECT_SPEC.md. Read the sections relevant to the task before every task.

Progress lives in docs/PROGRESS.md, technical choices in docs/DECISIONS.md, the data model in docs/DATA_MODEL.md.

# 2. AGENT RULES (copy into AGENTS.md)
- Work one phase at a time. Never start the next phase until I paste its prompt.
- Before coding a phase: read the relevant spec sections and docs/PROGRESS.md, then show me a short plain-English plan and wait for my OK.
- Talk to me as a non-programmer. When you need me to do something, give numbered click-by-click steps.
- Every outside service sits behind an interface with a Demo implementation and a Live implementation (e.g. PaymentService -> DemoPaymentService / RazorpayPaymentService). A single config value APP_MODE = demo | live (overridable per service) chooses which one runs. Never call a real service in demo mode.
- Demo mode never charges money, never sends real SMS/WhatsApp/email and never dials a real number. Show a clear "Demo" dialog instead and log every simulated message to the Demo Outbox (visible in the admin panel).
- No hard-coded user-facing text. All strings go into the ARB files for en, hi and te. Keep translations natural and simple.
- Follow the design system in section 4 everywhere. Build shared widgets once in lib/core and reuse them; no one-off styling.
- Security: Firestore and Storage security rules for every collection (deny by default); roles enforced with Firebase custom claims on the server, not only in the UI; validate prices, limits and permissions in Cloud Functions. No secrets or API keys in app code or Git.
- Packages: use well-maintained packages that support Android, iOS AND web. Check pub.dev for the latest stable version and platform support before adding one. If a package lacks web support, give web a graceful fallback. Record choices in docs/DECISIONS.md.
- After finishing each phase: run the app on Chrome and the Android emulator; click through every new screen in light and dark mode, in English and Telugu, with Easy mode on, at 360 px phone width and at desktop width; fix all errors and layout overflows; run flutter analyze and all tests until clean; take screenshots of key screens.
- Then update docs/PROGRESS.md, commit to Git ("Phase N complete: ..."), and give me: (a) a 5-line summary, (b) a "what to test" checklist I can follow, (c) anything I must do.
- If you are stuck on the same error after 3 attempts, stop, explain it in plain words and offer 2 options.
- Never delete files outside this project. Ask me before anything destructive (force push, deleting data or Firebase projects, resetting Git).
- Version 2 trigger: if I say "Start Version 2" or "actual final version 2", read section 13 and follow the Live plan, one Live phase (L1-L5) at a time, starting with a plan.

# Project notes for agents (added during setup)
- Run modes are chosen with --dart-define flags (see lib/core/config/app_config.dart):
  - APP_MODE=demo|live (default demo)
  - BACKEND=standalone|emulator|firebase (default standalone). "standalone" runs the whole demo inside the app with an in-memory Firestore seeded from lib/core/demo/seed/. "emulator" uses the Firebase Local Emulator Suite seeded by tools/seed/seed.dart.
- Use only top-level Firestore collections (no subcollections); parent ids are fields. This keeps rules, queries and the standalone demo persistence simple.
- Generated code: run `dart run build_runner build -d` after changing freezed/json models, and `flutter gen-l10n` after editing ARB files in lib/core/l10n/.
