import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../pets/data/pets_repository.dart';
import '../../pets/domain/pet.dart';
import '../data/vault_repository.dart';
import '../domain/auto_read.dart';
import '../domain/insurance.dart';
import '../domain/vault_models.dart';
import 'vault_labels.dart';
import 'vault_screen.dart' show DocTile;

/// Insurance tracker (spec 7.9): policies, cover, renewal and claims.
class InsuranceScreen extends ConsumerStatefulWidget {
  const InsuranceScreen({super.key, this.petId, this.docId});
  final String? petId;

  /// Opened from an insurance document: start a policy prefilled from it.
  final String? docId;

  @override
  ConsumerState<InsuranceScreen> createState() => _InsuranceScreenState();
}

class _InsuranceScreenState extends ConsumerState<InsuranceScreen> {
  bool _opened = false;

  @override
  void initState() {
    super.initState();
    if (widget.docId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (_opened || !mounted) return;
        _opened = true;
        final doc = await ref.read(docProvider(widget.docId!).future);
        final pet = doc == null ? null : await ref.read(petProvider(doc.petId).future);
        if (mounted && pet != null) await showPolicySheet(context, ref, pet: pet, fromDoc: doc);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final pets = ref.watch(myPetsProvider).value ?? const <Pet>[];
    final byId = {for (final p in pets) p.id: p};
    final policies = widget.petId == null ? ref.watch(myPoliciesProvider) : ref.watch(petPoliciesProvider(widget.petId!));
    final pet = widget.petId == null ? null : byId[widget.petId];
    final addFor = pet ?? ref.watch(selectedPetProvider) ?? ref.watch(activePetsProvider).firstOrNull;
    return Scaffold(
      appBar: AppBar(title: Text(pet == null ? l.vaultInsuranceTitle : '${l.vaultInsuranceTitle} · ${pet.name}')),
      floatingActionButton: addFor == null
          ? null
          : FloatingActionButton.extended(
              onPressed: () => showPolicySheet(context, ref, pet: addFor, choosePet: widget.petId == null),
              icon: const Icon(Icons.add_rounded),
              label: Text(l.vaultAddPolicy),
            ),
      body: AsyncView<List<InsurancePolicy>>(
        value: policies,
        data: (list) {
          if (list.isEmpty) {
            return EmptyState(
              scene: Scene.vault,
              title: l.vaultNoPolicies,
              message: l.vaultNoPoliciesBody,
              actionLabel: addFor == null ? null : l.vaultAddPolicy,
              onAction: addFor == null ? null : () => showPolicySheet(context, ref, pet: addFor, choosePet: widget.petId == null),
            );
          }
          final sorted = [...list]..sort((a, b) => (a.renewal ?? DateTime(2100)).compareTo(b.renewal ?? DateTime(2100)));
          return PageBody(maxWidth: 820, children: [
            const SizedBox(height: Space.md),
            for (final p in sorted) _PolicyTile(policy: p, pet: byId[p.petId]),
            const SizedBox(height: Space.md),
            InfoNote(l.vaultInsuranceNote),
            const SizedBox(height: 72),
          ]);
        },
      ),
    );
  }
}

class _PolicyTile extends StatelessWidget {
  const _PolicyTile({required this.policy, required this.pet});
  final InsurancePolicy policy;
  final Pet? pet;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final open = policy.claims.where((c) => c.isOpen).length;
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.md),
      child: PawCard(
        onTap: () => context.push('/vault/insurance/${policy.id}'),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            if (pet != null) ...[
              PetAvatar(species: pet!.species, colorTag: pet!.colorTag, photoUrl: pet!.photoUrl, size: 40),
              const SizedBox(width: Space.md),
            ],
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(policy.provider, style: context.text.titleSmall),
                Text([if (pet != null) pet!.name, policy.policyNo].join(' · '), style: context.text.bodySmall),
              ]),
            ),
            renewalChip(context, policy.renewal),
          ]),
          const SizedBox(height: Space.md),
          Wrap(spacing: Space.lg, runSpacing: Space.sm, children: [
            _Fact(label: l.vaultCover, value: Fmt.inr(policy.cover)),
            _Fact(label: l.vaultPremium, value: l.vaultPremiumYear(Fmt.inr(policy.premium))),
            if (policy.renewal != null) _Fact(label: l.vaultFieldRenewal, value: Fmt.date(policy.renewal!, context.lang)),
            _Fact(label: l.vaultClaims, value: open > 0 ? l.vaultOpenClaims(open) : '${policy.claims.length}'),
          ]),
        ]),
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
        Text(label, style: context.text.bodySmall),
        Text(value, style: context.text.titleSmall),
      ]);
}

/// One policy with its claims.
class PolicyScreen extends ConsumerWidget {
  const PolicyScreen({super.key, required this.policyId});
  final String policyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final async = ref.watch(policyProvider(policyId));
    final policy = async.value;
    final pet = policy == null ? null : ref.watch(petProvider(policy.petId)).value;
    return Scaffold(
      appBar: AppBar(
        title: Text(policy?.provider ?? l.vaultInsuranceTitle, overflow: TextOverflow.ellipsis),
        actions: [
          if (policy != null && pet != null)
            PopupMenuButton<String>(
              tooltip: l.moreOptions,
              onSelected: (v) async {
                if (v == 'edit') {
                  await showPolicySheet(context, ref, pet: pet, existing: policy);
                  return;
                }
                if (v == 'delete') {
                  final ok = await confirmAction(context, title: l.vaultDeletePolicyQ, body: l.vaultDeletePolicyBody, confirmLabel: l.delete);
                  if (!ok) return;
                  await ref.read(vaultRepositoryProvider).deletePolicy(policy.id);
                  if (context.mounted) context.pop();
                }
              },
              itemBuilder: (_) => [
                PopupMenuItem(value: 'edit', child: ListTile(leading: const Icon(Icons.edit_rounded), title: Text(l.vaultEditPolicy))),
                PopupMenuItem(value: 'delete', child: ListTile(leading: const Icon(Icons.delete_outline_rounded), title: Text(l.delete))),
              ],
            ),
        ],
      ),
      floatingActionButton: policy == null
          ? null
          : FloatingActionButton.extended(
              onPressed: () => showClaimSheet(context, ref, policy),
              icon: const Icon(Icons.add_rounded),
              label: Text(l.vaultNewClaim),
            ),
      body: AsyncView<InsurancePolicy?>(
        value: async,
        data: (p) {
          if (p == null) return EmptyState(scene: Scene.search, title: l.vaultDocMissing);
          final doc = p.docId == null ? null : ref.watch(docProvider(p.docId!)).value;
          return PageBody(maxWidth: 820, children: [
            const SizedBox(height: Space.md),
            PawCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Row(children: [
                  if (pet != null) PetAvatar(species: pet.species, colorTag: pet.colorTag, photoUrl: pet.photoUrl, size: 44),
                  const SizedBox(width: Space.md),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(l.vaultPolicyFor(pet?.name ?? ''), style: context.text.titleMedium),
                      Text([p.policyNo, if (p.planName.isNotEmpty) p.planName].join(' · '), style: context.text.bodySmall),
                    ]),
                  ),
                  renewalChip(context, p.renewal),
                ]),
                const Divider(height: Space.xl),
                Wrap(spacing: Space.xl, runSpacing: Space.md, children: [
                  _Fact(label: l.vaultCover, value: Fmt.inr(p.cover)),
                  _Fact(label: l.vaultPremium, value: l.vaultPremiumYear(Fmt.inr(p.premium))),
                  if (p.start != null) _Fact(label: l.vaultFieldCoverStart, value: Fmt.date(p.start!, context.lang)),
                  if (p.renewal != null) _Fact(label: l.vaultFieldRenewal, value: Fmt.date(p.renewal!, context.lang)),
                ]),
                const SizedBox(height: Space.md),
                Text(l.vaultCoverLeft(Fmt.inr(p.coverLeft)), style: context.text.bodyMedium),
                const SizedBox(height: Space.xs),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: p.cover == 0 ? 0 : p.coverLeft / p.cover,
                    minHeight: 8,
                    color: context.paw.success,
                    backgroundColor: context.paw.outline,
                  ),
                ),
              ]),
            ),
            SectionHeader(l.vaultPolicyDoc),
            if (doc != null)
              DocTile(doc: doc, pet: pet)
            else
              PawCard(
                onTap: pet == null ? null : () => showPolicySheet(context, ref, pet: pet, existing: p),
                child: Row(children: [
                  const Icon(Icons.attach_file_rounded),
                  const SizedBox(width: Space.md),
                  Expanded(child: Text(l.vaultLinkDoc)),
                ]),
              ),
            SectionHeader(l.vaultClaims, action: l.vaultNewClaim, onAction: () => showClaimSheet(context, ref, p)),
            if (p.claims.isEmpty) PawCard(child: Text(l.vaultNoClaims)),
            for (final c in p.claims)
              Padding(
                padding: const EdgeInsets.only(bottom: Space.sm),
                child: PawCard(
                  onTap: () => showClaimSheet(context, ref, p, existing: c),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    Row(children: [
                      Expanded(child: Text(c.title, style: context.text.titleSmall)),
                      StatusChip(claimStatusLabel(context, c.status), tone: claimStatusTone(c.status)),
                    ]),
                    const SizedBox(height: 2),
                    Text(
                      [
                        Fmt.date(c.date, context.lang),
                        l.vaultClaimedAmount(Fmt.inr(c.amount)),
                        if (c.status == 'paid') l.vaultPaidAmount(Fmt.inr(c.settledAmount ?? c.amount)),
                      ].join(' · '),
                      style: context.text.bodySmall,
                    ),
                    const SizedBox(height: Space.sm),
                    Row(children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(value: checklistProgress(c.checklist), minHeight: 6, backgroundColor: context.paw.outline),
                        ),
                      ),
                      const SizedBox(width: Space.sm),
                      Text(
                        l.vaultChecklistProgress(c.checklist.values.where((v) => v).length, c.checklist.length),
                        style: context.text.labelSmall,
                      ),
                    ]),
                  ]),
                ),
              ),
            const SizedBox(height: Space.md),
            InfoNote(l.vaultInsuranceNote),
            const SizedBox(height: 72),
          ]);
        },
      ),
    );
  }
}

/// Add or edit a policy. [fromDoc] prefills it from an insurance document.
Future<void> showPolicySheet(BuildContext context, WidgetRef ref, {required Pet pet, InsurancePolicy? existing, VaultDoc? fromDoc, bool choosePet = false}) {
  return showPawSheet<void>(context, builder: (_) => _PolicySheet(pet: pet, existing: existing, fromDoc: fromDoc, choosePet: choosePet));
}

class _PolicySheet extends ConsumerStatefulWidget {
  const _PolicySheet({required this.pet, this.existing, this.fromDoc, this.choosePet = false});
  final Pet pet;
  final InsurancePolicy? existing;
  final VaultDoc? fromDoc;
  final bool choosePet;
  @override
  ConsumerState<_PolicySheet> createState() => _PolicySheetState();
}

class _PolicySheetState extends ConsumerState<_PolicySheet> {
  late Pet _pet = widget.pet;
  late final ExtractedDetails? _ex = widget.fromDoc?.extracted == null ? null : ExtractedDetails.fromMap(widget.fromDoc!.extracted!);
  late final _provider = TextEditingController(text: widget.existing?.provider ?? _ex?.insurer ?? '');
  late final _plan = TextEditingController(text: widget.existing?.planName ?? '');
  late final _no = TextEditingController(text: widget.existing?.policyNo ?? _ex?.policyNo ?? '');
  late final _cover = TextEditingController(text: '${widget.existing?.cover ?? _ex?.cover ?? ''}');
  late final _premium = TextEditingController(text: '${widget.existing?.premium ?? _ex?.premium ?? ''}');
  late DateTime? _start = widget.existing?.start ?? _ex?.coverStart;
  late DateTime? _renewal = widget.existing?.renewal ?? _ex?.expiry ?? widget.fromDoc?.expiry;
  late String? _docId = widget.existing?.docId ?? widget.fromDoc?.id;
  bool _busy = false;

  @override
  void dispose() {
    for (final c in [_provider, _plan, _no, _cover, _premium]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final l = context.l10n;
    if (_provider.text.trim().isEmpty || _no.text.trim().isEmpty) {
      showToast(context, l.fieldRequired);
      return;
    }
    setState(() => _busy = true);
    int n(TextEditingController c) => int.tryParse(c.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    await ref.read(vaultRepositoryProvider).savePolicy(
      widget.existing?.id,
      {
        'petId': _pet.id,
        'ownerId': widget.existing?.ownerId ?? ref.read(currentUserProvider)!.uid,
        'provider': _provider.text.trim(),
        'planName': _plan.text.trim(),
        'policyNo': _no.text.trim(),
        'cover': n(_cover),
        'premium': n(_premium),
        'start': _start,
        'renewal': _renewal,
        'docId': _docId,
      },
      pet: _pet,
      reminderTitle: l.vaultInsuranceReminderTitle(_pet.name),
    );
    if (mounted) {
      Navigator.pop(context);
      showToast(context, l.saved);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final pets = ref.watch(activePetsProvider);
    final docs = (ref.watch(petDocsProvider(_pet.id)).value ?? const <VaultDoc>[]).where((d) => d.type == 'insurance').toList();
    Future<DateTime?> pick(DateTime? v) async {
      final now = DateTime.now();
      return showDatePicker(context: context, firstDate: DateTime(now.year - 10), lastDate: DateTime(now.year + 10), initialDate: v ?? now);
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(widget.existing == null ? l.vaultAddPolicy : l.vaultEditPolicy, style: context.text.titleMedium),
      const SizedBox(height: Space.md),
      if (widget.choosePet && widget.existing == null && pets.length > 1) ...[
        Wrap(spacing: Space.sm, runSpacing: Space.sm, children: [
          for (final p in pets)
            ChoiceChip(
              avatar: PetAvatar(species: p.species, colorTag: p.colorTag, photoUrl: p.photoUrl, size: 24),
              showCheckmark: false,
              label: Text(p.name),
              selected: p.id == _pet.id,
              onSelected: (_) => setState(() {
                _pet = p;
                _docId = null;
              }),
            ),
        ]),
        const SizedBox(height: Space.md),
      ],
      PawTextField(label: l.vaultFieldInsurer, controller: _provider),
      PawTextField(label: l.vaultPlanName, controller: _plan),
      PawTextField(label: l.vaultFieldPolicyNo, controller: _no),
      PawTextField(label: l.vaultFieldCover, controller: _cover, keyboardType: TextInputType.number, prefixText: '₹ ', inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
      PawTextField(label: l.vaultFieldPremium, controller: _premium, keyboardType: TextInputType.number, prefixText: '₹ ', inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
      OutlinedButton.icon(
        style: OutlinedButton.styleFrom(alignment: Alignment.centerLeft, minimumSize: const Size.fromHeight(52)),
        icon: const Icon(Icons.event_rounded),
        label: Text('${l.vaultFieldCoverStart}: ${_start == null ? '–' : Fmt.date(_start!, context.lang)}'),
        onPressed: () async {
          final d = await pick(_start);
          if (d != null) setState(() => _start = d);
        },
      ),
      const SizedBox(height: Space.sm),
      OutlinedButton.icon(
        style: OutlinedButton.styleFrom(alignment: Alignment.centerLeft, minimumSize: const Size.fromHeight(52)),
        icon: const Icon(Icons.event_repeat_rounded),
        label: Text('${l.vaultFieldRenewal}: ${_renewal == null ? '–' : Fmt.date(_renewal!, context.lang)}'),
        onPressed: () async {
          final d = await pick(_renewal);
          if (d != null) setState(() => _renewal = d);
        },
      ),
      const SizedBox(height: Space.md),
      DropdownButtonFormField<String?>(
        initialValue: docs.any((d) => d.id == _docId) ? _docId : null,
        isExpanded: true,
        decoration: InputDecoration(labelText: l.vaultPolicyDoc),
        items: [
          DropdownMenuItem<String?>(value: null, child: Text(l.vaultNoDocLinked)),
          for (final d in docs) DropdownMenuItem<String?>(value: d.id, child: Text(d.title, overflow: TextOverflow.ellipsis)),
        ],
        onChanged: (v) => setState(() => _docId = v),
      ),
      const SizedBox(height: Space.md),
      InfoNote(l.vaultRenewalReminderNote, icon: Icons.notifications_active_outlined),
      const SizedBox(height: Space.lg),
      PrimaryButton(label: l.save, icon: Icons.check_rounded, loading: _busy, onPressed: _save),
    ]);
  }
}

/// Add or update a claim: amount, status steps and the document checklist.
Future<void> showClaimSheet(BuildContext context, WidgetRef ref, InsurancePolicy policy, {Claim? existing}) {
  return showPawSheet<void>(context, builder: (_) => _ClaimSheet(policy: policy, existing: existing));
}

class _ClaimSheet extends ConsumerStatefulWidget {
  const _ClaimSheet({required this.policy, this.existing});
  final InsurancePolicy policy;
  final Claim? existing;
  @override
  ConsumerState<_ClaimSheet> createState() => _ClaimSheetState();
}

class _ClaimSheetState extends ConsumerState<_ClaimSheet> {
  late final _title = TextEditingController(text: widget.existing?.title ?? '');
  late final _amount = TextEditingController(text: widget.existing == null ? '' : '${widget.existing!.amount}');
  late final _settled = TextEditingController(text: widget.existing?.settledAmount?.toString() ?? '');
  late DateTime _date = widget.existing?.date ?? DateTime.now();
  late final String _status = widget.existing?.status ?? 'draft';
  late final Map<String, bool> _check = {...?widget.existing?.checklist};
  late final Map<String, String> _attach = {...?widget.existing?.attachments};
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _title.dispose();
    _amount.dispose();
    _settled.dispose();
    super.dispose();
  }

  Future<void> _save([String? moveTo]) async {
    final l = context.l10n;
    if (_title.text.trim().isEmpty) {
      setState(() => _error = l.fieldRequired);
      return;
    }
    final checklist = {for (final k in claimChecklistKeys) k: _check[k] ?? false};
    if (moveTo == 'submitted' && !readyToSubmit(checklist)) {
      setState(() => _error = l.vaultReadyToSubmit);
      return;
    }
    setState(() => _busy = true);
    int? n(TextEditingController c) => int.tryParse(c.text.replaceAll(RegExp(r'[^0-9]'), ''));
    final status = moveTo ?? _status;
    await ref.read(vaultRepositoryProvider).saveClaim(widget.policy, {
      'id': widget.existing?.id ?? 'cl_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(999)}',
      'title': _title.text.trim(),
      'date': _date,
      'amount': n(_amount) ?? 0,
      'settledAmount': status == 'paid' ? (n(_settled) ?? n(_amount)) : n(_settled),
      'status': status,
      'checklist': checklist,
      'attachments': _attach,
    });
    if (mounted) {
      Navigator.pop(context);
      showToast(context, l.vaultClaimSaved);
    }
  }

  Future<void> _attachDoc(String key) async {
    final docs = ref.read(petDocsProvider(widget.policy.petId)).value ?? const <VaultDoc>[];
    final picked = await showPawSheet<VaultDoc>(context, builder: (ctx) {
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(ctx.l10n.vaultAttachDoc, style: ctx.text.titleMedium),
        const SizedBox(height: Space.sm),
        for (final d in docs)
          ListTile(
            leading: DocTypeBadge(type: d.type, size: 36),
            title: Text(d.title),
            subtitle: Text(docTypeLabel(ctx, d.type)),
            onTap: () => Navigator.pop(ctx, d),
          ),
      ]);
    });
    if (picked != null) {
      setState(() {
        _attach[key] = picked.id;
        _check[key] = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final docs = {for (final d in ref.watch(petDocsProvider(widget.policy.petId)).value ?? const <VaultDoc>[]) d.id: d};
    final next = widget.existing == null ? const <String>[] : nextClaimStatuses(_status);
    final done = claimChecklistKeys.where((k) => _check[k] ?? false).length;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Row(children: [
        Expanded(child: Text(widget.existing == null ? l.vaultNewClaim : widget.existing!.title, style: context.text.titleMedium)),
        StatusChip(claimStatusLabel(context, _status), tone: claimStatusTone(_status)),
      ]),
      const SizedBox(height: Space.md),
      PawTextField(label: l.vaultClaimFor, hint: l.vaultClaimForHint, controller: _title),
      PawTextField(label: l.vaultClaimAmount, controller: _amount, keyboardType: TextInputType.number, prefixText: '₹ ', inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
      if (_status == 'approved' || _status == 'paid')
        PawTextField(label: l.vaultSettledAmount, controller: _settled, keyboardType: TextInputType.number, prefixText: '₹ ', inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
      OutlinedButton.icon(
        style: OutlinedButton.styleFrom(alignment: Alignment.centerLeft, minimumSize: const Size.fromHeight(52)),
        icon: const Icon(Icons.event_rounded),
        label: Text('${l.vaultClaimDate}: ${Fmt.date(_date, context.lang)}'),
        onPressed: () async {
          final now = DateTime.now();
          final d = await showDatePicker(context: context, firstDate: DateTime(now.year - 3), lastDate: now, initialDate: _date.isAfter(now) ? now : _date);
          if (d != null) setState(() => _date = d);
        },
      ),
      const SizedBox(height: Space.md),
      Row(children: [
        Expanded(child: Text(l.vaultClaimChecklist, style: context.text.titleSmall)),
        Text(l.vaultChecklistProgress(done, claimChecklistKeys.length), style: context.text.bodySmall),
      ]),
      for (final k in claimChecklistKeys)
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          value: _check[k] ?? false,
          onChanged: (v) => setState(() => _check[k] = v ?? false),
          title: Text(checklistLabel(context, k)),
          subtitle: _attach[k] != null && docs[_attach[k]] != null ? Text(l.vaultAttached(docs[_attach[k]]!.title)) : null,
          secondary: IconButton(
            tooltip: l.vaultAttachDoc,
            icon: Icon(_attach[k] != null ? Icons.attach_file_rounded : Icons.attach_file_outlined, color: _attach[k] != null ? context.colors.primary : null),
            onPressed: () => _attachDoc(k),
          ),
        ),
      if (_error != null) ...[
        const SizedBox(height: Space.sm),
        Text(_error!, style: context.text.bodySmall?.copyWith(color: context.paw.error)),
      ],
      const SizedBox(height: Space.lg),
      PrimaryButton(label: l.save, icon: Icons.check_rounded, loading: _busy, onPressed: () => _save()),
      for (final s in next) ...[
        const SizedBox(height: Space.sm),
        SecondaryButton(label: l.vaultMarkAs(claimStatusLabel(context, s)), onPressed: _busy ? null : () => _save(s)),
      ],
    ]);
  }
}
