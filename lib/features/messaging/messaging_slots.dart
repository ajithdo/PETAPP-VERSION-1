import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/app_user.dart';
import '../assistant/presentation/ask_screen.dart';
import '../televet/presentation/prescription_builder.dart';
import '../televet/presentation/prescription_pdf.dart';
import '../televet/presentation/televet_flow_screen.dart';
import '../televet/presentation/televet_home_screen.dart';
import '../televet/presentation/vet_consult_screen.dart';
import '../televet/presentation/vet_queue_section.dart';
import '../televet/presentation/video_call_screen.dart';
import 'presentation/inbox_screen.dart';

/// Phase 6 slots (messaging, tele-vet, Ask PawSetu). Shared files call these;
/// only Phase 6 edits this file.

/// Full-screen routes: /messages, /messages/new, /messages/:id, /televet...,
/// /ask (Ask PawSetu) and anything else Phase 6 needs.
final messagingRootRoutes = <RouteBase>[
  GoRoute(path: '/messages', builder: (_, _) => const MessagesHome()),
  // Before /messages/:id so "new" is not read as an id.
  GoRoute(
    path: '/messages/new',
    builder: (_, s) => NewConversationScreen(bookingId: s.uri.queryParameters['booking'], placeId: s.uri.queryParameters['place']),
  ),
  GoRoute(path: '/messages/:id', builder: (_, s) => MessagesHome(selectedId: s.pathParameters['id'])),
  GoRoute(path: '/televet', builder: (_, _) => const TeleVetHomeScreen()),
  GoRoute(path: '/televet/new', builder: (_, s) => TeleVetFlowScreen(petId: s.uri.queryParameters['pet'])),
  GoRoute(path: '/televet/consent', builder: (_, _) => const TeleVetConsentScreen()),
  GoRoute(path: '/televet/call/:id', builder: (_, s) => VideoCallScreen(consultationId: s.pathParameters['id']!)),
  GoRoute(path: '/ask', builder: (_, _) => const AskScreen()),
  GoRoute(path: '/prescriptions/:id', builder: (_, s) => PrescriptionScreen(prescriptionId: s.pathParameters['id']!)),
];

/// Extra partner portal pages under /partner/ (e.g. /partner/consult/:id).
final messagingPartnerRoutes = <RouteBase>[
  GoRoute(
    path: 'consult/:id',
    builder: (_, s) => VetConsultScreen(consultationId: s.pathParameters['id']!),
    routes: [
      GoRoute(path: 'prescription', builder: (_, s) => PrescriptionBuilderScreen(consultationId: s.pathParameters['id']!)),
    ],
  ),
];

/// Partner portal sections 'chat' (all partners) and 'televet' (vets).
/// Return null for sections this phase does not handle.
Widget? messagingPartnerSection(BuildContext context, WidgetRef ref, AppUser user, String section) => switch (section) {
      'chat' when user.role != UserRole.seller => const PartnerChatSection(),
      'televet' when user.role == UserRole.vet => const VetQueueSection(),
      _ => null,
    };

/// Route the Home "Ask a vet" quick action opens.
String get askVetLink => '/televet';
