import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Phase 10 slots (admin panel, PawSetu Plus, coupons, help and complaints,
/// privacy centre). Shared files call these; only Phase 10 edits this file.

/// Admin panel sections (see admin_shell.dart for the section keys).
/// Null = coming soon.
Widget? adminSection(BuildContext context, WidgetRef ref, String section) => null;

/// Extra admin pages under /admin/ (e.g. detail pages).
final adminExtraRoutes = <RouteBase>[];

/// Routes under /me: must include 'plus', 'help' and 'privacy' (Me menu and
/// the Plus prompt link to /me/plus, /me/help and /me/privacy).
final adminMeRoutes = <RouteBase>[];

/// Full-screen routes if needed.
final adminRootRoutes = <RouteBase>[];
