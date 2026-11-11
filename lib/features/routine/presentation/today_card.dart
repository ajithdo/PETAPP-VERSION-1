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
          final streakChip = s > 1 ? StatusChip(l.streakDays(s), tone: ChipTone.accent, icon: Icons.local_fire_department_outlined) : null;
          final left = p.items.where((i) => i.$2 < i.$3).length;
          return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            // Home: the band above shows the streak, so this says what's left.
            if (!header)
              Row(crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [
                Expanded(child: Semantics(header: true, child: Text(l.today, style: context.text.titleLarge))),
                const SizedBox(width: Space.sm),
                Flexible(child: Text(left == 0 ? l.done : l.tasksLeft(left), style: context.text.bodySmall, textAlign: TextAlign.end)),
              ])
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
            SizedBox(height: header ? Space.md : Space.sm),
            if (header) const Divider(),
            for (final item in p.items)
              _ChecklistRow(
                pet: pet,
                type: item.$1,
                done: item.$2,
                goal: item.$3,
                big: big,
                last: p.today.where((x) => x.type == item.$1).fold<RoutineLog?>(null, (a, b) => a == null || b.at.isAfter(a.at) ? b : a),
              ),
            const SizedBox(height: Space.sm),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: Space.sm,
              runSpacing: Space.sm,
              children: [
                FilledButton.tonalIcon(
                  onPressed: () => showQuickLog(context, ref, pet),
                  style: FilledButton.styleFrom(backgroundColor: context.paw.surfaceSubtle, foregroundColor: context.paw.textPrimary),
                  icon: const Icon(Icons.add_rounded),
                  label: Text(l.logSomething),
                ),
                LinkButton(label: l.seeAll, onPressed: () => context.push('/pets/${pet.id}/routine')),
              ],
            ),
          ]);
        },
      ),
    );
  }
}

class _ChecklistRow extends ConsumerWidget {
  const _ChecklistRow({required this.pet, required this.type, required this.done, required this.goal, required this.big, this.last});
  final Pet pet;
  final LogType type;
  final int done;
  final int goal;
  final bool big;

  /// Today's latest log of this kind: who did it and when.
  final RoutineLog? last;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final complete = done >= goal;
    final paw = context.paw;
    // UI Design 6 list row: the task tick leads (a ring that fills, then a
    // marigold when done), the type and progress in the middle, and a
    // one-tap log button at the end. Rows are split by hairlines.
    final tick = big ? IconSizes.xxl : IconSizes.xl;
    final count = type == LogType.play ? l.playProgress(done, goal) : '$done/$goal';
    return Container(
      constraints: BoxConstraints(minHeight: big ? Sizes.listRowEasy : Sizes.listRow),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: paw.outline))),
      child: Row(children: [
        TaskTick(done: done, goal: goal, size: tick),
        const SizedBox(width: Space.md),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Wrap(crossAxisAlignment: WrapCrossAlignment.center, spacing: Space.sm, children: [
              Icon(logTypeIcon(type), size: IconSizes.md, color: paw.textPrimary),
              if (type != LogType.play) Text(logTypeLabel(context, type), style: (big ? context.text.titleMedium : context.text.titleSmall)),
              Text(count, style: (big ? context.text.titleMedium : context.text.titleSmall)?.copyWith(color: paw.textSecondary)),
            ]),
            // Who did it and when ("7:00 am, Rohan"), from today's log.
            if (last != null)
              Text(
                [Fmt.time(last!.at, context.lang), if (last!.byName.isNotEmpty) last!.byName.split(' ').first].join(', '),
                style: context.text.bodySmall?.copyWith(color: paw.textSecondary),
              ),
          ]),
        ),
        IconButton.filled(
          style: IconButton.styleFrom(
            backgroundColor: type == LogType.walk && !complete ? paw.action : paw.surfaceSubtle,
            foregroundColor: type == LogType.walk && !complete ? paw.onAction : paw.textPrimary,
            minimumSize: Size.square(big ? TapTarget.easy : TapTarget.min),
          ),
          tooltip: l.logNow(logTypeLabel(context, type)),
          icon: Icon(type == LogType.walk ? Icons.play_arrow_rounded : Icons.add_rounded, size: big ? IconSizes.xl : IconSizes.lg),
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
      ]),
    );
  }
}
