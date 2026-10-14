/// Insurance tracker (spec 7.9): policy details, cover, renewal date, and
/// claims with status and a claim-document checklist. Pure Dart.
library;

import '../../../core/data/converters.dart';

/// Claim steps in order. A claim ends as paid or rejected.
const claimStatuses = ['draft', 'submitted', 'in_review', 'approved', 'paid', 'rejected'];

/// Documents an insurer usually asks for.
const claimChecklistKeys = ['claim_form', 'vet_bills', 'prescription', 'lab_reports', 'policy_copy', 'pet_photo', 'id_proof'];

class Claim {
  Claim(this.raw);
  final Map<String, dynamic> raw;
  String get id => (raw['id'] as String?) ?? '';
  String get title => (raw['title'] as String?) ?? '';
  DateTime get date => parseDate(raw['date']) ?? DateTime.fromMillisecondsSinceEpoch(0);
  int get amount => (raw['amount'] as num?)?.toInt() ?? 0;
  int? get settledAmount => (raw['settledAmount'] as num?)?.toInt();
  String get status {
    final s = raw['status'] as String?;
    return claimStatuses.contains(s) ? s! : 'draft';
  }

  Map<String, bool> get checklist => {
        for (final k in claimChecklistKeys) k: ((raw['checklist'] as Map?)?[k] as bool?) ?? false,
      };

  /// Vault documents attached to checklist items.
  Map<String, String> get attachments => ((raw['attachments'] as Map?) ?? const {}).map((k, v) => MapEntry('$k', '$v'));
  String? get notes => raw['notes'] as String?;
  bool get isOpen => status != 'paid' && status != 'rejected';
}

class InsurancePolicy {
  InsurancePolicy(this.id, this.raw);
  final String id;
  final Map<String, dynamic> raw;
  String get petId => (raw['petId'] as String?) ?? '';
  String get ownerId => (raw['ownerId'] as String?) ?? '';
  String get provider => (raw['provider'] as String?) ?? '';
  String get planName => (raw['planName'] as String?) ?? '';
  String get policyNo => (raw['policyNo'] as String?) ?? '';
  int get cover => (raw['cover'] as num?)?.toInt() ?? 0;
  int get premium => (raw['premium'] as num?)?.toInt() ?? 0;
  DateTime? get start => parseDate(raw['start']);
  DateTime? get renewal => parseDate(raw['renewal']);
  String? get docId => raw['docId'] as String?;
  List<Claim> get claims => [
        for (final c in (raw['claims'] as List?) ?? const [])
          if (c is Map) Claim(c.cast<String, dynamic>()),
      ]..sort((a, b) => b.date.compareTo(a.date));

  /// Money already paid out this policy year.
  int get claimedThisYear => claims.where((c) => c.status == 'paid').fold(0, (s, c) => s + (c.settledAmount ?? c.amount));
  int get coverLeft => (cover - claimedThisYear).clamp(0, cover);
}

enum RenewalState { active, renewSoon, lapsed, unknown }

/// Renew soon = within 30 days (matches the document expiry warning).
RenewalState renewalState(DateTime? renewal, DateTime now) {
  if (renewal == null) return RenewalState.unknown;
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(renewal.year, renewal.month, renewal.day);
  if (day.isBefore(today)) return RenewalState.lapsed;
  if (!day.isAfter(today.add(const Duration(days: 30)))) return RenewalState.renewSoon;
  return RenewalState.active;
}

/// Share of checklist items done, 0..1.
double checklistProgress(Map<String, bool> checklist) =>
    checklist.isEmpty ? 0 : checklist.values.where((v) => v).length / checklist.length;

/// Which statuses a claim can move to next.
List<String> nextClaimStatuses(String status) => switch (status) {
      'draft' => ['submitted'],
      'submitted' => ['in_review', 'rejected'],
      'in_review' => ['approved', 'rejected'],
      'approved' => ['paid'],
      _ => const [],
    };

/// A claim can be submitted once the claim form and the vet bills are ready.
bool readyToSubmit(Map<String, bool> checklist) => (checklist['claim_form'] ?? false) && (checklist['vet_bills'] ?? false);
