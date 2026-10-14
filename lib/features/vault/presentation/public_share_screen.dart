import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/logo.dart';
import '../../../core/widgets/widgets.dart';
import '../../album/domain/album.dart';
import '../../album/presentation/album_screen.dart' show MemoryGrid;
import '../../album/presentation/album_viewer.dart';
import '../data/share_service.dart';
import '../domain/share_rules.dart';
import 'doc_preview.dart';
import 'vault_labels.dart';

/// The page a vet or family member opens from a share link. Works without
/// signing in; view only; stops working once expired or turned off.
class PublicShareScreen extends ConsumerStatefulWidget {
  const PublicShareScreen({super.key, required this.token});
  final String token;

  @override
  ConsumerState<PublicShareScreen> createState() => _PublicShareScreenState();
}

class _PublicShareScreenState extends ConsumerState<PublicShareScreen> {
  ShareView? _view;
  bool _loading = true;
  bool _error = false;
  final _pin = TextEditingController();

  @override
  void initState() {
    super.initState();
    _open();
  }

  @override
  void dispose() {
    _pin.dispose();
    super.dispose();
  }

  Future<void> _open([String? pin]) async {
    setState(() {
      _loading = true;
      _error = false;
    });
    try {
      final v = await ref.read(shareLinkServiceProvider).open(widget.token, pin: pin);
      if (mounted) {
        setState(() {
          _view = v;
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint('Open share link failed: $e');
      if (mounted) {
        setState(() {
          _loading = false;
          _error = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final v = _view;
    Widget body;
    if (_loading && v == null) {
      body = const Padding(padding: EdgeInsets.all(Space.xxl), child: Center(child: CircularProgressIndicator()));
    } else if (_error) {
      body = ErrorState(onRetry: () => _open(_pin.text.isEmpty ? null : _pin.text));
    } else {
      body = switch (v!.status) {
        ShareStatus.ok => v.kind == 'album' ? _album(context, v) : _docs(context, v),
        ShareStatus.needsPin || ShareStatus.wrongPin || ShareStatus.locked => _pinCard(context, v),
        _ => _stopped(context, v),
      };
    }
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: context.gutter, vertical: Space.lg),
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 960),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Row(children: [
                    const PawSetuLogo(size: 40, withName: true),
                    const Spacer(),
                    StatusChip(l.vaultViewOnly, tone: ChipTone.info, icon: Icons.visibility_rounded),
                  ]),
                  const SizedBox(height: Space.xl),
                  body,
                  const SizedBox(height: Space.xl),
                  Text(l.vaultSharedFooter, style: context.text.bodySmall, textAlign: TextAlign.center),
                  const SizedBox(height: Space.sm),
                  Center(child: TextButton(onPressed: () => context.go('/splash'), child: Text(l.vaultGetPawSetu))),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context, ShareView v, String title) {
    final l = context.l10n;
    return Row(children: [
      PetAvatar(species: v.species, colorTag: 'amber', size: 56),
      const SizedBox(width: Space.md),
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Semantics(header: true, child: Text(title, style: context.text.titleLarge)),
          Text(v.expiresAt == null ? l.vaultLinkNoEnd : l.vaultSharedUntil(Fmt.dateTime(v.expiresAt!, context.lang)), style: context.text.bodySmall),
        ]),
      ),
    ]);
  }

  Widget _docs(BuildContext context, ShareView v) {
    final l = context.l10n;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      _header(context, v, l.vaultSharedBy(v.ownerName, v.petName)),
      const SizedBox(height: Space.lg),
      if (v.docs.isEmpty) EmptyState(scene: Scene.vault, title: l.vaultNoMatches, compact: true),
      ResponsiveGrid(minItemWidth: 300, children: [
        for (final d in v.docs)
          PawCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Row(children: [
                DocTypeBadge(type: d.type, size: 36),
                const SizedBox(width: Space.sm),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(d.title, style: context.text.titleSmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                    Text([docTypeLabel(context, d.type), if (d.expiry != null) expiryText(context, d.expiry!)].join(' · '), style: context.text.bodySmall),
                  ]),
                ),
              ]),
              const SizedBox(height: Space.md),
              SizedBox(height: 300, child: DocPreview(doc: d, petName: v.petName, onTap: () => openDocViewer(context, d, v.petName))),
            ]),
          ),
      ]),
    ]);
  }

  Widget _album(BuildContext context, ShareView v) {
    final l = context.l10n;
    final groups = groupByMonth(v.items);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      _header(context, v, l.albumSharedBy(v.ownerName, v.petName)),
      const SizedBox(height: Space.lg),
      for (final g in groups) ...[
        Padding(
          padding: const EdgeInsets.only(top: Space.md, bottom: Space.sm),
          child: Text(Fmt.monthYear(g.month, context.lang), style: context.text.titleMedium),
        ),
        MemoryGrid(
          items: g.items,
          onTap: (i) => Navigator.of(context).push(MaterialPageRoute<void>(
            builder: (_) => Scaffold(
              backgroundColor: Colors.black,
              body: MediaPager(items: v.items, initialIndex: v.items.indexOf(i), petName: v.petName),
            ),
          )),
        ),
      ],
    ]);
  }

  Widget _pinCard(BuildContext context, ShareView v) {
    final l = context.l10n;
    final msg = switch (v.status) {
      ShareStatus.wrongPin => l.vaultShareWrongPin,
      ShareStatus.locked => l.vaultShareLocked,
      _ => null,
    };
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: PawCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            const Illustration(Scene.vault, size: 96),
            const SizedBox(height: Space.md),
            Text(l.vaultEnterSharePin, style: context.text.titleMedium, textAlign: TextAlign.center),
            const SizedBox(height: Space.xs),
            Text(l.vaultEnterSharePinBody(v.ownerName), style: context.text.bodyMedium, textAlign: TextAlign.center),
            const SizedBox(height: Space.lg),
            PawTextField(
              label: l.vaultLinkPin,
              controller: _pin,
              keyboardType: TextInputType.number,
              obscure: true,
              enabled: v.status != ShareStatus.locked,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
              onSubmitted: (p) => _open(p),
              autofocus: true,
            ),
            if (msg != null) Text(msg, style: context.text.bodySmall?.copyWith(color: context.paw.error), textAlign: TextAlign.center),
            const SizedBox(height: Space.md),
            PrimaryButton(
              label: l.vaultOpenLink,
              loading: _loading,
              onPressed: v.status == ShareStatus.locked ? null : () => _open(_pin.text),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _stopped(BuildContext context, ShareView v) {
    final l = context.l10n;
    final body = switch (v.status) {
      ShareStatus.revoked => l.vaultLinkRevokedBody,
      ShareStatus.expired => l.vaultLinkExpiredBody(v.expiresAt == null ? '' : Fmt.dateTime(v.expiresAt!, context.lang)),
      _ => l.vaultLinkNotFoundBody,
    };
    return EmptyState(scene: Scene.search, title: l.vaultLinkStopped, message: body);
  }
}
