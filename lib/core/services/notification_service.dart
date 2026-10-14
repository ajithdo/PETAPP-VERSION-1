import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// A tapped notification or one of its action buttons.
class NotificationTap {
  const NotificationTap({required this.payload, this.action});
  final String payload;

  /// given, skip, snooze or null for a plain tap.
  final String? action;
}

/// Local reminders that work offline (spec 7.4). On Android and iOS they are
/// real scheduled notifications; on the website reminders appear in the
/// in-app notification centre instead.
abstract class NotificationService {
  Future<void> init();
  Future<bool> requestPermission();
  Future<void> schedule({required int id, required String title, required String body, required DateTime at, required String payload, bool medicineActions = false});
  Future<void> showNow({required int id, required String title, required String body, required String payload, bool medicineActions = false});
  Future<void> cancelAll();
  Stream<NotificationTap> get taps;
  bool get supported;
}

const _channelId = 'reminders';
const _medCategory = 'medicine';

class LocalNotificationService implements NotificationService {
  final _plugin = FlutterLocalNotificationsPlugin();
  final _taps = StreamController<NotificationTap>.broadcast();
  bool _ready = false;

  @override
  bool get supported => !kIsWeb && (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS);

  @override
  Stream<NotificationTap> get taps => _taps.stream;

  @override
  Future<void> init() async {
    if (!supported || _ready) return;
    tzdata.initializeTimeZones();
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(info.identifier));
    } catch (_) {
      tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));
    }
    final darwin = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      notificationCategories: [
        DarwinNotificationCategory(_medCategory, actions: [
          DarwinNotificationAction.plain('given', 'Given', options: {DarwinNotificationActionOption.foreground}),
          DarwinNotificationAction.plain('skip', 'Skip', options: {DarwinNotificationActionOption.foreground}),
          DarwinNotificationAction.plain('snooze', 'Snooze', options: {DarwinNotificationActionOption.foreground}),
        ]),
      ],
    );
    await _plugin.initialize(
      settings: InitializationSettings(
        android: const AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: darwin,
      ),
      onDidReceiveNotificationResponse: (r) => _taps.add(NotificationTap(payload: r.payload ?? '', action: r.actionId)),
    );
    final launch = await _plugin.getNotificationAppLaunchDetails();
    final r = launch?.notificationResponse;
    if (launch?.didNotificationLaunchApp == true && r != null) {
      Future.delayed(const Duration(seconds: 2), () => _taps.add(NotificationTap(payload: r.payload ?? '', action: r.actionId)));
    }
    _ready = true;
  }

  @override
  Future<bool> requestPermission() async {
    if (!supported) return true;
    await init();
    final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) return await android.requestNotificationsPermission() ?? false;
    final ios = _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    return await ios?.requestPermissions(alert: true, badge: true, sound: true) ?? false;
  }

  NotificationDetails _details(bool medicine) => NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          'Reminders',
          channelDescription: 'Vaccines, medicines and care reminders',
          importance: Importance.high,
          priority: Priority.high,
          actions: medicine
              ? const [
                  AndroidNotificationAction('given', 'Given', showsUserInterface: true),
                  AndroidNotificationAction('skip', 'Skip', showsUserInterface: true),
                  AndroidNotificationAction('snooze', 'Snooze 15 min', showsUserInterface: true),
                ]
              : null,
        ),
        iOS: DarwinNotificationDetails(categoryIdentifier: medicine ? _medCategory : null),
      );

  @override
  Future<void> schedule({required int id, required String title, required String body, required DateTime at, required String payload, bool medicineActions = false}) async {
    if (!supported) return;
    await init();
    if (at.isBefore(DateTime.now())) return;
    await _plugin.zonedSchedule(
      id: id,
      scheduledDate: tz.TZDateTime.from(at, tz.local),
      notificationDetails: _details(medicineActions),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      title: title,
      body: body,
      payload: payload,
    );
  }

  @override
  Future<void> showNow({required int id, required String title, required String body, required String payload, bool medicineActions = false}) async {
    if (!supported) return;
    await init();
    await _plugin.show(id: id, title: title, body: body, notificationDetails: _details(medicineActions), payload: payload);
  }

  @override
  Future<void> cancelAll() async {
    if (!supported) return;
    await init();
    await _plugin.cancelAll();
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) => LocalNotificationService());
