import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers.dart';
import '../../core/theme/tokens.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/widgets.dart';
import '../health/domain/vaccine_schedule.dart';
import '../plans/domain/plan_rules.dart';
import '../plans/presentation/plus_screen.dart';
import 'domain/privacy.dart';
import 'presentation/admin_catalogue.dart';
import 'presentation/admin_complaints.dart';
import 'presentation/admin_dashboard.dart';
import 'presentation/admin_logs.dart';
import 'presentation/admin_people.dart';
import 'presentation/admin_settings.dart';
import 'presentation/banners.dart';
import 'presentation/commission_report.dart';
import 'presentation/help_screens.dart';
import 'presentation/privacy_screen.dart';

export 'presentation/help_screens.dart' show HelpListBody, helpBase;

/// Phase 10 slots (admin panel, PawSetu Plus, coupons, help and complaints,
/// privacy centre). Shared files call these; only Phase 10 edits this file.

/// Admin panel sections (see admin_shell.dart for the section keys).
/// Null = coming soon.
Widget? adminSection(BuildContext context, WidgetRef ref, String section) => switch (section) {
      'dashboard' => const AdminDashboard(),
      'approvals' => const AdminApprovals(),
      'users' => const AdminUsers(),
      'catalogue' => const AdminCatalogue(),
      'complaints' => const AdminComplaints(),
      'moderation' => const AdminModeration(),
      'settings' => const AdminSettings(),
      'outbox' => const AdminOutbox(),
      'audit' => const AdminAudit(),
      _ => null,
    };

/// Extra admin pages under /admin/ (e.g. detail pages).
final adminExtraRoutes = <RouteBase>[
  GoRoute(path: 'reports/commission', builder: (_, _) => const CommissionReportScreen()),
  GoRoute(path: 'complaints/:id', builder: (_, s) => AdminTicketScreen(ticketId: s.pathParameters['id']!)),
];

/// What a new ticket is about, from links such as
/// /me/help/new?order=… (also booking= and conversation=).
(String?, String?) _linkFrom(GoRouterState s) {
  final q = s.uri.queryParameters;
  if (q['booking'] != null) return ('booking', q['booking']);
  if (q['order'] != null) return ('order', q['order']);
  if (q['conversation'] != null) return ('chat', q['conversation']);
  return (null, null);
}

List<RouteBase> _helpChildren() => [
      GoRoute(
        path: 'new',
        builder: (_, s) {
          final (type, id) = _linkFrom(s);
          return NewTicketScreen(linkType: type, linkId: id);
        },
      ),
      GoRoute(path: ':id', builder: (_, s) => TicketScreen(ticketId: s.pathParameters['id']!)),
    ];

/// Routes under /me: must include 'plus', 'help' and 'privacy' (Me menu and
/// the Plus prompt link to /me/plus, /me/help and /me/privacy).
final adminMeRoutes = <RouteBase>[
  GoRoute(path: 'plus', builder: (_, _) => const PlusScreen()),
  GoRoute(path: 'refer', builder: (_, _) => const ReferScreen()),
  GoRoute(path: 'privacy', builder: (_, _) => const PrivacyScreen()),
  GoRoute(path: 'help', builder: (_, _) => const HelpListScreen(), routes: _helpChildren()),
];

/// Full-screen routes if needed: help for partner accounts (the owner area
/// is closed to them) and the "account paused" page.
final adminRootRoutes = <RouteBase>[
  GoRoute(path: '/help', builder: (_, _) => const HelpListScreen(), routes: _helpChildren()),
  GoRoute(path: '/suspended', builder: (_, _) => const SuspendedScreen()),
];

/// Keeps app-wide copies of admin settings up to date (vaccine timings).
final configSyncProvider = Provider<void>((ref) {
  ref.listen(appSettingsDocProvider, (_, next) {
    VaccineOverrides.current = ((next.value?['vaccineSchedules'] as Map?) ?? const {}).cast<String, dynamic>();
  }, fireImmediately: true);
});

/// Feature flags from Settings → Feature switches (on unless switched off).
bool featureOn(WidgetRef ref, String flag) => ((ref.watch(appSettingsDocProvider).value?['flags'] as Map?)?[flag]) != false;

/// Hides Me menu entries whose feature is switched off.
bool meItemVisible(WidgetRef ref, String route) => switch (route) {
      '/me/devices' => featureOn(ref, 'smartDevices'),
      '/me/refer' => featureOn(ref, 'referrals'),
      _ => true,
    };

/// Home notices: account deletion pending, trial ending, and admin banners.
List<Widget> adminHomeSection(BuildContext context, WidgetRef ref) {
  final l = context.l10n;
  final user = ref.watch(currentUserProvider);
  if (user == null) return const [];
  final now = DateTime.now();
  final deletion = user.deletionRequestedAt;
  final trialLeft = user.onTrial ? daysLeft(user.trialEndsAt, now) : null;
  return [
    if (deletion != null)
      Padding(
        padding: const EdgeInsets.only(top: Space.md),
        child: PawCard(
          borderColor: context.paw.error,
          onTap: () => context.push('/me/privacy'),
          child: Row(children: [
            Icon(Icons.warning_amber_rounded, color: context.paw.error),
            const SizedBox(width: Space.md),
            Expanded(child: Text(l.prvDeletionPending(Fmt.date(deletionDate(deletion), context.lang)), style: context.text.bodyMedium)),
            const Icon(Icons.chevron_right_rounded),
          ]),
        ),
      ),
    if (trialLeft != null && trialLeft <= 2)
      Padding(
        padding: const EdgeInsets.only(top: Space.md),
        child: PawCard(
          borderColor: context.paw.accent,
          onTap: () => context.push('/me/plus'),
          child: Row(children: [
            Icon(Icons.workspace_premium_rounded, color: context.paw.accent),
            const SizedBox(width: Space.md),
            Expanded(child: Text(l.plusTrialEndingSoon(trialLeft), style: context.text.bodyMedium)),
            const Icon(Icons.chevron_right_rounded),
          ]),
        ),
      ),
    const BannerStrip(placement: 'home'),
  ];
}
