import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/settings/settings_controller.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/logo.dart';
import '../../../core/widgets/widgets.dart';

/// Hidden screen that shows every shared widget (Settings → About, tap 5×).
/// The theme toggle at the top switches light and dark in place.
class DesignGalleryScreen extends ConsumerWidget {
  const DesignGalleryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final mode = ref.watch(settingsProvider).themeMode;
    final isDark = mode == ThemeMode.dark || (mode == ThemeMode.system && Theme.of(context).brightness == Brightness.dark);
    final p = context.paw;
    Widget swatch(String name, Color c) => Column(children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(14), border: Border.all(color: p.outline)),
          ),
          const SizedBox(height: 4),
          Text(name, style: context.text.labelSmall),
        ]);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.designGallery),
        actions: [
          IconButton(
            tooltip: l.appearance,
            icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
            onPressed: () => ref.read(settingsProvider.notifier).setThemeMode(isDark ? ThemeMode.light : ThemeMode.dark),
          ),
        ],
      ),
      body: PageBody(maxWidth: 900, children: [
        const SectionHeader('Brand'),
        const Row(children: [PawSetuLogo(size: 56, withName: true)]),
        const SectionHeader('Colours'),
        Wrap(spacing: Space.md, runSpacing: Space.md, children: [
          swatch('Primary', context.colors.primary),
          swatch('Container', p.primaryContainer),
          swatch('Accent', p.accent),
          swatch('Background', p.background),
          swatch('Surface', p.surface),
          swatch('Success', p.success),
          swatch('Warning', p.warning),
          swatch('Error', p.error),
          swatch('SOS', p.sos),
          for (final e in PetTagColors.all.entries) swatch(e.key, e.value),
        ]),
        const SectionHeader('Type'),
        Text('Display 32', style: context.text.displaySmall),
        Text('Title 22', style: context.text.titleLarge),
        Text('Heading 18', style: context.text.titleMedium),
        Text('Body 16 · हिन्दी पाठ · తెలుగు పాఠం', style: context.text.bodyLarge),
        Text('Caption 13', style: context.text.bodySmall),
        const SectionHeader('Buttons'),
        PrimaryButton(label: 'Primary action', onPressed: () {}),
        const SizedBox(height: Space.sm),
        PrimaryButton(label: 'Loading', loading: true, onPressed: () {}),
        const SizedBox(height: Space.sm),
        SecondaryButton(label: 'Secondary', icon: Icons.add_rounded, onPressed: () {}),
        const SizedBox(height: Space.sm),
        PrimaryButton(label: 'Delete', danger: true, onPressed: () {}),
        const SectionHeader('Chips'),
        const Wrap(spacing: Space.sm, runSpacing: Space.sm, children: [
          StatusChip('Done', tone: ChipTone.success, icon: Icons.check_rounded),
          StatusChip('Due soon', tone: ChipTone.warning),
          StatusChip('Overdue', tone: ChipTone.error),
          StatusChip('Plus', tone: ChipTone.accent),
          StatusChip('Pending'),
        ]),
        const SizedBox(height: Space.sm),
        ChoiceRow<String>(options: const ['Dog', 'Cat', 'Bird', 'Rabbit'], selected: 'Dog', onSelected: (_) {}, label: (s) => s),
        const SectionHeader('Inputs'),
        const PawTextField(label: 'Pet name', hint: 'e.g. Bruno', prefixIcon: Icons.pets_rounded),
        const SectionHeader('Cards'),
        const ResponsiveGrid(minItemWidth: 200, children: [
          StatTile(label: 'Walk today', value: '3.2 km', icon: Icons.directions_walk_rounded),
          StatTile(label: 'Weight', value: '29 kg', icon: Icons.monitor_weight_rounded),
          StatTile(label: 'Next vaccine', value: '3 days', icon: Icons.vaccines_rounded),
        ]),
        const SizedBox(height: Space.md),
        const InfoNote('Indicative, always confirm with your vet.'),
        const SizedBox(height: Space.sm),
        const DemoBanner('Demo payment. No money is charged.'),
        const SectionHeader('Pet avatars'),
        const Wrap(spacing: Space.md, children: [
          PetAvatar(species: 'dog', colorTag: 'amber', size: 64),
          PetAvatar(species: 'cat', colorTag: 'lavender', size: 64),
          PetAvatar(species: 'bird', colorTag: 'mint', size: 64),
          PetAvatar(species: 'rabbit', colorTag: 'rose', size: 64, selected: true),
        ]),
        const SectionHeader('Progress ring and SOS'),
        Row(children: [
          const ProgressRing(progress: 0.6, center: Text('3/5')),
          const SizedBox(width: Space.xl),
          SosButton(onActivate: () => showToast(context, 'SOS activated (gallery)')),
          const SizedBox(width: Space.xl),
          SosButton(large: true, onActivate: () => showToast(context, 'SOS activated (gallery)')),
        ]),
        const SectionHeader('Bottom sheet and dialogs'),
        Wrap(spacing: Space.sm, runSpacing: Space.sm, children: [
          OutlinedButton(
            onPressed: () => showPawSheet<void>(context, builder: (c) => const Padding(
                  padding: EdgeInsets.only(bottom: Space.xl),
                  child: Text('Bottom sheet with 28 px top corners'),
                )),
            child: const Text('Open sheet'),
          ),
          OutlinedButton(
            onPressed: () => showDemoDialog(context, title: 'Demo', body: 'Demo: this would call +91 90000 00012'),
            child: const Text('Demo dialog'),
          ),
          OutlinedButton(
            onPressed: () => confirmAction(context, title: 'Delete this?', body: 'This cannot be undone.'),
            child: const Text('Confirm dialog'),
          ),
        ]),
        const SectionHeader('Illustrations'),
        Wrap(spacing: Space.md, runSpacing: Space.md, children: [
          for (final s in Scene.values) Illustration(s, size: 110),
        ]),
        const SectionHeader('States'),
        SizedBox(
          height: 300,
          child: EmptyState(title: 'No memories yet', message: 'Add Bruno\'s first photo.', actionLabel: 'Add photo', onAction: () {}, compact: true),
        ),
        SizedBox(height: 260, child: ErrorState(onRetry: () {})),
        const Skeleton(height: 84, radius: Radii.card),
      ]),
    );
  }
}
