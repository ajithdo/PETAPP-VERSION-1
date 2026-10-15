import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../data/privacy_repository.dart';
import '../domain/privacy.dart';

/// Privacy centre (spec 7.14): consents, "Download my data" and "Delete my
/// account" with a 30-day grace period.
class PrivacyScreen extends ConsumerStatefulWidget {
  const PrivacyScreen({super.key});

  @override
  ConsumerState<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends ConsumerState<PrivacyScreen> {
  bool _exporting = false;
  String? _exportSummary;

  Future<void> _export() async {
    final l = context.l10n;
    final user = ref.read(currentUserProvider);
    if (user == null) return;
    setState(() => _exporting = true);
    try {
      final json = await ref.read(privacyRepositoryProvider).exportMyData(user);
      final parts = (jsonDecode(json) as Map).length - 2;
      final bytes = Uint8List.fromList(utf8.encode(json));
      setState(() => _exportSummary = l.prvExportReady(parts, (bytes.length / 1024).ceil()));
      const name = 'pawsetu-my-data.json';
      await SharePlus.instance.share(ShareParams(
        files: [XFile.fromData(bytes, mimeType: 'application/json', name: name)],
        fileNameOverrides: const [name],
        subject: l.prvExportSubject,
      ));
    } catch (_) {
      if (mounted) showToast(context, l.errorTitle);
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  Future<void> _delete() async {
    final l = context.l10n;
    final user = ref.read(currentUserProvider);
    if (user == null) return;
    final when = Fmt.date(deletionDate(DateTime.now()), context.lang);
    final ok = await confirmAction(context, title: l.prvDeleteConfirmTitle, body: l.prvDeleteConfirmBody(when, deletionGraceDays), confirmLabel: l.prvDeleteButton);
    if (!ok || !mounted) return;
    final date = await ref.read(privacyRepositoryProvider).requestDeletion(user);
    if (!mounted) return;
    await showDemoDialog(context, title: l.prvDeleteRequestedTitle, body: l.prvDeleteRequestedBody(Fmt.date(date, context.lang)));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final user = ref.watch(currentUserProvider);
    if (user == null) return const Scaffold(body: SkeletonList());
    final repo = ref.read(privacyRepositoryProvider);
    final consents = user.consents;
    final deletion = user.deletionRequestedAt;
    final items = <(String, String, String, bool)>[
      ('lostPetAlerts', l.prvConsentLost, l.prvConsentLostHint, true),
      ('analytics', l.prvConsentAnalytics, l.prvConsentAnalyticsHint, true),
      ('marketing', l.prvConsentMarketing, l.prvConsentMarketingHint, false),
      ('partnerShare', l.prvConsentPartners, l.prvConsentPartnersHint, false),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(l.privacyCentre)),
      body: PageBody(maxWidth: 800, children: [
        const SizedBox(height: Space.md),
        if (deletion != null) ...[
          InfoNote(l.prvDeletionPending(Fmt.date(deletionDate(deletion), context.lang)), tone: ChipTone.error, icon: Icons.warning_amber_rounded),
          const SizedBox(height: Space.sm),
          PrimaryButton(
            label: l.prvCancelDeletion,
            icon: Icons.restore_rounded,
            onPressed: () async {
              await repo.cancelDeletion(user);
              if (context.mounted) showToast(context, l.prvDeletionCancelled);
            },
          ),
          const SizedBox(height: Space.md),
        ],
        PawCard(
          color: context.paw.primaryContainer,
          child: Row(children: [
            Icon(Icons.privacy_tip_rounded, size: 40, color: context.colors.primary),
            const SizedBox(width: Space.md),
            Expanded(child: Text(l.prvIntro, style: context.text.bodyMedium)),
          ]),
        ),
        SectionHeader(l.prvConsents),
        PawCard(
          padding: const EdgeInsets.symmetric(horizontal: Space.md, vertical: Space.xs),
          child: Column(children: [
            for (final (key, title, hint, def) in items)
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(title),
                subtitle: Text(hint),
                value: (consents[key] as bool?) ?? def,
                onChanged: (v) => repo.setConsent(user, key, v),
              ),
          ]),
        ),
        SectionHeader(l.prvDownloadTitle),
        PawCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(l.prvDownloadBody, style: context.text.bodyMedium),
            const SizedBox(height: Space.md),
            PrimaryButton(label: l.prvDownloadButton, icon: Icons.download_rounded, loading: _exporting, onPressed: _export),
            if (_exportSummary != null) ...[const SizedBox(height: Space.sm), InfoNote(_exportSummary!, tone: ChipTone.success)],
          ]),
        ),
        SectionHeader(l.prvDeleteTitle),
        PawCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(l.prvDeleteBody(deletionGraceDays), style: context.text.bodyMedium),
            const SizedBox(height: Space.md),
            if (deletion == null)
              PrimaryButton(label: l.prvDeleteButton, icon: Icons.delete_forever_rounded, danger: true, onPressed: _delete)
            else
              Text(l.prvDeletionPending(Fmt.date(deletionDate(deletion), context.lang)), style: context.text.bodySmall?.copyWith(color: context.paw.error)),
          ]),
        ),
        const SizedBox(height: Space.md),
        DemoBanner(l.prvDemoNote),
      ]),
    );
  }
}

/// Shown instead of the app when an admin has paused the account.
class SuspendedScreen extends ConsumerWidget {
  const SuspendedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(Space.xl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.block_rounded, size: 72, color: context.paw.error),
                const SizedBox(height: Space.lg),
                Text(l.suspTitle, style: context.text.headlineSmall, textAlign: TextAlign.center),
                const SizedBox(height: Space.sm),
                Text(l.suspBody, style: context.text.bodyLarge, textAlign: TextAlign.center),
                const SizedBox(height: Space.xl),
                PrimaryButton(
                  label: l.suspContact,
                  icon: Icons.email_rounded,
                  onPressed: () => showDemoDialog(context, title: l.suspContact, body: l.suspContactBody),
                ),
                const SizedBox(height: Space.sm),
                SecondaryButton(
                  label: l.signOut,
                  icon: Icons.logout_rounded,
                  onPressed: () async {
                    await ref.read(authServiceProvider).signOut();
                    if (context.mounted) context.go('/signin');
                  },
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
