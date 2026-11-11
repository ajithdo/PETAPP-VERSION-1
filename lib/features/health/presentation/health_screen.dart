import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/providers.dart';
import '../../../core/settings/settings_controller.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../pets/data/pets_repository.dart';
import '../../booking/data/places_repository.dart';
import '../../pets/domain/pet.dart';
import '../../pets/presentation/pet_labels.dart';
import '../../routine/data/routine_repository.dart';
import '../../routine/domain/routine.dart';
import '../../routine/presentation/quick_log_sheet.dart';
import '../data/health_repository.dart';
import '../domain/medicine_schedule.dart';
import '../domain/vaccine_schedule.dart';
import 'health_labels.dart';
import 'health_sheets.dart';

/// Health tab (spec 7.4) for the pet chosen in the top bar.
class HealthTab extends ConsumerWidget {
  const HealthTab({super.key, this.petId});
  final String? petId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final pets = ref.watch(activePetsProvider);
    final selected = petId == null ? ref.watch(selectedPetProvider) : pets.where((p) => p.id == petId).firstOrNull;
    if (pets.isEmpty) {
      return EmptyState(title: l.noPetsTitle, actionLabel: l.addPet, onAction: () => context.push('/pets/new'));
    }
    if (selected == null) {
      return PageBody(children: [
        SectionHeader(l.choosePetForHealth),
        for (final p in pets)
          Padding(
            padding: const EdgeInsets.only(bottom: Space.md),
            child: _PetDueTile(pet: p),
          ),
      ]);
    }
    return HealthBody(pet: selected);
  }
}

class _PetDueTile extends ConsumerWidget {
  const _PetDueTile({required this.pet});
  final Pet pet;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final due = ref.watch(petDueProvider(pet)).value ?? const [];
    final urgent = due.where((d) => d.status == DoseStatus.overdue || d.status == DoseStatus.dueSoon).length;
    return PawCard(
      onTap: () => ref.read(settingsProvider.notifier).selectPet(pet.id),
      child: Row(children: [
        PetAvatar(species: pet.species, colorTag: pet.colorTag, photoUrl: pet.photoUrl, size: Sizes.avatarMd),
        const SizedBox(width: Space.md),
        Expanded(child: Text(pet.name, style: context.text.titleSmall)),
        if (urgent > 0) StatusChip(context.l10n.itemsNeedAttention(urgent), tone: ChipTone.warning),
        const Icon(Icons.chevron_right_outlined),
      ]),
    );
  }
}

class HealthBody extends ConsumerWidget {
  const HealthBody({super.key, required this.pet});
  final Pet pet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final user = ref.watch(currentUserProvider)!;
    final canCare = pet.canCare(user.uid);
    final due = ref.watch(petDueProvider(pet));
    final urgent = (due.value ?? const <DueItem>[])
        .where((i) => i.status == DoseStatus.overdue || i.status == DoseStatus.dueSoon)
        .length;
    final wide = context.screenSize == ScreenSize.desktop;
    final nextUp = <Widget>[
      SectionHeader(l.nextUp, padding: wide ? const EdgeInsets.only(bottom: Space.sm) : null),
      AsyncView(
        value: due,
        loading: const Skeleton(height: Sizes.skeletonCard, radius: Radii.card),
        data: (items) {
          final top = items.where((i) => i.status != DoseStatus.upcoming).take(5).toList();
          if (top.isEmpty) {
            return PawCard(
              child: Row(children: [
                Icon(Icons.check_circle_outlined, color: context.paw.success),
                const SizedBox(width: Space.md),
                Expanded(child: Text(l.nothingDue(pet.name), style: context.text.bodyMedium)),
              ]),
            );
          }
          final first = top.first;
          // Calm register: a plain card with the date-led row (no tinted
          // alert fill); vaccines can be booked from here.
          return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            PawCard(
              padding: const EdgeInsets.symmetric(vertical: Space.xs),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                DueTile(item: first, pet: pet),
                if (first.kind == 'vaccine')
                  Padding(
                    padding: const EdgeInsets.fromLTRB(Space.lg, 0, Space.lg, Space.md),
                    child: SecondaryButton(label: l.bookNow, icon: Icons.calendar_month_outlined, onPressed: () => context.push('/book/find/clinic')),
                  ),
              ]),
            ),
            if (top.length > 1) ...[
              const SizedBox(height: Space.md),
              PawCard(
                padding: const EdgeInsets.symmetric(vertical: Space.xs),
                child: Column(children: [for (final i in top.skip(1)) DueTile(item: i, pet: pet)]),
              ),
            ],
          ]);
        },
      ),
    ];
    final pass = _HealthPass(pet: pet, urgent: due.hasValue ? urgent : null);
    final emergency = _EmergencyInfo(pet: pet);
    final vaccines = _VaccinesSection(pet: pet, canCare: canCare);
    final medicines = _MedicinesSection(pet: pet, canCare: canCare);
    final prevention = <Widget>[if (pet.species == 'dog' || pet.species == 'cat') _PreventionSection(pet: pet, canCare: canCare)];
    final weight = _WeightSection(pet: pet);
    final visits = _EventsSection(pet: pet, type: 'vet_visit', canCare: canCare);
    final symptoms = _EventsSection(pet: pet, type: 'symptom', canCare: canCare);
    final reminders = _RemindersSection(pet: pet);
    Widget column(List<Widget> c) => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: c);
    // Desktop (UI Design 2 records vault): the pass and emergency info on the
    // left, what's due and the records on the right.
    final body = wide
        ? <Widget>[
            const SizedBox(height: Space.lg),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(flex: 5, child: column([pass, const SizedBox(height: Space.lg), emergency, weight, reminders])),
              const SizedBox(width: Space.xl),
              Expanded(flex: 7, child: column([...nextUp, vaccines, ...prevention, medicines, visits, symptoms])),
            ]),
          ]
        : <Widget>[
            const SizedBox(height: Space.sm),
            pass,
            const SizedBox(height: Space.md),
            emergency,
            ...nextUp,
            vaccines,
            medicines,
            ...prevention,
            weight,
            visits,
            symptoms,
            reminders,
          ];
    return PageBody(maxWidth: wide ? Space.maxContentWidth : Space.wideWidth, children: [
      ...body,
      const SizedBox(height: Space.lg),
      Builder(builder: (context) {
        final by = ((ref.watch(appSettingsDocProvider).value?['contentReview'] as Map?)?['vaccines'] as String?) ?? '';
        return InfoNote(by.isEmpty ? l.indicativeNote : '${l.indicativeNote} ${l.reviewedBy(by)}');
      }),
    ]);
  }
}

/// One due row with a quick action.
class DueTile extends ConsumerWidget {
  const DueTile({super.key, required this.item, required this.pet, this.showPet = false});
  final DueItem item;
  final Pet pet;
  final bool showPet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = dueTitle(context, item);
    final when = dueWhen(context, item);
    // UI Design 5: every scheduled row leads with its date; a chip only when
    // something is overdue (not "Due soon" on every row).
    final at = item.at;
    final Widget leading = showPet
        ? PetAvatar(species: pet.species, colorTag: pet.colorTag, photoUrl: pet.photoUrl, size: Sizes.avatarSm)
        : at != null
            ? DateBadge(day: '${at.day}', month: Fmt.monthShort(at, context.lang))
            : CircleAvatar(
                backgroundColor: context.paw.surfaceSubtle,
                child: Icon(dueIcon(item.kind), color: context.paw.textPrimary),
              );
    return ListTile(
      leading: leading,
      title: Text(showPet ? '${pet.name} · $title' : title),
      subtitle: when.isEmpty ? null : Text(when),
      trailing: item.status == DoseStatus.overdue ? statusChipWidget(context, item.status) : null,
      onTap: () => openDueItem(context, ref, pet, item),
    );
  }
}

/// What tapping a due item does (Health list, Home "Next up"): log the
/// vaccine, act on the dose, reorder food, or open the event sheet.
Future<void> openDueItem(BuildContext context, WidgetRef ref, Pet pet, DueItem item) async {
  switch (item.kind) {
    case 'vaccine':
      final t = templatesFor(pet.speciesEnum).where((t) => t.key == item.refId).firstOrNull;
      await showVaccineSheet(context, pet, template: t);
    case 'medicine':
      final meds = ref.read(medicinesProvider(pet.id)).value ?? const [];
      final m = meds.where((m) => m.id == item.refId).firstOrNull;
      if (m != null && item.at != null) await showDoseActions(context, ref, pet, m, item.at!);
    case 'refill':
      context.push('/shop');
    case 'deworming':
    case 'flea_tick':
      await showEventSheet(context, pet, item.kind);
    default:
      context.go('/health');
  }
}

/// Given / Skip / Snooze for a dose, from the app (the same three actions
/// are on the phone notification).
Future<void> showDoseActions(BuildContext context, WidgetRef ref, Pet pet, Medicine m, DateTime dose) {
  return showPawSheet<void>(context, builder: (ctx) {
    final l = ctx.l10n;
    Future<void> log(String status) async {
      await ref.read(healthRepositoryProvider).logDose(med: m, status: status, dose: dose, by: ref.read(currentUserProvider)!, petName: pet.name);
      if (ctx.mounted) Navigator.pop(ctx);
      if (context.mounted) showToast(context, status == 'given' ? l.doseGiven(m.name) : (status == 'skipped' ? l.doseSkipped : l.doseSnoozed));
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text('${m.name} · ${pet.name}', style: ctx.text.titleMedium),
      Text('${m.dose} ${unitLabel(ctx, m.unit)} · ${Fmt.dateTime(dose, ctx.lang)}${m.withFood ? ' · ${l.withFood}' : ''}', style: ctx.text.bodySmall),
      const SizedBox(height: Space.lg),
      PrimaryButton(label: l.given, icon: Icons.check_outlined, onPressed: () => log('given')),
      const SizedBox(height: Space.sm),
      Row(children: [
        Expanded(child: SecondaryButton(label: l.skip, onPressed: () => log('skipped'))),
        const SizedBox(width: Space.sm),
        Expanded(child: SecondaryButton(label: l.snooze15, onPressed: () => log('snoozed'))),
      ]),
    ]);
  });
}

class _VaccinesSection extends ConsumerWidget {
  const _VaccinesSection({required this.pet, required this.canCare});
  final Pet pet;
  final bool canCare;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final records = ref.watch(vaccinesProvider(pet.id));
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      SectionHeader(l.vaccinations, action: canCare ? l.record : null, onAction: () => showVaccineSheet(context, pet)),
      AsyncView(
        value: records,
        loading: const Skeleton(height: Sizes.skeletonCard, radius: Radii.card),
        data: (recs) {
          if (pet.species == 'rabbit' || pet.species == 'bird') {
            return PawCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(pet.species == 'rabbit' ? l.rabbitVaccineNote : l.birdVaccineNote),
              for (final r in recs) ListTile(contentPadding: EdgeInsets.zero, title: Text(r.name), subtitle: Text(Fmt.date(r.givenDate, context.lang))),
            ]));
          }
          final s = buildSchedule(species: pet.speciesEnum, birthday: pet.birthday, records: recs, now: DateTime.now());
          // UI Design 6: one card per vaccine, its doses on a timeline, and
          // one tag on the card for the most urgent dose.
          final groups = <String, List<(_VaccineStep, DoseStatus)>>{};
          for (final i in s.items) {
            groups.putIfAbsent(i.template.name, () => []).add((
              _VaccineStep(
                title: doseLabel(context, i.template.doseLabel),
                subtitle: _subtitle(context, i),
                status: i.status,
                certificateDocId: i.record?.certificateDocId,
                inGroup: true,
                onTap: canCare && i.status != DoseStatus.done ? () => showVaccineSheet(context, pet, template: i.template) : null,
              ),
              i.status,
            ));
          }
          for (final r in recs.where((r) => r.key == 'other')) {
            groups.putIfAbsent(r.name, () => []).add((
              _VaccineStep(title: r.name, subtitle: Fmt.date(r.givenDate, context.lang), status: DoseStatus.done, certificateDocId: r.certificateDocId, inGroup: true),
              DoseStatus.done,
            ));
          }
          DoseStatus worst(List<DoseStatus> all) {
            for (final st in const [DoseStatus.overdue, DoseStatus.dueSoon, DoseStatus.upcoming, DoseStatus.askVet]) {
              if (all.contains(st)) return st;
            }
            return DoseStatus.done;
          }

          return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            if (s.needsCatchUp) ...[
              InfoNote(l.catchUpNote, icon: Icons.support_agent_outlined),
              const SizedBox(height: Space.md),
            ],
            for (final g in groups.entries)
              Padding(
                padding: const EdgeInsets.only(bottom: Space.md),
                child: PawCard(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    Row(children: [
                      Expanded(child: Text(g.key, style: context.text.titleMedium)),
                      const SizedBox(width: Space.sm),
                      statusChipWidget(context, worst([for (final x in g.value) x.$2])),
                    ]),
                    const SizedBox(height: Space.md),
                    for (var k = 0; k < g.value.length; k++)
                      TimelineTile(
                        tone: statusChip(context, g.value[k].$2).$2,
                        isFirst: k == 0,
                        isLast: k == g.value.length - 1,
                        onTap: g.value[k].$1.onTap,
                        child: g.value[k].$1,
                      ),
                  ]),
                ),
              ),
          ]);
        },
      ),
    ]);
  }

  String _subtitle(BuildContext context, ScheduleItem i) {
    final l = context.l10n;
    if (i.status == DoseStatus.done && i.record != null) {
      final r = i.record!;
      return [l.givenOn(Fmt.date(r.givenDate, context.lang)), r.brand, r.clinicName].whereType<String>().join(' · ');
    }
    if (i.status == DoseStatus.askVet) return l.askYourVet;
    return i.due == null ? '' : l.dueOn(Fmt.date(i.due!, context.lang));
  }
}

class _MedicinesSection extends ConsumerWidget {
  const _MedicinesSection({required this.pet, required this.canCare});
  final Pet pet;
  final bool canCare;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      SectionHeader(l.medicines, action: canCare ? l.add : null, onAction: () => showMedicineSheet(context, pet)),
      AsyncView(
        value: ref.watch(medicinesProvider(pet.id)),
        loading: const Skeleton(height: Sizes.skeletonCard, radius: Radii.card),
        data: (meds) {
          if (meds.isEmpty) return PawCard(child: Text(l.noMedicines(pet.name)));
          final now = DateTime.now();
          return PawCard(
            padding: const EdgeInsets.symmetric(vertical: Space.xs),
            child: Column(children: [
              for (final m in meds)
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: context.paw.primaryContainer,
                    child: Icon(Icons.medication_outlined, color: context.colors.primary),
                  ),
                  title: Text(m.name),
                  subtitle: Text([
                    '${m.dose} ${unitLabel(context, m.unit)} · ${frequencyLabel(context, m)}',
                    if (nextDose(m.plan, now) != null) l.nextDoseAt(Fmt.dateTime(nextDose(m.plan, now)!, context.lang)),
                    if (m.stock != null) l.stockLeft(m.stock!),
                  ].join('\n')),
                  isThreeLine: true,
                  trailing: m.lowStock ? StatusChip(l.refill, tone: ChipTone.warning) : null,
                  onTap: () async {
                    final next = nextDose(m.plan, now.subtract(const Duration(hours: 2)));
                    if (next != null && canCare) {
                      await showDoseActions(context, ref, pet, m, next);
                    } else if (canCare) {
                      await showMedicineSheet(context, pet, existing: m);
                    }
                  },
                  onLongPress: canCare ? () => showMedicineSheet(context, pet, existing: m) : null,
                ),
            ]),
          );
        },
      ),
    ]);
  }
}

class _PreventionSection extends ConsumerWidget {
  const _PreventionSection({required this.pet, required this.canCare});
  final Pet pet;
  final bool canCare;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final events = ref.watch(healthEventsProvider(pet.id)).value ?? const [];
    DateTime? last(String t) => events.where((e) => e.type == t).map((e) => e.date).firstOrNull;
    final now = DateTime.now();
    final dw = nextDeworming(pet.birthday, last('deworming'), now);
    final ft = nextFleaTick(last('flea_tick'), now);
    Widget row(String type, String title, DateTime next, DateTime? lastDate) {
      final item = DueItem(
        petId: pet.id,
        kind: type,
        title: title,
        at: next,
        status: next.isBefore(DateTime(now.year, now.month, now.day))
            ? DoseStatus.overdue
            : (next.isBefore(now.add(const Duration(days: 7))) ? DoseStatus.dueSoon : DoseStatus.upcoming),
      );
      final paw = context.paw;
      return Material(
        color: paw.surfaceSubtle,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.lg), side: BorderSide(color: paw.outline)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: canCare ? () => showEventSheet(context, pet, type) : null,
          child: Padding(
            padding: const EdgeInsets.all(Space.md),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(dueIcon(type), color: paw.brand),
              const SizedBox(width: Space.md),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(title, style: context.text.titleSmall),
                  const SizedBox(height: Space.xxs),
                  Text(
                    [
                      if (lastDate != null) l.lastDone(Fmt.date(lastDate, context.lang)),
                      l.nextDue(Fmt.date(next, context.lang)),
                    ].join(' · '),
                    style: context.text.bodySmall,
                  ),
                ]),
              ),
              const SizedBox(width: Space.sm),
              statusChipWidget(context, item.status),
            ]),
          ),
        ),
      );
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      SectionHeader(l.prevention),
      PawCard(
        padding: const EdgeInsets.all(Space.md),
        // Side by side when there is room (UI Design 2), stacked on phones.
        child: ResponsiveGrid(
          minItemWidth: Sizes.miniCardMin,
          spacing: Space.sm,
          children: [
            row('deworming', l.deworming, dw, last('deworming')),
            row('flea_tick', l.fleaTick, ft, last('flea_tick')),
          ],
        ),
      ),
      const SizedBox(height: Space.xs),
      Text(l.tickFeverNote, style: context.text.bodySmall),
    ]);
  }
}

class _WeightSection extends ConsumerWidget {
  const _WeightSection({required this.pet});
  final Pet pet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final logs = ref.watch(_weightLogsProvider(pet.id)).value ?? const <RoutineLog>[];
    final pts = logs.where((g) => g.weightKg != null).toList()..sort((a, b) => a.at.compareTo(b.at));
    final range = healthyWeight(pet.speciesEnum, pet.breedId, pet.size, young: pet.lifeStage() == 'young');
    final scale = pet.isBird ? 1000.0 : 1.0;
    final unit = pet.isBird ? 'g' : 'kg';
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      SectionHeader(l.weight, action: l.add, onAction: () => showLogDetails(context, ref, pet, LogType.weight)),
      PawCard(
        child: pts.length < 2
            ? Text(l.weightNeedsTwo)
            : Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                SizedBox(
                  height: Sizes.chartHeight,
                  child: LineChart(LineChartData(
                    minY: _min(pts, range, scale),
                    maxY: _max(pts, range, scale),
                    gridData: FlGridData(drawVerticalLine: false, getDrawingHorizontalLine: (_) => FlLine(color: context.paw.outline, strokeWidth: Strokes.hairline)),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: Sizes.chartAxisBottom,
                          interval: (pts.length / 3).ceilToDouble().clamp(1, 99),
                          getTitlesWidget: (v, meta) {
                            final i = v.toInt();
                            if (i < 0 || i >= pts.length) return const SizedBox.shrink();
                            return SideTitleWidget(meta: meta, child: Text(Fmt.dateShort(pts[i].at, context.lang), style: context.text.labelSmall));
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: Sizes.chartAxisLeftWide,
                          getTitlesWidget: (v, meta) => SideTitleWidget(meta: meta, child: Text(v.toStringAsFixed(pet.isBird ? 0 : 1), style: context.text.labelSmall)),
                        ),
                      ),
                    ),
                    rangeAnnotations: range == null
                        ? null
                        : RangeAnnotations(horizontalRangeAnnotations: [
                            HorizontalRangeAnnotation(y1: range.min * scale, y2: range.max * scale, color: context.paw.success.withValues(alpha: Opacities.chip)),
                          ]),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [for (var i = 0; i < pts.length; i++) FlSpot(i.toDouble(), pts[i].weightKg! * scale)],
                        color: context.colors.primary,
                        barWidth: Strokes.chart,
                        isCurved: true,
                        dotData: const FlDotData(show: true),
                      ),
                    ],
                  )),
                ),
                const SizedBox(height: Space.sm),
                Text(
                  range == null
                      ? l.weightGrowingNote
                      : l.weightRangeNote('${(range.min * scale).toStringAsFixed(pet.isBird ? 0 : 1)}–${(range.max * scale).toStringAsFixed(pet.isBird ? 0 : 1)} $unit'),
                  style: context.text.bodySmall,
                ),
              ]),
      ),
    ]);
  }

  double _min(List<RoutineLog> p, ({double min, double max})? r, double s) {
    final lo = [...p.map((x) => x.weightKg! * s), if (r != null) r.min * s].reduce((a, b) => a < b ? a : b);
    return (lo * 0.9).floorToDouble();
  }

  double _max(List<RoutineLog> p, ({double min, double max})? r, double s) {
    final hi = [...p.map((x) => x.weightKg! * s), if (r != null) r.max * s].reduce((a, b) => a > b ? a : b);
    return (hi * 1.1).ceilToDouble();
  }
}

final _weightLogsProvider = StreamProvider.family<List<RoutineLog>, String>((ref, petId) {
  final now = DateTime.now();
  return ref.watch(routineRepositoryProvider).watchLogs(petId, from: DateTime(now.year - 1, now.month, now.day)).map((l) => l.where((g) => g.type == LogType.weight).toList());
});

class _EventsSection extends ConsumerWidget {
  const _EventsSection({required this.pet, required this.type, required this.canCare});
  final Pet pet;
  final String type;
  final bool canCare;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final events = (ref.watch(healthEventsProvider(pet.id)).value ?? const []).where((e) => e.type == type).toList();
    final isSymptom = type == 'symptom';
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      SectionHeader(isSymptom ? l.symptomDiary : l.vetVisits, action: l.add, onAction: () => showEventSheet(context, pet, type)),
      PawCard(
        padding: const EdgeInsets.symmetric(vertical: Space.xs),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          if (events.isEmpty) Padding(padding: const EdgeInsets.all(Space.md), child: Text(isSymptom ? l.noSymptoms : l.noVisits)),
          for (final e in events.take(5))
            ListTile(
              leading: Icon(isSymptom ? Icons.sick_outlined : Icons.local_hospital_outlined,
                  color: isSymptom && e.severity >= 3 ? context.paw.error : context.colors.primary),
              title: Text(isSymptom ? '${symptomLabel(context, e.symptom)} · ${_sev(context, e.severity)}' : e.title),
              subtitle: Text([
                Fmt.date(e.date, context.lang),
                if (e.clinicName?.isNotEmpty == true) e.clinicName!,
                if (e.diagnosis?.isNotEmpty == true) e.diagnosis!,
                if (e.notes?.isNotEmpty == true) e.notes!,
              ].join(' · '), maxLines: 2, overflow: TextOverflow.ellipsis),
              trailing: e.photos.isEmpty
                  ? null
                  : ClipRRect(borderRadius: BorderRadius.circular(Radii.md), child: MediaImage(url: e.photos.first, width: Sizes.avatarSm, height: Sizes.avatarSm)),
            ),
          if (isSymptom && events.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(Space.sm),
              child: TextButton.icon(
                icon: const Icon(Icons.share_outlined),
                label: Text(l.shareWithVet),
                onPressed: () {
                  final lines = [
                    l.symptomShareTitle(pet.name),
                    for (final e in events.take(10))
                      '- ${Fmt.dateTime(e.date, context.lang)}: ${symptomLabel(context, e.symptom)} (${_sev(context, e.severity)})${e.notes?.isNotEmpty == true ? ' – ${e.notes}' : ''}',
                  ];
                  SharePlus.instance.share(ShareParams(text: lines.join('\n')));
                },
              ),
            ),
        ]),
      ),
    ]);
  }

  String _sev(BuildContext context, int s) => switch (s) {
        1 => context.l10n.intensityMild,
        2 => context.l10n.intensityModerate,
        _ => context.l10n.intensityStrong,
      };
}

class _RemindersSection extends ConsumerWidget {
  const _RemindersSection({required this.pet});
  final Pet pet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final list = (ref.watch(remindersProvider).value ?? const []).where((r) => r.petId == pet.id && !r.done).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      SectionHeader(l.reminders, action: l.add, onAction: () => showReminderSheet(context, pet)),
      PawCard(
        padding: const EdgeInsets.symmetric(vertical: Space.xs),
        child: Column(children: [
          if (list.isEmpty) Padding(padding: const EdgeInsets.all(Space.md), child: Text(l.noReminders)),
          for (final r in list)
            ListTile(
              leading: const Icon(Icons.alarm_outlined),
              title: Text(r.title),
              subtitle: Text(Fmt.dateTime(r.at, context.lang)),
              trailing: IconButton(
                tooltip: l.markDone,
                icon: const Icon(Icons.check_circle_outlined),
                onPressed: () async {
                  final repo = ref.read(healthRepositoryProvider);
                  if (r.repeat == 'monthly' || r.repeat == 'yearly') {
                    final next = r.repeat == 'monthly'
                        ? DateTime(r.at.year, r.at.month + 1, r.at.day, r.at.hour, r.at.minute)
                        : DateTime(r.at.year + 1, r.at.month, r.at.day, r.at.hour, r.at.minute);
                    await repo.updateReminder(r.id, {'at': next});
                  } else {
                    await repo.updateReminder(r.id, {'done': true});
                  }
                },
              ),
            ),
        ]),
      ),
    ]);
  }
}

/// The UI Design 2 health pass at the top of the Health tab: who the pet is, the
/// key facts, whether anything needs attention, and the card and report.
class _HealthPass extends StatelessWidget {
  const _HealthPass({required this.pet, required this.urgent});
  final Pet pet;

  /// Items overdue or due soon; null while loading.
  final int? urgent;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final breed = pet.breedName(context.lang);
    final age = petAgeLabel(context, pet);
    return PassCard(
      title: l.healthOf(pet.name),
      titleIsHeader: true,
      subtitle: breed.isEmpty ? null : breed,
      leading: PetAvatar(species: pet.species, colorTag: pet.colorTag, photoUrl: pet.photoUrl, size: Sizes.avatarMd, name: pet.name),
      badges: [
        if (urgent != null)
          urgent! > 0
              ? PassCard.badge(context, l.itemsNeedAttention(urgent!), icon: Icons.schedule_outlined, tone: ChipTone.warning)
              : PassCard.badge(context, l.healthAllClear),
      ],
      rows: [
        if (age.isNotEmpty) PassRow(label: l.age, value: age),
        if (pet.weightKg != null) PassRow(label: l.weight, value: Fmt.weight(pet.weightKg!, grams: pet.isBird)),
        if (pet.microchip?.isNotEmpty == true) PassRow(label: l.microchip, value: pet.microchip!, mono: true),
      ],
      actions: [
        PassCard.action(context, label: l.medicalCard, icon: Icons.badge_outlined, onPressed: () => context.push('/pets/${pet.id}/card')),
        PassCard.action(context, label: l.healthReport, icon: Icons.picture_as_pdf_outlined, secondary: true, onPressed: () => context.push('/pets/${pet.id}/report')),
      ],
    );
  }
}

/// One vaccine on the Health timeline: its status, name and dates.
class _VaccineStep extends StatelessWidget {
  const _VaccineStep({required this.title, required this.subtitle, required this.status, this.onTap, this.certificateDocId, this.inGroup = false});
  final String title;

  /// Inside a vaccine's own card, which already shows the status tag.
  final bool inGroup;
  final String subtitle;
  final DoseStatus status;
  final VoidCallback? onTap;

  /// The certificate saved in the vault, if one was attached.
  final String? certificateDocId;

  @override
  Widget build(BuildContext context) {
    // The timeline dot already shows the status; a chip only when the
    // vaccine needs attention, and after the title (no label above it).
    final attention = !inGroup && (status == DoseStatus.overdue || status == DoseStatus.dueSoon);
    final text = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: context.text.titleSmall?.copyWith(color: status == DoseStatus.overdue ? context.paw.error : (status == DoseStatus.dueSoon ? context.paw.accent : null))),
      if (subtitle.isNotEmpty) ...[
        const SizedBox(height: Space.xxs),
        Text(subtitle, style: context.text.bodySmall),
      ],
      if (attention) ...[const SizedBox(height: Space.xs + Space.xxs), statusChipWidget(context, status)],
    ]);
    if (certificateDocId == null) return text;
    return Wrap(alignment: WrapAlignment.spaceBetween, crossAxisAlignment: WrapCrossAlignment.start, spacing: Space.sm, runSpacing: Space.xs, children: [
      text,
      OutlinedButton.icon(
        onPressed: () => context.push('/vault/doc/$certificateDocId'),
        icon: const Icon(Icons.description_outlined, size: IconSizes.md),
        label: Text(context.l10n.certificate),
      ),
    ]);
  }
}

/// Emergency info on Health (calm register): allergies and the regular
/// clinic at a glance, on a plain card. Not red: SOS is the only red, and the
/// medical card is already one tap away on the pass above.
class _EmergencyInfo extends ConsumerWidget {
  const _EmergencyInfo({required this.pet});
  final Pet pet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final paw = context.paw;
    final clinic = pet.clinicId == null ? null : ref.watch(placeProvider(pet.clinicId!)).value;
    final allergic = pet.allergies.isNotEmpty;
    final allergies = allergic ? pet.allergies.join(', ') : l.noKnownAllergies;
    return PawCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Icon(Icons.medical_information_outlined, color: paw.textPrimary),
          const SizedBox(width: Space.sm),
          Expanded(child: Semantics(header: true, child: Text(l.emergencyInfo, style: context.text.titleMedium))),
        ]),
        const SizedBox(height: Space.md),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (allergic) ...[Icon(Icons.warning_amber_rounded, size: IconSizes.md, color: paw.warning), const SizedBox(width: Space.xs + Space.xxs)],
          Expanded(
            child: Text.rich(TextSpan(children: [
              TextSpan(text: '${l.allergies}: ', style: context.text.bodyMedium?.copyWith(color: paw.textSecondary)),
              TextSpan(text: allergies, style: context.text.bodyMedium?.copyWith(color: paw.textPrimary, fontWeight: FontWeight.w700)),
            ])),
          ),
        ]),
        const SizedBox(height: Space.xs),
        Text('${l.regularClinic}: ${clinic?.name ?? l.notAdded}', style: context.text.bodyMedium?.copyWith(color: paw.textSecondary)),
      ]),
    );
  }
}
