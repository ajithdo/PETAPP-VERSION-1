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
import '../../../core/theme/ph.dart';

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
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: Space.formWidth),
                child: Semantics(
                  label: l.stepOf(_step + 1, 2),
                  excludeSemantics: true,
                  child: Row(children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: (_step + 1) / 2,
                        minHeight: Sizes.progressBar,
                        borderRadius: BorderRadius.circular(Radii.xs),
                      ),
                    ),
                    const SizedBox(width: Space.md),
                    Text(l.stepOf(_step + 1, 2), style: context.text.labelMedium?.copyWith(color: context.paw.textSecondary)),
                  ]),
                ),
              ),
            ),
            Expanded(
              child: PageBody(maxWidth: Space.formWidth, children: [
                const SizedBox(height: Space.lg),
                // UI Design 2: the whole step sits in one white card.
                PawCard(
                  padding: EdgeInsets.all(context.isPhone ? Space.lg : Space.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _step == 0 ? _basics(context) : _about(context),
                  ),
                ),
                const SizedBox(height: Space.lg),
              ]),
            ),
            Padding(
              padding: EdgeInsets.all(context.gutter),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: Space.formWidth),
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
              ? ClipOval(child: Image.memory(_photo!, width: Sizes.formAvatar, height: Sizes.formAvatar, fit: BoxFit.cover, semanticLabel: context.l10n.vaultPhoto))
              : PetAvatar(species: _species, colorTag: _color, photoUrl: _photoUrl, size: Sizes.formAvatar),
          Positioned(
            right: 0,
            bottom: 0,
            child: IconButton.filled(
              tooltip: l.addPhoto,
              onPressed: () async {
                final bytes = await pickSquarePhoto(context);
                if (bytes != null) setState(() => _photo = bytes);
              },
              icon: const Icon(Ph.camera),
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
          prefixIcon: Ph.pawPrint,
          autofocus: !_isEdit,
          textInputAction: TextInputAction.next,
          validator: (v) => (v == null || v.trim().isEmpty) ? l.fieldRequired : null,
        ),
      ),
      FieldLabel(l.species),
      ChoiceTiles<String>(
        options: const ['dog', 'cat', 'bird', 'rabbit'],
        selected: _species,
        icon: speciesIcon,
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
      PawPickerField(
        label: l.breed,
        value: _breedId == null ? null : breedText,
        placeholder: l.chooseBreed,
        icon: Ph.magnifyingGlass,
        onTap: () async {
          final b = await pickBreed(context, species);
          if (b != null) {
            setState(() {
              _breedId = b.id;
              _breedOther = b.other;
            });
          }
        },
      ),
      if (_species == 'bird') ...[
        const SizedBox(height: Space.md),
        InfoNote(l.birdLegalNote, icon: Ph.gavel),
      ],
      const SizedBox(height: Space.lg),
      FieldLabel(l.colourTag, hint: l.colourTagHint),
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
                width: TapTarget.min,
                height: TapTarget.min,
                decoration: BoxDecoration(
                  color: e.value,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: e.key == _color ? context.paw.textPrimary : context.paw.outline,
                    width: e.key == _color ? Strokes.avatarRingSelected : Strokes.hairline,
                  ),
                ),
                child: e.key == _color ? Icon(Ph.check, color: readableOn(context.paw.ink, [e.value], ratio: 3)) : null,
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
      const SizedBox(height: Space.xxs),
      Text(l.petAboutSubtitle, style: context.text.bodySmall),
      const SizedBox(height: Space.lg),
      FieldLabel(l.birthday),
      SegmentedButton<bool>(
        segments: [
          ButtonSegment(value: false, label: Text(l.exactDate), icon: const Icon(Ph.cake)),
          ButtonSegment(value: true, label: Text(l.approxAge), icon: const Icon(Ph.clockCountdown)),
        ],
        selected: {_useApprox},
        onSelectionChanged: (s) => setState(() => _useApprox = s.first),
      ),
      const SizedBox(height: Space.md),
      if (!_useApprox)
        PawPickerField(
          label: l.birthday,
          icon: Ph.calendarBlank,
          value: _birthday == null ? null : Fmt.date(_birthday!, context.lang),
          placeholder: l.chooseDate,
          trailingIcon: Ph.calendarPlus,
          onTap: () async {
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
            child: LabeledField(
              label: l.years,
              child: DropdownButtonFormField<int>(
                initialValue: _approxYears,
                items: [for (var i = 0; i <= 25; i++) DropdownMenuItem(value: i, child: Text('$i'))],
                onChanged: (v) => setState(() => _approxYears = v ?? 0),
              ),
            ),
          ),
          const SizedBox(width: Space.md),
          Expanded(
            child: LabeledField(
              label: l.months,
              child: DropdownButtonFormField<int>(
                initialValue: _approxMonths,
                items: [for (var i = 0; i <= 11; i++) DropdownMenuItem(value: i, child: Text('$i'))],
                onChanged: (v) => setState(() => _approxMonths = v ?? 0),
              ),
            ),
          ),
        ]),
      const SizedBox(height: Space.md),
      FieldLabel(l.gender),
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
        prefixIcon: Ph.scales,
      ),
      Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          title: Text(l.moreDetails, style: context.text.titleSmall),
          subtitle: Text(l.moreDetailsHint, style: context.text.bodySmall),
          childrenPadding: const EdgeInsets.only(top: Space.sm),
          children: [
            _pair(context, PawTextField(label: l.markings, controller: _markings), PawTextField(label: l.microchip, controller: _microchip)),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _neutered,
              onChanged: (v) => setState(() => _neutered = v),
              title: Text(l.neutered),
            ),
            _pair(context, PawTextField(label: l.allergies, controller: _allergies, helper: l.allergiesHint), PawTextField(label: l.dietType, controller: _diet)),
            LabeledField(
              label: l.regularClinic,
              child: DropdownButtonFormField<String?>(
                initialValue: clinics.any((c) => c.$1 == _clinicId) ? _clinicId : null,
                isExpanded: true,
                items: [
                  DropdownMenuItem<String?>(value: null, child: Text(l.none)),
                  for (final c in clinics) DropdownMenuItem(value: c.$1, child: Text(c.$2, overflow: TextOverflow.ellipsis)),
                ],
                onChanged: (v) => setState(() => _clinicId = v),
              ),
            ),
            PawTextField(label: l.temperament, controller: _temperament, maxLines: 3),
            InfoNote(l.insuranceInVault),
          ],
        ),
      ),
    ];
  }
}

/// Two form boxes side by side on wider screens, one under the other on
/// phones (UI Design 2 pet form).
Widget _pair(BuildContext context, Widget a, Widget b) {
  if (context.isPhone) return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [a, b]);
  return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Expanded(child: a),
    const SizedBox(width: Space.md),
    Expanded(child: b),
  ]);
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
