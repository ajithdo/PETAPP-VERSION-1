import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import 'app_config.dart';

/// Firebase options.
///
/// Version 1 uses the Local Emulator Suite with the project id
/// "demo-pawsetu"; "demo-" projects need no real Firebase project, so the
/// keys below are placeholders the emulators accept.
///
/// Version 2 (L1): run `flutterfire configure` for pawsetu-dev and
/// pawsetu-prod, then return the generated options here. Never commit
/// secrets; these web/app keys are public identifiers by design.
FirebaseOptions firebaseOptionsFor(AppConfig config) {
  final projectId = config.firebaseProjectId;
  const apiKey = String.fromEnvironment('FIREBASE_API_KEY', defaultValue: 'demo-api-key');
  const appIdWeb = String.fromEnvironment('FIREBASE_APP_ID_WEB', defaultValue: '1:000000000000:web:0000000000000000');
  const appIdAndroid =
      String.fromEnvironment('FIREBASE_APP_ID_ANDROID', defaultValue: '1:000000000000:android:0000000000000000');
  const appIdIos = String.fromEnvironment('FIREBASE_APP_ID_IOS', defaultValue: '1:000000000000:ios:0000000000000000');
  final appId = kIsWeb
      ? appIdWeb
      : switch (defaultTargetPlatform) {
          TargetPlatform.android => appIdAndroid,
          TargetPlatform.iOS => appIdIos,
          _ => appIdWeb,
        };
  return FirebaseOptions(
    apiKey: apiKey,
    appId: appId,
    messagingSenderId: '000000000000',
    projectId: projectId,
    storageBucket: '$projectId.appspot.com',
    authDomain: '$projectId.firebaseapp.com',
    iosBundleId: 'com.pawsetu.app',
  );
}
