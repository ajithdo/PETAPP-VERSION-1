import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/demo/seed/seed_people.dart';
import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
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
/// own page and, with [embedded], at the top of the sign-in page.
class DemoAccountList extends ConsumerStatefulWidget {
  const DemoAccountList({super.key, this.maxWidth = 900, this.minItemWidth = 300, this.embedded = false});
  final double maxWidth;
  final double minItemWidth;

  /// A section inside another scrolling page instead of a page of its own.
  final bool embedded;

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

  /// The demo families' pets (the bundled demo photos), so a visitor sees
  /// who they will be looking after before signing in.
  static const _pets = {
    'u_priya': ['bruno', 'misty'],
    'u_ravi': ['simba', 'kiwi'],
    'u_anjali': ['coco', 'tiger'],
    'u_arjun': ['max', 'luna'],
  };

  IconData _icon(String role) => switch (role) {
        'vet' => Icons.medical_services_outlined,
        'clinic_admin' => Icons.local_hospital_outlined,
        'groomer' => Icons.content_cut_outlined,
        'trainer' => Icons.sports_outlined,
        'boarder' => Icons.house_outlined,
        'walker' => Icons.directions_walk_outlined,
        'seller' => Icons.storefront_outlined,
        'admin' => Icons.admin_panel_settings_outlined,
        _ => Icons.pets_outlined,
      };

  Color _tone(BuildContext context, String role) => switch (role) {
        'clinic_admin' || 'seller' => context.paw.accent,
        'vet' || 'walker' => context.paw.success,
        'groomer' => CategoryColors.ocean,
        _ => context.paw.textPrimary,
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
    final content = <Widget>[
      for (final g in groups.entries) ...[
        SectionHeader(g.key),
        ResponsiveGrid(
          minItemWidth: widget.minItemWidth,
          children: [for (final a in g.value) _tile(context, a)],
        ),
      ],
      const SizedBox(height: Space.lg),
      Text(l.demoCredentials(demoPassword, demoOtp), style: context.text.bodySmall, textAlign: TextAlign.center),
    ];
    if (!widget.embedded) return PageBody(maxWidth: widget.maxWidth, children: [DemoBanner(l.demoLoginNote), ...content]);
    // On the sign-in page (UI Design 6): a marigold panel with its title,
    // one line of help and the accounts as cards.
    final paw = context.paw;
    return Container(
      padding: const EdgeInsets.all(Space.lg),
      decoration: BoxDecoration(color: paw.accentContainer, borderRadius: BorderRadius.circular(Radii.xl)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Icon(Icons.science_outlined, color: paw.onAccentContainer),
          const SizedBox(width: Space.sm),
          Expanded(child: Semantics(header: true, child: Text(l.demoAccountsTitle, style: context.text.titleLarge))),
        ]),
        const SizedBox(height: Space.xs),
        Text(l.demoAccountsHint, style: context.text.bodyMedium?.copyWith(color: paw.onAccentContainer)),
        ...content,
      ]),
    );
  }

  Widget _tile(BuildContext context, DemoAccount a) {
    final l = context.l10n;
    final paw = context.paw;
    // A shape for everything: pet parents show their pets in arches, family
    // and sitters are circles with initials, partners are tiles.
    final pets = _pets[a.uid];
    final double archH = Sizes.avatarMd;
    final archW = (archH / Sizes.archAspect).roundToDouble();
    Widget arch(String name) => Container(
      decoration: ShapeDecoration(shape: archShape(archW + Space.xs, BorderSide(color: paw.surface, width: Space.xxs))),
      child: ArchClip(width: archW, child: Image.asset('assets/images/demo/pets/$name.jpg', width: archW, height: archH, fit: BoxFit.cover, excludeFromSemantics: true)),
    );
    final Widget lead = pets != null
        ? SizedBox(
            width: archW * 2 - Space.md,
            height: archH + Space.xs,
            child: Stack(children: [Positioned(left: 0, child: arch(pets[0])), Positioned(left: archW - Space.md, child: arch(pets[1]))]),
          )
        : (a.role == 'owner'
            ? CircleAvatar(
                radius: Sizes.avatarMd / 2,
                backgroundColor: paw.surfaceSubtle,
                child: Text(initials(a.name), style: context.text.labelLarge),
              )
            : Container(
                width: Sizes.avatarMd,
                height: Sizes.avatarMd,
                decoration: BoxDecoration(
                  color: a.role == 'admin' ? paw.textPrimary : _tone(context, a.role).withValues(alpha: Opacities.chip),
                  borderRadius: BorderRadius.circular(Radii.md),
                ),
                child: Icon(_icon(a.role), color: a.role == 'admin' ? paw.background : _tone(context, a.role)),
              ));
    return PawCard(
      onTap: _busyUid == null ? () => _login(a.uid) : null,
      semanticLabel: '${l.demoBadge}: ${a.name}. ${_describe(context, a)}',
      padding: const EdgeInsets.all(Space.md),
      child: Row(children: [
        lead,
        const SizedBox(width: Space.md),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // The page already says these are demo accounts: no "Demo" chip
            // on every row, and the full description (never cut with "…").
            Text(a.name, style: context.text.titleSmall),
            const SizedBox(height: Space.xxs),
            Text(_describe(context, a), style: context.text.bodySmall?.copyWith(color: context.paw.textSecondary)),
          ]),
        ),
        if (_busyUid == a.uid)
          const SizedBox(width: Sizes.spinner, height: Sizes.spinner, child: CircularProgressIndicator(strokeWidth: Strokes.spinner))
        else
          Icon(Icons.chevron_right_rounded, color: context.paw.textSecondary),
      ]),
    );
  }
}
