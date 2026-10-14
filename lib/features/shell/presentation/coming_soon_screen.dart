import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/widgets.dart';

/// Friendly placeholder for sections built in a later phase, and the
/// not-found page. Back always works.
class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({super.key, required this.title, required this.phase, this.notFound = false, this.embedded = false});
  final String title;
  final int phase;
  final bool notFound;
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final content = EmptyState(
      scene: notFound ? Scene.search : Scene.welcomeBridge,
      title: notFound ? l.notFoundTitle : (title.isEmpty ? l.comingSoon : title),
      message: notFound ? l.notFoundBody : l.comingInPhase(phase),
      actionLabel: notFound ? l.goHome : null,
      onAction: notFound ? () => context.go('/splash') : null,
    );
    if (embedded) return content;
    return Scaffold(appBar: AppBar(title: Text(notFound ? '' : title)), body: content);
  }
}
