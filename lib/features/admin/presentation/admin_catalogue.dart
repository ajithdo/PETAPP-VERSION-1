import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../booking/domain/booking_rules.dart';
import '../../shop/domain/shop_models.dart';
import '../../shop/domain/shop_rules.dart';
import '../../shop/presentation/shop_labels.dart';
import '../data/admin_repository.dart';
import 'admin_inputs.dart';
import 'banners.dart';
import 'support_labels.dart';

/// Admin catalogue (spec 10): products (active, featured), category
/// margins, sellers, affiliate partner stores and banners.
class AdminCatalogue extends ConsumerStatefulWidget {
  const AdminCatalogue({super.key});

  @override
  ConsumerState<AdminCatalogue> createState() => _AdminCatalogueState();
}

class _AdminCatalogueState extends ConsumerState<AdminCatalogue> {
  String _tab = 'products';

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final body = switch (_tab) {
      'categories' => const _CategoriesTab(),
      'sellers' => const _SellersTab(),
      'places' => const _PlacesTab(),
      'partners' => const _PartnersTab(),
      'banners' => const _BannersTab(),
      _ => const _ProductsTab(),
    };
    return Column(children: [
      ContentWidth(
        maxWidth: 1000,
        child: Padding(
          padding: const EdgeInsets.only(top: Space.md, bottom: Space.sm),
          child: ChoiceRow<String>(
            options: const ['products', 'categories', 'places', 'sellers', 'partners', 'banners'],
            selected: _tab,
            label: (t) => switch (t) {
              'categories' => l.admTabCategories,
              'sellers' => l.admTabSellers,
              'places' => l.admTabPlaces,
              'partners' => l.admTabPartners,
              'banners' => l.admTabBanners,
              _ => l.admTabProducts,
            },
            onSelected: (t) => setState(() => _tab = t),
          ),
        ),
      ),
      Expanded(child: body),
    ]);
  }
}

// ---------------------------------------------------------------- products

class _ProductsTab extends ConsumerStatefulWidget {
  const _ProductsTab();

  @override
  ConsumerState<_ProductsTab> createState() => _ProductsTabState();
}

class _ProductsTabState extends ConsumerState<_ProductsTab> {
  String _q = '';
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final products = ref.watch(adminCollectionProvider('products'));
    final sellers = {for (final s in ref.watch(adminCollectionProvider('sellers')).value ?? const <Map<String, dynamic>>[]) s['id']: s['name']};
    return AsyncView<List<Map<String, dynamic>>>(
      value: products,
      onRetry: () => ref.invalidate(adminCollectionProvider('products')),
      data: (raw) {
        final all = [for (final m in raw) Product(m['id'] as String, m)]..sort((a, b) => a.name.compareTo(b.name));
        final q = _q.trim().toLowerCase();
        final shown = all.where((p) {
          final ok = switch (_filter) {
            'featured' => p.raw['featured'] == true,
            'hidden' => !p.active,
            'affiliate' => p.isAffiliate,
            'low' => !p.isAffiliate && (p.stock ?? 0) <= 5,
            _ => true,
          };
          return ok && (q.isEmpty || '${p.name} ${p.brand} ${sellers[p.sellerId] ?? ''}'.toLowerCase().contains(q));
        }).toList();
        final visible = shown.take(60).toList();
        return PageBody(maxWidth: 1000, children: [
          PawTextField(label: l.admSearchProducts, prefixIcon: Icons.search_rounded, onChanged: (v) => setState(() => _q = v)),
          const SizedBox(height: Space.sm),
          ChoiceRow<String>(
            options: const ['all', 'featured', 'hidden', 'low', 'affiliate'],
            selected: _filter,
            label: (f) => switch (f) {
              'featured' => l.admFeatured,
              'hidden' => l.admHidden,
              'low' => l.admLowStock,
              'affiliate' => l.admPartnerLinks,
              _ => l.admAllKinds,
            },
            onSelected: (f) => setState(() => _filter = f),
          ),
          const SizedBox(height: Space.sm),
          Text(shown.length > visible.length ? l.admShowingOf(visible.length, shown.length) : l.admProductsCount(shown.length), style: context.text.bodySmall),
          const SizedBox(height: Space.sm),
          if (shown.isEmpty) EmptyState(title: l.admNothingHere, compact: true),
          for (final p in visible) _ProductTile(product: p, seller: sellers[p.sellerId] as String?),
        ]);
      },
    );
  }
}

class _ProductTile extends ConsumerWidget {
  const _ProductTile({required this.product, this.seller});
  final Product product;
  final String? seller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final p = product;
    final featured = p.raw['featured'] == true;
    Future<void> set(Map<String, dynamic> f) async {
      final admin = ref.read(currentUserProvider);
      if (admin == null) return;
      await ref.read(adminRepositoryProvider).updateDoc(admin, 'products', p.id, f, action: 'product_update');
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: Space.sm),
      child: PawCard(
        padding: const EdgeInsets.symmetric(horizontal: Space.md, vertical: Space.sm),
        child: Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(p.name, style: context.text.titleSmall, maxLines: 2, overflow: TextOverflow.ellipsis),
              Text(
                [
                  categoryLabel(context, p.category),
                  Fmt.inr(p.price, context.lang),
                  if (p.isAffiliate) l.admPartnerLink else l.admStock(p.stock ?? 0),
                  ?seller,
                ].join(' · '),
                style: context.text.bodySmall,
              ),
            ]),
          ),
          IconButton(
            tooltip: featured ? l.admUnfeature : l.admFeature,
            onPressed: () => set({'featured': !featured}),
            icon: Icon(featured ? Icons.star_rounded : Icons.star_border_rounded, color: featured ? context.paw.accent : null),
          ),
          Semantics(
            label: l.admShowInShop,
            child: Switch(value: p.active, onChanged: (v) => set({'active': v})),
          ),
        ]),
      ),
    );
  }
}

// ---------------------------------------------------------------- categories

class _CategoriesTab extends ConsumerWidget {
  const _CategoriesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final cfg = ref.watch(appSettingsDocProvider).value;
    final s = ShopSettings.fromConfig(cfg);
    return PageBody(maxWidth: 1000, children: [
      InfoNote(l.admCategoryNote(s.foodMarginPercent.toString(), s.otherMarginPercent.toString())),
      const SizedBox(height: Space.md),
      for (final c in shopCategories)
        Padding(
          padding: const EdgeInsets.only(bottom: Space.sm),
          child: PawCard(
            padding: const EdgeInsets.symmetric(horizontal: Space.md, vertical: Space.sm),
            child: Row(children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(categoryLabel(context, c), style: context.text.titleSmall),
                  Text(
                    s.categoryPercent.containsKey(c) ? l.admMarginCustom('${s.categoryPercent[c]}') : l.admMarginDefault('${commissionPercent(c, s)}'),
                    style: context.text.bodySmall,
                  ),
                ]),
              ),
              TextButton.icon(
                icon: const Icon(Icons.edit_rounded, size: 18),
                label: Text(l.edit),
                onPressed: () async {
                  final v = await askNumber(context,
                      title: l.admMarginFor(categoryLabel(context, c)), initial: s.categoryPercent[c]?.toInt(), suffix: '%', allowEmpty: true, max: 90, helper: l.admEmptyDefault);
                  final admin = ref.read(currentUserProvider);
                  if (v == null || admin == null) return;
                  await ref.read(adminRepositoryProvider).updateConfig(admin, {'commission.categoryPercent.$c': v < 0 ? FieldValue.delete() : v}, what: 'category_margin');
                },
              ),
            ]),
          ),
        ),
    ]);
  }
}

// ---------------------------------------------------------------- sellers

class _SellersTab extends ConsumerWidget {
  const _SellersTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final sellers = ref.watch(adminCollectionProvider('sellers'));
    return AsyncView<List<Map<String, dynamic>>>(
      value: sellers,
      data: (raw) {
        final list = [for (final m in raw) Seller(m['id'] as String, m)]..sort((a, b) => a.name.compareTo(b.name));
        return PageBody(maxWidth: 1000, children: [
          InfoNote(l.admSellerNote),
          const SizedBox(height: Space.md),
          for (final s in list)
            Padding(
              padding: const EdgeInsets.only(bottom: Space.sm),
              child: PawCard(
                padding: const EdgeInsets.symmetric(horizontal: Space.md, vertical: Space.sm),
                child: Row(children: [
                  const CircleAvatar(child: Icon(Icons.storefront_rounded, size: 20)),
                  const SizedBox(width: Space.md),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(s.name, style: context.text.titleSmall),
                      Text(
                        [
                          s.city,
                          if (s.rating > 0) '★ ${s.rating.toStringAsFixed(1)}',
                          s.commissionPercent is num ? l.admMarginCustom('${s.commissionPercent}') : l.admMarginStandard,
                        ].where((x) => x.isNotEmpty).join(' · '),
                        style: context.text.bodySmall,
                      ),
                    ]),
                  ),
                  StatusChip(partnerStatusLabel(context, s.status), tone: partnerStatusTone(s.status)),
                  IconButton(
                    tooltip: l.admEditMargin,
                    icon: const Icon(Icons.percent_rounded),
                    onPressed: () async {
                      final v = await askNumber(context,
                          title: l.admMarginFor(s.name), initial: s.commissionPercent is num ? (s.commissionPercent as num).toInt() : null, suffix: '%', allowEmpty: true, max: 90, helper: l.admEmptyDefault);
                      final admin = ref.read(currentUserProvider);
                      if (v == null || admin == null) return;
                      await ref.read(adminRepositoryProvider).updateDoc(admin, 'sellers', s.id, {'commissionPercent': v < 0 ? FieldValue.delete() : v}, action: 'seller_update');
                    },
                  ),
                ]),
              ),
            ),
        ]);
      },
    );
  }
}

// ---------------------------------------------------------------- clinics and providers

/// Approved clinics and service providers with their booking commission
/// (spec 8: per provider, else per service type, else the default).
class _PlacesTab extends ConsumerStatefulWidget {
  const _PlacesTab();

  @override
  ConsumerState<_PlacesTab> createState() => _PlacesTabState();
}

class _PlacesTabState extends ConsumerState<_PlacesTab> {
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final clinics = ref.watch(adminCollectionProvider('clinics')).value ?? const <Map<String, dynamic>>[];
    final providers = ref.watch(adminCollectionProvider('providers')).value ?? const <Map<String, dynamic>>[];
    final cfg = ref.watch(appSettingsDocProvider).value;
    final all = [
      for (final c in clinics) if (c['status'] == 'approved') ('clinics', 'clinic', c),
      for (final p in providers) if (p['status'] == 'approved') ('providers', (p['type'] as String?) ?? 'groomer', p),
    ]..sort((a, b) => '${a.$3['name']}'.compareTo('${b.$3['name']}'));
    final q = _q.trim().toLowerCase();
    final shown = q.isEmpty ? all : all.where((e) => '${e.$3['name']} ${e.$3['city'] ?? ''}'.toLowerCase().contains(q)).toList();
    return PageBody(maxWidth: 1000, children: [
      InfoNote(l.admPlacesNote),
      const SizedBox(height: Space.md),
      PawTextField(label: l.searchByNameOrArea, prefixIcon: Icons.search_rounded, onChanged: (v) => setState(() => _q = v)),
      const SizedBox(height: Space.md),
      for (final (col, kind, m) in shown.take(60))
        Padding(
          padding: const EdgeInsets.only(bottom: Space.sm),
          child: PawCard(
            padding: const EdgeInsets.symmetric(horizontal: Space.md, vertical: Space.sm),
            child: Row(children: [
              CircleAvatar(child: Icon(partnerKindIcon(kind), size: 20)),
              const SizedBox(width: Space.md),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('${m['name'] ?? ''}', style: context.text.titleSmall),
                  Text(
                    [
                      partnerKindLabel(context, kind),
                      if ((m['city'] as String?)?.isNotEmpty == true) m['city'] as String,
                      m['commissionPercent'] is num
                          ? l.admRateCustom('${m['commissionPercent']}')
                          : l.admRateStandard('${bookingCommissionPercent(cfg, kind: kind)}'),
                    ].join(' · '),
                    style: context.text.bodySmall,
                  ),
                ]),
              ),
              IconButton(
                tooltip: l.admEditMargin,
                icon: const Icon(Icons.percent_rounded),
                onPressed: () async {
                  final v = await askNumber(context,
                      title: l.admRateFor('${m['name'] ?? ''}'),
                      initial: (m['commissionPercent'] as num?)?.toInt(),
                      suffix: '%',
                      allowEmpty: true,
                      max: 50,
                      helper: l.admEmptyDefault);
                  final admin = ref.read(currentUserProvider);
                  if (v == null || admin == null) return;
                  await ref.read(adminRepositoryProvider).updateDoc(admin, col, m['id'] as String, {'commissionPercent': v < 0 ? FieldValue.delete() : v}, action: 'place_update');
                },
              ),
            ]),
          ),
        ),
    ]);
  }
}

// ---------------------------------------------------------------- partner stores

class _PartnersTab extends ConsumerWidget {
  const _PartnersTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final partners = ref.watch(adminCollectionProvider('partners'));
    return AsyncView<List<Map<String, dynamic>>>(
      value: partners,
      data: (raw) {
        final list = [for (final m in raw) PartnerStore(m['id'] as String, m)]..sort((a, b) => a.name.compareTo(b.name));
        return PageBody(maxWidth: 1000, children: [
          InfoNote(l.admPartnersNote),
          const SizedBox(height: Space.md),
          for (final p in list)
            Padding(
              padding: const EdgeInsets.only(bottom: Space.sm),
              child: PawCard(
                padding: const EdgeInsets.symmetric(horizontal: Space.md, vertical: Space.sm),
                onTap: () => _editPartner(context, ref, p),
                child: Row(children: [
                  const CircleAvatar(child: Icon(Icons.link_rounded, size: 20)),
                  const SizedBox(width: Space.md),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(p.name, style: context.text.titleSmall),
                      Text(p.url, style: context.text.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text(l.admPartnerLine('${p.commissionPercent}', p.clicks), style: context.text.bodySmall),
                    ]),
                  ),
                  const Icon(Icons.edit_rounded),
                ]),
              ),
            ),
          const SizedBox(height: Space.sm),
          SecondaryButton(label: l.admAddPartner, icon: Icons.add_rounded, onPressed: () => _editPartner(context, ref, null)),
        ]);
      },
    );
  }

  Future<void> _editPartner(BuildContext context, WidgetRef ref, PartnerStore? p) async {
    final name = TextEditingController(text: p?.name ?? '');
    final url = TextEditingController(text: p?.url ?? 'https://');
    final pct = TextEditingController(text: p == null ? '5' : '${p.commissionPercent}');
    final saved = await showPawSheet<bool>(context, builder: (ctx) {
      final l = ctx.l10n;
      return StatefulBuilder(builder: (ctx, setSheet) {
        final n = int.tryParse(pct.text.trim());
        final ok = name.text.trim().isNotEmpty && url.text.trim().startsWith('https://') && n != null && n >= 0 && n <= 50;
        return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(p == null ? l.admAddPartner : p.name, style: ctx.text.titleMedium),
          const SizedBox(height: Space.md),
          PawTextField(label: l.admPartnerName, controller: name, onChanged: (_) => setSheet(() {})),
          const SizedBox(height: Space.sm),
          PawTextField(label: l.admPartnerUrl, controller: url, keyboardType: TextInputType.url, onChanged: (_) => setSheet(() {})),
          const SizedBox(height: Space.sm),
          PawTextField(label: l.admPartnerCommission, controller: pct, keyboardType: TextInputType.number, suffix: const Text('%'), onChanged: (_) => setSheet(() {})),
          const SizedBox(height: Space.md),
          PrimaryButton(label: l.save, onPressed: ok ? () => Navigator.pop(ctx, true) : null),
          const SizedBox(height: Space.sm),
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l.cancel)),
        ]);
      });
    });
    final admin = ref.read(currentUserProvider);
    if (saved != true || admin == null) return;
    final fields = {'name': name.text.trim(), 'url': url.text.trim(), 'commissionPercent': int.parse(pct.text.trim())};
    final repo = ref.read(adminRepositoryProvider);
    if (p == null) {
      await repo.addDoc(admin, 'partners', {...fields, 'clicks': 0, 'status': 'approved', 'createdAt': DateTime.now()}, action: 'partner_store_update');
    } else {
      await repo.updateDoc(admin, 'partners', p.id, fields, action: 'partner_store_update');
    }
  }
}

// ---------------------------------------------------------------- banners

class _BannersTab extends ConsumerWidget {
  const _BannersTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final banners = ref.watch(bannersProvider);
    return AsyncView<List<PromoBannerData>>(
      value: banners,
      data: (list) => PageBody(maxWidth: 1000, children: [
        InfoNote(l.admBannersNote),
        const SizedBox(height: Space.md),
        if (list.isEmpty) EmptyState(title: l.admNothingHere, compact: true),
        for (final b in list)
          Padding(
            padding: const EdgeInsets.only(bottom: Space.md),
            child: PawCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                PromoBanner(banner: b, preview: true),
                const SizedBox(height: Space.sm),
                Row(children: [
                  StatusChip(b.placement == 'shop' ? l.admPlaceShop : l.admPlaceHome, icon: b.placement == 'shop' ? Icons.storefront_rounded : Icons.home_rounded),
                  const SizedBox(width: Space.xs),
                  StatusChip(bannerAudienceLabel(context, b.audience), icon: Icons.people_rounded),
                  const SizedBox(width: Space.sm),
                  if (b.link.isNotEmpty) Expanded(child: Text(b.link, style: context.text.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis)) else const Spacer(),
                  IconButton(tooltip: l.edit, icon: const Icon(Icons.edit_rounded), onPressed: () => editBanner(context, ref, b)),
                  Semantics(
                    label: l.admBannerShown,
                    child: Switch(
                      value: b.active,
                      onChanged: (v) async {
                        final admin = ref.read(currentUserProvider);
                        if (admin == null) return;
                        await ref.read(adminRepositoryProvider).updateDoc(admin, 'banners', b.id, {'active': v}, action: 'banner_update');
                      },
                    ),
                  ),
                ]),
              ]),
            ),
          ),
        SecondaryButton(label: l.admNewBanner, icon: Icons.add_rounded, onPressed: () => editBanner(context, ref, null)),
      ]),
    );
  }
}

Future<void> editBanner(BuildContext context, WidgetRef ref, PromoBannerData? b) async {
  final title = TextEditingController(text: b?.title ?? '');
  final body = TextEditingController(text: b?.body ?? '');
  final link = TextEditingController(text: b?.link ?? '');
  var placement = b?.placement ?? 'home';
  var tone = b?.tone ?? 'primary';
  var audience = b?.audience ?? 'all';
  final saved = await showPawSheet<bool>(context, builder: (ctx) {
    final l = ctx.l10n;
    return StatefulBuilder(builder: (ctx, setSheet) {
      final linkOk = link.text.trim().isEmpty || link.text.trim().startsWith('/');
      final preview = PromoBannerData('preview', {'title': title.text.trim().isEmpty ? l.admBannerTitle : title.text.trim(), 'body': body.text.trim(), 'tone': tone});
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(b == null ? l.admNewBanner : l.admEditBanner, style: ctx.text.titleMedium),
        const SizedBox(height: Space.md),
        PromoBanner(banner: preview, preview: true),
        const SizedBox(height: Space.md),
        PawTextField(label: l.admBannerTitle, controller: title, onChanged: (_) => setSheet(() {})),
        const SizedBox(height: Space.sm),
        PawTextField(label: l.admBannerBody, controller: body, maxLines: 2, onChanged: (_) => setSheet(() {})),
        const SizedBox(height: Space.sm),
        PawTextField(label: l.admBannerLink, controller: link, hint: '/me/plus', helper: l.admBannerLinkHelp, onChanged: (_) => setSheet(() {})),
        const SizedBox(height: Space.sm),
        ChoiceRow<String>(
          options: const ['home', 'shop'],
          selected: placement,
          label: (p) => p == 'shop' ? l.admPlaceShop : l.admPlaceHome,
          onSelected: (p) => setSheet(() => placement = p),
        ),
        const SizedBox(height: Space.sm),
        ChoiceRow<String>(
          options: const ['primary', 'accent'],
          selected: tone,
          label: (t) => t == 'accent' ? l.admToneOffer : l.admToneNews,
          onSelected: (t) => setSheet(() => tone = t),
        ),
        const SizedBox(height: Space.sm),
        Text(l.admBannerAudience, style: ctx.text.titleSmall),
        const SizedBox(height: Space.xs),
        ChoiceRow<String>(
          options: const ['all', 'free', 'plus'],
          selected: audience,
          label: (a) => bannerAudienceLabel(ctx, a),
          onSelected: (a) => setSheet(() => audience = a),
        ),
        const SizedBox(height: Space.md),
        PrimaryButton(label: l.save, onPressed: title.text.trim().isEmpty || !linkOk ? null : () => Navigator.pop(ctx, true)),
        const SizedBox(height: Space.sm),
        TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l.cancel)),
      ]);
    });
  });
  final admin = ref.read(currentUserProvider);
  if (saved != true || admin == null) return;
  final fields = {'title': title.text.trim(), 'body': body.text.trim(), 'link': link.text.trim(), 'placement': placement, 'tone': tone, 'audience': audience};
  final repo = ref.read(adminRepositoryProvider);
  if (b == null) {
    await repo.addDoc(admin, 'banners', {...fields, 'active': true, 'order': DateTime.now().millisecondsSinceEpoch ~/ 1000, 'createdAt': DateTime.now()}, action: 'banner_create');
  } else {
    await repo.updateDoc(admin, 'banners', b.id, fields, action: 'banner_update');
  }
}

String bannerAudienceLabel(BuildContext context, String audience) {
  final l = context.l10n;
  return switch (audience) {
    'free' => l.admAudienceFree,
    'plus' => l.admAudiencePlus,
    _ => l.admEveryone,
  };
}
