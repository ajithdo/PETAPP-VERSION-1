import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/app_user.dart';
import '../../../core/providers.dart';
import '../../../core/settings/settings_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/logo.dart';
import '../../../core/widgets/widgets.dart';
import '../../pets/data/pets_repository.dart';
import '../../pets/presentation/pet_labels.dart';
import 'sos_launcher.dart';
import '../../../core/theme/ph.dart';

const _tabRoots = ['/home', '/health', '/book', '/shop', '/me'];

/// Owner app frame (UI Design 6 "Toran", DESIGN.md "Navigation and top
/// bar"): on phones the five tabs sit in a floating dark dock with a marigold
/// pill for the current tab; on tablets a dark rail, and on desktop a dark
/// side menu with the account at the bottom. Messages, notifications and SOS
/// sit in the top bar on every size; the pet pills sit above each main tab.
class OwnerShell extends ConsumerWidget {
  const OwnerShell({super.key, required this.shell});
  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final path = GoRouterState.of(context).uri.path;
    return _OwnerChrome(
      index: shell.currentIndex,
      onTab: _tabRoots.contains(path),
      onTap: (i) => shell.goBranch(i, initialLocation: i == shell.currentIndex),
      child: shell,
    );
  }
}

/// The owner's frame around a page: the dock on phones, the rail or side
/// menu on wider screens. [index] is the current tab (null when the page
/// belongs to none); [onTab] adds the top bar of a main tab.
class _OwnerChrome extends StatelessWidget {
  const _OwnerChrome({required this.index, required this.onTab, required this.onTap, required this.child});
  final int? index;
  final bool onTab;
  final ValueChanged<int> onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final destinations = [
      // Outlined when idle, filled when selected.
      (Ph.house, Ph.houseFill, l.tabHome),
      (Ph.heartbeat, Ph.heartbeatFill, l.tabHealth),
      (Ph.calendarDots, Ph.calendarDotsFill, l.tabBook),
      (Ph.bag, Ph.bagFill, l.tabShop),
      (Ph.user, Ph.userFill, l.tabMe),
    ];
    if (context.isPhone) {
      return Scaffold(
        body: SafeArea(
          bottom: false,
          child: Column(children: [
            if (onTab) const OwnerTopBar(),
            Expanded(child: child),
          ]),
        ),
        // The dock floats a little above the bottom edge, on the page colour.
        bottomNavigationBar: ColoredBox(
          color: context.paw.background,
          child: SafeArea(
            top: false,
            minimum: const EdgeInsets.fromLTRB(Space.md, Space.xs, Space.md, Space.md),
            child: _Dock(index: index, items: destinations, onTap: onTap),
          ),
        ),
      );
    }
    // Tablet: a rail with icons and labels. Desktop: the same rail extended
    // into side navigation (labels beside the icons, on one line).
    final desktop = context.screenSize == ScreenSize.desktop;
    final rail = NavigationRail(
      selectedIndex: index,
      onDestinationSelected: onTap,
      extended: desktop,
      minExtendedWidth: Sizes.sideNav,
      labelType: desktop ? NavigationRailLabelType.none : NavigationRailLabelType.all,
      groupAlignment: -1,
      leading: Padding(
        padding: const EdgeInsets.only(top: Space.sm, bottom: Space.lg),
        child: PawSetuLogo(size: TapTarget.min - Space.sm, withName: desktop, onDark: true),
      ),
      trailingAtBottom: true,
      trailing: desktop ? const _AccountCard() : null,
      destinations: [
        for (final d in destinations)
          NavigationRailDestination(icon: Icon(d.$1), selectedIcon: Icon(d.$2), label: Text(d.$3, maxLines: 1, overflow: TextOverflow.ellipsis)),
      ],
    );
    return Scaffold(
      body: SafeArea(
        child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          rail,
          Expanded(
            child: Column(children: [
              _WideTopBar(showPets: onTab),
              Expanded(child: child),
            ]),
          ),
        ]),
      ),
    );
  }
}

/// Keeps the dock (or the side menu) on the owner's pages outside the five
/// tabs: messages, notifications, tele-vet, a pet's profile and so on (UI
/// Design 6: "the bottom bar stays on every page"). Full-attention pages
/// (SOS, a live call or walk, forms, shared links) and other roles get the
/// page alone.
class SubPageFrame extends ConsumerWidget {
  const SubPageFrame({super.key, required this.path, required this.child});
  final String path;
  final Widget child;

  static bool _alone(String p) =>
      p.startsWith('/sos') ||
      p.startsWith('/televet/call') ||
      p.startsWith('/televet/new') ||
      p.startsWith('/televet/consent') ||
      p.startsWith('/walk/') ||
      p.startsWith('/lost/') ||
      p.startsWith('/share/') ||
      p.startsWith('/join/') ||
      p.startsWith('/partner-signup') ||
      p.startsWith('/suspended') ||
      p == '/pets/new' ||
      p.endsWith('/edit') ||
      p.endsWith('/birthday') ||
      p.endsWith('/report');

  /// The tab a page belongs to, as in the design: a pet's profile under Me,
  /// its routine under Home, its medical card under Health, tele-vet under
  /// Book.
  static int? _tabFor(String p) {
    if (p.startsWith('/televet')) return 2;
    if (p.endsWith('/routine')) return 0;
    if (p.endsWith('/card')) return 1;
    if (p.startsWith('/pets/') || p.startsWith('/vault/') || p == '/settings' || p.startsWith('/help')) return 4;
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    if (user == null || user.role != UserRole.owner || _alone(path)) return child;
    return _OwnerChrome(index: _tabFor(path), onTab: false, onTap: (i) => context.go(_tabRoots[i]), child: child);
  }
}

/// The signed-in person at the foot of the desktop side menu: their initials,
/// name and plan. Tapping it opens Me.
class _AccountCard extends ConsumerWidget {
  const _AccountCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paw = context.paw;
    final user = ref.watch(currentUserProvider);
    if (user == null) return const SizedBox.shrink();
    final initials = user.name.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).take(2).map((w) => w.characters.first.toUpperCase()).join();
    return Padding(
      padding: const EdgeInsets.fromLTRB(Space.md, Space.lg, Space.md, Space.lg),
      child: SizedBox(
        width: Sizes.sideNav - 2 * Space.md,
        child: Material(
          color: paw.onBand.withValues(alpha: Opacities.tint),
          borderRadius: BorderRadius.circular(Radii.xl),
          child: InkWell(
            borderRadius: BorderRadius.circular(Radii.xl),
            onTap: () => context.go('/me'),
            child: Padding(
              padding: const EdgeInsets.all(Space.sm + Space.xxs),
              child: Row(children: [
                CircleAvatar(
                  radius: Space.lg + Space.xxs,
                  backgroundColor: paw.marigold,
                  child: Text(initials, style: context.text.labelLarge?.copyWith(color: paw.onMarigold, fontWeight: FontWeight.w700)),
                ),
                const SizedBox(width: Space.sm + Space.xxs),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(user.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: context.text.labelLarge?.copyWith(color: paw.onBand)),
                    Text(user.isPlus ? context.l10n.pawsetuPlus : context.l10n.planFree,
                        maxLines: 1, overflow: TextOverflow.ellipsis, style: context.text.labelSmall?.copyWith(color: paw.onBandMuted)),
                  ]),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

/// Tablet and desktop top bar: the pet pills (on the main tabs) on the left;
/// The floating dock (phones): five tabs on the kaapi band, a marigold pill
/// behind the current tab's icon (UI Design 6).
class _Dock extends StatelessWidget {
  const _Dock({required this.index, required this.items, required this.onTap});

  /// The current tab, or null when the page belongs to none.
  final int? index;
  final List<(IconData, IconData, String)> items;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final paw = context.paw;
    final locale = Localizations.localeOf(context).languageCode;
    final radius = BorderRadius.circular(Sizes.dockRadius);
    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: radius, boxShadow: Shadows.raised(paw.ink)),
      child: Material(
        color: paw.band,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: Sizes.dock),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Space.xs + Space.xxs),
            child: Row(children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: Semantics(
                    button: true,
                    selected: i == index,
                    label: items[i].$3,
                    excludeSemantics: true,
                    child: InkWell(
                      borderRadius: radius,
                      onTap: () => onTap(i),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: Space.sm + Space.xxs),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
                          AnimatedContainer(
                            duration: Motion.toggle,
                            width: Sizes.dockPillWidth,
                            height: Sizes.dockPillHeight,
                            decoration: BoxDecoration(
                              color: i == index ? paw.marigold : paw.marigold.withValues(alpha: 0),
                              borderRadius: BorderRadius.circular(Radii.lg),
                            ),
                            child: Icon(
                              i == index ? items[i].$2 : items[i].$1,
                              size: Sizes.dockIcon,
                              color: i == index ? paw.band : paw.onBandMuted,
                            ),
                          ),
                          const SizedBox(height: Space.xxs),
                          Text(
                            items[i].$3,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTheme.styleFor(TypeScale.dock, locale, i == index ? paw.onBand : paw.onBandMuted)
                                .copyWith(fontWeight: i == index ? FontWeight.w700 : FontWeight.w500),
                          ),
                        ]),
                      ),
                    ),
                  ),
                ),
            ]),
          ),
        ),
      ),
    );
  }
}

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
        icon: Ph.chatCircleDots,
        tooltip: l.messages,
        badge: msgs,
        onPressed: () => context.push('/messages'),
      ),
      const SizedBox(width: Space.sm),
      PawIconButton(
        icon: Ph.bell,
        tooltip: l.notifications,
        badge: notes,
        onPressed: () => context.push('/notifications'),
      ),
      const SizedBox(width: Space.xs),
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
    if (!phone) {
      // Wide screens: the logo and quick actions are in the top bar, so this
      // row holds only the pet pills.
      return Material(
        color: context.paw.background,
        child: Padding(padding: EdgeInsets.fromLTRB(context.gutter, Space.md, context.gutter, Space.xs), child: const PetSwitcher()),
      );
    }
    return Material(
      color: context.paw.background,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Padding(
          padding: EdgeInsets.fromLTRB(context.gutter, Space.sm + Space.xxs, context.gutter - Space.xs, Space.xxs),
          child: const Row(children: [
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: PawSetuLogo(size: Sizes.topLogo, withName: true),
              ),
            ),
            SizedBox(width: Space.sm),
            _QuickActions(),
          ]),
        ),
        // The pet pills scroll to the screen's edge.
        PetSwitcher(padding: EdgeInsets.fromLTRB(context.gutter, Space.xs, context.gutter, Space.sm + Space.xxs)),
      ]),
    );
  }
}

/// Pet pills: "All pets" (2+ pets), one pill per pet and "Add pet".
class PetSwitcher extends ConsumerWidget {
  const PetSwitcher({super.key, this.padding = EdgeInsets.zero});

  /// Space inside the scrolling row (so pills can slide to the screen edge).
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final pets = ref.watch(activePetsProvider);
    final selected = ref.watch(selectedPetProvider);
    final all = ref.watch(allPetsSelectedProvider);
    final notifier = ref.read(settingsProvider.notifier);
    if (pets.isEmpty) return const SizedBox.shrink();
    const avatar = Sizes.pillArch * Sizes.archAspect;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: padding,
      child: Row(children: [
        if (pets.length > 1)
          Padding(
            padding: const EdgeInsets.only(right: Space.sm),
            child: PawPill(
              label: l.allPets,
              selected: all,
              leading: Icon(Ph.pawPrintFill, size: IconSizes.sm + Space.xxs, color: all ? context.paw.surface : context.paw.textPrimary),
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
              leading: PetAvatar(species: p.species, colorTag: p.colorTag, photoUrl: p.photoUrl, size: avatar, ring: false),
              onTap: () => notifier.selectPet(p.id),
            ),
          ),
        PawPill(
          label: l.addPet,
          outlined: true,
          leading: Icon(Ph.plus, size: IconSizes.sm + Space.xxs, color: context.paw.textSecondary),
          onTap: () => context.push('/pets/new'),
        ),
      ]),
    );
  }
}
