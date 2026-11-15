@AGENTS.md

Design rules: DESIGN.md (UI Design 5)

## Which tool for which job
- Screens, layout, colour, type, UX copy → the impeccable skill. It is the ONLY design skill. Review Flutter from source; its web detector doesn't apply.
- Overflows, unbounded constraints, phone/tablet/desktop layouts → flutter-fix-layout-issues, flutter-build-responsive-layout.
- Running and checking the app → the dart server: launch_app (Chrome or Android emulator), hot_reload after UI edits, widget_inspector, get_runtime_errors. Screenshots: flutter_driver_command, or Playwright on the web build at 360, 768 and 1280 px.
- Tests → the dart server's run_tests tool, plus the widget and integration test skills.
- Adding a package → pub_dev_search, then Context7 for current docs; follow the package rules in AGENTS.md.
- firestore.rules / storage.rules → firestore-rules-creation to write, firebase-security-rules-auditor to review, then run the rules tests listed under "Checks" in README.md.
- Bigger features → Superpowers: brainstorming → writing-plans → executing-plans. Still show me the plan and wait, as AGENTS.md says.
- Bugs → systematic-debugging. Before saying anything is done → verification-before-completion.
- Deploying the web demo → netlify-deploy, only after I say yes.

## Flutter hot reload (official Flutter rule)

# Proactive Flutter Hot Reload Rule

Whenever you edit or modify any `.dart` file under `lib/` in this project:

1. **When to Skip**:
   - **Files Outside `lib/`**: Only trigger hot reload or hot restart for edits under `lib/`. Do not trigger when modifying files in other directories (e.g., `test/**`, `integration_test/**`, `benchmark/**`, `test_driver/**` or `example/**`).
   - **Comments & Documentation**: Do not trigger hot reload or hot restart when changes only affect comments, docstrings, or whitespace.

2. **Discover & Connect**:
   - Discover active running application instances using the `dtd` MCP Tool (or `list_running_apps` / `vm_service`) from the Dart MCP server.

3. **Trigger Hot Reload / Hot Restart**:
   - Execute the `hot_reload` MCP tool immediately after making changes to UI widgets (including `build` methods of stateful widgets) or simple methods.
   - Execute the `hot_restart` MCP tool if fundamental logic, state initialization (e.g., `initState`), global/static state, or `main()` was modified.
