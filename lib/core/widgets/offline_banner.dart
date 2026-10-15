import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/tokens.dart';
import 'layout.dart';

/// False while the device has no network. When it can't tell (tests, an
/// unsupported platform) it counts as online.
final onlineProvider = StreamProvider<bool>((ref) async* {
  final connectivity = Connectivity();
  bool online(List<ConnectivityResult> r) => !(r.isNotEmpty && r.every((x) => x == ConnectivityResult.none));
  try {
    yield online(await connectivity.checkConnectivity());
  } catch (_) {
    yield true;
    return;
  }
  yield* connectivity.onConnectivityChanged.map(online).handleError((Object _) {});
});

/// A strip at the bottom of every screen while offline: saved information
/// keeps working and new entries wait for the connection (spec 14).
class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(onlineProvider).value ?? true) return child;
    return Column(children: [
      Expanded(child: MediaQuery.removePadding(context: context, removeBottom: true, child: child)),
      Material(
        color: Color.alphaBlend(context.paw.warning.withValues(alpha: 0.18), context.paw.surface),
        child: SafeArea(
          top: false,
          child: Semantics(
            liveRegion: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.sm),
              child: Row(children: [
                Icon(Icons.cloud_off_rounded, size: 20, color: context.paw.textPrimary),
                const SizedBox(width: Space.sm),
                Expanded(child: Text(context.l10n.offlineBanner, style: context.text.bodySmall?.copyWith(color: context.paw.textPrimary))),
              ]),
            ),
          ),
        ),
      ),
    ]);
  }
}
