import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/app_user.dart';
import '../../../core/l10n/gen/app_localizations.dart';
import '../../../core/providers.dart';
import '../../../core/routing/router.dart';
import '../../../core/services/messaging_service.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/services/service_providers.dart';
import '../../../core/settings/settings_controller.dart';
import '../../../core/utils/format.dart';
import '../../pets/data/pets_repository.dart';
import '../../pets/domain/pet.dart';
import '../data/health_repository.dart';
import '../domain/vaccine_schedule.dart';

/// Turns due items into reminders:
///  - schedules local notifications for the next 7 days (offline, mobile),
///  - when an item becomes due, adds it to the notification centre and
///    sends the other channels the user chose (Demo Outbox in demo mode),
///  - handles Given / Skip / Snooze from medicine notifications.
/// Quiet hours move reminders to the end of the quiet window, except
/// medicines, which ring on time.
class ReminderEngine {
  ReminderEngine(this.ref) {
    _start();
  }
  final Ref ref;
  Timer? _debounce;
  Timer? _tick;
  StreamSubscription<NotificationTap>? _taps;
  final _due = <String, List<DueItem>>{};

  NotificationService get _notes => ref.read(notificationServiceProvider);

  void _start() {
    _notes.init();
    _taps = _notes.taps.listen(_onTap);
    _tick = Timer.periodic(const Duration(minutes: 1), (_) => _dispatch());
    ref.onDispose(() {
      _debounce?.cancel();
      _tick?.cancel();
      _taps?.cancel();
    });
  }

  /// Called by the provider whenever a pet's due list changes.
  void update(Map<String, List<DueItem>> due) {
    _due
      ..clear()
      ..addAll(due);
    _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 2), () async {
      await _reschedule();
      await _dispatch();
    });
  }

  AppLocalizations get _l => lookupAppLocalizations(Locale(ref.read(settingsProvider).locale));

  Pet? _pet(String id) => ref.read(activePetsProvider).where((p) => p.id == id).firstOrNull;

  String _title(DueItem i) {
    final l = _l;
    final name = _pet(i.petId)?.name ?? '';
    return switch (i.kind) {
      'vaccine' => i.status == DoseStatus.overdue ? l.remVaccineOverdue(name, i.title) : l.remVaccineDue(name, i.title),
      'medicine' => l.remMedicine(name, i.title),
      'refill' => l.remRefill(i.title, name),
      'deworming' => l.remDeworming(name),
      'flea_tick' => l.remFleaTick(name),
      _ => i.title,
    };
  }

  String _type(DueItem i) => switch (i.kind) {
        'vaccine' => 'vaccines',
        'medicine' || 'refill' => 'medicines',
        'deworming' || 'flea_tick' => 'deworming',
        _ => 'custom',
      };

  String _key(DueItem i) => '${i.kind}|${i.refId ?? i.petId}|${i.at?.toIso8601String() ?? 'now'}';

  DateTime _respectQuiet(DateTime at, DueItem i) {
    final s = ref.read(settingsProvider);
    if (!s.quietHoursOn || i.kind == 'medicine') return at;
    final h = at.hour;
    final inQuiet = s.quietStart > s.quietEnd ? (h >= s.quietStart || h < s.quietEnd) : (h >= s.quietStart && h < s.quietEnd);
    if (!inQuiet) return at;
    var end = DateTime(at.year, at.month, at.day, s.quietEnd);
    if (!end.isAfter(at)) end = end.add(const Duration(days: 1));
    return end;
  }

  Future<void> _reschedule() async {
    final svc = _notes;
    if (!svc.supported) return;
    final settings = ref.read(settingsProvider);
    await svc.cancelAll();
    final now = DateTime.now();
    final horizon = now.add(const Duration(days: 7));
    var n = 0;
    for (final list in _due.values) {
      for (final i in list) {
        if (i.at == null || i.at!.isBefore(now) || i.at!.isAfter(horizon)) continue;
        if (!settings.channelsFor(_type(i)).contains('push')) continue;
        // Vaccines and care reminders ring at 9 am on the day; medicines at the dose time.
        final base = i.kind == 'medicine' ? i.at! : DateTime(i.at!.year, i.at!.month, i.at!.day, 9);
        await svc.schedule(
          id: 1000 + n++,
          title: _title(i),
          body: _l.remTapToOpen,
          at: _respectQuiet(base, i),
          payload: i.kind == 'medicine' ? 'med|${i.refId}|${i.petId}|${i.at!.toIso8601String()}' : 'pet|${i.petId}',
          medicineActions: i.kind == 'medicine',
        );
        if (n >= 60) return;
      }
    }
  }

  /// Items that are due now go to the notification centre and to the
  /// email/SMS/WhatsApp channels the user picked (once each).
  Future<void> _dispatch() async {
    final user = ref.read(currentUserProvider);
    if (user == null || user.role != UserRole.owner) return;
    final prefs = ref.read(prefsProvider);
    final sent = prefs.getStringList('dispatched_${user.uid}')?.toSet() ?? <String>{};
    final settings = ref.read(settingsProvider);
    final now = DateTime.now();
    final db = ref.read(firestoreProvider);
    final msg = ref.read(messagingServiceProvider);
    var changed = false;
    for (final list in _due.values) {
      for (final i in list) {
        final due = i.status == DoseStatus.overdue || (i.at != null && !i.at!.isAfter(now) && now.difference(i.at!).inHours < 24);
        if (!due) continue;
        final key = _key(i);
        if (sent.contains(key)) continue;
        if (_respectQuiet(now, i) != now) continue; // wait for quiet hours to end
        sent.add(key);
        changed = true;
        final title = _title(i);
        await db.collection('notifications').add({
          'uid': user.uid,
          'title': title,
          'body': i.at == null ? '' : Fmt.dateTime(i.at!, settings.locale),
          'type': _type(i),
          'link': '/health?pet=${i.petId}',
          'read': false,
          'createdAt': now,
        });
        for (final ch in settings.channelsFor(_type(i))) {
          if (ch == 'push') continue;
          final channel = Channel.values.firstWhere((c) => c.name == ch);
          await msg.send(
            channel: channel,
            to: channel == Channel.email ? (user.email ?? '') : (user.phone ?? ''),
            subject: channel == Channel.email ? title : null,
            body: title,
            uid: user.uid,
            type: 'reminder',
          );
        }
        if (i.kind == 'medicine' && _notes.supported) {
          await _notes.showNow(id: 900, title: title, body: _l.remTapToOpen, payload: 'med|${i.refId}|${i.petId}|${i.at!.toIso8601String()}', medicineActions: true);
        }
      }
    }
    if (changed) await prefs.setStringList('dispatched_${user.uid}', sent.toList());
  }

  Future<void> _onTap(NotificationTap t) async {
    final parts = t.payload.split('|');
    final router = ref.read(routerProvider);
    if (parts.first == 'med' && parts.length >= 4) {
      final user = ref.read(currentUserProvider);
      final pet = _pet(parts[2]);
      if (user == null || pet == null) return;
      final meds = await ref.read(healthRepositoryProvider).watchMedicines(pet.id).first;
      final med = meds.where((m) => m.id == parts[1]).firstOrNull;
      final dose = DateTime.tryParse(parts[3]);
      if (med == null || dose == null) return;
      switch (t.action) {
        case 'given':
        case 'skip':
          await ref.read(healthRepositoryProvider).logDose(med: med, status: t.action == 'given' ? 'given' : 'skipped', dose: dose, by: user, petName: pet.name);
        case 'snooze':
          await ref.read(healthRepositoryProvider).logDose(med: med, status: 'snoozed', dose: dose, by: user, petName: pet.name);
          await _notes.schedule(
            id: 901,
            title: _l.remMedicine(pet.name, med.name),
            body: _l.remSnoozed,
            at: DateTime.now().add(const Duration(minutes: 15)),
            payload: t.payload,
            medicineActions: true,
          );
        default:
          router.push('/health?pet=${pet.id}');
      }
      return;
    }
    if (parts.first == 'pet' && parts.length > 1) router.push('/health?pet=${parts[1]}');
  }
}

/// Keeps the engine alive while someone is signed in and feeds it due items.
final reminderEngineProvider = Provider<ReminderEngine?>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null || user.role != UserRole.owner) return null;
  final engine = ReminderEngine(ref);
  final pets = ref.watch(activePetsProvider);
  final due = <String, List<DueItem>>{};
  for (final p in pets) {
    final v = ref.watch(petDueProvider(p));
    if (v.hasValue) due[p.id] = v.value!;
  }
  engine.update(due);
  return engine;
});
