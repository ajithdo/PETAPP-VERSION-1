import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../core/settings/settings_controller.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/logo.dart';
import '../../../core/widgets/widgets.dart';

/// 3 short welcome slides (spec 5: onboarding under 60 seconds).
class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});
  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  final _page = PageController();
  int _index = 0;

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  void _finish({String to = '/signin'}) {
    ref.read(settingsProvider.notifier).setOnboardingSeen();
    context.go(to);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final slides = [
      (Scene.welcomeCare, l.welcome1Title, l.welcome1Body),
      (Scene.welcomeHealth, l.welcome2Title, l.welcome2Body),
      (Scene.welcomeBridge, l.welcome3Title, l.welcome3Body),
    ];
    final last = _index == slides.length - 1;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Column(children: [
              Padding(
                padding: EdgeInsets.all(context.gutter),
                child: Row(children: [
                  const PawSetuLogo(size: 36, withName: true),
                  const Spacer(),
                  _LanguageMenu(),
                ]),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _page,
                  itemCount: slides.length,
                  onPageChanged: (i) => setState(() => _index = i),
                  itemBuilder: (context, i) {
                    final s = slides[i];
                    return SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: context.gutter),
                      child: Column(children: [
                        const SizedBox(height: Space.xl),
                        Illustration(s.$1, size: context.isPhone ? 240 : 280),
                        const SizedBox(height: Space.xl),
                        Semantics(
                          header: true,
                          child: Text(s.$2, style: context.text.headlineMedium, textAlign: TextAlign.center),
                        ),
                        const SizedBox(height: Space.md),
                        Text(s.$3,
                            style: context.text.bodyLarge?.copyWith(color: context.paw.textSecondary),
                            textAlign: TextAlign.center),
                      ]),
                    );
                  },
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                for (var i = 0; i < slides.length; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.all(4),
                    width: i == _index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: i == _index ? context.colors.primary : context.paw.outline,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
              ]),
              Padding(
                padding: EdgeInsets.all(context.gutter),
                child: Row(children: [
                  if (!last) TextButton(onPressed: _finish, child: Text(l.skip)),
                  const Spacer(),
                  PrimaryButton(
                    expand: false,
                    label: last ? l.getStarted : l.next,
                    icon: last ? null : Icons.arrow_forward_rounded,
                    onPressed: last
                        ? _finish
                        : () => _page.nextPage(
                            duration: Duration(milliseconds: context.reduceMotion ? 1 : 280), curve: Curves.easeOut),
                  ),
                ]),
              ),
              if (ref.watch(appConfigProvider).isDemo)
                Padding(
                  padding: EdgeInsets.fromLTRB(context.gutter, 0, context.gutter, context.gutter),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _finish(to: '/demo'),
                      icon: const Icon(Icons.science_rounded),
                      label: Text(l.exploreDemo),
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

class _LanguageMenu extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(settingsProvider).locale;
    return PopupMenuButton<String>(
      tooltip: context.l10n.language,
      initialValue: locale,
      onSelected: ref.read(settingsProvider.notifier).setLocale,
      itemBuilder: (_) => const [
        PopupMenuItem(value: 'en', child: Text('English')),
        PopupMenuItem(value: 'hi', child: Text('हिन्दी')),
        PopupMenuItem(value: 'te', child: Text('తెలుగు')),
      ],
      child: Chip(
        avatar: const Icon(Icons.translate_rounded, size: 18),
        label: Text(languageName(locale)),
      ),
    );
  }
}

String languageName(String code) => switch (code) { 'hi' => 'हिन्दी', 'te' => 'తెలుగు', _ => 'English' };
