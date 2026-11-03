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

/// Owner app frame: bottom navigation on phones, a rail on tablets and a
/// side navigation on desktop, plus the top bar on every main tab.
class OwnerShell extends ConsumerWidget {
  const OwnerShell({super.key, required this.shell});
  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final path = GoRouterState.of(context).uri.path;
    final showTopBar = _tabRoots.contains(path);
    final destinations = [
      (Icons.home_outlined, Icons.home_rounded, l.tabHome),
      (Icons.favorite_border_rounded, Icons.favorite_rounded, l.tabHealth),
      (Icons.event_outlined, Icons.event_rounded, l.tabBook),
      (Icons.shopping_bag_outlined, Icons.shopping_bag_rounded, l.tabShop),
      (Icons.person_outline_rounded, Icons.person_rounded, l.tabMe),
    ];
    void go(int i) => shell.goBranch(i, initialLocation: i == shell.currentIndex);

    final body = Column(children: [
      if (showTopBar) const OwnerTopBar(),
      Expanded(child: shell),
    ]);

    switch (context.screenSize) {
      case ScreenSize.phone:
        return Scaffold(
          body: SafeArea(bottom: false, child: body),
          bottomNavigationBar: DecoratedBox(
            decoration: BoxDecoration(border: Border(top: BorderSide(color: context.paw.outline))),
            child: NavigationBar(
              selectedIndex: shell.currentIndex,
              onDestinationSelected: go,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              destinations: [
                for (final d in destinations) NavigationDestination(icon: Icon(d.$1), selectedIcon: Icon(d.$2), label: d.$3),
              ],
            ),
          ),
        );
      case ScreenSize.tablet:
      case ScreenSize.desktop:
        final extended = context.screenSize == ScreenSize.desktop;
        return Scaffold(
          body: SafeArea(
            child: Row(children: [
              NavigationRail(
                extended: extended,
                minExtendedWidth: 220,
                selectedIndex: shell.currentIndex,
                onDestinationSelected: go,
                labelType: extended ? NavigationRailLabelType.none : NavigationRailLabelType.all,
                leading: Padding(
                  padding: const EdgeInsets.symmetric(vertical: Space.lg),
                  child: PawSetuLogo(size: TapTarget.min - Space.sm, withName: extended),
                ),
                destinations: [
                  for (final d in destinations)
                    NavigationRailDestination(icon: Icon(d.$1), selectedIcon: Icon(d.$2), label: Text(d.$3)),
                ],
              ),
              VerticalDivider(width: 1, color: context.paw.outline),
              Expanded(child: body),
            ]),
          ),
        );
    }
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
    final l = context.l10n;
    final msgs = ref.watch(unreadMessagesProvider).value ?? 0;
    final notes = ref.watch(unreadNotificationsProvider).value ?? 0;
    final phone = context.isPhone;
    final actions = [
      PawIconButton(
        icon: Icons.chat_bubble_outline_rounded,
        tooltip: l.messages,
        badge: msgs,
        onPressed: () => context.push('/messages'),
      ),
      const SizedBox(width: Space.xs),
      PawIconButton(
        icon: Icons.notifications_none_rounded,
        tooltip: l.notifications,
        badge: notes,
        onPressed: () => context.push('/notifications'),
      ),
      const SizedBox(width: Space.sm),
      SosButton(onActivate: () => openSos(context, ref)),
    ];
    return Material(
      color: context.paw.background,
      child: Padding(
        padding: EdgeInsets.fromLTRB(context.gutter, Space.sm, context.gutter, Space.xs),
        child: phone
            ? Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Row(children: [
                  const PawSetuLogo(size: TapTarget.min - Space.sm, withName: true),
                  const Spacer(),
                  ...actions,
                ]),
                const PetSwitcher(),
              ])
            : Row(children: [
                const Expanded(child: PetSwitcher()),
                const SizedBox(width: Space.md),
                ...actions,
              ]),
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
    if (pets.isEmpty) {
      return context.isPhone
          ? const SizedBox.shrink()
          : const Align(alignment: Alignment.centerLeft, child: PawSetuLogo(size: TapTarget.min - Space.sm, withName: true));
    }
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
              leading: Icon(Icons.pets_rounded, size: IconSizes.md - 2, color: context.paw.brand),
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
          leading: Icon(Icons.add_rounded, size: IconSizes.md - 2, color: context.paw.textSecondary),
          onTap: () => context.push('/pets/new'),
        ),
      ]),
    );
  }
}
