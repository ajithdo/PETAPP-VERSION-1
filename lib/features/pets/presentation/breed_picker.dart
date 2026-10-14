import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';
import '../../../core/widgets/widgets.dart';
import '../domain/breeds.dart';

/// Result of the breed picker: a built-in breed id, "mixed", or "other" with text.
typedef BreedChoice = ({String id, String? other});

/// Searchable, translated breed list (matches English and the current
/// language), with "Mixed / Indie" and "Other (type it)".
Future<BreedChoice?> pickBreed(BuildContext context, Species species) {
  return showModalBottomSheet<BreedChoice>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    constraints: const BoxConstraints(maxWidth: 640),
    builder: (ctx) => _BreedSheet(species: species),
  );
}

class _BreedSheet extends StatefulWidget {
  const _BreedSheet({required this.species});
  final Species species;
  @override
  State<_BreedSheet> createState() => _BreedSheetState();
}

class _BreedSheetState extends State<_BreedSheet> {
  String _q = '';
  final _other = TextEditingController();
  bool _typing = false;

  @override
  void dispose() {
    _other.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final lang = context.lang;
    final q = _q.trim().toLowerCase();
    final list = breedsFor(widget.species)
        .where((b) => q.isEmpty || b.en.toLowerCase().contains(q) || b.name(lang).toLowerCase().contains(q))
        .toList()
      ..sort((a, b) => a.name(lang).compareTo(b.name(lang)));
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      builder: (context, scroll) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(Space.lg, 0, Space.lg, Space.sm),
            child: _typing
                ? Row(children: [
                    Expanded(
                      child: PawTextField(label: l.typeBreed, controller: _other, autofocus: true),
                    ),
                    const SizedBox(width: Space.sm),
                    FilledButton(
                      onPressed: () {
                        if (_other.text.trim().isEmpty) return;
                        Navigator.pop(context, (id: otherBreedId, other: _other.text.trim()));
                      },
                      child: Text(l.done),
                    ),
                  ])
                : TextField(
                    autofocus: false,
                    decoration: InputDecoration(prefixIcon: const Icon(Icons.search_rounded), hintText: l.searchBreeds),
                    onChanged: (v) => setState(() => _q = v),
                  ),
          ),
          if (widget.species == Species.bird)
            Padding(
              padding: const EdgeInsets.fromLTRB(Space.lg, 0, Space.lg, Space.sm),
              child: InfoNote(l.birdLegalNote, icon: Icons.gavel_rounded),
            ),
          Expanded(
            child: ListView(controller: scroll, children: [
              ListTile(
                leading: const Icon(Icons.diversity_3_rounded),
                title: Text(l.breedMixed),
                onTap: () => Navigator.pop(context, (id: mixedBreedId, other: null)),
              ),
              ListTile(
                leading: const Icon(Icons.edit_rounded),
                title: Text(l.breedOther),
                onTap: () => setState(() => _typing = true),
              ),
              const Divider(),
              for (final b in list)
                ListTile(
                  title: Text(b.name(lang)),
                  subtitle: lang == 'en' ? null : Text(b.en),
                  onTap: () => Navigator.pop(context, (id: b.id, other: null)),
                ),
              if (list.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(Space.xl),
                  child: Text(l.noBreedMatch, textAlign: TextAlign.center),
                ),
            ]),
          ),
        ]),
      ),
    );
  }
}
