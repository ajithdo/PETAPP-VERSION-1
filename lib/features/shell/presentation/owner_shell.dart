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

/// Owner app frame (UI Design 5, DESIGN.md "Navigation and top bar"): the
/// Material navigation bar with the five tabs on phones, a navigation rail on
/// tablets and side navigation on desktop. Messages, notifications and SOS
/// sit in the top bar on every size; the pet pills sit above each main tab.
class OwnerShell extends ConsumerWidget {
  const OwnerShell({super.key, required this.shell});
  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final path = GoRouterState.of(context).uri.path;
    final onTab = _tabRoots.contains(path);
    final destinations = [
      // Outlined when idle, filled when selected.
      (Icons.home_outlined, Icons.home_rounded, l.tabHome),
      (Icons.favorite_border_rounded, Icons.favorite_rounded, l.tabHealth),
      (Icons.calendar_month_outlined, Icons.calendar_month_rounded, l.tabBook),
      (Icons.shopping_bag_outlined, Icons.shopping_bag_rounded, l.tabShop),
      (Icons.person_outline_rounded, Icons.person_rounded, l.tabMe),
    ];
    void go(int i) => shell.goBranch(i, initialLocation: i == shell.currentIndex);

    if (context.isPhone) {
      return Scaffold(
        body: SafeArea(
          bottom: false,
          child: Column(children: [
            if (onTab) const OwnerTopBar(),
            Expanded(child: shell),
          ]),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: shell.currentIndex,
          onDestinationSelected: go,
          destinations: [
            for (final d in destinations) NavigationDestination(icon: Icon(d.$1), selectedIcon: Icon(d.$2), label: d.$3),
          ],
        ),
      );
    }
    // Tablet: a rail with icons and labels. Desktop: the same rail extended
    // into side navigation (labels beside the icons, on one line).
    final desktop = context.screenSize == ScreenSize.desktop;
    final rail = NavigationRail(
      selectedIndex: shell.currentIndex,
      onDestinationSelected: go,
      extended: desktop,
      minExtendedWidth: Sizes.sideNav,
      labelType: desktop ? NavigationRailLabelType.none : NavigationRailLabelType.all,
      groupAlignment: -1,
      leading: Padding(
        padding: const EdgeInsets.only(top: Space.sm, bottom: Space.lg),
        child: PawSetuLogo(size: TapTarget.min - Space.sm, withName: desktop),
      ),
      destinations: [
        for (final d in destinations)
          NavigationRailDestination(icon: Icon(d.$1), selectedIcon: Icon(d.$2), label: Text(d.$3, maxLines: 1, overflow: TextOverflow.ellipsis)),
      ],
    );
    return Scaffold(
      body: SafeArea(
        child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          rail,
          VerticalDivider(width: Strokes.hairline, thickness: Strokes.hairline, color: context.paw.outline),
          Expanded(
            child: Column(children: [
              _WideTopBar(showPets: onTab),
              Expanded(child: shell),
            ]),
          ),
        ]),
      ),
    );
  }
}

/// Tablet and desktop top bar: the pet pills (on the main tabs) on the left;
/// messages, notifications and SOS on the right.
class _WideTopBar extends StatelessWidget {
  const _WideTopBar({required this.showPets});
  final bool showPets;

  @override
  Widget build(BuildContext context) {
    final paw = context.paw;
    return Container(
      constraints: const BoxConstraints(minHeight: Sizes.header),
      padding: EdgeInsets.symmetric(horizontal: context.gutter, vertical: Space.sm),
      decoration: BoxDecoration(color: paw.background, border: Border(bottom: BorderSide(color: paw.outline))),
      child: Row(children: [
        Expanded(child: showPets ? const PetSwitcher() : const SizedBox.shrink()),
        const SizedBox(width: Space.lg),
        const _QuickActions(),
      ]),
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

/// Phone top bar (main tabs): the PawSetu mark, messages, notifications and
/// the SOS pill on one row, and the pet pills below.
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
              leading: Icon(Icons.pets_rounded, size: IconSizes.sm, color: all ? context.paw.surface : context.paw.textPrimary),
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
          leading: Icon(Icons.add_rounded, size: IconSizes.sm, color: context.paw.textPrimary),
          onTap: () => context.push('/pets/new'),
        ),
      ]),
    );
  }
}
