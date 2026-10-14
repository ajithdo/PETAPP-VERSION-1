import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/widgets.dart';
import '../../shell/presentation/coming_soon_screen.dart';
import '../../shell/presentation/portal_scaffold.dart';
import 'admin_sections.dart';

/// Platform admin panel (spec 10). Only reachable with the admin role.
class AdminShell extends ConsumerWidget {
  const AdminShell({super.key, required this.section});
  final String section;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final sections = [
      PortalSection('dashboard', Icons.insights_rounded, l.aDashboard),
      PortalSection('approvals', Icons.verified_rounded, l.aApprovals),
      PortalSection('users', Icons.people_rounded, l.aUsers),
      PortalSection('catalogue', Icons.category_rounded, l.aCatalogue),
      PortalSection('complaints', Icons.support_agent_rounded, l.aComplaints),
      PortalSection('moderation', Icons.flag_rounded, l.aModeration),
      PortalSection('settings', Icons.tune_rounded, l.aSettings),
      PortalSection('outbox', Icons.outbox_rounded, l.aOutbox),
      PortalSection('audit', Icons.history_rounded, l.aAudit),
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
