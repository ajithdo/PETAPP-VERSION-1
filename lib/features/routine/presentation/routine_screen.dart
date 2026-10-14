import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../pets/data/pets_repository.dart';
import '../../pets/domain/pet.dart';
import '../data/routine_repository.dart';
import '../domain/routine.dart';
import 'quick_log_sheet.dart';
import 'routine_labels.dart';
import 'today_card.dart';
import 'walk_tracker_screen.dart';

/// Per-pet routine: today's log, weekly and monthly charts, behaviour
/// trends and the daily plan with suggested goals (spec 7.3).
class RoutineScreen extends ConsumerWidget {
  const RoutineScreen({super.key, required this.petId});
  final String petId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final pet = ref.watch(petProvider(petId)).value;
    if (pet == null) return const Scaffold(body: SkeletonList());
    final user = ref.watch(currentUserProvider);
    final canLog = user != null && pet.memberIds.contains(user.uid);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.routineOf(pet.name)),
          bottom: TabBar(isScrollable: true, tabAlignment: TabAlignment.start, tabs: [
            Tab(text: l.tabLog),
            Tab(text: l.tabCharts),
            Tab(text: l.tabBehaviour),
            Tab(text: l.tabPlan),
          ]),
        ),
        floatingActionButton: canLog
            ? FloatingActionButton.extended(
                onPressed: () => showQuickLog(context, ref, pet),
                icon: const Icon(Icons.add_rounded),
                label: Text(l.logSomething),
              )
            : null,
        body: TabBarView(children: [
          _LogTab(pet: pet),
          _ChartsTab(pet: pet),
          _BehaviourTab(pet: pet),
          _PlanTab(pet: pet),
        ]),
      ),
    );
  }
}

class _LogTab extends ConsumerWidget {
  const _LogTab({required this.pet});
  final Pet pet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return AsyncView(
      value: ref.watch(petLogsProvider(pet.id)),
      data: (logs) {
        final byDay = <DateTime, List<RoutineLog>>{};
        for (final g in logs) {
          byDay.putIfAbsent(Fmt.dayOnly(g.at), () => []).add(g);
        }
        final days = byDay.keys.toList()..sort((a, b) => b.compareTo(a));
        return PageBody(maxWidth: 800, children: [
          const SizedBox(height: Space.md),
          TodayCard(pet: pet),
          if (logs.isEmpty)
            EmptyState(title: l.noLogsTitle(pet.name), message: l.noLogsBody, compact: true),
          for (final d in days.take(7)) ...[
            SectionHeader(Fmt.sameDay(d, DateTime.now()) ? l.today : Fmt.weekdayDate(d, context.lang)),
            PawCard(
              padding: const EdgeInsets.symmetric(vertical: Space.xs),
              child: Column(children: [for (final g in byDay[d]!) _LogTile(log: g, pet: pet)]),
            ),
          ],
          const SizedBox(height: 80),
        ]);
      },
    );
  }
}

class _LogTile extends ConsumerWidget {
  const _LogTile({required this.log, required this.pet});
  final RoutineLog log;
  final Pet pet;

  String _detail(BuildContext context) {
    final l = context.l10n;
    return switch (log.type) {
      LogType.walk => '${Fmt.km(log.distanceKm)} · ${l.minutesShort(log.minutes)}',
      LogType.meal => log.grams == null ? '' : '${log.grams} g',
      LogType.play || LogType.training || LogType.sleep => l.minutesShort(log.minutes),
      LogType.mood => moodLabel(context, log.mood),
      LogType.weight => log.weightKg == null ? '' : Fmt.weight(log.weightKg!, grams: pet.isBird),
      LogType.behaviour => log.tags.keys.map((t) => behaviourLabel(context, t)).join(', '),
      _ => '',
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final detail = _detail(context);
    final sub = [Fmt.time(log.at, context.lang), log.byName.split(' ').first, if (log.note != null) log.note!].join(' · ');
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: logTypeColor(log.type).withValues(alpha: 0.15),
        child: Icon(logTypeIcon(log.type), color: logTypeColor(log.type)),
      ),
      title: Text([logTypeLabel(context, log.type), if (detail.isNotEmpty) detail].join(' · ')),
      subtitle: Text(sub, maxLines: 2, overflow: TextOverflow.ellipsis),
      trailing: PopupMenuButton<String>(
        tooltip: l.moreOptions,
        onSelected: (v) async {
          if (v == 'delete') {
            final ok = await confirmAction(context, title: l.deleteLogConfirm);
            if (ok) await ref.read(routineRepositoryProvider).deleteLog(log.id);
          }
        },
        itemBuilder: (_) => [PopupMenuItem(value: 'delete', child: Text(l.delete))],
      ),
      onTap: log.type == LogType.walk && log.route.length > 1
          ? () => showPawSheet<void>(context, builder: (ctx) => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Text('${logTypeLabel(ctx, LogType.walk)} · ${Fmt.dateTime(log.at, ctx.lang)}', style: ctx.text.titleMedium),
                const SizedBox(height: Space.md),
                WalkRouteView(log: log, height: 280),
                const SizedBox(height: Space.md),
                Text('${Fmt.km(log.distanceKm)} · ${l.minutesShort(log.minutes)} · ${log.byName}'),
              ]))
          : null,
    );
  }
}

class _ChartsTab extends ConsumerStatefulWidget {
  const _ChartsTab({required this.pet});
  final Pet pet;
  @override
  ConsumerState<_ChartsTab> createState() => _ChartsTabState();
}

class _ChartsTabState extends ConsumerState<_ChartsTab> {
  int _days = 7;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final pet = widget.pet;
    return AsyncView(
      value: ref.watch(petLogsProvider(pet.id)),
      data: (logs) {
        final today = Fmt.dayOnly(DateTime.now());
        final days = [for (var i = _days - 1; i >= 0; i--) DateTime(today.year, today.month, today.day - i)];
        double sum(DateTime d, LogType t, double Function(RoutineLog) f) =>
            logs.where((g) => g.type == t && Fmt.sameDay(g.at, d)).fold(0.0, (s, g) => s + f(g));
        final isDog = pet.species == 'dog';
        final activity = [for (final d in days) isDog ? sum(d, LogType.walk, (g) => g.distanceKm) : sum(d, LogType.play, (g) => g.minutes.toDouble())];
        final meals = [for (final d in days) sum(d, LogType.meal, (_) => 1)];
        final walksTotal = logs.where((g) => g.type == LogType.walk && !g.at.isBefore(days.first)).fold(0.0, (s, g) => s + g.distanceKm);
        final moodCounts = <String, int>{};
        for (final g in logs.where((g) => g.type == LogType.mood && !g.at.isBefore(days.first))) {
          moodCounts[g.mood ?? ''] = (moodCounts[g.mood ?? ''] ?? 0) + 1;
        }
        return PageBody(maxWidth: 900, children: [
          const SizedBox(height: Space.md),
          Center(
            child: SegmentedButton<int>(
              segments: [ButtonSegment(value: 7, label: Text(l.week)), ButtonSegment(value: 30, label: Text(l.month))],
              selected: {_days},
              onSelectionChanged: (s) => setState(() => _days = s.first),
            ),
          ),
          const SizedBox(height: Space.md),
          ResponsiveGrid(minItemWidth: 180, children: [
            if (isDog) StatTile(label: l.totalWalked, value: Fmt.km(walksTotal), icon: Icons.directions_walk_rounded),
            StatTile(label: l.streak, value: l.daysCount(streak(logs.map((g) => g.at), DateTime.now())), icon: Icons.local_fire_department_rounded, color: context.paw.accent),
            StatTile(label: l.mealsLogged, value: '${meals.fold<double>(0, (a, b) => a + b).round()}', icon: Icons.restaurant_rounded),
          ]),
          SectionHeader(isDog ? l.chartWalkKm : l.chartPlayMinutes),
          _BarChartCard(values: activity, days: days, color: context.colors.primary, goal: isDog ? null : pet.dailyPlan.playMinutes.toDouble()),
          SectionHeader(l.chartMeals),
          _BarChartCard(values: meals, days: days, color: logTypeColor(LogType.meal), goal: pet.dailyPlan.meals.toDouble()),
          SectionHeader(l.chartMood),
          PawCard(
            child: moodCounts.isEmpty
                ? Text(l.noMoodLogs)
                : Wrap(spacing: Space.sm, runSpacing: Space.sm, children: [
                    for (final e in (moodCounts.entries.toList()..sort((a, b) => b.value.compareTo(a.value))))
                      Chip(avatar: Icon(moodIcon(e.key), size: 18), label: Text('${moodLabel(context, e.key)} · ${e.value}')),
                  ]),
          ),
        ]);
      },
    );
  }
}

class _BarChartCard extends StatelessWidget {
  const _BarChartCard({required this.values, required this.days, required this.color, this.goal});
  final List<double> values;
  final List<DateTime> days;
  final Color color;
  final double? goal;

  @override
  Widget build(BuildContext context) {
    final maxV = [...values, goal ?? 0].fold<double>(0, (a, b) => b > a ? b : a);
    final top = maxV <= 0 ? 1.0 : maxV * 1.2;
    final step = days.length > 10 ? 5 : 1;
    final text = context.text.labelSmall;
    return PawCard(
      child: SizedBox(
        height: 200,
        child: BarChart(
          BarChartData(
            maxY: top,
            minY: 0,
            barTouchData: const BarTouchData(enabled: true),
            gridData: FlGridData(
              drawVerticalLine: false,
              horizontalInterval: top / 4,
              getDrawingHorizontalLine: (_) => FlLine(color: context.paw.outline, strokeWidth: 1),
            ),
            borderData: FlBorderData(show: false),
            extraLinesData: goal == null
                ? null
                : ExtraLinesData(horizontalLines: [
                    HorizontalLine(y: goal!, color: context.paw.accent, strokeWidth: 2, dashArray: [6, 4]),
                  ]),
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 36,
                  interval: top / 4,
                  getTitlesWidget: (v, meta) => SideTitleWidget(
                    meta: meta,
                    child: Text(v >= 10 ? v.toStringAsFixed(0) : v.toStringAsFixed(1), style: text),
                  ),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 28,
                  getTitlesWidget: (v, meta) {
                    final i = v.toInt();
                    if (i < 0 || i >= days.length || (days.length - 1 - i) % step != 0) return const SizedBox.shrink();
                    return SideTitleWidget(meta: meta, child: Text(Fmt.dateShort(days[i], context.lang).split(' ').first, style: text));
                  },
                ),
              ),
            ),
            barGroups: [
              for (var i = 0; i < values.length; i++)
                BarChartGroupData(x: i, barRods: [
                  BarChartRodData(
                    toY: values[i],
                    color: color,
                    width: days.length > 10 ? 6 : 18,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                  ),
                ]),
            ],
          ),
        ),
      ),
    );
  }
}

class _BehaviourTab extends ConsumerWidget {
  const _BehaviourTab({required this.pet});
  final Pet pet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return AsyncView(
      value: ref.watch(petLogsProvider(pet.id)),
      data: (logs) {
        final b = logs.where((g) => g.type == LogType.behaviour).toList()..sort((a, c) => a.at.compareTo(c.at));
        final tags = <String, List<(DateTime, int)>>{};
        for (final g in b) {
          g.tags.forEach((t, v) => tags.putIfAbsent(t, () => []).add((g.at, v)));
        }
        if (tags.isEmpty) {
          return EmptyState(
            scene: Scene.empty,
            title: l.noBehaviourTitle,
            message: l.noBehaviourBody(pet.name),
            actionLabel: l.logBehaviour,
            onAction: () => showLogDetails(context, ref, pet, LogType.behaviour),
          );
        }
        String trendText(List<(DateTime, int)> pts) {
          if (pts.length < 2) return l.trendNew;
          final d = pts.last.$2 - pts.first.$2;
          return d > 0 ? l.trendUp : (d < 0 ? l.trendDown : l.trendSteady);
        }

        return PageBody(maxWidth: 800, children: [
          const SizedBox(height: Space.md),
          for (final e in tags.entries)
            Padding(
              padding: const EdgeInsets.only(bottom: Space.md),
              child: PawCard(
                child: Row(children: [
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(behaviourLabel(context, e.key), style: context.text.titleSmall),
                      Text('${intensityLabel(context, e.value.last.$2)} · ${trendText(e.value)}', style: context.text.bodySmall),
                    ]),
                  ),
                  SizedBox(
                    width: 120,
                    height: 40,
                    child: LineChart(LineChartData(
                      minY: 0,
                      maxY: 3.5,
                      titlesData: const FlTitlesData(show: false),
                      gridData: const FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      lineTouchData: const LineTouchData(enabled: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: [for (var i = 0; i < e.value.length; i++) FlSpot(i.toDouble(), e.value[i].$2.toDouble())],
                          color: context.colors.primary,
                          barWidth: 3,
                          isCurved: true,
                          dotData: const FlDotData(show: true),
                        ),
                      ],
                    )),
                  ),
                ]),
              ),
            ),
          SecondaryButton(
            label: l.shareWithTrainerVet,
            icon: Icons.share_rounded,
            onPressed: () {
              final lines = [
                l.behaviourSummaryTitle(pet.name),
                for (final e in tags.entries)
                  '- ${behaviourLabel(context, e.key)}: ${intensityLabel(context, e.value.last.$2)} (${trendText(e.value)})',
              ];
              SharePlus.instance.share(ShareParams(text: lines.join('\n')));
            },
          ),
        ]);
      },
    );
  }
}

class _PlanTab extends ConsumerStatefulWidget {
  const _PlanTab({required this.pet});
  final Pet pet;
  @override
  ConsumerState<_PlanTab> createState() => _PlanTabState();
}

class _PlanTabState extends ConsumerState<_PlanTab> {
  late DailyPlan _plan = widget.pet.dailyPlan;

  Widget _stepper(String label, int value, int min, int max, int step, ValueChanged<int> on) {
    return ListTile(
      title: Text(label),
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        IconButton(
          tooltip: context.l10n.decrease,
          onPressed: value > min ? () => on(value - step) : null,
          icon: const Icon(Icons.remove_circle_outline_rounded),
        ),
        SizedBox(width: 40, child: Text('$value', textAlign: TextAlign.center, style: context.text.titleMedium)),
        IconButton(
          tooltip: context.l10n.increase,
          onPressed: value < max ? () => on(value + step) : null,
          icon: const Icon(Icons.add_circle_outline_rounded),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final pet = widget.pet;
    final g = suggestedGoals(species: pet.speciesEnum, size: pet.size, lifeStage: pet.lifeStage());
    final canEdit = pet.canCare(ref.watch(currentUserProvider)?.uid ?? '');
    return PageBody(maxWidth: 720, children: [
      const SizedBox(height: Space.md),
      Text(l.dailyPlanFor(pet.name), style: context.text.titleMedium),
      const SizedBox(height: Space.xs),
      Text(l.dailyPlanHint, style: context.text.bodySmall),
      const SizedBox(height: Space.md),
      PawCard(
        padding: const EdgeInsets.symmetric(vertical: Space.sm),
        child: Column(children: [
          if (pet.species == 'dog') _stepper(l.walksPerDay, _plan.walks, 0, 5, 1, (v) => setState(() => _plan = _plan.copyWith(walks: v))),
          _stepper(l.mealsPerDay, _plan.meals, 0, 6, 1, (v) => setState(() => _plan = _plan.copyWith(meals: v))),
          _stepper(l.playMinutesPerDay, _plan.playMinutes, 0, 180, 5, (v) => setState(() => _plan = _plan.copyWith(playMinutes: v))),
        ]),
      ),
      const SizedBox(height: Space.md),
      InfoNote(l.suggestedGoalsText(
        pet.species == 'dog' ? l.suggestedWalks(g.walks, g.walkMinutes) : '',
        g.meals,
        g.playMinutes,
      )),
      const SizedBox(height: Space.sm),
      TextButton.icon(
        onPressed: () => setState(() => _plan = DailyPlan(walks: g.walks, meals: g.meals, playMinutes: g.playMinutes)),
        icon: const Icon(Icons.auto_fix_high_rounded),
        label: Text(l.useSuggested),
      ),
      const SizedBox(height: Space.md),
      PrimaryButton(
        label: l.savePlan,
        onPressed: canEdit
            ? () async {
                await ref.read(routineRepositoryProvider).updatePlan(pet.id, _plan);
                if (context.mounted) showToast(context, l.planSaved);
              }
            : null,
      ),
      const SizedBox(height: Space.md),
      InfoNote(l.planReminderNote),
      if (pet.species == 'dog') ...[
        const SizedBox(height: Space.lg),
        SecondaryButton(label: l.startWalk, icon: Icons.directions_walk_rounded, onPressed: () => context.push('/walk/${pet.id}')),
      ],
    ]);
  }
}
