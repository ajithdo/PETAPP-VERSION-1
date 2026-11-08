import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/utils/read_once.dart';
import '../../../core/widgets/widgets.dart';
import '../../admin/presentation/banners.dart';
import '../../messaging/messaging_slots.dart' show askVetLink;
import '../../pets/data/pets_repository.dart';
import '../../pets/domain/pet.dart';
import '../data/order_repository.dart';
import '../data/shop_repository.dart';
import '../domain/shop_models.dart';
import '../domain/shop_rules.dart';
import 'product_widgets.dart';
import 'quick_reorder.dart';
import 'shop_labels.dart';

/// Shop tab (spec 7.10): search, personalised picks per pet, Buy again,
/// categories, deals and partner stores.
class ShopHomeScreen extends ConsumerStatefulWidget {
  const ShopHomeScreen({super.key});
  @override
  ConsumerState<ShopHomeScreen> createState() => _ShopHomeScreenState();
}

class _ShopHomeScreenState extends ConsumerState<ShopHomeScreen> {
  String? _petId;
  bool _ranSubs = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _runSubscriptions());
  }

  /// Standalone demo: due auto-reorders are placed when the shop opens.
  Future<void> _runSubscriptions() async {
    if (_ranSubs || !ref.read(appConfigProvider).isStandalone) return;
    _ranSubs = true;
    final user = ref.read(currentUserProvider);
    if (user == null) return;
    final subs = await readOnce(ref, mySubscriptionsProvider);
    if (dueSubscriptions(subs, DateTime.now()).isEmpty) return;
    final pets = await readOnce(ref, myPetsProvider);
    final n = await ref.read(orderRepositoryProvider).runDueSubscriptions(user, subs, {for (final p in pets) p.id: p});
    if (n > 0 && mounted) showToast(context, context.l10n.subsOrderedToast(n));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final user = ref.watch(currentUserProvider);
    final products = ref.watch(productsProvider);
    final pets = ref.watch(activePetsProvider);
    final selected = ref.watch(selectedPetProvider);
    final orders = ref.watch(myOrdersProvider).value ?? const <ShopOrder>[];
    final pet = pets.where((p) => p.id == _petId).firstOrNull ?? selected ?? pets.firstOrNull;
    final open = orders.where((o) => o.isOpen).length;

    return AsyncView<List<Product>>(
      value: products,
      onRetry: () => ref.invalidate(productsProvider),
      data: (all) {
        final byId = {for (final p in all) p.id: p};
        final picks = pet == null
            ? const <Product>[]
            : picksFor(all, species: pet.species, lifeStage: pet.lifeStage(), breedSize: pet.size.name, allergies: pet.allergies);
        final again = [for (final id in buyAgainIds(orders)) ?byId[id]].where((p) => p.active && !p.isAffiliate).toList();
        final featured = all.where((p) => p.active && p.featured).take(10).toList();
        final deals = (all.where((p) => p.active && p.discountPercent >= 15).toList()..sort((a, b) => b.discountPercent.compareTo(a.discountPercent))).take(10).toList();
        return PageBody(children: [
          const SizedBox(height: Space.sm),
          Row(children: [
            Expanded(child: Semantics(header: true, child: Text(l.shopTitle, style: context.text.headlineMedium))),
            IconButton(tooltip: l.ordMyOrders, onPressed: () => context.push('/shop/orders'), icon: Badge(isLabelVisible: open > 0, label: Text('$open'), child: const Icon(Icons.receipt_long_outlined))),
            const CartButton(),
          ]),
          const SizedBox(height: Space.sm),
          Semantics(
            button: true,
            label: l.shopSearchHint,
            excludeSemantics: true,
            child: InkWell(
              borderRadius: BorderRadius.circular(Radii.full),
              onTap: () => context.push('/shop/search?focus=1'),
              child: InputDecorator(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search_outlined),
                  hintText: l.shopSearchHint,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(Radii.full), borderSide: BorderSide(color: context.paw.controlBorder)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(Radii.full), borderSide: BorderSide(color: context.paw.controlBorder)),
                ),
                child: Text(l.shopSearchHint, style: context.text.bodyLarge?.copyWith(color: context.paw.textSecondary)),
              ),
            ),
          ),
          // Buy again first: reordering is the most common job (like an Indian
          // pet shop's "order again"), then picks for the pet.
          if (again.isNotEmpty) ...[
            SectionHeader(l.shopBuyAgain, action: l.ordMyOrders, onAction: () => context.push('/shop/orders')),
            SizedBox(
              // Taller for Hindi and Telugu, whose lines are taller.
              height: (Sizes.buyAgainTile + (context.lang == 'en' ? 0 : Space.xl)) * MediaQuery.textScalerOf(context).scale(1) + Space.xl,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: again.length,
                separatorBuilder: (_, _) => const SizedBox(width: Space.sm),
                itemBuilder: (_, i) => _BuyAgainTile(product: again[i], pet: pet),
              ),
            ),
          ],
          if (pet != null) ...[
            SectionHeader(l.shopForPet(pet.name)),
            // The pet pills in the top bar choose the pet; no second set of
            // pet chips here (nothing shown twice on a screen).
            Text(_petLine(context, pet), style: context.text.bodySmall),
            const SizedBox(height: Space.sm),
            if (picks.isEmpty) PawCard(child: Text(l.shopNoPicks)) else ProductRow(products: picks),
            const SizedBox(height: Space.md),
            // A quick way to a vet before buying (owner's brief).
            PawCard(
              onTap: () => context.push(askVetLink),
              child: Row(children: [
                CircleAvatar(backgroundColor: context.paw.accentContainer, child: Icon(Icons.support_agent_outlined, color: context.paw.onAccentContainer)),
                const SizedBox(width: Space.md),
                Expanded(child: Text(l.shopAskVet(pet.name), style: context.text.titleSmall)),
                Icon(Icons.chevron_right_rounded, color: context.paw.textSecondary),
              ]),
            ),
          ],
          SectionHeader(l.shopCategories),
          _CategoryGrid(species: pet?.species),
          // Offers and the Plus note sit below what the pet needs, as quiet
          // cards (no loud promo banner).
          const BannerStrip(placement: 'shop'),
          if (user != null && !user.isPlus) ...[
            const SizedBox(height: Space.sm),
            InfoNote(l.shopPlusDeliveryNote(Fmt.inr(ref.watch(shopSettingsProvider).plusFreeDeliveryAbove)), icon: Icons.workspace_premium_outlined, tone: ChipTone.accent),
          ],
          if (featured.isNotEmpty) ...[
            SectionHeader(l.shopFeatured),
            ProductRow(products: featured),
          ],
          if (deals.isNotEmpty) ...[
            SectionHeader(l.shopDeals, action: l.seeAll, onAction: () => context.push('/shop/search?sort=discount')),
            ProductRow(products: deals),
          ],
          SectionHeader(l.shopPartnerStores),
          Text(l.shopPartnerStoresNote, style: context.text.bodySmall),
          const SizedBox(height: Space.sm),
          _PartnerStores(products: all),
        ]);
      },
    );
  }

  String _petLine(BuildContext context, Pet pet) {
    final stage = shopLifeStage(pet.lifeStage());
    return [
      pet.breedName(context.lang).isEmpty ? speciesName(context, pet.species) : pet.breedName(context.lang),
      lifeStageTag(context, stage),
      if (pet.allergies.isNotEmpty) context.l10n.shopAvoiding(pet.allergies.join(', ')),
    ].join(' · ');
  }
}

class _BuyAgainTile extends ConsumerWidget {
  const _BuyAgainTile({required this.product, this.pet});
  final Product product;
  final Pet? pet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final p = product;
    return SizedBox(
      width: Sizes.reorderCard,
      child: PawCard(
        padding: const EdgeInsets.all(Space.sm),
        onTap: () => context.push('/shop/product/${p.id}'),
        child: Row(children: [
          ProductArt(category: p.category, photoUrl: p.photoUrl, seed: p.imageSeed, size: Sizes.thumbXl, radius: Radii.md),
          const SizedBox(width: Space.sm),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              Text(p.name, style: context.text.bodyMedium?.copyWith(fontWeight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis),
              Text(Fmt.inr(p.price), style: context.text.bodySmall),
              const SizedBox(height: Space.xs),
              FilledButton.tonalIcon(
                onPressed: p.inStock ? () => showQuickReorder(context, ref, product: p, pet: pet) : null,
                icon: const Icon(Icons.replay_outlined, size: IconSizes.chip),
                label: Text(p.inStock ? l.shopReorder : l.shopOutOfStock),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid({this.species});
  final String? species;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final cols = (c.maxWidth / 120).floor().clamp(3, 7);
      return TileGrid(
        columns: cols,
        spacing: Space.sm,
        minTileHeight: 104,
        children: [
          for (final cat in shopCategories)
            // Calm tiles: warm grey, the category's icon in its own colour.
            Material(
              color: context.paw.surfaceSubtle,
              borderRadius: BorderRadius.circular(Radii.lg),
              child: InkWell(
                borderRadius: BorderRadius.circular(Radii.lg),
                onTap: () => context.push('/shop/search?cat=$cat'),
                child: Padding(
                  padding: const EdgeInsets.all(Space.sm),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(categoryIcon(cat), color: readableOn(categoryColor(cat), [context.paw.surfaceSubtle], ratio: 3), size: IconSizes.xl),
                    const SizedBox(height: Space.xs),
                    Text(categoryLabel(context, cat), style: context.text.labelMedium, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
                  ]),
                ),
              ),
            ),
        ],
      );
    });
  }
}

class _PartnerStores extends ConsumerWidget {
  const _PartnerStores({required this.products});
  final List<Product> products;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final stores = ref.watch(partnerStoresProvider).value ?? const <PartnerStore>[];
    return ResponsiveGrid(minItemWidth: 260, children: [
      for (final s in stores)
        PawCard(
          onTap: () => context.push('/shop/search?store=${s.id}'),
          child: Row(children: [
            CircleAvatar(backgroundColor: context.paw.primaryContainer, child: Icon(Icons.storefront_outlined, color: context.colors.primary)),
            const SizedBox(width: Space.md),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(s.name, style: context.text.titleSmall),
                Text(l.shopListings(products.where((p) => p.partnerId == s.id).length), style: context.text.bodySmall),
              ]),
            ),
            const Icon(Icons.chevron_right_outlined),
          ]),
        ),
    ]);
  }
}
