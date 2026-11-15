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
import '../../plans/domain/plan_rules.dart';
import '../../plans/presentation/plus_prompt.dart';
import '../data/family_repository.dart';
import '../../../core/theme/ph.dart';

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
          bottom: TabBar(isScrollable: true, tabAlignment: TabAlignment.start, tabs: [Tab(text: l.people), Tab(text: l.activity)]),
        ),
        body: TabBarView(children: [
          PageBody(maxWidth: Space.readingWidth, children: [
            if (invites.isNotEmpty) ...[
              SectionHeader(l.invitesForYou),
              for (final inv in invites) _ReceivedInvite(invite: inv, user: user),
            ],
            const SizedBox(height: Space.md),
            // UI Design 6: the three roles side by side, in plain words.
            Semantics(
              label: l.familyRolesHelp,
              excludeSemantics: true,
              child: LayoutBuilder(builder: (context, c) {
                final roles = [
                  (Ph.eye, l.roleViewer, l.roleViewerHint),
                  (Ph.handHeart, l.roleCarer, l.roleCarerHint),
                  (Ph.users, l.roleCoowner, l.roleCoownerHint),
                ];
                // Three across, as in the design; one per row with big text.
                final cols = c.maxWidth >= 300 && MediaQuery.textScalerOf(context).scale(1) < 1.15 ? 3 : 1;
                return TileGrid(columns: cols, spacing: Space.sm, children: [
                  for (final r in roles)
                    Container(
                      padding: const EdgeInsets.all(Space.md),
                      decoration: BoxDecoration(color: context.paw.surfaceSubtle, borderRadius: BorderRadius.circular(Radii.lg)),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Icon(r.$1, size: IconSizes.md, color: context.paw.textPrimary),
                        const SizedBox(height: Space.sm),
                        Text(r.$2, style: context.text.labelLarge),
                        Text(r.$3, style: context.text.bodySmall?.copyWith(color: context.paw.textSecondary)),
                      ]),
                    ),
                ]);
              }),
            ),
            for (final p in ordered) _PetMembersCard(pet: p, user: user),
            if (pets.isEmpty) EmptyState(title: l.noPetsTitle, compact: true),
            // A sitter or walker for a few days: Carer access with an end date.
            if (ordered.any((p) => p.canEdit(user.uid))) ...[
              const SizedBox(height: Space.lg),
              PawPanel(
                padding: PawPanel.listPadding,
                child: PawItem(
                  lead: const PawTile(icon: Ph.calendarX, tone: Tone.gold),
                  title: l.familyAway,
                  sub: l.familyAwayBody,
                  subMaxLines: 4,
                  onTap: () => _inviteTo(context, ref, ordered.firstWhere((p) => p.canEdit(user.uid)), user, sitter: true),
                ),
              ),
            ],
            if (pets.isNotEmpty) Builder(builder: (context) => _LatestActivity(pets: pets, user: user, onSeeAll: () => DefaultTabController.of(context).animateTo(1))),
            const SizedBox(height: Space.xl),
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
        color: context.paw.primaryContainer.withValues(alpha: Opacities.half),
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
    final limit = (ref.watch(planLimitsProvider)['family'] as num?)?.toInt() ?? 2;
    final paw = context.paw;
    String does(String uid, String role) => uid == pet.ownerId
        ? l.roleOwnerDoes
        : switch (role) {
            'coowner' => l.roleCoownerDoes,
            'carer' => l.roleCarerDoes,
            _ => l.roleViewerDoes,
          };
    return Padding(
      padding: const EdgeInsets.only(top: Space.lg),
      child: PawCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          // The pet, how many people share it, and Invite.
          Row(children: [
            PetAvatar(species: pet.species, colorTag: pet.colorTag, photoUrl: pet.photoUrl, size: Sizes.avatarLg, name: pet.name),
            const SizedBox(width: Space.md),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(pet.name, style: context.text.labelLarge),
                Text(isUnlimited(limit) ? l.peopleCount(pet.members.length) : l.peopleOf(pet.members.length, pet.members.length > limit ? pet.members.length : limit), style: context.text.bodySmall?.copyWith(color: paw.textSecondary)),
              ]),
            ),
            if (canManage) PawButton(label: l.invite, icon: Ph.userPlus, onPressed: () => _inviteTo(context, ref, pet, user)),
          ]),
          const SizedBox(height: Space.sm),
          // People are circles with initials (the owner's is ink): the name,
          // what the access covers, and the role as a tag.
          PawList(children: [
            for (final e in pet.members.entries)
              PawItem(
                lead: Container(
                  width: Sizes.tile,
                  height: Sizes.tile,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: e.key == pet.ownerId ? paw.textPrimary : context.tint.paper3, shape: BoxShape.circle),
                  child: Text(
                    initials(e.value.name),
                    style: context.text.labelLarge?.copyWith(color: e.key == pet.ownerId ? paw.background : paw.textPrimary, fontFamily: FontFamilies.heading, fontWeight: FontWeight.w700),
                  ),
                ),
                title: e.value.name + (e.key == user.uid ? ' (${l.you})' : ''),
                sub: e.value.expiresAt != null
                    ? (e.value.expiresAt!.isBefore(DateTime.now()) ? l.accessEnded : l.accessUntil(Fmt.dateTime(e.value.expiresAt!, context.lang)))
                    : does(e.key, e.value.role),
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                  PawTag(petRoleLabel(context, e.value.role), kind: e.key == pet.ownerId || e.value.expiresAt != null ? TagKind.gold : TagKind.neutral),
                  if (canManage && e.key != pet.ownerId && e.key != user.uid)
                    PopupMenuButton<String>(
                      tooltip: l.moreOptions,
                      icon: Icon(Ph.dotsThreeVertical, color: paw.textPrimary),
                      onSelected: (v) => _memberAction(context, ref, v, e.key, e.value),
                      itemBuilder: (_) => [
                        PopupMenuItem(value: 'role', child: Text(l.changeRole)),
                        PopupMenuItem(value: 'remove', child: Text(l.removeAccess)),
                      ],
                    ),
                ]),
              ),
          ]),
          for (final inv in sent)
            ListTile(
              leading: const CircleAvatar(child: Icon(Ph.hourglassHigh)),
              title: Text(inv.contact ?? l.inviteLink),
              subtitle: Text(l.invitePending(petRoleLabel(context, inv.role))),
              trailing: canManage
                  ? IconButton(
                      tooltip: l.cancelInvite,
                      icon: const Icon(Ph.x),
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

}

/// Invites someone to help with [pet]. [sitter] opens the sheet set to
/// Carer access with an end date ("Going away?").
Future<void> _inviteTo(BuildContext context, WidgetRef ref, Pet pet, AppUser user, {bool sitter = false}) async {
final currentOthers = pet.members.keys.where((k) => k != pet.ownerId).length;
  final l = context.l10n;
  final limit = (ref.read(planLimitsProvider)['family'] as num?)?.toInt() ?? 2;
  if (currentOthers >= limit) {
    await showPlusPrompt(context, title: l.familyLimitTitle(limit), body: l.familyLimitBody);
    return;
  }
  final result = await _InviteSheet.show(context, pet, sitter: sitter);
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
            icon: Ph.shareNetwork,
            onPressed: () => SharePlus.instance.share(ShareParams(text: l.inviteShareText(pet.name, link))),
          ),
          const SizedBox(height: Space.sm),
          SecondaryButton(
            label: l.copyLink,
            icon: Ph.copy,
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

typedef _InviteResult = ({String? contact, String role, DateTime? expiresAt});

class _InviteSheet extends StatefulWidget {
  const _InviteSheet({required this.pet, this.sitter = false});
  final Pet pet;

  /// Start on Carer access with an end date.
  final bool sitter;

  static Future<_InviteResult?> show(BuildContext context, Pet pet, {bool sitter = false}) => showModalBottomSheet<_InviteResult>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        constraints: const BoxConstraints(maxWidth: Sizes.sheetMaxWidth),
        builder: (_) => _InviteSheet(pet: pet, sitter: sitter),
      );

  @override
  State<_InviteSheet> createState() => _InviteSheetState();
}

class _InviteSheetState extends State<_InviteSheet> {
  String _how = 'phone';
  String _role = 'carer';
  late bool _sitter = widget.sitter;
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
              ButtonSegment(value: 'phone', label: Text(l.phone), icon: const Icon(Ph.phone)),
              ButtonSegment(value: 'email', label: Text(l.email), icon: const Icon(Ph.envelopeSimple)),
              ButtonSegment(value: 'link', label: Text(l.link), icon: const Icon(Ph.link)),
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
              icon: const Icon(Ph.calendarBlank),
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
    final user = ref.watch(currentUserProvider);
    final stream = ref.watch(_activityProvider(petIds.join(',')));
    return AsyncView(
      value: stream,
      data: (items) {
        if (items.isEmpty) return EmptyState(title: l.noActivityTitle, message: l.noActivityBody, scene: Scene.chat);
        return PageBody(maxWidth: Space.readingWidth, children: [
          const SizedBox(height: Space.md),
          for (final (i, a) in items.indexed) _ActivityRow(item: a, pets: pets, me: user, first: i == 0, last: i == items.length - 1),
          const SizedBox(height: Space.xl),
        ]);
      },
    );
  }
}

/// The last few things anyone did, under the people; "See all" opens the
/// Activity tab.
class _LatestActivity extends ConsumerWidget {
  const _LatestActivity({required this.pets, required this.user, required this.onSeeAll});
  final List<Pet> pets;
  final AppUser user;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = (ref.watch(_activityProvider(pets.map((p) => p.id).join(','))).value ?? const <ActivityItem>[]).take(4).toList();
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const SizedBox(height: Sizes.sectionGap),
      SecHead(context.l10n.latestActivity, action: context.l10n.seeAll, onAction: onSeeAll),
      for (final (i, a) in items.indexed) _ActivityRow(item: a, pets: pets, me: user, first: i == 0, last: i == items.length - 1),
    ]);
  }
}

/// One thing someone did: when, who (their initials, joined to the next by
/// a short line) and what, with the person's name in bold.
class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.item, required this.pets, required this.me, this.first = false, this.last = false});
  final ActivityItem item;
  final List<Pet> pets;
  final AppUser? me;
  final bool first;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final paw = context.paw;
    final a = item;
    final text = activityText(context, a, pets);
    final who = a.actorName.split(' ').first;
    final mine = me != null && a.actorName == me!.name;
    final today = Fmt.sameDay(a.createdAt, DateTime.now());
    final small = context.text.labelSmall?.copyWith(color: paw.textSecondary, fontWeight: FontWeight.w500);
    return Semantics(
      container: true,
      label: '${Fmt.dateTime(a.createdAt, context.lang)}. $text',
      excludeSemantics: true,
      child: IntrinsicHeight(
        child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          SizedBox(
            width: Sizes.timelineTime,
            child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(Fmt.time(a.createdAt, context.lang), style: small, textAlign: TextAlign.right),
              Text(today ? context.l10n.today.toLowerCase() : Fmt.dateShort(a.createdAt, context.lang), style: small, textAlign: TextAlign.right),
            ]),
          ),
          const SizedBox(width: Space.md),
          Column(children: [
            Expanded(child: Container(width: Strokes.focus, color: first ? null : paw.outline)),
            Container(
              width: Sizes.buttonSmall,
              height: Sizes.buttonSmall,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: mine ? paw.textPrimary : context.tint.paper3, shape: BoxShape.circle),
              child: Text(initials(a.actorName), style: context.text.labelMedium?.copyWith(color: mine ? paw.background : paw.textPrimary, fontWeight: FontWeight.w700)),
            ),
            Expanded(child: Container(width: Strokes.focus, color: last ? null : paw.outline)),
          ]),
          const SizedBox(width: Space.md),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: Space.md),
              child: Align(
                alignment: Alignment.centerLeft,
                child: who.isNotEmpty && text.startsWith(who)
                    ? Text.rich(TextSpan(children: [
                        TextSpan(text: who, style: const TextStyle(fontWeight: FontWeight.w700)),
                        TextSpan(text: text.substring(who.length)),
                      ]), style: context.text.bodyMedium)
                    : Text(text, style: context.text.bodyMedium),
              ),
            ),
          ),
        ]),
      ),
    );
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
