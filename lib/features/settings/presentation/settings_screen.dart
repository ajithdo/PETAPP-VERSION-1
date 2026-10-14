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
      body: PageBody(maxWidth: 720, children: [
        group(l.language, [
          RadioGroup<String>(
            groupValue: s.locale,
            onChanged: (v) {
              n.setLocale(v!);
              _saveProfile({'language': v});
            },
            child: Column(children: [
              for (final code in const ['en', 'hi', 'te'])
                RadioListTile<String>(
                  value: code,
                  title: Text(switch (code) { 'hi' => 'हिन्दी (Hindi)', 'te' => 'తెలుగు (Telugu)', _ => 'English' }),
                ),
            ]),
          ),
        ]),
        group(l.appearance, [
          RadioGroup<ThemeMode>(
            groupValue: s.themeMode,
            onChanged: (v) => n.setThemeMode(v!),
            child: Column(children: [
              for (final m in const [ThemeMode.system, ThemeMode.light, ThemeMode.dark])
                RadioListTile<ThemeMode>(value: m, title: Text(themeModeLabel(context, m))),
            ]),
          ),
        ]),
        group(l.accessibility, [
          SwitchListTile(
            value: s.easyMode,
            title: Text(l.easyMode),
            subtitle: Text(l.easyModeHint),
            secondary: const Icon(Icons.accessibility_new_rounded),
            onChanged: (v) {
              n.setEasyMode(v);
              _saveProfile({'easyMode': v});
            },
          ),
          ListTile(
            leading: const Icon(Icons.format_size_rounded),
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
            secondary: const Icon(Icons.contrast_rounded),
            onChanged: n.setHighContrast,
          ),
        ]),
        group(l.notifications, [
          ListTile(
            leading: const Icon(Icons.notifications_active_rounded),
            title: Text(l.notificationChannels),
            subtitle: Text(l.notificationChannelsHint),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push(notificationSettingsLink),
          ),
        ]),
        if (cfg.isDemo)
          group(l.demoData, [
            ListTile(
              leading: const Icon(Icons.science_rounded),
              title: Text(l.demoModeOn),
              subtitle: Text(cfg.isStandalone ? l.demoStandaloneHint : l.demoEmulatorHint),
            ),
            if (store != null)
              ListTile(
                leading: const Icon(Icons.restart_alt_rounded),
                title: Text(l.resetDemoData),
                subtitle: Text(l.resetDemoDataHint),
                trailing: _resetting ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5)) : null,
                onTap: _resetting
                    ? null
                    : () async {
                        final ok = await confirmAction(context, title: l.resetDemoData, body: l.resetDemoDataConfirm);
                        if (!ok) return;
                        setState(() => _resetting = true);
                        await ref.read(authServiceProvider).signOut();
                        await store.reset();
                        if (mounted) setState(() => _resetting = false);
                      },
              ),
          ]),
        group(l.about, [
          ListTile(
            leading: const Icon(Icons.info_outline_rounded),
            title: const Text('PawSetu'),
            subtitle: Text(l.aboutVersion('1.0.0 (Version 1 demo)')),
            onTap: () {
              _aboutTaps++;
              if (_aboutTaps >= 5) {
                _aboutTaps = 0;
                context.push('/design-gallery');
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.map_rounded),
            title: Text(l.mapCredit),
          ),
        ]),
        const SizedBox(height: Space.xl),
        SecondaryButton(
          label: l.signOut,
          icon: Icons.logout_rounded,
          onPressed: () => ref.read(authServiceProvider).signOut(),
        ),
      ]),
    );
  }
}
