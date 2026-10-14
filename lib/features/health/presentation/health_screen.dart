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
import '../../pets/domain/pet.dart';
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
        PetAvatar(species: pet.species, colorTag: pet.colorTag, photoUrl: pet.photoUrl, size: 48),
        const SizedBox(width: Space.md),
        Expanded(child: Text(pet.name, style: context.text.titleSmall)),
        if (urgent > 0) StatusChip(context.l10n.itemsNeedAttention(urgent), tone: ChipTone.warning),
        const Icon(Icons.chevron_right_rounded),
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
    return PageBody(maxWidth: 960, children: [
      const SizedBox(height: Space.sm),
      Row(children: [
        Expanded(child: Text(l.healthOf(pet.name), style: context.text.headlineSmall)),
      ]),
      const SizedBox(height: Space.md),
      Wrap(spacing: Space.sm, runSpacing: Space.sm, children: [
        FilledButton.tonalIcon(
          onPressed: () => context.push('/pets/${pet.id}/report'),
          icon: const Icon(Icons.picture_as_pdf_rounded),
          label: Text(l.healthReport),
        ),
        FilledButton.tonalIcon(
          onPressed: () => context.push('/pets/${pet.id}/card'),
          icon: const Icon(Icons.badge_rounded),
          label: Text(l.medicalCard),
        ),
      ]),
      SectionHeader(l.nextUp),
      AsyncView(
        value: due,
        loading: const Skeleton(height: 120, radius: Radii.card),
        data: (items) {
          final top = items.where((i) => i.status != DoseStatus.upcoming).take(5).toList();
          if (top.isEmpty) return PawCard(child: Text(l.nothingDue(pet.name)));
          return PawCard(
            padding: const EdgeInsets.symmetric(vertical: Space.xs),
            child: Column(children: [for (final i in top) DueTile(item: i, pet: pet)]),
          );
        },
      ),
      _VaccinesSection(pet: pet, canCare: canCare),
      _MedicinesSection(pet: pet, canCare: canCare),
      if (pet.species == 'dog' || pet.species == 'cat') _PreventionSection(pet: pet, canCare: canCare),
      _WeightSection(pet: pet),
      _EventsSection(pet: pet, type: 'vet_visit', canCare: canCare),
      _EventsSection(pet: pet, type: 'symptom', canCare: canCare),
      _RemindersSection(pet: pet),
      const SizedBox(height: Space.lg),
      InfoNote(l.indicativeNote),
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
    return ListTile(
      leading: showPet
          ? PetAvatar(species: pet.species, colorTag: pet.colorTag, photoUrl: pet.photoUrl, size: 40)
          : CircleAvatar(
              backgroundColor: context.paw.primaryContainer,
              child: Icon(dueIcon(item.kind), color: context.colors.primary),
            ),
      title: Text(showPet ? '${pet.name} · $title' : title),
      subtitle: when.isEmpty ? null : Text(when),
      trailing: statusChipWidget(context, item.status),
      onTap: () => _act(context, ref),
    );
  }

  Future<void> _act(BuildContext context, WidgetRef ref) async {
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
      PrimaryButton(label: l.given, icon: Icons.check_rounded, onPressed: () => log('given')),
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
        loading: const Skeleton(height: 160, radius: Radii.card),
        data: (recs) {
          if (pet.species == 'rabbit' || pet.species == 'bird') {
            return PawCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(pet.species == 'rabbit' ? l.rabbitVaccineNote : l.birdVaccineNote),
              for (final r in recs) ListTile(contentPadding: EdgeInsets.zero, title: Text(r.name), subtitle: Text(Fmt.date(r.givenDate, context.lang))),
            ]));
          }
          final s = buildSchedule(species: pet.speciesEnum, birthday: pet.birthday, records: recs, now: DateTime.now());
          return PawCard(
            padding: const EdgeInsets.symmetric(vertical: Space.xs),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              if (s.needsCatchUp)
                Padding(padding: const EdgeInsets.all(Space.md), child: InfoNote(l.catchUpNote, icon: Icons.support_agent_rounded)),
              for (final i in s.items)
                ListTile(
                  leading: Icon(Icons.vaccines_rounded, color: i.status == DoseStatus.overdue ? context.paw.error : context.colors.primary),
                  title: Text('${i.template.name} · ${doseLabel(context, i.template.doseLabel)}'),
                  subtitle: Text(_subtitle(context, i)),
                  trailing: statusChipWidget(context, i.status),
                  onTap: canCare && i.status != DoseStatus.done ? () => showVaccineSheet(context, pet, template: i.template) : null,
                ),
              for (final r in recs.where((r) => r.key == 'other'))
                ListTile(
                  leading: const Icon(Icons.vaccines_rounded),
                  title: Text(r.name),
                  subtitle: Text(Fmt.date(r.givenDate, context.lang)),
                  trailing: statusChipWidget(context, DoseStatus.done),
                ),
            ]),
          );
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
        loading: const Skeleton(height: 80, radius: Radii.card),
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
                    child: Icon(Icons.medication_rounded, color: context.colors.primary),
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
      return ListTile(
        leading: Icon(dueIcon(type), color: context.colors.primary),
        title: Text(title),
        subtitle: Text([
          if (lastDate != null) l.lastDone(Fmt.date(lastDate, context.lang)),
          l.nextDue(Fmt.date(next, context.lang)),
        ].join(' · ')),
        trailing: statusChipWidget(context, item.status),
        onTap: canCare ? () => showEventSheet(context, pet, type) : null,
      );
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      SectionHeader(l.prevention),
      PawCard(
        padding: const EdgeInsets.symmetric(vertical: Space.xs),
        child: Column(children: [
          row('deworming', l.deworming, dw, last('deworming')),
          row('flea_tick', l.fleaTick, ft, last('flea_tick')),
        ]),
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
                  height: 180,
                  child: LineChart(LineChartData(
                    minY: _min(pts, range, scale),
                    maxY: _max(pts, range, scale),
                    gridData: FlGridData(drawVerticalLine: false, getDrawingHorizontalLine: (_) => FlLine(color: context.paw.outline, strokeWidth: 1)),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 26,
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
                          reservedSize: 40,
                          getTitlesWidget: (v, meta) => SideTitleWidget(meta: meta, child: Text(v.toStringAsFixed(pet.isBird ? 0 : 1), style: context.text.labelSmall)),
                        ),
                      ),
                    ),
                    rangeAnnotations: range == null
                        ? null
                        : RangeAnnotations(horizontalRangeAnnotations: [
                            HorizontalRangeAnnotation(y1: range.min * scale, y2: range.max * scale, color: context.paw.success.withValues(alpha: 0.12)),
                          ]),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [for (var i = 0; i < pts.length; i++) FlSpot(i.toDouble(), pts[i].weightKg! * scale)],
                        color: context.colors.primary,
                        barWidth: 3,
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
              leading: Icon(isSymptom ? Icons.sick_rounded : Icons.local_hospital_rounded,
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
                  : ClipRRect(borderRadius: BorderRadius.circular(8), child: MediaImage(url: e.photos.first, width: 44, height: 44)),
            ),
          if (isSymptom && events.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(Space.sm),
              child: TextButton.icon(
                icon: const Icon(Icons.share_rounded),
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
              leading: const Icon(Icons.alarm_rounded),
              title: Text(r.title),
              subtitle: Text(Fmt.dateTime(r.at, context.lang)),
              trailing: IconButton(
                tooltip: l.markDone,
                icon: const Icon(Icons.check_circle_outline_rounded),
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
