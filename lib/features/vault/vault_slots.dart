import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../album/presentation/album_screen.dart';
import '../album/presentation/birthday_screen.dart';
import '../album/presentation/memory_card.dart';
import '../pets/domain/pet.dart';
import 'presentation/doc_detail_screen.dart';
import 'presentation/insurance_screens.dart';
import 'presentation/public_share_screen.dart';
import 'presentation/read_screen.dart';
import 'presentation/shares_screen.dart';
import 'presentation/vault_gate.dart';
import 'presentation/vault_screen.dart';

/// Phase 7 slots (document vault, insurance, memory album, share links).
/// Shared files call these; only Phase 7 edits this file.

/// Routes under /me: 'vault' and 'album' (the Me menu links to them).
final vaultMeRoutes = <RouteBase>[
  GoRoute(path: 'vault', builder: (_, _) => const VaultGate(child: VaultScreen())),
  GoRoute(path: 'album', builder: (_, _) => const AlbumScreen()),
];

/// Full-screen routes: per-pet vault and album, document pages, insurance,
/// share links and the public share page /share/:token (no sign-in).
final vaultRootRoutes = <RouteBase>[
  GoRoute(path: '/pets/:id/vault', builder: (_, s) => VaultGate(child: VaultScreen(petId: s.pathParameters['id']))),
  GoRoute(
    path: '/pets/:id/album',
    builder: (_, s) => AlbumScreen(petId: s.pathParameters['id'], openAdd: s.uri.queryParameters['add'] == '1'),
  ),
  GoRoute(path: '/pets/:id/birthday', builder: (_, s) => BirthdayScreen(petId: s.pathParameters['id']!)),
  GoRoute(
    path: '/vault/doc/:id',
    builder: (_, s) => VaultGate(child: DocDetailScreen(docId: s.pathParameters['id']!)),
    routes: [
      GoRoute(
        path: 'read',
        builder: (_, s) => VaultGate(child: AutoReadScreen(docId: s.pathParameters['id']!, fromUpload: s.uri.queryParameters['new'] == '1')),
      ),
    ],
  ),
  GoRoute(path: '/vault/shares', builder: (_, _) => const VaultGate(child: ShareLinksScreen())),
  GoRoute(
    path: '/vault/insurance',
    builder: (_, s) => VaultGate(child: InsuranceScreen(petId: s.uri.queryParameters['pet'], docId: s.uri.queryParameters['doc'])),
  ),
  GoRoute(path: '/vault/insurance/:id', builder: (_, s) => VaultGate(child: PolicyScreen(policyId: s.pathParameters['id']!))),
  GoRoute(path: '/share/:token', builder: (_, s) => PublicShareScreen(token: s.pathParameters['token']!)),
];

/// Pet profile section links (pet_links.dart).
String petVaultLink(String petId) => '/pets/$petId/vault';
String petAlbumLink(String petId) => '/pets/$petId/album';

/// Home "Add photo" quick action.
String addPhotoLink(String petId) => '/pets/$petId/album?add=1';

/// Home card with the latest memory, "On this day" or a birthday for [pet].
List<Widget> latestMemorySection(BuildContext context, WidgetRef ref, Pet pet) => homeMemorySection(context, ref, pet);
