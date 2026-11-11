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
    // UI Design 6: each slide is a row of pet doorways; the middle pet has
    // the full marigold garland over it.
    final slides = [
      (const ['misty', 'bruno', 'simba'], l.welcome1Title, l.welcome1Body),
      (const ['kiwi', 'max', 'coco'], l.welcome2Title, l.welcome2Body),
      (const ['tiger', 'luna', 'sheru'], l.welcome3Title, l.welcome3Body),
    ];
    final last = _index == slides.length - 1;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: Sizes.sheetMaxWidth),
            child: Column(children: [
              Padding(
                padding: EdgeInsets.all(context.gutter),
                child: const Row(children: [
                  PawSetuLogo(size: Sizes.logo, withName: true),
                  Spacer(),
                  LanguageMenu(),
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
                        _Colonnade(pets: s.$1),
                        const SizedBox(height: Space.xl),
                        Semantics(
                          header: true,
                          child: Text(s.$2, style: context.text.displaySmall, textAlign: TextAlign.center),
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
                    duration: Motion.enter,
                    margin: const EdgeInsets.all(Space.xs),
                    width: i == _index ? Space.xl : Sizes.dot,
                    height: Sizes.dot,
                    decoration: BoxDecoration(
                      color: i == _index ? context.paw.textPrimary : context.paw.controlBorder.withValues(alpha: Opacities.half),
                      borderRadius: BorderRadius.circular(Radii.xs),
                    ),
                  ),
              ]),
              Padding(
                padding: EdgeInsets.all(context.gutter),
                child: Row(children: [
                  if (!last) LinkButton(label: l.skip, onPressed: _finish),
                  const Spacer(),
                  PrimaryButton(
                    expand: false,
                    label: last ? l.getStarted : l.next,
                    icon: last ? null : Icons.arrow_forward_outlined,
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
                      icon: const Icon(Icons.science_outlined),
                      label: Text(l.exploreDemo),
                    ),
                  ),
                ),
              if (ref.watch(appConfigProvider).isDemo)
                Padding(
                  padding: EdgeInsets.fromLTRB(context.gutter, 0, context.gutter, context.gutter),
                  child: Text(l.welcomeLanguages, textAlign: TextAlign.center, style: context.text.bodySmall),
                ),
            ]),
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
    final side = context.isPhone ? Sizes.avatarLg + Space.xl : Sizes.profileAvatarSm;
    final mid = context.isPhone ? Sizes.garland : Sizes.garlandLarge;
    Widget photo(String name) => Image.asset('assets/images/demo/pets/$name.jpg', fit: BoxFit.cover, excludeFromSemantics: true);
    Widget sideArch(String name) => ArchClip(
      width: side / Sizes.archAspect,
      child: SizedBox(width: side / Sizes.archAspect, height: side, child: photo(name)),
    );
    return ExcludeSemantics(
      child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
        sideArch(pets[0]),
        const SizedBox(width: Space.sm),
        Container(
          padding: const EdgeInsets.fromLTRB(Space.sm, Space.sm, Space.sm, 0),
          decoration: BoxDecoration(color: paw.band, borderRadius: BorderRadius.vertical(top: Radius.circular(mid), bottom: const Radius.circular(Radii.xl))),
          child: Garland(photo: photo(pets[1]), done: 5, total: 5, size: mid),
        ),
        const SizedBox(width: Space.sm),
        sideArch(pets[2]),
      ]),
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
      child: Chip(
        avatar: const Icon(Icons.translate_outlined, size: IconSizes.chip),
        label: Text(languageName(locale)),
      ),
    );
  }
}

String languageName(String code) => switch (code) { 'hi' => 'हिन्दी', 'te' => 'తెలుగు', _ => 'English' };
