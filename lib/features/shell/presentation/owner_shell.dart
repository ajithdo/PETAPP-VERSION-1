import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../core/settings/settings_controller.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/logo.dart';
import '../../../core/widgets/widgets.dart';
import '../../pets/data/pets_repository.dart';
import '../../pets/domain/pet.dart';
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
    final easy = ref.watch(settingsProvider).easyMode;
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
          bottomNavigationBar: NavigationBar(
            selectedIndex: shell.currentIndex,
            onDestinationSelected: go,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            destinations: [
              for (final d in destinations)
                NavigationDestination(icon: Icon(d.$1, size: easy ? 30 : 24), selectedIcon: Icon(d.$2, size: easy ? 30 : 24), label: d.$3),
            ],
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
                  child: PawSetuLogo(size: 40, withName: extended),
                ),
                destinations: [
                  for (final d in destinations)
                    NavigationRailDestination(icon: Icon(d.$1), selectedIcon: Icon(d.$2), label: Text(d.$3)),
                ],
              ),
              const VerticalDivider(width: 1),
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

/// Pet switcher, messages, notifications and the red SOS button.
class OwnerTopBar extends ConsumerWidget {
  const OwnerTopBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final msgs = ref.watch(unreadMessagesProvider).value ?? 0;
    final notes = ref.watch(unreadNotificationsProvider).value ?? 0;
    return Material(
      color: context.paw.background,
      child: Padding(
        padding: EdgeInsets.fromLTRB(context.gutter - 4, Space.sm, context.gutter - 4, Space.sm),
        child: Row(children: [
          const Expanded(child: PetSwitcher()),
          IconButton(
            tooltip: l.messages,
            onPressed: () => context.push('/messages'),
            icon: Badge.count(count: msgs, isLabelVisible: msgs > 0, child: const Icon(Icons.chat_bubble_outline_rounded)),
          ),
          IconButton(
            tooltip: l.notifications,
            onPressed: () => context.push('/notifications'),
            icon: Badge.count(count: notes, isLabelVisible: notes > 0, child: const Icon(Icons.notifications_none_rounded)),
          ),
          const SizedBox(width: Space.xs),
          SosButton(onActivate: () => openSos(context, ref)),
        ]),
      ),
    );
  }
}

/// Avatar chips (wide screens) or a compact picker (phones), plus "All pets".
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
      return Align(alignment: Alignment.centerLeft, child: PawSetuLogo(size: 36, withName: !context.isPhone || true));
    }
    if (!context.isPhone) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: [
          if (pets.length > 1)
            Padding(
              padding: const EdgeInsets.only(right: Space.sm),
              child: ChoiceChip(
                label: Text(l.allPets),
                avatar: const Icon(Icons.pets_rounded, size: 18),
                selected: all,
                onSelected: (_) => notifier.selectPet('all'),
              ),
            ),
          for (final p in pets)
            Padding(
              padding: const EdgeInsets.only(right: Space.sm),
              child: ChoiceChip(
                showCheckmark: false,
                avatar: PetAvatar(species: p.species, colorTag: p.colorTag, photoUrl: p.photoUrl, size: 28),
                label: Text(p.name),
                selected: !all && selected?.id == p.id,
                onSelected: (_) => notifier.selectPet(p.id),
              ),
            ),
        ]),
      );
    }
    return Align(
      alignment: Alignment.centerLeft,
      child: Semantics(
        button: true,
        label: l.switchPet,
        child: InkWell(
          borderRadius: BorderRadius.circular(100),
          onTap: () => _pick(context, ref, pets),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              if (all || selected == null)
                CircleAvatar(
                  radius: 20,
                  backgroundColor: context.paw.primaryContainer,
                  child: Icon(Icons.pets_rounded, color: context.colors.primary),
                )
              else
                PetAvatar(species: selected.species, colorTag: selected.colorTag, photoUrl: selected.photoUrl, size: 40),
              const SizedBox(width: Space.sm),
              Flexible(
                child: Text(all || selected == null ? l.allPets : selected.name,
                    style: context.text.titleSmall, overflow: TextOverflow.ellipsis),
              ),
              const Icon(Icons.expand_more_rounded),
            ]),
          ),
        ),
      ),
    );
  }

  void _pick(BuildContext context, WidgetRef ref, List<Pet> pets) {
    final notifier = ref.read(settingsProvider.notifier);
    showPawSheet<void>(context, builder: (ctx) {
      final l = ctx.l10n;
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(l.switchPet, style: ctx.text.titleMedium),
        const SizedBox(height: Space.md),
        if (pets.length > 1)
          ListTile(
            leading: CircleAvatar(
              backgroundColor: ctx.paw.primaryContainer,
              child: Icon(Icons.pets_rounded, color: ctx.colors.primary),
            ),
            title: Text(l.allPets),
            onTap: () {
              notifier.selectPet('all');
              Navigator.pop(ctx);
            },
          ),
        for (final p in pets)
          ListTile(
            leading: PetAvatar(species: p.species, colorTag: p.colorTag, photoUrl: p.photoUrl, size: 44),
            title: Text(p.name),
            subtitle: Text([p.breedName(ctx.lang), petAgeLabel(ctx, p)].where((s) => s.isNotEmpty).join(' · ')),
            onTap: () {
              notifier.selectPet(p.id);
              Navigator.pop(ctx);
            },
          ),
        const SizedBox(height: Space.sm),
        OutlinedButton.icon(
          onPressed: () {
            Navigator.pop(ctx);
            context.push('/pets/new');
          },
          icon: const Icon(Icons.add_rounded),
          label: Text(l.addPet),
        ),
      ]);
    });
  }
}
