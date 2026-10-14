import 'seed.dart';
import 'seed_health.dart';
import 'seed_routine.dart';

/// Activity data added phase by phase: routine logs (Phase 3), health
/// records (Phase 4), bookings, chats, documents, album, orders, devices,
/// admin data.
void seedActivity(Add add, DateTime now, SeedData data) {
  seedRoutine(add, now);
  seedHealth(add, now, data);
}
