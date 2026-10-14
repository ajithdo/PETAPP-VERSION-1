import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../core/services/service_providers.dart';
import '../../../core/settings/settings_controller.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/photo_picker.dart';
import '../../../core/widgets/widgets.dart';
import '../../plans/presentation/plus_prompt.dart';
import '../data/pets_repository.dart';
import '../domain/breeds.dart';
import '../domain/pet.dart';
import 'breed_picker.dart';
import 'pet_labels.dart';

/// Add or edit a pet in 2 short steps (spec 7.1). Only name and species are
/// required; everything else can wait.
class PetFormScreen extends ConsumerStatefulWidget {
  const PetFormScreen({super.key, this.petId});
  final String? petId;
  @override
  ConsumerState<PetFormScreen> createState() => _PetFormScreenState();
}

class _PetFormScreenState extends ConsumerState<PetFormScreen> {
  final _form1 = GlobalKey<FormState>();
  int _step = 0;
  bool _loaded = false;
  bool _busy = false;
  Pet? _original;

  final _name = TextEditingController();
  String _species = 'dog';
  String? _breedId;
  String? _breedOther;
  String _color = 'amber';
  Uint8List? _photo;
  String? _photoUrl;

  bool _useApprox = false;
  DateTime? _birthday;
  int _approxYears = 1;
  int _approxMonths = 0;
  String? _gender;
  final _weight = TextEditingController();

  final _markings = TextEditingController();
  final _microchip = TextEditingController();
  bool _neutered = false;
  final _allergies = TextEditingController();
  final _diet = TextEditingController();
  final _temperament = TextEditingController();
  String? _clinicId;

  @override
  void dispose() {
    for (final c in [_name, _weight, _markings, _microchip, _allergies, _diet, _temperament]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    if (_loaded) return;
    _loaded = true;
    if (widget.petId == null) return;
    final p = await ref.read(petsRepositoryProvider).getPet(widget.petId!);
    if (p == null || !mounted) return;
    setState(() {
      _original = p;
      _name.text = p.name;
      _species = p.species;
      _breedId = p.breedId;
      _breedOther = p.breedOther;
      _color = p.colorTag;
      _photoUrl = p.photoUrl;
      _birthday = p.birthday;
      _gender = p.gender;
      if (p.weightKg != null) {
        _weight.text = p.isBird ? (p.weightKg! * 1000).round().toString() : p.weightKg!.toString();
      }
      _markings.text = p.markings ?? '';
      _microchip.text = p.microchip ?? '';
      _neutered = p.neutered;
      _allergies.text = p.allergies.join(', ');
      _diet.text = p.dietType ?? '';
      _temperament.text = p.temperament ?? '';
      _clinicId = p.clinicId;
    });
  }

  bool get _isEdit => widget.petId != null;

  DateTime? get _effectiveBirthday {
    if (!_useApprox) return _birthday;
    final now = DateTime.now();
    return DateTime(now.year - _approxYears, now.month - _approxMonths, 1);
  }

  Future<void> _next() async {
    if (!(_form1.currentState?.validate() ?? false)) return;
    if (!_isEdit) {
      final limit = (ref.read(planLimitsProvider)['pets'] as num?)?.toInt() ?? 3;
      final user = ref.read(currentUserProvider)!;
      final owned = ref.read(activePetsProvider).where((p) => p.ownerId == user.uid).length;
      if (owned >= limit) {
        final l = context.l10n;
        await showPlusPrompt(context, title: l.petLimitTitle(limit), body: l.petLimitBody);
        return;
      }
    }
    setState(() => _step = 1);
  }

  Future<void> _save() async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;
    setState(() => _busy = true);
    try {
      var photoUrl = _photoUrl;
      if (_photo != null) {
        photoUrl = await ref.read(storageServiceProvider).upload(_photo!,
            path: 'users/${user.uid}/pets/${DateTime.now().millisecondsSinceEpoch}.png', contentType: 'image/png');
      }
      final w = double.tryParse(_weight.text.replaceAll(',', '.'));
      final weightKg = w == null ? null : (_species == 'bird' ? w / 1000 : w);
      final allergies = _allergies.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
      final fields = <String, dynamic>{
        'name': _name.text.trim(),
        'species': _species,
        'breedId': _breedId,
        'breedOther': _breedOther,
        'colorTag': _color,
        'photoUrl': photoUrl,
        'birthday': _effectiveBirthday,
        'gender': _gender,
        'weightKg': weightKg,
        'markings': _markings.text.trim().isEmpty ? null : _markings.text.trim(),
        'microchip': _microchip.text.trim().isEmpty ? null : _microchip.text.trim(),
        'neutered': _neutered,
        'allergies': allergies,
        'dietType': _diet.text.trim().isEmpty ? null : _diet.text.trim(),
        'temperament': _temperament.text.trim().isEmpty ? null : _temperament.text.trim(),
        'clinicId': _clinicId,
      };
      final repo = ref.read(petsRepositoryProvider);
      if (_isEdit) {
        await repo.updatePet(widget.petId!, fields);
        if (weightKg != null && weightKg != _original?.weightKg) {
          await repo.logWeight(widget.petId!, weightKg, user.uid, user.name);
        }
        if (mounted) context.pop();
      } else {
        final defaults = switch (_species) {
          'dog' => const DailyPlan(walks: 2, meals: 2, playMinutes: 30),
          'cat' => const DailyPlan(walks: 0, meals: 3, playMinutes: 20),
          'bird' => const DailyPlan(walks: 0, meals: 2, playMinutes: 30),
          _ => const DailyPlan(walks: 0, meals: 2, playMinutes: 60),
        };
        final pet = Pet.fromJson({...fields, 'ownerId': user.uid, 'dailyPlan': defaults.toJson()});
        final id = await repo.addPet(pet, ownerName: user.name);
        if (weightKg != null) await repo.logWeight(id, weightKg, user.uid, user.name);
        ref.read(settingsProvider.notifier).selectPet(id);
        if (mounted) {
          showToast(context, context.l10n.petAdded(_name.text.trim()));
          context.pushReplacement('/pets/$id');
        }
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    _load();
    final l = context.l10n;
    return PopScope(
      canPop: _step == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) setState(() => _step = 0);
      },
      child: Scaffold(
        appBar: AppBar(title: Text(_isEdit ? l.editPet : l.addPet)),
        body: SafeArea(
          child: Column(children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.gutter),
              child: Semantics(
                label: l.stepOf(_step + 1, 2),
                child: LinearProgressIndicator(value: (_step + 1) / 2, minHeight: 6, borderRadius: BorderRadius.circular(3)),
              ),
            ),
            Expanded(
              child: PageBody(maxWidth: 640, children: [
                const SizedBox(height: Space.lg),
                if (_step == 0) ..._basics(context) else ..._about(context),
              ]),
            ),
            Padding(
              padding: EdgeInsets.all(context.gutter),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Row(children: [
                  if (_step == 1) ...[
                    Expanded(child: SecondaryButton(label: l.back, onPressed: () => setState(() => _step = 0))),
                    const SizedBox(width: Space.md),
                  ],
                  Expanded(
                    flex: 2,
                    child: PrimaryButton(
                      label: _step == 0 ? l.next : (_isEdit ? l.saveChanges : l.addPet),
                      loading: _busy,
                      onPressed: _step == 0 ? _next : _save,
                    ),
                  ),
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  List<Widget> _basics(BuildContext context) {
    final l = context.l10n;
    final species = speciesFromName(_species);
    final breedText = _breedId == null
        ? l.chooseBreed
        : (_breedId == mixedBreedId
            ? l.breedMixed
            : (_breedId == otherBreedId ? (_breedOther ?? '') : breedById[_breedId]?.name(context.lang) ?? ''));
    return [
      Text(l.petBasicsTitle, style: context.text.titleLarge),
      const SizedBox(height: Space.lg),
      Center(
        child: Stack(children: [
          _photo != null
              ? ClipOval(child: Image.memory(_photo!, width: 112, height: 112, fit: BoxFit.cover))
              : PetAvatar(species: _species, colorTag: _color, photoUrl: _photoUrl, size: 112),
          Positioned(
            right: 0,
            bottom: 0,
            child: IconButton.filled(
              tooltip: l.addPhoto,
              onPressed: () async {
                final bytes = await pickSquarePhoto(context);
                if (bytes != null) setState(() => _photo = bytes);
              },
              icon: const Icon(Icons.photo_camera_rounded),
            ),
          ),
        ]),
      ),
      const SizedBox(height: Space.xl),
      Form(
        key: _form1,
        child: PawTextField(
          label: l.petName,
          controller: _name,
          prefixIcon: Icons.pets_rounded,
          autofocus: !_isEdit,
          textInputAction: TextInputAction.next,
          validator: (v) => (v == null || v.trim().isEmpty) ? l.fieldRequired : null,
        ),
      ),
      Text(l.species, style: context.text.titleSmall),
      const SizedBox(height: Space.sm),
      ChoiceRow<String>(
        options: const ['dog', 'cat', 'bird', 'rabbit'],
        selected: _species,
        icons: speciesIcon,
        label: (s) => speciesLabel(context, s),
        onSelected: (s) => setState(() {
          if (s != _species) {
            _breedId = null;
            _breedOther = null;
          }
          _species = s;
        }),
      ),
      const SizedBox(height: Space.lg),
      Text(l.breed, style: context.text.titleSmall),
      const SizedBox(height: Space.sm),
      OutlinedButton.icon(
        style: OutlinedButton.styleFrom(alignment: Alignment.centerLeft, minimumSize: const Size.fromHeight(52)),
        onPressed: () async {
          final b = await pickBreed(context, species);
          if (b != null) {
            setState(() {
              _breedId = b.id;
              _breedOther = b.other;
            });
          }
        },
        icon: const Icon(Icons.search_rounded),
        label: Text(breedText, overflow: TextOverflow.ellipsis),
      ),
      if (_species == 'bird') ...[
        const SizedBox(height: Space.md),
        InfoNote(l.birdLegalNote, icon: Icons.gavel_rounded),
      ],
      const SizedBox(height: Space.lg),
      Text(l.colourTag, style: context.text.titleSmall),
      const SizedBox(height: 2),
      Text(l.colourTagHint, style: context.text.bodySmall),
      const SizedBox(height: Space.sm),
      Wrap(spacing: Space.md, runSpacing: Space.md, children: [
        for (final e in PetTagColors.all.entries)
          Semantics(
            button: true,
            selected: e.key == _color,
            label: colourName(context, e.key),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => setState(() => _color = e.key),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: e.value,
                  shape: BoxShape.circle,
                  border: Border.all(color: e.key == _color ? context.paw.textPrimary : Colors.transparent, width: 3),
                ),
                child: e.key == _color ? const Icon(Icons.check_rounded, color: Colors.white) : null,
              ),
            ),
          ),
      ]),
    ];
  }

  List<Widget> _about(BuildContext context) {
    final l = context.l10n;
    final clinics = ref.watch(_clinicNamesProvider).value ?? const <(String, String)>[];
    return [
      Text(l.petAboutTitle(_name.text.trim()), style: context.text.titleLarge),
      const SizedBox(height: 2),
      Text(l.petAboutSubtitle, style: context.text.bodySmall),
      const SizedBox(height: Space.lg),
      Text(l.birthday, style: context.text.titleSmall),
      const SizedBox(height: Space.sm),
      SegmentedButton<bool>(
        segments: [
          ButtonSegment(value: false, label: Text(l.exactDate), icon: const Icon(Icons.cake_rounded)),
          ButtonSegment(value: true, label: Text(l.approxAge), icon: const Icon(Icons.timelapse_rounded)),
        ],
        selected: {_useApprox},
        onSelectionChanged: (s) => setState(() => _useApprox = s.first),
      ),
      const SizedBox(height: Space.md),
      if (!_useApprox)
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(alignment: Alignment.centerLeft, minimumSize: const Size.fromHeight(52)),
          icon: const Icon(Icons.calendar_today_rounded),
          label: Text(_birthday == null ? l.chooseDate : Fmt.date(_birthday!, context.lang)),
          onPressed: () async {
            final d = await showDatePicker(
              context: context,
              firstDate: DateTime(1990),
              lastDate: DateTime.now(),
              initialDate: _birthday ?? DateTime.now().subtract(const Duration(days: 365)),
            );
            if (d != null) setState(() => _birthday = d);
          },
        )
      else
        Row(children: [
          Expanded(
            child: DropdownButtonFormField<int>(
              initialValue: _approxYears,
              decoration: InputDecoration(labelText: l.years),
              items: [for (var i = 0; i <= 25; i++) DropdownMenuItem(value: i, child: Text('$i'))],
              onChanged: (v) => setState(() => _approxYears = v ?? 0),
            ),
          ),
          const SizedBox(width: Space.md),
          Expanded(
            child: DropdownButtonFormField<int>(
              initialValue: _approxMonths,
              decoration: InputDecoration(labelText: l.months),
              items: [for (var i = 0; i <= 11; i++) DropdownMenuItem(value: i, child: Text('$i'))],
              onChanged: (v) => setState(() => _approxMonths = v ?? 0),
            ),
          ),
        ]),
      const SizedBox(height: Space.lg),
      Text(l.gender, style: context.text.titleSmall),
      const SizedBox(height: Space.sm),
      ChoiceRow<String>(
        options: const ['male', 'female', 'unknown'],
        selected: _gender,
        label: (g) => genderLabel(context, g),
        onSelected: (g) => setState(() => _gender = g),
      ),
      const SizedBox(height: Space.lg),
      PawTextField(
        label: _species == 'bird' ? l.weightGrams : l.weightKg,
        controller: _weight,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
        prefixIcon: Icons.monitor_weight_rounded,
      ),
      Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          title: Text(l.moreDetails, style: context.text.titleSmall),
          subtitle: Text(l.moreDetailsHint, style: context.text.bodySmall),
          childrenPadding: const EdgeInsets.only(top: Space.sm),
          children: [
            PawTextField(label: l.markings, controller: _markings),
            PawTextField(label: l.microchip, controller: _microchip),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _neutered,
              onChanged: (v) => setState(() => _neutered = v),
              title: Text(l.neutered),
            ),
            PawTextField(label: l.allergies, controller: _allergies, helper: l.allergiesHint),
            PawTextField(label: l.dietType, controller: _diet),
            DropdownButtonFormField<String?>(
              initialValue: clinics.any((c) => c.$1 == _clinicId) ? _clinicId : null,
              isExpanded: true,
              decoration: InputDecoration(labelText: l.regularClinic),
              items: [
                DropdownMenuItem<String?>(value: null, child: Text(l.none)),
                for (final c in clinics) DropdownMenuItem(value: c.$1, child: Text(c.$2, overflow: TextOverflow.ellipsis)),
              ],
              onChanged: (v) => setState(() => _clinicId = v),
            ),
            const SizedBox(height: Space.md),
            PawTextField(label: l.temperament, controller: _temperament, maxLines: 3),
            InfoNote(l.insuranceInVault),
          ],
        ),
      ),
    ];
  }
}

String colourName(BuildContext context, String key) {
  final l = context.l10n;
  return switch (key) {
    'lavender' => l.colourLavender,
    'sky' => l.colourSky,
    'rose' => l.colourRose,
    'mint' => l.colourMint,
    'sand' => l.colourSand,
    _ => l.colourAmber,
  };
}

final _clinicNamesProvider = FutureProvider<List<(String, String)>>((ref) async {
  final snap = await ref.watch(firestoreProvider).collection('clinics').where('status', isEqualTo: 'approved').get();
  return [for (final d in snap.docs) (d.id, '${d.data()['name']} · ${d.data()['area']}')]..sort((a, b) => a.$2.compareTo(b.$2));
});
