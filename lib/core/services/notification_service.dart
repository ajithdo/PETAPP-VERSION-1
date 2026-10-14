import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Push and local notifications. Phase 1 only records the permission step;
/// Phase 4 adds scheduled local reminders and Firebase Cloud Messaging.
abstract class NotificationService {
  Future<bool> requestPermission();
}

class BasicNotificationService implements NotificationService {
  @override
  Future<bool> requestPermission() async => true;
}

final notificationServiceProvider = Provider<NotificationService>((ref) => BasicNotificationService());
