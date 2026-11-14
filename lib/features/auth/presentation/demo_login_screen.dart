import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/demo/seed/seed_people.dart';
import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import 'auth_widgets.dart';
import '../../../core/theme/ph.dart';

/// "Explore as demo user": one-tap logins for every role (spec 5 and 12).
class DemoLoginScreen extends StatelessWidget {
  const DemoLoginScreen({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(body: SafeArea(child: DemoAccountList()));
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
        'vet' => Ph.stethoscope,
        'clinic_admin' => Ph.firstAid,
        'groomer' => Ph.scissors,
        'trainer' => Ph.graduationCap,
        'boarder' => Ph.houseLine,
        'walker' => Ph.personSimpleWalk,
        'seller' => Ph.storefront,
        'admin' => Ph.shieldStar,
        _ => Ph.pawPrint,
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

  /// What a visitor should know before choosing: the plan, the language
  /// and Easy mode, as tags.
  List<Widget> _tags(BuildContext context, DemoAccount a) {
    final l = context.l10n;
    return switch (a.uid) {
      'u_priya' || 'u_arjun' => [PawTag(l.planPlus, kind: TagKind.plus, icon: Ph.crownSimpleFill)],
      'u_ravi' => [PawTag(l.planFree), const PawTag('తెలుగు', kind: TagKind.sky)],
      'u_anjali' => [PawTag(l.planFree), const PawTag('हिन्दी', kind: TagKind.sky), PawTag(l.easyMode, kind: TagKind.green)],
      _ => const [],
    };
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final paw = context.paw;
    final owners = demoAccounts.where((a) => ['u_priya', 'u_ravi', 'u_anjali', 'u_arjun'].contains(a.uid)).toList();
    final family = demoAccounts.where((a) => ['u_rohan', 'u_meera'].contains(a.uid)).toList();
    final partners = demoAccounts.where((a) => a.role != 'owner' && a.role != 'admin').toList();
    final team = demoAccounts.where((a) => a.role == 'admin').toList();
    Widget grid(List<DemoAccount> list) => ResponsiveGrid(minItemWidth: widget.minItemWidth, children: [for (final a in list) _tile(context, a)]);
    final credentials = Text(l.demoCredentials(demoPassword, demoOtp), style: context.text.bodySmall?.copyWith(color: paw.textSecondary), textAlign: TextAlign.center);
    if (!widget.embedded) {
      // Its own page: a round back button and the title, the demo note, then
      // every account by group.
      return PageBody(maxWidth: widget.maxWidth, children: [
        const SizedBox(height: Space.sm),
        Row(children: [
          PawIconButton(icon: Ph.arrowLeft, tooltip: MaterialLocalizations.of(context).backButtonTooltip, onPressed: () => context.canPop() ? context.pop() : context.go('/signin')),
          const SizedBox(width: Space.md),
          Expanded(child: Semantics(header: true, child: Text(l.exploreDemo, style: context.text.headlineMedium))),
        ]),
        const SizedBox(height: Space.lg),
        DemoBanner(l.demoLoginNote),
        for (final (title, list) in [(l.demoGroupOwners, owners), (l.demoGroupFamily, family), (l.demoGroupPartners, partners), (l.demoGroupPlatform, team)]) ...[
          const SizedBox(height: Space.xl),
          SecHead(title),
          grid(list),
        ],
        const SizedBox(height: Space.lg),
        credentials,
      ]);
    }
    // On the sign-in page: a marigold panel with its title, one line of
    // help, the pet parents and family, and the first two partners with a
    // link to everyone.
    Widget label(String t) => Padding(padding: const EdgeInsets.only(top: Space.lg, bottom: Space.sm), child: Text(t, style: context.text.labelLarge));
    return Wash(
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Icon(Ph.flask, size: IconSizes.md, color: paw.textPrimary),
          const SizedBox(width: Space.sm),
          Expanded(child: Semantics(header: true, child: Text(l.demoAccountsTitle, style: context.text.titleLarge))),
        ]),
        const SizedBox(height: Space.xs),
        Text(l.demoAccountsHint, style: context.text.bodySmall?.copyWith(color: paw.accent)),
        label(l.demoGroupOwners),
        grid(owners),
        label(l.demoGroupFamily),
        grid(family),
        Padding(
          padding: const EdgeInsets.only(top: Space.lg, bottom: Space.sm),
          child: Row(crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [
            Expanded(child: Text(l.demoPartnersTeam, style: context.text.labelLarge)),
            const SizedBox(width: Space.md),
            TextLink(l.seeAllCount(partners.length + team.length), onTap: () => context.push('/demo')),
          ]),
        ),
        grid(partners.take(2).toList()),
        const SizedBox(height: Space.lg),
        credentials,
      ]),
    );
  }

  Widget _tile(BuildContext context, DemoAccount a) {
    final l = context.l10n;
    final paw = context.paw;
    // A shape for everything: pet parents show their pets in arches, family
    // and sitters are circles with initials, partners are tiles.
    final pets = _pets[a.uid];
    const archW = Sizes.avatarSm;
    final archH = (archW * Sizes.archAspect).roundToDouble();
    Widget arch(String name, {bool ring = false}) => Container(
      decoration: ring ? ShapeDecoration(shape: archShape(archW + Space.xs, BorderSide(color: paw.surface, width: Space.xxs))) : null,
      padding: ring ? const EdgeInsets.all(Space.xxs) : EdgeInsets.zero,
      child: ArchClip(width: archW, child: Image.asset('assets/images/demo/pets/$name.png', width: archW, height: archH, fit: BoxFit.cover, excludeFromSemantics: true)),
    );
    final tone = switch (a.role) {
      'clinic_admin' || 'seller' => Tone.gold,
      'vet' || 'walker' => Tone.green,
      'groomer' => Tone.sky,
      'admin' => Tone.ink,
      _ => Tone.neutral,
    };
    final Widget lead = pets != null
        ? SizedBox(
            width: archW * 2 - Space.md,
            height: archH + Space.xs,
            child: Stack(children: [
              Positioned(left: 0, top: Space.xxs, child: arch(pets[0])),
              Positioned(left: archW - Space.md - Space.xxs, top: 0, child: arch(pets[1], ring: true)),
            ]),
          )
        : (a.role == 'owner'
            ? Container(
                width: Sizes.tile,
                height: Sizes.tile,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: context.tint.paper3, shape: BoxShape.circle),
                child: Text(initials(a.name), style: context.text.labelLarge?.copyWith(fontFamily: FontFamilies.heading, fontWeight: FontWeight.w700)),
              )
            : PawTile(icon: _icon(a.role), tone: tone));
    final tags = _tags(context, a);
    return PawCard(
      onTap: _busyUid == null ? () => _login(a.uid) : null,
      semanticLabel: '${l.demoBadge}: ${a.name}. ${_describe(context, a)}',
      padding: const EdgeInsets.all(Space.md),
      // White cards on the marigold panel; hairline cards on the page.
      flat: true,
      borderColor: widget.embedded ? paw.surface : null,
      child: Row(children: [
        lead,
        const SizedBox(width: Space.md),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // The page already says these are demo accounts: no "Demo" chip
            // on every row, and the full description (never cut with "…").
            Text(a.name, style: context.text.labelLarge),
            Text(_describe(context, a), style: context.text.bodySmall?.copyWith(color: paw.textSecondary)),
            if (tags.isNotEmpty) ...[
              const SizedBox(height: Space.sm),
              Wrap(spacing: Space.xs, runSpacing: Space.xs, children: tags),
            ],
          ]),
        ),
        const SizedBox(width: Space.md),
        if (_busyUid == a.uid)
          const SizedBox(width: Sizes.spinner, height: Sizes.spinner, child: CircularProgressIndicator(strokeWidth: Strokes.spinner))
        else
          const Chev(),
      ]),
    );
  }
}
