import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/logo.dart';
import '../../../core/widgets/widgets.dart';

class PortalSection {
  const PortalSection(this.key, this.icon, this.label);
  final String key;
  final IconData icon;
  final String label;
}

/// Web-first frame for the partner portal and the admin panel: a sidebar
/// on wide screens, a drawer on phones.
class PortalScaffold extends ConsumerWidget {
  const PortalScaffold({
    super.key,
    required this.basePath,
    required this.title,
    required this.sections,
    required this.current,
    required this.body,
    this.actions = const [],
  });

  final String basePath;
  final String title;
  final List<PortalSection> sections;
  final String current;
  final Widget body;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final wide = !context.isPhone;
    final idx = sections.indexWhere((s) => s.key == current).clamp(0, sections.length - 1);
    void go(int i) {
      final key = sections[i].key;
      context.go(key == 'dashboard' ? basePath : '$basePath/$key');
    }

    // Keyed by section: opening a page from a web address or the browser's
    // back button builds a fresh menu with the right item highlighted.
    final nav = NavigationDrawer(
      key: ValueKey('nav-$current'),
      selectedIndex: idx,
      onDestinationSelected: (i) {
        if (!wide) Navigator.of(context).pop();
        go(i);
      },
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(Space.xl, Space.xl, Space.lg, Space.sm),
          child: PawSetuLogo(size: 36, withName: true),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(Space.xl, 0, Space.lg, Space.md),
          child: Text(title, style: context.text.bodySmall),
        ),
        for (final s in sections) NavigationDrawerDestination(icon: Icon(s.icon), label: Text(s.label)),
        const Padding(padding: EdgeInsets.symmetric(horizontal: Space.xl, vertical: Space.sm), child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Space.lg),
          child: ListTile(
            leading: const Icon(Icons.settings_rounded),
            title: Text(context.l10n.settings),
            onTap: () => context.push('/settings'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Space.lg),
          child: ListTile(
            leading: const Icon(Icons.logout_rounded),
            title: Text(context.l10n.signOut),
            onTap: () => ref.read(authServiceProvider).signOut(),
          ),
        ),
      ],
    );

    final appBar = AppBar(
      title: Text(sections[idx].label),
      actions: [
        ...actions,
        if (user != null)
          Padding(
            padding: const EdgeInsets.only(right: Space.md),
            // On a phone the name would squeeze the page title: initial only.
            child: wide
                ? Chip(
                    avatar: const Icon(Icons.person_rounded, size: 18),
                    label: Text(user.name, overflow: TextOverflow.ellipsis),
                  )
                : Tooltip(
                    message: user.name,
                    child: CircleAvatar(radius: 16, child: Text(user.name.isEmpty ? '?' : user.name.characters.first.toUpperCase())),
                  ),
          ),
      ],
    );

    if (wide) {
      return Scaffold(
        body: Row(children: [
          SizedBox(width: 280, child: nav),
          const VerticalDivider(width: 1),
          Expanded(child: Scaffold(appBar: appBar, body: body)),
        ]),
      );
    }
    return Scaffold(appBar: appBar, drawer: nav, body: body);
  }
}
