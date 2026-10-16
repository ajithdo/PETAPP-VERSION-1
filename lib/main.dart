import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/auth/auth_service.dart';
import 'core/config/app_config.dart';
import 'core/config/firebase_options.dart';
import 'core/demo/demo_store.dart';
import 'core/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  final config = AppConfig.fromEnvironment();
  runApp(_Root(config: config, overrides: await _setUp(config)));
}

/// Everything the app needs before its first screen.
Future<List<Override>> _setUp(AppConfig config) async {
  final prefs = await SharedPreferences.getInstance();

  final overrides = <Override>[
    appConfigProvider.overrideWithValue(config),
    prefsProvider.overrideWithValue(prefs),
  ];

  if (config.isStandalone) {
    final store = await DemoStore.open(prefs);
    overrides.addAll([
      firestoreProvider.overrideWithValue(store.db),
      demoStoreProvider.overrideWithValue(store),
      authServiceProvider.overrideWithValue(DemoAuthService(store.db, prefs)),
    ]);
  } else {
    await Firebase.initializeApp(options: firebaseOptionsFor(config));
    final db = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;
    final functions = FirebaseFunctions.instanceFor(region: 'asia-south1');
    if (config.backend == Backend.emulator) {
      final host = config.emulatorHost;
      db.useFirestoreEmulator(host, 8080);
      await auth.useAuthEmulator(host, 9099);
      functions.useFunctionsEmulator(host, 5001);
      await FirebaseStorage.instance.useStorageEmulator(host, 9199);
    }
    if (!kIsWeb) {
      db.settings = const Settings(persistenceEnabled: true);
    }
    overrides.addAll([
      firestoreProvider.overrideWithValue(db),
      authServiceProvider.overrideWithValue(
        FirebaseAuthService(auth, db, functions, demoLoginEnabled: config.isDemo),
      ),
    ]);
  }
  return overrides;
}

/// Holds the app; [restart] builds it again from scratch with a new set-up
/// (a fresh demo database after "Reset demo data").
class _Root extends StatefulWidget {
  const _Root({required this.config, required this.overrides});
  final AppConfig config;
  final List<Override> overrides;

  @override
  State<_Root> createState() => _RootState();
}

class _RootState extends State<_Root> {
  late List<Override> _overrides = widget.overrides;
  var _generation = 0;

  Future<void> _restart() async {
    final next = await _setUp(widget.config);
    if (!mounted) return;
    setState(() {
      _overrides = next;
      _generation++;
    });
  }

  @override
  Widget build(BuildContext context) => ProviderScope(
        key: ValueKey(_generation),
        overrides: [..._overrides, appRestartProvider.overrideWithValue(_restart)],
        child: const PawSetuApp(),
      );
}
