import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/ph.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../pets/domain/pet.dart';
import '../data/health_repository.dart';
import '../domain/vaccine_schedule.dart';
import 'health_labels.dart';
import 'health_screen.dart';

/// "Next up" (Home and Health, UI Design 6): what is due soonest, in one
/// hairline panel. Each row leads with a date leaf (marigold when the first
/// one is due soon, red when overdue). The first row carries the action
/// ("Mark given", or "Book" when overdue); the rest open with an arrow.
class NextUpPanel extends ConsumerWidget {
  const NextUpPanel({super.key, required this.items, this.showPet = false});

  /// Most urgent first.
  final List<(Pet, DueItem)> items;
  final bool showPet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final paw = context.paw;
    if (items.isEmpty) {
      return PawPanel(
        child: Row(children: [
          Icon(Ph.checkCircleFill, color: paw.success),
          const SizedBox(width: Space.md),
          Expanded(child: Text(l.nothingDueAll, style: context.text.bodyMedium)),
        ]),
      );
    }
    return PawPanel(
      child: PawList(tight: true, children: [
        for (final (i, (pet, item)) in items.indexed)
          () {
            final overdue = item.status == DoseStatus.overdue;
            final tone = overdue ? ChipTone.error : (i == 0 ? ChipTone.warning : null);
            final title = dueTitle(context, item);
            final when = dueWhen(context, item);
            final at = item.at;
            return PawItem(
              lead: at != null
                  ? DateBadge(day: '${at.day}', month: Fmt.monthShort(at, context.lang), tone: tone)
                  : PawTile(icon: dueIcon(item.kind), size: Sizes.dateBadge),
              title: showPet ? '${pet.name} · $title' : title,
              sub: when.isEmpty ? statusChip(context, item.status).$1 : when,
              subWidget: tone == null
                  ? null
                  : Text(
                      when.isEmpty ? statusChip(context, item.status).$1 : when,
                      style: context.text.bodySmall?.copyWith(color: overdue ? paw.error : paw.accent, fontWeight: FontWeight.w600),
                    ),
              onTap: () => openDueItem(context, ref, pet, item),
              trailing: i != 0
                  ? null
                  : overdue && item.kind == 'vaccine'
                      ? PawButton(label: l.bookWord, kind: BtnKind.ink, onPressed: () => context.go('/book'))
                      : PawButton(label: l.markGiven, kind: BtnKind.line, onPressed: () => openDueItem(context, ref, pet, item)),
            );
          }(),
      ]),
    );
  }
}
