import 'seed.dart';
import 'seed_admin.dart';
import 'seed_bookings.dart';
import 'seed_health.dart';
import 'seed_messaging.dart';
import 'seed_orders.dart';
import 'seed_routine.dart';
import 'seed_safety.dart';
import 'seed_vault.dart';

/// Activity data added phase by phase: routine logs (Phase 3), health
/// records (Phase 4), bookings, chats, documents, album, orders, devices,
/// admin data.
void seedActivity(Add add, DateTime now, SeedData data) {
  seedRoutine(add, now);
  seedHealth(add, now, data);
  seedBookings(add, now);
  seedMessaging(add, now, data);
  seedVault(add, now, data);
  seedOrders(add, now, data);
  seedSafety(add, now, data);
  seedAdmin(add, now, data);
}
