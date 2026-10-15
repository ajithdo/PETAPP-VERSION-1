import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/l10n/gen/app_localizations.dart';
import 'features/admin/admin_slots.dart';
import 'features/health/application/reminder_engine.dart';
import 'core/providers.dart';
import 'core/routing/router.dart';
import 'core/settings/settings_controller.dart';
import 'core/theme/app_theme.dart';

class PawSetuApp extends ConsumerWidget {
  const PawSetuApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final router = ref.watch(routerProvider);
    // Reminders run while an owner is signed in.
    ref.watch(reminderEngineProvider);
    // Admin changes in config/app (e.g. vaccine timings) apply straight away.
    ref.watch(configSyncProvider);

    // Apply the language and Easy mode saved on the signed-in profile.
    ref.listen(currentUserProvider, (prev, next) async {
      if (next == null || prev?.uid == next.uid) return;
      final profile = await ref.read(firestoreProvider).collection('users').doc(next.uid).get();
      final data = profile.data();
      ref.read(settingsProvider.notifier).applyProfile(
            language: data?['language'] as String?,
            easyMode: data?['easyMode'] as bool?,
          );
      // Finish an invite link opened before signing in.
      final prefs = ref.read(prefsProvider);
      final pendingJoin = prefs.getString('pending_join');
      if (pendingJoin != null) {
        await prefs.remove('pending_join');
        router.go('/join/$pendingJoin');
      }
    });

    ThemeData theme(Brightness b) => AppTheme.build(
          brightness: b,
          locale: settings.locale,
          highContrast: settings.highContrast,
          easyMode: settings.easyMode,
        );

    return MaterialApp.router(
      title: 'PawSetu',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      locale: Locale(settings.locale),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      themeMode: settings.themeMode,
      theme: theme(Brightness.light),
      darkTheme: theme(Brightness.dark),
      builder: (context, child) {
        final mq = MediaQuery.of(context);
        // User text size × Easy mode boost, capped so layouts never break.
        final scale = (mq.textScaler.scale(1) * settings.effectiveTextScale).clamp(0.8, 2.0);
        return MediaQuery(
          data: mq.copyWith(textScaler: TextScaler.linear(scale)),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
