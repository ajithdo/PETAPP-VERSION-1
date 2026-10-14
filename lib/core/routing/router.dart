import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/admin/admin_slots.dart';
import '../../features/admin/presentation/admin_shell.dart';
import '../../features/auth/presentation/demo_login_screen.dart';
import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/auth/presentation/phone_sign_in_screen.dart';
import '../../features/auth/presentation/sign_in_screen.dart';
import '../../features/auth/presentation/sign_up_screen.dart';
import '../../features/auth/presentation/verify_email_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/onboarding/presentation/setup_screens.dart';
import '../../features/onboarding/presentation/welcome_screen.dart';
import '../../features/partner/presentation/partner_shell.dart';
import '../../features/settings/presentation/design_gallery_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/shell/presentation/coming_soon_screen.dart';
import '../../features/shell/presentation/me_screen.dart';
import '../../features/shell/presentation/owner_shell.dart';
import '../../features/shell/presentation/splash_screen.dart';
import '../auth/app_user.dart';
import '../providers.dart';
import '../settings/settings_controller.dart';
import 'extra_routes.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

/// Paths anyone can open without signing in.
const publicPrefixes = ['/welcome', '/signin', '/signup', '/forgot', '/phone', '/demo', '/partner-signup', '/lost/', '/share/', '/join/'];
const authPaths = ['/welcome', '/signin', '/signup', '/forgot', '/phone', '/demo', '/splash'];

String homeFor(UserRole role) => switch (role) {
  UserRole.owner => '/home',
  UserRole.admin => '/admin',
  _ => '/partner',
};

class _RouterRefresh extends ChangeNotifier {
  _RouterRefresh(Ref ref) {
    ref.listen(authStateProvider, (_, _) => notifyListeners());
    ref.listen(settingsProvider.select((s) => s.onboardingSeen), (_, _) => notifyListeners());
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = _RouterRefresh(ref);
  ref.onDispose(refresh.dispose);

  String? redirect(BuildContext context, GoRouterState state) {
    final loc = state.matchedLocation;
    final auth = ref.read(authStateProvider);
    final settings = ref.read(settingsProvider);
    final isPublic = publicPrefixes.any((p) => loc == p || loc.startsWith(p.endsWith('/') ? p : '$p/'));

    if (auth.isLoading && !auth.hasValue) return loc == '/splash' ? null : '/splash';
    final user = auth.value;

    if (user == null) {
      if (isPublic) return null;
      return settings.onboardingSeen ? '/signin' : '/welcome';
    }

    if (!user.emailVerified && loc != '/verify-email') return '/verify-email';
    if (user.emailVerified && loc == '/verify-email') return homeFor(user.role);

    final home = homeFor(user.role);
    if (authPaths.contains(loc)) {
      if (user.role == UserRole.owner && !user.onboarded) return '/setup';
      return home;
    }
    if (user.role == UserRole.owner && !user.onboarded && !loc.startsWith('/setup')) return '/setup';

    // Role guards: partner portal, admin panel and owner app are separate.
    if (loc.startsWith('/admin') && user.role != UserRole.admin) return home;
    if ((loc == '/partner' || loc.startsWith('/partner/')) && !user.role.isPartner) return home;
    final ownerArea = ['/home', '/health', '/book', '/shop', '/me', '/pets', '/setup'];
    if (user.role != UserRole.owner && ownerArea.any(loc.startsWith) && !loc.startsWith('/me/settings')) {
      return home;
    }
    return null;
  }

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/splash',
    refreshListenable: refresh,
    redirect: redirect,
    routes: [
      GoRoute(path: '/splash', builder: (_, _) => const SplashScreen()),
      GoRoute(path: '/welcome', builder: (_, _) => const WelcomeScreen()),
      GoRoute(path: '/signin', builder: (_, _) => const SignInScreen()),
      GoRoute(path: '/signup', builder: (_, _) => const SignUpScreen()),
      GoRoute(path: '/forgot', builder: (_, _) => const ForgotPasswordScreen()),
      GoRoute(path: '/phone', builder: (_, _) => const PhoneSignInScreen()),
      GoRoute(path: '/demo', builder: (_, _) => const DemoLoginScreen()),
      GoRoute(path: '/verify-email', builder: (_, _) => const VerifyEmailScreen()),
      GoRoute(
        path: '/setup',
        builder: (_, _) => const SetupPreferencesScreen(),
        routes: [
          GoRoute(path: 'pet', builder: (_, _) => const SetupFirstPetScreen()),
          GoRoute(path: 'notifications', builder: (_, _) => const SetupNotificationsScreen()),
        ],
      ),
      GoRoute(path: '/design-gallery', builder: (_, _) => const DesignGalleryScreen()),
      GoRoute(
        path: '/coming-soon',
        builder: (_, s) => ComingSoonScreen(title: s.uri.queryParameters['title'] ?? '', phase: int.tryParse(s.uri.queryParameters['phase'] ?? '') ?? 0),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => OwnerShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [GoRoute(path: '/home', builder: (_, _) => const HomeScreen(), routes: homeRoutes)],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: '/health', builder: (_, s) => healthTab(s.uri.queryParameters['pet']), routes: healthRoutes)],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: '/book', builder: (_, _) => bookTab(), routes: bookRoutes)],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: '/shop', builder: (_, _) => shopTab(), routes: shopRoutes)],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/me',
                builder: (_, _) => const MeScreen(),
                routes: [
                  GoRoute(path: 'settings', builder: (_, _) => const SettingsScreen(), routes: settingsRoutes),
                  ...meRoutes,
                ],
              ),
            ],
          ),
        ],
      ),
      ...rootRoutes,
      GoRoute(
        path: '/partner',
        builder: (_, _) => const PartnerShell(section: 'dashboard'),
        routes: [
          ...partnerRoutes,
          GoRoute(
            path: ':section',
            builder: (_, s) => PartnerShell(section: s.pathParameters['section']!),
          ),
        ],
      ),
      GoRoute(
        path: '/admin',
        builder: (_, _) => const AdminShell(section: 'dashboard'),
        routes: [
          ...adminExtraRoutes,
          GoRoute(
            path: ':section',
            builder: (_, s) => AdminShell(section: s.pathParameters['section']!),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const ComingSoonScreen(title: '', phase: 0, notFound: true),
  );
});
