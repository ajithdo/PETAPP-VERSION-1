import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../data/admin_repository.dart';
import '../domain/admin_rules.dart';

/// Admin dashboard (spec 10): totals, charts by day, week or month, and the
/// top clinics and products.
class AdminDashboard extends ConsumerStatefulWidget {
  const AdminDashboard({super.key});

  @override
  ConsumerState<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends ConsumerState<AdminDashboard> {
  StatRange _range = StatRange.week;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final lang = context.lang;
    final totals = ref.watch(adminTotalsProvider).value ?? const Totals();
    final days = ref.watch(adminAnalyticsProvider).value ?? const <DayStats>[];
    final periods = groupStats(days, _range);
    final complete = completePeriods(periods, _range, DateTime.now());
    String label(DateTime d) => switch (_range) {
          StatRange.day => Fmt.dateShort(d, lang),
          StatRange.week => Fmt.dateShort(d, lang),
          StatRange.month => Fmt.monthShort(d, lang),
        };
    return PageBody(maxWidth: 1200, children: [
      const SizedBox(height: Space.md),
      ResponsiveGrid(minItemWidth: 170, spacing: Space.sm, children: [
        StatTile(label: l.admUsers(totals.owners, totals.partners), value: Fmt.number(totals.users, lang), icon: Icons.people_alt_rounded),
        StatTile(label: l.admPets, value: Fmt.number(totals.pets, lang), icon: Icons.pets_rounded),
        StatTile(label: l.admBookings30, value: Fmt.number(totals.bookings30, lang), icon: Icons.event_available_rounded),
        StatTile(label: l.admOrderValue30, value: Fmt.inr(totals.orderValue30, lang), icon: Icons.shopping_bag_rounded),
        StatTile(label: l.admCommission30, value: Fmt.inr(totals.commission30, lang), icon: Icons.account_balance_wallet_rounded, color: context.paw.success),
        StatTile(label: l.admPlusMembers, value: Fmt.number(totals.plusMembers, lang), icon: Icons.workspace_premium_rounded, color: context.paw.accent),
        StatTile(label: l.admSos30, value: Fmt.number(totals.sos30, lang), icon: Icons.emergency_rounded, color: context.paw.sos),
      ]),
      const SizedBox(height: Space.lg),
      Wrap(spacing: Space.md, runSpacing: Space.sm, crossAxisAlignment: WrapCrossAlignment.center, children: [
        SegmentedButton<StatRange>(
          segments: [
            ButtonSegment(value: StatRange.day, label: Text(l.admByDay)),
            ButtonSegment(value: StatRange.week, label: Text(l.admByWeek)),
            ButtonSegment(value: StatRange.month, label: Text(l.admByMonth)),
          ],
          selected: {_range},
          onSelectionChanged: (s) => setState(() => _range = s.first),
        ),
        TextButton.icon(
          onPressed: () => context.go('/admin/reports/commission'),
          icon: const Icon(Icons.receipt_long_rounded),
          label: Text(l.admCommissionReport),
        ),
      ]),
      const SizedBox(height: Space.md),
      if (periods.isEmpty)
        EmptyState(title: l.admNoNumbers, compact: true)
      else
        ResponsiveGrid(minItemWidth: 420, children: [
          _ChartCard(
            title: l.admChartBookingsOrders,
            change: changePercent(complete, (d) => d.bookings + d.orders),
            legend: [(l.admLegendBookings, context.colors.primary), (l.admLegendOrders, context.paw.accent)],
            child: _Bars(periods: periods, label: label, series: [((d) => d.bookings.toDouble(), context.colors.primary), ((d) => d.orders.toDouble(), context.paw.accent)]),
          ),
          _ChartCard(
            title: l.admChartMoney,
            change: changePercent(complete, (d) => d.orderValue),
            legend: [(l.admLegendOrderValue, context.colors.primary), (l.admLegendCommission, context.paw.success)],
            child: _Lines(periods: periods, label: label, series: [((d) => d.orderValue.toDouble(), context.colors.primary), ((d) => d.commission.toDouble(), context.paw.success)]),
          ),
          _ChartCard(
            title: l.admChartGrowth,
            change: changePercent(complete, (d) => d.users),
            legend: [(l.admLegendUsers, context.colors.primary), (l.admLegendPets, context.paw.accent), (l.admLegendPlus, context.paw.warning)],
            child: _Bars(periods: periods, label: label, series: [
              ((d) => d.users.toDouble(), context.colors.primary),
              ((d) => d.pets.toDouble(), context.paw.accent),
              ((d) => d.subscriptions.toDouble(), context.paw.warning),
            ]),
          ),
          _ChartCard(
            title: l.admChartSos,
            change: changePercent(complete, (d) => d.sos),
            legend: [(l.admLegendSos, context.paw.sos)],
            child: _Bars(periods: periods, label: label, series: [((d) => d.sos.toDouble(), context.paw.sos)]),
          ),
        ]),
      const SizedBox(height: Space.lg),
      ResponsiveGrid(minItemWidth: 420, children: [
        _TopList(title: l.admTopClinics, items: totals.topClinics, unit: l.admBookingsUnit, icon: Icons.local_hospital_rounded),
        _TopList(title: l.admTopProducts, items: totals.topProducts, unit: l.admSoldUnit, icon: Icons.shopping_basket_rounded),
      ]),
      const SizedBox(height: Space.xxl),
    ]);
  }
}

typedef _Series = (double Function(DayStats), Color);

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.title, required this.child, required this.legend, this.change});
  final String title;
  final Widget child;
  final List<(String, Color)> legend;
  final int? change;

  @override
  Widget build(BuildContext context) {
    final c = change;
    return PawCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(title, style: context.text.titleMedium)),
          if (c != null)
            StatusChip(context.l10n.admChange('${c >= 0 ? '+' : ''}$c'),
                tone: c >= 0 ? ChipTone.success : ChipTone.warning, icon: c >= 0 ? Icons.trending_up_rounded : Icons.trending_down_rounded),
        ]),
        const SizedBox(height: Space.xs),
        Wrap(spacing: Space.md, children: [
          for (final (name, color) in legend)
            Row(mainAxisSize: MainAxisSize.min, children: [
              Container(width: 10, height: 10, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
              const SizedBox(width: 4),
              Text(name, style: context.text.labelSmall),
            ]),
        ]),
        const SizedBox(height: Space.md),
        SizedBox(height: 200, child: child),
      ]),
    );
  }
}

double _niceTop(double max) {
  if (max <= 0) return 1;
  final mag = [1, 2, 5, 10, 20, 25, 50, 100, 200, 250, 500, 1000, 2000, 2500, 5000, 10000, 20000, 25000, 50000, 100000, 200000, 250000, 500000, 1000000, 2000000, 5000000];
  final step = mag.firstWhere((m) => max / m <= 4, orElse: () => 10000000);
  return (step * ((max / step).ceil())).toDouble();
}

String _short(double v) => v >= 100000 ? '${(v / 100000).toStringAsFixed(v >= 1000000 ? 0 : 1)}L' : (v >= 1000 ? '${(v / 1000).toStringAsFixed(v >= 10000 ? 0 : 1)}k' : v.toStringAsFixed(0));

FlTitlesData _titles(BuildContext context, List<DayStats> periods, String Function(DateTime) label, double top) {
  final style = context.text.labelSmall;
  final every = (periods.length / 6).ceil().clamp(1, 99);
  return FlTitlesData(
    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: true, reservedSize: 40, interval: top / 4, getTitlesWidget: (v, meta) => SideTitleWidget(meta: meta, child: Text(_short(v), style: style))),
    ),
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 26,
        interval: 1,
        getTitlesWidget: (v, meta) {
          final i = v.round();
          if (i < 0 || i >= periods.length || i % every != 0) return const SizedBox.shrink();
          return SideTitleWidget(meta: meta, child: Text(label(periods[i].date), style: style));
        },
      ),
    ),
  );
}

class _Bars extends StatelessWidget {
  const _Bars({required this.periods, required this.series, required this.label});
  final List<DayStats> periods;
  final List<_Series> series;
  final String Function(DateTime) label;

  @override
  Widget build(BuildContext context) {
    final max = periods.fold<double>(0, (m, d) => [m, ...series.map((s) => s.$1(d))].reduce((a, b) => a > b ? a : b));
    final top = _niceTop(max);
    final width = (220 / (periods.length * series.length)).clamp(3.0, 14.0);
    return BarChart(BarChartData(
      maxY: top,
      minY: 0,
      barTouchData: const BarTouchData(enabled: true),
      gridData: FlGridData(drawVerticalLine: false, horizontalInterval: top / 4, getDrawingHorizontalLine: (_) => FlLine(color: context.paw.outline, strokeWidth: 1)),
      borderData: FlBorderData(show: false),
      titlesData: _titles(context, periods, label, top),
      barGroups: [
        for (var i = 0; i < periods.length; i++)
          BarChartGroupData(x: i, barsSpace: 2, barRods: [
            for (final s in series) BarChartRodData(toY: s.$1(periods[i]), color: s.$2, width: width, borderRadius: const BorderRadius.vertical(top: Radius.circular(3))),
          ]),
      ],
    ));
  }
}

class _Lines extends StatelessWidget {
  const _Lines({required this.periods, required this.series, required this.label});
  final List<DayStats> periods;
  final List<_Series> series;
  final String Function(DateTime) label;

  @override
  Widget build(BuildContext context) {
    final max = periods.fold<double>(0, (m, d) => [m, ...series.map((s) => s.$1(d))].reduce((a, b) => a > b ? a : b));
    final top = _niceTop(max);
    return LineChart(LineChartData(
      maxY: top,
      minY: 0,
      minX: 0,
      maxX: (periods.length - 1).toDouble().clamp(1, 999),
      gridData: FlGridData(drawVerticalLine: false, horizontalInterval: top / 4, getDrawingHorizontalLine: (_) => FlLine(color: context.paw.outline, strokeWidth: 1)),
      borderData: FlBorderData(show: false),
      titlesData: _titles(context, periods, label, top),
      lineBarsData: [
        for (final s in series)
          LineChartBarData(
            spots: [for (var i = 0; i < periods.length; i++) FlSpot(i.toDouble(), s.$1(periods[i]))],
            color: s.$2,
            barWidth: 3,
            isCurved: true,
            preventCurveOverShooting: true,
            dotData: FlDotData(show: periods.length <= 14),
          ),
      ],
    ));
  }
}

class _TopList extends StatelessWidget {
  const _TopList({required this.title, required this.items, required this.unit, required this.icon});
  final String title;
  final List<(String, int)> items;
  final String unit;
  final IconData icon;

  @override
  Widget build(BuildContext context) => PawCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(title, style: context.text.titleMedium),
          const SizedBox(height: Space.sm),
          if (items.isEmpty) Text(context.l10n.admNothingYet, style: context.text.bodySmall),
          for (var i = 0; i < items.length; i++)
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(radius: 14, child: Text('${i + 1}', style: context.text.labelMedium)),
              title: Text(items[i].$1, maxLines: 1, overflow: TextOverflow.ellipsis),
              trailing: Text('${items[i].$2} $unit', style: context.text.labelMedium),
            ),
        ]),
      );
}
