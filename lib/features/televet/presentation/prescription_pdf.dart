import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/converters.dart';
import '../../../core/l10n/gen/app_localizations.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/document_preview.dart';
import '../../../core/widgets/widgets.dart';
import '../../pets/domain/pet.dart';
import '../data/consultation.dart';
import '../data/televet_repository.dart';

/// Age like "3 yrs 2 mo" without a BuildContext (PDFs render off screen).
String ageText(AppLocalizations l, DateTime? birthday, DateTime now) {
  if (birthday == null) return '–';
  final a = ageParts(birthday, now);
  if (a.years == 0) return l.ageMonths(a.months);
  if (a.months == 0) return l.ageYears(a.years);
  return l.ageYearsMonths(a.years, a.months);
}

String speciesText(AppLocalizations l, String s) => switch (s) {
      'cat' => l.speciesCat,
      'bird' => l.speciesBird,
      'rabbit' => l.speciesRabbit,
      _ => l.speciesDog,
    };

String genderText(AppLocalizations l, String? g) => switch (g) {
      'male' => l.genderMale,
      'female' => l.genderFemale,
      _ => l.genderUnknown,
    };

/// The A4 e-prescription (spec 7.7): vet name, qualification, Veterinary
/// Council registration number, clinic, date, medicines and signature.
/// Takes [l] explicitly so it can be rendered in the pet parent's language.
class PrescriptionPage extends StatelessWidget {
  const PrescriptionPage({super.key, required this.l, required this.lang, required this.rx});
  final AppLocalizations l;
  final String lang;
  final Map<String, dynamic> rx;

  @override
  Widget build(BuildContext context) {
    final created = parseDate(rx['createdAt']) ?? DateTime.now();
    final follow = parseDate(rx['followUp']);
    final info = ((rx['petInfo'] as Map?) ?? const {}).cast<String, dynamic>();
    final pet = Pet.fromJson({
      'id': rx['petId'] ?? '',
      'ownerId': rx['ownerId'] ?? '',
      'name': rx['petName'] ?? '',
      'species': rx['petSpecies'] ?? 'dog',
      ...info,
    });
    final items = [for (final i in (rx['items'] as List?) ?? const []) PrescriptionItem.fromMap((i as Map).cast<String, dynamic>())];
    String v(Object? s) => (s == null || '$s'.trim().isEmpty) ? '–' : '$s';
    const grey = Color(0xFF5B6B6E);
    const teal = Color(0xFF0F766E);

    Widget kv(String k, String value) => Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(width: 92, child: Text(k, style: const TextStyle(color: grey, fontSize: 9))),
            Expanded(child: Text(value, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600))),
          ]),
        );

    return Stack(children: [
      A4Page(
        title: l.rxTitle,
        subtitle: Fmt.dateTime(created, lang),
        footer: l.rxFooter,
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(v(rx['vetName']), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                Text(v(rx['qualification']), style: const TextStyle(fontSize: 10, color: grey)),
                Text(l.rxRegNo(v(rx['regNo'])), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
              ]),
            ),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(v(rx['clinicName']), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700), textAlign: TextAlign.end),
                Text(v(rx['clinicAddress']), style: const TextStyle(fontSize: 9, color: grey), textAlign: TextAlign.end),
                if ((rx['clinicPhone'] as String?)?.isNotEmpty == true) Text(rx['clinicPhone'] as String, style: const TextStyle(fontSize: 9, color: grey)),
              ]),
            ),
          ]),
          const SizedBox(height: 8),
          const Divider(color: Color(0xFFE5E1DA), height: 1),
          A4Section(
            title: l.rxPatient,
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(child: Column(children: [
                kv(l.rxPetName, v(rx['petName'])),
                kv(l.rxSpeciesBreed, [speciesText(l, pet.species), pet.breedName(lang)].where((s) => s.isNotEmpty).join(' · ')),
                kv(l.age, ageText(l, pet.birthday, created)),
              ])),
              const SizedBox(width: 12),
              Expanded(child: Column(children: [
                kv(l.weight, pet.weightKg == null ? '–' : Fmt.weight(pet.weightKg!, grams: pet.isBird)),
                kv(l.gender, genderText(l, pet.gender)),
                kv(l.owner, v(rx['ownerName'])),
              ])),
            ]),
          ),
          if (pet.allergies.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text('${l.allergies}: ${pet.allergies.join(', ')}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFFB91C1C))),
            ),
          A4Section(title: l.rxDiagnosis, child: Text(v(rx['diagnosis']), style: const TextStyle(fontSize: 11))),
          A4Section(
            title: 'Rx',
            child: A4Table(
              header: [l.rxMedicine, l.dose, l.frequency, l.rxDuration, l.rxInstructions],
              flex: const [3, 2, 2, 2, 3],
              rows: [for (final i in items) [i.medicine, v(i.dose), v(i.frequency), v(i.duration), v(i.instructions)]],
            ),
          ),
          if ((rx['notes'] as String?)?.isNotEmpty == true) A4Section(title: l.rxAdvice, child: Text(rx['notes'] as String, style: const TextStyle(fontSize: 10.5))),
          A4Section(title: l.rxFollowUp, child: Text(follow == null ? l.rxNoFollowUp : Fmt.date(follow, lang), style: const TextStyle(fontSize: 10.5))),
          const Spacer(),
          Align(
            alignment: Alignment.centerRight,
            child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(v(rx['vetName']),
                  style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: teal, fontWeight: FontWeight.w500, letterSpacing: 0.5)),
              Container(width: 180, height: 1, color: const Color(0xFF1C2B2D), margin: const EdgeInsets.symmetric(vertical: 3)),
              Text(l.rxSignedDigitally(Fmt.dateTime(created, lang)), style: const TextStyle(fontSize: 8.5, color: grey)),
              Text(l.rxRegNo(v(rx['regNo'])), style: const TextStyle(fontSize: 8.5, color: grey)),
            ]),
          ),
          const SizedBox(height: 6),
        ],
      ),
      // Demo documents are stamped SAMPLE (spec 12).
      Positioned(
        right: 40,
        top: 120,
        child: Transform.rotate(
          angle: 0.25,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(border: Border.all(color: const Color(0x88B91C1C), width: 2), borderRadius: BorderRadius.circular(4)),
            child: Text(l.msgSampleStamp, style: const TextStyle(color: Color(0x88B91C1C), fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 2)),
          ),
        ),
      ),
    ]);
  }
}

/// '/prescriptions/:id': view, share or download an e-prescription. Pet
/// parents (and their family) and vets can open it.
class PrescriptionScreen extends ConsumerWidget {
  const PrescriptionScreen({super.key, required this.prescriptionId});
  final String prescriptionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final rx = ref.watch(prescriptionProvider(prescriptionId));
    return AsyncView<Prescription?>(
      value: rx,
      loading: Scaffold(appBar: AppBar(title: Text(l.rxTitle)), body: const SkeletonList()),
      data: (p) {
        if (p == null) return Scaffold(appBar: AppBar(title: Text(l.rxTitle)), body: EmptyState(title: l.notFoundTitle));
        return DocumentPreviewScreen(
          title: l.rxTitleOf(p.petName),
          fileName: '${p.petName}-prescription-${Fmt.date(p.createdAt).replaceAll(' ', '-')}.pdf',
          pages: (ctx) => [PrescriptionPage(l: ctx.l10n, lang: ctx.lang, rx: p.raw)],
        );
      },
    );
  }
}
