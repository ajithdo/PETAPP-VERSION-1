import 'package:flutter/material.dart';

import '../../../core/widgets/widgets.dart';

/// Words for partner kinds, statuses, ticket topics and Demo Outbox
/// channels, shared by the admin panel and the help screens.

String partnerKindLabel(BuildContext context, String kind) {
  final l = context.l10n;
  return switch (kind) {
    'clinic' => l.admKindClinic,
    'vet' => l.roleVet,
    'groomer' => l.roleGroomer,
    'trainer' => l.roleTrainer,
    'boarder' => l.roleBoarder,
    'walker' => l.roleWalker,
    'seller' => l.roleSeller,
    _ => kind,
  };
}

IconData partnerKindIcon(String kind) => switch (kind) {
      'clinic' => Icons.local_hospital_rounded,
      'vet' => Icons.medical_services_rounded,
      'groomer' => Icons.content_cut_rounded,
      'trainer' => Icons.sports_rounded,
      'boarder' => Icons.house_rounded,
      'walker' => Icons.directions_walk_rounded,
      'seller' => Icons.storefront_rounded,
      _ => Icons.badge_rounded,
    };

String partnerStatusLabel(BuildContext context, String status) {
  final l = context.l10n;
  return switch (status) {
    'approved' => l.statusApproved,
    'pending' => l.statusPendingApproval,
    'rejected' => l.admStatusRejected,
    'suspended' => l.admStatusSuspended,
    _ => status,
  };
}

ChipTone partnerStatusTone(String status) => switch (status) {
      'approved' => ChipTone.success,
      'pending' => ChipTone.warning,
      _ => ChipTone.error,
    };

String ticketStatusLabel(BuildContext context, String status) {
  final l = context.l10n;
  return switch (status) {
    'open' => l.hpStatusOpen,
    'in_progress' => l.hpStatusInProgress,
    'resolved' => l.hpStatusResolved,
    _ => status,
  };
}

ChipTone ticketStatusTone(String status) => switch (status) {
      'open' => ChipTone.warning,
      'in_progress' => ChipTone.info,
      'resolved' => ChipTone.success,
      _ => ChipTone.neutral,
    };

String ticketTopicLabel(BuildContext context, String topic) {
  final l = context.l10n;
  return switch (topic) {
    'refund' => l.hpTopicRefund,
    'late' => l.hpTopicLate,
    'quality' => l.hpTopicQuality,
    'behaviour' => l.hpTopicBehaviour,
    'app' => l.hpTopicApp,
    _ => l.hpTopicOther,
  };
}

String linkTypeLabel(BuildContext context, String type) {
  final l = context.l10n;
  return switch (type) {
    'booking' => l.hpLinkBooking,
    'order' => l.hpLinkOrder,
    'chat' => l.hpLinkChat,
    _ => l.hpLinkOther,
  };
}

IconData linkTypeIcon(String type) => switch (type) {
      'booking' => Icons.event_rounded,
      'order' => Icons.shopping_bag_rounded,
      'chat' => Icons.chat_rounded,
      _ => Icons.help_rounded,
    };

String reportTypeLabel(BuildContext context, String type) {
  final l = context.l10n;
  return switch (type) {
    'review' => l.admReportReview,
    'chat' => l.admReportChat,
    _ => l.admReportContent,
  };
}

String outboxChannelLabel(BuildContext context, String channel) {
  final l = context.l10n;
  return switch (channel) {
    'sms' => l.admChannelSms,
    'whatsapp' => l.admChannelWhatsapp,
    'email' => l.admChannelEmail,
    'push' => l.admChannelPush,
    _ => channel,
  };
}

IconData outboxChannelIcon(String channel) => switch (channel) {
      'sms' => Icons.sms_rounded,
      'whatsapp' => Icons.chat_rounded,
      'email' => Icons.email_rounded,
      'push' => Icons.notifications_active_rounded,
      _ => Icons.outbox_rounded,
    };

/// A plain-words name for an audit log action.
String auditActionLabel(BuildContext context, String action) {
  final l = context.l10n;
  return switch (action) {
    'partner_approve' => l.admActApprove,
    'partner_reject' => l.admActReject,
    'partner_suspend' => l.admActSuspendPartner,
    'user_suspend' => l.admActSuspendUser,
    'user_unsuspend' => l.admActUnsuspendUser,
    'setUserRole' => l.admActRole,
    'ticket_reply' => l.admActTicketReply,
    'ticket_status' => l.admActTicketStatus,
    'ticket_assign' => l.admActTicketAssign,
    'ticket_refund' => l.admActRefund,
    'report_hide' => l.admActHide,
    'report_restore' => l.admActRestore,
    'report_dismiss' => l.admActDismiss,
    'report_handled' => l.admActHandled,
    'coupon_create' => l.admActCouponNew,
    'coupon_update' => l.admActCouponEdit,
    'product_update' => l.admActProduct,
    'banner_create' => l.admActBannerNew,
    'banner_update' => l.admActBannerEdit,
    'seller_update' => l.admActSeller,
    'partner_store_update' => l.admActPartnerStore,
    'place_update' => l.admActPlace,
    _ when action.startsWith('settings_') => l.admActSettings,
    _ => action,
  };
}
