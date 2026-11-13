import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../pets/domain/pet.dart';
import '../data/routine_repository.dart';
import '../domain/routine.dart';
import 'quick_log_sheet.dart';
import 'routine_labels.dart';
import '../../../core/theme/ph.dart';

/// "Today" card: the daily plan as a checklist. Each row has a one-tap log
/// button. With [header] (routine screen) it opens with a progress ring and
/// the day's title; on Home the Genda band above already shows both, so the
/// card starts with "Today" and the streak.
class TodayCard extends ConsumerWidget {
  const TodayCard({super.key, required this.pet, this.big = false, this.header = true});
  final Pet pet;
  final bool big;
  final bool header;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final logs = ref.watch(petLogsProvider(pet.id));
    return PawCard(
      child: logs.when(
        loading: () => const Skeleton(height: Sizes.skeletonCard),
        error: (_, _) => Text(l.errorBody),
        data: (all) {
          final p = TodayProgress(pet: pet, logs: all);
          final s = streak(all.map((x) => x.at), DateTime.now());
          final streakChip = s > 1 ? StatusChip(l.streakDays(s), tone: ChipTone.accent, icon: Ph.fireFill) : null;
          final left = p.items.where((i) => i.$2 < i.$3).length;
          return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            // Home: the band above shows the streak, so this says what's left.
            if (!header)
              SecHead(l.today, note: left == 0 ? l.done : l.leftCount(left))
            else
            Row(children: [
              ProgressRing(
                progress: p.fraction,
                size: big ? Sizes.todayRingEasy : Sizes.todayRing,
                center: Text('${(p.fraction * 100).round()}%', style: context.text.labelLarge),
              ),
              const SizedBox(width: Space.lg),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(l.todayFor(pet.name), style: context.text.titleMedium),
                  const SizedBox(height: Space.xxs),
                  Text(
                    p.fraction >= 1 ? l.allDoneToday(pet.name) : l.tasksLeft(p.items.where((i) => i.$2 < i.$3).length),
                    style: context.text.bodySmall,
                  ),
                  if (streakChip != null) ...[const SizedBox(height: Space.sm), streakChip],
                ]),
              ),
            ]),
            if (header) ...[const SizedBox(height: Space.md), const Divider()],
            PawList(children: [
              for (final (i, item) in p.items.indexed)
                _ChecklistRow(
                  pet: pet,
                  type: item.$1,
                  done: item.$2,
                  goal: item.$3,
                  big: big,
                  // The first thing still open gets the marigold button.
                  primary: i == p.items.indexWhere((x) => x.$2 < x.$3),
                  last: p.today.where((x) => x.type == item.$1).fold<RoutineLog?>(null, (a, b) => a == null || b.at.isAfter(a.at) ? b : a),
                ),
            ]),
            const SizedBox(height: Space.md),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              PawButton(label: l.logSomething, icon: Ph.plus, kind: BtnKind.soft, onPressed: () => showQuickLog(context, ref, pet)),
              const SizedBox(width: Space.md),
              Flexible(child: TextLink(l.seeAll, onTap: () => context.push('/pets/${pet.id}/routine'))),
            ]),
          ]);
        },
      ),
    );
  }
}

class _ChecklistRow extends ConsumerWidget {
  const _ChecklistRow({required this.pet, required this.type, required this.done, required this.goal, required this.big, this.primary = false, this.last});
  final Pet pet;
  final LogType type;
  final int done;
  final int goal;
  final bool big;

  /// The next thing to do: its button is marigold.
  final bool primary;

  /// Today's latest log of this kind: who did it and when.
  final RoutineLog? last;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final paw = context.paw;
    // UI Design 6 list row: the task tick leads (a ring that fills, then a
    // marigold when done), the type and its count in the middle, and a
    // one-tap log button at the end.
    final play = type == LogType.play;
    final title = context.text.labelLarge;
    // Who did it and when ("7:00 am, Rohan"), from today's log.
    final who = last == null ? null : [Fmt.time(last!.at, context.lang), if (last!.byName.isNotEmpty) last!.byName.split(' ').first].join(', ');
    final meta = play ? [l.playOfMin(done, goal), if (last != null) Fmt.time(last!.at, context.lang)].join(', ') : who;
    return PawItem(
      lead: TaskTick(done: done, goal: goal, size: big ? IconSizes.xxl : IconSizes.xl),
      title: logTypeLabel(context, type),
      noTrailing: false,
      subWidget: null,
      sub: meta,
      titleWidget: Wrap(crossAxisAlignment: WrapCrossAlignment.center, spacing: Space.sm, children: [
        Icon(logTypeIcon(type), size: IconSizes.sm, color: paw.textPrimary),
        Text(logTypeLabel(context, type), style: title),
        if (!play && goal > 1) Text('$done/$goal', style: title?.copyWith(color: paw.textSecondary, fontFeatures: const [FontFeature.tabularFigures()])),
      ]),
      trailing: RoundButton(
        kind: primary ? BtnKind.primary : BtnKind.soft,
        tooltip: l.logNow(logTypeLabel(context, type)),
        icon: type == LogType.walk ? Ph.playFill : Ph.plus,
        onPressed: () async {
          if (type == LogType.walk) {
            context.push('/walk/${pet.id}');
            return;
          }
          HapticFeedback.lightImpact();
          final user = ref.read(currentUserProvider)!;
          await ref.read(routineRepositoryProvider).addLog(
                pet: pet,
                by: user,
                type: type,
                data: type == LogType.play ? {'minutes': 15} : null,
              );
          if (context.mounted) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(l.logged(logTypeLabel(context, type), pet.name))));
          }
        },
      ),
    );
  }
}
