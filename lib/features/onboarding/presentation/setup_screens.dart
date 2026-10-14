import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/settings/settings_controller.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/widgets.dart';
import '../../pets/data/pets_repository.dart';
import '../../pets/domain/pet.dart';
import '../../pets/presentation/pet_labels.dart';

/// Shared frame for the three setup steps with a step indicator.
class _SetupFrame extends StatelessWidget {
  const _SetupFrame({required this.step, required this.title, this.subtitle, required this.children, required this.actions});
  final int step;
  final String title;
  final String? subtitle;
  final List<Widget> children;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Column(children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(context.gutter),
                  children: [
                    Semantics(
                      label: context.l10n.stepOf(step, 3),
                      child: LinearProgressIndicator(
                        value: step / 3,
                        minHeight: 6,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(height: Space.xl),
                    Semantics(header: true, child: Text(title, style: context.text.headlineSmall)),
                    if (subtitle != null) ...[
                      const SizedBox(height: Space.sm),
                      Text(subtitle!, style: context.text.bodyMedium?.copyWith(color: context.paw.textSecondary)),
                    ],
                    const SizedBox(height: Space.xl),
                    ...children,
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.all(context.gutter), child: Column(children: actions)),
            ]),
          ),
        ),
      ),
    );
  }
}

/// Step 1: language, theme and Easy mode.
class SetupPreferencesScreen extends ConsumerWidget {
  const SetupPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final s = ref.watch(settingsProvider);
    final n = ref.read(settingsProvider.notifier);
    final user = ref.watch(currentUserProvider);
    return _SetupFrame(
      step: 1,
      title: user?.firstName.isNotEmpty == true ? l.setupHello(user!.firstName) : l.setupHelloNoName,
      subtitle: l.setupPrefsSubtitle,
      actions: [
        PrimaryButton(
          label: l.next,
          onPressed: () async {
            if (user != null) {
              await ref.read(firestoreProvider).collection('users').doc(user.uid).update({
                'language': s.locale,
                'easyMode': s.easyMode,
              });
            }
            if (context.mounted) context.go('/setup/pet');
          },
        ),
      ],
      children: [
        Text(l.language, style: context.text.titleSmall),
        const SizedBox(height: Space.sm),
        ChoiceRow<String>(
          options: const ['en', 'hi', 'te'],
          selected: s.locale,
          onSelected: n.setLocale,
          label: (c) => switch (c) { 'hi' => 'हिन्दी', 'te' => 'తెలుగు', _ => 'English' },
        ),
        const SizedBox(height: Space.xl),
        Text(l.appearance, style: context.text.titleSmall),
        const SizedBox(height: Space.sm),
        ChoiceRow<ThemeMode>(
          options: ThemeMode.values,
          selected: s.themeMode,
          onSelected: n.setThemeMode,
          label: (m) => themeModeLabel(context, m),
        ),
        const SizedBox(height: Space.xl),
        PawCard(
          child: SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: s.easyMode,
            onChanged: n.setEasyMode,
            title: Text(l.easyMode, style: context.text.titleSmall),
            subtitle: Text(l.easyModeHint),
            secondary: Icon(Icons.accessibility_new_rounded, color: context.colors.primary),
          ),
        ),
      ],
    );
  }
}

String themeModeLabel(BuildContext context, ThemeMode m) => switch (m) {
      ThemeMode.light => context.l10n.themeLight,
      ThemeMode.dark => context.l10n.themeDark,
      ThemeMode.system => context.l10n.themeSystem,
    };

/// Step 2: add the first pet (only name and species required).
class SetupFirstPetScreen extends ConsumerStatefulWidget {
  const SetupFirstPetScreen({super.key});
  @override
  ConsumerState<SetupFirstPetScreen> createState() => _SetupFirstPetScreenState();
}

class _SetupFirstPetScreenState extends ConsumerState<SetupFirstPetScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  String _species = 'dog';
  bool _busy = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_form.currentState?.validate() ?? false)) return;
    final user = ref.read(currentUserProvider);
    if (user == null) return;
    setState(() => _busy = true);
    final id = await ref.read(petsRepositoryProvider).addPet(
          Pet(ownerId: user.uid, name: _name.text.trim(), species: _species, colorTag: 'amber'),
          ownerName: user.name,
        );
    ref.read(settingsProvider.notifier).selectPet(id);
    if (mounted) context.go('/setup/notifications');
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return _SetupFrame(
      step: 2,
      title: l.setupPetTitle,
      subtitle: l.setupPetSubtitle,
      actions: [
        PrimaryButton(label: l.addPet, loading: _busy, onPressed: _save),
        const SizedBox(height: Space.sm),
        TextButton(onPressed: () => context.go('/setup/notifications'), child: Text(l.skipForNow)),
      ],
      children: [
        Form(
          key: _form,
          child: PawTextField(
            label: l.petName,
            controller: _name,
            autofocus: true,
            prefixIcon: Icons.pets_rounded,
            validator: (v) => (v == null || v.trim().isEmpty) ? l.fieldRequired : null,
          ),
        ),
        Text(l.species, style: context.text.titleSmall),
        const SizedBox(height: Space.sm),
        Row(children: [
          for (final sp in const ['dog', 'cat', 'bird', 'rabbit'])
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Semantics(
                  selected: sp == _species,
                  button: true,
                  label: speciesLabel(context, sp),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(Radii.card),
                    onTap: () => setState(() => _species = sp),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: Space.md),
                      decoration: BoxDecoration(
                        color: sp == _species ? context.paw.primaryContainer : context.paw.surface,
                        borderRadius: BorderRadius.circular(Radii.card),
                        border: Border.all(
                          color: sp == _species ? context.colors.primary : context.paw.outline,
                          width: sp == _species ? 2 : 1,
                        ),
                      ),
                      child: Column(children: [
                        PetFace(species: sp, color: const Color(0xFFF4A261), size: 52),
                        const SizedBox(height: Space.xs),
                        Text(speciesLabel(context, sp), style: context.text.labelMedium, textAlign: TextAlign.center),
                      ]),
                    ),
                  ),
                ),
              ),
            ),
        ]),
        if (_species == 'bird') ...[
          const SizedBox(height: Space.md),
          InfoNote(l.birdLegalNote),
        ],
      ],
    );
  }
}

/// Step 3: explain why notifications help, then ask permission.
class SetupNotificationsScreen extends ConsumerStatefulWidget {
  const SetupNotificationsScreen({super.key});
  @override
  ConsumerState<SetupNotificationsScreen> createState() => _SetupNotificationsScreenState();
}

class _SetupNotificationsScreenState extends ConsumerState<SetupNotificationsScreen> {
  bool _busy = false;

  Future<void> _finish({required bool ask}) async {
    setState(() => _busy = true);
    if (ask) await ref.read(notificationServiceProvider).requestPermission();
    final user = ref.read(currentUserProvider);
    if (user != null) {
      await ref.read(firestoreProvider).collection('users').doc(user.uid).update({'onboarded': true});
    }
    if (mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return _SetupFrame(
      step: 3,
      title: l.setupNotifTitle,
      subtitle: l.setupNotifSubtitle,
      actions: [
        PrimaryButton(label: l.allowNotifications, loading: _busy, onPressed: () => _finish(ask: true)),
        const SizedBox(height: Space.sm),
        TextButton(onPressed: _busy ? null : () => _finish(ask: false), child: Text(l.notNow)),
      ],
      children: [
        for (final r in [
          (Icons.vaccines_rounded, l.notifReasonVaccines),
          (Icons.medication_rounded, l.notifReasonMedicines),
          (Icons.event_available_rounded, l.notifReasonBookings),
          (Icons.chat_bubble_rounded, l.notifReasonMessages),
        ])
          Padding(
            padding: const EdgeInsets.only(bottom: Space.md),
            child: Row(children: [
              CircleAvatar(
                backgroundColor: context.paw.primaryContainer,
                child: Icon(r.$1, color: context.colors.primary),
              ),
              const SizedBox(width: Space.md),
              Expanded(child: Text(r.$2, style: context.text.bodyLarge)),
            ]),
          ),
      ],
    );
  }
}
