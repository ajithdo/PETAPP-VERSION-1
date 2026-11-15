import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/cards.dart';
import '../../../core/theme/ph.dart';

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

  /// all, free (people without Plus) or plus
  String get audience => (raw['audience'] as String?) ?? 'all';

  bool showsTo({required bool plus}) => audience == 'all' || (audience == 'plus') == plus;
}

final bannersProvider = StreamProvider<List<PromoBannerData>>((ref) {
  if (ref.watch(currentUserProvider) == null) return Stream.value(const []);
  return ref
      .watch(firestoreProvider)
      .collection('banners')
      .snapshots()
      .map((s) => [for (final d in s.docs) PromoBannerData(d.id, d.data())]..sort((a, b) => a.order.compareTo(b.order)));
});

/// Active banners for [placement] that this person should see, in order.
final activeBannersProvider = Provider.family<List<PromoBannerData>, String>((ref, placement) {
  final all = ref.watch(bannersProvider).value ?? const <PromoBannerData>[];
  final plus = ref.watch(currentUserProvider)?.isPlus ?? false;
  return [for (final b in all) if (b.active && b.placement == placement && b.showsTo(plus: plus)) b];
});

class PromoBanner extends StatelessWidget {
  const PromoBanner({super.key, required this.banner, this.preview = false});
  final PromoBannerData banner;

  /// In the admin panel the banner doesn't open its link.
  final bool preview;

  @override
  Widget build(BuildContext context) {
    // UI Design 5: an offer is a normal card with a small marigold mark,
    // never a loud coloured block (DESIGN.md, no loud promo banners).
    final paw = context.paw;
    final accent = banner.tone == 'accent';
    final open = banner.link.startsWith('/') && !preview;
    return PawCard(
      onTap: open ? () => context.push(banner.link) : null,
      semanticLabel: banner.title,
      child: Row(children: [
        Container(
          width: IconSizes.xxxl,
          height: IconSizes.xxxl,
          decoration: BoxDecoration(color: paw.accentContainer, shape: BoxShape.circle),
          child: Icon(accent ? Ph.tag : Ph.megaphone, color: paw.onAccentContainer, size: IconSizes.md),
        ),
        const SizedBox(width: Space.md),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(banner.title, style: context.text.titleSmall),
            if (banner.body.isNotEmpty) Text(banner.body, style: context.text.bodySmall?.copyWith(color: paw.textSecondary)),
          ]),
        ),
        if (open) Icon(Ph.caretRight, color: paw.textSecondary),
      ]),
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
