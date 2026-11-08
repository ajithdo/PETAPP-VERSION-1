import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
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
          return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            if (!header)
              Row(children: [
                Expanded(child: Semantics(header: true, child: Text(l.today, style: context.text.titleLarge))),
                ?streakChip,
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
              _ChecklistRow(pet: pet, type: item.$1, done: item.$2, goal: item.$3, big: big),
            const Divider(),
            const SizedBox(height: Space.md),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: Space.sm,
              runSpacing: Space.sm,
              children: [
                OutlinedButton.icon(
                  onPressed: () => showQuickLog(context, ref, pet),
                  icon: const Icon(Icons.add_outlined),
                  label: Text(l.logSomething),
                ),
                TextButton(onPressed: () => context.push('/pets/${pet.id}/routine'), child: Text(l.seeAll)),
              ],
            ),
          ]);
        },
      ),
    );
  }
}

class _ChecklistRow extends ConsumerWidget {
  const _ChecklistRow({required this.pet, required this.type, required this.done, required this.goal, required this.big});
  final Pet pet;
  final LogType type;
  final int done;
  final int goal;
  final bool big;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final complete = done >= goal;
    final label = type == LogType.play ? l.playProgress(done, goal) : '${logTypeLabel(context, type)} · $done / $goal';
    final paw = context.paw;
    // UI Design 5 list row: the done tick leads (filled marigold-brown when
    // the goal is met), the type and progress in the middle, and a one-tap
    // log button at the end.
    final tick = big ? IconSizes.action : IconSizes.xl - Space.xs;
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: big ? Sizes.listRowEasy : Sizes.listRow),
      child: Row(children: [
        Container(
          width: tick,
          height: tick,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: complete ? paw.done : null,
            border: complete ? null : Border.all(color: paw.controlBorder, width: Strokes.focus),
          ),
          child: complete ? Icon(Icons.check_rounded, size: tick * 0.7, color: paw.onBrand) : null,
        ),
        const SizedBox(width: Space.md),
        Icon(logTypeIcon(type), size: IconSizes.md, color: paw.textSecondary),
        const SizedBox(width: Space.sm),
        Expanded(
          child: Text(label,
              style: (big ? context.text.titleMedium : context.text.titleSmall)?.copyWith(
                color: complete ? paw.textSecondary : paw.textPrimary,
              )),
        ),
        IconButton.filledTonal(
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
