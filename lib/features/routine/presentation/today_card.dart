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

/// Home "Today" card: the daily plan as a checklist with a progress ring.
/// Each row has a one-tap log button.
class TodayCard extends ConsumerWidget {
  const TodayCard({super.key, required this.pet, this.big = false});
  final Pet pet;
  final bool big;

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
          return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
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
                  if (s > 1) ...[
                    const SizedBox(height: Space.sm),
                    StatusChip(l.streakDays(s), tone: ChipTone.accent, icon: Icons.local_fire_department_rounded),
                  ],
                ]),
              ),
            ]),
            const SizedBox(height: Space.md),
            const Divider(),
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
                  icon: const Icon(Icons.add_rounded),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Space.xxs),
      child: Row(children: [
        Icon(complete ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
            color: complete ? paw.success : paw.controlBorder, size: big ? IconSizes.action : IconSizes.lg),
        const SizedBox(width: Space.md),
        Icon(logTypeIcon(type), size: IconSizes.md, color: paw.textSecondary),
        const SizedBox(width: Space.sm),
        Expanded(
          child: Text(label,
              style: (big ? context.text.bodyLarge : context.text.bodyMedium)?.copyWith(
                color: complete ? paw.textSecondary : paw.textPrimary,
              )),
        ),
        IconButton(
          tooltip: l.logNow(logTypeLabel(context, type)),
          icon: Icon(type == LogType.walk ? Icons.play_circle_outline_rounded : Icons.add_circle_outline_rounded,
              color: paw.brand, size: big ? IconSizes.xxl : IconSizes.action),
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
