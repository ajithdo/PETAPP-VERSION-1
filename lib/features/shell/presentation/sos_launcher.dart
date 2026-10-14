import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/widgets.dart';

/// Opens the SOS flow. Phase 9 replaces this placeholder with the full
/// emergency sheet (call nearest clinic / get nearest clinic address).
void openSos(BuildContext context, WidgetRef ref) {
  showDemoDialog(context, title: context.l10n.sosTitle, body: context.l10n.comingInPhase(9));
}
