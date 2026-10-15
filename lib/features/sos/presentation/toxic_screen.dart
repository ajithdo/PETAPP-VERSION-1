import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/gen/app_localizations.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/widgets.dart';
import '../../pets/data/pets_repository.dart';
import '../../pets/presentation/pet_labels.dart';
import '../../shell/presentation/sos_launcher.dart';
import '../domain/toxic.dart';
import 'safety_labels.dart';

final _en = lookupAppLocalizations(const Locale('en'));

/// "Is it safe?" (spec 7.14): search a food, plant or household item and
/// see what it means for this pet's species.
class ToxicCheckScreen extends ConsumerStatefulWidget {
  const ToxicCheckScreen({super.key, this.query});
  final String? query;

  @override
  ConsumerState<ToxicCheckScreen> createState() => _ToxicCheckScreenState();
}

class _ToxicCheckScreenState extends ConsumerState<ToxicCheckScreen> {
  late final _search = TextEditingController(text: widget.query ?? '');
  String? _species;
  ToxKind? _kind;

  @override
  void initState() {
    super.initState();
    _species = ref.read(selectedPetProvider)?.species;
    if (_species == null) {
      final pets = ref.read(activePetsProvider);
      if (pets.isNotEmpty) _species = pets.first.species;
    }
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final results = searchToxic(
      _search.text,
      species: _species,
      kind: _kind,
      names: (t) => [toxText(l, t.id).$1, toxText(_en, t.id).$1],
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(l.toxTitle),
        actions: [Padding(padding: const EdgeInsets.only(right: Space.md), child: SosButton(onActivate: () => openSos(context, ref)))],
      ),
      body: PageBody(maxWidth: 760, children: [
        const SizedBox(height: Space.md),
        TextField(
          controller: _search,
          onChanged: (_) => setState(() {}),
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search_rounded),
            hintText: l.toxSearchHint,
            labelText: l.toxSearchLabel,
            suffixIcon: _search.text.isEmpty
                ? null
                : IconButton(tooltip: l.clearSearch, icon: const Icon(Icons.close_rounded), onPressed: () => setState(_search.clear)),
          ),
        ),
        const SizedBox(height: Space.md),
        Text(l.toxForWhichPet, style: context.text.labelLarge),
        const SizedBox(height: Space.xs),
        Wrap(spacing: Space.sm, runSpacing: Space.xs, children: [
          for (final s in const ['dog', 'cat', 'bird', 'rabbit'])
            ChoiceChip(label: Text(speciesLabel(context, s)), selected: _species == s, onSelected: (_) => setState(() => _species = s)),
        ]),
        const SizedBox(height: Space.sm),
        Wrap(spacing: Space.sm, runSpacing: Space.xs, children: [
          ChoiceChip(label: Text(l.toxKindAll), selected: _kind == null, onSelected: (_) => setState(() => _kind = null)),
          for (final k in ToxKind.values)
            ChoiceChip(label: Text(toxKindLabel(l, k)), selected: _kind == k, onSelected: (_) => setState(() => _kind = k)),
        ]),
        const SizedBox(height: Space.md),
        const DraftLabel(area: 'toxic'),
        const SizedBox(height: Space.md),
        if (results.isEmpty)
          EmptyState(title: l.toxNoMatch, message: l.toxNoMatchHint, compact: true, actionLabel: l.firstAidTalkToVet, onAction: () => context.push('/televet'))
        else
          PawCard(
            padding: const EdgeInsets.symmetric(vertical: Space.xs),
            child: Column(children: [
              for (final t in results) _ToxTile(item: t, species: _species),
            ]),
          ),
        const SizedBox(height: Space.xxl),
      ]),
    );
  }
}

class _ToxTile extends StatelessWidget {
  const _ToxTile({required this.item, required this.species});
  final ToxItem item;
  final String? species;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final (name, why) = toxText(l, item.id);
    final level = item.levelFor(species) ?? ToxLevel.safe;
    return ListTile(
      onTap: () => _showToxItem(context, item, species),
      leading: Icon(toxIcon(level), color: switch (level) {
        ToxLevel.danger => context.paw.error,
        ToxLevel.caution => context.paw.warning,
        ToxLevel.safe => context.paw.success,
      }),
      title: Text(name, style: context.text.titleSmall),
      subtitle: Text(why, maxLines: 2, overflow: TextOverflow.ellipsis),
      trailing: StatusChip(toxLevelLabel(l, level), tone: toxTone(level)),
    );
  }
}

Future<void> _showToxItem(BuildContext context, ToxItem item, String? species) {
  return showPawSheet<void>(context, builder: (ctx) {
    final l = ctx.l10n;
    final (name, why) = toxText(l, item.id);
    final level = item.levelFor(species) ?? ToxLevel.safe;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
      Text(name, style: ctx.text.headlineSmall),
      const SizedBox(height: Space.sm),
      Align(alignment: AlignmentDirectional.centerStart, child: StatusChip(toxLevelLabel(l, level), tone: toxTone(level), icon: toxIcon(level))),
      const SizedBox(height: Space.md),
      Text(why, style: ctx.text.bodyLarge),
      const SizedBox(height: Space.lg),
      Text(l.toxForEachPet, style: ctx.text.titleSmall),
      const SizedBox(height: Space.xs),
      for (final s in const ['dog', 'cat', 'bird', 'rabbit'])
        if (item.levels[s] != null)
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: Text(speciesLabel(ctx, s)),
            trailing: StatusChip(toxLevelLabel(l, item.levels[s]!), tone: toxTone(item.levels[s]!)),
          ),
      if (level == ToxLevel.danger) ...[
        const SizedBox(height: Space.md),
        InfoNote(l.toxAteIt, icon: Icons.emergency_rounded, tone: ChipTone.error),
        const SizedBox(height: Space.sm),
        PrimaryButton(
          label: l.sosGetHelp,
          icon: Icons.emergency_rounded,
          danger: true,
          onPressed: () {
            Navigator.pop(ctx);
            context.push('/sos');
          },
        ),
        const SizedBox(height: Space.sm),
        SecondaryButton(
          label: l.toxPoisoningGuide,
          icon: Icons.medical_services_rounded,
          onPressed: () {
            Navigator.pop(ctx);
            context.push('/first-aid/poisoning');
          },
        ),
      ],
      const SizedBox(height: Space.md),
      const DraftLabel(area: 'toxic'),
    ]);
  });
}
