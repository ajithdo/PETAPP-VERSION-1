import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../core/routing/settings_links.dart';
import '../../../core/settings/settings_controller.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/widgets.dart';
import '../../onboarding/presentation/setup_screens.dart';

/// Settings (spec 4 and 5): language, appearance, accessibility,
/// notifications, demo data and about.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});
  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  int _aboutTaps = 0;
  bool _resetting = false;

  Future<void> _saveProfile(Map<String, dynamic> fields) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;
    await ref.read(firestoreProvider).collection('users').doc(user.uid).update(fields);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final s = ref.watch(settingsProvider);
    final n = ref.read(settingsProvider.notifier);
    final cfg = ref.watch(appConfigProvider);
    final store = ref.watch(demoStoreProvider);

    Widget group(String title, List<Widget> children) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionHeader(title),
            PawCard(padding: const EdgeInsets.symmetric(vertical: Space.sm), child: Column(children: children)),
          ],
        );

    return Scaffold(
      appBar: AppBar(title: Text(l.settings)),
      body: PageBody(maxWidth: Space.formWidth, children: [
        // UI Design 6: languages show their own script; appearance shows
        // a small preview. One tap chooses.
        SectionHeader(l.language),
        _PickRow(children: [
          for (final (code, glyph, name, sub) in const [
            ('en', 'Aa', 'English', 'English'),
            ('hi', 'अ', 'हिन्दी', 'Hindi'),
            ('te', 'అ', 'తెలుగు', 'Telugu'),
          ])
            _Pick(
              selected: s.locale == code,
              label: '$name, $sub',
              onTap: () {
                n.setLocale(code);
                _saveProfile({'language': code});
              },
              top: Text(glyph, style: context.text.headlineMedium?.copyWith(fontFamilyFallback: const [FontFamilies.devanagari, FontFamilies.telugu])),
              title: name,
              subtitle: sub,
            ),
        ]),
        SectionHeader(l.appearance),
        _PickRow(children: [
          for (final m in const [ThemeMode.system, ThemeMode.light, ThemeMode.dark])
            _Pick(
              selected: s.themeMode == m,
              label: themeModeLabel(context, m),
              onTap: () => n.setThemeMode(m),
              top: _ThemePreview(mode: m),
              title: themeModeLabel(context, m),
            ),
        ]),
        group(l.accessibility, [
          SwitchListTile(
            value: s.easyMode,
            title: Text(l.easyMode),
            subtitle: Text(l.easyModeHint),
            secondary: const Icon(Icons.accessibility_new_outlined),
            onChanged: (v) {
              n.setEasyMode(v);
              _saveProfile({'easyMode': v});
            },
          ),
          ListTile(
            leading: const Icon(Icons.format_size_outlined),
            title: Text(l.textSize),
            subtitle: Slider(
              value: s.textScale,
              min: 0.85,
              max: 1.6,
              divisions: 15,
              label: '${(s.textScale * 100).round()}%',
              semanticFormatterCallback: (v) => '${(v * 100).round()}%',
              onChanged: n.setTextScale,
            ),
            trailing: Text('${(s.textScale * 100).round()}%'),
          ),
          SwitchListTile(
            value: s.highContrast,
            title: Text(l.highContrast),
            subtitle: Text(l.highContrastHint),
            secondary: const Icon(Icons.contrast_outlined),
            onChanged: n.setHighContrast,
          ),
        ]),
        group(l.notifications, [
          ListTile(
            leading: const Icon(Icons.notifications_active_outlined),
            title: Text(l.notificationChannels),
            subtitle: Text(l.notificationChannelsHint),
            trailing: const Icon(Icons.chevron_right_outlined),
            onTap: () => context.push(notificationSettingsLink),
          ),
        ]),
        if (cfg.isDemo)
          group(l.demoData, [
            ListTile(
              leading: const Icon(Icons.science_outlined),
              title: Text(l.demoModeOn),
              subtitle: Text(cfg.isStandalone ? l.demoStandaloneHint : l.demoEmulatorHint),
            ),
            if (store != null)
              ListTile(
                leading: const Icon(Icons.restart_alt_outlined),
                title: Text(l.resetDemoData),
                subtitle: Text(l.resetDemoDataHint),
                trailing: _resetting ? const SizedBox(width: Sizes.spinner, height: Sizes.spinner, child: CircularProgressIndicator(strokeWidth: Strokes.spinner)) : null,
                onTap: _resetting
                    ? null
                    : () async {
                        final ok = await confirmAction(context, title: l.resetDemoData, body: l.resetDemoDataConfirm);
                        if (!ok) return;
                        setState(() => _resetting = true);
                        await ref.read(authServiceProvider).signOut();
                        await store.reset();
                        // Start again on the demo accounts.
                        await ref.read(prefsProvider).setString(startAtKey, '/signin');
                        if (context.mounted) context.go('/signin');
                        await ref.read(appRestartProvider)();
                      },
              ),
          ]),
        group(l.about, [
          ListTile(
            leading: const Icon(Icons.info_outlined),
            title: const Text('PawSetu'),
            subtitle: Text(l.aboutVersion('1.0.0 (DEMO VERSION 1)')),
            onTap: () {
              _aboutTaps++;
              if (_aboutTaps >= 5) {
                _aboutTaps = 0;
                context.push('/design-gallery');
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.map_outlined),
            title: Text(l.mapCredit),
          ),
        ]),
        const SizedBox(height: Space.xl),
        SecondaryButton(
          label: l.signOut,
          icon: Icons.logout_outlined,
          onPressed: () => ref.read(authServiceProvider).signOut(),
        ),
      ]),
    );
  }
}

/// Choice cards in a row (three across; stacked with big text).
class _PickRow extends StatelessWidget {
  const _PickRow({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => TileGrid(columns: MediaQuery.textScalerOf(context).scale(1) > 1.4 ? 1 : 3, spacing: Space.sm, children: children);
}

/// One choice card: a picture or glyph on top, a title, a radio dot.
class _Pick extends StatelessWidget {
  const _Pick({required this.selected, required this.label, required this.onTap, required this.top, required this.title, this.subtitle});
  final bool selected;
  final String label;
  final VoidCallback onTap;
  final Widget top;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final paw = context.paw;
    return Semantics(
      button: true,
      selected: selected,
      inMutuallyExclusiveGroup: true,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: selected ? paw.surface : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.lg),
          side: BorderSide(color: selected ? paw.textPrimary : paw.outline, width: selected ? Strokes.strong : Strokes.hairline),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(Radii.lg),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(Space.md),
            child: Stack(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                top,
                const SizedBox(height: Space.xs),
                Text(title, style: context.text.titleSmall),
                if (subtitle != null) Text(subtitle!, style: context.text.bodySmall),
              ]),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: IconSizes.md,
                  height: IconSizes.md,
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: selected ? paw.textPrimary : paw.controlBorder, width: Strokes.focus)),
                  child: selected
                      ? Center(child: Container(width: Space.sm + Space.xxs, height: Space.sm + Space.xxs, decoration: BoxDecoration(color: paw.marigold, shape: BoxShape.circle)))
                      : null,
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

/// A tiny picture of the app in light, dark, or split for "System".
class _ThemePreview extends StatelessWidget {
  const _ThemePreview({required this.mode});
  final ThemeMode mode;

  @override
  Widget build(BuildContext context) {
    const light = PawColors.light, dark = PawColors.dark;
    Widget half(PawColors c) => ColoredBox(
          color: c.background,
          child: Padding(
            padding: const EdgeInsets.all(Space.sm),
            child: Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(width: Space.xl, height: Space.xs, decoration: BoxDecoration(color: c.marigold, borderRadius: BorderRadius.circular(Radii.xs))),
              const SizedBox(height: Space.xs),
              Container(width: Space.xxl, height: Space.xs, decoration: BoxDecoration(color: c.textSecondary, borderRadius: BorderRadius.circular(Radii.xs))),
            ]),
          ),
        );
    return ClipRRect(
      borderRadius: BorderRadius.circular(Radii.sm),
      child: Container(
        height: Sizes.thumb,
        decoration: BoxDecoration(border: Border.all(color: context.paw.outline)),
        child: switch (mode) {
          ThemeMode.light => half(light),
          ThemeMode.dark => half(dark),
          _ => Row(children: [Expanded(child: half(light)), Expanded(child: half(dark))]),
        },
      ),
    );
  }
}
