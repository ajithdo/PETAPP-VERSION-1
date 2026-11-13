import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/widgets.dart';
import '../../shell/presentation/coming_soon_screen.dart';
import '../../shell/presentation/portal_scaffold.dart';
import 'admin_sections.dart';
import '../../../core/theme/ph.dart';

/// Platform admin panel (spec 10). Only reachable with the admin role.
class AdminShell extends ConsumerWidget {
  const AdminShell({super.key, required this.section});
  final String section;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final sections = [
      PortalSection('dashboard', Ph.chartLineUp, l.aDashboard),
      PortalSection('approvals', Ph.sealCheckFill, l.aApprovals),
      PortalSection('users', Ph.users, l.aUsers),
      PortalSection('catalogue', Ph.squaresFour, l.aCatalogue),
      PortalSection('complaints', Ph.headset, l.aComplaints),
      PortalSection('moderation', Ph.flag, l.aModeration),
      PortalSection('settings', Ph.slidersHorizontal, l.aSettings),
      PortalSection('outbox', Ph.trayArrowUp, l.aOutbox),
      PortalSection('audit', Ph.clockCounterClockwise, l.aAudit),
    ];
    final current = sections.any((s) => s.key == section) ? section : 'dashboard';
    final body = adminSectionBody(context, ref, current) ??
        ComingSoonScreen(title: sections.firstWhere((s) => s.key == current).label, phase: 10, embedded: true);
    return PortalScaffold(
      basePath: '/admin',
      title: l.adminPanel,
      sections: sections,
      current: current,
      body: body,
    );
  }
}
