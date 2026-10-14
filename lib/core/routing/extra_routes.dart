import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/admin/admin_slots.dart';
import '../../features/booking/presentation/book_home_screen.dart';
import '../../features/booking/presentation/booking_flow_screen.dart';
import '../../features/booking/presentation/my_bookings_screen.dart';
import '../../features/booking/presentation/place_finder_screen.dart';
import '../../features/booking/presentation/place_screen.dart';
import '../../features/family/presentation/family_screen.dart';
import '../../features/family/presentation/join_screen.dart';
import '../../features/health/presentation/health_report.dart';
import '../../features/health/presentation/health_screen.dart';
import '../../features/notifications/presentation/notification_screens.dart';
import '../../features/partner/presentation/partner_sections.dart';
import '../../features/partner/presentation/partner_signup_screen.dart';
import '../../features/pets/presentation/my_pets_screen.dart';
import '../../features/pets/presentation/pet_form_screen.dart';
import '../../features/pets/presentation/pet_profile_screen.dart';
import '../../features/messaging/messaging_slots.dart';
import '../../features/routine/presentation/routine_screen.dart';
import '../../features/routine/presentation/walk_tracker_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/shop/shop_slots.dart';
import '../../features/sos/sos_slots.dart';
import '../../features/vault/vault_slots.dart';
import '../widgets/layout.dart';

/// Routes and menus that grow phase by phase. router.dart wires them in.

/// Tab roots that are not built yet show an embedded placeholder.
Widget healthTab([String? petId]) => HealthTab(petId: petId);
Widget bookTab() => const BookHomeScreen();
Widget shopTab() => shopTabRoot();

final homeRoutes = <RouteBase>[];
final healthRoutes = <RouteBase>[];
final bookRoutes = <RouteBase>[
  GoRoute(
    path: 'find/:kind',
    builder: (_, s) => PlaceFinderScreen(kind: s.pathParameters['kind']!, startOnMap: s.uri.queryParameters['map'] == '1'),
  ),
  GoRoute(
    path: 'place/:id',
    builder: (_, s) => PlaceScreen(placeId: s.pathParameters['id']!),
  ),
  GoRoute(
    path: 'new/:placeId',
    builder: (_, s) =>
        BookingFlowScreen(placeId: s.pathParameters['placeId']!, serviceId: s.uri.queryParameters['service'], petId: s.uri.queryParameters['pet']),
  ),
  GoRoute(
    path: 'done/:id',
    builder: (_, s) => BookingDoneScreen(bookingId: s.pathParameters['id']!),
  ),
  GoRoute(path: 'bookings', builder: (_, _) => const MyBookingsScreen()),
  GoRoute(
    path: 'bookings/:id',
    builder: (_, s) => BookingDetailScreen(bookingId: s.pathParameters['id']!),
  ),
];
final shopRoutes = <RouteBase>[...shopTabRoutes];
final settingsRoutes = <RouteBase>[GoRoute(path: 'notifications', builder: (_, _) => const NotificationSettingsScreen())];
final meRoutes = <RouteBase>[
  GoRoute(path: 'pets', builder: (_, _) => const MyPetsScreen()),
  GoRoute(
    path: 'family',
    builder: (_, s) => FamilyScreen(initialPetId: s.uri.queryParameters['pet']),
  ),
  ...vaultMeRoutes,
  ...shopMeRoutes,
  ...sosMeRoutes,
  ...adminMeRoutes,
];

/// Full-screen routes outside the tabs.
final rootRoutes = <RouteBase>[
  GoRoute(path: '/settings', builder: (_, _) => const SettingsScreen()),
  ...messagingRootRoutes,
  ...vaultRootRoutes,
  ...shopRootRoutes,
  ...sosRootRoutes,
  ...adminRootRoutes,
  GoRoute(path: '/notifications', builder: (_, _) => const NotificationCentreScreen()),
  GoRoute(path: '/pets/new', builder: (_, _) => const PetFormScreen()),
  GoRoute(
    path: '/pets/:id',
    builder: (_, s) => PetProfileScreen(petId: s.pathParameters['id']!),
    routes: [
      GoRoute(
        path: 'edit',
        builder: (_, s) => PetFormScreen(petId: s.pathParameters['id']),
      ),
      GoRoute(
        path: 'routine',
        builder: (_, s) => RoutineScreen(petId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: 'report',
        builder: (_, s) => HealthReportScreen(petId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: 'card',
        builder: (_, s) => MedicalCardScreen(petId: s.pathParameters['id']!),
      ),
    ],
  ),
  GoRoute(
    path: '/walk/:petId',
    builder: (_, s) => WalkTrackerScreen(petId: s.pathParameters['petId']!),
  ),
  GoRoute(path: '/partner-signup', builder: (_, _) => const PartnerSignupScreen()),
  GoRoute(
    path: '/join/:token',
    builder: (_, s) => JoinScreen(token: s.pathParameters['token']!),
  ),
];

/// Extra partner portal pages (listed before the `:section` route).
final partnerRoutes = <RouteBase>[
  ...messagingPartnerRoutes,
  ...sellerPartnerRoutes,
  GoRoute(
    path: 'booking/:id',
    builder: (_, s) => BookingDetailScreen(
      bookingId: s.pathParameters['id']!,
      partnerView: true,
      partnerActions: (b) => PartnerBookingActions(booking: b),
    ),
  ),
];

class MeMenuItem {
  const MeMenuItem(this.icon, this.label, this.route);
  final IconData icon;
  final String label;
  final String route;
}

List<MeMenuItem> meMenu(BuildContext context) {
  final l = context.l10n;
  return [
    MeMenuItem(Icons.pets_rounded, l.myPets, '/me/pets'),
    MeMenuItem(Icons.family_restroom_rounded, l.familySharing, '/me/family'),
    MeMenuItem(Icons.lock_rounded, l.documentVault, '/me/vault'),
    MeMenuItem(Icons.photo_library_rounded, l.memoryAlbum, '/me/album'),
    MeMenuItem(Icons.watch_rounded, l.connectedDevices, '/me/devices'),
    MeMenuItem(Icons.qr_code_2_rounded, l.lostPetMode, '/me/lost'),
    MeMenuItem(Icons.account_balance_wallet_rounded, l.expenses, '/me/expenses'),
    MeMenuItem(Icons.workspace_premium_rounded, l.pawsetuPlus, '/me/plus'),
    MeMenuItem(Icons.settings_rounded, l.settings, '/me/settings'),
    MeMenuItem(Icons.support_agent_rounded, l.helpAndComplaints, '/me/help'),
    MeMenuItem(Icons.privacy_tip_rounded, l.privacyCentre, '/me/privacy'),
  ];
}
