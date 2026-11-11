import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../pets/data/pets_repository.dart';
import '../../pets/domain/pet.dart';
import '../../plans/presentation/plus_prompt.dart';
import '../data/vault_repository.dart';
import '../domain/storage_quota.dart';
import '../domain/vault_models.dart';
import 'upload_flow.dart';
import 'vault_gate.dart';
import 'vault_labels.dart';

/// Document vault (spec 7.9): every pet's documents, or one pet's when
/// [petId] is set. Always shown behind [VaultGate].
class VaultScreen extends ConsumerStatefulWidget {
  const VaultScreen({super.key, this.petId});
  final String? petId;

  @override
  ConsumerState<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends ConsumerState<VaultScreen> {
  final _search = TextEditingController();
  String? _type;
  String? _tag;
  String? _pet;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final allPets = ref.watch(myPetsProvider).value ?? const <Pet>[];
    final petsById = {for (final p in allPets) p.id: p};
    final fixed = widget.petId == null ? null : petsById[widget.petId];
    final docsAsync = widget.petId == null ? ref.watch(myDocsProvider) : ref.watch(petDocsProvider(widget.petId!));
    final focusPet = fixed ?? (_pet == null ? null : petsById[_pet]);
    final defaultPet = fixed ?? focusPet ?? ref.watch(selectedPetProvider) ?? ref.watch(activePetsProvider).firstOrNull;
    return Scaffold(
      appBar: AppBar(
        title: Text(fixed == null ? l.documentVault : l.vaultOfPet(fixed.name)),
        actions: [
          IconButton(
            tooltip: l.vaultLockSettings,
            icon: const Icon(Icons.lock_outlined),
            onPressed: () => showVaultLockSheet(context, ref),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showUploadSheet(context, ref, pet: defaultPet, fixedPet: fixed != null),
        icon: const Icon(Icons.add_outlined),
        label: Text(l.vaultAddDocument),
      ),
      body: AsyncView<List<VaultDoc>>(
        value: docsAsync,
        data: (all) {
          final now = DateTime.now();
          final scoped = all.where((d) => fixed != null || _pet == null || d.petId == _pet).toList();
          final types = vaultDocTypes.where((t) => scoped.any((d) => d.type == t)).toList();
          final tags = popularTags(scoped);
          final shown = sortDocs(
            scoped.where((d) {
              if (_type != null && d.type != _type) return false;
              if (_tag != null && !d.tags.contains(_tag)) return false;
              return docMatches(d, _search.text, typeLabel: docTypeLabel(context, d.type), petName: petsById[d.petId]?.name ?? '');
            }).toList(),
            now,
          );
          final filtering = _search.text.isNotEmpty || _type != null || _tag != null;
          final attention = filtering
              ? const <VaultDoc>[]
              : shown.where((d) => d.needsReview || expiryState(d.expiry, now) == ExpiryState.soon || expiryState(d.expiry, now) == ExpiryState.expired).toList();
          final rest = shown.where((d) => !attention.contains(d)).toList();
          return PageBody(maxWidth: Space.wideWidth, children: [
            const SizedBox(height: Space.sm),
            Wrap(spacing: Space.sm, runSpacing: Space.sm, children: [
              FilledButton.tonalIcon(
                onPressed: () => context.push(fixed == null ? '/vault/insurance' : '/vault/insurance?pet=${fixed.id}'),
                icon: const Icon(Icons.health_and_safety_outlined),
                label: Text(l.vaultInsuranceTitle),
              ),
              FilledButton.tonalIcon(
                onPressed: () => context.push('/vault/shares'),
                icon: const Icon(Icons.link_outlined),
                label: Text(l.vaultShareLinks),
              ),
            ]),
            const SizedBox(height: Space.md),
            const StorageMeter(),
            const SizedBox(height: Space.md),
            TextField(
              controller: _search,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: l.vaultSearchHint,
                prefixIcon: const Icon(Icons.search_outlined),
                suffixIcon: _search.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: l.vaultClearSearch,
                        icon: const Icon(Icons.close_outlined),
                        onPressed: () => setState(_search.clear),
                      ),
              ),
            ),
            if (fixed == null && allPets.length > 1) ...[
              const SizedBox(height: Space.md),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  _chip(l.allPets, _pet == null, () => setState(() => _pet = null)),
                  for (final p in allPets)
                    _chip(p.name, _pet == p.id, () => setState(() => _pet = _pet == p.id ? null : p.id),
                        avatar: PetAvatar(species: p.species, colorTag: p.colorTag, photoUrl: p.photoUrl, size: Sizes.avatarChip)),
                ]),
              ),
            ],
            if (types.length > 1) ...[
              const SizedBox(height: Space.sm),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  _chip(l.filterAll, _type == null, () => setState(() => _type = null)),
                  for (final t in types)
                    _chip(docTypeLabel(context, t), _type == t, () => setState(() => _type = _type == t ? null : t),
                        avatar: Icon(docTypeIcon(t), size: IconSizes.chip)),
                ]),
              ),
            ],
            if (tags.isNotEmpty) ...[
              const SizedBox(height: Space.sm),
              Wrap(spacing: Space.xs, runSpacing: Space.xs, children: [
                for (final t in tags)
                  FilterChip(
                    label: Text('#$t'),
                    selected: _tag == t,
                    visualDensity: VisualDensity.compact,
                    onSelected: (_) => setState(() => _tag = _tag == t ? null : t),
                  ),
              ]),
            ],
            if (all.isEmpty)
              EmptyState(
                scene: Scene.vault,
                title: l.vaultEmptyTitle,
                message: l.vaultEmptyBody,
                actionLabel: l.vaultAddDocument,
                onAction: () => showUploadSheet(context, ref, pet: defaultPet, fixedPet: fixed != null),
              )
            else if (shown.isEmpty)
              EmptyState(scene: Scene.search, title: l.vaultNoMatches, compact: true)
            else ...[
              // UI Design 6: documents as paper sheets in a grid.
              if (attention.isNotEmpty) ...[
                SectionHeader(l.vaultNeedsAttention),
                _SheetGrid(docs: attention, petsById: petsById, showPet: fixed == null),
              ],
              if (rest.isNotEmpty) ...[
                SectionHeader(attention.isEmpty ? l.vaultDocCount(rest.length) : l.vaultAllDocs),
                _SheetGrid(docs: rest, petsById: petsById, showPet: fixed == null),
              ],
            ],
            const SizedBox(height: Space.lg),
            InfoNote(l.vaultSecureNote, icon: Icons.shield_outlined),
            const SizedBox(height: Space.fabClearance),
          ]);
        },
      ),
    );
  }

  Widget _chip(String label, bool selected, VoidCallback onTap, {Widget? avatar}) => Padding(
        padding: const EdgeInsets.only(right: Space.sm),
        child: ChoiceChip(label: Text(label), avatar: avatar, selected: selected, showCheckmark: avatar == null, onSelected: (_) => onTap()),
      );
}

/// Documents as sheets: 2 across on phones, 4 on wide screens.
class _SheetGrid extends StatelessWidget {
  const _SheetGrid({required this.docs, required this.petsById, required this.showPet});
  final List<VaultDoc> docs;
  final Map<String, Pet> petsById;
  final bool showPet;

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, c) {
    final big = MediaQuery.textScalerOf(context).scale(1) > 1.3;
    final cols = c.maxWidth >= 720 ? 4 : (big ? 1 : 2);
    return TileGrid(columns: cols, spacing: Space.sm, children: [
      for (final d in docs) DocSheet(doc: d, pet: petsById[d.petId], showPet: showPet),
    ]);
  });
}

/// One document as a paper sheet: its kind's icon and a few ruled lines on
/// a tinted page (a "SAMPLE" stamp on demo papers), then the title and one
/// line under it, and at most one tag.
class DocSheet extends StatelessWidget {
  const DocSheet({super.key, required this.doc, this.pet, this.showPet = false});
  final VaultDoc doc;
  final Pet? pet;
  final bool showPet;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final paw = context.paw;
    final c = docTypeColor(context, doc.type);
    final sub = [
      if (showPet && pet != null) pet!.name,
      if (doc.expiry != null) expiryText(context, doc.expiry!) else Fmt.date(doc.createdAt, context.lang),
    ].join(', ');
    final chip = doc.needsReview
        ? StatusChip(l.vaultNeedsReview, tone: ChipTone.accent, icon: Icons.auto_awesome_outlined)
        : expiryChip(context, doc.expiry);
    Widget rule(double share) => FractionallySizedBox(
          widthFactor: share,
          alignment: Alignment.centerLeft,
          child: Container(height: Space.xs, margin: const EdgeInsets.only(top: Space.xs + Space.xxs), decoration: BoxDecoration(color: c.withValues(alpha: Opacities.border), borderRadius: BorderRadius.circular(Radii.xs))),
        );
    return PawCard(
      padding: const EdgeInsets.all(Space.sm + Space.xxs),
      onTap: () => context.push('/vault/doc/${doc.id}'),
      semanticLabel: [doc.title, docTypeLabel(context, doc.type), sub].join(', '),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        AspectRatio(
          aspectRatio: 1.25,
          child: Container(
            padding: const EdgeInsets.all(Space.md),
            decoration: BoxDecoration(color: c.withValues(alpha: Opacities.tint), borderRadius: BorderRadius.circular(Radii.sm)),
            child: Stack(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(docTypeIcon(doc.type), color: c, size: IconSizes.lg),
                const SizedBox(height: Space.xs),
                rule(0.8),
                rule(0.8),
                rule(0.55),
              ]),
              if (doc.isSample)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Transform.rotate(
                    angle: -0.2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: Space.xs, vertical: Space.xxs),
                      decoration: BoxDecoration(border: Border.all(color: paw.error, width: Strokes.strong), borderRadius: BorderRadius.circular(Radii.xs)),
                      child: Text(l.vaultSample, style: context.text.labelSmall?.copyWith(color: paw.error, fontWeight: FontWeight.w800)),
                    ),
                  ),
                ),
            ]),
          ),
        ),
        const SizedBox(height: Space.sm),
        Text(doc.title, style: context.text.titleSmall, maxLines: 2, overflow: TextOverflow.ellipsis),
        Text(sub, style: context.text.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
        if (chip != null) ...[const SizedBox(height: Space.xs), Align(alignment: Alignment.centerLeft, child: chip)],
      ]),
    );
  }
}

/// One document row.
class DocTile extends StatelessWidget {
  const DocTile({super.key, required this.doc, this.pet, this.showPet = false});
  final VaultDoc doc;
  final Pet? pet;
  final bool showPet;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final sub = [
      docTypeLabel(context, doc.type),
      if (showPet && pet != null) pet!.name,
      if (doc.expiry != null) expiryText(context, doc.expiry!) else l.vaultAddedOn(Fmt.date(doc.createdAt, context.lang)),
    ].join(' · ');
    final chip = doc.needsReview
        ? StatusChip(l.vaultNeedsReview, tone: ChipTone.accent, icon: Icons.auto_awesome_outlined)
        : expiryChip(context, doc.expiry);
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.sm),
      child: PawCard(
        padding: const EdgeInsets.all(Space.md),
        onTap: () => context.push('/vault/doc/${doc.id}'),
        child: Row(children: [
          DocTypeBadge(type: doc.type),
          const SizedBox(width: Space.md),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(doc.title, style: context.text.titleSmall, maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: Space.xxs),
              Text(sub, style: context.text.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
              if (chip != null || doc.isSample) ...[
                const SizedBox(height: Space.xs),
                Wrap(spacing: Space.xs, runSpacing: Space.xs, children: [
                  ?chip,
                  if (doc.isSample) StatusChip(l.vaultSample, tone: ChipTone.neutral),
                ]),
              ],
            ]),
          ),
          const Icon(Icons.chevron_right_outlined),
        ]),
      ),
    );
  }
}

/// "96 MB of 25 GB used" with a bar (spec 7.11 storage quota).
class StorageMeter extends ConsumerWidget {
  const StorageMeter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final u = ref.watch(storageUsageProvider);
    if (u == null) return const Skeleton(height: Sizes.thumb, radius: Radii.card);
    final color = u.nearlyFull ? context.paw.warning : context.colors.primary;
    return Semantics(
      label: '${l.vaultStorageTitle}: ${l.vaultStorageUsed(formatBytes(u.usedBytes), formatBytes(u.limitBytes))}',
      excludeSemantics: true,
      child: PawCard(
        padding: const EdgeInsets.symmetric(horizontal: Space.md, vertical: Space.md),
        child: Row(children: [
          Icon(Icons.cloud_outlined, color: color),
          const SizedBox(width: Space.md),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l.vaultStorageUsed(formatBytes(u.usedBytes), formatBytes(u.limitBytes)), style: context.text.bodyMedium),
              const SizedBox(height: Space.xs),
              ClipRRect(
                borderRadius: BorderRadius.circular(Radii.sm),
                child: LinearProgressIndicator(
                  value: u.fraction < 0.01 && u.usedBytes > 0 ? 0.01 : u.fraction,
                  minHeight: Sizes.progressBar,
                  color: color,
                  backgroundColor: context.paw.outline,
                ),
              ),
              const SizedBox(height: Space.xs),
              Text(l.vaultStorageSplit(formatBytes(u.docsBytes), formatBytes(u.albumBytes)), style: context.text.bodySmall),
            ]),
          ),
        ]),
      ),
    );
  }
}

/// Checks the plan's storage limit before an upload. Free users get the
/// PawSetu Plus prompt.
Future<bool> ensureStorageRoom(BuildContext context, WidgetRef ref, int bytes) async {
  final u = ref.read(storageUsageProvider);
  if (u == null || u.canAdd(bytes)) return true;
  final l = context.l10n;
  final plus = ref.read(currentUserProvider)?.isPlus ?? false;
  final used = formatBytes(u.usedBytes);
  final limit = formatBytes(u.limitBytes);
  if (plus) {
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: Icon(Icons.cloud_off_outlined, color: ctx.paw.warning, size: IconSizes.xl),
        title: Text(l.vaultStorageFullTitle),
        content: Text(l.vaultStorageFullBodyPlus(used, limit)),
        actions: [FilledButton(onPressed: () => Navigator.pop(ctx), child: Text(l.ok))],
      ),
    );
  } else {
    await showPlusPrompt(context, title: l.vaultStorageFullTitle, body: l.vaultStorageFullBody(used, limit));
  }
  return false;
}
