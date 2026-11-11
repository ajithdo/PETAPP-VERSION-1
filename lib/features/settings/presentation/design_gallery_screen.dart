import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/settings/settings_controller.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/logo.dart';
import '../../../core/widgets/widgets.dart';

/// Hidden screen that shows every shared widget of UI Design 5 "Genda"
/// (DESIGN.md), for checking the design system (Settings → About, tap 5×).
/// The buttons at the top switch light, dark and high contrast in place.
/// Sample words here are design specimens, not app text.
class DesignGalleryScreen extends ConsumerWidget {
  const DesignGalleryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final settings = ref.watch(settingsProvider);
    final mode = settings.themeMode;
    final isDark = mode == ThemeMode.dark || (mode == ThemeMode.system && Theme.of(context).brightness == Brightness.dark);
    final p = context.paw;
    Widget swatch(String name, Color c) => SizedBox(
          width: Sizes.thumbXl + Space.lg,
          child: Column(children: [
            Container(
              width: Sizes.thumb,
              height: Sizes.thumb,
              decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(Radii.lg), border: Border.all(color: p.outline)),
            ),
            const SizedBox(height: Space.xs),
            Text(name, style: context.text.labelSmall, textAlign: TextAlign.center, maxLines: 2),
          ]),
        );
    Widget row({required Widget leading, required String title, String? subtitle, Widget? trailing}) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.md),
          child: Row(children: [
            leading,
            const SizedBox(width: Space.md),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: context.text.titleSmall),
                if (subtitle != null) Text(subtitle, style: context.text.bodySmall?.copyWith(color: p.textSecondary)),
              ]),
            ),
            if (trailing != null) ...[const SizedBox(width: Space.sm), trailing],
          ]),
        );
    Widget check(bool on) => Container(
          width: IconSizes.xl - Space.xs,
          height: IconSizes.xl - Space.xs,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: on ? p.done : null,
            border: on ? null : Border.all(color: p.controlBorder, width: Strokes.focus),
          ),
          child: on ? Icon(Icons.check_rounded, size: IconSizes.md, color: p.surface) : null,
        );
    Widget time(String t, String ampm) => SizedBox(
          width: Sizes.dateBadge,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(t, style: context.text.titleMedium),
            Text(ampm, style: context.text.labelSmall?.copyWith(color: p.textSecondary)),
          ]),
        );

    return Scaffold(
      appBar: AppBar(
        title: Text(l.designGallery),
        actions: [
          IconButton(
            tooltip: l.appearance,
            icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
            onPressed: () => ref.read(settingsProvider.notifier).setThemeMode(isDark ? ThemeMode.light : ThemeMode.dark),
          ),
          IconButton(
            tooltip: l.highContrast,
            isSelected: settings.highContrast,
            icon: const Icon(Icons.contrast_rounded),
            onPressed: () => ref.read(settingsProvider.notifier).setHighContrast(!settings.highContrast),
          ),
        ],
      ),
      body: PageBody(maxWidth: Space.wideWidth, children: [
        const SectionHeader('Brand'),
        const Row(children: [PawSetuLogo(size: Sizes.logoLg, withName: true)]),
        const SectionHeader('Colours'),
        Wrap(spacing: Space.sm, runSpacing: Space.md, children: [
          swatch('Cocoa (action)', p.action),
          swatch('Band', p.band),
          swatch('Marigold', p.marigold),
          swatch('Marigold ink', p.accent),
          swatch('Done', p.done),
          swatch('Tint', p.primaryContainer),
          swatch('Page', p.background),
          swatch('Card', p.surface),
          swatch('Grouped', p.surfaceSubtle),
          swatch('Hairline', p.outline),
          swatch('Control', p.controlBorder),
          swatch('Text', p.textPrimary),
          swatch('Secondary', p.textSecondary),
          swatch('Success', p.success),
          swatch('Warning', p.warning),
          swatch('Error (berry)', p.error),
          swatch('SOS (only red)', p.sos),
          for (final e in PetTagColors.all.entries) swatch(e.key, e.value),
        ]),
        const SectionHeader('Type'),
        Text('Display 36', style: context.text.displayLarge),
        Text('Headline 26', style: context.text.headlineMedium),
        Text('Title 21 · Coming up', style: context.text.titleLarge),
        Text('Title small 17 · Flea and tick prevention', style: context.text.titleSmall),
        Text('Body 16 · हिन्दी पाठ · తెలుగు పాఠం', style: context.text.bodyMedium),
        Text('Body small 14 · Friday 13 Nov · in 5 days', style: context.text.bodySmall?.copyWith(color: p.textSecondary)),
        Text('Label small 13 · the smallest text', style: context.text.labelSmall),
        const SectionHeader('Genda band (Home)'),
        GendaBand(petName: 'Bruno', dateLabel: 'Sunday, 8 November', photo: const PetAvatar(species: 'dog', colorTag: 'amber', size: Sizes.garland), done: 2, total: 4, onTap: () {}),
        const SizedBox(height: Space.md),
        const GendaBand(petName: 'Misty', photo: PetAvatar(species: 'cat', colorTag: 'lavender', size: Sizes.garland), done: 3, total: 3),
        const SizedBox(height: Space.md),
        const GendaBand(petName: 'Coco', photo: PetAvatar(species: 'rabbit', colorTag: 'rose', size: Sizes.garland), done: 0, total: 0),
        const SectionHeader('Pet switcher and filters'),
        Wrap(spacing: Space.sm, runSpacing: Space.sm, children: [
          PawPill(label: 'Bruno', selected: true, leading: const PetAvatar(species: 'dog', colorTag: 'amber', size: Sizes.avatarXs), onTap: () {}),
          PawPill(label: 'Misty', leading: const PetAvatar(species: 'cat', colorTag: 'lavender', size: Sizes.avatarXs), onTap: () {}),
          PawPill(label: '+', outlined: true, semanticLabel: 'Add a pet', onTap: () {}),
        ]),
        const SizedBox(height: Space.sm),
        Wrap(spacing: Space.sm, runSpacing: Space.sm, children: [
          FilterChip(label: const Text('Open now'), selected: true, onSelected: (_) {}),
          FilterChip(label: const Text('Home visit'), selected: false, onSelected: (_) {}),
        ]),
        const SizedBox(height: Space.sm),
        ChoiceRow<String>(options: const ['Dog', 'Cat', 'Bird', 'Rabbit'], selected: 'Dog', onSelected: (_) {}, label: (s) => s),
        const SectionHeader('Buttons'),
        PrimaryButton(label: 'Book for Bruno', onPressed: () {}),
        const SizedBox(height: Space.sm),
        PrimaryButton(label: 'Loading', loading: true, onPressed: () {}),
        const SizedBox(height: Space.sm),
        SecondaryButton(label: 'Mark as given', icon: Icons.check_rounded, onPressed: () {}),
        const SizedBox(height: Space.sm),
        Row(children: [
          TextButton(onPressed: () {}, child: const Text('See all')),
          const Spacer(),
          PawIconButton(icon: Icons.chat_bubble_outline_rounded, tooltip: 'Messages', badge: 1, onPressed: () {}),
          const SizedBox(width: Space.sm),
          PawIconButton(icon: Icons.notifications_none_rounded, tooltip: 'Notifications', badge: 2, onPressed: () {}),
        ]),
        const SizedBox(height: Space.sm),
        PrimaryButton(label: 'Cancel booking', danger: true, onPressed: () {}),
        const SectionHeader('SOS (the only red)'),
        Row(children: [
          SosButton(onActivate: () => showToast(context, 'SOS activated (gallery)')),
          const SizedBox(width: Space.xl),
          SosButton(large: true, onActivate: () => showToast(context, 'SOS activated (gallery)')),
        ]),
        const SectionHeader('Quick actions'),
        ResponsiveGrid(minItemWidth: Sizes.quickTileMin, children: [
          QuickActionTile(icon: Icons.medical_services_rounded, label: 'Book a vet', onTap: () {}),
          QuickActionTile(icon: Icons.videocam_rounded, label: 'Tele-vet', onTap: () {}),
          QuickActionTile(icon: Icons.replay_rounded, label: 'Buy again', onTap: () {}),
          QuickActionTile(icon: Icons.healing_rounded, label: 'First aid', onTap: () {}),
        ]),
        SectionHeader('List rows', action: 'See all', onAction: () {}),
        PawCard(
          padding: EdgeInsets.zero,
          child: Column(children: [
            row(leading: time('7:00', 'am'), title: 'Morning walk', subtitle: 'Done by Rohan · 2.1 km', trailing: check(true)),
            const Divider(),
            row(leading: time('6:30', 'pm'), title: 'Evening walk', subtitle: 'Usual route, 30 min', trailing: check(false)),
            const Divider(),
            row(
              leading: const DateBadge(day: '13', month: 'Nov'),
              title: 'Flea and tick prevention',
              subtitle: 'Spot-on, every 30 days',
              trailing: const StatusChip('Confirmed', tone: ChipTone.success, icon: Icons.check_rounded),
            ),
            const Divider(),
            row(leading: const DateBadge(day: '18', month: 'Nov 2025', muted: true), title: 'DHPPi + Lepto', subtitle: 'Given · Gulmohar Vet Studio'),
          ]),
        ),
        const SectionHeader('Status chips'),
        const Wrap(spacing: Space.sm, runSpacing: Space.sm, children: [
          StatusChip('Confirmed', tone: ChipTone.success, icon: Icons.check_rounded),
          StatusChip('Waiting for you', tone: ChipTone.warning, icon: Icons.schedule_rounded),
          StatusChip('Payment failed', tone: ChipTone.error, icon: Icons.error_outline_rounded),
          StatusChip('Plus', tone: ChipTone.accent, icon: Icons.workspace_premium_rounded),
          StatusChip('Cancelled'),
        ]),
        const SectionHeader('Cards'),
        const ResponsiveGrid(minItemWidth: 200, children: [
          StatTile(label: 'Walk today', value: '2.1 km', icon: Icons.directions_walk_rounded),
          StatTile(label: 'Weight', value: '29.0 kg', icon: Icons.monitor_weight_rounded),
          StatTile(label: 'Payout this week', value: '₹18,450', icon: Icons.payments_rounded),
        ]),
        const SizedBox(height: Space.md),
        PawAlertCard(
          icon: Icons.pest_control_rounded,
          overline: 'Next for Bruno',
          title: 'Flea and tick prevention',
          message: 'Friday 13 Nov · in 5 days',
          actionLabel: 'Mark as given',
          onAction: () {},
        ),
        const SizedBox(height: Space.sm),
        const PawAlertCard(icon: Icons.error_outline_rounded, title: "We couldn't save that", message: 'Check your internet and try again.', tone: ChipTone.error),
        const SizedBox(height: Space.sm),
        const InfoNote('Indicative, always confirm with your vet.'),
        const SizedBox(height: Space.sm),
        const DemoBanner('Demo payment. No money is charged.'),
        const SectionHeader('Health pass'),
        PassCard(
          overline: 'Medical card',
          overlineIcon: Icons.badge_rounded,
          title: 'Bruno',
          subtitle: 'Labrador · 3 years · 29.0 kg',
          badges: [PassCard.badge(context, 'All up to date')],
          rows: const [PassRow(label: 'Microchip', value: '9851 2100 4471 230', mono: true), PassRow(label: 'Allergies', value: 'None known')],
          actions: [PassCard.action(context, label: 'Share', icon: Icons.share_rounded, onPressed: () {})],
        ),
        const SectionHeader('Timeline'),
        const TimelineTile(tone: ChipTone.success, isFirst: true, child: Text('Anti-rabies · given 18 Nov 2025')),
        const TimelineTile(tone: ChipTone.warning, child: Text('DHPPi + Lepto · due Wed 18 Nov')),
        const TimelineTile(tone: ChipTone.neutral, isLast: true, child: Text('Annual check-up · Jul 2027')),
        const SectionHeader('Inputs'),
        const PawTextField(label: 'Pet name', hint: 'e.g. Bruno', prefixIcon: Icons.pets_rounded),
        const SizedBox(height: Space.md),
        PawTextField(label: 'Phone number', initialValue: '98765', validator: (_) => 'Enter all 10 digits of the phone number', autofocus: false),
        const SizedBox(height: Space.md),
        OptionCard(title: 'At the clinic', subtitle: 'Gulmohar Vet Studio, Indiranagar', selected: true, onTap: () {}),
        const SizedBox(height: Space.sm),
        OptionCard(title: 'Home visit', subtitle: '₹300 travel fee', selected: false, onTap: () {}),
        const SizedBox(height: Space.md),
        const PriceSummary(lines: [('Consultation', '₹750'), ('Platform fee', 'Free')], totalLabel: 'Total', total: '₹750'),
        const SectionHeader('Pet avatars and progress'),
        const Wrap(spacing: Space.md, runSpacing: Space.md, crossAxisAlignment: WrapCrossAlignment.center, children: [
          PetAvatar(species: 'dog', colorTag: 'amber', size: Sizes.thumbLg),
          PetAvatar(species: 'cat', colorTag: 'lavender', size: Sizes.thumbLg),
          PetAvatar(species: 'bird', colorTag: 'mint', size: Sizes.thumbLg),
          PetAvatar(species: 'rabbit', colorTag: 'rose', size: Sizes.thumbLg, selected: true),
          ProgressRing(progress: 0.6, center: Text('3/5')),
        ]),
        const SectionHeader('Navigation bar'),
        NavigationBar(
          selectedIndex: 0,
          onDestinationSelected: (_) {},
          destinations: [
            NavigationDestination(icon: const Icon(Icons.home_outlined), selectedIcon: const Icon(Icons.home_rounded), label: l.tabHome),
            NavigationDestination(icon: const Icon(Icons.favorite_border_rounded), selectedIcon: const Icon(Icons.favorite_rounded), label: l.tabHealth),
            NavigationDestination(icon: const Icon(Icons.calendar_month_outlined), selectedIcon: const Icon(Icons.calendar_month_rounded), label: l.tabBook),
            NavigationDestination(icon: const Icon(Icons.shopping_bag_outlined), selectedIcon: const Icon(Icons.shopping_bag_rounded), label: l.tabShop),
            NavigationDestination(icon: const Icon(Icons.person_outline_rounded), selectedIcon: const Icon(Icons.person_rounded), label: l.tabMe),
          ],
        ),
        const SectionHeader('Bottom sheet and dialogs'),
        Wrap(spacing: Space.sm, runSpacing: Space.sm, children: [
          OutlinedButton(
            onPressed: () => showPawSheet<void>(
              context,
              builder: (c) => const Padding(padding: EdgeInsets.only(bottom: Space.xl), child: Text('Bottom sheet with 28 px top corners')),
            ),
            child: const Text('Open sheet'),
          ),
          OutlinedButton(
            onPressed: () => showDemoDialog(context, title: 'Demo', body: 'Demo: this would call +91 90000 00012'),
            child: const Text('Demo dialog'),
          ),
          OutlinedButton(
            onPressed: () => confirmAction(context, title: 'Cancel this booking?', body: 'Gulmohar Vet Studio will be told.'),
            child: const Text('Confirm dialog'),
          ),
          OutlinedButton(onPressed: () => showToast(context, 'Marked as given', actionLabel: 'Undo', onAction: () {}), child: const Text('Snackbar')),
        ]),
        const SectionHeader('Drawings'),
        Wrap(spacing: Space.md, runSpacing: Space.md, children: [
          for (final s in Scene.values) Illustration(s, size: Sizes.illustrationSm),
        ]),
        const SectionHeader('States'),
        SizedBox(
          height: Sizes.galleryPreview,
          child: EmptyState(title: 'No memories yet', message: "Add Bruno's first photo.", actionLabel: 'Add photo', onAction: () {}, compact: true),
        ),
        SizedBox(height: Sizes.galleryPreviewSm, child: ErrorState(onRetry: () {})),
        const Skeleton(height: Sizes.skeletonCard, radius: Radii.card),
        const SizedBox(height: Space.xxl),
      ]),
    );
  }
}
