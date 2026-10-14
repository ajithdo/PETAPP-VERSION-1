import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/app_user.dart';
import '../../core/widgets/widgets.dart';
import '../shell/presentation/coming_soon_screen.dart';

/// Phase 6 slots (messaging, tele-vet, Ask PawSetu). Shared files call these;
/// only Phase 6 edits this file.

/// Full-screen routes: /messages, /messages/new, /messages/:id, /televet...,
/// /ask (Ask PawSetu) and anything else Phase 6 needs.
final messagingRootRoutes = <RouteBase>[
  GoRoute(
    path: '/messages',
    builder: (c, _) => ComingSoonScreen(title: c.l10n.messages, phase: 6),
  ),
  GoRoute(
    path: '/televet',
    builder: (c, _) => ComingSoonScreen(title: c.l10n.teleVet, phase: 6),
  ),
];

/// Extra partner portal pages under /partner/ (e.g. /partner/consult/:id).
final messagingPartnerRoutes = <RouteBase>[];

/// Partner portal sections 'chat' (all partners) and 'televet' (vets).
/// Return null for sections this phase does not handle.
Widget? messagingPartnerSection(BuildContext context, WidgetRef ref, AppUser user, String section) => null;

/// Route the Home "Ask a vet" quick action opens.
String get askVetLink => '/televet';
