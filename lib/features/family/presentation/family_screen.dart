import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/auth/app_user.dart';
import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../pets/data/pets_repository.dart';
import '../../pets/domain/pet.dart';
import '../../pets/presentation/pet_labels.dart';
import '../../plans/presentation/plus_prompt.dart';
import '../data/family_repository.dart';

/// Family and sharing (spec 6, 7.2): invites, roles, sitter access with an
/// end date, and the activity feed.
class FamilyScreen extends ConsumerStatefulWidget {
  const FamilyScreen({super.key, this.initialPetId});
  final String? initialPetId;
  @override
  ConsumerState<FamilyScreen> createState() => _FamilyScreenState();
}

class _FamilyScreenState extends ConsumerState<FamilyScreen> {
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final user = ref.watch(currentUserProvider)!;
    final pets = ref.watch(activePetsProvider);
    final invites = ref.watch(myInvitesProvider).value ?? const [];
    final focus = widget.initialPetId;
    final ordered = [...pets]..sort((a, b) => a.id == focus ? -1 : (b.id == focus ? 1 : 0));
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.familySharing),
          bottom: TabBar(tabs: [Tab(text: l.people), Tab(text: l.activity)]),
        ),
        body: TabBarView(children: [
          PageBody(maxWidth: 800, children: [
            if (invites.isNotEmpty) ...[
              SectionHeader(l.invitesForYou),
              for (final inv in invites) _ReceivedInvite(invite: inv, user: user),
            ],
            InfoNote(l.familyRolesHelp),
            for (final p in ordered) _PetMembersCard(pet: p, user: user),
            if (pets.isEmpty) EmptyState(title: l.noPetsTitle, compact: true),
          ]),
          _ActivityFeed(petIds: pets.map((p) => p.id).toList(), pets: pets),
        ]),
      ),
    );
  }
}

class _ReceivedInvite extends ConsumerWidget {
  const _ReceivedInvite({required this.invite, required this.user});
  final PetInvite invite;
  final AppUser user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.md),
      child: PawCard(
        color: context.paw.primaryContainer.withValues(alpha: 0.5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l.inviteReceived(invite.invitedByName, invite.petName, petRoleLabel(context, invite.role)),
              style: context.text.bodyLarge),
          if (invite.expiresAt != null)
            Text(l.accessUntil(Fmt.dateTime(invite.expiresAt!, context.lang)), style: context.text.bodySmall),
          const SizedBox(height: Space.md),
          Row(children: [
            Expanded(
              child: SecondaryButton(label: l.decline, onPressed: () => ref.read(familyRepositoryProvider).decline(invite)),
            ),
            const SizedBox(width: Space.md),
            Expanded(
              child: PrimaryButton(
                label: l.accept,
                onPressed: () async {
                  await ref.read(familyRepositoryProvider).accept(invite, user);
                  if (context.mounted) showToast(context, l.inviteAccepted(invite.petName));
                },
              ),
            ),
          ]),
        ]),
      ),
    );
  }
}

class _PetMembersCard extends ConsumerWidget {
  const _PetMembersCard({required this.pet, required this.user});
  final Pet pet;
  final AppUser user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final canManage = pet.canEdit(user.uid);
    final sent = ref.watch(sentInvitesProvider(pet.id)).value ?? const [];
    final others = pet.members.entries.where((e) => e.key != pet.ownerId).toList();
    return Padding(
      padding: const EdgeInsets.only(top: Space.lg),
      child: PawCard(
        padding: const EdgeInsets.symmetric(vertical: Space.sm),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          ListTile(
            leading: PetAvatar(species: pet.species, colorTag: pet.colorTag, photoUrl: pet.photoUrl, size: 44),
            title: Text(pet.name, style: context.text.titleMedium),
            subtitle: Text(l.peopleCount(pet.members.length)),
            trailing: canManage
                ? FilledButton.tonalIcon(
                    onPressed: () => _invite(context, ref, others.length),
                    icon: const Icon(Icons.person_add_rounded),
                    label: Text(l.invite),
                  )
                : null,
          ),
          const Divider(),
          for (final e in pet.members.entries)
            ListTile(
              leading: CircleAvatar(
                backgroundColor: context.paw.primaryContainer,
                child: Text(e.value.name.isEmpty ? '?' : e.value.name.characters.first),
              ),
              title: Text(e.value.name + (e.key == user.uid ? ' (${l.you})' : '')),
              subtitle: e.value.expiresAt == null
                  ? null
                  : Text(
                      e.value.expiresAt!.isBefore(DateTime.now())
                          ? l.accessEnded
                          : l.accessUntil(Fmt.dateTime(e.value.expiresAt!, context.lang)),
                      style: context.text.bodySmall?.copyWith(color: context.paw.warning),
                    ),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                StatusChip(petRoleLabel(context, e.value.role), tone: e.key == pet.ownerId ? ChipTone.accent : ChipTone.neutral),
                if (canManage && e.key != pet.ownerId && e.key != user.uid)
                  PopupMenuButton<String>(
                    tooltip: l.moreOptions,
                    onSelected: (v) => _memberAction(context, ref, v, e.key, e.value),
                    itemBuilder: (_) => [
                      PopupMenuItem(value: 'role', child: Text(l.changeRole)),
                      PopupMenuItem(value: 'remove', child: Text(l.removeAccess)),
                    ],
                  ),
              ]),
            ),
          for (final inv in sent)
            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.hourglass_top_rounded)),
              title: Text(inv.contact ?? l.inviteLink),
              subtitle: Text(l.invitePending(petRoleLabel(context, inv.role))),
              trailing: canManage
                  ? IconButton(
                      tooltip: l.cancelInvite,
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => ref.read(familyRepositoryProvider).cancelInvite(inv.id),
                    )
                  : null,
            ),
        ]),
      ),
    );
  }

  Future<void> _memberAction(BuildContext context, WidgetRef ref, String action, String uid, PetMember m) async {
    final l = context.l10n;
    final repo = ref.read(familyRepositoryProvider);
    if (action == 'remove') {
      final ok = await confirmAction(context, title: l.removeAccessConfirm(m.name, pet.name), confirmLabel: l.removeAccess);
      if (ok) await repo.removeMember(pet.id, uid, m.name, user);
      return;
    }
    final result = await _RoleSheet.show(context, initialRole: m.role, initialExpiry: m.expiresAt);
    if (result != null) await repo.changeRole(pet.id, uid, result.role, result.expiresAt, user);
  }

  Future<void> _invite(BuildContext context, WidgetRef ref, int currentOthers) async {
    final l = context.l10n;
    final limit = (ref.read(planLimitsProvider)['family'] as num?)?.toInt() ?? 2;
    if (currentOthers >= limit) {
      await showPlusPrompt(context, title: l.familyLimitTitle(limit), body: l.familyLimitBody);
      return;
    }
    final result = await _InviteSheet.show(context, pet);
    if (result == null) return;
    final inv = await ref.read(familyRepositoryProvider).invite(
          petId: pet.id,
          petName: pet.name,
          from: user,
          role: result.role,
          contact: result.contact,
          expiresAt: result.expiresAt,
        );
    if (!context.mounted) return;
    if (result.contact == null) {
      final link = 'https://pawsetu.app/#/join/${inv.token}';
      await showPawSheet<void>(context, builder: (ctx) => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(l.inviteLinkReady, style: ctx.text.titleMedium),
            const SizedBox(height: Space.md),
            SelectableText(link, style: ctx.text.bodyMedium),
            const SizedBox(height: Space.md),
            PrimaryButton(
              label: l.share,
              icon: Icons.share_rounded,
              onPressed: () => SharePlus.instance.share(ShareParams(text: l.inviteShareText(pet.name, link))),
            ),
            const SizedBox(height: Space.sm),
            SecondaryButton(
              label: l.copyLink,
              icon: Icons.copy_rounded,
              onPressed: () {
                Clipboard.setData(ClipboardData(text: link));
                Navigator.pop(ctx);
                showToast(context, l.copied);
              },
            ),
          ]));
    } else {
      showToast(context, l.inviteSent(result.contact!));
    }
  }
}

typedef _InviteResult = ({String? contact, String role, DateTime? expiresAt});

class _InviteSheet extends StatefulWidget {
  const _InviteSheet({required this.pet});
  final Pet pet;

  static Future<_InviteResult?> show(BuildContext context, Pet pet) => showModalBottomSheet<_InviteResult>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        constraints: const BoxConstraints(maxWidth: 640),
        builder: (_) => _InviteSheet(pet: pet),
      );

  @override
  State<_InviteSheet> createState() => _InviteSheetState();
}

class _InviteSheetState extends State<_InviteSheet> {
  String _how = 'phone';
  String _role = 'carer';
  bool _sitter = false;
  DateTime _until = DateTime.now().add(const Duration(days: 3));
  final _contact = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _contact.dispose();
    super.dispose();
  }

  void _send() {
    final l = context.l10n;
    String? contact;
    if (_how != 'link') {
      final v = _contact.text.trim();
      if (_how == 'phone' && v.replaceAll(RegExp(r'\D'), '').length != 10) {
        setState(() => _error = l.phoneInvalid);
        return;
      }
      if (_how == 'email' && !v.contains('@')) {
        setState(() => _error = l.authErrInvalidEmail);
        return;
      }
      contact = _how == 'phone' ? '+91$v' : v;
    }
    Navigator.pop(context, (contact: contact, role: _role, expiresAt: _sitter ? _until : null));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Padding(
      padding: EdgeInsets.fromLTRB(Space.lg, 0, Space.lg, Space.xl + MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(l.inviteTitle(widget.pet.name), style: context.text.titleMedium),
          const SizedBox(height: Space.md),
          SegmentedButton<String>(
            segments: [
              ButtonSegment(value: 'phone', label: Text(l.phone), icon: const Icon(Icons.phone_rounded)),
              ButtonSegment(value: 'email', label: Text(l.email), icon: const Icon(Icons.mail_rounded)),
              ButtonSegment(value: 'link', label: Text(l.link), icon: const Icon(Icons.link_rounded)),
            ],
            selected: {_how},
            onSelectionChanged: (s) => setState(() {
              _how = s.first;
              _error = null;
            }),
          ),
          const SizedBox(height: Space.md),
          if (_how != 'link')
            PawTextField(
              label: _how == 'phone' ? l.mobileNumber : l.email,
              controller: _contact,
              prefixText: _how == 'phone' ? '+91 ' : null,
              keyboardType: _how == 'phone' ? TextInputType.phone : TextInputType.emailAddress,
              inputFormatters: _how == 'phone' ? [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)] : null,
            ),
          if (_error != null) Text(_error!, style: TextStyle(color: context.paw.error)),
          Text(l.role, style: context.text.titleSmall),
          const SizedBox(height: Space.sm),
          _RolePicker(value: _role, onChanged: (r) => setState(() => _role = r)),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _sitter,
            onChanged: (v) => setState(() => _sitter = v),
            title: Text(l.temporaryAccess),
            subtitle: Text(l.temporaryAccessHint),
          ),
          if (_sitter)
            OutlinedButton.icon(
              icon: const Icon(Icons.event_rounded),
              label: Text(l.accessUntil(Fmt.date(_until, context.lang))),
              onPressed: () async {
                final d = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 90)),
                  initialDate: _until,
                );
                if (d != null) setState(() => _until = DateTime(d.year, d.month, d.day, 21));
              },
            ),
          const SizedBox(height: Space.lg),
          PrimaryButton(label: _how == 'link' ? l.createLink : l.sendInvite, onPressed: _send),
        ]),
      ),
    );
  }
}

class _RolePicker extends StatelessWidget {
  const _RolePicker({required this.value, required this.onChanged});
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return RadioGroup<String>(
      groupValue: value,
      onChanged: (v) => onChanged(v!),
      child: Column(children: [
        RadioListTile<String>(value: 'viewer', title: Text(l.roleViewer), subtitle: Text(l.roleViewerHint)),
        RadioListTile<String>(value: 'carer', title: Text(l.roleCarer), subtitle: Text(l.roleCarerHint)),
        RadioListTile<String>(value: 'coowner', title: Text(l.roleCoowner), subtitle: Text(l.roleCoownerHint)),
      ]),
    );
  }
}

class _RoleSheet {
  static Future<({String role, DateTime? expiresAt})?> show(BuildContext context,
      {required String initialRole, DateTime? initialExpiry}) {
    var role = initialRole;
    var expiry = initialExpiry;
    return showPawSheet(context, builder: (ctx) {
      final l = ctx.l10n;
      return StatefulBuilder(builder: (ctx, setState) => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(l.changeRole, style: ctx.text.titleMedium),
            _RolePicker(value: role, onChanged: (r) => setState(() => role = r)),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: expiry != null,
              onChanged: (v) => setState(() => expiry = v ? DateTime.now().add(const Duration(days: 3)) : null),
              title: Text(l.temporaryAccess),
            ),
            if (expiry != null) Text(l.accessUntil(Fmt.dateTime(expiry!, ctx.lang))),
            const SizedBox(height: Space.md),
            PrimaryButton(label: l.saveChanges, onPressed: () => Navigator.pop(ctx, (role: role, expiresAt: expiry))),
          ]));
    });
  }
}

class _ActivityFeed extends ConsumerWidget {
  const _ActivityFeed({required this.petIds, required this.pets});
  final List<String> petIds;
  final List<Pet> pets;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final stream = ref.watch(_activityProvider(petIds.join(',')));
    return AsyncView(
      value: stream,
      data: (items) {
        if (items.isEmpty) return EmptyState(title: l.noActivityTitle, message: l.noActivityBody, scene: Scene.chat);
        return PageBody(maxWidth: 800, children: [
          const SizedBox(height: Space.md),
          for (final a in items)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: _petAvatar(a.petId),
              title: Text(activityText(context, a, pets)),
              subtitle: Text(Fmt.dateTime(a.createdAt, context.lang)),
            ),
        ]);
      },
    );
  }

  Widget _petAvatar(String petId) {
    final p = pets.where((p) => p.id == petId).firstOrNull;
    if (p == null) return const CircleAvatar(child: Icon(Icons.pets_rounded));
    return PetAvatar(species: p.species, colorTag: p.colorTag, photoUrl: p.photoUrl, size: 40);
  }
}

final _activityProvider = StreamProvider.family<List<ActivityItem>, String>((ref, ids) {
  final list = ids.isEmpty ? <String>[] : ids.split(',');
  return ref.watch(familyRepositoryProvider).watchActivity(list);
});

/// "Ravi gave Bruno his medicine at 8:05 PM" style sentences.
String activityText(BuildContext context, ActivityItem a, List<Pet> pets) {
  final l = context.l10n;
  final pet = pets.where((p) => p.id == a.petId).firstOrNull?.name ?? '';
  final who = a.actorName.split(' ').first;
  final d = a.detail ?? '';
  return switch (a.type) {
    'medicine_given' => l.actMedicineGiven(who, pet, d),
    'walk_logged' => l.actWalk(who, pet, d),
    'meal_logged' => l.actMeal(who, pet),
    'member_added' || 'member_joined' => l.actMemberJoined(who, pet),
    'member_removed' => l.actMemberRemoved(who, d, pet),
    'role_changed' => l.actRoleChanged(who, pet),
    _ => l.actGeneric(who, pet),
  };
}
