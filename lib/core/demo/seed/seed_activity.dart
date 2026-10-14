import 'seed.dart';
import 'seed_routine.dart';

/// Activity data added phase by phase: routine logs (Phase 3), health
/// records, bookings, chats, documents, album, orders, devices, admin data.
void seedActivity(Add add, DateTime now, SeedData data) {
  seedRoutine(add, now);
}
