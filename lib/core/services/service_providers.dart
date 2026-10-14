import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../providers.dart';
import 'messaging_service.dart';
import 'storage_service.dart';

/// Picks the Demo or Live implementation of each outside service from
/// APP_MODE (overridable per service). Demo never calls a real service.
final storageServiceProvider = Provider<StorageService>((ref) {
  final cfg = ref.watch(appConfigProvider);
  if (cfg.isStandalone) return DemoStorageService(ref.watch(prefsProvider));
  return FirebaseStorageService(FirebaseStorage.instance);
});

final messagingServiceProvider = Provider<MessagingService>((ref) {
  final cfg = ref.watch(appConfigProvider);
  if (cfg.serviceMode('messaging') == AppMode.demo) {
    return DemoMessagingService(ref.watch(firestoreProvider));
  }
  return LiveMessagingService(FirebaseFunctions.instanceFor(region: 'asia-south1'));
});
