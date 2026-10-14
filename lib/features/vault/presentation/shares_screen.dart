import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../data/vault_repository.dart';
import '../domain/share_rules.dart';
import 'share_sheet.dart';
import 'vault_labels.dart';

/// Every link the owner shared: status, who opened it (access log), and
/// "Turn off link" (spec 7.9 revoke anytime).
class ShareLinksScreen extends ConsumerWidget {
  const ShareLinksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.vaultShareLinks)),
      body: AsyncView<List<ShareLink>>(
        value: ref.watch(myShareLinksProvider),
        data: (links) {
          if (links.isEmpty) {
            return EmptyState(scene: Scene.vault, title: l.vaultNoLinks, message: l.vaultNoLinksBody);
          }
          final now = DateTime.now();
          final active = links.where((k) => k.isActive(now)).toList();
          final old = links.where((k) => !k.isActive(now)).toList();
          return PageBody(maxWidth: 820, children: [
            const SizedBox(height: Space.sm),
            InfoNote(l.vaultLinksNote, icon: Icons.shield_rounded),
            if (active.isNotEmpty) ...[
              SectionHeader(l.vaultLinkActive),
              for (final k in active) _LinkTile(link: k),
            ],
            if (old.isNotEmpty) ...[
              SectionHeader(l.vaultLinksOld),
              for (final k in old) _LinkTile(link: k),
            ],
          ]);
        },
      ),
    );
  }
}

class _LinkTile extends StatelessWidget {
  const _LinkTile({required this.link});
  final ShareLink link;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final opens = link.accessLog.where((a) => a.ok).length;
    final what = link.kind == 'album' ? l.vaultLinkAlbum : l.vaultLinkDocs(link.docIds.length);
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.sm),
      child: PawCard(
        padding: const EdgeInsets.all(Space.md),
        onTap: () => showLinkDetails(context, link),
        child: Row(children: [
          CircleAvatar(
            backgroundColor: context.paw.primaryContainer,
            child: Icon(link.kind == 'album' ? Icons.photo_library_rounded : Icons.description_rounded, color: context.colors.primary),
          ),
          const SizedBox(width: Space.md),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${link.petName} · $what', style: context.text.titleSmall),
              Text(
                [
                  link.expiresAt == null ? l.vaultLinkNoEnd : l.vaultLinkWorksUntil(Fmt.dateTime(link.expiresAt!, context.lang)),
                  l.vaultLinkOpened(opens),
                ].join(' · '),
                style: context.text.bodySmall,
              ),
              const SizedBox(height: Space.xs),
              Wrap(spacing: Space.xs, runSpacing: Space.xs, children: [
                linkStatusChip(context, link),
                if (link.hasPin) StatusChip(l.vaultHasPin, tone: ChipTone.info, icon: Icons.pin_rounded),
              ]),
            ]),
          ),
          const Icon(Icons.chevron_right_rounded),
        ]),
      ),
    );
  }
}

/// Link details: copy, access log and revoke.
Future<void> showLinkDetails(BuildContext context, ShareLink link) {
  return showPawSheet<void>(context, builder: (ctx) {
    return Consumer(builder: (ctx, ref, _) {
      final l = ctx.l10n;
      final fresh = (ref.watch(myShareLinksProvider).value ?? const []).where((k) => k.id == link.id).firstOrNull ?? link;
      final url = shareLinkUrl(fresh.id);
      final active = fresh.isActive(DateTime.now());
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Expanded(child: Text('${fresh.petName} · ${fresh.kind == 'album' ? l.vaultLinkAlbum : l.vaultLinkDocs(fresh.docIds.length)}', style: ctx.text.titleMedium)),
          linkStatusChip(ctx, fresh),
        ]),
        const SizedBox(height: Space.xs),
        Text(l.vaultCreatedOn(Fmt.dateTime(fresh.createdAt, ctx.lang)), style: ctx.text.bodySmall),
        if (fresh.revokedAt != null) Text(l.vaultRevokedOn(Fmt.dateTime(fresh.revokedAt!, ctx.lang)), style: ctx.text.bodySmall),
        const SizedBox(height: Space.md),
        if (active)
          Row(children: [
            Expanded(child: SelectableText(url, maxLines: 2, style: ctx.text.bodySmall?.copyWith(color: ctx.colors.primary))),
            IconButton(
              tooltip: l.copyLink,
              icon: const Icon(Icons.copy_rounded),
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: url));
                if (ctx.mounted) showToast(ctx, l.copied);
              },
            ),
          ]),
        SectionHeader(l.vaultAccessLog, padding: const EdgeInsets.only(top: Space.md, bottom: Space.xs)),
        if (fresh.accessLog.isEmpty)
          Text(l.vaultNoAccess, style: ctx.text.bodyMedium)
        else
          for (final a in fresh.accessLog.take(20))
            ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              leading: Icon(a.ok ? Icons.visibility_rounded : Icons.block_rounded, color: a.ok ? ctx.paw.success : ctx.paw.error),
              title: Text(a.ok ? l.vaultAccessOk : l.vaultAccessWrongPin),
              subtitle: Text('${Fmt.dateTime(a.at, ctx.lang)} · ${a.device}'),
            ),
        const SizedBox(height: Space.lg),
        if (active)
          PrimaryButton(
            label: l.vaultRevoke,
            icon: Icons.link_off_rounded,
            danger: true,
            onPressed: () async {
              final ok = await confirmAction(ctx, title: l.vaultRevokeQ, body: l.vaultRevokeBody, confirmLabel: l.vaultRevoke);
              if (!ok) return;
              await ref.read(vaultRepositoryProvider).revokeLink(fresh.id);
              if (ctx.mounted) {
                Navigator.pop(ctx);
                showToast(context, l.vaultRevoked);
              }
            },
          ),
      ]);
    });
  });
}
