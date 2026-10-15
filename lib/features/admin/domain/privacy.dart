/// Privacy centre (spec 7.14): what "Download my data" includes, and the
/// grace period before an account is deleted.
///
/// Pure Dart: shared by the app, the unit tests and functions/src/phase10.ts.
library;

/// Days between "Delete my account" and the actual deletion. Signing in
/// during this time lets the person cancel.
const deletionGraceDays = 30;

DateTime deletionDate(DateTime requestedAt) => requestedAt.add(const Duration(days: deletionGraceDays));

/// One part of the export: documents in [collection] whose [field] matches
/// the person ([byPet]: the field holds one of the person's own pet ids).
class ExportPart {
  const ExportPart(this.collection, this.field, {this.byPet = false, this.arrayContains = false});
  final String collection;
  final String field;
  final bool byPet;
  final bool arrayContains;
}

/// Everything about the person: their profile, the pets they own and those
/// pets' records, and what they wrote, booked, bought or reported.
const exportParts = <ExportPart>[
  ExportPart('pets', 'ownerId'),
  ExportPart('logs', 'byUid'),
  ExportPart('vaccinations', 'petId', byPet: true),
  ExportPart('medicines', 'petId', byPet: true),
  ExportPart('medicineLogs', 'petId', byPet: true),
  ExportPart('healthEvents', 'petId', byPet: true),
  ExportPart('reminders', 'ownerId'),
  ExportPart('notifications', 'uid'),
  ExportPart('bookings', 'ownerId'),
  ExportPart('reviews', 'ownerId'),
  ExportPart('conversations', 'participantIds', arrayContains: true),
  ExportPart('messages', 'senderId'),
  ExportPart('consultations', 'ownerId'),
  ExportPart('prescriptions', 'petId', byPet: true),
  ExportPart('documents', 'ownerId'),
  ExportPart('insurance', 'ownerId'),
  ExportPart('album', 'ownerId'),
  ExportPart('shareLinks', 'ownerId'),
  ExportPart('orders', 'ownerId'),
  ExportPart('subscriptions', 'ownerId'),
  ExportPart('expenses', 'ownerId'),
  ExportPart('devices', 'ownerId'),
  ExportPart('sosLogs', 'uid'),
  ExportPart('lostReports', 'ownerId'),
  ExportPart('tickets', 'uid'),
  ExportPart('referrals', 'referrerId'),
  ExportPart('payments', 'uid'),
];

/// Firestore values (timestamps, nested maps) as plain JSON.
Object? plainJson(Object? v, String Function(Object) dateToIso) {
  if (v == null || v is String || v is num || v is bool) return v;
  if (v is DateTime) return v.toUtc().toIso8601String();
  if (v is List) return [for (final x in v) plainJson(x, dateToIso)];
  if (v is Map) return {for (final e in v.entries) '${e.key}': plainJson(e.value, dateToIso)};
  return dateToIso(v);
}
