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
import 'next_up_panel.dart';
import '../../../core/theme/ph.dart';

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
        const Icon(Ph.caretRight),
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
    const gap = SizedBox(height: Sizes.sectionGap);
    final nextUp = <Widget>[
      SecHead(l.nextUp),
      AsyncView(
        value: due,
        loading: const Skeleton(height: Sizes.skeletonCard, radius: Radii.card),
        data: (items) => NextUpPanel(
          items: [for (final i in items.where((i) => i.status != DoseStatus.upcoming).take(4)) (pet, i)],
          emptyText: l.nothingDue(pet.name),
        ),
      ),
    ];
    final vaccinesLate = (due.value ?? const <DueItem>[]).any((i) => i.kind == 'vaccine' && i.status == DoseStatus.overdue);
    final pass = _HealthPass(pet: pet, urgent: due.hasValue ? urgent : null, vaccinesOk: due.hasValue && !vaccinesLate);
    final emergency = _EmergencyInfo(pet: pet);
    final vaccines = _VaccinesSection(pet: pet, canCare: canCare);
    final weight = _WeightSection(pet: pet);
    final records = _RecordsSection(pet: pet);
    Widget column(List<Widget> c) => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: c);
    // UI Design 6. Phone: the pass, emergency info, what's next, weight,
    // vaccinations, then the other records as one list. Desktop: the pass
    // side on the left, vaccinations and records on the right.
    final body = wide
        ? <Widget>[
            const SizedBox(height: Space.lg),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(flex: 5, child: column([pass, gap, emergency, gap, ...nextUp, gap, weight])),
              const SizedBox(width: Space.xl),
              Expanded(flex: 7, child: column([vaccines, gap, records])),
            ]),
          ]
        : <Widget>[
            const SizedBox(height: Space.sm),
            pass,
            gap,
            emergency,
            gap,
            ...nextUp,
            gap,
            weight,
            gap,
            vaccines,
            gap,
            records,
          ];
    return PageBody(maxWidth: wide ? Space.maxContentWidth : Space.wideWidth, children: body);
  }
}

/// The other health records as one list (UI Design 6): each row says where
/// things stand and opens its own page.
class _RecordsSection extends ConsumerWidget {
  const _RecordsSection({required this.pet});
  final Pet pet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final lang = context.lang;
    final now = DateTime.now();
    final meds = ref.watch(medicinesProvider(pet.id)).value ?? const <Medicine>[];
    final events = ref.watch(healthEventsProvider(pet.id)).value ?? const <HealthEvent>[];
    final visits = events.where((e) => e.type == 'vet_visit').toList();
    final symptoms = events.where((e) => e.type == 'symptom').toList();
    final reminders = (ref.watch(remindersProvider).value ?? const <Reminder>[]).where((r) => r.petId == pet.id && !r.done).toList();
    DateTime? last(String t) => events.where((e) => e.type == t).map((e) => e.date).firstOrNull;
    final prevention = pet.species == 'dog' || pet.species == 'cat';
    void open(String kind) => context.push('/health/records/$kind?pet=${pet.id}');
    Widget row(String kind, IconData icon, Tone tone, String title, String sub) => PawItem(
          lead: PawTile(icon: icon, tone: tone),
          title: title,
          sub: sub,
          subMaxLines: 2,
          onTap: () => open(kind),
        );
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      SecHead(l.healthRecords),
      PawPanel(
        padding: PawPanel.listPadding,
        child: PawList(children: [
          row(
            'medicines',
            Ph.pill,
            Tone.sky,
            l.medicines,
            meds.isEmpty
                ? l.noneRightNow
                : [
                    meds.map((m) => m.name).join(', '),
                    if (meds.map((m) => nextDose(m.plan, now)).whereType<DateTime>().isNotEmpty)
                      l.nextDoseAt(Fmt.dateTime((meds.map((m) => nextDose(m.plan, now)).whereType<DateTime>().toList()..sort()).first, lang)),
                  ].join('. '),
          ),
          if (prevention)
            row(
              'prevention',
              Ph.bug,
              Tone.gold,
              l.preventionTitle,
              [
                l.whatDueOn(l.deworming, Fmt.dateShort(nextDeworming(pet.birthday, last('deworming'), now), lang)),
                l.whatDueOn(l.fleaTick, Fmt.dateShort(nextFleaTick(last('flea_tick'), now), lang)),
              ].join('. '),
            ),
          row(
            'visits',
            Ph.stethoscope,
            Tone.green,
            l.vetVisits,
            visits.isEmpty
                ? l.nothingLogged
                : [
                    [Fmt.dateShort(visits.first.date, lang), if (visits.first.clinicName?.isNotEmpty == true) visits.first.clinicName!].join(', '),
                    visits.first.title,
                  ].where((x) => x.isNotEmpty).join(': '),
          ),
          row(
            'symptoms',
            Ph.notepad,
            Tone.red,
            l.symptomDiary,
            symptoms.isEmpty
                ? l.nothingLogged
                : '${Fmt.dateShort(symptoms.first.date, lang)}: ${[symptomLabel(context, symptoms.first.symptom), severityLabel(context, symptoms.first.severity)].join(', ')}',
          ),
          row(
            'reminders',
            Ph.bellRinging,
            Tone.neutral,
            l.reminders,
            reminders.isEmpty ? l.noneRightNow : reminders.take(2).map((r) => '${r.title} ${Fmt.dateShort(r.at, lang)}').join(', '),
          ),
        ]),
      ),
    ]);
  }
}

/// One kind of record on its own page (medicines, deworming and flea/tick,
/// vet visits, the symptom diary, reminders), opened from Health's
/// "Records" list.
class HealthRecordsScreen extends ConsumerWidget {
  const HealthRecordsScreen({super.key, required this.kind, this.petId});
  final String kind;
  final String? petId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final pets = ref.watch(activePetsProvider);
    final pet = petId == null ? ref.watch(selectedPetProvider) : pets.where((p) => p.id == petId).firstOrNull;
    final title = switch (kind) {
      'medicines' => l.medicines,
      'prevention' => l.preventionTitle,
      'visits' => l.vetVisits,
      'symptoms' => l.symptomDiary,
      _ => l.reminders,
    };
    if (pet == null) {
      return Scaffold(appBar: AppBar(title: Text(title)), body: EmptyState(title: l.noPetsTitle));
    }
    final canCare = pet.canCare(ref.watch(currentUserProvider)!.uid);
    final Widget section = switch (kind) {
      'medicines' => _MedicinesSection(pet: pet, canCare: canCare),
      'prevention' => _PreventionSection(pet: pet, canCare: canCare),
      'visits' => _EventsSection(pet: pet, type: 'vet_visit', canCare: canCare),
      'symptoms' => _EventsSection(pet: pet, type: 'symptom', canCare: canCare),
      _ => _RemindersSection(pet: pet),
    };
    return Scaffold(
      appBar: AppBar(title: Text('${pet.name} · $title')),
      body: PageBody(maxWidth: Space.wideWidth, children: [section]),
    );
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
      PrimaryButton(label: l.given, icon: Ph.check, onPressed: () => log('given')),
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
      SecHead(l.vaccinations, action: canCare ? l.record : null, onAction: () => showVaccineSheet(context, pet)),
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

          final firstDue = groups.entries.where((g) => g.value.any((x) => x.$2 == DoseStatus.overdue || x.$2 == DoseStatus.dueSoon)).map((g) => g.key).firstOrNull;
          return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            if (s.needsCatchUp) ...[
              InfoNote(l.catchUpNote, icon: Ph.headset),
              const SizedBox(height: Space.md),
            ],
            for (final (n, g) in groups.entries.indexed)
              Padding(
                padding: EdgeInsets.only(top: n == 0 ? 0 : Space.lg),
                child: PawCard(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    Row(children: [
                      Expanded(child: Text(g.key, style: context.text.titleSmall)),
                      const SizedBox(width: Space.sm),
                      statusChipWidget(context, worst([for (final x in g.value) x.$2])),
                    ]),
                    const SizedBox(height: Space.xs),
                    for (var k = 0; k < g.value.length; k++) _DoseRow(step: g.value[k].$1, last: k == g.value.length - 1),
                    // The first vaccine that needs a dose gets the buttons.
                    if (canCare && g.key == firstDue) ...[
                      const SizedBox(height: Space.md),
                      Wrap(spacing: Space.md, runSpacing: Space.sm, children: [
                        PawButton(label: l.bookWord, icon: Ph.calendarPlus, onPressed: () => context.push('/book/find/clinic')),
                        PawButton(
                          label: l.record,
                          icon: Ph.plus,
                          kind: BtnKind.soft,
                          onPressed: g.value.map((x) => x.$1.onTap).whereType<VoidCallback>().firstOrNull ?? () => showVaccineSheet(context, pet),
                        ),
                      ]),
                    ],
                  ]),
                ),
              ),
            const SizedBox(height: Space.md),
            Builder(builder: (context) {
              final by = ((ref.watch(appSettingsDocProvider).value?['contentReview'] as Map?)?['vaccines'] as String?) ?? '';
              return Text(
                by.isEmpty ? l.indicativeSchedule : '${l.indicativeSchedule} ${l.reviewedBy(by)}',
                style: context.text.bodySmall?.copyWith(color: context.paw.textSecondary),
              );
            }),
          ]);
        },
      ),
    ]);
  }

  String _subtitle(BuildContext context, ScheduleItem i) {
    final l = context.l10n;
    if (i.status == DoseStatus.done && i.record != null) {
      final r = i.record!;
      final meta = [r.brand, r.clinicName].whereType<String>().where((x) => x.isNotEmpty).join(', ');
      return [l.givenOn(Fmt.date(r.givenDate, context.lang)), if (meta.isNotEmpty) meta].join('\n');
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
                    child: Icon(Ph.pill, color: context.colors.primary),
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
    final paw = context.paw;
    final digits = pet.isBird ? 0 : 1;
    final latest = pts.isEmpty ? null : pts.last.weightKg! * scale;
    // "29 kg in the healthy range": the latest weight, and where it sits.
    final (String, Color)? verdict = latest == null || range == null
        ? null
        : latest < range.min * scale
            ? (l.weightBelow, paw.accent)
            : latest > range.max * scale
                ? (l.weightAbove, paw.accent)
                : (l.weightHealthy, paw.success);
    final lo = pts.length < 2 ? 0.0 : _min(pts, range, scale), hi = pts.length < 2 ? 1.0 : _max(pts, range, scale);
    // About four grid lines, on round numbers.
    final step = [1.0, 2.0, 5.0, 10.0, 20.0, 50.0, 100.0, 200.0, 500.0].firstWhere((x) => (hi - lo) / x <= 4, orElse: () => 1000);
    final axis = context.text.labelSmall?.copyWith(color: paw.textSecondary, fontWeight: FontWeight.w400);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      SecHead(l.weight, action: l.add, onAction: () => showLogDetails(context, ref, pet, LogType.weight)),
      PawCard(
        child: pts.length < 2
            ? Text(l.weightNeedsTwo)
            : Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Text.rich(TextSpan(children: [
                  TextSpan(text: '${latest!.toStringAsFixed(latest == latest.roundToDouble() ? 0 : digits)} $unit', style: context.text.headlineMedium),
                  if (verdict != null) TextSpan(text: '  ${verdict.$1}', style: context.text.bodySmall?.copyWith(color: verdict.$2, fontWeight: FontWeight.w600)),
                ])),
                const SizedBox(height: Space.md),
                SizedBox(
                  height: Sizes.chartHeightSm,
                  child: LineChart(LineChartData(
                    minY: lo,
                    maxY: hi,
                    gridData: FlGridData(
                      drawVerticalLine: false,
                      horizontalInterval: step,
                      getDrawingHorizontalLine: (_) => FlLine(color: paw.outline, strokeWidth: Strokes.hairline),
                    ),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: Sizes.chartAxisBottom,
                          interval: 1,
                          getTitlesWidget: (v, meta) {
                            final i = v.toInt();
                            // First, last and up to two in between.
                            final n = pts.length - 1;
                            final shown = {0, n, if (n >= 4) (n / 3).round(), if (n >= 4) (2 * n / 3).round()};
                            if (i < 0 || i > n || v != i.toDouble() || !shown.contains(i)) return const SizedBox.shrink();
                            return SideTitleWidget(meta: meta, fitInside: SideTitleFitInsideData.fromTitleMeta(meta), child: Text(Fmt.dateShort(pts[i].at, context.lang), style: axis));
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: step,
                          reservedSize: Sizes.chartAxisLeft - Space.xs,
                          getTitlesWidget: (v, meta) => v == meta.min || v == meta.max && v % step != 0
                              ? const SizedBox.shrink()
                              : SideTitleWidget(meta: meta, child: Text(v.toStringAsFixed(0), style: axis)),
                        ),
                      ),
                    ),
                    rangeAnnotations: range == null
                        ? null
                        : RangeAnnotations(horizontalRangeAnnotations: [
                            HorizontalRangeAnnotation(y1: range.min * scale, y2: range.max * scale, color: paw.successContainer),
                          ]),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [for (var i = 0; i < pts.length; i++) FlSpot(i.toDouble(), pts[i].weightKg! * scale)],
                        color: paw.textPrimary,
                        barWidth: Strokes.spinner,
                        isCurved: false,
                        isStrokeCapRound: true,
                        isStrokeJoinRound: true,
                        // Open dots along the line; the latest one is a
                        // bigger marigold dot.
                        dotData: FlDotData(
                          getDotPainter: (spot, _, _, i) => FlDotCirclePainter(
                            radius: i == pts.length - 1 ? Space.xs + Strokes.hairline : Space.xs - Strokes.hairline,
                            color: i == pts.length - 1 ? paw.marigold : paw.surface,
                            strokeWidth: Strokes.focus,
                            strokeColor: paw.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  )),
                ),
                const SizedBox(height: Space.sm),
                Text(
                  range == null
                      ? l.weightGrowingNote
                      : l.weightRangeNote('${_trim(range.min * scale, digits)}–${_trim(range.max * scale, digits)} $unit'),
                  style: context.text.bodySmall?.copyWith(color: paw.textSecondary),
                ),
              ]),
      ),
    ]);
  }

  /// "25" rather than "25.0".
  String _trim(double v, int digits) => v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(digits);

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
              leading: Icon(isSymptom ? Ph.smileyNervous : Ph.firstAid,
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
                icon: const Icon(Ph.shareNetwork),
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

  String _sev(BuildContext context, int s) => severityLabel(context, s);
}

/// "Mild", "Moderate" or "Strong" for a symptom.
String severityLabel(BuildContext context, int s) => switch (s) {
      1 => context.l10n.intensityMild,
      2 => context.l10n.intensityModerate,
      _ => context.l10n.intensityStrong,
    };

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
              leading: const Icon(Ph.alarm),
              title: Text(r.title),
              subtitle: Text(Fmt.dateTime(r.at, context.lang)),
              trailing: IconButton(
                tooltip: l.markDone,
                icon: const Icon(Ph.checkCircle),
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
  const _HealthPass({required this.pet, required this.urgent, this.vaccinesOk = false});
  final Pet pet;

  /// No vaccine is overdue (boosters due soon still count as up to date).
  final bool vaccinesOk;

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
      leading: PetAvatar(species: pet.species, colorTag: pet.colorTag, photoUrl: pet.photoUrl, size: Sizes.passArch, name: pet.name),
      badges: [
        if (urgent != null && urgent! > 0) PassCard.badge(context, l.itemsNeedAttention(urgent!), tone: ChipTone.warning),
        if (urgent != null && urgent! > 0 && vaccinesOk) PassCard.badge(context, l.vaccinesUpToDate),
        if (urgent != null && urgent! == 0) PassCard.badge(context, l.healthAllClear),
      ],
      rows: [
        if (age.isNotEmpty) PassRow(label: l.age, value: age),
        if (pet.weightKg != null) PassRow(label: l.weight, value: Fmt.weight(pet.weightKg!, grams: pet.isBird)),
        if (pet.microchip?.isNotEmpty == true) PassRow(label: l.microchip, value: pet.microchip!, mono: true),
      ],
      actions: [
        PassCard.action(context, label: l.medicalCard, icon: Ph.identificationCard, onPressed: () => context.push('/pets/${pet.id}/card')),
        PassCard.action(context, label: l.healthReport, icon: Ph.filePdf, secondary: true, onPressed: () => context.push('/pets/${pet.id}/report')),
      ],
    );
  }
}

/// One dose on a vaccine's card (UI Design 6): a dot on a thin line, the
/// dose's name, and when it was given or is due. Given doses are green; the
/// next one is an open marigold ring; an overdue one is red.
class _DoseRow extends StatelessWidget {
  const _DoseRow({required this.step, required this.last});
  final _VaccineStep step;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final paw = context.paw;
    final st = step.status;
    final (Color dot, Color ring, Color? label) = switch (st) {
      DoseStatus.done => (paw.success, paw.successContainer, null),
      DoseStatus.overdue => (paw.sos, paw.sosContainer, paw.error),
      DoseStatus.dueSoon => (paw.surface, paw.marigold, paw.accent),
      _ => (paw.surface, context.tint.line2, null),
    };
    final k = MediaQuery.textScalerOf(context).scale(1);
    final row = IntrinsicHeight(
      child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        SizedBox(
          width: Space.xl + Space.xs,
          child: Stack(alignment: Alignment.topLeft, children: [
            if (!last)
              Positioned(
                left: Space.sm + Strokes.hairline,
                top: Space.lg + Space.xs,
                bottom: 0,
                child: Container(width: Strokes.focus, color: paw.outline),
              ),
            Positioned(
              left: Space.xxs - Strokes.hairline,
              top: Space.xxs - Strokes.hairline,
              child: Container(
                width: Space.lg + Space.xxs,
                height: Space.lg + Space.xxs,
                padding: const EdgeInsets.all(Space.xxs + Strokes.hairline),
                decoration: BoxDecoration(color: ring, shape: BoxShape.circle),
                child: DecoratedBox(decoration: BoxDecoration(color: dot, shape: BoxShape.circle)),
              ),
            ),
          ]),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: last ? 0 : Space.md + Space.xxs),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(width: Sizes.planColumn * k, child: Text(step.title, style: context.text.labelLarge?.copyWith(color: label))),
              const SizedBox(width: Space.sm),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                  if (step.subtitle.isNotEmpty) Text(step.subtitle, style: context.text.bodySmall?.copyWith(color: paw.textSecondary)),
                  if (step.certificateDocId != null)
                    Padding(
                      padding: const EdgeInsets.only(top: Space.xs),
                      child: TextLink(context.l10n.certificate, onTap: () => context.push('/vault/doc/${step.certificateDocId}')),
                    ),
                ]),
              ),
            ]),
          ),
        ),
      ]),
    );
    if (step.onTap == null) return row;
    return InkWell(onTap: step.onTap, borderRadius: BorderRadius.circular(Radii.sm), child: row);
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
        icon: const Icon(Ph.fileText, size: IconSizes.md),
        label: Text(context.l10n.certificate),
      ),
    ]);
  }
}

/// Emergency info on Health (UI Design 6): allergies and the regular clinic
/// at a glance, in a hairline panel. An allergy is red with a warning sign.
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
    return PawPanel(
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Icon(Ph.firstAidKit, size: IconSizes.sm, color: paw.textPrimary),
          const SizedBox(width: Space.sm),
          Expanded(child: Semantics(header: true, child: Text(l.emergencyInfo, style: context.text.labelLarge))),
        ]),
        const SizedBox(height: Space.md),
        KvList(rows: [
          (l.allergies, allergies, allergic ? Tone.red : null),
          (l.regularClinic, clinic?.name ?? l.notAdded, null),
        ]),
        const SizedBox(height: Space.md),
      ]),
    );
  }
}
