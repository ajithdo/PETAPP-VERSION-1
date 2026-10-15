import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/app_user.dart';
import '../../../core/data/converters.dart';
import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../partner/presentation/partner_shell.dart' show roleLabel;
import '../data/admin_repository.dart';
import '../domain/admin_rules.dart';
import 'admin_inputs.dart';
import 'support_labels.dart';

/// Admin approvals queue (spec 10): clinics, vets, groomers, trainers,
/// boarding and sitters, walkers and sellers. View KYC documents, check
/// registration numbers, approve, reject with a reason or suspend.
class AdminApprovals extends ConsumerStatefulWidget {
  const AdminApprovals({super.key});

  @override
  ConsumerState<AdminApprovals> createState() => _AdminApprovalsState();
}

class _AdminApprovalsState extends ConsumerState<AdminApprovals> {
  String _status = 'pending';
  String? _kind;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final list = ref.watch(adminPartnersProvider(_status));
    return AsyncView<List<PendingPartner>>(
      value: list,
      onRetry: () => ref.invalidate(adminPartnersProvider(_status)),
      data: (all) {
        final shown = _kind == null ? all : all.where((p) => p.kind == _kind).toList();
        final kinds = {for (final p in all) p.kind};
        return PageBody(maxWidth: 900, children: [
          const SizedBox(height: Space.md),
          ChoiceRow<String>(
            options: const ['pending', 'approved', 'rejected', 'suspended'],
            selected: _status,
            label: (s) => partnerStatusLabel(context, s),
            onSelected: (s) => setState(() {
              _status = s;
              _kind = null;
            }),
          ),
          if (kinds.length > 1) ...[
            const SizedBox(height: Space.sm),
            ChoiceRow<String?>(
              options: [null, ...partnerKindsForAdmin.where(kinds.contains)],
              selected: _kind,
              label: (k) => k == null ? l.admAllKinds : partnerKindLabel(context, k),
              onSelected: (k) => setState(() => _kind = k),
            ),
          ],
          const SizedBox(height: Space.md),
          if (_status == 'pending' && all.isNotEmpty) ...[
            Text(l.admWaitingCount(all.length), style: context.text.titleMedium),
            const SizedBox(height: Space.sm),
          ],
          if (shown.isEmpty) EmptyState(title: _status == 'pending' ? l.admNoPending : l.admNothingHere, compact: true),
          for (final p in shown)
            Padding(padding: const EdgeInsets.only(bottom: Space.md), child: _PartnerCard(partner: p)),
        ]);
      },
    );
  }
}

class _PartnerCard extends ConsumerStatefulWidget {
  const _PartnerCard({required this.partner});
  final PendingPartner partner;

  @override
  ConsumerState<_PartnerCard> createState() => _PartnerCardState();
}

class _PartnerCardState extends ConsumerState<_PartnerCard> {
  bool _busy = false;

  Future<void> _decide(String decision) async {
    final l = context.l10n;
    final p = widget.partner;
    var reason = '';
    if (decision != 'approve') {
      final r = await askReason(context, title: decision == 'reject' ? l.admRejectTitle(p.name) : l.admSuspendTitle(p.name),
          quick: [l.admReasonDocs, l.admReasonRegNo, l.admReasonDetails]);
      if (r == null || !mounted) return;
      reason = r;
    }
    final admin = ref.read(currentUserProvider);
    if (admin == null) return;
    setState(() => _busy = true);
    try {
      await ref.read(adminRepositoryProvider).review(admin, p, decision, reason: reason);
      if (!mounted) return;
      showToast(context, switch (decision) {
        'approve' => l.admApprovedToast(p.name),
        'reject' => l.admRejectedToast(p.name),
        _ => l.admSuspendedToast(p.name),
      });
    } catch (e) {
      if (mounted) showToast(context, l.errorTitle);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = widget.partner;
    final needsReg = p.kind == 'clinic' || p.kind == 'vet';
    final phone = p.raw['phone'] as String?;
    final email = p.raw['email'] as String?;
    final address = (p.raw['address'] as String?) ?? (p.raw['area'] as String?);
    return PawCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          CircleAvatar(child: Icon(partnerKindIcon(p.kind), size: 20)),
          const SizedBox(width: Space.md),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(p.name, style: context.text.titleMedium),
              Text(
                [partnerKindLabel(context, p.kind), if (p.city.isNotEmpty) p.city, l.admAppliedOn(Fmt.date(p.createdAt, context.lang))].join(' · '),
                style: context.text.bodySmall,
              ),
            ]),
          ),
          const SizedBox(width: Space.sm),
          StatusChip(partnerStatusLabel(context, p.status), tone: partnerStatusTone(p.status)),
        ]),
        if (phone != null || email != null || address != null) ...[
          const SizedBox(height: Space.sm),
          Text([?address, ?phone, ?email].join(' · '), style: context.text.bodySmall),
        ],
        if (needsReg) ...[
          const SizedBox(height: Space.sm),
          Wrap(spacing: Space.sm, runSpacing: Space.xs, crossAxisAlignment: WrapCrossAlignment.center, children: [
            Text(l.admRegNo(p.regNo ?? '–'), style: context.text.bodyMedium),
            if (p.regNo == null)
              StatusChip(l.admRegMissing, tone: ChipTone.error, icon: Icons.error_outline_rounded)
            else if (regNoLooksValid(p.regNo))
              StatusChip(l.admRegLooksRight, tone: ChipTone.success, icon: Icons.check_circle_outline_rounded)
            else
              StatusChip(l.admRegCheck, tone: ChipTone.warning, icon: Icons.warning_amber_rounded),
          ]),
          if (p.regNo != null)
            Padding(padding: const EdgeInsets.only(top: 2), child: Text(l.admRegHint, style: context.text.bodySmall)),
        ],
        const SizedBox(height: Space.sm),
        Text(l.admKycDocs, style: context.text.titleSmall),
        const SizedBox(height: Space.xs),
        if (p.kycDocs.isEmpty)
          Text(l.admNoDocs, style: context.text.bodySmall?.copyWith(color: context.paw.warning))
        else
          Wrap(spacing: Space.sm, runSpacing: Space.sm, children: [
            for (final d in p.kycDocs)
              ActionChip(
                avatar: const Icon(Icons.description_rounded, size: 18),
                label: Text(d),
                onPressed: () => _showDoc(context, p, d),
              ),
          ]),
        if (p.reason.isNotEmpty) ...[
          const SizedBox(height: Space.sm),
          InfoNote(l.admReasonGiven(p.reason), tone: ChipTone.warning),
        ],
        const SizedBox(height: Space.md),
        Wrap(spacing: Space.sm, runSpacing: Space.sm, alignment: WrapAlignment.end, children: [
          if (p.status != 'approved')
            PrimaryButton(label: p.status == 'pending' ? l.admApprove : l.admReinstate, icon: Icons.check_rounded, expand: false, loading: _busy, onPressed: () => _decide('approve')),
          if (p.status == 'pending') SecondaryButton(label: l.admReject, icon: Icons.close_rounded, expand: false, onPressed: _busy ? null : () => _decide('reject')),
          if (p.status == 'approved')
            SecondaryButton(label: l.admSuspend, icon: Icons.block_rounded, expand: false, onPressed: _busy ? null : () => _decide('suspend')),
        ]),
      ]),
    );
  }

  void _showDoc(BuildContext context, PendingPartner p, String doc) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(doc),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: ctx.paw.primaryContainer,
              borderRadius: BorderRadius.circular(Radii.card),
              border: Border.all(color: ctx.paw.outline),
            ),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.description_rounded, size: 56, color: ctx.colors.primary),
              const SizedBox(height: Space.sm),
              Text(p.name, style: ctx.text.titleSmall, textAlign: TextAlign.center),
              Text(ctx.l10n.admSampleStamp, style: ctx.text.labelLarge?.copyWith(color: ctx.paw.error, letterSpacing: 2)),
            ]),
          ),
          const SizedBox(height: Space.md),
          Text(ctx.l10n.admDocDemoNote, style: ctx.text.bodySmall),
        ]),
        actions: [FilledButton(onPressed: () => Navigator.pop(ctx), child: Text(ctx.l10n.ok))],
      ),
    );
  }
}

// ---------------------------------------------------------------- users

/// Admin users list (spec 10): search, view, suspend and change roles.
class AdminUsers extends ConsumerStatefulWidget {
  const AdminUsers({super.key});

  @override
  ConsumerState<AdminUsers> createState() => _AdminUsersState();
}

class _AdminUsersState extends ConsumerState<AdminUsers> {
  String _q = '';
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final users = ref.watch(adminUsersProvider);
    return AsyncView<List<Map<String, dynamic>>>(
      value: users,
      onRetry: () => ref.invalidate(adminUsersProvider),
      data: (all) {
        final q = _q.trim().toLowerCase();
        final shown = all.where((u) {
          final role = (u['role'] as String?) ?? 'owner';
          final ok = switch (_filter) {
            'owners' => role == 'owner',
            'partners' => role != 'owner' && role != 'admin',
            'admins' => role == 'admin',
            'plus' => u['plan'] == 'plus' || u['plan'] == 'trial',
            'suspended' => u['suspended'] == true,
            _ => true,
          };
          if (!ok) return false;
          if (q.isEmpty) return true;
          return [u['name'], u['email'], u['phone'], u['city']].whereType<String>().any((s) => s.toLowerCase().contains(q));
        }).toList();
        return PageBody(maxWidth: 900, children: [
          const SizedBox(height: Space.md),
          PawTextField(
            label: l.admSearchUsers,
            prefixIcon: Icons.search_rounded,
            onChanged: (v) => setState(() => _q = v),
          ),
          const SizedBox(height: Space.sm),
          ChoiceRow<String>(
            options: const ['all', 'owners', 'partners', 'admins', 'plus', 'suspended'],
            selected: _filter,
            label: (f) => switch (f) {
              'owners' => l.admFilterOwners,
              'partners' => l.admFilterPartners,
              'admins' => l.admFilterAdmins,
              'plus' => l.planPlus,
              'suspended' => l.admStatusSuspended,
              _ => l.admAllKinds,
            },
            onSelected: (f) => setState(() => _filter = f),
          ),
          const SizedBox(height: Space.sm),
          Text(l.admPeopleCount(shown.length), style: context.text.bodySmall),
          const SizedBox(height: Space.sm),
          if (shown.isEmpty) EmptyState(title: l.admNothingHere, compact: true),
          for (final u in shown) _UserTile(user: u),
        ]);
      },
    );
  }
}

class _UserTile extends ConsumerWidget {
  const _UserTile({required this.user});
  final Map<String, dynamic> user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final role = UserRole.parse(user['role'] as String?);
    final plan = (user['plan'] as String?) ?? 'free';
    final suspended = user['suspended'] == true;
    final name = (user['name'] as String?) ?? '';
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.sm),
      child: PawCard(
        padding: const EdgeInsets.symmetric(horizontal: Space.md, vertical: Space.sm),
        onTap: () => showUserSheet(context, ref, user),
        child: Row(children: [
          CircleAvatar(child: Text(name.isEmpty ? '?' : name.characters.first.toUpperCase())),
          const SizedBox(width: Space.md),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name, style: context.text.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
              Text([user['email'], user['phone']].whereType<String>().where((s) => s.isNotEmpty).join(' · '),
                  style: context.text.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Wrap(spacing: Space.xs, runSpacing: Space.xs, children: [
                StatusChip(roleLabel(context, role), tone: role == UserRole.admin ? ChipTone.accent : (role.isPartner ? ChipTone.info : ChipTone.neutral)),
                if (plan == 'plus') StatusChip(l.planPlus, tone: ChipTone.accent, icon: Icons.workspace_premium_rounded),
                if (plan == 'trial') StatusChip(l.plusTrialChip, tone: ChipTone.accent),
                if (suspended) StatusChip(l.admStatusSuspended, tone: ChipTone.error, icon: Icons.block_rounded),
                if (user['deletionRequestedAt'] != null) StatusChip(l.admDeletionPending, tone: ChipTone.warning),
              ]),
            ]),
          ),
          const Icon(Icons.chevron_right_rounded),
        ]),
      ),
    );
  }
}

/// User details with role and suspension controls.
Future<void> showUserSheet(BuildContext context, WidgetRef ref, Map<String, dynamic> user) {
  return showPawSheet<void>(context, builder: (_) => _UserSheet(user: user));
}

class _UserSheet extends ConsumerStatefulWidget {
  const _UserSheet({required this.user});
  final Map<String, dynamic> user;

  @override
  ConsumerState<_UserSheet> createState() => _UserSheetState();
}

class _UserSheetState extends ConsumerState<_UserSheet> {
  late UserRole _role = UserRole.parse(widget.user['role'] as String?);
  bool _busy = false;

  String get _uid => widget.user['id'] as String;

  Future<void> _saveRole() async {
    final l = context.l10n;
    final admin = ref.read(currentUserProvider)!;
    final ok = await confirmAction(context, title: l.admRoleConfirm(widget.user['name'] as String? ?? '', roleLabel(context, _role)), danger: false);
    if (!ok || !mounted) return;
    setState(() => _busy = true);
    try {
      await ref.read(adminRepositoryProvider).setRole(admin, _uid, _role.key);
      if (mounted) showToast(context, l.admRoleChanged);
    } catch (_) {
      if (mounted) showToast(context, l.errorTitle);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _toggleSuspend(bool suspend) async {
    final l = context.l10n;
    final admin = ref.read(currentUserProvider)!;
    final name = widget.user['name'] as String? ?? '';
    String reason = '';
    if (suspend) {
      final r = await askReason(context, title: l.admSuspendUserTitle(name), quick: [l.admReasonAbuse, l.admReasonFraud, l.admReasonFake]);
      if (r == null || !mounted) return;
      reason = r;
    }
    setState(() => _busy = true);
    try {
      await ref.read(adminRepositoryProvider).setSuspended(admin, _uid, suspend, reason: reason);
      if (!mounted) return;
      showToast(context, suspend ? l.admUserSuspended(name) : l.admUserRestored(name));
      Navigator.pop(context);
    } catch (_) {
      if (mounted) showToast(context, l.errorTitle);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final u = widget.user;
    final me = ref.watch(currentUserProvider);
    final isMe = me?.uid == _uid;
    final current = UserRole.parse(u['role'] as String?);
    final suspended = u['suspended'] == true;
    final created = parseDate(u['createdAt']);
    final renews = parseDate(u['planRenewsAt']);
    final trialEnds = parseDate(u['trialEndsAt']);
    final deletion = parseDate(u['deletionRequestedAt']);
    Widget row(String label, String value) => Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(width: 120, child: Text(label, style: context.text.bodySmall)),
            Expanded(child: Text(value, style: context.text.bodyMedium)),
          ]),
        );
    final plan = (u['plan'] as String?) ?? 'free';
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text((u['name'] as String?) ?? '', style: context.text.titleLarge),
      const SizedBox(height: Space.sm),
      row(l.email, (u['email'] as String?) ?? '–'),
      row(l.phone, (u['phone'] as String?) ?? '–'),
      if ((u['city'] as String?)?.isNotEmpty == true) row(l.admCity, u['city'] as String),
      row(l.admPlanLabel, switch (plan) {
        'plus' => renews == null ? l.planPlus : l.admPlusTill(Fmt.date(renews, context.lang)),
        'trial' => trialEnds == null ? l.plusTrialChip : l.admTrialTill(Fmt.date(trialEnds, context.lang)),
        _ => l.planFree,
      }),
      if (created != null) row(l.admJoined, Fmt.date(created, context.lang)),
      if (u['referralCode'] != null) row(l.referYourCode, u['referralCode'] as String),
      if (deletion != null) ...[
        const SizedBox(height: Space.sm),
        InfoNote(l.admDeletionOn(Fmt.date(deletion.add(const Duration(days: 30)), context.lang)), tone: ChipTone.warning),
      ],
      if (suspended && (u['suspendReason'] as String?)?.isNotEmpty == true) ...[
        const SizedBox(height: Space.sm),
        InfoNote(l.admReasonGiven(u['suspendReason'] as String), tone: ChipTone.error),
      ],
      const SizedBox(height: Space.md),
      Text(l.role, style: context.text.titleSmall),
      const SizedBox(height: Space.xs),
      DropdownButtonFormField<UserRole>(
        initialValue: _role,
        isExpanded: true,
        items: [for (final r in UserRole.values) DropdownMenuItem(value: r, child: Text(roleLabel(context, r)))],
        onChanged: isMe ? null : (r) => setState(() => _role = r ?? _role),
      ),
      if (isMe) Padding(padding: const EdgeInsets.only(top: 4), child: Text(l.admNotYourself, style: context.text.bodySmall)),
      const SizedBox(height: Space.sm),
      if (_role != current)
        PrimaryButton(label: l.admSaveRole, icon: Icons.save_rounded, loading: _busy, onPressed: _saveRole),
      const SizedBox(height: Space.sm),
      if (!isMe)
        suspended
            ? SecondaryButton(label: l.admUnsuspend, icon: Icons.lock_open_rounded, onPressed: _busy ? null : () => _toggleSuspend(false))
            : PrimaryButton(label: l.admSuspendUser, icon: Icons.block_rounded, danger: true, onPressed: _busy ? null : () => _toggleSuspend(true)),
      const SizedBox(height: Space.sm),
      TextButton(onPressed: () => Navigator.pop(context), child: Text(l.close)),
    ]);
  }
}
