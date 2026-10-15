import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/data/converters.dart';
import '../../core/theme/tokens.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/widgets.dart';
import '../pets/domain/pet.dart';
import 'presentation/devices_screens.dart';
import 'presentation/first_aid_screens.dart';
import 'presentation/lost_screens.dart';
import 'presentation/public_lost_screen.dart';
import 'presentation/sos_screen.dart';
import 'presentation/toxic_screen.dart';

/// Phase 9 slots (SOS, first aid, toxic food checker, lost pet mode and QR
/// tags, smart devices). Shared files call these; only Phase 9 edits this file.

/// Opens the SOS flow from the red top-bar button (after the 2-second hold).
void openSos(BuildContext context, WidgetRef ref) {
  GoRouter.of(context).push('/sos');
}

/// Routes under /me (the Me menu links to /me/lost and /me/devices).
final sosMeRoutes = <RouteBase>[
  GoRoute(path: 'lost', builder: (_, _) => const LostHomeScreen()),
  GoRoute(path: 'lost/:petId', builder: (_, s) => PetLostScreen(petId: s.pathParameters['petId']!)),
  GoRoute(path: 'devices', builder: (_, _) => const DevicesScreen()),
  GoRoute(path: 'devices/add', builder: (_, _) => const PairDeviceScreen()),
  GoRoute(path: 'devices/:id', builder: (_, s) => DeviceScreen(deviceId: s.pathParameters['id']!)),
];

/// Full-screen routes, including the public finder page /lost/:token.
final sosRootRoutes = <RouteBase>[
  GoRoute(path: '/sos', builder: (_, s) => SosScreen(petId: s.uri.queryParameters['pet'])),
  GoRoute(path: '/first-aid', builder: (_, _) => const FirstAidListScreen()),
  GoRoute(path: '/first-aid/:id', builder: (_, s) => FirstAidGuideScreen(id: s.pathParameters['id']!)),
  GoRoute(path: '/toxic-check', builder: (_, s) => ToxicCheckScreen(query: s.uri.queryParameters['q'])),
  GoRoute(path: '/lost/:token', builder: (_, s) => PublicLostScreen(token: s.pathParameters['token']!)),
];

/// Pet profile "QR tag" link.
String petQrLink(String petId) => '/me/lost/$petId';

/// Home: a red banner for each lost pet, at the top.
List<Widget> lostPetSection(BuildContext context, WidgetRef ref, List<Pet> pets) {
  final l = context.l10n;
  return [
    for (final p in pets.where((p) => p.lost != null))
      Padding(
        padding: const EdgeInsets.only(top: Space.lg),
        child: PawCard(
          onTap: () => context.push('/me/lost/${p.id}'),
          color: context.paw.sos.withValues(alpha: 0.08),
          borderColor: context.paw.sos,
          semanticLabel: l.lostBannerTitle(p.name),
          child: Row(children: [
            Icon(Icons.travel_explore_rounded, color: context.paw.sos, size: 32),
            const SizedBox(width: Space.md),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(l.lostBannerTitle(p.name), style: context.text.titleMedium?.copyWith(color: context.paw.sos)),
                Text(
                  l.lostBannerBody(Fmt.dateTime(parseDate(p.lost?['since']) ?? DateTime.now(), context.lang), (p.lost?['area'] as String?) ?? ''),
                  style: context.text.bodySmall,
                ),
              ]),
            ),
            const Icon(Icons.chevron_right_rounded),
          ]),
        ),
      ),
  ];
}
