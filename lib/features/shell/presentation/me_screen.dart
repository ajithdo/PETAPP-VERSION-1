import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../core/routing/extra_routes.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../admin/admin_slots.dart' show meItemVisible;
import '../../pets/data/pets_repository.dart';
import '../../pets/presentation/pet_labels.dart';
import '../../../core/theme/ph.dart';

/// "Me" tab (spec 5, UI Design 6): the account and its pets on top, the
/// everyday features (vault, album, lost pet mode, devices) as tiles, then
/// two short lists: orders and money, help and settings.
class MeScreen extends ConsumerWidget {
  const MeScreen({super.key});

  /// Shown as tiles under "Pets and family"; the rest of that group is a list.
  static const _tiles = ['/me/vault', '/me/album', '/me/lost', '/me/devices'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final paw = context.paw;
    final user = ref.watch(currentUserProvider);
    final items = meMenu(context).where((m) => meItemVisible(ref, m.route)).toList();
    final pets = ref.watch(activePetsProvider);
    final wide = context.screenSize == ScreenSize.desktop;
    final profile = PawCard(
      padding: const EdgeInsets.all(Space.lg),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          CircleAvatar(
            radius: Sizes.avatarLg / 2,
            backgroundColor: paw.brand,
            child: Text(initials(user?.name ?? ''), style: context.text.titleLarge?.copyWith(color: paw.onBrand)),
          ),
          const SizedBox(width: Space.md),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(user?.name.isNotEmpty == true ? user!.name : l.petParent, style: context.text.headlineSmall),
              // One fact per line: no "Bengaluru ·" left hanging.
              for (final line in [?user?.city, user?.email ?? user?.phone].whereType<String>().where((x) => x.isNotEmpty))
                Text(line, style: context.text.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
            ]),
          ),
          const SizedBox(width: Space.sm),
          StatusChip(user?.isPlus == true ? l.planPlus : l.planFree, tone: user?.isPlus == true ? ChipTone.accent : ChipTone.neutral, icon: user?.isPlus == true ? Ph.crownSimpleFill : null),
        ]),
        const SizedBox(height: Space.md),
        const Divider(height: Strokes.hairline),
        Row(children: [
          Expanded(child: Text(l.myPets, style: context.text.titleSmall)),
          LinkButton(label: l.manage, onPressed: () => context.push('/me/pets')),
        ]),
        // Every pet in its arch; tap to open its profile.
        Wrap(spacing: Space.lg, runSpacing: Space.md, children: [
          for (final p in pets)
            _PetDoor(
              label: p.name,
              semantic: [p.name, speciesLabel(context, p.species)].join(', '),
              onTap: () => context.push('/pets/${p.id}'),
              child: PetAvatar(species: p.species, colorTag: p.colorTag, photoUrl: p.photoUrl, size: Sizes.avatarLg + Space.md, selected: true),
            ),
          _PetDoor(
            label: l.addPet,
            semantic: l.addPet,
            onTap: () => context.push('/pets/new'),
            child: Container(
              width: ((Sizes.avatarLg + Space.md) / Sizes.archAspect).roundToDouble(),
              height: Sizes.avatarLg + Space.md,
              decoration: ShapeDecoration(shape: archShape((Sizes.avatarLg + Space.md) / Sizes.archAspect, BorderSide(color: paw.controlBorder.withValues(alpha: Opacities.half), width: Strokes.strong))),
              child: Icon(Ph.plus, color: paw.textSecondary),
            ),
          ),
        ]),
      ]),
    );
    final petsGroup = items.where((m) => m.group == 0).toList();
    final tiles = petsGroup.where((m) => _tiles.contains(m.route)).toList();
    final rows = petsGroup.where((m) => !_tiles.contains(m.route) && m.route != '/me/pets').toList();
    final petsSection = [
      SectionHeader(l.meGroupPets),
      if (tiles.isNotEmpty)
        TileGrid(columns: 2, children: [for (final t in tiles) _FeatureTile(item: t)]),
      if (rows.isNotEmpty) ...[const SizedBox(height: Space.md), _MenuCard(items: rows)],
    ];
    List<Widget> group(int g, String title) => [
      if (items.any((m) => m.group == g)) ...[
        SectionHeader(title),
        _MenuCard(items: items.where((m) => m.group == g).toList()),
      ],
    ];
    final signOut = Padding(
      padding: const EdgeInsets.only(top: Space.lg),
      child: SecondaryButton(
        label: l.signOut,
        icon: Ph.signOut,
        onPressed: () async {
          final ok = await confirmAction(context, title: l.signOutConfirm, danger: false, confirmLabel: l.signOut);
          if (ok) await ref.read(authServiceProvider).signOut();
        },
      ),
    );
    if (wide) {
      Widget col(List<Widget> c) => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: c);
      return PageBody(children: [
        const SizedBox(height: Space.sm),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(flex: 5, child: col([profile, ...petsSection])),
          const SizedBox(width: Space.xl),
          Expanded(flex: 7, child: col([...group(1, l.meGroupMoney), ...group(2, l.meGroupHelp), signOut])),
        ]),
      ]);
    }
    return PageBody(children: [
      const SizedBox(height: Space.sm),
      profile,
      ...petsSection,
      ...group(1, l.meGroupMoney),
      ...group(2, l.meGroupHelp),
      signOut,
    ]);
  }
}

/// A pet's arch with its name under it (Me).
class _PetDoor extends StatelessWidget {
  const _PetDoor({required this.label, required this.semantic, required this.onTap, required this.child});
  final String label;
  final String semantic;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: semantic,
    excludeSemantics: true,
    child: InkWell(
      borderRadius: BorderRadius.circular(Radii.md),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(Space.xs),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          child,
          const SizedBox(height: Space.xs),
          Text(label, style: context.text.labelMedium),
        ]),
      ),
    ),
  );
}

/// An everyday feature as a tile: a tinted icon tile and its name.
class _FeatureTile extends StatelessWidget {
  const _FeatureTile({required this.item});
  final MeMenuItem item;

  @override
  Widget build(BuildContext context) {
    final paw = context.paw;
    final tone = switch (item.route) {
      '/me/vault' => paw.accent,
      '/me/album' => CategoryColors.ocean,
      '/me/lost' => paw.success,
      _ => paw.textSecondary,
    };
    return PawCard(
      padding: const EdgeInsets.all(Space.md + Space.xxs),
      onTap: () => context.push(item.route),
      semanticLabel: item.label,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: TapTarget.min - Space.xxs,
          height: TapTarget.min - Space.xxs,
          decoration: BoxDecoration(color: tone.withValues(alpha: Opacities.chip), borderRadius: BorderRadius.circular(Radii.md)),
          child: Icon(item.icon, color: tone, size: IconSizes.md + Space.xxs),
        ),
        const SizedBox(height: Space.md),
        Text(item.label, style: context.text.titleSmall),
      ]),
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({required this.items});
  final List<MeMenuItem> items;

  @override
  Widget build(BuildContext context) {
    final paw = context.paw;
    return PawCard(
      padding: EdgeInsets.zero,
      child: Column(children: [
        for (var i = 0; i < items.length; i++) ...[
          ListTile(
            leading: Container(
              width: Sizes.avatarSm,
              height: Sizes.avatarSm,
              decoration: BoxDecoration(color: paw.surfaceSubtle, borderRadius: BorderRadius.circular(Radii.md)),
              child: Icon(items[i].icon, color: paw.textPrimary, size: IconSizes.md),
            ),
            title: Text(items[i].label),
            trailing: Icon(Ph.caretRight, color: paw.textSecondary),
            onTap: () => context.push(items[i].route),
          ),
          if (i < items.length - 1) const Divider(indent: Space.lg + Sizes.avatarSm + Space.lg, height: Strokes.hairline),
        ],
      ]),
    );
  }
}
