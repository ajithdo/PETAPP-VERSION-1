import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/config/app_config.dart';
import '../../../core/providers.dart';
import '../../../core/services/messaging_service.dart';
import '../../../core/services/service_providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../pets/domain/pet.dart';
import '../data/vault_repository.dart';
import '../domain/pin_hash.dart';
import '../domain/share_rules.dart';
import 'vault_labels.dart';

/// Web address of a share link. On the website it points at this same
/// site, so the demo link really opens.
String shareLinkUrl(String token) {
  if (kIsWeb) {
    final b = Uri.base;
    return shareUrl(token, webBase: '${b.origin}${b.path}');
  }
  return shareUrl(token);
}

/// "Share with a vet": pick documents, how long the link works and an
/// optional PIN, then copy or send the view-only link (spec 7.9).
Future<void> showVaultShareSheet(BuildContext context, WidgetRef ref, {required Pet pet, List<String> initialDocIds = const []}) {
  return showPawSheet<void>(context, builder: (_) => _VaultShareSheet(pet: pet, initial: initialDocIds));
}

class _VaultShareSheet extends ConsumerStatefulWidget {
  const _VaultShareSheet({required this.pet, required this.initial});
  final Pet pet;
  final List<String> initial;
  @override
  ConsumerState<_VaultShareSheet> createState() => _VaultShareSheetState();
}

class _VaultShareSheetState extends ConsumerState<_VaultShareSheet> {
  late final Set<String> _docs = {...widget.initial};
  ShareExpiry _expiry = ShareExpiry.hours24;
  bool _usePin = true;
  late final _pin = TextEditingController(text: randomSharePin());
  bool _busy = false;
  String? _token;
  String? _error;

  @override
  void dispose() {
    _pin.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    final l = context.l10n;
    if (_docs.isEmpty) {
      setState(() => _error = l.vaultSelectOneDoc);
      return;
    }
    if (_usePin && !isValidPin(_pin.text)) {
      setState(() => _error = l.vaultPinFormat);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final token = await ref.read(vaultRepositoryProvider).createLink(
          owner: ref.read(currentUserProvider)!,
          pet: widget.pet,
          kind: 'docs',
          docIds: _docs.toList(),
          expiresAt: _expiry.from(DateTime.now()),
          pin: _usePin ? _pin.text : null,
        );
    if (mounted) {
      setState(() {
        _busy = false;
        _token = token;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    if (_token != null) {
      final user = ref.read(currentUserProvider)!;
      final url = shareLinkUrl(_token!);
      return ShareLinkResult(
        url: url,
        pin: _usePin ? _pin.text : null,
        expiresAt: _expiry.from(DateTime.now()),
        message: l.vaultShareText(user.firstName, widget.pet.name, url),
      );
    }
    final docs = ref.watch(petDocsProvider(widget.pet.id)).value ?? const [];
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(l.vaultShareTitle, style: context.text.titleMedium),
      const SizedBox(height: Space.xs),
      Text(l.vaultShareBody, style: context.text.bodySmall),
      const SizedBox(height: Space.md),
      Text(l.vaultChooseDocs, style: context.text.titleSmall),
      for (final d in docs)
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          value: _docs.contains(d.id),
          onChanged: (v) => setState(() => v == true ? _docs.add(d.id) : _docs.remove(d.id)),
          secondary: DocTypeBadge(type: d.type, size: 36),
          title: Text(d.title, maxLines: 2, overflow: TextOverflow.ellipsis),
          subtitle: Text(docTypeLabel(context, d.type)),
        ),
      const SizedBox(height: Space.md),
      Text(l.vaultLinkValidFor, style: context.text.titleSmall),
      const SizedBox(height: Space.sm),
      ChoiceRow<ShareExpiry>(
        options: const [ShareExpiry.hour1, ShareExpiry.hours24, ShareExpiry.days7],
        selected: _expiry,
        onSelected: (e) => setState(() => _expiry = e),
        label: (e) => shareExpiryLabel(context, e),
      ),
      const SizedBox(height: Space.sm),
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        value: _usePin,
        onChanged: (v) => setState(() => _usePin = v),
        title: Text(l.vaultAddPin),
        subtitle: Text(l.vaultAddPinHint),
      ),
      if (_usePin)
        PawTextField(
          label: l.vaultLinkPin,
          controller: _pin,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
          prefixIcon: Icons.pin_rounded,
        ),
      if (_error != null) ...[
        Text(_error!, style: context.text.bodySmall?.copyWith(color: context.paw.error)),
        const SizedBox(height: Space.sm),
      ],
      const SizedBox(height: Space.sm),
      PrimaryButton(label: l.vaultCreateLink, icon: Icons.link_rounded, loading: _busy, onPressed: _create),
    ]);
  }
}

/// The finished link with Copy, Share and Send buttons.
class ShareLinkResult extends ConsumerWidget {
  const ShareLinkResult({super.key, required this.url, required this.message, this.pin, this.expiresAt, this.title});
  final String url;
  final String message;
  final String? pin;
  final DateTime? expiresAt;
  final String? title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Row(children: [
        Icon(Icons.check_circle_rounded, color: context.paw.success, size: 28),
        const SizedBox(width: Space.sm),
        Expanded(child: Text(title ?? l.vaultLinkReady, style: context.text.titleMedium)),
      ]),
      const SizedBox(height: Space.md),
      PawCard(
        color: context.paw.background,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SelectableText(url, style: context.text.bodyMedium?.copyWith(color: context.colors.primary)),
          const SizedBox(height: Space.sm),
          Text(expiresAt == null ? l.vaultLinkNoEnd : l.vaultLinkWorksUntil(Fmt.dateTime(expiresAt!, context.lang)), style: context.text.bodySmall),
          if (pin != null) ...[
            const SizedBox(height: Space.xs),
            Text(l.vaultLinkPinIs(pin!), style: context.text.titleSmall),
          ],
        ]),
      ),
      if (pin != null) ...[
        const SizedBox(height: Space.sm),
        InfoNote(l.vaultAddPinHint, icon: Icons.pin_rounded),
      ],
      const SizedBox(height: Space.md),
      Row(children: [
        Expanded(
          child: SecondaryButton(
            label: l.copyLink,
            icon: Icons.copy_rounded,
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: url));
              if (context.mounted) showToast(context, l.copied);
            },
          ),
        ),
        const SizedBox(width: Space.sm),
        Expanded(
          child: SecondaryButton(
            label: l.share,
            icon: Icons.ios_share_rounded,
            onPressed: () async {
              try {
                await SharePlus.instance.share(ShareParams(text: message));
              } catch (e) {
                debugPrint('Share failed: $e');
                await Clipboard.setData(ClipboardData(text: message));
                if (context.mounted) showToast(context, l.vaultShareCopiedInstead);
              }
            },
          ),
        ),
      ]),
      const SizedBox(height: Space.md),
      Text(l.vaultSendTo, style: context.text.titleSmall),
      const SizedBox(height: Space.sm),
      Wrap(spacing: Space.sm, runSpacing: Space.sm, children: [
        for (final ch in [Channel.whatsapp, Channel.sms, Channel.email])
          ActionChip(
            avatar: Icon(switch (ch) { Channel.email => Icons.email_rounded, Channel.sms => Icons.sms_rounded, _ => Icons.chat_rounded }, size: 18),
            label: Text(switch (ch) { Channel.email => l.chEmail, Channel.sms => l.chSms, _ => l.chWhatsApp }),
            onPressed: () => sendShareMessage(context, ref, ch, message),
          ),
      ]),
    ]);
  }
}

/// Sends the link by WhatsApp, SMS or email through the messaging service:
/// in demo mode nothing leaves the app (Demo Outbox + Demo dialog).
Future<void> sendShareMessage(BuildContext context, WidgetRef ref, Channel ch, String message) async {
  final l = context.l10n;
  final to = TextEditingController();
  final email = ch == Channel.email;
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(email ? l.vaultSendEmailTo : l.vaultSendPhoneTo),
      content: TextField(
        controller: to,
        autofocus: true,
        keyboardType: email ? TextInputType.emailAddress : TextInputType.phone,
        decoration: InputDecoration(
          labelText: email ? l.email : l.mobileNumber,
          prefixText: email ? null : '+91 ',
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
        FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l.vaultSend)),
      ],
    ),
  );
  final target = to.text.trim();
  to.dispose();
  if (ok != true || target.isEmpty || !context.mounted) return;
  final user = ref.read(currentUserProvider);
  await ref.read(messagingServiceProvider).send(
        channel: ch,
        to: email ? target : '+91 $target',
        body: message,
        subject: email ? l.vaultShareEmailSubject : null,
        uid: user?.uid,
        type: 'share_link',
      );
  if (!context.mounted) return;
  if (ref.read(appConfigProvider).serviceMode('messaging') == AppMode.demo) {
    await showDemoDialog(context, title: l.demoTitle, body: l.demoOutboxNote);
  } else {
    showToast(context, l.vaultSentTo(target));
  }
}
