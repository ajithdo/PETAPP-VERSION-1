import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../core/routing/settings_links.dart';
import '../../../core/settings/settings_controller.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/widgets.dart';
import '../../onboarding/presentation/setup_screens.dart';
import '../../../core/theme/ph.dart';

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

  /// Sends the "change your password" link (demo: lands in the Demo Outbox).
  Future<void> _password(String email) async {
    final l = context.l10n;
    final ok = await confirmAction(context, title: l.setEmailPassword, body: '$email\n\n${l.setResetPassword}', confirmLabel: l.sendResetLink, danger: false);
    if (!ok) return;
    try {
      await ref.read(authServiceProvider).sendPasswordReset(email);
      if (mounted) showToast(context, l.setResetSent(email));
    } catch (_) {
      if (mounted) showToast(context, l.errorTitle);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final s = ref.watch(settingsProvider);
    final n = ref.read(settingsProvider.notifier);
    final cfg = ref.watch(appConfigProvider);
    final store = ref.watch(demoStoreProvider);

    final paw = context.paw;
    const gap = SizedBox(height: Sizes.sectionGap);
    // A titled group of rows in a hairline panel.
    Widget group(String title, List<Widget> children) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            gap,
            SecHead(title),
            PawPanel(padding: PawPanel.listPadding, child: PawList(children: children)),
          ],
        );
    Widget toggle(IconData icon, Tone tone, String title, String sub, bool value, ValueChanged<bool>? onChanged) => MergeSemantics(
          child: PawItem(
            lead: PawTile(icon: icon, tone: tone),
            title: title,
            sub: sub,
            subMaxLines: 4,
            onTap: onChanged == null ? null : () => onChanged(!value),
            trailing: Switch(value: value, onChanged: onChanged),
          ),
        );
    final user = ref.watch(currentUserProvider);
    // "10:00 PM"
    String hour(int h) => MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay(hour: h % 24, minute: 0));

    return Scaffold(
      appBar: AppBar(title: Text(l.settings)),
      body: PageBody(maxWidth: Space.formWidth, children: [
        // UI Design 6: languages show their own script; appearance shows
        // a small preview. One tap chooses.
        const SizedBox(height: Space.sm),
        SecHead(l.language),
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
        const SizedBox(height: Space.sm),
        Text(l.languageNote, style: context.text.bodySmall?.copyWith(color: paw.textSecondary)),
        gap,
        SecHead(l.appearance),
        _PickRow(children: [
          for (final m in const [ThemeMode.system, ThemeMode.light, ThemeMode.dark])
            _Pick(
              selected: s.themeMode == m,
              label: themeModeLabel(context, m),
              onTap: () => n.setThemeMode(m),
              top: _ThemePreview(mode: m),
              title: m == ThemeMode.system ? l.themeSystemShort : themeModeLabel(context, m),
            ),
        ]),
        group(l.notifications, [
          PawItem(
            lead: const PawTile(icon: Ph.bellRinging, tone: Tone.gold),
            title: l.setReminderChannels,
            sub: l.setReminderChannelsHint,
            onTap: () => context.push(notificationSettingsLink),
          ),
          PawItem(
            lead: const PawTile(icon: Ph.moon, tone: Tone.sky),
            title: l.quietHours,
            sub: s.quietHoursOn ? l.setQuietRange(hour(s.quietStart), hour(s.quietEnd)) : l.setQuietOff,
            onTap: () => context.push(notificationSettingsLink),
          ),
        ]),
        group(l.accessibility, [
          toggle(Ph.personArmsSpread, Tone.green, l.easyMode, l.easyModeHint, s.easyMode, (v) {
            n.setEasyMode(v);
            _saveProfile({'easyMode': v});
          }),
          // Text size: a small A, the slider, a big A.
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Space.md),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Row(children: [
                Expanded(child: Text(l.textSize, style: context.text.labelLarge)),
                Text('${(s.textScale * 100).round()}%', style: context.text.labelLarge),
              ]),
              Row(children: [
                Text('A', style: context.text.labelSmall?.copyWith(fontWeight: FontWeight.w700)),
                Expanded(
                  child: Slider(
                    value: s.textScale,
                    min: 0.85,
                    max: 1.6,
                    divisions: 15,
                    label: '${(s.textScale * 100).round()}%',
                    semanticFormatterCallback: (v) => '${(v * 100).round()}%',
                    onChanged: n.setTextScale,
                  ),
                ),
                Text('A', style: context.text.titleLarge),
              ]),
              Text(l.textSizeNote, style: context.text.bodySmall?.copyWith(color: paw.textSecondary)),
            ]),
          ),
          toggle(Ph.circleHalf, Tone.neutral, l.highContrast, l.highContrastHint, s.highContrast, n.setHighContrast),
          // Easy mode always asks on a tap, so the switch shows on and can't
          // be turned off while it's on.
          toggle(Ph.handTap, Tone.neutral, l.setSosTap, l.setSosTapHint, s.sosByTap, s.easyMode ? null : n.setSosTap),
        ]),
        group(l.setAccount, [
          PawItem(
            lead: const PawTile(icon: Ph.envelopeSimple),
            title: l.setEmailPassword,
            sub: (user?.email ?? '').isEmpty ? l.setNoEmail : user!.email!,
            noTrailing: (user?.email ?? '').isEmpty,
            onTap: (user?.email ?? '').isEmpty ? null : () => _password(user!.email!),
          ),
          PawItem(
            lead: const PawTile(icon: Ph.deviceMobile),
            title: l.phone,
            sub: (user?.phone ?? '').isEmpty ? l.setNoPhone : user!.phone!,
            noTrailing: true,
          ),
          PawItem(
            lead: const PawTile(icon: Ph.info),
            title: l.setAbout,
            sub: cfg.isDemo ? l.setAboutDemo('1.0') : l.aboutVersion('1.0'),
            subMaxLines: 2,
            noTrailing: true,
            onTap: () {
              _aboutTaps++;
              if (_aboutTaps >= 5) {
                _aboutTaps = 0;
                context.push('/design-gallery');
              }
            },
          ),
        ]),
        if (cfg.isDemo)
          group(l.demoData, [
            PawItem(
              lead: const PawTile(icon: Ph.flask, tone: Tone.gold),
              title: l.demoModeOn,
              sub: cfg.isStandalone ? l.demoStandaloneHint : l.demoEmulatorHint,
            ),
            if (store != null)
              PawItem(
                lead: const PawTile(icon: Ph.arrowCounterClockwise),
                title: l.resetDemoData,
                sub: l.resetDemoDataHint,
                trailing: _resetting ? const SizedBox(width: Sizes.spinner, height: Sizes.spinner, child: CircularProgressIndicator(strokeWidth: Strokes.spinner)) : const Chev(),
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
        const SizedBox(height: Space.lg),
        Text(l.mapCredit, style: context.text.bodySmall?.copyWith(color: paw.textSecondary), textAlign: TextAlign.center),
        const SizedBox(height: Space.lg),
        PawButton(label: l.signOut, icon: Ph.signOut, kind: BtnKind.line, size: BtnSize.regular, block: true, onPressed: () => ref.read(authServiceProvider).signOut()),
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

/// A small picture of the app in light, dark, or cut corner to corner for
/// "System": a marigold line over a grey one on that theme's paper.
class _ThemePreview extends StatelessWidget {
  const _ThemePreview({required this.mode});
  final ThemeMode mode;

  @override
  Widget build(BuildContext context) {
    const light = PawColors.light, dark = PawColors.dark;
    Widget face(PawColors c) => ColoredBox(
          color: c.background,
          child: Padding(
            padding: const EdgeInsets.all(Space.sm),
            child: Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(width: Space.xl, height: Space.xs, decoration: BoxDecoration(color: c.marigold, borderRadius: BorderRadius.circular(Radii.xs))),
              const SizedBox(height: Space.xs),
              Container(width: Space.xxl + Space.sm, height: Space.xs, decoration: BoxDecoration(color: c.textSecondary, borderRadius: BorderRadius.circular(Radii.xs))),
            ]),
          ),
        );
    return Padding(
      // Leaves room for the radio dot in the tile's corner.
      padding: const EdgeInsets.only(right: Space.xs),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Radii.sm),
        child: Container(
          height: Sizes.thumb - Space.sm,
          foregroundDecoration: BoxDecoration(border: Border.all(color: context.tint.line2), borderRadius: BorderRadius.circular(Radii.sm)),
          child: switch (mode) {
            ThemeMode.light => face(light),
            ThemeMode.dark => face(dark),
            _ => Stack(fit: StackFit.expand, children: [face(light), ClipPath(clipper: const _Diagonal(), child: face(dark))]),
          },
        ),
      ),
    );
  }
}

/// The bottom-right half of a box, cut from the top right to the bottom left.
class _Diagonal extends CustomClipper<Path> {
  const _Diagonal();

  @override
  Path getClip(Size size) => Path()
    ..moveTo(size.width, 0)
    ..lineTo(size.width, size.height)
    ..lineTo(0, size.height)
    ..close();

  @override
  bool shouldReclip(_Diagonal oldClipper) => false;
}
