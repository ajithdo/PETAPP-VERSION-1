import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import 'cards.dart';

/// One step on a vertical timeline (vaccines, order and booking progress):
/// a coloured dot on a thin line, then the step's content. Done steps are
/// green, due soon amber, overdue red, the rest a hollow ring.
class TimelineTile extends StatelessWidget {
  const TimelineTile({
    super.key,
    required this.child,
    this.tone = ChipTone.neutral,
    this.isFirst = false,
    this.isLast = false,
    this.onTap,
  });

  final Widget child;
  final ChipTone tone;
  final bool isFirst;
  final bool isLast;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final paw = context.paw;
    final (fill, ring) = switch (tone) {
      ChipTone.success => (paw.success, paw.success),
      ChipTone.warning => (paw.warning, paw.warning),
      ChipTone.error => (paw.error, paw.error),
      ChipTone.info => (paw.brand, paw.brand),
      _ => (paw.surface, paw.controlBorder),
    };
    final line = paw.outline;
    final rail = SizedBox(
      width: Sizes.timelineRail,
      child: Column(children: [
        Container(width: Strokes.focus, height: Space.xs + Space.xxs, color: isFirst ? null : line),
        Container(
          width: Sizes.timelineDot,
          height: Sizes.timelineDot,
          decoration: BoxDecoration(
            color: fill,
            shape: BoxShape.circle,
            border: Border.all(color: ring, width: Strokes.focus),
          ),
        ),
        Expanded(child: Container(width: Strokes.focus, color: isLast ? null : line)),
      ]),
    );
    final row = IntrinsicHeight(
      child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        rail,
        const SizedBox(width: Space.sm),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : Space.lg),
            child: child,
          ),
        ),
      ]),
    );
    if (onTap == null) return row;
    return InkWell(onTap: onTap, borderRadius: BorderRadius.circular(Radii.md), child: row);
  }
}
