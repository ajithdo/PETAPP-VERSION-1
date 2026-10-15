import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/providers.dart';
import '../../../core/services/service_providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/photo_picker.dart';
import '../../../core/widgets/widgets.dart';
import '../../pets/domain/pet.dart';
import '../data/routine_repository.dart';
import '../domain/routine.dart';
import 'routine_labels.dart';

/// Tap 1: open this sheet. Tap 2: tap a log type. It's saved straight away
/// with sensible defaults; "Add details" opens the full form (spec 7.3).
Future<void> showQuickLog(BuildContext context, WidgetRef ref, Pet pet) {
  return showPawSheet<void>(context, builder: (ctx) {
    final l = ctx.l10n;
    final types = logTypesFor(pet.species);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Row(children: [
        PetAvatar(species: pet.species, colorTag: pet.colorTag, photoUrl: pet.photoUrl, size: 40),
        const SizedBox(width: Space.md),
        Expanded(child: Text(l.logFor(pet.name), style: ctx.text.titleMedium)),
      ]),
      const SizedBox(height: Space.lg),
      TileGrid(
        columns: ctx.isPhone ? 3 : 4,
        spacing: Space.sm,
        children: [
          for (final t in types)
            QuickActionTile(
              icon: logTypeIcon(t),
              label: logTypeLabel(ctx, t),
              color: logTypeColor(t),
              onTap: () async {
                Navigator.pop(ctx);
                if (t == LogType.walk) {
                  context.push('/walk/${pet.id}');
                  return;
                }
                if (t == LogType.weight || t == LogType.behaviour || t == LogType.mood) {
                  await showLogDetails(context, ref, pet, t);
                  return;
                }
                await _quickSave(context, ref, pet, t);
              },
            ),
        ],
      ),
    ]);
  });
}

Map<String, dynamic>? _defaults(Pet pet, LogType t) => switch (t) {
      LogType.meal => {'grams': pet.dailyPortionG != null ? (pet.dailyPortionG! / (pet.dailyPlan.meals == 0 ? 1 : pet.dailyPlan.meals)).round() : null},
      LogType.play => {'minutes': 15},
      LogType.training => {'minutes': 15},
      LogType.sleep => {'minutes': 60},
      _ => null,
    };

Future<void> _quickSave(BuildContext context, WidgetRef ref, Pet pet, LogType t) async {
  final user = ref.read(currentUserProvider)!;
  HapticFeedback.lightImpact();
  final id = await ref.read(routineRepositoryProvider).addLog(pet: pet, by: user, type: t, data: _defaults(pet, t));
  if (!context.mounted) return;
  final l = context.l10n;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text(l.logged(logTypeLabel(context, t), pet.name)),
      action: SnackBarAction(label: l.addDetails, onPressed: () => showLogDetails(context, ref, pet, t, logId: id)),
    ));
}

/// Full log form: time, type-specific fields, note and photo.
Future<void> showLogDetails(BuildContext context, WidgetRef ref, Pet pet, LogType type, {String? logId}) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    constraints: const BoxConstraints(maxWidth: 640),
    builder: (_) => _LogDetailsSheet(pet: pet, type: type, logId: logId),
  );
}

class _LogDetailsSheet extends ConsumerStatefulWidget {
  const _LogDetailsSheet({required this.pet, required this.type, this.logId});
  final Pet pet;
  final LogType type;
  final String? logId;
  @override
  ConsumerState<_LogDetailsSheet> createState() => _LogDetailsSheetState();
}

class _LogDetailsSheetState extends ConsumerState<_LogDetailsSheet> {
  DateTime _at = DateTime.now();
  final _note = TextEditingController();
  final _amount = TextEditingController();
  final _minutes = TextEditingController();
  final _km = TextEditingController();
  String _mood = 'happy';
  final Map<String, int> _tags = {};
  bool _busy = false;
  String? _photoUrl;

  @override
  void dispose() {
    for (final c in [_note, _amount, _minutes, _km]) {
      c.dispose();
    }
    super.dispose();
  }

  Map<String, dynamic>? _data() {
    int? i(TextEditingController c) => int.tryParse(c.text.trim());
    double? d(TextEditingController c) => double.tryParse(c.text.trim().replaceAll(',', '.'));
    return switch (widget.type) {
      LogType.meal => {'grams': i(_amount)},
      LogType.play || LogType.training || LogType.sleep => {'minutes': i(_minutes) ?? 0},
      LogType.mood => {'mood': _mood},
      LogType.weight => {'weightKg': widget.pet.isBird ? (d(_amount) ?? 0) / 1000 : d(_amount)},
      LogType.behaviour => {'tags': _tags},
      LogType.walk => {'distanceKm': d(_km) ?? 0, 'durationMin': i(_minutes) ?? 0, 'source': 'manual'},
      _ => null,
    };
  }

  Future<void> _save() async {
    final l = context.l10n;
    if (widget.type == LogType.weight && _data()!['weightKg'] == null) {
      showToast(context, l.enterWeight);
      return;
    }
    if (widget.type == LogType.behaviour && _tags.isEmpty) {
      showToast(context, l.chooseOneTag);
      return;
    }
    setState(() => _busy = true);
    final repo = ref.read(routineRepositoryProvider);
    final user = ref.read(currentUserProvider)!;
    if (widget.logId != null) {
      await repo.updateLog(widget.logId!, {
        'at': _at,
        'note': _note.text.trim(),
        if (_photoUrl != null) 'photoUrl': _photoUrl,
        if (_data() != null) 'data': _data(),
      });
    } else {
      await repo.addLog(pet: widget.pet, by: user, type: widget.type, at: _at, note: _note.text.trim(), photoUrl: _photoUrl, data: _data());
    }
    if (mounted) {
      Navigator.pop(context);
      showToast(context, l.logged(logTypeLabel(context, widget.type), widget.pet.name));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = widget.type;
    return Padding(
      padding: EdgeInsets.fromLTRB(Space.lg, 0, Space.lg, Space.xl + MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            Icon(logTypeIcon(t), color: logTypeColor(t)),
            const SizedBox(width: Space.sm),
            Expanded(child: Text('${logTypeLabel(context, t)} · ${widget.pet.name}', style: context.text.titleMedium)),
          ]),
          const SizedBox(height: Space.md),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(alignment: Alignment.centerLeft),
            icon: const Icon(Icons.schedule_rounded),
            label: Text(Fmt.dateTime(_at, context.lang)),
            onPressed: () async {
              final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(_at));
              if (time != null) setState(() => _at = DateTime(_at.year, _at.month, _at.day, time.hour, time.minute));
            },
          ),
          const SizedBox(height: Space.md),
          if (t == LogType.meal)
            PawTextField(label: l.amountGrams, controller: _amount, keyboardType: TextInputType.number),
          if (t == LogType.walk) ...[
            PawTextField(label: l.distanceKm, controller: _km, keyboardType: const TextInputType.numberWithOptions(decimal: true)),
            PawTextField(label: l.durationMinutes, controller: _minutes, keyboardType: TextInputType.number),
          ],
          if (t == LogType.play || t == LogType.training || t == LogType.sleep)
            PawTextField(label: l.durationMinutes, controller: _minutes, keyboardType: TextInputType.number),
          if (t == LogType.weight)
            PawTextField(
              label: widget.pet.isBird ? l.weightGrams : l.weightKg,
              controller: _amount,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
          if (t == LogType.mood) ...[
            Text(l.howIsPet(widget.pet.name), style: context.text.titleSmall),
            const SizedBox(height: Space.sm),
            Wrap(spacing: Space.sm, runSpacing: Space.sm, children: [
              for (final m in moods)
                ChoiceChip(
                  avatar: Icon(moodIcon(m), size: 18),
                  label: Text(moodLabel(context, m)),
                  selected: _mood == m,
                  onSelected: (_) => setState(() => _mood = m),
                ),
            ]),
            const SizedBox(height: Space.md),
          ],
          if (t == LogType.behaviour) ...[
            Text(l.behaviourPrompt, style: context.text.titleSmall),
            const SizedBox(height: Space.sm),
            Wrap(spacing: Space.sm, runSpacing: Space.sm, children: [
              for (final tag in behaviourTags)
                FilterChip(
                  label: Text(_tags.containsKey(tag)
                      ? '${behaviourLabel(context, tag)} · ${intensityLabel(context, _tags[tag]!)}'
                      : behaviourLabel(context, tag)),
                  selected: _tags.containsKey(tag),
                  onSelected: (_) => setState(() {
                    // Tap cycles: off -> mild -> moderate -> strong -> off
                    final cur = _tags[tag] ?? 0;
                    if (cur >= 3) {
                      _tags.remove(tag);
                    } else {
                      _tags[tag] = cur + 1;
                    }
                  }),
                ),
            ]),
            const SizedBox(height: Space.xs),
            Text(l.behaviourHint, style: context.text.bodySmall),
            const SizedBox(height: Space.md),
          ],
          PawTextField(label: l.noteOptional, controller: _note, maxLines: 3),
          Row(children: [
            if (_photoUrl != null)
              Padding(
                padding: const EdgeInsets.only(right: Space.md),
                child: ClipRRect(borderRadius: BorderRadius.circular(12), child: MediaImage(url: _photoUrl!, width: 56, height: 56)),
              ),
            TextButton.icon(
              icon: const Icon(Icons.add_a_photo_rounded),
              label: Text(l.addPhoto),
              onPressed: () async {
                final pick = await pickImage(context, ImageSource.gallery);
                if (pick == null) return;
                final user = ref.read(currentUserProvider)!;
                final url = await ref.read(storageServiceProvider).upload(pick.bytes,
                    path: 'users/${user.uid}/logs/${DateTime.now().millisecondsSinceEpoch}.jpg', contentType: 'image/jpeg');
                setState(() => _photoUrl = url);
              },
            ),
          ]),
          const SizedBox(height: Space.md),
          PrimaryButton(label: l.save, loading: _busy, onPressed: _save),
        ]),
      ),
    );
  }
}
