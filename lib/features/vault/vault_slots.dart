import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../pets/domain/pet.dart';

/// Phase 7 slots (document vault, insurance, memory album, share links).
/// Shared files call these; only Phase 7 edits this file.

/// Routes under /me: must include 'vault' and 'album' (Me menu links to
/// /me/vault and /me/album).
final vaultMeRoutes = <RouteBase>[];

/// Full-screen routes, e.g. /pets/:id/vault, /pets/:id/album, and the public
/// share page /share/:token (already a public path in the router).
final vaultRootRoutes = <RouteBase>[];

/// Pet profile section links (pet_links.dart).
String petVaultLink(String petId) => '/coming-soon?phase=7&title=Vault';
String petAlbumLink(String petId) => '/coming-soon?phase=7&title=Album';

/// Home "Add photo" quick action.
String addPhotoLink(String petId) => '/coming-soon?phase=7&title=Album';

/// Home card with the latest memory or a milestone for [pet]. Empty list =
/// nothing to show.
List<Widget> latestMemorySection(BuildContext context, WidgetRef ref, Pet pet) => const [];
