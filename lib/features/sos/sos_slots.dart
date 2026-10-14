import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/widgets.dart';

/// Phase 9 slots (SOS, first aid, toxic food checker, lost pet mode and QR
/// tags, smart devices). Shared files call these; only Phase 9 edits this file.

/// Opens the SOS flow from the red top-bar button (after the 2-second hold).
void openSos(BuildContext context, WidgetRef ref) {
  showDemoDialog(context, title: context.l10n.sosTitle, body: context.l10n.comingInPhase(9));
}

/// Routes under /me: must include 'lost' and 'devices' (Me menu links to
/// /me/lost and /me/devices).
final sosMeRoutes = <RouteBase>[];

/// Full-screen routes, e.g. /sos, /first-aid, /first-aid/:id, /toxic-check,
/// /pets/:id/qr, and the public finder page /lost/:token (already public).
final sosRootRoutes = <RouteBase>[];

/// Pet profile "QR tag" link.
String petQrLink(String petId) => '/coming-soon?phase=9&title=QR';
