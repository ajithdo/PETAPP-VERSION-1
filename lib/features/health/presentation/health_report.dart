import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/document_preview.dart';
import '../../../core/widgets/widgets.dart';
import '../../pets/data/pets_repository.dart';
import '../../pets/domain/pet.dart';
import '../../pets/presentation/pet_labels.dart';
import '../../routine/data/routine_repository.dart';
import '../../routine/domain/routine.dart';
import '../../shell/presentation/sos_launcher.dart';
import '../data/health_repository.dart';
import '../domain/vaccine_schedule.dart';
import 'health_labels.dart';
import 'health_sheets.dart';

final _clinicProvider = FutureProvider.family<Map<String, dynamic>?, String?>((ref, id) async {
  if (id == null) return null;
  return (await ref.watch(firestoreProvider).collection('clinics').doc(id).get()).data();
});

final _yearLogsProvider = StreamProvider.family<List<RoutineLog>, String>((ref, petId) {
  final now = DateTime.now();
  return ref.watch(routineRepositoryProvider).watchLogs(petId, from: DateTime(now.year - 1, now.month, now.day));
});

/// One-tap health report PDF (spec 7.4): profile, vaccines, medicines,
/// allergies, recent visits and the weight chart.
class HealthReportScreen extends ConsumerWidget {
  const HealthReportScreen({super.key, required this.petId});
  final String petId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final pet = ref.watch(petProvider(petId)).value;
    final v = ref.watch(vaccinesProvider(petId));
    final m = ref.watch(medicinesProvider(petId));
    final e = ref.watch(healthEventsProvider(petId));
    final w = ref.watch(_yearLogsProvider(petId));
    final user = ref.watch(currentUserProvider);
    final clinic = ref.watch(_clinicProvider(pet?.clinicId));
    if (pet == null || !v.hasValue || !m.hasValue || !e.hasValue || !w.hasValue || clinic.isLoading) {
      return Scaffold(appBar: AppBar(title: Text(l.healthReport)), body: const SkeletonList());
    }
    final weights = w.value!.where((g) => g.type == LogType.weight && g.weightKg != null).toList()..sort((a, b) => a.at.compareTo(b.at));
    return DocumentPreviewScreen(
      title: l.healthReportOf(pet.name),
      fileName: '${pet.name}-health-report.pdf',
      pages: (ctx) => _pages(ctx, pet, v.value!, m.value!, e.value!, weights, user?.name ?? '', user?.phone ?? '', clinic.value),
    );
  }

  List<Widget> _pages(BuildContext context, Pet pet, List<VaccineRecord> vaccines, List<Medicine> meds, List<HealthEvent> events,
      List<RoutineLog> weights, String ownerName, String ownerPhone, Map<String, dynamic>? clinic) {
    final l = context.l10n;
    final lang = context.lang;
    final now = DateTime.now();
    final stamp = l.generatedOn(Fmt.dateTime(now, lang));
    final footer = l.reportFooter;
    final sched = buildSchedule(species: pet.speciesEnum, birthday: pet.birthday, records: vaccines, now: now);
    final age = petAgeLabel(context, pet);
    String v(String? s) => (s == null || s.isEmpty) ? '–' : s;

    Widget kv(String k, String value) => Padding(
          padding: const EdgeInsets.only(bottom: 3),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(width: 92, child: Text(k, style: const TextStyle(color: Color(0xFF5B6B6E), fontSize: 9))),
            Expanded(child: Text(value, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600))),
          ]),
        );

    final page1 = A4Page(
      title: l.healthReport,
      subtitle: stamp,
      footer: footer,
      pageLabel: '1 / 2',
      children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          PetFace(species: pet.species, color: PetTagColors.of(pet.colorTag), size: 72),
          const SizedBox(width: 16),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(pet.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
              Text('${speciesLabel(context, pet.species)} · ${pet.breedName(lang)}', style: const TextStyle(fontSize: 11, color: Color(0xFF5B6B6E))),
              const SizedBox(height: 8),
              Row(children: [
                Expanded(child: Column(children: [
                  kv(l.age, v(age)),
                  kv(l.birthday, pet.birthday == null ? '–' : Fmt.date(pet.birthday!, lang)),
                  kv(l.gender, genderLabel(context, pet.gender)),
                  kv(l.weight, pet.weightKg == null ? '–' : Fmt.weight(pet.weightKg!, grams: pet.isBird)),
                ])),
                const SizedBox(width: 12),
                Expanded(child: Column(children: [
                  kv(l.neutered, pet.neutered ? l.yes : l.no),
                  kv(l.microchip, v(pet.microchip)),
                  kv(l.markings, v(pet.markings)),
                  kv(l.dietType, v(pet.dietType)),
                ])),
              ]),
            ]),
          ),
        ]),
        A4Section(
          title: l.ownerAndClinic,
          child: Row(children: [
            Expanded(child: Column(children: [kv(l.owner, v(ownerName)), kv(l.phone, v(ownerPhone))])),
            const SizedBox(width: 12),
            Expanded(child: Column(children: [kv(l.regularClinic, v(clinic?['name'] as String?)), kv(l.phone, v(clinic?['phone'] as String?))])),
          ]),
        ),
        A4Section(
          title: l.allergies,
          child: Text(pet.allergies.isEmpty ? l.noKnownAllergies : pet.allergies.join(', '),
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: pet.allergies.isEmpty ? null : const Color(0xFFB91C1C))),
        ),
        A4Section(
          title: l.vaccinations,
          child: sched.items.isEmpty && vaccines.isEmpty
              ? Text(pet.species == 'rabbit' ? l.rabbitVaccineNote : l.birdVaccineNote)
              : A4Table(
                  header: [l.vaccine, l.dose, l.dateGiven, l.nextDueShort, l.status],
                  flex: const [3, 2, 2, 2, 2],
                  rows: [
                    for (final i in sched.items.where((i) => !i.template.optional))
                      [
                        i.template.name,
                        doseLabel(context, i.template.doseLabel),
                        i.record == null ? '–' : Fmt.date(i.record!.givenDate, lang),
                        i.status == DoseStatus.done ? '–' : (i.due == null ? l.askYourVet : Fmt.date(i.due!, lang)),
                        statusChip(context, i.status).$1,
                      ],
                    for (final r in vaccines.where((r) => r.key == 'other')) [r.name, '–', Fmt.date(r.givenDate, lang), '–', l.statusDone],
                  ],
                ),
        ),
        if (sched.needsCatchUp) Padding(padding: const EdgeInsets.only(top: 4), child: Text(l.catchUpNote, style: const TextStyle(fontSize: 9))),
        A4Section(
          title: l.medicines,
          child: A4Table(
            header: [l.medicineName, l.dose, l.frequency, l.startDate],
            flex: const [3, 2, 3, 2],
            rows: [
              for (final m in meds)
                [m.name, '${m.dose} ${unitLabel(context, m.unit)}', '${frequencyLabel(context, m)}${m.withFood ? ' · ${l.withFood}' : ''}', Fmt.date(m.start, lang)],
            ],
          ),
        ),
      ],
    );

    final visits = events.where((e) => e.type == 'vet_visit').take(6).toList();
    final symptomsList = events.where((e) => e.type == 'symptom').take(6).toList();
    final prevention = events.where((e) => e.type == 'deworming' || e.type == 'flea_tick').take(6).toList();
    final page2 = A4Page(
      title: l.healthReport,
      subtitle: '${pet.name} · $stamp',
      footer: footer,
      pageLabel: '2 / 2',
      children: [
        A4Section(
          title: l.vetVisits,
          child: A4Table(
            header: [l.date, l.clinicName, l.reasonForVisit, l.diagnosis],
            flex: const [2, 3, 3, 3],
            rows: [for (final e in visits) [Fmt.date(e.date, lang), v(e.clinicName), e.title, v(e.diagnosis)]],
          ),
        ),
        A4Section(
          title: l.symptomDiary,
          child: A4Table(
            header: [l.date, l.symptom, l.severity, l.noteOptional],
            flex: const [2, 2, 2, 4],
            rows: [
              for (final e in symptomsList)
                [Fmt.date(e.date, lang), symptomLabel(context, e.symptom), e.severity <= 1 ? l.intensityMild : (e.severity == 2 ? l.intensityModerate : l.intensityStrong), v(e.notes)],
            ],
          ),
        ),
        A4Section(
          title: l.prevention,
          child: A4Table(
            header: [l.date, l.type, l.productUsed],
            flex: const [2, 2, 4],
            rows: [for (final e in prevention) [Fmt.date(e.date, lang), e.type == 'deworming' ? l.deworming : l.fleaTick, e.title]],
          ),
        ),
        A4Section(
          title: l.weight,
          child: SizedBox(
            height: 170,
            child: weights.length < 2
                ? Text(l.weightNeedsTwo)
                : CustomPaint(painter: _WeightPainter(weights, pet.isBird, healthyWeight(pet.speciesEnum, pet.breedId, pet.size, young: pet.lifeStage() == 'young'))),
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: const Color(0xFFFDE7D3), borderRadius: BorderRadius.circular(8)),
          child: Text(l.indicativeNote, style: const TextStyle(fontSize: 9)),
        ),
      ],
    );
    return [page1, page2];
  }
}

class _WeightPainter extends CustomPainter {
  _WeightPainter(this.logs, this.grams, this.range);
  final List<RoutineLog> logs;
  final bool grams;
  final ({double min, double max})? range;

  @override
  void paint(Canvas canvas, Size size) {
    final s = grams ? 1000.0 : 1.0;
    final vals = logs.map((g) => g.weightKg! * s).toList();
    var lo = vals.reduce((a, b) => a < b ? a : b);
    var hi = vals.reduce((a, b) => a > b ? a : b);
    if (range != null) {
      lo = lo < range!.min * s ? lo : range!.min * s;
      hi = hi > range!.max * s ? hi : range!.max * s;
    }
    lo *= 0.9;
    hi *= 1.1;
    const left = 36.0;
    final w = size.width - left - 8;
    final h = size.height - 20;
    double y(double v) => h - (v - lo) / (hi - lo) * h;
    double x(int i) => left + (logs.length == 1 ? 0 : i / (logs.length - 1) * w);
    final grid = Paint()..color = const Color(0xFFE5E1DA);
    final tp = TextPainter(textDirection: TextDirection.ltr);
    for (var k = 0; k <= 4; k++) {
      final v = lo + (hi - lo) * k / 4;
      canvas.drawLine(Offset(left, y(v)), Offset(size.width, y(v)), grid);
      tp.text = TextSpan(text: v.toStringAsFixed(grams ? 0 : 1), style: const TextStyle(fontSize: 8, color: Color(0xFF5B6B6E)));
      tp.layout();
      tp.paint(canvas, Offset(0, y(v) - 5));
    }
    if (range != null) {
      canvas.drawRect(Rect.fromLTRB(left, y(range!.max * s), size.width, y(range!.min * s)), Paint()..color = const Color(0x2215803D));
    }
    final path = Path();
    for (var i = 0; i < vals.length; i++) {
      i == 0 ? path.moveTo(x(i), y(vals[i])) : path.lineTo(x(i), y(vals[i]));
    }
    canvas.drawPath(path, Paint()..color = const Color(0xFF0F766E)..style = PaintingStyle.stroke..strokeWidth = 2.5);
    for (var i = 0; i < vals.length; i++) {
      canvas.drawCircle(Offset(x(i), y(vals[i])), 3, Paint()..color = const Color(0xFF0F766E));
    }
    for (final i in {0, vals.length - 1}) {
      tp.text = TextSpan(text: Fmt.dateShort(logs[i].at), style: const TextStyle(fontSize: 8, color: Color(0xFF5B6B6E)));
      tp.layout();
      tp.paint(canvas, Offset((x(i) - tp.width / 2).clamp(left, size.width - tp.width), h + 6));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Offline medical card: the essentials to show a vet, a boarding centre or
/// at the airport. Works from data already on the phone.
class MedicalCardScreen extends ConsumerWidget {
  const MedicalCardScreen({super.key, required this.petId});
  final String petId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.medicalCard),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: Space.md),
            child: SosButton(onActivate: () => openSos(context, ref)),
          ),
        ],
      ),
      body: PageBody(maxWidth: 560, children: [
        const SizedBox(height: Space.sm),
        MedicalSummaryCard(petId: petId),
        const SizedBox(height: Space.lg),
        InfoNote(l.medicalCardOffline, icon: Icons.offline_bolt_rounded),
      ]),
    );
  }
}

/// The medical card itself: shown on the medical card screen and in SOS so
/// the vet can see it at a glance.
class MedicalSummaryCard extends ConsumerWidget {
  const MedicalSummaryCard({super.key, required this.petId});
  final String petId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final pet = ref.watch(petProvider(petId)).value;
    if (pet == null) return const Skeleton(height: 240);
    final user = ref.watch(currentUserProvider);
    final vaccines = ref.watch(vaccinesProvider(petId)).value ?? const [];
    final meds = ref.watch(medicinesProvider(petId)).value ?? const [];
    final clinic = ref.watch(_clinicProvider(pet.clinicId)).value;
    final rabies = vaccines.where((v) => v.key.startsWith('rabies')).toList();
    final now = DateTime.now();
    Widget row(IconData icon, String k, String v, {Color? color}) => ListTile(
          dense: true,
          leading: Icon(icon, color: color ?? context.colors.primary),
          title: Text(k, style: context.text.bodySmall),
          subtitle: Text(v, style: context.text.bodyLarge?.copyWith(fontWeight: FontWeight.w600, color: color)),
        );
    return PawCard(
      borderColor: context.paw.sos,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          PetAvatar(species: pet.species, colorTag: pet.colorTag, photoUrl: pet.photoUrl, size: 72),
          const SizedBox(width: Space.lg),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(pet.name, style: context.text.headlineSmall),
              Text('${speciesLabel(context, pet.species)} · ${pet.breedName(context.lang)}', style: context.text.bodySmall),
              Text([petAgeLabel(context, pet), if (pet.weightKg != null) Fmt.weight(pet.weightKg!, grams: pet.isBird)].where((s) => s.isNotEmpty).join(' · '),
                  style: context.text.bodySmall),
            ]),
          ),
        ]),
        const Divider(height: Space.xl),
        row(Icons.no_food_rounded, l.allergies, pet.allergies.isEmpty ? l.noKnownAllergies : pet.allergies.join(', '),
            color: pet.allergies.isEmpty ? null : context.paw.error),
        row(Icons.medication_rounded, l.currentMedicines, meds.isEmpty ? l.none : meds.map((m) => '${m.name} (${frequencyLabel(context, m)})').join(', ')),
        row(Icons.vaccines_rounded, l.rabiesVaccine, rabies.isEmpty ? l.notRecorded : l.givenOn(Fmt.date(rabies.first.givenDate, context.lang))),
        row(Icons.memory_rounded, l.microchip, pet.microchip ?? l.notAdded),
        row(Icons.local_hospital_rounded, l.regularClinic, clinic == null ? l.notAdded : '${clinic['name']} · ${clinic['phone']}'),
        row(Icons.person_rounded, l.owner, '${user?.name ?? ''} · ${user?.phone ?? ''}'),
        const SizedBox(height: Space.sm),
        Text(l.medicalCardUpdated(Fmt.dateTime(now, context.lang)), style: context.text.labelSmall),
      ]),
    );
  }
}
