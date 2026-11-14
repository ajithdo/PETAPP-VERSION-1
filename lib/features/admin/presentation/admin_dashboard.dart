import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../data/admin_repository.dart';
import '../domain/admin_rules.dart';
import '../domain/support.dart';
import 'support_labels.dart';
import '../../../core/theme/ph.dart';

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
    final paw = context.paw;
    final totals = ref.watch(adminTotalsProvider).value ?? const Totals();
    final days = ref.watch(adminAnalyticsProvider).value ?? const <DayStats>[];
    final periods = groupStats(days, _range);
    final complete = completePeriods(periods, _range, DateTime.now());
    String label(DateTime d) => switch (_range) {
          StatRange.day => Fmt.dateShort(d, lang),
          StatRange.week => Fmt.dateShort(d, lang),
          StatRange.month => Fmt.monthShort(d, lang),
        };
    // The design's chart colours: ink, marigold, leaf, and red for SOS.
    final ink = paw.textPrimary, gold = paw.marigold, leaf = paw.success;
    final charts = <Widget>[
      Wrap(alignment: WrapAlignment.spaceBetween, crossAxisAlignment: WrapCrossAlignment.center, spacing: Space.md, runSpacing: Space.md, children: [
        SegText(
          items: [l.admByDay, l.admByWeek, l.admByMonth],
          index: StatRange.values.indexOf(_range),
          onChanged: (i) => setState(() => _range = StatRange.values[i]),
        ),
        Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Ph.fileText, size: IconSizes.sm, color: paw.textPrimary),
          const SizedBox(width: Space.xs),
          TextLink(l.admCommissionReport, onTap: () => context.go('/admin/reports/commission')),
        ]),
      ]),
      const SizedBox(height: Space.md),
      if (periods.isEmpty)
        EmptyState(title: l.admNoNumbers, compact: true)
      else
        ResponsiveGrid(minItemWidth: 380, children: [
          _ChartCard(
            title: l.admChartBookingsOrders,
            change: changePercent(complete, (d) => d.bookings + d.orders),
            legend: [(l.admLegendBookings, ink), (l.admLegendOrders, gold)],
            child: _Bars(periods: periods, label: label, series: [((d) => d.bookings.toDouble(), ink), ((d) => d.orders.toDouble(), gold)]),
          ),
          _ChartCard(
            title: l.admChartMoney,
            change: changePercent(complete, (d) => d.orderValue),
            legend: [(l.admLegendOrderValue, ink), (l.admLegendCommission, leaf)],
            child: _Lines(periods: periods, label: label, series: [((d) => d.orderValue.toDouble(), ink), ((d) => d.commission.toDouble(), leaf)]),
          ),
          _ChartCard(
            title: l.admChartGrowth,
            change: changePercent(complete, (d) => d.users),
            legend: [(l.admLegendUsers, ink), (l.admLegendPets, gold), (l.admLegendPlus, leaf)],
            child: _Bars(periods: periods, label: label, series: [
              ((d) => d.users.toDouble(), ink),
              ((d) => d.pets.toDouble(), gold),
              ((d) => d.subscriptions.toDouble(), leaf),
            ]),
          ),
          _ChartCard(
            title: l.admChartSos,
            change: changePercent(complete, (d) => d.sos),
            legend: [(l.admLegendSos, paw.sos)],
            child: _Bars(periods: periods, label: label, series: [((d) => d.sos.toDouble(), paw.sos)]),
          ),
        ]),
    ];
    final side = <Widget>[
      const _WaitingCard(),
      const _OutboxCard(),
      _TopList(title: l.admTopClinics, items: totals.topClinics, unit: l.admCountBookings),
      _TopList(title: l.admTopProducts, items: totals.topProducts, unit: l.admCountSold),
    ];
    Widget stack(List<Widget> items) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final (i, w) in items.indexed) ...[if (i > 0) const SizedBox(height: Space.md), w],
          ],
        );
    return LayoutBuilder(builder: (context, box) {
      final wide = box.maxWidth >= Space.wideWidth;
      return PageBody(maxWidth: Space.maxContentWidth, children: [
        const SizedBox(height: Space.sm),
        // Seven number tiles: in one row on a wide screen, two across on a phone.
        ResponsiveGrid(minColumns: 2, minItemWidth: wide ? 140 : 160, spacing: Space.md, children: [
          StatTile(compact: wide, label: l.admUsersShort, value: Fmt.number(totals.users, lang), icon: Ph.users, sub: l.admUsersSplit(totals.owners, totals.partners)),
          StatTile(compact: wide, label: l.admPets, value: Fmt.number(totals.pets, lang), icon: Ph.pawPrint),
          StatTile(compact: wide, label: l.admBookings30Short, value: Fmt.number(totals.bookings30, lang), icon: Ph.calendarCheck),
          StatTile(compact: wide, label: l.admOrderValue30Short, value: Fmt.inr(totals.orderValue30, lang), icon: Ph.bag),
          StatTile(compact: wide, label: l.admCommission30Short, value: Fmt.inr(totals.commission30, lang), icon: Ph.wallet, color: paw.success),
          StatTile(compact: wide, label: l.admPlusMembers, value: Fmt.number(totals.plusMembers, lang), icon: Ph.crownSimple, color: paw.accent),
          StatTile(compact: wide, label: l.admSos30Short, value: Fmt.number(totals.sos30, lang), icon: Ph.asterisk, color: paw.sos),
        ]),
        const SizedBox(height: Space.lg + Space.xs),
        if (wide)
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(flex: 8, child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: charts)),
            const SizedBox(width: Space.md),
            Expanded(flex: 4, child: stack(side)),
          ])
        else ...[
          ...charts,
          const SizedBox(height: Space.md),
          stack(side),
        ],
        const SizedBox(height: Space.xxl),
      ]);
    });
  }
}

/// "Waiting for you": what needs an answer, with how many of each.
class _WaitingCard extends ConsumerWidget {
  const _WaitingCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final pending = ref.watch(adminPartnersProvider('pending')).value ?? const <PendingPartner>[];
    final tickets = ref.watch(adminTicketsProvider).value ?? const <Ticket>[];
    final reports = (ref.watch(adminReportsProvider).value ?? const <Report>[]).where((r) => r.status == 'open').length;
    int kind(bool Function(PendingPartner) test) => pending.where(test).length;
    final clinics = kind((p) => p.kind == 'clinic'), vets = kind((p) => p.kind == 'vet'), sellers = kind((p) => p.kind == 'seller');
    final others = pending.length - clinics - vets - sellers;
    final approvals = [
      if (clinics > 0) l.admCountClinics(clinics),
      if (vets > 0) l.admCountVets(vets),
      if (sellers > 0) l.admCountSellers(sellers),
      if (others > 0) l.admCountProviders(others),
    ].join(', ');
    final open = tickets.where((t) => t.status == 'open').length;
    final progress = tickets.where((t) => t.status == 'in_progress').length;
    Widget row(IconData icon, Tone tone, String title, String sub, int count, TagKind tag, String path) => PawItem(
          lead: PawTile(icon: icon, tone: tone),
          title: title,
          sub: count == 0 ? l.admNothingWaiting : sub,
          subMaxLines: 2,
          onTap: () => context.go(path),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            if (count > 0) ...[PawTag('$count', kind: tag), const SizedBox(width: Space.sm)],
            const Chev(),
          ]),
        );
    return PawCard(
      padding: const EdgeInsets.fromLTRB(Space.lg, Space.lg, Space.lg, Space.xs),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Semantics(header: true, child: Text(l.admWaiting, style: context.text.titleSmall)),
        const SizedBox(height: Space.xs),
        PawList(children: [
          row(Ph.sealCheck, Tone.gold, l.aApprovals, approvals, pending.length, TagKind.gold, '/admin/approvals'),
          row(Ph.headset, Tone.red, l.admComplaintsShort, l.admTicketsLine(open, progress), open + progress, TagKind.red, '/admin/complaints'),
          row(Ph.flag, Tone.neutral, l.aModeration, l.admReportsLine(reports), reports, TagKind.neutral, '/admin/moderation'),
        ]),
      ]),
    );
  }
}

/// The last few messages the demo "sent" (none of them really went out).
class _OutboxCard extends ConsumerWidget {
  const _OutboxCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final paw = context.paw;
    final msgs = (ref.watch(adminOutboxProvider).value ?? const <Map<String, dynamic>>[]).take(3).toList();
    Tone tone(String c) => switch (c) {
          'whatsapp' => Tone.green,
          'sms' => Tone.sky,
          _ => Tone.neutral,
        };
    return PawCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        SecHead(l.aOutbox, action: l.pOpen, onAction: () => context.go('/admin/outbox'), style: context.text.titleSmall),
        if (msgs.isEmpty)
          Text(l.admNothingHere, style: context.text.bodySmall?.copyWith(color: paw.textSecondary))
        else
          PawList(children: [
            for (final m in msgs)
              PawItem(
                lead: PawTile(icon: outboxChannelIcon('${m['channel']}'), tone: tone('${m['channel']}')),
                title: l.admOutboxTo(outboxChannelLabel(context, '${m['channel']}'), '${m['toName'] ?? m['to'] ?? ''}'),
                sub: '${m['body'] ?? m['subject'] ?? ''}',
                subMaxLines: 2,
                noTrailing: true,
              ),
          ]),
        const SizedBox(height: Space.sm),
        Text(l.admOutboxNote, style: context.text.bodySmall?.copyWith(color: paw.textSecondary)),
      ]),
    );
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
          Expanded(child: Text(title, style: context.text.titleSmall)),
          const SizedBox(width: Space.sm),
          if (c != null)
            StatusChip(context.l10n.admChange('${c >= 0 ? '+' : ''}$c'),
                tone: c >= 0 ? ChipTone.success : ChipTone.warning, icon: c >= 0 ? Ph.trendUp : Ph.trendDown),
        ]),
        const SizedBox(height: Space.xs),
        Wrap(spacing: Space.md, runSpacing: Space.xs, children: [
          for (final (name, color) in legend)
            Row(mainAxisSize: MainAxisSize.min, children: [
              Container(width: Space.sm, height: Space.sm, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
              const SizedBox(width: Space.xs + Space.xxs),
              Text(name, style: context.text.bodySmall?.copyWith(color: context.paw.textSecondary)),
            ]),
        ]),
        const SizedBox(height: Space.md),
        SizedBox(height: Sizes.chartHeightSm + Space.xl, child: child),
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
  final style = context.text.labelSmall?.copyWith(color: context.paw.textSecondary, fontWeight: FontWeight.w400, fontSize: TypeScale.dock.size);
  // Three dates under the chart: the first, the middle and the last.
  final marks = {0, (periods.length - 1) ~/ 2, periods.length - 1};
  return FlTitlesData(
    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: Space.xxl,
        interval: top / 4,
        // The lines in between are numbered; the floor and the ceiling aren't.
        getTitlesWidget: (v, meta) => v <= 0 || v >= top ? const SizedBox.shrink() : SideTitleWidget(meta: meta, child: Text(_short(v), style: style)),
      ),
    ),
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: Space.xl,
        interval: 1,
        getTitlesWidget: (v, meta) {
          final i = v.round();
          if (i < 0 || i >= periods.length || !marks.contains(i)) return const SizedBox.shrink();
          return SideTitleWidget(meta: meta, fitInside: SideTitleFitInsideData.fromTitleMeta(meta, distanceFromEdge: 0), child: Text(label(periods[i].date), style: style));
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
      gridData: FlGridData(drawVerticalLine: false, horizontalInterval: top / 4, checkToShowHorizontalLine: (v) => v > 0 && v < top, getDrawingHorizontalLine: (_) => FlLine(color: context.paw.outline, strokeWidth: Strokes.hairline)),
      borderData: FlBorderData(show: false),
      titlesData: _titles(context, periods, label, top),
      barGroups: [
        for (var i = 0; i < periods.length; i++)
          BarChartGroupData(x: i, barsSpace: 2, barRods: [
            for (final s in series) BarChartRodData(toY: s.$1(periods[i]), color: s.$2, width: width, borderRadius: BorderRadius.circular(Radii.xs)),
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
      gridData: FlGridData(drawVerticalLine: false, horizontalInterval: top / 4, checkToShowHorizontalLine: (v) => v > 0 && v < top, getDrawingHorizontalLine: (_) => FlLine(color: context.paw.outline, strokeWidth: Strokes.hairline)),
      borderData: FlBorderData(show: false),
      titlesData: _titles(context, periods, label, top),
      lineBarsData: [
        for (final s in series)
          LineChartBarData(
            spots: [for (var i = 0; i < periods.length; i++) FlSpot(i.toDouble(), s.$1(periods[i]))],
            color: s.$2,
            barWidth: Strokes.focus + Strokes.hairline / 2,
            isCurved: true,
            preventCurveOverShooting: true,
            dotData: const FlDotData(show: false),
          ),
      ],
    ));
  }
}

/// A ranked list: the place, then how many.
class _TopList extends StatelessWidget {
  const _TopList({required this.title, required this.items, required this.unit});
  final String title;
  final List<(String, int)> items;
  final String Function(int) unit;

  @override
  Widget build(BuildContext context) {
    final paw = context.paw;
    return PawCard(
      padding: const EdgeInsets.fromLTRB(Space.lg, Space.lg, Space.lg, Space.xs),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Semantics(header: true, child: Text(title, style: context.text.titleSmall)),
        const SizedBox(height: Space.xs),
        if (items.isEmpty) Padding(padding: const EdgeInsets.only(bottom: Space.md), child: Text(context.l10n.admNothingYet, style: context.text.bodySmall?.copyWith(color: paw.textSecondary))),
        PawList(children: [
          for (var i = 0; i < items.length; i++)
            PawItem(
              lead: SizedBox(width: Space.xl - Space.xs, child: Text('${i + 1}', style: context.text.titleMedium?.copyWith(color: paw.textSecondary))),
              title: items[i].$1,
              sub: unit(items[i].$2),
              noTrailing: true,
            ),
        ]),
      ]),
    );
  }
}
