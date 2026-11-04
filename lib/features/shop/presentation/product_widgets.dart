import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../data/shop_repository.dart';
import '../domain/shop_models.dart';
import 'shop_labels.dart';

/// Product picture: the seller's photo, or an illustrated placeholder in
/// the category's colour (the demo has no product photos).
class ProductArt extends StatelessWidget {
  const ProductArt({super.key, required this.category, this.photoUrl, this.seed = 0, this.size, this.radius = 16, this.label});
  final String category;
  final String? photoUrl;
  final int seed;
  final double? size;
  final double radius;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final c = categoryColor(category);
    final shade = (seed % 4) * 0.06;
    Widget art;
    if (photoUrl != null && photoUrl!.isNotEmpty) {
      art = MediaImage(url: photoUrl!, fit: BoxFit.cover, semanticLabel: label);
    } else {
      art = DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color.lerp(c, SeedArtColors.light, 0.82 - shade)!, Color.lerp(c, SeedArtColors.light, 0.55 - shade)!],
          ),
        ),
        child: LayoutBuilder(builder: (context, box) {
          final s = box.biggest.shortestSide.isFinite ? box.biggest.shortestSide : 80.0;
          return Center(child: Icon(categoryIcon(category), size: s * 0.42, color: Color.lerp(c, SeedArtColors.shadow, 0.15)));
        }),
      );
      if (label != null) art = Semantics(image: true, label: label, child: art);
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(width: size, height: size, child: art),
    );
  }
}

class PriceTag extends StatelessWidget {
  const PriceTag({super.key, required this.price, required this.mrp, this.big = false});
  final int price;
  final int mrp;
  final bool big;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final off = mrp > price && mrp > 0 ? ((mrp - price) * 100 / mrp).round() : 0;
    return Semantics(
      label: off > 0 ? l.shopPriceSemantics(Fmt.inr(price), Fmt.inr(mrp), off) : Fmt.inr(price),
      excludeSemantics: true,
      child: Wrap(crossAxisAlignment: WrapCrossAlignment.center, spacing: Space.xs + Space.xxs, runSpacing: Space.xxs, children: [
        Text(Fmt.inr(price), style: (big ? context.text.headlineSmall : context.text.titleSmall)?.copyWith(fontWeight: FontWeight.w700)),
        if (off > 0) ...[
          Text(Fmt.inr(mrp),
              style: (big ? context.text.bodyLarge : context.text.bodySmall)?.copyWith(decoration: TextDecoration.lineThrough, color: context.paw.textSecondary)),
          Text(l.shopOffPercent(off), style: (big ? context.text.titleSmall : context.text.labelMedium)?.copyWith(color: context.paw.success, fontWeight: FontWeight.w700)),
        ],
      ]),
    );
  }
}

class RatingLine extends StatelessWidget {
  const RatingLine({super.key, required this.rating, required this.count});
  final double rating;
  final int count;

  @override
  Widget build(BuildContext context) {
    if (count == 0) return Text(context.l10n.shopNoReviewsYet, style: context.text.bodySmall);
    return Semantics(
      label: context.l10n.shopRatingSemantics(rating.toStringAsFixed(1), count),
      excludeSemantics: true,
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.star_rounded, size: IconSizes.sm, color: context.paw.accent),
        const SizedBox(width: Space.xxs),
        Text(rating.toStringAsFixed(1), style: context.text.labelLarge),
        Text(' ($count)', style: context.text.bodySmall),
      ]),
    );
  }
}

/// Small label on partner-store (affiliate) listings.
class PartnerStoreBadge extends StatelessWidget {
  const PartnerStoreBadge({super.key, this.store});
  final String? store;
  @override
  Widget build(BuildContext context) =>
      StatusChip(store == null ? context.l10n.shopPartnerStore : context.l10n.shopSoldOn(store!), tone: ChipTone.info, icon: Icons.open_in_new_outlined);
}

/// Grid tile for product lists.
class ProductCard extends ConsumerWidget {
  const ProductCard({super.key, required this.product, this.compact = false});
  final Product product;
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final p = product;
    final partners = ref.watch(partnerStoresProvider).value ?? const <PartnerStore>[];
    final store = p.isAffiliate ? partners.where((s) => s.id == p.partnerId).firstOrNull?.name : null;
    return PawCard(
      padding: const EdgeInsets.all(Space.sm),
      onTap: () => context.push('/shop/product/${p.id}'),
      semanticLabel: '${p.name}, ${Fmt.inr(p.price)}${p.isAffiliate ? ', ${l.shopPartnerStore}' : ''}',
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        AspectRatio(
          aspectRatio: compact ? 1.3 : 1.15,
          child: Stack(fit: StackFit.expand, children: [
            ProductArt(category: p.category, photoUrl: p.photoUrl, seed: p.imageSeed, radius: Radii.lg),
            if (p.discountPercent >= 10)
              Positioned(
                left: 6,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: Space.xs + Space.xxs, vertical: Space.xxs),
                  decoration: BoxDecoration(color: context.paw.success, borderRadius: BorderRadius.circular(Radii.sm)),
                  child: Text(l.shopOffPercent(p.discountPercent), style: context.text.labelSmall?.copyWith(color: context.paw.surface, fontWeight: FontWeight.w700)),
                ),
              ),
            if (!p.inStock)
              Positioned.fill(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: MediaColors.scrim, borderRadius: BorderRadius.circular(Radii.lg)),
                  child: Text(l.shopOutOfStock, style: context.text.labelLarge?.copyWith(color: MediaColors.foreground)),
                ),
              ),
          ]),
        ),
        const SizedBox(height: Space.sm),
        Text(p.brand, style: context.text.labelSmall?.copyWith(color: context.paw.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
        Text(p.name, style: context.text.bodyMedium?.copyWith(fontWeight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis),
        const SizedBox(height: Space.xxs),
        PriceTag(price: p.price, mrp: p.mrp),
        const SizedBox(height: Space.xxs),
        if (p.isAffiliate) PartnerStoreBadge(store: store) else RatingLine(rating: p.rating, count: p.reviewCount),
      ]),
    );
  }
}

/// Responsive grid of product cards.
class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key, required this.products});
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final cols = (c.maxWidth / 190).floor().clamp(2, 6);
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: cols, mainAxisSpacing: Space.sm, crossAxisSpacing: Space.sm, mainAxisExtent: _tileHeight(context, c.maxWidth / cols)),
        itemCount: products.length,
        itemBuilder: (_, i) => ProductCard(product: products[i]),
      );
    });
  }

  double _tileHeight(BuildContext context, double width) {
    final scale = MediaQuery.textScalerOf(context).scale(1);
    return (width - 2 * Space.sm) / Sizes.productArtAspect + Sizes.productTextBlock * scale + 2 * Space.sm;
  }
}

/// Horizontal row of product cards.
class ProductRow extends StatelessWidget {
  const ProductRow({super.key, required this.products});
  final List<Product> products;

  /// The row is as tall as its tallest card, so big text and taller
  /// scripts (Hindi, Telugu) never get cut off.
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: IntrinsicHeight(
        child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          for (var i = 0; i < products.length; i++) ...[
            if (i > 0) const SizedBox(width: Space.sm),
            SizedBox(width: Sizes.productCardCompact, child: ProductCard(product: products[i], compact: true)),
          ],
        ]),
      ),
    );
  }
}

class QtyStepper extends StatelessWidget {
  const QtyStepper({super.key, required this.qty, required this.onChanged, this.max = 20, required this.itemName});
  final int qty;
  final ValueChanged<int> onChanged;
  final int max;
  final String itemName;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Container(
      decoration: BoxDecoration(border: Border.all(color: context.paw.outline), borderRadius: BorderRadius.circular(Radii.md)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        IconButton(
          tooltip: qty <= 1 ? l.shopRemoveItem(itemName) : l.shopLessOf(itemName),
          icon: Icon(qty <= 1 ? Icons.delete_outlined : Icons.remove_outlined),
          onPressed: () => onChanged(qty - 1),
        ),
        Semantics(
          label: l.shopQtySemantics(qty),
          excludeSemantics: true,
          child: Text('$qty', style: context.text.titleSmall),
        ),
        IconButton(
          tooltip: l.shopMoreOf(itemName),
          icon: const Icon(Icons.add_outlined),
          onPressed: qty >= max ? null : () => onChanged(qty + 1),
        ),
      ]),
    );
  }
}

/// Cart button with the item count, for app bars.
class CartButton extends ConsumerWidget {
  const CartButton({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final n = ref.watch(cartCountProvider);
    return IconButton(
      tooltip: n == 0 ? context.l10n.shopCart : context.l10n.shopCartWithCount(n),
      onPressed: () => context.push('/shop/cart'),
      icon: Badge(isLabelVisible: n > 0, label: Text('$n'), child: const Icon(Icons.shopping_cart_outlined)),
    );
  }
}
