import 'package:pawsetu/core/services/notification_service.dart';

/// Phone notifications need platform plugins the test sandbox doesn't have.
/// Their errors arrive asynchronously, and in tests that wait on real async
/// work (goldens, the text contrast check) they land in the middle of a
/// check. Screen tests use this no-op service instead.
class NoNotifications implements NotificationService {
  @override
  Future<void> init() async {}
  @override
  Future<bool> requestPermission() async => false;
  @override
  Future<void> schedule({required int id, required String title, required String body, required DateTime at, required String payload, bool medicineActions = false}) async {}
  @override
  Future<void> showNow({required int id, required String title, required String body, required String payload, bool medicineActions = false}) async {}
  @override
  Future<void> cancelAll() async {}
  @override
  Stream<NotificationTap> get taps => const Stream.empty();
  @override
  bool get supported => false;
}
