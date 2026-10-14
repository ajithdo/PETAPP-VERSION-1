import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/gen/app_localizations.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/utils/widget_capture.dart';
import '../../../core/widgets/document_preview.dart';
import '../../../core/widgets/widgets.dart';
import '../data/consultation.dart';
import '../data/prescription_service.dart';
import '../data/televet_repository.dart';
import 'prescription_pdf.dart';

/// The signed-in vet's profile (name, qualification, registration number).
final myVetDocProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final u = ref.watch(currentUserProvider);
  if (u == null) return const {};
  final db = ref.watch(firestoreProvider);
  final s = await db.collection('vets').where('uid', isEqualTo: u.uid).get();
  if (s.docs.isNotEmpty) return {'id': s.docs.first.id, ...s.docs.first.data()};
  if (u.partnerId != null) {
    final d = await db.collection('vets').doc(u.partnerId).get();
    if (d.exists) return {'id': d.id, ...d.data()!};
  }
  return {'name': u.name};
});

final _clinicDocProvider = FutureProvider.family<Map<String, dynamic>?, String?>((ref, id) async {
  if (id == null || id.isEmpty) return null;
  return (await ref.watch(firestoreProvider).collection('clinics').doc(id).get()).data();
});

class _ItemCtrl {
  final medicine = TextEditingController();
  final dose = TextEditingController();
  final frequency = TextEditingController();
  final duration = TextEditingController();
  final instructions = TextEditingController();
  void dispose() {
    for (final c in [medicine, dose, frequency, duration, instructions]) {
      c.dispose();
    }
  }

  PrescriptionItem toItem() => PrescriptionItem(
        medicine: medicine.text.trim(),
        dose: dose.text.trim(),
        frequency: frequency.text.trim(),
        duration: duration.text.trim(),
        instructions: instructions.text.trim(),
      );
}

/// '/partner/consult/:id/prescription': the e-prescription builder
/// (medicine, dose, frequency, duration, instructions, follow-up date).
/// "Sign and send" renders the PDF in the pet parent's language and saves
/// it to the pet's records and vault.
class PrescriptionBuilderScreen extends ConsumerStatefulWidget {
  const PrescriptionBuilderScreen({super.key, required this.consultationId});
  final String consultationId;
  @override
  ConsumerState<PrescriptionBuilderScreen> createState() => _PrescriptionBuilderScreenState();
}

class _PrescriptionBuilderScreenState extends ConsumerState<PrescriptionBuilderScreen> {
  final _diagnosis = TextEditingController();
  final _notes = TextEditingController();
  final _items = <_ItemCtrl>[_ItemCtrl()];
  DateTime? _followUp;
  bool _busy = false;
  static const maxItems = 8;

  @override
  void dispose() {
    _diagnosis.dispose();
    _notes.dispose();
    for (final i in _items) {
      i.dispose();
    }
    super.dispose();
  }

  PrescriptionDraft get _draft => PrescriptionDraft(
        items: [for (final i in _items) i.toItem()].where((i) => i.medicine.isNotEmpty).toList(),
        diagnosis: _diagnosis.text.trim(),
        notes: _notes.text.trim(),
        followUp: _followUp,
      );

  Map<String, dynamic> _doc(Consultation c, Map<String, dynamic> vetDoc, Map<String, dynamic>? clinic) {
    final pet = c.pet;
    return ref.read(prescriptionServiceProvider).buildDoc(
          c: c,
          vet: ref.read(currentUserProvider)!,
          vetDoc: vetDoc,
          clinic: clinic,
          draft: _draft,
          petInfo: {
            'breedId': pet.breedId,
            'breedOther': pet.breedOther,
            'birthday': pet.birthday,
            'weightKg': pet.weightKg,
            'gender': pet.gender,
            'allergies': pet.allergies,
          },
          now: DateTime.now(),
        );
  }

  void _preview(Consultation c, Map<String, dynamic> vetDoc, Map<String, dynamic>? clinic) {
    final l = context.l10n;
    final doc = _doc(c, vetDoc, clinic);
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => DocumentPreviewScreen(
        title: l.rxTitleOf(c.petName),
        fileName: '${c.petName}-prescription.pdf',
        pages: (ctx) => [PrescriptionPage(l: ctx.l10n, lang: ctx.lang, rx: doc)],
      ),
    ));
  }

  Future<void> _send(Consultation c, Map<String, dynamic> vetDoc, Map<String, dynamic>? clinic) async {
    final l = context.l10n;
    if (_draft.items.isEmpty) {
      showToast(context, l.rxNeedMedicine);
      return;
    }
    final ok = await confirmAction(context, title: l.rxSignTitle, body: l.rxSignBody(c.ownerName, c.petName), confirmLabel: l.rxSignSend, danger: false);
    if (!ok || !mounted) return;
    setState(() => _busy = true);
    try {
      final service = ref.read(prescriptionServiceProvider);
      final ownerLang = await service.ownerLanguage(c.ownerId);
      final doc = _doc(c, vetDoc, clinic);
      if (!mounted) return;
      // Render in the pet parent's language (Hindi/Telugu shaped by Flutter).
      final ownerL = lookupAppLocalizations(Locale(ownerLang));
      final png = await renderWidgetToPng(
        PrescriptionPage(l: ownerL, lang: ownerLang, rx: doc),
        view: View.of(context),
        theme: AppTheme.build(brightness: Brightness.light, locale: ownerLang),
        logicalSize: a4Logical,
      );
      final pdf = await pngPagesToPdf([png], title: ownerL.rxTitleOf(c.petName));
      await service.issue(c: c, vet: ref.read(currentUserProvider)!, doc: doc, pdf: pdf, ownerLang: ownerLang);
      if (!mounted) return;
      showToast(context, l.rxSentToast(c.ownerName.split(' ').first, c.petName));
      context.pop();
    } catch (e) {
      debugPrint('Prescription failed: $e');
      if (mounted) showToast(context, l.errorBody);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = ref.watch(consultationProvider(widget.consultationId)).value;
    final vet = ref.watch(myVetDocProvider);
    final clinic = ref.watch(_clinicDocProvider(vet.value?['clinicId'] as String? ?? c?.clinicId));
    if (c == null || !vet.hasValue) return Scaffold(appBar: AppBar(title: Text(l.rxWrite)), body: const SkeletonList());
    final vetDoc = vet.value!;
    final freq = [l.rxFreqOnce, l.rxFreqTwice, l.rxFreqThrice, l.rxFreqNeeded];
    final durations = [l.rxDays(3), l.rxDays(5), l.rxDays(7), l.rxDays(14)];
    final instr = [l.rxAfterFood, l.rxBeforeFood, l.rxApplyThin];
    Widget chips(List<String> options, TextEditingController ctrl) => Wrap(spacing: Space.xs, runSpacing: Space.xs, children: [
          for (final o in options)
            ActionChip(
              label: Text(o, style: context.text.labelSmall),
              visualDensity: VisualDensity.compact,
              onPressed: () => setState(() => ctrl.text = o),
            ),
        ]);

    return Scaffold(
      appBar: AppBar(title: Text(l.rxWrite)),
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: PageBody(maxWidth: 760, children: [
              const SizedBox(height: Space.sm),
              PawCard(
                padding: const EdgeInsets.all(Space.md),
                child: Row(children: [
                  PetAvatar(species: c.petSpecies, colorTag: c.pet.colorTag, photoUrl: c.pet.photoUrl, size: 44),
                  const SizedBox(width: Space.md),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('${c.petName} · ${c.ownerName}', style: context.text.titleSmall),
                      Text(
                        [vetDoc['name'] ?? '', vetDoc['qualification'] ?? '', l.rxRegNo((vetDoc['regNo'] as String?) ?? '–')].where((s) => '$s'.isNotEmpty).join(' · '),
                        style: context.text.bodySmall,
                      ),
                    ]),
                  ),
                ]),
              ),
              const SizedBox(height: Space.md),
              PawTextField(label: l.rxDiagnosis, controller: _diagnosis, hint: l.rxDiagnosisHint, maxLines: 2),
              SectionHeader(l.rxMedicines, padding: const EdgeInsets.only(top: Space.sm, bottom: Space.sm)),
              for (final (n, item) in _items.indexed)
                Padding(
                  padding: const EdgeInsets.only(bottom: Space.md),
                  child: PawCard(
                    padding: const EdgeInsets.all(Space.md),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                      Row(children: [
                        Expanded(child: Text(l.rxMedicineN(n + 1), style: context.text.titleSmall)),
                        if (_items.length > 1)
                          IconButton(
                            tooltip: l.remove,
                            onPressed: () => setState(() => _items.removeAt(n).dispose()),
                            icon: const Icon(Icons.delete_outline_rounded),
                          ),
                      ]),
                      const SizedBox(height: Space.sm),
                      PawTextField(label: l.rxMedicine, controller: item.medicine, hint: l.rxMedicineHint),
                      Row(children: [
                        Expanded(child: PawTextField(label: l.dose, controller: item.dose, hint: l.rxDoseHint)),
                        const SizedBox(width: Space.sm),
                        Expanded(child: PawTextField(label: l.rxDuration, controller: item.duration)),
                      ]),
                      chips(durations, item.duration),
                      const SizedBox(height: Space.md),
                      PawTextField(label: l.frequency, controller: item.frequency),
                      chips(freq, item.frequency),
                      const SizedBox(height: Space.md),
                      PawTextField(label: l.rxInstructions, controller: item.instructions),
                      chips(instr, item.instructions),
                    ]),
                  ),
                ),
              if (_items.length < maxItems)
                SecondaryButton(label: l.rxAddMedicine, icon: Icons.add_rounded, onPressed: () => setState(() => _items.add(_ItemCtrl()))),
              const SizedBox(height: Space.lg),
              PawTextField(label: l.rxAdvice, controller: _notes, hint: l.rxAdviceHint, maxLines: 3),
              Row(children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final now = DateTime.now();
                      final d = await showDatePicker(
                        context: context,
                        firstDate: now,
                        lastDate: now.add(const Duration(days: 180)),
                        initialDate: _followUp ?? now.add(const Duration(days: 7)),
                      );
                      if (d != null) setState(() => _followUp = d);
                    },
                    icon: const Icon(Icons.event_rounded),
                    label: Text(_followUp == null ? l.rxAddFollowUp : l.rxFollowUpOn(Fmt.date(_followUp!, context.lang))),
                  ),
                ),
                if (_followUp != null) IconButton(tooltip: l.remove, onPressed: () => setState(() => _followUp = null), icon: const Icon(Icons.close_rounded)),
              ]),
              const SizedBox(height: Space.md),
              InfoNote(l.rxWhereItGoes(c.petName)),
            ]),
          ),
          Padding(
            padding: EdgeInsets.all(context.gutter),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Row(children: [
                Expanded(child: SecondaryButton(label: l.rxPreview, icon: Icons.visibility_rounded, onPressed: () => _preview(c, vetDoc, clinic.value))),
                const SizedBox(width: Space.md),
                Expanded(
                  flex: 2,
                  child: PrimaryButton(label: l.rxSignSend, icon: Icons.draw_rounded, loading: _busy, onPressed: () => _send(c, vetDoc, clinic.value)),
                ),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}
