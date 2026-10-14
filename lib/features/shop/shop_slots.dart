import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/app_user.dart';
import '../../core/widgets/widgets.dart';
import '../pets/domain/pet.dart';
import '../shell/presentation/coming_soon_screen.dart';

/// Phase 8 slots (marketplace, cart, checkout, orders, expenses, seller
/// portal). Shared files call these; only Phase 8 edits this file.

/// Root widget of the Shop tab (/shop).
Widget shopTabRoot() => Builder(builder: (c) => ComingSoonScreen(title: c.l10n.tabShop, phase: 8, embedded: true));

/// Routes under /shop (product, cart, checkout, orders...).
final shopTabRoutes = <RouteBase>[];

/// Routes under /me: must include 'expenses' (Me menu links to /me/expenses).
final shopMeRoutes = <RouteBase>[];

/// Full-screen routes if needed.
final shopRootRoutes = <RouteBase>[];

/// Extra partner portal pages for sellers under /partner/ (e.g. order/:id).
final sellerPartnerRoutes = <RouteBase>[];

/// Seller portal sections: dashboard, products, orders, returns, payouts,
/// reviews, profile. Null = coming soon.
Widget? sellerSection(BuildContext context, WidgetRef ref, AppUser user, String section) => null;

/// Home "food running low" card for [pet]. Empty list = nothing to show.
List<Widget> foodLowSection(BuildContext context, WidgetRef ref, Pet pet) => const [];
