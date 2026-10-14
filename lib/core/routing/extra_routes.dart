import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/family/presentation/family_screen.dart';
import '../../features/family/presentation/join_screen.dart';
import '../../features/pets/presentation/my_pets_screen.dart';
import '../../features/pets/presentation/pet_form_screen.dart';
import '../../features/pets/presentation/pet_profile_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/shell/presentation/coming_soon_screen.dart';
import '../widgets/layout.dart';

/// Routes and menus that grow phase by phase. router.dart wires them in.

GoRoute _soon(String path, int phase, String Function(BuildContext) title) => GoRoute(
      path: path,
      builder: (context, _) => ComingSoonScreen(title: title(context), phase: phase),
    );

/// Tab roots that are not built yet show an embedded placeholder.
Widget healthTab() => Builder(builder: (c) => ComingSoonScreen(title: c.l10n.tabHealth, phase: 4, embedded: true));
Widget bookTab() => Builder(builder: (c) => ComingSoonScreen(title: c.l10n.tabBook, phase: 5, embedded: true));
Widget shopTab() => Builder(builder: (c) => ComingSoonScreen(title: c.l10n.tabShop, phase: 8, embedded: true));

final homeRoutes = <RouteBase>[];
final healthRoutes = <RouteBase>[];
final bookRoutes = <RouteBase>[];
final shopRoutes = <RouteBase>[];
final settingsRoutes = <RouteBase>[];
final meRoutes = <RouteBase>[
  GoRoute(path: 'pets', builder: (_, _) => const MyPetsScreen()),
  GoRoute(path: 'family', builder: (_, s) => FamilyScreen(initialPetId: s.uri.queryParameters['pet'])),
];

/// Full-screen routes outside the tabs.
final rootRoutes = <RouteBase>[
  GoRoute(path: '/settings', builder: (_, _) => const SettingsScreen()),
  _soon('/messages', 6, (c) => c.l10n.messages),
  _soon('/notifications', 4, (c) => c.l10n.notifications),
  GoRoute(path: '/pets/new', builder: (_, _) => const PetFormScreen()),
  GoRoute(
    path: '/pets/:id',
    builder: (_, s) => PetProfileScreen(petId: s.pathParameters['id']!),
    routes: [
      GoRoute(path: 'edit', builder: (_, s) => PetFormScreen(petId: s.pathParameters['id'])),
    ],
  ),
  GoRoute(path: '/join/:token', builder: (_, s) => JoinScreen(token: s.pathParameters['token']!)),
];

class MeMenuItem {
  const MeMenuItem(this.icon, this.label, this.route);
  final IconData icon;
  final String label;
  final String route;
}

List<MeMenuItem> meMenu(BuildContext context) {
  final l = context.l10n;
  String soon(int phase, String title) => '/coming-soon?phase=$phase&title=${Uri.encodeComponent(title)}';
  return [
    MeMenuItem(Icons.pets_rounded, l.myPets, '/me/pets'),
    MeMenuItem(Icons.family_restroom_rounded, l.familySharing, '/me/family'),
    MeMenuItem(Icons.lock_rounded, l.documentVault, soon(7, l.documentVault)),
    MeMenuItem(Icons.photo_library_rounded, l.memoryAlbum, soon(7, l.memoryAlbum)),
    MeMenuItem(Icons.watch_rounded, l.connectedDevices, soon(9, l.connectedDevices)),
    MeMenuItem(Icons.qr_code_2_rounded, l.lostPetMode, soon(9, l.lostPetMode)),
    MeMenuItem(Icons.account_balance_wallet_rounded, l.expenses, soon(8, l.expenses)),
    MeMenuItem(Icons.workspace_premium_rounded, l.pawsetuPlus, soon(10, l.pawsetuPlus)),
    MeMenuItem(Icons.settings_rounded, l.settings, '/me/settings'),
    MeMenuItem(Icons.support_agent_rounded, l.helpAndComplaints, soon(10, l.helpAndComplaints)),
    MeMenuItem(Icons.privacy_tip_rounded, l.privacyCentre, soon(10, l.privacyCentre)),
  ];
}
