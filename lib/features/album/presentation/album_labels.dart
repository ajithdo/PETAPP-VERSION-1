import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';
import '../../../core/widgets/widgets.dart';
import '../domain/album.dart';

String milestoneLabel(BuildContext context, String kind, {String? custom}) {
  final l = context.l10n;
  return switch (kind) {
    'birthday' => l.albumMsBirthday,
    'gotcha' => l.albumMsGotcha,
    'first_walk' => l.albumMsFirstWalk,
    'first_vaccine' => l.albumMsFirstVaccine,
    _ => (custom?.isNotEmpty ?? false) ? custom! : l.albumMsCustom,
  };
}

String itemMilestoneLabel(BuildContext context, AlbumItem i) => milestoneLabel(context, i.milestone ?? 'custom', custom: i.milestoneTitle);

IconData milestoneIcon(String kind) => switch (kind) {
      'birthday' => Icons.cake_rounded,
      'gotcha' => Icons.home_rounded,
      'first_walk' => Icons.directions_walk_rounded,
      'first_vaccine' => Icons.vaccines_rounded,
      _ => Icons.star_rounded,
    };

Color milestoneColor(BuildContext context, String kind) => switch (kind) {
      'birthday' => context.paw.accent,
      'gotcha' => PetTagColors.of('rose'),
      'first_walk' => context.paw.success,
      'first_vaccine' => context.colors.primary,
      _ => PetTagColors.of('lavender'),
    };

/// "1 year ago", "3 years ago".
String yearsAgoLabel(BuildContext context, DateTime then, {DateTime? now}) =>
    context.l10n.albumYearsAgo(yearsAgo(then, now ?? DateTime.now()).clamp(1, 99));

String videoLength(int seconds) => '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}';

/// Round milestone badge.
class MilestoneBadge extends StatelessWidget {
  const MilestoneBadge({super.key, required this.kind, this.size = 40, this.earned = true});
  final String kind;
  final double size;
  final bool earned;

  @override
  Widget build(BuildContext context) {
    final c = earned ? milestoneColor(context, kind) : context.paw.outline;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: c.withValues(alpha: earned ? 0.2 : 0.5),
        border: Border.all(color: c, width: 2),
      ),
      child: Icon(milestoneIcon(kind), size: size * 0.5, color: earned ? c : context.paw.textSecondary),
    );
  }
}
