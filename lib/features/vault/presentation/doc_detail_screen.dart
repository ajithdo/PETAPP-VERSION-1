import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/data/converters.dart';
import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../pets/data/pets_repository.dart';
import '../../pets/domain/pet.dart';
import '../data/vault_repository.dart';
import '../domain/auto_read.dart';
import '../domain/storage_quota.dart';
import '../domain/vault_models.dart';
import 'doc_preview.dart';
import 'share_sheet.dart';
import 'vault_labels.dart';

/// One document: secure preview, details, expiry, sharing (spec 7.9).
class DocDetailScreen extends ConsumerWidget {
  const DocDetailScreen({super.key, required this.docId});
  final String docId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final docAsync = ref.watch(docProvider(docId));
    final doc = docAsync.value;
    final pet = doc == null ? null : ref.watch(petProvider(doc.petId)).value;
    final user = ref.watch(currentUserProvider);
    final canEdit = doc != null && user != null && (doc.ownerId == user.uid || (pet?.canEdit(user.uid) ?? false));
    return Scaffold(
      appBar: AppBar(
        title: Text(doc?.title ?? l.vaultDocDetails, overflow: TextOverflow.ellipsis),
        actions: [
          if (doc != null && pet != null)
            IconButton(
              tooltip: l.vaultShareWithVet,
              icon: const Icon(Icons.ios_share_rounded),
              onPressed: () => showVaultShareSheet(context, ref, pet: pet, initialDocIds: [doc.id]),
            ),
          if (canEdit)
            PopupMenuButton<String>(
              tooltip: l.moreOptions,
              onSelected: (v) async {
                if (v == 'edit') context.push('/vault/doc/${doc.id}/read');
                if (v == 'delete') await _delete(context, ref, doc, pet);
              },
              itemBuilder: (_) => [
                PopupMenuItem(value: 'edit', child: ListTile(leading: const Icon(Icons.edit_rounded), title: Text(l.vaultEditDetails))),
                PopupMenuItem(
                  value: 'delete',
                  child: ListTile(leading: Icon(Icons.delete_outline_rounded, color: context.paw.error), title: Text(l.vaultDeleteDoc)),
                ),
              ],
            ),
        ],
      ),
      body: AsyncView<VaultDoc?>(
        value: docAsync,
        data: (d) {
          if (d == null) {
            return EmptyState(scene: Scene.search, title: l.vaultDocMissing, actionLabel: l.documentVault, onAction: () => context.go('/me/vault'));
          }
          return _Body(doc: d, pet: pet, canEdit: canEdit);
        },
      ),
    );
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, VaultDoc doc, Pet? pet) async {
    final l = context.l10n;
    final ok = await confirmAction(context, title: l.vaultDeleteDocQ(doc.title), body: l.vaultDeleteDocBody(pet?.name ?? ''), confirmLabel: l.delete);
    if (!ok) return;
    await ref.read(vaultRepositoryProvider).deleteDoc(doc);
    if (!context.mounted) return;
    showToast(context, l.vaultDeleted);
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/me/vault');
    }
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.doc, required this.pet, required this.canEdit});
  final VaultDoc doc;
  final Pet? pet;
  final bool canEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final lang = context.lang;
    final petName = pet?.name ?? '';
    final ex = doc.extracted == null || doc.readStatus != 'confirmed' ? null : ExtractedDetails.fromMap(doc.extracted!);
    final policies = ref.watch(petPoliciesProvider(doc.petId)).value ?? const [];
    final policy = policies.where((p) => p.docId == doc.id).firstOrNull;
    Widget row(String k, String v) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(width: 132, child: Text(k, style: context.text.bodySmall)),
            Expanded(child: Text(v, style: context.text.bodyMedium)),
          ]),
        );
    String? date(DateTime? d) => d == null ? null : Fmt.date(d, lang);
    final details = ex == null
        ? const <(String, String?)>[]
        : <(String, String?)>[
            (l.vaultFieldPetName, ex.petName),
            (l.vaccineName, ex.vaccineName),
            (l.dateGiven, date(ex.dateGiven)),
            (l.nextDueShort, date(ex.nextDue)),
            (l.vaccineBrand, ex.brand),
            (l.batchNumber, ex.batch),
            (l.vaultFieldInsurer, ex.insurer),
            (l.vaultFieldPolicyNo, ex.policyNo),
            (l.vaultFieldCover, ex.cover == null ? null : Fmt.inr(ex.cover!)),
            (l.vaultFieldPremium, ex.premium == null ? null : Fmt.inr(ex.premium!)),
            (l.vaultFieldCoverStart, date(ex.coverStart)),
            (l.vaultFieldTest, ex.testName),
            (l.vaultFieldAmount, ex.amount == null ? null : Fmt.inr(ex.amount!)),
            (l.vaultFieldReference, ex.referenceNo),
            (l.vaultFieldIssuer, ex.issuer),
            (l.vaultFieldIssuedOn, date(ex.issuedOn)),
            (l.vetName, ex.vetName),
            (l.vaultFieldVetReg, ex.vetRegNo),
            (l.clinicName, ex.clinicName),
          ];
    final confirmedAt = parseDate(doc.extracted?['confirmedAt']);
    return PageBody(maxWidth: 820, children: [
      const SizedBox(height: Space.md),
      if (doc.needsReview && canEdit) ...[
        PawCard(
          color: context.paw.accent.withValues(alpha: 0.16),
          onTap: () => context.push('/vault/doc/${doc.id}/read'),
          child: Row(children: [
            Icon(Icons.auto_awesome_rounded, color: context.paw.onAccent),
            const SizedBox(width: Space.md),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(l.vaultCheckDetails, style: context.text.titleSmall),
                Text(l.vaultCheckDetailsHint, style: context.text.bodySmall),
              ]),
            ),
            const Icon(Icons.chevron_right_rounded),
          ]),
        ),
        const SizedBox(height: Space.md),
      ],
      ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 560),
        child: DocPreview(doc: doc, petName: petName, onTap: () => openDocViewer(context, doc, petName)),
      ),
      const SizedBox(height: Space.xs),
      Text(l.vaultTapToZoom, textAlign: TextAlign.center, style: context.text.bodySmall),
      const SizedBox(height: Space.md),
      PawCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            DocTypeBadge(type: doc.type),
            const SizedBox(width: Space.md),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(doc.title, style: context.text.titleMedium),
                Text([docTypeLabel(context, doc.type), if (petName.isNotEmpty) petName].join(' · '), style: context.text.bodySmall),
              ]),
            ),
          ]),
          const SizedBox(height: Space.sm),
          Wrap(spacing: Space.xs, runSpacing: Space.xs, children: [
            ?expiryChip(context, doc.expiry),
            if (doc.isSample) StatusChip(l.vaultSample, tone: ChipTone.neutral),
            for (final t in doc.tags) StatusChip('#$t', tone: ChipTone.info),
          ]),
          const Divider(height: Space.xl),
          if (doc.expiry != null) row(l.vaultFieldExpiry, expiryText(context, doc.expiry!)),
          row(l.vaultAddedLabel, [Fmt.date(doc.createdAt, lang), if ((doc.raw['byName'] as String?)?.isNotEmpty ?? false) doc.raw['byName'] as String].join(' · ')),
          row(l.vaultFileType, doc.isPdf ? l.vaultPdf : (doc.isSample ? l.vaultSample : l.vaultPhoto)),
          if (doc.sizeBytes > 0) row(l.vaultFileSize, formatBytes(doc.sizeBytes)),
        ]),
      ),
      if (details.any((e) => e.$2 != null && e.$2!.isNotEmpty)) ...[
        SectionHeader(l.vaultDetailsRead),
        PawCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            for (final e in details)
              if (e.$2 != null && e.$2!.isNotEmpty) row(e.$1, e.$2!),
            if (confirmedAt != null) ...[
              const SizedBox(height: Space.sm),
              Text(l.vaultConfirmedBy((doc.extracted?['confirmedBy'] as String?) ?? '', Fmt.date(confirmedAt, lang)), style: context.text.bodySmall),
            ],
          ]),
        ),
      ],
      if (doc.type == 'vaccination' && doc.readStatus != 'pending' && doc.readStatus != 'skipped') ...[
        const SizedBox(height: Space.md),
        PawCard(
          onTap: () => context.go('/health?pet=${doc.petId}'),
          child: Row(children: [
            Icon(Icons.favorite_rounded, color: context.paw.error),
            const SizedBox(width: Space.md),
            Expanded(child: Text(l.vaultLinkedVaccine(petName))),
            const Icon(Icons.chevron_right_rounded),
          ]),
        ),
      ],
      if (doc.type == 'insurance') ...[
        const SizedBox(height: Space.md),
        PawCard(
          onTap: () => context.push(policy == null ? '/vault/insurance?pet=${doc.petId}&doc=${doc.id}' : '/vault/insurance/${policy.id}'),
          child: Row(children: [
            Icon(Icons.health_and_safety_rounded, color: context.colors.primary),
            const SizedBox(width: Space.md),
            Expanded(child: Text(policy == null ? l.vaultTrackPolicy : l.vaultOpenPolicy)),
            const Icon(Icons.chevron_right_rounded),
          ]),
        ),
      ],
      if (doc.link != null) ...[
        const SizedBox(height: Space.md),
        SecondaryButton(label: l.vaultOpenInApp, icon: Icons.open_in_new_rounded, onPressed: () => context.push(doc.link!)),
      ],
      const SizedBox(height: Space.lg),
      if (pet != null)
        PrimaryButton(
          label: l.vaultShareWithVet,
          icon: Icons.ios_share_rounded,
          onPressed: () => showVaultShareSheet(context, ref, pet: pet!, initialDocIds: [doc.id]),
        ),
      const SizedBox(height: Space.md),
      InfoNote(l.vaultSecureNote, icon: Icons.shield_rounded),
    ]);
  }
}
