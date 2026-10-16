import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/demo/seed/seed_people.dart';
import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/widgets.dart';
import 'auth_widgets.dart';

/// "Explore as demo user": one-tap logins for every role (spec 5 and 12).
class DemoLoginScreen extends StatelessWidget {
  const DemoLoginScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(context.l10n.exploreDemo)),
        body: const DemoAccountList(),
      );
}

/// Every demo account, grouped, each signed in with one tap. Used on its
/// own page and beside the sign-in form on laptops.
class DemoAccountList extends ConsumerStatefulWidget {
  const DemoAccountList({super.key, this.maxWidth = 900, this.minItemWidth = 300});
  final double maxWidth;
  final double minItemWidth;

  @override
  ConsumerState<DemoAccountList> createState() => _DemoAccountListState();
}

class _DemoAccountListState extends ConsumerState<DemoAccountList> {
  String? _busyUid;

  String _describe(BuildContext context, DemoAccount a) {
    final l = context.l10n;
    return switch (a.uid) {
      'u_priya' => l.demoPriya,
      'u_ravi' => l.demoRavi,
      'u_anjali' => l.demoAnjali,
      'u_arjun' => l.demoArjun,
      'u_rohan' => l.demoRohan,
      'u_meera' => l.demoMeera,
      'u_clinicadmin' => l.demoClinicAdmin,
      'u_vet' => l.demoVet,
      'u_groomer' => l.demoGroomer,
      'u_trainer' => l.demoTrainer,
      'u_boarder' => l.demoBoarder,
      'u_walker' => l.demoWalker,
      'u_seller' => l.demoSeller,
      'u_admin' => l.demoAdmin,
      _ => '',
    };
  }

  IconData _icon(String role) => switch (role) {
        'vet' => Icons.medical_services_rounded,
        'clinic_admin' => Icons.local_hospital_rounded,
        'groomer' => Icons.content_cut_rounded,
        'trainer' => Icons.sports_rounded,
        'boarder' => Icons.house_rounded,
        'walker' => Icons.directions_walk_rounded,
        'seller' => Icons.storefront_rounded,
        'admin' => Icons.admin_panel_settings_rounded,
        _ => Icons.pets_rounded,
      };

  Future<void> _login(String uid) async {
    setState(() => _busyUid = uid);
    try {
      await ref.read(authServiceProvider).signInAsDemo(uid);
    } catch (e) {
      if (mounted) showToast(context, authErrorText(context, e));
    } finally {
      if (mounted) setState(() => _busyUid = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final groups = <String, List<DemoAccount>>{
      l.demoGroupOwners: demoAccounts.where((a) => ['u_priya', 'u_ravi', 'u_anjali', 'u_arjun'].contains(a.uid)).toList(),
      l.demoGroupFamily: demoAccounts.where((a) => ['u_rohan', 'u_meera'].contains(a.uid)).toList(),
      l.demoGroupPartners: demoAccounts.where((a) => a.role != 'owner' && a.role != 'admin').toList(),
      l.demoGroupPlatform: demoAccounts.where((a) => a.role == 'admin').toList(),
    };
    return PageBody(maxWidth: widget.maxWidth, children: [
        DemoBanner(l.demoLoginNote),
        for (final g in groups.entries) ...[
          SectionHeader(g.key),
          ResponsiveGrid(
            minItemWidth: widget.minItemWidth,
            children: [
              for (final a in g.value)
                PawCard(
                  onTap: _busyUid == null ? () => _login(a.uid) : null,
                  semanticLabel: '${l.demoBadge}: ${a.name}. ${_describe(context, a)}',
                  child: Row(children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: context.paw.primaryContainer,
                      child: Icon(_icon(a.role), color: context.colors.primary),
                    ),
                    const SizedBox(width: Space.md),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          Flexible(child: Text(a.name, style: context.text.titleSmall, overflow: TextOverflow.ellipsis)),
                          const SizedBox(width: Space.sm),
                          StatusChip(l.demoBadge, tone: ChipTone.accent),
                        ]),
                        const SizedBox(height: 2),
                        Text(_describe(context, a), style: context.text.bodySmall),
                      ]),
                    ),
                    if (_busyUid == a.uid)
                      const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5))
                    else
                      const Icon(Icons.login_rounded),
                  ]),
                ),
            ],
          ),
        ],
        const SizedBox(height: Space.lg),
        Text(l.demoCredentials(demoPassword, demoOtp), style: context.text.bodySmall, textAlign: TextAlign.center),
      ]);
  }
}
