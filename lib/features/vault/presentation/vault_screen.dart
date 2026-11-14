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
import '../domain/insurance.dart';
import '../domain/share_rules.dart';
import '../domain/storage_quota.dart';
import '../domain/vault_models.dart';
import 'shares_screen.dart';
import 'upload_flow.dart';
import 'vault_gate.dart';
import 'vault_labels.dart';
import '../../../core/theme/ph.dart';

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

  // Starts on the pet you're looking at everywhere else; tap its chip
  // again to see every pet's papers.
  late String? _pet = widget.petId == null ? ref.read(selectedPetProvider)?.id : null;

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
    final petFilter = fixed?.id ?? (petsById.containsKey(_pet) ? _pet : null);
    void add() => showUploadSheet(context, ref, pet: defaultPet, fixedPet: fixed != null);
    return Scaffold(
      appBar: AppBar(
        title: Text(fixed == null ? l.documentVault : l.vaultOfPet(fixed.name)),
        actions: [
          IconButton(tooltip: l.vaultShareLinks, icon: const Icon(Ph.link), onPressed: () => context.push('/vault/shares')),
          IconButton(tooltip: l.vaultLockSettings, icon: const Icon(Ph.lockKeyOpen), onPressed: () => showVaultLockSheet(context, ref)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: add, icon: const Icon(Ph.scan), label: Text(l.vaultScanOrUpload)),
      body: AsyncView<List<VaultDoc>>(
        value: docsAsync,
        data: (all) {
          final now = DateTime.now();
          final scoped = all.where((d) => petFilter == null || d.petId == petFilter).toList();
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
          bool urgent(VaultDoc d) => expiryState(d.expiry, now) == ExpiryState.soon || expiryState(d.expiry, now) == ExpiryState.expired;
          // Papers that need a look come first, then the rest.
          final ordered = [...shown.where((d) => d.needsReview || urgent(d)), ...shown.where((d) => !d.needsReview && !urgent(d))];
          final due = filtering ? null : shown.where(urgent).firstOrNull;
          final links = (ref.watch(myShareLinksProvider).value ?? const <ShareLink>[])
              .where((k) => k.kind == 'docs' && k.isActive(now) && (petFilter == null || k.petId == petFilter))
              .toList();
          final policies = (ref.watch(myPoliciesProvider).value ?? const <InsurancePolicy>[]).where((p) => petFilter == null || p.petId == petFilter).toList();
          final insuranceLink = petFilter == null ? '/vault/insurance' : '/vault/insurance?pet=$petFilter';
          final docTitles = {for (final d in all) d.id: d.title};
          return PageBody(maxWidth: Space.wideWidth, children: [
            const SizedBox(height: Space.xs),
            TextField(
              controller: _search,
              onChanged: (_) => setState(() {}),
              decoration: searchPillDecoration(
                context,
                hint: l.vaultSearchDocsHint,
                suffix: _search.text.isEmpty ? null : IconButton(tooltip: l.vaultClearSearch, icon: const Icon(Ph.x), onPressed: () => setState(_search.clear)),
              ),
            ),
            if ((fixed == null && allPets.length > 1) || types.length > 1 || tags.isNotEmpty) ...[
              const SizedBox(height: Space.md),
              // One row to narrow things down: whose papers, then what kind.
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                child: Row(children: [
                  if (fixed == null && allPets.length > 1)
                    for (final p in allPets)
                      Padding(
                        padding: const EdgeInsets.only(right: Space.sm),
                        child: PawPill(
                          label: p.name,
                          selected: _pet == p.id,
                          leading: PetAvatar(species: p.species, colorTag: p.colorTag, photoUrl: p.photoUrl, size: Sizes.pillArch, ring: false),
                          onTap: () => setState(() {
                            _pet = _pet == p.id ? null : p.id;
                            _type = null;
                            _tag = null;
                          }),
                        ),
                      ),
                  if (types.length > 1)
                    for (final t in types)
                      Padding(
                        padding: const EdgeInsets.only(right: Space.sm),
                        child: PawChip(label: docTypeShort(context, t), selected: _type == t, onTap: () => setState(() => _type = _type == t ? null : t)),
                      ),
                  for (final t in tags)
                    Padding(
                      padding: const EdgeInsets.only(right: Space.sm),
                      child: PawChip(label: '#$t', selected: _tag == t, onTap: () => setState(() => _tag = _tag == t ? null : t)),
                    ),
                ]),
              ),
            ],
            if (due != null) ...[
              const SizedBox(height: Space.lg),
              InfoNote(
                due.type == 'vaccination' && petsById[due.petId] != null ? l.vaultRenewHintVaccine(petsById[due.petId]!.name) : l.vaultRenewHint,
                lead: expiryState(due.expiry, now) == ExpiryState.expired
                    ? l.vaultExpiredNote(due.title, Fmt.dateShort(due.expiry!, context.lang))
                    : l.vaultExpiresNote(due.title, Fmt.dateShort(due.expiry!, context.lang)),
                icon: Ph.clock,
                tone: ChipTone.warning,
              ),
            ],
            const SizedBox(height: Space.lg),
            if (all.isEmpty)
              EmptyState(scene: Scene.vault, title: l.vaultEmptyTitle, message: l.vaultEmptyBody, actionLabel: l.vaultAddDocument, onAction: add)
            else if (shown.isEmpty)
              EmptyState(scene: Scene.search, title: l.vaultNoMatches, compact: true)
            else
              _SheetGrid(docs: ordered, petsById: petsById, showPet: petFilter == null),
            if (!filtering) ...[
              if (links.isNotEmpty) ...[
                const SizedBox(height: Sizes.sectionGap),
                SecHead(l.vaultSharedWithVet, action: l.vaultAllLinks, onAction: () => context.push('/vault/shares')),
                for (final (i, k) in links.indexed) ...[
                  if (i > 0) const SizedBox(height: Space.sm),
                  _SharedRow(link: k, docTitles: docTitles),
                ],
              ],
              const SizedBox(height: Sizes.sectionGap),
              SecHead(l.vaultTypeShortInsurance),
              if (policies.isEmpty)
                PawPanel(
                  padding: PawPanel.listPadding,
                  child: PawItem(
                    lead: const PawTile(icon: Ph.shieldCheck, tone: Tone.sky),
                    title: l.vaultAddInsurance,
                    sub: l.vaultAddInsuranceBody,
                    subMaxLines: 3,
                    onTap: () => context.push(insuranceLink),
                  ),
                )
              else
                PawPanel(
                  padding: PawPanel.listPadding,
                  child: PawList(children: [
                    for (final p in policies) _policyRow(context, p, petsById[p.petId], showPet: petFilter == null, now: now),
                  ]),
                ),
              const SizedBox(height: Sizes.sectionGap),
              const StorageMeter(),
              const SizedBox(height: Space.md),
              InfoNote(l.vaultSecureNote, icon: Ph.shield),
            ],
            const SizedBox(height: Space.fabClearance),
          ]);
        },
      ),
    );
  }

  /// "PawCover Gold, ₹2,00,000 cover" and what's happening with it.
  Widget _policyRow(BuildContext context, InsurancePolicy p, Pet? pet, {required bool showPet, required DateTime now}) {
    final l = context.l10n;
    final lang = context.lang;
    final open = p.claims.where((c) => c.isOpen).toList();
    final first = open.firstOrNull;
    final name = [p.provider, p.planName].where((s) => s.isNotEmpty).join(' ');
    final String sub;
    if (first != null) {
      final done = first.checklist.values.where((v) => v).length;
      sub = l.vaultOpenClaimLine(open.length, claimStatusLabel(context, first.status).toLowerCase(), Fmt.inr(first.amount, lang), done, first.checklist.length);
    } else {
      sub = [if (showPet && pet != null) pet.name, if (p.renewal != null) l.vaultRenewsOn(Fmt.date(p.renewal!, lang))].join(', ');
    }
    return PawItem(
      lead: const PawTile(icon: Ph.shieldCheck, tone: Tone.sky),
      title: l.vaultPolicyLine(name, Fmt.inr(p.cover, lang)),
      sub: sub.isEmpty ? null : sub,
      subMaxLines: 3,
      onTap: () => context.push('/vault/insurance/${p.id}'),
    );
  }
}

/// A live link a vet can open: what it shows, till when, and Revoke.
class _SharedRow extends ConsumerWidget {
  const _SharedRow({required this.link, required this.docTitles});
  final ShareLink link;
  final Map<String, String> docTitles;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final paw = context.paw;
    final opens = link.accessLog.where((a) => a.ok).length;
    final one = link.docIds.length == 1 ? docTitles[link.docIds.single] : null;
    final what = one ?? l.vaultLinkDocs(link.docIds.length);
    final till = link.expiresAt == null ? l.vaultLinkNoEnd : l.vaultLinkWorksUntil(Fmt.dateTime(link.expiresAt!, context.lang));
    return PawPanel(
      child: Row(children: [
        const PawTile(icon: Ph.link, tone: Tone.gold),
        const SizedBox(width: Space.md),
        Expanded(
          child: InkWell(
            onTap: () => showLinkDetails(context, link),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l.vaultWhatViewOnly(what), style: context.text.labelLarge),
              Text('${link.petName}. $till. ${l.vaultLinkOpened(opens)}.', style: context.text.bodySmall?.copyWith(color: paw.textSecondary)),
            ]),
          ),
        ),
        const SizedBox(width: Space.md),
        PawButton(
          label: l.vaultRevokeShort,
          kind: BtnKind.line,
          semanticLabel: l.vaultRevoke,
          onPressed: () async {
            final ok = await confirmAction(context, title: l.vaultRevokeQ, body: l.vaultRevokeBody, confirmLabel: l.vaultRevoke);
            if (!ok) return;
            await ref.read(vaultRepositoryProvider).revokeLink(link.id);
            if (context.mounted) showToast(context, l.vaultRevoked);
          },
        ),
      ]),
    );
  }
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
    return TileGrid(columns: cols, spacing: Space.md, children: [
      for (final d in docs) DocSheet(doc: d, pet: petsById[d.petId], showPet: showPet),
    ]);
  });
}

/// One document as a paper sheet: its kind's icon and three ruled lines on
/// a tinted page (a "SAMPLE" stamp on demo papers), then the title and one
/// line under it.
class DocSheet extends StatelessWidget {
  const DocSheet({super.key, required this.doc, this.pet, this.showPet = false});
  final VaultDoc doc;
  final Pet? pet;
  final bool showPet;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final paw = context.paw;
    final (:fill, :ink) = toneColors(context, docTypeTone(doc.type));
    final sub = [
      if (showPet && pet != null) pet!.name,
      if (doc.expiry != null) expiryText(context, doc.expiry!) else Fmt.date(doc.createdAt, context.lang),
    ].join(', ');
    Widget rule(double share) => FractionallySizedBox(
          widthFactor: share,
          alignment: Alignment.centerLeft,
          child: Container(height: Space.xs + Strokes.hairline, margin: const EdgeInsets.only(top: Space.xs + Space.xxs), decoration: BoxDecoration(color: context.tint.line2, borderRadius: BorderRadius.circular(Radii.xs))),
        );
    return PawCard(
      padding: const EdgeInsets.all(Space.md),
      onTap: () => context.push('/vault/doc/${doc.id}'),
      semanticLabel: [doc.title, docTypeLabel(context, doc.type), sub, if (doc.needsReview) l.vaultNeedsReview].join(', '),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        AspectRatio(
          aspectRatio: Sizes.docSheetAspect,
          child: Container(
            padding: const EdgeInsets.all(Space.md),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(color: fill, borderRadius: BorderRadius.circular(Radii.sm)),
            child: Stack(clipBehavior: Clip.none, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(docTypeIcon(doc.type), color: ink, size: IconSizes.md),
                const SizedBox(height: Space.xxs),
                rule(0.8),
                rule(0.8),
                rule(0.55),
              ]),
              if (doc.needsReview) Positioned(right: -Space.xs, top: -Space.xs, child: PawTag(l.vaultNeedsReview, kind: TagKind.gold, icon: Ph.sparkleFill)),
              if (doc.isSample)
                Positioned(
                  right: -Space.xs,
                  bottom: -Space.xxs,
                  child: Transform.rotate(
                    angle: -Sizes.stampTilt,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: Space.xs + Strokes.hairline, vertical: Strokes.hairline),
                      decoration: BoxDecoration(border: Border.all(color: paw.error, width: Strokes.strong), borderRadius: BorderRadius.circular(Radii.xs)),
                      child: Text(l.vaultSample.toUpperCase(), style: context.text.labelSmall?.copyWith(color: paw.error, fontWeight: FontWeight.w800, fontSize: TypeScale.stamp, letterSpacing: Tracking.stamp)),
                    ),
                  ),
                ),
            ]),
          ),
        ),
        const SizedBox(height: Space.sm),
        Text(doc.title, style: context.text.labelLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
        Text(sub, style: context.text.bodySmall?.copyWith(color: paw.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
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
        ? StatusChip(l.vaultNeedsReview, tone: ChipTone.accent, icon: Ph.sparkleFill)
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
          const Icon(Ph.caretRight),
        ]),
      ),
    );
  }
}

/// "96 MB of 25 GB used" with a bar (spec 7.11 storage quota).
class StorageMeter extends ConsumerWidget {
  const StorageMeter({super.key, this.note});

  /// The line under the bar instead of the documents and album split.
  final String? note;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final u = ref.watch(storageUsageProvider);
    if (u == null) return const Skeleton(height: Sizes.thumb, radius: Radii.card);
    return Semantics(
      label: '${l.vaultStorageTitle}: ${l.vaultStorageUsed(formatBytes(u.usedBytes), formatBytes(u.limitBytes))}',
      excludeSemantics: true,
      child: PawPanel(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            Expanded(child: Text(l.vaultStorageTitle, style: context.text.labelLarge)),
            Text(l.vaultStorageOf(formatBytes(u.usedBytes), formatBytes(u.limitBytes)), style: context.text.bodySmall?.copyWith(color: context.paw.textSecondary)),
          ]),
          const SizedBox(height: Space.sm),
          LevelBar(value: u.fraction < 0.01 && u.usedBytes > 0 ? 0.01 : u.fraction, color: u.nearlyFull ? context.paw.error : null),
          const SizedBox(height: Space.sm),
          Text(note ?? l.vaultStorageSplit(formatBytes(u.docsBytes), formatBytes(u.albumBytes)), style: context.text.bodySmall?.copyWith(color: context.paw.textSecondary)),
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
        icon: Icon(Ph.cloudSlash, color: ctx.paw.warning, size: IconSizes.xl),
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
