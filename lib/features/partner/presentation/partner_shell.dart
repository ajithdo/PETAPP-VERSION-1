import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/app_user.dart';
import '../../../core/providers.dart';
import '../../../core/widgets/widgets.dart';
import '../../shell/presentation/coming_soon_screen.dart';
import '../../shell/presentation/portal_scaffold.dart';
import 'partner_sections.dart';
import '../../../core/theme/ph.dart';

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
      PortalSection('dashboard', Ph.squaresFour, l.pDashboard),
      PortalSection('products', Ph.package, l.pProducts),
      PortalSection('orders', Ph.receipt, l.pOrders),
      PortalSection('returns', Ph.arrowUUpLeft, l.pReturns),
      PortalSection('payouts', Ph.bank, l.pPayouts),
      PortalSection('reviews', Ph.starFill, l.pReviews),
      PortalSection('profile', Ph.identificationCard, l.pProfileKyc),
      PortalSection('help', Ph.headset, l.helpAndComplaints),
    ];
  }
  return [
    PortalSection('dashboard', Ph.squaresFour, l.pDashboard),
    PortalSection('calendar', Ph.calendarDots, l.pCalendar),
    PortalSection('requests', Ph.tray, l.pRequests),
    if (role == UserRole.vet) PortalSection('televet', Ph.videoCamera, l.pTeleVetQueue),
    if (role != UserRole.vet) PortalSection('services', Ph.pencilRuler, l.pServices),
    if (role == UserRole.clinicAdmin) PortalSection('staff', Ph.usersThree, l.pStaff),
    PortalSection('chat', Ph.chatCircleDots, l.pChat),
    PortalSection('reviews', Ph.starFill, l.pReviews),
    if (role != UserRole.vet) PortalSection('payouts', Ph.bank, l.pPayouts),
    PortalSection('profile', Ph.identificationCard, l.pProfileKyc),
    if (role == UserRole.clinicAdmin) PortalSection('emergency', Ph.asterisk, l.pEmergency),
    PortalSection('help', Ph.headset, l.helpAndComplaints),
  ];
}
