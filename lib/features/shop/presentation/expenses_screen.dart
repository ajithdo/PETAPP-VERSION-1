import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/data/paging.dart';
import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../pets/data/pets_repository.dart';
import '../../pets/domain/pet.dart';
import '../data/order_repository.dart';
import '../domain/shop_models.dart';
import '../domain/shop_rules.dart';
import 'shop_labels.dart';

/// Expense tracker (spec 7.14): bookings, tele-vet and orders are added
/// automatically; manual entries; monthly chart per pet and category.
class ExpensesScreen extends ConsumerStatefulWidget {
  const ExpensesScreen({super.key, this.petId});
  final String? petId;
  @override
  ConsumerState<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends ConsumerState<ExpensesScreen> {
  late String? _petId = widget.petId;
  int _months = 6;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final pets = ref.watch(myPetsProvider).value ?? const <Pet>[];
    return Scaffold(
      appBar: AppBar(title: Text(l.expenses)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => editExpense(context, ref, petId: _petId),
        icon: const Icon(Icons.add_rounded),
        label: Text(l.expAdd),
      ),
      body: AsyncView<List<Expense>>(
        value: ref.watch(myExpensesProvider),
        data: (all) {
          final now = DateTime.now();
          final list = _petId == null ? all : all.where((e) => e.petId == _petId).toList();
          final months = monthlyTotals(list, now, months: _months);
          final thisMonth = months.last;
          final lastMonth = months.length > 1 ? months[months.length - 2] : null;
          final from = months.first.month;
          final totals = categoryTotals(list, from: from);
          final periodTotal = totals.values.fold(0, (s, v) => s + v);
          final cats = totals.keys.toList()..sort((a, b) => totals[b]!.compareTo(totals[a]!));
          final byMonth = <DateTime, List<Expense>>{};
          for (final e in list.where((e) => !e.date.isBefore(from))) {
            (byMonth[DateTime(e.date.year, e.date.month)] ??= []).add(e);
          }
          final keys = byMonth.keys.toList()..sort((a, b) => b.compareTo(a));
          return PageBody(maxWidth: 900, children: [
            const SizedBox(height: Space.md),
            if (pets.length > 1)
              Wrap(spacing: Space.sm, runSpacing: Space.xs, children: [
                ChoiceChip(label: Text(l.allPets), selected: _petId == null, onSelected: (_) => setState(() => _petId = null)),
                for (final p in pets.where((p) => !p.archived))
                  ChoiceChip(
                    avatar: PetAvatar(species: p.species, colorTag: p.colorTag, photoUrl: p.photoUrl, size: 24),
                    label: Text(p.name),
                    selected: _petId == p.id,
                    onSelected: (_) => setState(() => _petId = p.id),
                  ),
              ]),
            const SizedBox(height: Space.md),
            ResponsiveGrid(minItemWidth: 200, children: [
              StatTile(label: l.expThisMonth, value: Fmt.inr(thisMonth.total), icon: Icons.calendar_today_rounded),
              if (lastMonth != null) StatTile(label: l.expLastMonth, value: Fmt.inr(lastMonth.total), icon: Icons.history_rounded),
              StatTile(label: l.expPeriodTotal(_months), value: Fmt.inr(periodTotal), icon: Icons.account_balance_wallet_rounded),
            ]),
            SectionHeader(l.expByMonth),
            Wrap(spacing: Space.sm, children: [
              for (final m in const [3, 6, 12]) ChoiceChip(label: Text(l.expMonths(m)), selected: _months == m, onSelected: (_) => setState(() => _months = m)),
            ]),
            const SizedBox(height: Space.sm),
            _MonthChart(months: months),
            if (cats.isNotEmpty) ...[
              SectionHeader(l.expByCategory),
              PawCard(
                child: Column(children: [
                  for (final c in cats)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: Space.xs),
                      child: Row(children: [
                        CircleAvatar(radius: 16, backgroundColor: expenseColor(c).withValues(alpha: 0.18), child: Icon(expenseIcon(c), size: 18, color: expenseColor(c))),
                        const SizedBox(width: Space.md),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(expenseCategoryLabel(context, c), style: context.text.bodyMedium),
                            const SizedBox(height: 4),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: periodTotal == 0 ? 0 : totals[c]! / periodTotal,
                                minHeight: 6,
                                color: expenseColor(c),
                                backgroundColor: context.paw.outline,
                              ),
                            ),
                          ]),
                        ),
                        const SizedBox(width: Space.md),
                        Text(Fmt.inr(totals[c]!), style: context.text.titleSmall),
                      ]),
                    ),
                ]),
              ),
            ],
            if (keys.isEmpty)
              Padding(padding: const EdgeInsets.only(top: Space.lg), child: EmptyState(compact: true, title: l.expNone, message: l.expNoneBody))
            else
              ..._expenseList(keys, byMonth, pets),
            const SizedBox(height: 80),
          ]);
        },
      ),
    );
  }

  /// Month by month, newest first, a page of entries at a time.
  List<Widget> _expenseList(List<DateTime> keys, Map<DateTime, List<Expense>> byMonth, List<Pet> pets) {
    final limit = ref.watch(listLimitProvider('expenses'));
    final total = byMonth.values.fold(0, (n, list) => n + list.length);
    var shown = 0;
    final out = <Widget>[];
    for (final m in keys) {
      if (shown >= limit) break;
      final items = byMonth[m]!..sort((a, b) => b.date.compareTo(a.date));
      out.add(SectionHeader('${Fmt.monthYear(m, context.lang)} · ${Fmt.inr(items.fold(0, (s, e) => s + e.amount))}'));
      for (final e in items.take(limit - shown)) {
        out.add(Padding(padding: const EdgeInsets.only(bottom: Space.xs), child: _ExpenseTile(expense: e, pets: pets)));
        shown++;
      }
    }
    if (total > limit) out.add(ShowMoreButton(onPressed: () => ref.read(listLimitProvider('expenses').notifier).more()));
    return out;
  }
}

class _MonthChart extends StatelessWidget {
  const _MonthChart({required this.months});
  final List<MonthTotal> months;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final maxV = months.fold<int>(0, (m, t) => t.total > m ? t.total : m);
    final top = maxV <= 0 ? 1000.0 : maxV * 1.2;
    final text = context.text.labelSmall;
    final cats = expenseCategories.where((c) => months.any((m) => (m.byCategory[c] ?? 0) > 0)).toList();
    return PawCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Semantics(
          label: l.expChartSemantics(months.map((m) => '${Fmt.monthYear(m.month, context.lang)} ${Fmt.inr(m.total)}').join(', ')),
          excludeSemantics: true,
          child: SizedBox(
            height: 220,
            child: BarChart(
              BarChartData(
                maxY: top,
                minY: 0,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, _, _, _) => BarTooltipItem(
                      '${Fmt.monthYear(months[group.x].month, context.lang)}\n${Fmt.inr(months[group.x].total)}',
                      const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                gridData: FlGridData(
                  drawVerticalLine: false,
                  horizontalInterval: top / 4,
                  getDrawingHorizontalLine: (_) => FlLine(color: context.paw.outline, strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 52,
                      interval: top / 4,
                      getTitlesWidget: (v, meta) => SideTitleWidget(meta: meta, child: Text(_short(v), style: text)),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (v, meta) {
                        final i = v.toInt();
                        if (i < 0 || i >= months.length) return const SizedBox.shrink();
                        if (months.length > 6 && i.isOdd) return const SizedBox.shrink();
                        return SideTitleWidget(meta: meta, child: Text(Fmt.monthShort(months[i].month, context.lang), style: text));
                      },
                    ),
                  ),
                ),
                barGroups: [
                  for (var i = 0; i < months.length; i++)
                    BarChartGroupData(x: i, barRods: [
                      BarChartRodData(
                        toY: months[i].total.toDouble(),
                        width: months.length > 6 ? 14 : 24,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                        rodStackItems: _stack(months[i], cats),
                        color: Colors.transparent,
                      ),
                    ]),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: Space.sm),
        Wrap(spacing: Space.md, runSpacing: Space.xs, children: [
          for (final c in cats)
            Row(mainAxisSize: MainAxisSize.min, children: [
              Container(width: 10, height: 10, decoration: BoxDecoration(color: expenseColor(c), borderRadius: BorderRadius.circular(3))),
              const SizedBox(width: 4),
              Text(expenseCategoryLabel(context, c), style: context.text.bodySmall),
            ]),
        ]),
      ]),
    );
  }

  List<BarChartRodStackItem> _stack(MonthTotal m, List<String> cats) {
    var from = 0.0;
    final out = <BarChartRodStackItem>[];
    for (final c in cats) {
      final v = (m.byCategory[c] ?? 0).toDouble();
      if (v <= 0) continue;
      out.add(BarChartRodStackItem(from, from + v, expenseColor(c)));
      from += v;
    }
    return out;
  }

  String _short(double v) {
    if (v >= 100000) return '₹${(v / 100000).toStringAsFixed(1)}L';
    if (v >= 1000) return '₹${(v / 1000).toStringAsFixed(v >= 10000 ? 0 : 1)}k';
    return '₹${v.toStringAsFixed(0)}';
  }
}

class _ExpenseTile extends ConsumerWidget {
  const _ExpenseTile({required this.expense, required this.pets});
  final Expense expense;
  final List<Pet> pets;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final e = expense;
    final pet = pets.where((p) => p.id == e.petId).firstOrNull;
    final source = switch (e.source) { 'booking' => l.expFromBooking, 'order' => l.expFromOrder, 'televet' => l.expFromTeleVet, _ => null };
    return PawCard(
      padding: const EdgeInsets.symmetric(horizontal: Space.md, vertical: Space.sm),
      onTap: e.source == 'manual'
          ? () => editExpense(context, ref, existing: e)
          : (e.source == 'order' && e.sourceId != null ? () => context.push('/shop/orders/${e.sourceId}') : null),
      child: Row(children: [
        CircleAvatar(radius: 18, backgroundColor: expenseColor(e.category).withValues(alpha: 0.18), child: Icon(expenseIcon(e.category), size: 18, color: expenseColor(e.category))),
        const SizedBox(width: Space.md),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(e.note.isEmpty ? expenseCategoryLabel(context, e.category) : e.note, style: context.text.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
            Text(
              [Fmt.date(e.date, context.lang), expenseCategoryLabel(context, e.category), ?pet?.name, ?source].join(' · '),
              style: context.text.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ]),
        ),
        const SizedBox(width: Space.sm),
        Text(Fmt.inr(e.amount), style: context.text.titleSmall),
      ]),
    );
  }
}

/// Add or edit a manual expense.
Future<void> editExpense(BuildContext context, WidgetRef ref, {Expense? existing, String? petId}) async {
  await showPawSheet<void>(context, builder: (_) => _ExpenseForm(existing: existing, petId: petId));
}

class _ExpenseForm extends ConsumerStatefulWidget {
  const _ExpenseForm({this.existing, this.petId});
  final Expense? existing;
  final String? petId;
  @override
  ConsumerState<_ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends ConsumerState<_ExpenseForm> {
  final _form = GlobalKey<FormState>();
  late final _amount = TextEditingController(text: widget.existing == null ? '' : '${widget.existing!.amount}');
  late final _note = TextEditingController(text: widget.existing?.note ?? '');
  late String _category = widget.existing?.category ?? 'food';
  late String? _petId = widget.existing?.petId ?? widget.petId;
  late DateTime _date = widget.existing?.date ?? DateTime.now();
  bool _busy = false;

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final pets = (ref.watch(myPetsProvider).value ?? const <Pet>[]).where((p) => !p.archived).toList();
    return Form(
      key: _form,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(widget.existing == null ? l.expAdd : l.expEdit, style: context.text.titleMedium),
        const SizedBox(height: Space.md),
        PawTextField(
          label: l.expAmount,
          controller: _amount,
          prefixText: '₹ ',
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(7)],
          validator: (v) => (int.tryParse(v ?? '') ?? 0) > 0 ? null : l.expAmountInvalid,
          autofocus: widget.existing == null,
        ),
        Text(l.expCategory, style: context.text.titleSmall),
        const SizedBox(height: Space.xs),
        Wrap(spacing: Space.xs, runSpacing: Space.xs, children: [
          for (final c in expenseCategories)
            ChoiceChip(
              avatar: Icon(expenseIcon(c), size: 18),
              label: Text(expenseCategoryLabel(context, c)),
              selected: _category == c,
              onSelected: (_) => setState(() => _category = c),
            ),
        ]),
        const SizedBox(height: Space.md),
        if (pets.isNotEmpty) ...[
          Text(l.expForPet, style: context.text.titleSmall),
          const SizedBox(height: Space.xs),
          Wrap(spacing: Space.xs, runSpacing: Space.xs, children: [
            ChoiceChip(label: Text(l.expAllPets), selected: _petId == null, onSelected: (_) => setState(() => _petId = null)),
            for (final p in pets) ChoiceChip(label: Text(p.name), selected: _petId == p.id, onSelected: (_) => setState(() => _petId = p.id)),
          ]),
          const SizedBox(height: Space.md),
        ],
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.event_rounded),
          title: Text(l.date),
          subtitle: Text(Fmt.date(_date, context.lang)),
          onTap: () async {
            final d = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime(DateTime.now().year - 2), lastDate: DateTime.now());
            if (d != null) setState(() => _date = d);
          },
        ),
        PawTextField(label: l.expNote, controller: _note, hint: l.expNoteHint),
        PrimaryButton(label: l.save, loading: _busy, onPressed: _save),
        if (widget.existing != null) ...[
          const SizedBox(height: Space.sm),
          TextButton.icon(
            onPressed: () async {
              final ok = await confirmAction(context, title: l.expDeleteQ, body: Fmt.inr(widget.existing!.amount), confirmLabel: l.delete);
              if (!ok) return;
              await ref.read(orderRepositoryProvider).deleteExpense(widget.existing!.id);
              if (!mounted) return;
              Navigator.of(this.context).pop();
            },
            icon: const Icon(Icons.delete_outline_rounded),
            label: Text(l.delete),
          ),
        ],
      ]),
    );
  }

  Future<void> _save() async {
    if (!(_form.currentState?.validate() ?? false)) return;
    setState(() => _busy = true);
    final repo = ref.read(orderRepositoryProvider);
    final amount = int.parse(_amount.text);
    if (widget.existing == null) {
      await repo.addExpense(uid: ref.read(currentUserProvider)!.uid, petId: _petId, category: _category, amount: amount, date: _date, note: _note.text);
    } else {
      await repo.updateExpense(widget.existing!.id, {'amount': amount, 'category': _category, 'petId': _petId, 'date': _date, 'note': _note.text.trim()});
    }
    if (mounted) {
      showToast(context, context.l10n.expSaved);
      Navigator.pop(context);
    }
  }
}
