import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/app_user.dart';
import '../../../core/providers.dart';
import '../../../core/widgets/widgets.dart';
import '../../shell/presentation/coming_soon_screen.dart';
import '../../shell/presentation/portal_scaffold.dart';
import 'partner_sections.dart';

/// Partner portal (spec 9): clinics, vets, groomers, trainers, boarding,
/// walkers and sellers. Sections depend on the role.
class PartnerShell extends ConsumerWidget {
  const PartnerShell({super.key, required this.section});
  final String section;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final user = ref.watch(currentUserProvider);
    if (user == null) return const SizedBox.shrink();
    final sections = partnerSectionsFor(context, user.role);
    final current = sections.any((s) => s.key == section) ? section : 'dashboard';
    final body =
        partnerSectionBody(context, ref, user, current) ??
        ComingSoonScreen(title: sections.firstWhere((s) => s.key == current).label, phase: user.role == UserRole.seller ? 8 : 5, embedded: true);
    return PortalScaffold(basePath: '/partner', title: l.partnerPortalFor(roleLabel(context, user.role)), sections: sections, current: current, body: body);
  }
}

String roleLabel(BuildContext context, UserRole r) {
  final l = context.l10n;
  return switch (r) {
    UserRole.owner => l.rolePetParent,
    UserRole.vet => l.roleVet,
    UserRole.clinicAdmin => l.roleClinicAdmin,
    UserRole.groomer => l.roleGroomer,
    UserRole.trainer => l.roleTrainer,
    UserRole.boarder => l.roleBoarder,
    UserRole.walker => l.roleWalker,
    UserRole.seller => l.roleSeller,
    UserRole.admin => l.roleAdmin,
  };
}

List<PortalSection> partnerSectionsFor(BuildContext context, UserRole role) {
  final l = context.l10n;
  if (role == UserRole.seller) {
    return [
      PortalSection('dashboard', Icons.dashboard_rounded, l.pDashboard),
      PortalSection('products', Icons.inventory_2_rounded, l.pProducts),
      PortalSection('orders', Icons.receipt_long_rounded, l.pOrders),
      PortalSection('returns', Icons.assignment_return_rounded, l.pReturns),
      PortalSection('payouts', Icons.account_balance_rounded, l.pPayouts),
      PortalSection('reviews', Icons.star_rounded, l.pReviews),
      PortalSection('profile', Icons.badge_rounded, l.pProfileKyc),
      PortalSection('help', Icons.support_agent_rounded, l.helpAndComplaints),
    ];
  }
  return [
    PortalSection('dashboard', Icons.dashboard_rounded, l.pDashboard),
    PortalSection('calendar', Icons.calendar_month_rounded, l.pCalendar),
    PortalSection('requests', Icons.inbox_rounded, l.pRequests),
    if (role == UserRole.vet) PortalSection('televet', Icons.video_call_rounded, l.pTeleVetQueue),
    if (role != UserRole.vet) PortalSection('services', Icons.design_services_rounded, l.pServices),
    if (role == UserRole.clinicAdmin) PortalSection('staff', Icons.groups_rounded, l.pStaff),
    PortalSection('chat', Icons.chat_rounded, l.pChat),
    PortalSection('reviews', Icons.star_rounded, l.pReviews),
    if (role != UserRole.vet) PortalSection('payouts', Icons.account_balance_rounded, l.pPayouts),
    PortalSection('profile', Icons.badge_rounded, l.pProfileKyc),
    if (role == UserRole.clinicAdmin) PortalSection('emergency', Icons.emergency_rounded, l.pEmergency),
    PortalSection('help', Icons.support_agent_rounded, l.helpAndComplaints),
  ];
}
