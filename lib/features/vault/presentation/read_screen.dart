import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/utils/read_once.dart';
import '../../../core/widgets/widgets.dart';
import '../../pets/data/pets_repository.dart';
import '../../pets/domain/pet.dart';
import '../data/vault_repository.dart';
import '../domain/auto_read.dart';
import '../domain/vault_models.dart';
import 'doc_preview.dart';
import 'vault_labels.dart';

final documentReaderProvider = Provider<DocumentReader>((ref) => const SimulatedDocumentReader());

/// "We found these details. Save them?" (spec 7.9). Reads the document
/// (simulated in Version 1), lets the owner fix anything, then saves the
/// details and, for vaccine certificates, records the vaccine in the
/// pet's health records. Also used to edit details later.
class AutoReadScreen extends ConsumerStatefulWidget {
  const AutoReadScreen({super.key, required this.docId, this.fromUpload = false});
  final String docId;
  final bool fromUpload;

  @override
  ConsumerState<AutoReadScreen> createState() => _AutoReadScreenState();
}

class _AutoReadScreenState extends ConsumerState<AutoReadScreen> {
  VaultDoc? _doc;
  Pet? _pet;
  bool _reading = true;
  bool _found = false;
  bool _saving = false;
  String _type = 'other';
  final _c = <String, TextEditingController>{};
  final _dates = <String, DateTime?>{};
  final _tags = <String>[];
  final _tagInput = TextEditingController();
  bool _addToHealth = true;
  bool _trackInsurance = true;

  TextEditingController c(String k) => _c[k] ??= TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _start());
  }

  @override
  void dispose() {
    for (final x in _c.values) {
      x.dispose();
    }
    _tagInput.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    final doc = await readOnce(ref, docProvider(widget.docId));
    if (doc == null || !mounted) {
      setState(() => _reading = false);
      return;
    }
    final pet = await readOnce(ref, petProvider(doc.petId));
    if (!mounted) return;
    setState(() {
      _doc = doc;
      _pet = pet;
    });
    late ExtractedDetails d;
    if (doc.extracted != null && doc.readStatus == 'confirmed') {
      d = ExtractedDetails.fromMap(doc.extracted!);
      d.type = doc.type;
    } else {
      d = await ref.read(documentReaderProvider).read(
            sampleKey: doc.sampleKey,
            fileName: doc.fileName,
            petName: pet?.name ?? '',
            issuedOn: sampleIssuedOn(doc),
          );
      if (doc.readStatus == 'confirmed' || doc.readStatus == 'skipped') d.type = doc.type;
    }
    if (!mounted) return;
    _fill(d, doc);
  }

  void _fill(ExtractedDetails d, VaultDoc doc) {
    final l = context.l10n;
    _found = d.found;
    _type = d.type == 'other' && doc.type != 'other' ? doc.type : d.type;
    String? suggested;
    if (d.vaccineName != null) suggested = l.vaultTitleVaccineCert(d.vaccineName!);
    if (d.insurer != null && d.type == 'insurance') suggested = l.vaultTitlePolicy(d.insurer!);
    if (d.testName != null && d.type == 'lab') suggested = d.testName;
    final generic = doc.isSample || doc.title.isEmpty;
    c('title').text = generic && suggested != null ? suggested : doc.title;
    c('petName').text = d.petName ?? '';
    c('vaccine').text = d.vaccineName ?? '';
    c('brand').text = d.brand ?? '';
    c('batch').text = d.batch ?? '';
    c('vet').text = d.vetName ?? '';
    c('vetReg').text = d.vetRegNo ?? '';
    c('clinic').text = d.clinicName ?? '';
    c('insurer').text = d.insurer ?? '';
    c('policyNo').text = d.policyNo ?? '';
    c('cover').text = d.cover?.toString() ?? '';
    c('premium').text = d.premium?.toString() ?? '';
    c('test').text = d.testName ?? '';
    c('amount').text = d.amount?.toString() ?? '';
    c('reference').text = d.referenceNo ?? '';
    c('issuer').text = d.issuer ?? '';
    _dates
      ..['dateGiven'] = d.dateGiven
      ..['nextDue'] = d.nextDue
      ..['expiry'] = d.expiry ?? doc.expiry
      ..['coverStart'] = d.coverStart
      ..['issuedOn'] = d.issuedOn;
    _tags
      ..clear()
      ..addAll(doc.tags);
    if (_tags.isEmpty && d.found) {
      final series = d.vaccineName == null ? null : vaccineSeries(d.vaccineName!);
      final year = (d.dateGiven ?? d.issuedOn ?? d.coverStart)?.year;
      _tags.addAll([
        if (series != null && series != 'other') series,
        if (d.type == 'insurance') 'insurance',
        if (d.type == 'lab') 'lab',
        if (year != null) '$year',
      ]);
    }
    setState(() => _reading = false);
  }

  ExtractedDetails _collect() {
    String? t(String k) => c(k).text.trim().isEmpty ? null : c(k).text.trim();
    int? n(String k) => int.tryParse(c(k).text.replaceAll(RegExp(r'[^0-9]'), ''));
    final vaccine = _type == 'vaccination';
    final ins = _type == 'insurance';
    return ExtractedDetails(
      type: _type,
      found: _found,
      petName: t('petName'),
      vaccineName: vaccine ? t('vaccine') : null,
      brand: vaccine ? t('brand') : null,
      batch: vaccine ? t('batch') : null,
      dateGiven: vaccine || _type == 'lab' ? _dates['dateGiven'] : null,
      nextDue: vaccine ? _dates['nextDue'] : null,
      vetName: t('vet'),
      vetRegNo: t('vetReg'),
      clinicName: t('clinic'),
      insurer: ins ? t('insurer') : null,
      policyNo: ins ? t('policyNo') : null,
      cover: ins ? n('cover') : null,
      premium: ins ? n('premium') : null,
      coverStart: ins ? _dates['coverStart'] : null,
      expiry: _dates['expiry'],
      testName: _type == 'lab' ? t('test') : null,
      amount: _type == 'invoice' ? n('amount') : null,
      referenceNo: t('reference'),
      issuer: t('issuer'),
      issuedOn: _dates['issuedOn'],
    );
  }

  Future<void> _save() async {
    final l = context.l10n;
    final doc = _doc;
    final pet = _pet;
    final user = ref.read(currentUserProvider);
    if (doc == null || pet == null || user == null) return;
    if (c('title').text.trim().isEmpty) {
      showToast(context, l.fieldRequired);
      return;
    }
    final d = _collect();
    if (_type == 'vaccination' && _addToHealth && (d.vaccineName == null || d.dateGiven == null)) {
      showToast(context, l.vaultVaccineNeeded);
      return;
    }
    setState(() => _saving = true);
    try {
      final res = await ref.read(vaultRepositoryProvider).saveReadDetails(
            doc: doc,
            pet: pet,
            by: user,
            details: d,
            title: c('title').text.trim(),
            tags: _tags,
            addToHealth: _type == 'vaccination' && _addToHealth,
            trackInsurance: _type == 'insurance' && _trackInsurance,
            reminderTitle: _type == 'insurance' ? l.vaultInsuranceReminderTitle(pet.name) : l.vaultReminderTitle(c('title').text.trim(), pet.name),
          );
      if (!mounted) return;
      HapticFeedback.lightImpact();
      showToast(context, res.vaccineRecorded ? l.vaultSavedVaccine(d.vaccineName!, pet.name) : l.vaultSaved);
      _leave();
    } catch (e) {
      debugPrint('Save details failed: $e');
      if (mounted) {
        setState(() => _saving = false);
        showToast(context, l.errorBody);
      }
    }
  }

  Future<void> _skip() async {
    final doc = _doc;
    if (doc == null) return;
    await ref.read(vaultRepositoryProvider).updateDoc(doc.id, {
      'type': _type,
      'title': c('title').text.trim().isEmpty ? doc.title : c('title').text.trim(),
      'tags': cleanTags(_tags),
      'expiry': _dates['expiry'],
      'readStatus': 'skipped',
    });
    if (mounted) _leave();
  }

  void _leave() {
    if (widget.fromUpload) {
      context.pushReplacement('/vault/doc/${widget.docId}');
    } else if (context.canPop()) {
      context.pop();
    } else {
      context.go('/vault/doc/${widget.docId}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final doc = _doc;
    return Scaffold(
      appBar: AppBar(title: Text(_reading ? l.vaultReading : (_found ? l.vaultCheckDetails : l.vaultAddDetails))),
      body: doc == null && !_reading
          ? EmptyState(scene: Scene.search, title: l.vaultDocMissing, actionLabel: l.documentVault, onAction: () => context.go('/me/vault'))
          : PageBody(maxWidth: 720, children: [
              const SizedBox(height: Space.md),
              if (doc != null)
                Center(
                  child: SizedBox(
                    height: 220,
                    child: DocPreview(doc: doc, petName: _pet?.name ?? '', onTap: () => openDocViewer(context, doc, _pet?.name ?? '')),
                  ),
                ),
              const SizedBox(height: Space.md),
              if (_reading) ...[
                const SizedBox(height: Space.lg),
                const Center(child: CircularProgressIndicator()),
                const SizedBox(height: Space.md),
                Text(l.vaultReading, textAlign: TextAlign.center, style: context.text.titleMedium),
              ] else
                ..._form(context),
            ]),
    );
  }

  List<Widget> _form(BuildContext context) {
    final l = context.l10n;
    final pet = _pet;
    final petOnDoc = c('petName').text.trim();
    final mismatch = _found && pet != null && petOnDoc.isNotEmpty && petOnDoc.toLowerCase() != pet.name.toLowerCase();
    Widget field(String key, String label, {TextInputType? kb, String? prefix}) =>
        PawTextField(label: label, controller: c(key), keyboardType: kb, prefixText: prefix);
    return [
      PawCard(
        color: _found ? context.paw.primaryContainer.withValues(alpha: 0.6) : null,
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(_found ? Icons.auto_awesome_rounded : Icons.edit_note_rounded, color: context.colors.primary),
          const SizedBox(width: Space.md),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(_found ? l.vaultFoundTitle : l.vaultNotFoundTitle, style: context.text.titleMedium),
              const SizedBox(height: Space.xs),
              Text(_found ? l.vaultFoundBody : l.vaultNotFoundBody, style: context.text.bodyMedium),
            ]),
          ),
        ]),
      ),
      const SizedBox(height: Space.sm),
      DemoBanner(l.vaultDemoReadNote),
      if (mismatch) ...[
        const SizedBox(height: Space.sm),
        InfoNote(l.vaultPetMismatch(petOnDoc, pet.name), tone: ChipTone.warning, icon: Icons.warning_amber_rounded),
      ],
      const SizedBox(height: Space.lg),
      DropdownButtonFormField<String>(
        initialValue: _type,
        isExpanded: true,
        decoration: InputDecoration(labelText: l.vaultFieldDocType),
        items: [
          for (final t in vaultDocTypes)
            DropdownMenuItem(
              value: t,
              child: Row(children: [
                Icon(docTypeIcon(t), size: 20),
                const SizedBox(width: Space.sm),
                Flexible(child: Text(docTypeLabel(context, t), overflow: TextOverflow.ellipsis)),
              ]),
            ),
        ],
        onChanged: (v) => setState(() => _type = v ?? 'other'),
      ),
      const SizedBox(height: Space.md),
      field('title', l.vaultFieldTitle),
      if (_found) field('petName', l.vaultFieldPetName),
      if (_type == 'vaccination') ...[
        field('vaccine', l.vaccineName),
        _DateField(label: l.dateGiven, value: _dates['dateGiven'], onChanged: (d) => setState(() => _dates['dateGiven'] = d)),
        _DateField(label: l.nextDueShort, value: _dates['nextDue'], future: true, onChanged: (d) => setState(() => _dates['nextDue'] = d)),
        field('brand', l.vaccineBrand),
        field('batch', l.batchNumber),
        field('vet', l.vetName),
        field('vetReg', l.vaultFieldVetReg),
        field('clinic', l.clinicName),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: _addToHealth,
          onChanged: (v) => setState(() => _addToHealth = v),
          title: Text(l.vaultAddToHealth(pet?.name ?? '')),
          subtitle: Text(l.vaultAddToHealthHint),
        ),
      ],
      if (_type == 'insurance') ...[
        field('insurer', l.vaultFieldInsurer),
        field('policyNo', l.vaultFieldPolicyNo),
        field('cover', l.vaultFieldCover, kb: TextInputType.number, prefix: '₹ '),
        field('premium', l.vaultFieldPremium, kb: TextInputType.number, prefix: '₹ '),
        _DateField(label: l.vaultFieldCoverStart, value: _dates['coverStart'], future: true, onChanged: (d) => setState(() => _dates['coverStart'] = d)),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: _trackInsurance,
          onChanged: (v) => setState(() => _trackInsurance = v),
          title: Text(l.vaultTrackInsurance),
        ),
      ],
      if (_type == 'lab') ...[
        field('test', l.vaultFieldTest),
        field('clinic', l.clinicName),
        field('vet', l.vetName),
      ],
      if (_type == 'invoice') ...[
        field('clinic', l.clinicName),
        field('reference', l.vaultFieldReference),
        field('amount', l.vaultFieldAmount, kb: TextInputType.number, prefix: '₹ '),
      ],
      if (_type == 'prescription') ...[
        field('vet', l.vetName),
        field('clinic', l.clinicName),
      ],
      if (const ['licence', 'adoption', 'travel', 'other'].contains(_type)) ...[
        field('issuer', l.vaultFieldIssuer),
        field('reference', l.vaultFieldReference),
      ],
      if (_type != 'vaccination' && _type != 'insurance')
        _DateField(label: l.vaultFieldIssuedOn, value: _dates['issuedOn'], onChanged: (d) => setState(() => _dates['issuedOn'] = d)),
      _DateField(
        label: _type == 'insurance' ? l.vaultFieldRenewal : l.vaultFieldExpiry,
        value: _dates['expiry'],
        future: true,
        clearLabel: l.vaultNoExpiry,
        onChanged: (d) => setState(() => _dates['expiry'] = d),
      ),
      const SizedBox(height: Space.sm),
      Text(l.vaultFieldTags, style: context.text.titleSmall),
      const SizedBox(height: Space.sm),
      Wrap(spacing: Space.xs, runSpacing: Space.xs, children: [
        for (final t in _tags)
          InputChip(
            label: Text('#$t'),
            onDeleted: () => setState(() => _tags.remove(t)),
            deleteButtonTooltipMessage: l.remove,
          ),
      ]),
      const SizedBox(height: Space.sm),
      TextField(
        controller: _tagInput,
        decoration: InputDecoration(
          labelText: l.vaultAddTag,
          hintText: l.vaultTagHint,
          suffixIcon: IconButton(tooltip: l.vaultAddTag, icon: const Icon(Icons.add_rounded), onPressed: _addTag),
        ),
        onSubmitted: (_) => _addTag(),
      ),
      if (_type != 'vaccination' && _dates['expiry'] != null) ...[
        const SizedBox(height: Space.md),
        InfoNote(l.vaultExpiryReminderNote, icon: Icons.notifications_active_outlined),
      ],
      const SizedBox(height: Space.xl),
      PrimaryButton(label: l.vaultSaveDetails, icon: Icons.check_rounded, loading: _saving, onPressed: _save),
      const SizedBox(height: Space.sm),
      TextButton(onPressed: _saving ? null : _skip, child: Text(l.vaultSkipDetails)),
    ];
  }

  void _addTag() {
    final t = cleanTags([_tagInput.text]);
    if (t.isEmpty) return;
    setState(() {
      if (!_tags.map((e) => e.toLowerCase()).contains(t.first.toLowerCase())) _tags.add(t.first);
      _tagInput.clear();
    });
  }
}

class _DateField extends StatelessWidget {
  const _DateField({required this.label, required this.value, required this.onChanged, this.future = false, this.clearLabel});
  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;
  final bool future;
  final String? clearLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.md),
      child: Row(children: [
        Expanded(
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(alignment: Alignment.centerLeft, minimumSize: const Size.fromHeight(52)),
            icon: const Icon(Icons.event_rounded),
            label: Text('$label: ${value == null ? (clearLabel ?? '–') : Fmt.date(value!, context.lang)}', overflow: TextOverflow.ellipsis),
            onPressed: () async {
              final now = DateTime.now();
              final first = DateTime(now.year - 30);
              final last = future ? DateTime(now.year + 15, 12, 31) : DateTime(now.year, now.month, now.day, 23, 59);
              var initial = value ?? (future ? now.add(const Duration(days: 365)) : now);
              if (initial.isBefore(first)) initial = first;
              if (initial.isAfter(last)) initial = last;
              final d = await showDatePicker(context: context, firstDate: first, lastDate: last, initialDate: initial);
              if (d != null) onChanged(d);
            },
          ),
        ),
        if (value != null && clearLabel != null)
          IconButton(tooltip: clearLabel, icon: const Icon(Icons.close_rounded), onPressed: () => onChanged(null)),
      ]),
    );
  }
}
