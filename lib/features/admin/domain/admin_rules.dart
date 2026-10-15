/// Admin panel rules (spec 10): dashboard numbers by day, week or month, top
/// lists, partner approvals and registration-number checks.
///
/// Pure Dart: shared by the app and the unit tests.
library;

class DayStats {
  const DayStats({
    required this.date,
    this.users = 0,
    this.pets = 0,
    this.bookings = 0,
    this.bookingValue = 0,
    this.orders = 0,
    this.orderValue = 0,
    this.commission = 0,
    this.subscriptions = 0,
    this.sos = 0,
  });

  final DateTime date;
  final int users;
  final int pets;
  final int bookings;
  final int bookingValue;
  final int orders;
  final int orderValue;
  final int commission;
  final int subscriptions;
  final int sos;

  static int _i(Object? v) => (v as num?)?.toInt() ?? 0;

  factory DayStats.fromMap(Map<String, dynamic> m, DateTime Function(Object?) date) => DayStats(
        date: date(m['date']),
        users: _i(m['users']),
        pets: _i(m['pets']),
        bookings: _i(m['bookings']),
        bookingValue: _i(m['bookingValue']),
        orders: _i(m['orders']),
        orderValue: _i(m['orderValue']),
        commission: _i(m['commission']),
        subscriptions: _i(m['subscriptions']),
        sos: _i(m['sos']),
      );

  DayStats operator +(DayStats o) => DayStats(
        date: date,
        users: users + o.users,
        pets: pets + o.pets,
        bookings: bookings + o.bookings,
        bookingValue: bookingValue + o.bookingValue,
        orders: orders + o.orders,
        orderValue: orderValue + o.orderValue,
        commission: commission + o.commission,
        subscriptions: subscriptions + o.subscriptions,
        sos: sos + o.sos,
      );
}

enum StatRange { day, week, month }

/// Sums days into days (the last 14), weeks starting on Monday (the last
/// 12) or calendar months (the last 3), oldest first.
List<DayStats> groupStats(List<DayStats> days, StatRange range) {
  final sorted = [...days]..sort((a, b) => a.date.compareTo(b.date));
  DateTime key(DateTime d) => switch (range) {
        StatRange.day => DateTime(d.year, d.month, d.day),
        StatRange.week => DateTime(d.year, d.month, d.day - (d.weekday - DateTime.monday)),
        StatRange.month => DateTime(d.year, d.month),
      };
  final groups = <DateTime, DayStats>{};
  for (final d in sorted) {
    final k = key(d.date);
    final cur = groups[k];
    groups[k] = cur == null ? DayStats(date: k) + d : cur + d;
  }
  final list = groups.values.toList()..sort((a, b) => a.date.compareTo(b.date));
  final keep = switch (range) { StatRange.day => 14, StatRange.week => 12, StatRange.month => 3 };
  return list.length <= keep ? list : list.sublist(list.length - keep);
}

/// Periods that have fully ended by [today]. The current week or month is
/// still filling up, so comparing it would look like a drop.
List<DayStats> completePeriods(List<DayStats> periods, StatRange range, DateTime today) {
  final t = DateTime(today.year, today.month, today.day);
  bool done(DateTime start) => switch (range) {
        StatRange.day => start.isBefore(t),
        StatRange.week => !DateTime(start.year, start.month, start.day + 7).isAfter(t),
        StatRange.month => !DateTime(start.year, start.month + 1).isAfter(t),
      };
  return [for (final p in periods) if (done(p.date)) p];
}

/// Change between the last two periods, in percent (null when unknown).
int? changePercent(List<DayStats> periods, int Function(DayStats) value) {
  if (periods.length < 2) return null;
  final prev = value(periods[periods.length - 2]);
  if (prev == 0) return null;
  return ((value(periods.last) - prev) * 100 / prev).round();
}

class Totals {
  const Totals({
    this.users = 0,
    this.owners = 0,
    this.partners = 0,
    this.pets = 0,
    this.bookings30 = 0,
    this.orderValue30 = 0,
    this.commission30 = 0,
    this.plusMembers = 0,
    this.sos30 = 0,
    this.topClinics = const [],
    this.topProducts = const [],
  });
  final int users;
  final int owners;
  final int partners;
  final int pets;
  final int bookings30;
  final int orderValue30;
  final int commission30;
  final int plusMembers;
  final int sos30;
  final List<(String, int)> topClinics;
  final List<(String, int)> topProducts;
}

/// Most frequent names first (ties by name), at most [max].
List<(String, int)> topCounts(Iterable<String> names, {int max = 5}) {
  final counts = <String, int>{};
  for (final n in names) {
    if (n.trim().isEmpty) continue;
    counts[n] = (counts[n] ?? 0) + 1;
  }
  final list = [for (final e in counts.entries) (e.key, e.value)]..sort((a, b) => b.$2 != a.$2 ? b.$2.compareTo(a.$2) : a.$1.compareTo(b.$1));
  return list.take(max).toList();
}

/// A partner listing waiting for (or after) review: a clinic, vet,
/// groomer, trainer, boarding/sitter, walker or seller.
class PendingPartner {
  PendingPartner(this.collection, this.id, this.raw, this.date);
  final String collection;
  final String id;
  final Map<String, dynamic> raw;
  final DateTime Function(Object?) date;

  String get name => (raw['name'] as String?) ?? '';

  /// clinic, vet, groomer, trainer, boarder, walker or seller
  String get kind => switch (collection) {
        'clinics' => 'clinic',
        'vets' => 'vet',
        'sellers' => 'seller',
        _ => (raw['type'] as String?) ?? 'groomer',
      };
  String get city => (raw['city'] as String?) ?? (raw['clinicName'] as String?) ?? '';
  String get status => (raw['status'] as String?) ?? 'pending';
  String? get ownerUid => (raw['ownerUid'] ?? raw['uid']) as String?;
  List<String> get kycDocs => ((raw['kycDocs'] as List?) ?? const []).cast<String>();

  /// Veterinary Council registration (clinics and vets).
  String? get regNo => (raw['regNo'] ?? raw['vcRegNo']) as String?;
  String get reason => (raw['reviewReason'] as String?) ?? '';
  DateTime get createdAt => date(raw['createdAt'] ?? raw['reviewedAt']);
}

const partnerKindsForAdmin = ['clinic', 'vet', 'groomer', 'trainer', 'boarder', 'walker', 'seller'];

/// Veterinary Council registration numbers look like DEMO-VC-0001 in the
/// demo, or a state council code and number (e.g. TSVC-12345) for real vets.
/// The admin still checks them against the council's register.
bool regNoLooksValid(String? regNo) {
  final r = (regNo ?? '').trim().toUpperCase();
  return RegExp(r'^(DEMO-VC-\d{4}|[A-Z]{2,5}VC[-/ ]?\d{3,6}|VCI[-/ ]?\d{3,6})$').hasMatch(r);
}

// ---------- commission report ----------

/// One partner's line in the monthly commission report.
class CommissionLine {
  CommissionLine(this.name, this.kind);
  final String name;

  /// booking (clinics and service providers) or shop (sellers)
  final String kind;
  int count = 0;
  int gross = 0;
  int commission = 0;
  int payout = 0;
}

class CommissionReport {
  const CommissionReport({required this.lines, required this.bookingCommission, required this.shopMargin, required this.plusRevenue, required this.refunds});
  final List<CommissionLine> lines;
  final int bookingCommission;
  final int shopMargin;
  final int plusRevenue;
  final int refunds;

  /// What the platform kept this month (demo money).
  int get platformTotal => bookingCommission + shopMargin + plusRevenue - refunds;

  /// Comma-separated values with [headers] (name, type, count, gross,
  /// commission, payout) and one row per partner.
  String toCsv(List<String> headers, String Function(String kind) kindLabel) {
    String cell(Object v) {
      final s = '$v';
      return s.contains(RegExp('[",\n]')) ? '"${s.replaceAll('"', '""')}"' : s;
    }

    return [
      headers.map(cell).join(','),
      for (final l in lines) [l.name, kindLabel(l.kind), l.count, l.gross, l.commission, l.payout].map(cell).join(','),
    ].join('\n');
  }
}

/// Booking statuses that earn commission (money was or will be taken).
const commissionBookingStatuses = ['confirmed', 'in_progress', 'completed'];

/// Bookings (by start) and orders (by order date) in [month], grouped by
/// partner, plus PawSetu Plus payments and demo refunds.
CommissionReport commissionReport({
  required List<Map<String, dynamic>> bookings,
  required List<Map<String, dynamic>> orders,
  required List<Map<String, dynamic>> payments,
  required DateTime month,
  required DateTime Function(Object?) date,
}) {
  bool inMonth(Object? v) {
    final d = date(v);
    return d.year == month.year && d.month == month.month;
  }

  int i(Object? v) => (v as num?)?.toInt() ?? 0;
  final lines = <String, CommissionLine>{};
  var bookingCommission = 0, shopMargin = 0, plus = 0, refunds = 0;
  for (final b in bookings) {
    if (!commissionBookingStatuses.contains(b['status']) || !inMonth(b['start'] ?? b['createdAt'])) continue;
    final name = (b['providerName'] as String?) ?? '';
    final line = lines.putIfAbsent('b:$name', () => CommissionLine(name, 'booking'));
    final c = i(b['commission']);
    line
      ..count += 1
      ..gross += i(b['total'])
      ..commission += c
      ..payout += b['payout'] == null ? i(b['total']) - c : i(b['payout']);
    bookingCommission += c;
  }
  for (final o in orders) {
    if (o['status'] == 'cancelled' || o['status'] == 'returned' || !inMonth(o['createdAt'])) continue;
    final name = (o['sellerName'] as String?) ?? '';
    final line = lines.putIfAbsent('s:$name', () => CommissionLine(name, 'shop'));
    final c = i(o['commission']);
    line
      ..count += 1
      ..gross += i(o['total'])
      ..commission += c
      ..payout += o['payout'] == null ? i(o['total']) - c : i(o['payout']);
    shopMargin += c;
  }
  for (final p in payments) {
    if (!inMonth(p['at'])) continue;
    if (p['kind'] == 'plus') plus += i(p['amount']);
    if (p['kind'] == 'refund') refunds += i(p['amount']).abs();
  }
  final sorted = lines.values.toList()..sort((a, b) => b.commission != a.commission ? b.commission.compareTo(a.commission) : a.name.compareTo(b.name));
  return CommissionReport(lines: sorted, bookingCommission: bookingCommission, shopMargin: shopMargin, plusRevenue: plus, refunds: refunds);
}
