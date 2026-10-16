import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth/app_user.dart';
import 'auth/auth_service.dart';
import 'config/app_config.dart';
import 'demo/demo_store.dart';

/// Overridden in main.dart once Firebase / the demo store is ready.
final appConfigProvider = Provider<AppConfig>((ref) => throw UnimplementedError());
final prefsProvider = Provider<SharedPreferences>((ref) => throw UnimplementedError());
final firestoreProvider = Provider<FirebaseFirestore>((ref) => throw UnimplementedError());
final authServiceProvider = Provider<AuthService>((ref) => throw UnimplementedError());

/// Only set in standalone demo mode.
final demoStoreProvider = Provider<DemoStore?>((ref) => null);

/// Saved setting: where to open after the app restarts itself.
const startAtKey = 'startAt';

/// Starts the whole app again from scratch, with a new database (used after
/// "Reset demo data"). Set in main.dart.
final appRestartProvider = Provider<Future<void> Function()>((ref) => () async {});

final authStateProvider = StreamProvider<AppUser?>((ref) {
  return ref.watch(authServiceProvider).userChanges();
});

/// Current user or null (never loading for widgets that just need a value).
final currentUserProvider = Provider<AppUser?>((ref) {
  return ref.watch(authStateProvider).value;
});

/// Admin-configurable settings document (config/app).
final appSettingsDocProvider = StreamProvider<Map<String, dynamic>>((ref) {
  return ref
      .watch(firestoreProvider)
      .collection('config')
      .doc('app')
      .snapshots()
      .map((s) => s.data() ?? const {});
});

/// Plan limits for the current user, read from config/app.
final planLimitsProvider = Provider<Map<String, dynamic>>((ref) {
  final cfg = ref.watch(appSettingsDocProvider).value ?? const {};
  final user = ref.watch(currentUserProvider);
  final limits = (cfg['limits'] as Map?)?.cast<String, dynamic>() ?? const {};
  final key = (user?.isPlus ?? false) ? 'plus' : 'free';
  return (limits[key] as Map?)?.cast<String, dynamic>() ??
      const {
        'pets': 3,
        'teleVetPerMonth': 1,
        'teleVetMessages': 20,
        'teleVetWords': 60,
        'teleVetHours': 24,
        'aiQuestions': 5,
        'storageGb': 1,
        'family': 2,
        'videoSeconds': 60,
      };
});
