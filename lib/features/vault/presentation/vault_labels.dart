import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../domain/insurance.dart';
import '../domain/share_rules.dart';
import '../domain/vault_models.dart';
import '../../../core/theme/ph.dart';

String docTypeLabel(BuildContext context, String type) {
  final l = context.l10n;
  return switch (type) {
    'vaccination' => l.vaultTypeVaccination,
    'insurance' => l.vaultTypeInsurance,
    'lab' => l.vaultTypeLab,
    'prescription' => l.vaultTypePrescription,
    'invoice' => l.vaultTypeInvoice,
    'licence' => l.vaultTypeLicence,
    'adoption' => l.vaultTypeAdoption,
    'travel' => l.vaultTypeTravel,
    _ => l.vaultTypeOther,
  };
}

IconData docTypeIcon(String type) => switch (type) {
      'vaccination' => Ph.syringe,
      'insurance' => Ph.shieldPlus,
      'lab' => Ph.microscope,
      'prescription' => Ph.pill,
      'invoice' => Ph.receipt,
      'licence' => Ph.identificationCard,
      'adoption' => Ph.handHeart,
      'travel' => Ph.airplaneTilt,
      _ => Ph.fileText,
    };

/// Icon colour for a kind of document, readable (3:1) on cards in light
/// and dark mode.
Color docTypeColor(BuildContext context, String type) {
  Color cat(Color c) => readableOn(c, [context.paw.surface], ratio: 3);
  return switch (type) {
    'vaccination' => context.paw.brand,
    'insurance' => cat(CategoryColors.plum),
    'lab' => cat(CategoryColors.sky),
    'prescription' => context.paw.success,
    'invoice' => context.paw.accent,
    'licence' => cat(CategoryColors.gold),
    'adoption' => cat(CategoryColors.rose),
    'travel' => cat(CategoryColors.teal),
    _ => context.paw.textSecondary,
  };
}

/// Expiry chip, or null when the document never expires.
Widget? expiryChip(BuildContext context, DateTime? expiry, {DateTime? now}) {
  final l = context.l10n;
  final st = expiryState(expiry, now ?? DateTime.now());
  return switch (st) {
    ExpiryState.none => null,
    ExpiryState.expired => StatusChip(l.vaultExpired, tone: ChipTone.error, icon: Ph.calendarX),
    ExpiryState.soon => StatusChip(l.vaultExpiresSoon, tone: ChipTone.warning, icon: Ph.clock),
    ExpiryState.valid => null,
  };
}

String expiryText(BuildContext context, DateTime expiry, {DateTime? now}) {
  final l = context.l10n;
  final date = Fmt.date(expiry, context.lang);
  return expiryState(expiry, now ?? DateTime.now()) == ExpiryState.expired ? l.vaultExpiredOn(date) : l.vaultExpiresOn(date);
}

String claimStatusLabel(BuildContext context, String s) {
  final l = context.l10n;
  return switch (s) {
    'submitted' => l.vaultClaimSubmitted,
    'in_review' => l.vaultClaimInReview,
    'approved' => l.vaultClaimApproved,
    'paid' => l.vaultClaimPaid,
    'rejected' => l.vaultClaimRejected,
    _ => l.vaultClaimDraft,
  };
}

ChipTone claimStatusTone(String s) => switch (s) {
      'paid' || 'approved' => ChipTone.success,
      'rejected' => ChipTone.error,
      'submitted' || 'in_review' => ChipTone.info,
      _ => ChipTone.neutral,
    };

String checklistLabel(BuildContext context, String k) {
  final l = context.l10n;
  return switch (k) {
    'claim_form' => l.vaultCkClaimForm,
    'vet_bills' => l.vaultCkVetBills,
    'prescription' => l.vaultCkPrescription,
    'lab_reports' => l.vaultCkLabReports,
    'policy_copy' => l.vaultCkPolicyCopy,
    'pet_photo' => l.vaultCkPetPhoto,
    _ => l.vaultCkIdProof,
  };
}

Widget renewalChip(BuildContext context, DateTime? renewal) {
  final l = context.l10n;
  return switch (renewalState(renewal, DateTime.now())) {
    RenewalState.lapsed => StatusChip(l.vaultPolicyLapsed, tone: ChipTone.error),
    RenewalState.renewSoon => StatusChip(l.vaultRenewSoon, tone: ChipTone.warning),
    RenewalState.active => StatusChip(l.vaultPolicyActive, tone: ChipTone.success),
    RenewalState.unknown => const SizedBox.shrink(),
  };
}

Widget linkStatusChip(BuildContext context, ShareLink link) {
  final l = context.l10n;
  if (link.revoked) return StatusChip(l.vaultLinkRevoked, tone: ChipTone.neutral, icon: Ph.linkBreak);
  if (link.isExpired(DateTime.now())) return StatusChip(l.vaultLinkExpired, tone: ChipTone.warning);
  return StatusChip(l.vaultLinkActive, tone: ChipTone.success, icon: Ph.link);
}

String shareExpiryLabel(BuildContext context, ShareExpiry e) {
  final l = context.l10n;
  return switch (e) {
    ShareExpiry.hour1 => l.vaultExpiry1h,
    ShareExpiry.hours24 => l.vaultExpiry24h,
    ShareExpiry.days7 => l.vaultExpiry7d,
    ShareExpiry.never => l.vaultExpiryNever,
  };
}

/// Round icon badge for a document type.
class DocTypeBadge extends StatelessWidget {
  const DocTypeBadge({super.key, required this.type, this.size = 44});
  final String type;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = docTypeColor(context, type);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: c.withValues(alpha: Opacities.focus), borderRadius: BorderRadius.circular(Radii.md)),
      child: Icon(docTypeIcon(type), color: c, size: size * 0.52),
    );
  }
}
