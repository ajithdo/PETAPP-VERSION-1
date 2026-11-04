import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../core/settings/settings_controller.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/logo.dart';
import '../../../core/widgets/widgets.dart';
import '../../pets/data/pets_repository.dart';
import '../../pets/presentation/pet_labels.dart';
import 'sos_launcher.dart';

const _tabRoots = ['/home', '/health', '/book', '/shop', '/me'];

/// Owner app frame (Design 2): a floating dark bottom bar on phones and a
/// top bar with pill tabs on tablets and desktop, plus the pet pills on every
/// main tab.
class OwnerShell extends ConsumerWidget {
  const OwnerShell({super.key, required this.shell});
  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final path = GoRouterState.of(context).uri.path;
    final showTopBar = _tabRoots.contains(path);
    final destinations = [
      // Outlined when idle, filled when selected (Design 2 tab bar).
      (Icons.home_outlined, Icons.home, l.tabHome),
      (Icons.favorite_border, Icons.favorite, l.tabHealth),
      (Icons.event_outlined, Icons.event, l.tabBook),
      (Icons.shopping_bag_outlined, Icons.shopping_bag, l.tabShop),
      (Icons.person_outlined, Icons.person, l.tabMe),
    ];
    void go(int i) => shell.goBranch(i, initialLocation: i == shell.currentIndex);

    final body = Column(children: [
      if (showTopBar) const OwnerTopBar(),
      Expanded(child: shell),
    ]);

    if (context.isPhone) {
      return Scaffold(
        body: SafeArea(bottom: false, child: body),
        bottomNavigationBar: _PhoneDock(destinations: destinations, selected: shell.currentIndex, onSelect: go),
      );
    }
    // Tablet and desktop: one top bar with the logo, the tabs as pill
    // buttons and the quick actions (Design 2), above every page.
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          _WideHeader(destinations: destinations, selected: shell.currentIndex, onSelect: go),
          Expanded(child: body),
        ]),
      ),
    );
  }
}

/// Design 2 phone menu: a floating dark bar with the five tabs.
class _PhoneDock extends StatelessWidget {
  const _PhoneDock({required this.destinations, required this.selected, required this.onSelect});
  final List<(IconData, IconData, String)> destinations;
  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final paw = context.paw;
    final dark = Theme.of(context).brightness == Brightness.dark;
    // Dark bar in light mode; a raised dark surface in dark mode.
    final bg = dark ? paw.surfaceSubtle : paw.inverseSurface;
    final fg = dark ? paw.textSecondary : paw.onInverseSurface.withValues(alpha: Opacities.onDarkMuted);
    final on = dark ? paw.brand : PawColors.dark.brand;
    final bottom = MediaQuery.paddingOf(context).bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(Space.lg, Space.xs, Space.lg, Space.md + bottom),
      child: Material(
        color: bg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.xxl),
          side: dark ? BorderSide(color: paw.outline) : BorderSide.none,
        ),
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: Sizes.dock),
          child: Row(children: [
            for (var i = 0; i < destinations.length; i++)
              Expanded(
                child: Semantics(
                  button: true,
                  selected: i == selected,
                  label: destinations[i].$3,
                  excludeSemantics: true,
                  child: InkWell(
                    onTap: () => onSelect(i),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: Space.sm),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Icon(i == selected ? destinations[i].$2 : destinations[i].$1, color: i == selected ? on : fg, size: IconSizes.lg),
                        const SizedBox(height: Space.xxs),
                        Text(
                          destinations[i].$3,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.text.labelSmall?.copyWith(
                            color: i == selected ? on : fg,
                            fontWeight: i == selected ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
              ),
          ]),
        ),
      ),
    );
  }
}

/// Design 2 wide-screen top bar: the logo, the tabs as pill buttons in a sand
/// track (the chosen one in forest teal), and messages, notifications and SOS.
class _WideHeader extends ConsumerWidget {
  const _WideHeader({required this.destinations, required this.selected, required this.onSelect});
  final List<(IconData, IconData, String)> destinations;
  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paw = context.paw;
    final desktop = context.screenSize == ScreenSize.desktop;
    final tabs = Container(
      padding: const EdgeInsets.all(Space.xs),
      decoration: BoxDecoration(
        color: paw.surfaceSubtle,
        borderRadius: BorderRadius.circular(Radii.full),
        border: Border.all(color: paw.outline),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        for (var i = 0; i < destinations.length; i++)
          Padding(
            padding: EdgeInsets.only(left: i == 0 ? 0 : Space.xxs),
            child: _HeaderTab(
              icon: i == selected ? destinations[i].$2 : destinations[i].$1,
              label: destinations[i].$3,
              selected: i == selected,
              onTap: () => onSelect(i),
            ),
          ),
      ]),
    );
    return Container(
      constraints: const BoxConstraints(minHeight: Sizes.header),
      padding: EdgeInsets.symmetric(horizontal: context.gutter, vertical: Space.sm),
      decoration: BoxDecoration(
        color: paw.background,
        border: Border(bottom: BorderSide(color: paw.outline)),
      ),
      child: Row(children: [
        PawSetuLogo(size: TapTarget.min - Space.sm, withName: desktop),
        const SizedBox(width: Space.lg),
        Expanded(
          child: Center(
            child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: tabs),
          ),
        ),
        const SizedBox(width: Space.lg),
        const _QuickActions(),
      ]),
    );
  }
}

class _HeaderTab extends StatelessWidget {
  const _HeaderTab({required this.icon, required this.label, required this.selected, required this.onTap});
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final paw = context.paw;
    final fg = selected ? paw.onBrand : paw.textPrimary;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: selected ? paw.brand : paw.surfaceSubtle.withValues(alpha: 0),
        shape: const StadiumBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: TapTarget.min - Space.xs),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Space.lg),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(icon, size: IconSizes.md, color: fg),
                const SizedBox(width: Space.sm),
                Text(label, style: context.text.labelLarge?.copyWith(color: fg, fontWeight: selected ? FontWeight.w700 : FontWeight.w600)),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

/// Messages, notifications and the SOS pill (top bar on every screen size).
class _QuickActions extends ConsumerWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final msgs = ref.watch(unreadMessagesProvider).value ?? 0;
    final notes = ref.watch(unreadNotificationsProvider).value ?? 0;
    return Row(mainAxisSize: MainAxisSize.min, children: [
      PawIconButton(
        icon: Icons.chat_bubble_outlined,
        tooltip: l.messages,
        badge: msgs,
        onPressed: () => context.push('/messages'),
      ),
      const SizedBox(width: Space.xs),
      PawIconButton(
        icon: Icons.notifications_none_outlined,
        tooltip: l.notifications,
        badge: notes,
        onPressed: () => context.push('/notifications'),
      ),
      const SizedBox(width: Space.sm),
      SosButton(onActivate: () => openSos(context, ref)),
    ]);
  }
}

/// Unread notifications for the bell badge.
final unreadNotificationsProvider = StreamProvider<int>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value(0);
  return ref
      .watch(firestoreProvider)
      .collection('notifications')
      .where('uid', isEqualTo: user.uid)
      .where('read', isEqualTo: false)
      .snapshots()
      .map((s) => s.size);
});

/// Unread chat messages for the messages badge.
final unreadMessagesProvider = StreamProvider<int>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value(0);
  return ref
      .watch(firestoreProvider)
      .collection('conversations')
      .where('participantIds', arrayContains: user.uid)
      .snapshots()
      .map((s) => s.docs.fold<int>(0, (sum, d) => sum + (((d.data()['unread'] as Map?)?[user.uid] as num?)?.toInt() ?? 0)));
});

/// Design 2 top bar: the PawSetu mark (phones), messages, notifications and
/// the SOS pill on one row, and the pet pills below (on wider screens the
/// pills sit on the same row).
class OwnerTopBar extends ConsumerWidget {
  const OwnerTopBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phone = context.isPhone;
    return Material(
      color: context.paw.background,
      child: Padding(
        padding: EdgeInsets.fromLTRB(context.gutter, phone ? Space.sm : Space.md, context.gutter, Space.xs),
        child: phone
            ? const Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Row(children: [
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: PawSetuLogo(size: TapTarget.min - Space.sm, withName: true),
                    ),
                  ),
                  SizedBox(width: Space.sm),
                  _QuickActions(),
                ]),
                PetSwitcher(),
              ])
            // Wide screens: the logo and quick actions are in the top bar,
            // so this row holds only the pet pills.
            : const PetSwitcher(),
      ),
    );
  }
}

/// Pet pills: "All pets" (2+ pets), one pill per pet and "Add pet".
class PetSwitcher extends ConsumerWidget {
  const PetSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final pets = ref.watch(activePetsProvider);
    final selected = ref.watch(selectedPetProvider);
    final all = ref.watch(allPetsSelectedProvider);
    final notifier = ref.read(settingsProvider.notifier);
    if (pets.isEmpty) return const SizedBox.shrink();
    final avatar = IconSizes.lg + Space.xs;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: [
        if (pets.length > 1)
          Padding(
            padding: const EdgeInsets.only(right: Space.sm),
            child: PawPill(
              label: l.allPets,
              selected: all,
              leading: Icon(Icons.pets_outlined, size: IconSizes.sm, color: context.paw.brand),
              onTap: () => notifier.selectPet('all'),
            ),
          ),
        for (final p in pets)
          Padding(
            padding: const EdgeInsets.only(right: Space.sm),
            child: PawPill(
              label: p.name,
              semanticLabel: [p.name, p.breedName(context.lang), petAgeLabel(context, p)].where((s) => s.isNotEmpty).join(', '),
              selected: !all && selected?.id == p.id,
              leading: PetAvatar(species: p.species, colorTag: p.colorTag, photoUrl: p.photoUrl, size: avatar),
              onTap: () => notifier.selectPet(p.id),
            ),
          ),
        PawPill(
          label: l.addPet,
          outlined: true,
          leading: Icon(Icons.add_outlined, size: IconSizes.sm, color: context.paw.textSecondary),
          onTap: () => context.push('/pets/new'),
        ),
      ]),
    );
  }
}
