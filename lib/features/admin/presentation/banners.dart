import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';

/// Promotional banners set up in the admin panel (Catalogue → Banners) and
/// shown on Home or in the Shop.
class PromoBannerData {
  PromoBannerData(this.id, this.raw);
  final String id;
  final Map<String, dynamic> raw;
  String get title => (raw['title'] as String?) ?? '';
  String get body => (raw['body'] as String?) ?? '';
  String get link => (raw['link'] as String?) ?? '';

  /// home or shop
  String get placement => (raw['placement'] as String?) ?? 'home';

  /// primary or accent
  String get tone => (raw['tone'] as String?) ?? 'primary';
  bool get active => (raw['active'] as bool?) ?? true;
  int get order => (raw['order'] as num?)?.toInt() ?? 0;
}

final bannersProvider = StreamProvider<List<PromoBannerData>>((ref) {
  if (ref.watch(currentUserProvider) == null) return Stream.value(const []);
  return ref
      .watch(firestoreProvider)
      .collection('banners')
      .snapshots()
      .map((s) => [for (final d in s.docs) PromoBannerData(d.id, d.data())]..sort((a, b) => a.order.compareTo(b.order)));
});

/// Active banners for [placement], newest order first.
final activeBannersProvider = Provider.family<List<PromoBannerData>, String>((ref, placement) {
  final all = ref.watch(bannersProvider).value ?? const <PromoBannerData>[];
  return [for (final b in all) if (b.active && b.placement == placement) b];
});

class PromoBanner extends StatelessWidget {
  const PromoBanner({super.key, required this.banner, this.preview = false});
  final PromoBannerData banner;

  /// In the admin panel the banner doesn't open its link.
  final bool preview;

  @override
  Widget build(BuildContext context) {
    final accent = banner.tone == 'accent';
    final bg = accent ? context.paw.accent : context.colors.primary;
    final fg = accent ? context.paw.onAccent : context.colors.onPrimary;
    final open = banner.link.startsWith('/') && !preview;
    return Semantics(
      button: open,
      label: banner.title,
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(Radii.card),
        child: InkWell(
          borderRadius: BorderRadius.circular(Radii.card),
          onTap: open ? () => context.push(banner.link) : null,
          child: Padding(
            padding: const EdgeInsets.all(Space.lg),
            child: Row(children: [
              Icon(accent ? Icons.local_offer_rounded : Icons.campaign_rounded, color: fg, size: 32),
              const SizedBox(width: Space.md),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(banner.title, style: context.text.titleMedium?.copyWith(color: fg)),
                  if (banner.body.isNotEmpty) Text(banner.body, style: context.text.bodyMedium?.copyWith(color: fg)),
                ]),
              ),
              if (open) Icon(Icons.chevron_right_rounded, color: fg),
            ]),
          ),
        ),
      ),
    );
  }
}

/// The first active banner for [placement] (Home or Shop), or nothing.
class BannerStrip extends ConsumerWidget {
  const BannerStrip({super.key, required this.placement});
  final String placement;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(activeBannersProvider(placement));
    if (list.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: Space.md),
      child: Column(children: [
        for (final b in list.take(2))
          Padding(padding: const EdgeInsets.only(bottom: Space.sm), child: PromoBanner(banner: b)),
      ]),
    );
  }
}
