import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/app_user.dart';
import '../pets/domain/pet.dart';
import 'presentation/address_screens.dart';
import 'presentation/cart_screen.dart';
import 'presentation/expenses_screen.dart';
import 'presentation/food_low_card.dart';
import 'presentation/order_screens.dart';
import 'presentation/product_list_screen.dart';
import 'presentation/product_screen.dart';
import 'presentation/seller_portal.dart';
import 'presentation/shop_home_screen.dart';

/// Phase 8 slots (marketplace, cart, checkout, orders, expenses, seller
/// portal). Shared files call these; only Phase 8 edits this file.

/// Root widget of the Shop tab (/shop).
Widget shopTabRoot() => const ShopHomeScreen();

/// Routes under /shop (product, cart, checkout, orders...).
final shopTabRoutes = <RouteBase>[
  GoRoute(
    path: 'search',
    builder: (_, s) {
      final q = s.uri.queryParameters;
      return ProductListScreen(query: q['q'] ?? '', category: q['cat'], species: q['species'], store: q['store'], sort: q['sort'], focus: q['focus'] == '1');
    },
  ),
  GoRoute(path: 'product/:id', builder: (_, s) => ProductScreen(productId: s.pathParameters['id']!)),
  GoRoute(path: 'cart', builder: (_, _) => const CartScreen()),
  GoRoute(path: 'orders', builder: (_, s) => OrdersScreen(tab: s.uri.queryParameters['tab'] == 'auto' ? 1 : 0)),
  GoRoute(path: 'orders/:id', builder: (_, s) => OrderDetailScreen(orderId: s.pathParameters['id']!)),
  GoRoute(path: 'placed/:groupId', builder: (_, s) => OrderPlacedScreen(groupId: s.pathParameters['groupId']!)),
];

/// Routes under /me: 'expenses' (Me menu links to /me/expenses) and the
/// address book.
final shopMeRoutes = <RouteBase>[
  GoRoute(path: 'expenses', builder: (_, s) => ExpensesScreen(petId: s.uri.queryParameters['pet'])),
  GoRoute(path: 'addresses', builder: (_, _) => const AddressesScreen()),
];

/// Full-screen routes if needed.
final shopRootRoutes = <RouteBase>[];

/// Extra partner portal pages for sellers under /partner/.
final sellerPartnerRoutes = <RouteBase>[
  GoRoute(path: 'order/:id', builder: (_, s) => SellerOrderScreen(orderId: s.pathParameters['id']!)),
  GoRoute(path: 'product/new', builder: (_, _) => const ProductEditScreen()),
  GoRoute(path: 'product/:id', builder: (_, s) => ProductEditScreen(productId: s.pathParameters['id'])),
  GoRoute(path: 'products/import', builder: (_, _) => const CsvImportScreen()),
];

/// Seller portal sections: dashboard, products, orders, returns, payouts,
/// reviews, profile. Null = coming soon.
Widget? sellerSection(BuildContext context, WidgetRef ref, AppUser user, String section) => sellerPortalSection(context, ref, user, section);

/// Home "food running low" card for [pet]. Empty list = nothing to show.
List<Widget> foodLowSection(BuildContext context, WidgetRef ref, Pet pet) => foodLowCards(context, ref, pet);
