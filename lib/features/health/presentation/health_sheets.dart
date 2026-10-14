import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/providers.dart';
import '../../../core/services/service_providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/photo_picker.dart';
import '../../../core/widgets/widgets.dart';
import '../../pets/domain/pet.dart';
import '../data/health_repository.dart';
import '../domain/vaccine_schedule.dart';
import 'health_labels.dart';

Future<T?> _sheet<T>(BuildContext context, Widget child) => showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: const BoxConstraints(maxWidth: 640),
      builder: (_) => child,
    );

class _SheetFrame extends StatelessWidget {
  const _SheetFrame({required this.title, required this.children});
  final String title;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(Space.lg, 0, Space.lg, Space.xl + MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(title, style: context.text.titleMedium),
          const SizedBox(height: Space.md),
          ...children,
        ]),
      ),
    );
  }
}

class _DateButton extends StatelessWidget {
  const _DateButton({required this.date, required this.onChanged, this.withTime = false, this.future = false});
  final DateTime date;
  final ValueChanged<DateTime> onChanged;
  final bool withTime;
  final bool future;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(alignment: Alignment.centerLeft),
      icon: const Icon(Icons.event_rounded),
      label: Text(withTime ? Fmt.dateTime(date, context.lang) : Fmt.date(date, context.lang)),
      onPressed: () async {
        final now = DateTime.now();
        final d = await showDatePicker(
          context: context,
          firstDate: DateTime(2000),
          lastDate: future ? now.add(const Duration(days: 3650)) : now,
          initialDate: date,
        );
        if (d == null) return;
        var out = DateTime(d.year, d.month, d.day, date.hour, date.minute);
        if (withTime && context.mounted) {
          final t = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(date));
          if (t != null) out = DateTime(d.year, d.month, d.day, t.hour, t.minute);
        }
        onChanged(out);
      },
    );
  }
}

/// Record a vaccine: brand, batch, vet, clinic, date and certificate photo.
Future<void> showVaccineSheet(BuildContext context, Pet pet, {DoseTemplate? template}) =>
    _sheet(context, _VaccineSheet(pet: pet, template: template));

class _VaccineSheet extends ConsumerStatefulWidget {
  const _VaccineSheet({required this.pet, this.template});
  final Pet pet;
  final DoseTemplate? template;
  @override
  ConsumerState<_VaccineSheet> createState() => _VaccineSheetState();
}

class _VaccineSheetState extends ConsumerState<_VaccineSheet> {
  late String _key = widget.template?.key ?? (templatesFor(widget.pet.speciesEnum).firstOrNull?.key ?? 'other');
  final _otherName = TextEditingController();
  final _brand = TextEditingController();
  final _batch = TextEditingController();
  final _vet = TextEditingController();
  final _clinic = TextEditingController();
  DateTime _date = DateTime.now();
  String? _certUrl;
  bool _busy = false;

  @override
  void dispose() {
    for (final c in [_otherName, _brand, _batch, _vet, _clinic]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final templates = templatesFor(widget.pet.speciesEnum);
    return _SheetFrame(title: l.recordVaccineFor(widget.pet.name), children: [
      DropdownButtonFormField<String>(
        initialValue: _key,
        isExpanded: true,
        decoration: InputDecoration(labelText: l.vaccine),
        items: [
          for (final t in templates)
            DropdownMenuItem(value: t.key, child: Text('${t.name} · ${doseLabel(context, t.doseLabel)}', overflow: TextOverflow.ellipsis)),
          DropdownMenuItem(value: 'other', child: Text(l.otherVaccine)),
        ],
        onChanged: (v) => setState(() => _key = v ?? 'other'),
      ),
      const SizedBox(height: Space.md),
      if (_key == 'other') PawTextField(label: l.vaccineName, controller: _otherName),
      Text(l.dateGiven, style: context.text.titleSmall),
      const SizedBox(height: Space.sm),
      _DateButton(date: _date, onChanged: (d) => setState(() => _date = d)),
      const SizedBox(height: Space.md),
      PawTextField(label: l.vaccineBrand, controller: _brand),
      PawTextField(label: l.batchNumber, controller: _batch),
      PawTextField(label: l.vetName, controller: _vet),
      PawTextField(label: l.clinicName, controller: _clinic),
      Row(children: [
        if (_certUrl != null)
          Padding(
            padding: const EdgeInsets.only(right: Space.md),
            child: ClipRRect(borderRadius: BorderRadius.circular(8), child: MediaImage(url: _certUrl!, width: 56, height: 56)),
          ),
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.document_scanner_rounded),
            label: Text(_certUrl == null ? l.attachCertificate : l.certificateAttached),
            onPressed: () async {
              final p = await pickImage(context, ImageSource.gallery);
              if (p == null) return;
              final uid = ref.read(currentUserProvider)!.uid;
              final url = await ref.read(storageServiceProvider).upload(p.bytes,
                  path: 'users/$uid/vault/${DateTime.now().millisecondsSinceEpoch}.jpg', contentType: 'image/jpeg');
              setState(() => _certUrl = url);
            },
          ),
        ),
      ]),
      const SizedBox(height: Space.md),
      InfoNote(l.indicativeNote),
      const SizedBox(height: Space.md),
      PrimaryButton(
        label: l.markDone,
        loading: _busy,
        onPressed: () async {
          final t = templates.where((t) => t.key == _key).firstOrNull;
          final name = t?.name ?? _otherName.text.trim();
          if (name.isEmpty) {
            showToast(context, l.fieldRequired);
            return;
          }
          setState(() => _busy = true);
          await ref.read(healthRepositoryProvider).recordVaccine(
                pet: widget.pet,
                by: ref.read(currentUserProvider)!,
                templateKey: _key,
                name: name,
                givenDate: _date,
                brand: _brand.text.trim().isEmpty ? null : _brand.text.trim(),
                batch: _batch.text.trim().isEmpty ? null : _batch.text.trim(),
                vetName: _vet.text.trim().isEmpty ? null : _vet.text.trim(),
                clinicName: _clinic.text.trim().isEmpty ? null : _clinic.text.trim(),
                certificateUrl: _certUrl,
              );
          if (context.mounted) {
            Navigator.pop(context);
            showToast(context, l.vaccineRecorded(name, widget.pet.name));
          }
        },
      ),
    ]);
  }
}

/// Add or edit a medicine.
Future<void> showMedicineSheet(BuildContext context, Pet pet, {Medicine? existing}) =>
    _sheet(context, _MedicineSheet(pet: pet, existing: existing));

class _MedicineSheet extends ConsumerStatefulWidget {
  const _MedicineSheet({required this.pet, this.existing});
  final Pet pet;
  final Medicine? existing;
  @override
  ConsumerState<_MedicineSheet> createState() => _MedicineSheetState();
}

class _MedicineSheetState extends ConsumerState<_MedicineSheet> {
  late final _name = TextEditingController(text: widget.existing?.name);
  late final _dose = TextEditingController(text: widget.existing?.dose);
  late final _stock = TextEditingController(text: widget.existing?.stock?.toString());
  late String _unit = widget.existing?.unit.isNotEmpty == true ? widget.existing!.unit : 'tablet';
  late String _freq = widget.existing?.frequency ?? 'once';
  late List<TimeOfDay> _times = (widget.existing?.times ?? const ['09:00']).map((t) {
    final p = t.split(':');
    return TimeOfDay(hour: int.parse(p[0]), minute: int.parse(p[1]));
  }).toList();
  late int _everyHours = (widget.existing?.raw['everyHours'] as num?)?.toInt() ?? 8;
  late bool _withFood = widget.existing?.withFood ?? true;
  late DateTime _start = widget.existing?.start ?? DateTime.now();
  late DateTime? _end = widget.existing?.end;
  bool _busy = false;

  @override
  void dispose() {
    _name.dispose();
    _dose.dispose();
    _stock.dispose();
    super.dispose();
  }

  String _fmt(TimeOfDay t) => '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final needed = switch (_freq) { 'twice' => 2, _ => 1 };
    while (_times.length < needed) {
      _times = [..._times, const TimeOfDay(hour: 20, minute: 0)];
    }
    final shown = _freq == 'custom' ? _times : _times.take(needed).toList();
    return _SheetFrame(title: widget.existing == null ? l.addMedicineFor(widget.pet.name) : l.editMedicine, children: [
      PawTextField(label: l.medicineName, controller: _name, autofocus: widget.existing == null),
      Row(children: [
        Expanded(child: PawTextField(label: l.dose, controller: _dose, keyboardType: const TextInputType.numberWithOptions(decimal: true))),
        const SizedBox(width: Space.md),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: Space.md),
            child: DropdownButtonFormField<String>(
              initialValue: _unit,
              decoration: InputDecoration(labelText: l.unit),
              items: [
                for (final u in const ['tablet', 'ml', 'drops', 'mg', 'capsule', 'sachet'])
                  DropdownMenuItem(value: u, child: Text(unitLabel(context, u))),
              ],
              onChanged: (v) => setState(() => _unit = v ?? 'tablet'),
            ),
          ),
        ),
      ]),
      DropdownButtonFormField<String>(
        initialValue: _freq,
        decoration: InputDecoration(labelText: l.frequency),
        items: [
          DropdownMenuItem(value: 'once', child: Text(l.freqOnce)),
          DropdownMenuItem(value: 'twice', child: Text(l.freqTwice)),
          DropdownMenuItem(value: 'every_x_hours', child: Text(l.freqEveryHours(_everyHours))),
          DropdownMenuItem(value: 'weekly', child: Text(l.freqWeekly)),
          DropdownMenuItem(value: 'custom', child: Text(l.freqCustom)),
        ],
        onChanged: (v) => setState(() => _freq = v ?? 'once'),
      ),
      const SizedBox(height: Space.md),
      if (_freq == 'every_x_hours')
        Slider(
          value: _everyHours.toDouble(),
          min: 2,
          max: 24,
          divisions: 22,
          label: l.freqEveryHours(_everyHours),
          onChanged: (v) => setState(() => _everyHours = v.round()),
        ),
      Text(_freq == 'every_x_hours' ? l.firstDoseAt : l.doseTimes, style: context.text.titleSmall),
      const SizedBox(height: Space.sm),
      Wrap(spacing: Space.sm, runSpacing: Space.sm, children: [
        for (var i = 0; i < shown.length; i++)
          InputChip(
            label: Text(Fmt.time(DateTime(2000, 1, 1, shown[i].hour, shown[i].minute), context.lang)),
            avatar: const Icon(Icons.schedule_rounded, size: 18),
            onPressed: () async {
              final t = await showTimePicker(context: context, initialTime: shown[i]);
              if (t != null) setState(() => _times[i] = t);
            },
            onDeleted: _freq == 'custom' && shown.length > 1 ? () => setState(() => _times.removeAt(i)) : null,
          ),
        if (_freq == 'custom')
          ActionChip(
            avatar: const Icon(Icons.add_rounded, size: 18),
            label: Text(l.addTime),
            onPressed: () => setState(() => _times = [..._times, const TimeOfDay(hour: 14, minute: 0)]),
          ),
      ]),
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        value: _withFood,
        onChanged: (v) => setState(() => _withFood = v),
        title: Text(l.withFood),
      ),
      Text(l.startDate, style: context.text.titleSmall),
      const SizedBox(height: Space.sm),
      _DateButton(date: _start, future: true, onChanged: (d) => setState(() => _start = d)),
      const SizedBox(height: Space.sm),
      Row(children: [
        Expanded(child: Text(_end == null ? l.noEndDate : l.endsOn(Fmt.date(_end!, context.lang)), style: context.text.bodyMedium)),
        TextButton(
          onPressed: () async {
            final d = await showDatePicker(
                context: context, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 730)), initialDate: _end ?? DateTime.now().add(const Duration(days: 7)));
            setState(() => _end = d);
          },
          child: Text(l.setEndDate),
        ),
      ]),
      PawTextField(
        label: l.stockCount,
        controller: _stock,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        helper: l.stockHint,
      ),
      PrimaryButton(
        label: l.save,
        loading: _busy,
        onPressed: () async {
          if (_name.text.trim().isEmpty) {
            showToast(context, l.fieldRequired);
            return;
          }
          setState(() => _busy = true);
          await ref.read(healthRepositoryProvider).saveMedicine(widget.existing?.id, {
            'petId': widget.pet.id,
            'name': _name.text.trim(),
            'dose': _dose.text.trim(),
            'unit': _unit,
            'frequency': _freq,
            'everyHours': _everyHours,
            'times': [for (final t in shown) _fmt(t)],
            'weekdays': _freq == 'custom' ? [1, 2, 3, 4, 5, 6, 7] : <int>[],
            'withFood': _withFood,
            'startDate': DateTime(_start.year, _start.month, _start.day),
            'endDate': _end,
            'stock': int.tryParse(_stock.text.trim()),
            'refillAt': 5,
          });
          if (context.mounted) {
            Navigator.pop(context);
            showToast(context, l.medicineSaved(_name.text.trim()));
          }
        },
      ),
    ]);
  }
}

String unitLabel(BuildContext context, String u) {
  final l = context.l10n;
  return switch (u) {
    'ml' => l.unitMl,
    'drops' => l.unitDrops,
    'mg' => l.unitMg,
    'capsule' => l.unitCapsule,
    'sachet' => l.unitSachet,
    _ => l.unitTablet,
  };
}

/// Deworming, flea/tick, vet visit or symptom entry.
Future<void> showEventSheet(BuildContext context, Pet pet, String type) => _sheet(context, _EventSheet(pet: pet, type: type));

class _EventSheet extends ConsumerStatefulWidget {
  const _EventSheet({required this.pet, required this.type});
  final Pet pet;
  final String type;
  @override
  ConsumerState<_EventSheet> createState() => _EventSheetState();
}

class _EventSheetState extends ConsumerState<_EventSheet> {
  DateTime _date = DateTime.now();
  final _title = TextEditingController();
  final _notes = TextEditingController();
  final _clinic = TextEditingController();
  final _diagnosis = TextEditingController();
  String _symptom = 'vomiting';
  int _severity = 1;
  final _photos = <String>[];
  bool _busy = false;

  @override
  void dispose() {
    for (final c in [_title, _notes, _clinic, _diagnosis]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = widget.type;
    final title = switch (t) {
      'deworming' => l.deworming,
      'flea_tick' => l.fleaTick,
      'vet_visit' => l.vetVisit,
      _ => l.symptom,
    };
    return _SheetFrame(title: '$title · ${widget.pet.name}', children: [
      _DateButton(date: _date, withTime: t == 'symptom', onChanged: (d) => setState(() => _date = d)),
      const SizedBox(height: Space.md),
      if (t == 'deworming' || t == 'flea_tick') PawTextField(label: l.productUsed, controller: _title),
      if (t == 'vet_visit') ...[
        PawTextField(label: l.clinicName, controller: _clinic),
        PawTextField(label: l.reasonForVisit, controller: _title),
        PawTextField(label: l.diagnosis, controller: _diagnosis, maxLines: 2),
      ],
      if (t == 'symptom') ...[
        Wrap(spacing: Space.sm, runSpacing: Space.sm, children: [
          for (final s in symptoms)
            ChoiceChip(label: Text(symptomLabel(context, s)), selected: _symptom == s, onSelected: (_) => setState(() => _symptom = s)),
        ]),
        const SizedBox(height: Space.md),
        Text(l.severity, style: context.text.titleSmall),
        SegmentedButton<int>(
          segments: [
            ButtonSegment(value: 1, label: Text(l.intensityMild)),
            ButtonSegment(value: 2, label: Text(l.intensityModerate)),
            ButtonSegment(value: 3, label: Text(l.intensityStrong)),
          ],
          selected: {_severity},
          onSelectionChanged: (s) => setState(() => _severity = s.first),
        ),
        const SizedBox(height: Space.md),
        if (_severity == 3) ...[
          InfoNote(l.severeSymptomNote, icon: Icons.emergency_rounded, tone: ChipTone.error),
          const SizedBox(height: Space.md),
        ],
      ],
      PawTextField(label: l.noteOptional, controller: _notes, maxLines: 3),
      if (t == 'symptom' || t == 'vet_visit')
        Wrap(spacing: Space.sm, children: [
          for (final p in _photos) ClipRRect(borderRadius: BorderRadius.circular(8), child: MediaImage(url: p, width: 56, height: 56)),
          ActionChip(
            avatar: const Icon(Icons.add_a_photo_rounded, size: 18),
            label: Text(l.addPhoto),
            onPressed: () async {
              final p = await pickImage(context, ImageSource.gallery);
              if (p == null) return;
              final uid = ref.read(currentUserProvider)!.uid;
              final url = await ref.read(storageServiceProvider).upload(p.bytes,
                  path: 'users/$uid/health/${DateTime.now().millisecondsSinceEpoch}.jpg', contentType: 'image/jpeg');
              setState(() => _photos.add(url));
            },
          ),
        ]),
      const SizedBox(height: Space.md),
      PrimaryButton(
        label: l.save,
        loading: _busy,
        onPressed: () async {
          setState(() => _busy = true);
          await ref.read(healthRepositoryProvider).addEvent({
            'petId': widget.pet.id,
            'type': t,
            'date': _date,
            'title': _title.text.trim().isEmpty ? title : _title.text.trim(),
            'notes': _notes.text.trim(),
            if (t == 'vet_visit') 'clinicName': _clinic.text.trim(),
            if (t == 'vet_visit') 'diagnosis': _diagnosis.text.trim(),
            if (t == 'symptom') 'symptom': _symptom,
            if (t == 'symptom') 'severity': _severity,
            'photos': _photos,
            'byUid': ref.read(currentUserProvider)!.uid,
          });
          if (context.mounted) {
            Navigator.pop(context);
            showToast(context, l.savedFor(title, widget.pet.name));
          }
        },
      ),
    ]);
  }
}

/// Custom reminder: licence or insurance renewal, grooming, nail trim,
/// birthday or anything else.
Future<void> showReminderSheet(BuildContext context, Pet pet) => _sheet(context, _ReminderSheet(pet: pet));

class _ReminderSheet extends ConsumerStatefulWidget {
  const _ReminderSheet({required this.pet});
  final Pet pet;
  @override
  ConsumerState<_ReminderSheet> createState() => _ReminderSheetState();
}

class _ReminderSheetState extends ConsumerState<_ReminderSheet> {
  String _type = 'grooming';
  final _title = TextEditingController();
  DateTime _at = DateTime.now().add(const Duration(days: 7));
  String _repeat = 'none';

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final types = {
      'licence': l.remTypeLicence,
      'insurance': l.remTypeInsurance,
      'grooming': l.remTypeGrooming,
      'nail_trim': l.remTypeNailTrim,
      'birthday': l.remTypeBirthday,
      'custom': l.remTypeCustom,
    };
    return _SheetFrame(title: l.newReminderFor(widget.pet.name), children: [
      Wrap(spacing: Space.sm, runSpacing: Space.sm, children: [
        for (final e in types.entries)
          ChoiceChip(label: Text(e.value), selected: _type == e.key, onSelected: (_) => setState(() => _type = e.key)),
      ]),
      const SizedBox(height: Space.md),
      if (_type == 'custom') PawTextField(label: l.reminderTitle, controller: _title),
      _DateButton(date: _at, withTime: true, future: true, onChanged: (d) => setState(() => _at = d)),
      const SizedBox(height: Space.md),
      DropdownButtonFormField<String>(
        initialValue: _repeat,
        decoration: InputDecoration(labelText: l.repeat),
        items: [
          DropdownMenuItem(value: 'none', child: Text(l.repeatNone)),
          DropdownMenuItem(value: 'monthly', child: Text(l.repeatMonthly)),
          DropdownMenuItem(value: 'yearly', child: Text(l.repeatYearly)),
        ],
        onChanged: (v) => setState(() => _repeat = v ?? 'none'),
      ),
      const SizedBox(height: Space.lg),
      PrimaryButton(
        label: l.save,
        onPressed: () async {
          final title = _type == 'custom' ? _title.text.trim() : '${types[_type]} · ${widget.pet.name}';
          if (title.isEmpty) return;
          await ref.read(healthRepositoryProvider).addReminder({
            'ownerId': ref.read(currentUserProvider)!.uid,
            'petId': widget.pet.id,
            'type': _type,
            'title': title,
            'at': _at,
            'repeat': _repeat,
            'done': false,
          });
          if (context.mounted) {
            Navigator.pop(context);
            showToast(context, l.reminderSet);
          }
        },
      ),
    ]);
  }
}
