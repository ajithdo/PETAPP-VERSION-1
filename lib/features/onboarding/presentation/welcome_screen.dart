import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../core/settings/settings_controller.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/logo.dart';
import '../../../core/widgets/widgets.dart';
import '../../../core/theme/ph.dart';

/// 3 short welcome slides (spec 5: onboarding under 60 seconds).
class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});
  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  int _index = 0;

  void _finish({String to = '/signin'}) {
    ref.read(settingsProvider.notifier).setOnboardingSeen();
    context.go(to);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    // UI Design 6: each slide is a row of pet doorways; the middle pet has
    // the full marigold garland over it.
    final slides = [
      (const ['misty', 'bruno', 'simba'], l.welcome1Title, l.welcome1Body),
      (const ['kiwi', 'max', 'coco'], l.welcome2Title, l.welcome2Body),
      (const ['tiger', 'luna', 'sheru'], l.welcome3Title, l.welcome3Body),
    ];
    final last = _index == slides.length - 1;
    final paw = context.paw;
    void next() => last ? _finish() : setState(() => _index++);
    void back() {
      if (_index > 0) setState(() => _index--);
    }

    final s = slides[_index];
    final demo = ref.watch(appConfigProvider).isDemo;
    // UI Design 6: everything flows from the top (nothing pinned to the
    // bottom): the doorways, the words, the dots, then the buttons. Swipe or
    // tap Next to change the slide.
    return Scaffold(
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(context.gutter, Space.sm, context.gutter, context.gutter + Space.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: Sizes.narrowPage),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                const Row(children: [
                  PawSetuLogo(size: Sizes.topLogo, withName: true),
                  Spacer(),
                  LanguageMenu(),
                ]),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onHorizontalDragEnd: (d) {
                    final v = d.primaryVelocity ?? 0;
                    if (v < 0 && !last) next();
                    if (v > 0) back();
                  },
                  child: AnimatedSwitcher(
                    duration: context.reduceMotion ? Duration.zero : Motion.enter,
                    child: Column(key: ValueKey(_index), children: [
                      const SizedBox(height: Sizes.sectionGap),
                      _Colonnade(pets: s.$1),
                      const SizedBox(height: Space.xxl),
                      Semantics(header: true, child: Text(s.$2, style: context.text.displaySmall, textAlign: TextAlign.center)),
                      const SizedBox(height: Space.md),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: Sizes.placeCardMinWidth),
                        child: Text(s.$3, style: context.text.bodyMedium?.copyWith(color: paw.textSecondary), textAlign: TextAlign.center),
                      ),
                    ]),
                  ),
                ),
                const SizedBox(height: Space.xl),
                Semantics(
                  label: '${_index + 1} / ${slides.length}',
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    for (var i = 0; i < slides.length; i++)
                      AnimatedContainer(
                        duration: Motion.enter,
                        margin: const EdgeInsets.symmetric(horizontal: Space.xs),
                        width: i == _index ? Space.xl + Space.xs : Space.xs + Space.xxs,
                        height: Space.xs + Space.xxs,
                        decoration: BoxDecoration(color: i == _index ? paw.textPrimary : context.tint.line2, borderRadius: BorderRadius.circular(Radii.lg)),
                      ),
                  ]),
                ),
                const SizedBox(height: Space.xl),
                Row(children: [
                  if (!last) TextLink(l.skip, onTap: _finish),
                  const Spacer(),
                  PawButton(label: last ? l.getStarted : l.next, icon: last ? null : Ph.arrowRight, size: BtnSize.regular, onPressed: next),
                ]),
                if (demo) ...[
                  const SizedBox(height: Space.lg),
                  PawButton(label: l.exploreDemo, icon: Ph.flask, kind: BtnKind.line, size: BtnSize.regular, block: true, onPressed: () => _finish(to: '/demo')),
                  const SizedBox(height: Space.lg),
                  Text(l.welcomeLanguages, textAlign: TextAlign.center, style: context.text.bodySmall?.copyWith(color: paw.textSecondary)),
                ],
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

/// Three pet doorways in a row: two side pets in their arches, and the
/// middle pet on the dark band under a full marigold garland.
class _Colonnade extends StatelessWidget {
  const _Colonnade({required this.pets});
  final List<String> pets;

  @override
  Widget build(BuildContext context) {
    final paw = context.paw;
    Widget photo(String name) => Image.asset('assets/images/demo/pets/$name.png', fit: BoxFit.cover, excludeFromSemantics: true);
    return ExcludeSemantics(
      child: LayoutBuilder(builder: (context, box) {
        // The design's sizes (84 px side arches, a 168 px garland in a dark
        // doorway); a little smaller when the screen is narrow.
        const full = 2 * Sizes.welcomeArch + 2 * Space.sm + Sizes.welcomeGarland + 2 * Space.md;
        final k = (box.maxWidth / full).clamp(0.6, 1.0);
        final side = Sizes.welcomeArch * k, mid = Sizes.welcomeGarland * k;
        Widget sideArch(String name) => ArchClip(width: side, child: SizedBox(width: side, height: side * Sizes.archAspect, child: photo(name)));
        return Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
          sideArch(pets[0]),
          const SizedBox(width: Space.sm),
          Container(
            padding: EdgeInsets.fromLTRB(Space.md * k, Space.md * k, Space.md * k, 0),
            decoration: BoxDecoration(color: paw.band, borderRadius: BorderRadius.vertical(top: Radius.circular(mid), bottom: const Radius.circular(Radii.xl + Space.xxs))),
            child: Garland(photo: photo(pets[1]), done: 5, total: 5, size: mid),
          ),
          const SizedBox(width: Space.sm),
          sideArch(pets[2]),
        ]);
      }),
    );
  }
}

/// Language switch shown before sign-in (welcome and sign-in pages).
class LanguageMenu extends ConsumerWidget {
  const LanguageMenu({super.key});

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
      // A quiet chip: the language's own name and a small arrow.
      child: IgnorePointer(child: PawChip(label: languageName(locale), icon: Ph.translate, trailing: Ph.caretDown)),
    );
  }
}

String languageName(String code) => switch (code) { 'hi' => 'हिन्दी', 'te' => 'తెలుగు', _ => 'English' };
