import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../data/shop_repository.dart';
import '../domain/shop_models.dart';
import '../domain/shop_rules.dart';
import '../../../core/theme/ph.dart';

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
    // No photo: a drawn pack, toy or bed for the category (UI Design 6),
    // never a brand logo or a loud gradient placeholder.
    Widget art;
    if (photoUrl != null && photoUrl!.isNotEmpty) {
      art = MediaImage(url: photoUrl!, fit: BoxFit.cover, semanticLabel: label);
    } else {
      // The seed picks the pack's colour pair (the demo data gives the
      // design's products their own colours).
      final tone = seed % PackColors.pairs.length;
      art = PackShot(kind: PackShot.kindFor(category, seed), tone: tone);
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
      child: Wrap(crossAxisAlignment: WrapCrossAlignment.end, spacing: Space.sm, runSpacing: Space.xxs, children: [
        // The price in the heading cut (20 px), the old price struck out,
        // and the saving in green.
        Text(Fmt.inr(price), style: (big ? context.text.headlineLarge : context.text.titleLarge)?.copyWith(height: big ? null : 1.2)),
        if (off > 0) ...[
          Text(Fmt.inr(mrp),
              style: (big ? context.text.bodyMedium : context.text.bodySmall)?.copyWith(decoration: TextDecoration.lineThrough, color: context.tint.ink3)),
          Text(l.shopOffPercent(off), style: (big ? context.text.labelLarge : context.text.labelSmall)?.copyWith(color: context.paw.success, fontWeight: big ? FontWeight.w600 : FontWeight.w500)),
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
        Icon(Ph.starFill, size: IconSizes.xs, color: context.tint.star),
        const SizedBox(width: Space.xxs + Strokes.hairline),
        Text(rating.toStringAsFixed(1), style: context.text.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: context.paw.textPrimary)),
        const SizedBox(width: Space.sm),
        Text('($count)', style: context.text.bodySmall?.copyWith(color: context.paw.textSecondary)),
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
      StatusChip(store == null ? context.l10n.shopPartnerStore : context.l10n.shopSoldOn(store!), tone: ChipTone.info, icon: Ph.arrowSquareOutFill);
}

/// A product in a grid or row (UI Design 6): no card around it, just the
/// picture on its tint, the brand, the name, the price line and the rating.
/// [badge] sits on the picture ("Running low").
class ProductCard extends ConsumerWidget {
  const ProductCard({super.key, required this.product, this.compact = false, this.badge});
  final Product product;
  final bool compact;
  final String? badge;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final p = product;
    final paw = context.paw;
    final partners = ref.watch(partnerStoresProvider).value ?? const <PartnerStore>[];
    final store = p.isAffiliate ? partners.where((s) => s.id == p.partnerId).firstOrNull?.name : null;
    final wide = !context.isPhone;
    return Semantics(
      button: true,
      label: '${p.name}, ${Fmt.inr(p.price)}${p.isAffiliate ? ', ${l.shopPartnerStore}' : ''}',
      child: InkWell(
        borderRadius: BorderRadius.circular(Radii.lg),
        onTap: () => context.push('/shop/product/${p.id}'),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          AspectRatio(
            aspectRatio: Sizes.productArtAspect,
            child: Stack(fit: StackFit.expand, children: [
              // The discount is shown once, in the price line below.
              ProductArt(category: p.category, photoUrl: p.photoUrl, seed: p.imageSeed, radius: Radii.lg),
              if (badge != null && p.inStock) Positioned(left: Space.xs + Space.xxs, bottom: Space.xs + Space.xxs, child: PawTag(badge!, kind: TagKind.ink)),
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
          Text(p.brand, style: context.text.labelSmall?.copyWith(color: paw.textSecondary, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
          Text(p.name, style: context.text.labelMedium?.copyWith(height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: Space.xs),
          PriceTag(price: p.price, mrp: p.mrp),
          if (wide && !p.isAffiliate && p.inStock) ...[
            const SizedBox(height: Space.xxs),
            // When it arrives, in plain words (on wider screens).
            Row(children: [
              Icon(Ph.truck, size: IconSizes.sm, color: paw.textSecondary),
              const SizedBox(width: Space.xs),
              Flexible(
                child: Text(
                  l.shopDeliveryOn(Fmt.dateShort(addWorkingDays(Fmt.dayOnly(DateTime.now()), p.deliveryDays), context.lang)),
                  style: context.text.bodySmall?.copyWith(color: paw.textSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ]),
          ],
          const SizedBox(height: Space.xs),
          if (p.isAffiliate) PartnerStoreBadge(store: store) else RatingLine(rating: p.rating, count: p.reviewCount),
        ]),
      ),
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
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: cols, mainAxisSpacing: Space.lg, crossAxisSpacing: Space.md, mainAxisExtent: _tileHeight(context, (c.maxWidth - (cols - 1) * Space.md) / cols)),
        itemCount: products.length,
        itemBuilder: (_, i) => ProductCard(product: products[i]),
      );
    });
  }

  double _tileHeight(BuildContext context, double width) {
    final scale = MediaQuery.textScalerOf(context).scale(1);
    return width / Sizes.productArtAspect + Sizes.productTextBlock * scale;
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
            if (i > 0) const SizedBox(width: Space.md),
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
    // A pill with minus, the count and plus (UI Design 6).
    return Container(
      decoration: BoxDecoration(border: Border.all(color: context.paw.controlBorder.withValues(alpha: Opacities.half), width: Strokes.strong), borderRadius: BorderRadius.circular(Radii.full)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        IconButton(
          tooltip: qty <= 1 ? l.shopRemoveItem(itemName) : l.shopLessOf(itemName),
          icon: Icon(qty <= 1 ? Ph.trash : Ph.minus),
          onPressed: () => onChanged(qty - 1),
        ),
        Semantics(
          label: l.shopQtySemantics(qty),
          excludeSemantics: true,
          child: Text('$qty', style: context.text.titleSmall),
        ),
        IconButton(
          tooltip: l.shopMoreOf(itemName),
          icon: const Icon(Ph.plus),
          onPressed: qty >= max ? null : () => onChanged(qty + 1),
        ),
      ]),
    );
  }
}

/// Cart button with the item count, for app bars. [tonal] is the round
/// paper-coloured button of a page header (Shop).
class CartButton extends ConsumerWidget {
  const CartButton({super.key, this.tonal = false});
  final bool tonal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final n = ref.watch(cartCountProvider);
    final tip = n == 0 ? context.l10n.shopCart : context.l10n.shopCartWithCount(n);
    if (tonal) return PawIconButton(icon: Ph.shoppingCartSimple, tooltip: context.l10n.shopCart, badge: n, onPressed: () => context.push('/shop/cart'));
    return IconButton(
      tooltip: tip,
      onPressed: () => context.push('/shop/cart'),
      icon: Badge(isLabelVisible: n > 0, label: Text('$n'), child: const Icon(Ph.shoppingCartSimple)),
    );
  }
}
