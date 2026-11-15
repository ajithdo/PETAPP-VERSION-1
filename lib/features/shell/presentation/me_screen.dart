import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../core/routing/extra_routes.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../admin/admin_slots.dart' show meItemVisible;
import '../../album/data/album_repository.dart';
import '../../album/domain/album.dart';
import '../../pets/data/pets_repository.dart';
import '../../shop/data/order_repository.dart';
import '../../shop/data/shop_repository.dart';
import '../../shop/domain/shop_models.dart';
import '../../sos/data/device_repository.dart';
import '../../sos/domain/devices.dart';
import '../../vault/data/vault_repository.dart';
import '../../vault/domain/vault_models.dart';
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
    final lang = context.lang;
    final now = DateTime.now();
    // --- Where things stand, for the line under each feature ---
    final docs = ref.watch(myDocsProvider).value ?? const <VaultDoc>[];
    final expiring = docs.where((d) => expiryState(d.expiry, now) == ExpiryState.soon).length;
    final album = [for (final p in pets) ...(ref.watch(petAlbumProvider(p.id)).value ?? const <AlbumItem>[])];
    final photos = album.where((a) => a.type == 'photo').length, videos = album.where((a) => a.isVideo).length;
    final lostPet = pets.where((p) => p.lost != null).firstOrNull;
    final devices = ref.watch(myDevicesProvider).value ?? const <Device>[];
    final others = <String, Set<String>>{};
    for (final p in pets) {
      for (final m in p.members.entries) {
        if (m.key != user?.uid && m.value.name.isNotEmpty) others.putIfAbsent(m.value.name.split(' ').first, () => {}).add(p.name);
      }
    }
    final orders = (ref.watch(myOrdersProvider).value ?? const <ShopOrder>[]).where((o) => o.isOpen).toList();
    final spent = (ref.watch(myExpensesProvider).value ?? const <Expense>[]).where((e) => e.date.year == now.year && e.date.month == now.month).fold<int>(0, (a, e) => a + e.amount);
    final address = (ref.watch(addressesProvider).value ?? const <Address>[]).firstOrNull;
    final reward = (((ref.watch(appSettingsDocProvider).value?['referral'] as Map?)?['reward']) as num?)?.toInt() ?? 100;
    String status(String route) => switch (route) {
          '/me/vault' => [l.meDocsCount(docs.length), if (expiring > 0) l.meExpireSoon(expiring)].join(', '),
          '/me/album' => [l.mePhotosCount(photos), if (videos > 0) l.meVideosCount(videos)].join(', '),
          '/me/lost' => lostPet == null ? l.meTagsReady : l.mePetLost(lostPet.name),
          '/me/devices' => devices.isEmpty ? l.meNoneYet : l.meDeviceLine(devices.first.name, devices.first.battery),
          '/me/family' => others.isEmpty ? l.meOnlyYou : l.meCanCare(others.keys.first, others.values.first.join(', ')),
          '/shop/orders' => orders.isEmpty ? '' : l.meOnTheWay(orders.first.items.firstOrNull?.name ?? ''),
          '/me/expenses' => spent > 0 ? l.meThisMonth(Fmt.inr(spent, lang)) : '',
          '/me/addresses' => address == null ? '' : [address.label, [address.area, address.pin].where((x) => x.isNotEmpty).join(' ')].where((x) => x.isNotEmpty).join(', '),
          '/me/plus' => user?.isPlus == true ? (user?.planRenewsAt == null ? '' : l.meRenewsOn(Fmt.date(user!.planRenewsAt!, lang))) : l.meTryFree,
          '/me/refer' => l.meBothGet(Fmt.inr(reward, lang)),
          '/me/settings' => l.meSettingsSub,
          '/me/privacy' => l.mePrivacySub,
          _ => '',
        };
    const arch = Sizes.meArch;
    final profile = PawCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Container(
            width: Sizes.thumbLg,
            height: Sizes.thumbLg,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: paw.textPrimary, shape: BoxShape.circle),
            child: Text(initials(user?.name ?? ''), style: context.text.titleLarge?.copyWith(color: paw.background)),
          ),
          const SizedBox(width: Space.md),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Semantics(header: true, child: Text(user?.name.isNotEmpty == true ? user!.name : l.petParent, style: context.text.headlineMedium)),
              Text(
                [?user?.city, user?.email ?? user?.phone].whereType<String>().where((x) => x.isNotEmpty).join(', '),
                style: context.text.bodySmall?.copyWith(color: paw.textSecondary),
              ),
            ]),
          ),
          const SizedBox(width: Space.md),
          user?.isPlus == true ? PawTag(l.planPlus, kind: TagKind.plus, icon: Ph.crownSimpleFill) : PawTag(l.planFree),
        ]),
        const Padding(padding: EdgeInsets.only(top: Space.lg, bottom: Space.md + Space.xxs), child: Divider(height: Strokes.hairline)),
        Row(crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [
          Expanded(child: Text(l.myPets, style: context.text.labelLarge)),
          TextLink(l.manage, onTap: () => context.push('/me/pets')),
        ]),
        const SizedBox(height: Space.md),
        // Every pet in its arch; tap to open its profile.
        Wrap(spacing: Space.lg, runSpacing: Space.md, children: [
          for (final p in pets)
            _PetDoor(
              label: p.name,
              semantic: [p.name, speciesLabel(context, p.species)].join(', '),
              onTap: () => context.push('/pets/${p.id}'),
              child: PetAvatar(species: p.species, colorTag: p.colorTag, photoUrl: p.photoUrl, size: arch, selected: true),
            ),
          _PetDoor(
            label: l.addPet,
            semantic: l.addPet,
            muted: true,
            onTap: () => context.push('/pets/new'),
            child: CustomPaint(
              foregroundPainter: _DashedArchPainter(context.tint.line2),
              child: SizedBox(width: (arch / Sizes.archAspect).roundToDouble(), height: arch, child: Icon(Ph.plus, size: IconSizes.md, color: paw.textPrimary)),
            ),
          ),
        ]),
      ]),
    );
    const gap = SizedBox(height: Sizes.sectionGap);
    final petsGroup = items.where((m) => m.group == 0).toList();
    final tiles = petsGroup.where((m) => _tiles.contains(m.route)).toList();
    final rows = petsGroup.where((m) => !_tiles.contains(m.route) && m.route != '/me/pets').toList();
    final petsSection = [
      gap,
      SecHead(l.meGroupPets),
      if (tiles.isNotEmpty) TileGrid(columns: 2, children: [for (final t in tiles) _FeatureTile(item: t, status: status(t.route))]),
      if (rows.isNotEmpty) ...[const SizedBox(height: Space.md), _MenuPanel(items: rows, status: status, slim: true)],
    ];
    List<Widget> group(int g, String title, {bool flush = false}) => [
      if (items.any((m) => m.group == g)) ...[
        if (!flush) gap,
        SecHead(title),
        _MenuPanel(items: items.where((m) => m.group == g).toList(), status: status, count: {if (orders.isNotEmpty) '/shop/orders': orders.length}),
      ],
    ];
    final signOut = Padding(
      padding: const EdgeInsets.only(top: Space.lg),
      child: PawButton(
        label: l.signOut,
        icon: Ph.signOut,
        kind: BtnKind.line,
        size: BtnSize.regular,
        block: true,
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
          Expanded(flex: 7, child: col([...group(1, l.meGroupMoney, flush: true), ...group(2, l.meGroupApp), signOut])),
        ]),
      ]);
    }
    return PageBody(children: [
      const SizedBox(height: Space.sm),
      profile,
      ...petsSection,
      ...group(1, l.meGroupMoney),
      ...group(2, l.meGroupApp),
      signOut,
    ]);
  }
}

/// The dashed outline of the "Add pet" arch.
class _DashedArchPainter extends CustomPainter {
  _DashedArchPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final r = size.width / 2, foot = size.width * 0.18;
    final rect = (Offset.zero & size).deflate(Strokes.strong / 2);
    final path = Path()..addRRect(RRect.fromRectAndCorners(rect, topLeft: Radius.circular(r), topRight: Radius.circular(r), bottomLeft: Radius.circular(foot), bottomRight: Radius.circular(foot)));
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = Strokes.strong;
    for (final m in path.computeMetrics()) {
      for (double d = 0; d < m.length; d += Space.sm) {
        canvas.drawPath(m.extractPath(d, d + Space.xs), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DashedArchPainter o) => o.color != color;
}

/// A pet's arch with its name under it (Me).
class _PetDoor extends StatelessWidget {
  const _PetDoor({required this.label, required this.semantic, required this.onTap, required this.child, this.muted = false});
  final String label;
  final String semantic;
  final VoidCallback onTap;
  final Widget child;
  final bool muted;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: semantic,
    excludeSemantics: true,
    child: InkWell(
      borderRadius: BorderRadius.circular(Radii.md),
      onTap: onTap,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        child,
        const SizedBox(height: Space.xs + Space.xxs),
        Text(label, style: context.text.labelSmall?.copyWith(fontWeight: FontWeight.w500, color: muted ? context.paw.textSecondary : context.paw.textPrimary)),
      ]),
    ),
  );
}

/// An everyday feature as a tile: a tinted icon tile, its name, and where
/// things stand ("7 documents, 1 expires soon").
class _FeatureTile extends StatelessWidget {
  const _FeatureTile({required this.item, required this.status});
  final MeMenuItem item;
  final String status;

  @override
  Widget build(BuildContext context) {
    final tone = switch (item.route) {
      '/me/vault' => Tone.gold,
      '/me/album' => Tone.sky,
      '/me/lost' => Tone.green,
      _ => Tone.neutral,
    };
    return PawCard(
      padding: const EdgeInsets.all(Space.md + Space.xxs),
      onTap: () => context.push(item.route),
      semanticLabel: [item.label, status].where((x) => x.isNotEmpty).join(', '),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        PawTile(icon: item.icon, tone: tone),
        const SizedBox(height: Space.md),
        Text(item.label, style: context.text.labelLarge),
        if (status.isNotEmpty) Text(status, style: context.text.bodySmall?.copyWith(color: context.paw.textSecondary)),
      ]),
    );
  }
}

/// A short list of places to go, in a hairline panel: an icon tile, the
/// name, where things stand, and an arrow. [count] adds a small marigold
/// number before the arrow (open orders).
class _MenuPanel extends StatelessWidget {
  const _MenuPanel({required this.items, required this.status, this.count = const {}, this.slim = false});
  final List<MeMenuItem> items;
  final String Function(String route) status;
  final Map<String, int> count;

  /// One row on its own (Family and sharing): a little less space around it.
  final bool slim;

  @override
  Widget build(BuildContext context) {
    return PawPanel(
      padding: slim ? const EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.xs) : PawPanel.listPadding,
      child: PawList(children: [
        for (final m in items)
          PawItem(
            lead: PawTile(icon: m.icon),
            title: m.label,
            sub: status(m.route),
            onTap: () => context.push(m.route),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              if (count[m.route] != null) ...[PawTag('${count[m.route]}', kind: TagKind.gold), const SizedBox(width: Space.md)],
              const Chev(),
            ]),
          ),
      ]),
    );
  }
}
