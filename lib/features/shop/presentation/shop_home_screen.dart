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
import '../domain/food_stock.dart';
import '../domain/shop_models.dart';
import '../domain/shop_rules.dart';
import 'product_widgets.dart';
import 'quick_reorder.dart';
import 'shop_labels.dart';
import '../../../core/theme/ph.dart';

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
        final paw = context.paw;
        const gap = SizedBox(height: Space.xl);
        // Where orders go: the saved address (area and PIN code).
        final address = (ref.watch(addressesProvider).value ?? const <Address>[]).firstOrNull;
        // The food this pet is running low on gets a tag on its picture.
        final lowFood = pet == null || pet.foodProductId == null
            ? null
            : switch (foodState(foodDaysLeft(bagKg: pet.foodBagKg, dailyGrams: pet.dailyPortionG, openedAt: pet.foodOpenedAt, now: DateTime.now()))) {
                FoodState.unknown || FoodState.ok => null,
                _ => pet.foodProductId,
              };
        final partnerProducts = all.where((p) => p.active && p.isAffiliate).take(4).toList();
        final stores = ref.watch(partnerStoresProvider).value ?? const <PartnerStore>[];
        return PageBody(children: [
          const SizedBox(height: Space.sm),
          Row(children: [
            Expanded(child: Semantics(header: true, child: Text(l.shopTitle, style: context.text.displaySmall))),
            PawIconButton(icon: Ph.receipt, tooltip: l.ordMyOrders, badge: open, onPressed: () => context.push('/shop/orders')),
            const SizedBox(width: Space.md),
            const CartButton(tonal: true),
          ]),
          const SizedBox(height: Space.lg),
          SearchPill(hint: l.shopSearchHint, onTap: () => context.push('/shop/search?focus=1')),
          if (address != null) ...[
            const SizedBox(height: Space.md),
            Row(children: [
              Icon(Ph.mapPin, size: IconSizes.xs, color: paw.textSecondary),
              const SizedBox(width: Space.sm),
              Expanded(
                child: Text.rich(
                  TextSpan(children: [
                    TextSpan(text: '${l.shopDeliveringTo} '),
                    TextSpan(text: [address.area, address.pin].where((x) => x.isNotEmpty).join(' '), style: TextStyle(color: paw.textPrimary, fontWeight: FontWeight.w700)),
                  ]),
                  style: context.text.bodySmall?.copyWith(color: paw.textSecondary),
                ),
              ),
            ]),
          ],
          const SizedBox(height: Space.lg),
          _CategoryStrip(species: pet?.species),
          // Buy again first: reordering is the most common job (like an Indian
          // pet shop's "order again"), then picks for the pet.
          if (again.isNotEmpty) ...[
            gap,
            SecHead(l.shopBuyAgain, action: l.ordMyOrders, onAction: () => context.push('/shop/orders')),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              child: IntrinsicHeight(
                child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  for (final (i, p) in again.indexed) ...[
                    if (i > 0) const SizedBox(width: Space.md),
                    _BuyAgainTile(product: p, pet: pet),
                  ],
                ]),
              ),
            ),
          ],
          if (pet != null) ...[
            gap,
            // The pet pills in the top bar choose the pet; no second set of
            // pet chips here (nothing shown twice on a screen).
            Padding(
              padding: const EdgeInsets.only(bottom: Space.xs),
              child: Row(crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [
                Expanded(child: Semantics(header: true, child: Text(l.shopForPet(pet.name), style: context.text.titleLarge))),
                const SizedBox(width: Space.md),
                TextLink(l.seeAll, onTap: () => context.push('/shop/search?species=${pet.species}')),
              ]),
            ),
            Text(_petLine(context, pet), style: context.text.bodySmall?.copyWith(color: paw.textSecondary)),
            const SizedBox(height: Space.md),
            if (picks.isEmpty)
              PawPanel(child: Text(l.shopNoPicks, style: context.text.bodyMedium))
            else
              LayoutBuilder(builder: (context, c) {
                // Two across on phones, up to six on wide screens.
                final cols = (c.maxWidth / Sizes.productCardCompact).floor().clamp(2, 6);
                return TileGrid(
                  columns: cols,
                  spacing: Space.md,
                  rowSpacing: Space.lg,
                  children: [for (final p in picks.take(cols * (cols > 3 ? 1 : 3))) ProductCard(product: p, badge: p.id == lowFood ? l.shopRunningLow : null)],
                );
              }),
            gap,
            // A quick way to a vet before buying (owner's brief).
            Wash(
              onTap: () => context.push(askVetLink),
              child: Row(children: [
                const PawTile(icon: Ph.videoCamera, tone: Tone.marigold),
                const SizedBox(width: Space.md),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(l.shopNotSure(pet.name), style: context.text.labelLarge),
                    Text(l.qaAskVet, style: context.text.bodySmall?.copyWith(color: paw.accent)),
                  ]),
                ),
                const SizedBox(width: Space.md),
                const Chev(),
              ]),
            ),
          ],
          // Offers and the Plus note sit below what the pet needs, as quiet
          // cards (no loud promo banner).
          const BannerStrip(placement: 'shop'),
          if (user != null && !user.isPlus) ...[
            const SizedBox(height: Space.sm),
            InfoNote(l.shopPlusDeliveryNote(Fmt.inr(ref.watch(shopSettingsProvider).plusFreeDeliveryAbove)), icon: Ph.crownSimple, tone: ChipTone.accent),
          ],
          if (featured.isNotEmpty) ...[
            gap,
            SecHead(l.shopFeatured),
            ProductRow(products: featured),
          ],
          if (deals.isNotEmpty) ...[
            gap,
            SecHead(l.shopDeals, action: l.seeAll, onAction: () => context.push('/shop/search?sort=discount')),
            ProductRow(products: deals),
          ],
          gap,
          Padding(
            padding: const EdgeInsets.only(bottom: Space.xs),
            child: Semantics(header: true, child: Text(l.shopFromPartners, style: context.text.titleLarge)),
          ),
          Text(l.shopPartnerStoresNote, style: context.text.bodySmall?.copyWith(color: paw.textSecondary)),
          const SizedBox(height: Space.md),
          // What they sell, each opening the partner's own website…
          ResponsiveGrid(minItemWidth: Sizes.miniCardMin + Space.x3l, children: [
            for (final p in partnerProducts)
              PawPanel(
                onTap: () => context.push('/shop/product/${p.id}'),
                semanticLabel: p.name,
                child: Row(children: [
                  ProductArt(category: p.category, photoUrl: p.photoUrl, seed: p.imageSeed, size: Sizes.tileLg, radius: Sizes.tileLg * Sizes.tileCorner),
                  const SizedBox(width: Space.md),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(p.name, style: context.text.labelLarge, maxLines: 2, overflow: TextOverflow.ellipsis),
                      Text(
                        l.shopBuyOnStore(Fmt.inr(p.price), stores.where((s) => s.id == p.partnerId).firstOrNull?.name ?? l.shopPartnerStore),
                        style: context.text.bodySmall?.copyWith(color: paw.textSecondary),
                      ),
                    ]),
                  ),
                  const SizedBox(width: Space.md),
                  Icon(Ph.arrowSquareOut, size: IconSizes.md, color: paw.textPrimary),
                ]),
              ),
          ]),
          // …and the stores themselves, to see everything from one.
          if (stores.isNotEmpty) ...[
            const SizedBox(height: Space.md),
            Wrap(spacing: Space.sm, runSpacing: Space.sm, children: [
              for (final st in stores)
                PawChip(
                  label: '${st.name} · ${l.shopListings(all.where((p) => p.partnerId == st.id).length)}',
                  icon: Ph.storefront,
                  onTap: () => context.push('/shop/search?store=${st.id}'),
                ),
            ]),
          ],
        ]);
      },
    );
  }

  String _petLine(BuildContext context, Pet pet) {
    final stage = shopLifeStage(pet.lifeStage());
    // "Labrador Retriever, adult. Avoiding: chicken."
    final who = [
      pet.breedName(context.lang).isEmpty ? speciesName(context, pet.species) : pet.breedName(context.lang),
      lifeStageTag(context, stage).toLowerCase(),
    ].join(', ');
    return [who, if (pet.allergies.isNotEmpty) context.l10n.shopAvoiding(pet.allergies.join(', ').toLowerCase())].map((x) => '$x.').join(' ');
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
    final paw = context.paw;
    // "…, Chicken-free Lamb & Rice 10 kg": the last part names the pack.
    final short = p.name.split(', ').last;
    return SizedBox(
      width: Sizes.buyAgainCard,
      child: PawCard(
        padding: const EdgeInsets.all(Space.sm + Space.xxs),
        onTap: () => context.push('/shop/product/${p.id}'),
        child: Row(children: [
          ProductArt(category: p.category, photoUrl: p.photoUrl, seed: p.imageSeed, size: Sizes.thumbLg, radius: Sizes.thumbLg * Sizes.tileCorner),
          const SizedBox(width: Space.md),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
              Text(short, style: context.text.labelMedium?.copyWith(height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis),
              Text(Fmt.inr(p.price), style: context.text.bodySmall?.copyWith(color: paw.textSecondary)),
            ]),
          ),
          const SizedBox(width: Space.md),
          RoundButton(
            icon: Ph.arrowClockwise,
            kind: BtnKind.primary,
            tooltip: p.inStock ? l.shopReorder : l.shopOutOfStock,
            onPressed: p.inStock ? () => showQuickReorder(context, ref, product: p, pet: pet) : null,
          ),
        ]),
      ),
    );
  }
}

/// Categories as a strip of round tiles under the search (UI Design 6).
class _CategoryStrip extends StatelessWidget {
  const _CategoryStrip({this.species});
  final String? species;

  @override
  Widget build(BuildContext context) {
    final paw = context.paw;
    // Round tiles, 56 px, 14 px apart; the first one (food) is marigold.
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        for (final (i, cat) in shopCategories.indexed) ...[
          if (i > 0) const SizedBox(width: Space.md + Space.xxs),
          Semantics(
            button: true,
            label: categoryLabel(context, cat),
            excludeSemantics: true,
            child: InkWell(
              borderRadius: BorderRadius.circular(Radii.md),
              onTap: () => context.push('/shop/search?cat=$cat'),
              child: SizedBox(
                width: Sizes.quickCircle * (MediaQuery.textScalerOf(context).scale(1) > 1.15 ? 1.3 : 1),
                child: Column(children: [
                  PawTile(icon: categoryIcon(cat), size: Sizes.quickCircle, round: true, tone: i == 0 ? Tone.marigold : Tone.neutral),
                  const SizedBox(height: Space.xs + Space.xxs),
                  Text(
                    categoryShort(context, cat),
                    style: context.text.labelSmall?.copyWith(color: paw.textPrimary, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.visible,
                  ),
                ]),
              ),
            ),
          ),
        ],
      ]),
    );
  }
}

