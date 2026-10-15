import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../pets/data/pets_repository.dart';
import '../../pets/domain/pet.dart';
import '../data/order_repository.dart';
import '../data/shop_repository.dart';
import '../domain/food_stock.dart';
import '../domain/shop_models.dart';
import 'product_widgets.dart';
import 'quick_reorder.dart';

/// Home "food running low" card (spec 7.10): "Bruno's food may run out in
/// about 5 days. Reorder?" Reordering takes two taps.
List<Widget> foodLowCards(BuildContext context, WidgetRef ref, Pet pet) {
  final productId = pet.foodProductId;
  if (productId == null) return const [];
  final days = foodDaysLeft(bagKg: pet.foodBagKg, dailyGrams: pet.dailyPortionG, openedAt: pet.foodOpenedAt, now: DateTime.now());
  final state = foodState(days);
  if (state == FoodState.unknown || state == FoodState.ok) return const [];
  final product = ref.watch(productProvider(productId)).value;
  if (product == null) return const [];
  final orders = ref.watch(myOrdersProvider).value ?? const <ShopOrder>[];
  final opened = pet.foodOpenedAt ?? DateTime(2000);
  final pending = orders
      .where((o) => o.isOpen && o.petId == pet.id && o.createdAt.isAfter(opened) && o.items.any((i) => i.productId == productId))
      .firstOrNull;
  return [
    const SizedBox(height: Space.lg),
    pending != null ? _OnTheWay(pet: pet, order: pending) : _FoodLowCard(pet: pet, product: product, daysLeft: days!),
  ];
}

class _FoodLowCard extends ConsumerWidget {
  const _FoodLowCard({required this.pet, required this.product, required this.daysLeft});
  final Pet pet;
  final Product product;
  final double daysLeft;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final out = daysLeft <= 0;
    return PawCard(
      color: Color.lerp(context.paw.accent, context.paw.surface, Theme.of(context).brightness == Brightness.dark ? 0.8 : 0.86),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ProductArt(category: product.category, photoUrl: product.photoUrl, seed: product.imageSeed, size: 56, radius: 12),
          const SizedBox(width: Space.md),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(out ? l.foodRanOut(pet.name) : l.foodRunsOutIn(pet.name, roundDays(daysLeft)), style: context.text.titleSmall),
              const SizedBox(height: 2),
              Text(product.name, style: context.text.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
              Text(l.foodPortionLine(pet.dailyPortionG ?? 0, Fmt.weight(pet.foodBagKg ?? 0)), style: context.text.bodySmall),
            ]),
          ),
        ]),
        const SizedBox(height: Space.md),
        Row(children: [
          TextButton(onPressed: () => editFoodPlan(context, ref, pet), child: Text(l.foodEditPortion)),
          const Spacer(),
          FilledButton.icon(
            onPressed: product.inStock ? () => showQuickReorder(context, ref, product: product, pet: pet) : () => context.push('/shop/product/${product.id}'),
            icon: const Icon(Icons.replay_rounded),
            label: Text(product.inStock ? l.shopReorderPrice(Fmt.inr(product.price)) : l.shopOutOfStock),
          ),
        ]),
      ]),
    );
  }
}

class _OnTheWay extends StatelessWidget {
  const _OnTheWay({required this.pet, required this.order});
  final Pet pet;
  final ShopOrder order;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return PawCard(
      onTap: () => context.push('/shop/orders/${order.id}'),
      child: Row(children: [
        Icon(Icons.local_shipping_rounded, color: context.colors.primary, size: 32),
        const SizedBox(width: Space.md),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(l.foodOnTheWay(pet.name), style: context.text.titleSmall),
            if (order.expectedBy != null) Text(l.ordArrivingBy(Fmt.weekdayDate(order.expectedBy!, context.lang)), style: context.text.bodySmall),
          ]),
        ),
        Text(l.ordTrack, style: context.text.labelLarge?.copyWith(color: context.colors.primary)),
      ]),
    );
  }
}

/// Bag size, daily portion and the day the bag was opened.
Future<void> editFoodPlan(BuildContext context, WidgetRef ref, Pet pet) async {
  final l = context.l10n;
  final portion = TextEditingController(text: '${pet.dailyPortionG ?? suggestedDailyGrams(species: pet.species, weightKg: pet.weightKg, lifeStage: pet.lifeStage())}');
  final bag = TextEditingController(text: pet.foodBagKg == null ? '' : Fmt.weight(pet.foodBagKg!).replaceAll(RegExp(r'[^0-9.]'), ''));
  var opened = pet.foodOpenedAt ?? DateTime.now();
  final suggested = suggestedDailyGrams(species: pet.species, weightKg: pet.weightKg, lifeStage: pet.lifeStage());
  final ok = await showPawSheet<bool>(context, builder: (ctx) => StatefulBuilder(builder: (ctx, setState) {
        return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(l.foodPlanTitle(pet.name), style: ctx.text.titleMedium),
          const SizedBox(height: Space.md),
          PawTextField(
            label: l.foodDailyPortion,
            controller: portion,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            suffix: const Padding(padding: EdgeInsets.all(14), child: Text('g')),
            helper: l.foodSuggested(suggested),
          ),
          PawTextField(
            label: l.foodBagSize,
            controller: bag,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            suffix: const Padding(padding: EdgeInsets.all(14), child: Text('kg')),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.event_rounded),
            title: Text(l.foodOpenedOn),
            subtitle: Text(Fmt.date(opened, ctx.lang)),
            onTap: () async {
              final d = await showDatePicker(context: ctx, initialDate: opened, firstDate: DateTime.now().subtract(const Duration(days: 180)), lastDate: DateTime.now());
              if (d != null) setState(() => opened = d);
            },
          ),
          const SizedBox(height: Space.sm),
          PrimaryButton(label: l.save, onPressed: () => Navigator.pop(ctx, true)),
        ]);
      }));
  if (ok == true) {
    final g = int.tryParse(portion.text);
    final kg = double.tryParse(bag.text.replaceAll(',', '.'));
    await ref.read(petsRepositoryProvider).updatePet(pet.id, {
      if (g != null && g > 0) 'dailyPortionG': g,
      if (kg != null && kg > 0) 'foodBagKg': kg,
      'foodOpenedAt': opened,
    });
  }
  portion.dispose();
  bag.dispose();
}
