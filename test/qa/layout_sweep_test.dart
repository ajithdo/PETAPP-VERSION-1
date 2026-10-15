// Phase 11 layout sweep: opens every main screen with the real fonts in
// English, Hindi and Telugu, at phone width with 200% text, at desktop
// width, and in Easy mode, and fails on any layout overflow or other error.
//
// Run: flutter test test/qa/layout_sweep_test.dart
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pawsetu/app.dart';
import 'package:pawsetu/core/auth/auth_service.dart';
import 'package:pawsetu/core/config/app_config.dart';
import 'package:pawsetu/core/demo/demo_store.dart';
import 'package:pawsetu/core/demo/seed/seed.dart';
import 'package:pawsetu/core/providers.dart';
import 'package:pawsetu/core/routing/router.dart';
import 'package:pawsetu/core/settings/settings_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

const ownerRoutes = [
  '/home',
  '/health',
  '/book',
  '/shop',
  '/me',
  '/me/pets',
  '/me/family',
  '/me/album',
  '/me/devices',
  '/me/lost',
  '/me/lost/pet_bruno',
  '/me/expenses',
  '/me/addresses',
  '/me/plus',
  '/me/refer',
  '/me/help',
  '/me/help/new',
  '/me/help/tk_priya_harness',
  '/me/privacy',
  '/me/settings',
  '/notifications',
  '/pets/pet_bruno',
  '/pets/pet_bruno/edit',
  '/pets/pet_bruno/report',
  '/pets/pet_bruno/card',
  '/pets/new',
  '/book/find/clinic',
  '/book/place/clinic_blr_1',
  '/book/bookings',
  '/shop/orders',
  '/shop/cart',
  '/shop/product/prod_lab_adult_10',
  '/messages',
  '/televet',
  '/ask',
  '/first-aid',
  '/first-aid/choking',
  '/toxic-check',
];

const adminRoutes = [
  '/admin',
  '/admin/approvals',
  '/admin/users',
  '/admin/catalogue',
  '/admin/complaints',
  '/admin/complaints/tk_ravi_walk',
  '/admin/moderation',
  '/admin/settings',
  '/admin/outbox',
  '/admin/audit',
  '/admin/reports/commission',
];

const providerRoutes = ['/partner', '/partner/calendar', '/partner/requests', '/partner/services', '/partner/chat', '/partner/reviews', '/partner/payouts', '/partner/profile', '/partner/help'];
const clinicRoutes = [...providerRoutes, '/partner/staff', '/partner/emergency'];
const vetRoutes = ['/partner', '/partner/televet', '/partner/requests', '/partner/profile', '/partner/help'];
const sellerRoutes = ['/partner', '/partner/products', '/partner/orders', '/partner/returns', '/partner/payouts', '/partner/reviews', '/partner/profile', '/partner/help'];

Future<void> _loadFonts() async {
  Future<void> family(String name, List<int> weights) async {
    final loader = FontLoader(name);
    for (final w in weights) {
      loader.addFont(rootBundle.load('assets/fonts/$name-$w.ttf'));
    }
    await loader.load();
  }

  await family('PlusJakartaSans', [400, 500, 600, 700]);
  await family('NotoSansDevanagari', [400, 500, 600, 700]);
  await family('NotoSansTelugu', [400, 500, 600, 700]);
}

/// Errors that come from the test sandbox, not from the layout: no network
/// (map tiles, photos) and no platform plugins.
bool _sandboxNoise(FlutterErrorDetails d) {
  final text = d.exceptionAsString();
  return d.library == 'image resource service' ||
      text.contains('MissingPluginException') ||
      text.contains('HTTP request failed') ||
      text.contains('NetworkImageLoadException') ||
      text.contains('SocketException') ||
      text.contains('ClientException');
}

Future<void> sweep(
  WidgetTester tester, {
  required String uid,
  required List<String> routes,
  required String locale,
  required Size size,
  double textScale = 1.0,
  bool easyMode = false,
  bool a11y = false,
  required List<String> problems,
}) async {
  final semantics = a11y ? tester.ensureSemantics() : null;
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
    tester.platformDispatcher.clearTextScaleFactorTestValue();
  });

  SharedPreferences.setMockInitialValues({'onboardingSeen': true, 'languageChosen': true, 'locale': locale, 'demo_session_uid': uid});
  final prefs = await SharedPreferences.getInstance();
  final db = FakeFirebaseFirestore();
  await tester.runAsync(() => DemoStore.loadInto(db, DemoSeed.build(DateTime.now())));
  final auth = DemoAuthService(db, prefs);
  final container = ProviderContainer(overrides: [
    appConfigProvider.overrideWithValue(const AppConfig(mode: AppMode.demo, backend: Backend.standalone, emulatorHost: 'localhost', firebaseProjectId: 'demo-pawsetu')),
    prefsProvider.overrideWithValue(prefs),
    firestoreProvider.overrideWithValue(db),
    authServiceProvider.overrideWithValue(auth),
  ]);

  final original = FlutterError.onError;
  var where = 'start';
  FlutterError.onError = (d) {
    if (_sandboxNoise(d)) return;
    final first = d.exceptionAsString().split('\n').first;
    // Where in our code: the widget that overflowed.
    final at = RegExp(r'lib/[\w/]+\.dart:\d+:\d+').firstMatch(d.toString())?.group(0) ?? '';
    final msg = '[$locale ${size.width.toInt()}px x${textScale.toStringAsFixed(1)}${easyMode ? ' easy' : ''}] $where: $first $at';
    if (!problems.contains(msg)) problems.add(msg);
  };
  try {
    await tester.pumpWidget(UncontrolledProviderScope(container: container, child: const PawSetuApp()));
    await tester.pump(const Duration(milliseconds: 200));
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 250));
    }
    // The profile's own language and Easy mode apply on sign-in; set ours after.
    container.read(settingsProvider.notifier).setLocale(locale);
    container.read(settingsProvider.notifier).setEasyMode(easyMode);
    final router = container.read(routerProvider);
    var opened = 0;
    for (final r in routes) {
      where = r;
      router.go(r);
      for (var i = 0; i < 8; i++) {
        await tester.pump(const Duration(milliseconds: 200));
      }
      if (a11y) {
        // Every button and link has a spoken label and is at least 48 px.
        for (final g in [labeledTapTargetGuideline, androidTapTargetGuideline]) {
          final e = await g.evaluate(tester);
          if (!e.passed) {
            for (final line in (e.reason ?? '').split('\n').where((x) => x.trim().isNotEmpty).take(4)) {
              final msg = '[a11y $locale] $r: ${line.trim()}';
              if (!problems.contains(msg)) problems.add(msg);
            }
          }
        }
      }
      final at = router.routerDelegate.currentConfiguration.uri.path;
      if (at != r.split('?').first) problems.add('[$locale] $r: opened $at instead');
      opened++;
      // Scroll down once so lower parts of long pages are laid out too.
      final scrollables = find.byType(Scrollable);
      if (scrollables.evaluate().isNotEmpty) {
        await tester.drag(scrollables.first, const Offset(0, -600), warnIfMissed: false);
        for (var i = 0; i < 3; i++) {
          await tester.pump(const Duration(milliseconds: 200));
        }
      }
    }
    where = 'end';
    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
    await tester.pump(const Duration(minutes: 2));
    // ignore: avoid_print
    print('  checked $opened screens as $uid ($locale, ${size.width.toInt()} px, text x$textScale${easyMode ? ', Easy mode' : ''})');
  } finally {
    FlutterError.onError = original;
    semantics?.dispose();
  }
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initializeDateFormatting();
    await _loadFonts();
  });

  final problems = <String>[];
  const phone = Size(360, 780);
  const desktop = Size(1280, 860);

  for (final lang in ['en', 'hi', 'te']) {
    testWidgets('pet parent screens, phone, 200% text, $lang', (t) async {
      await sweep(t, uid: 'u_priya', routes: ownerRoutes, locale: lang, size: phone, textScale: 2.0, problems: problems);
    });
    testWidgets('admin panel, phone, 200% text, $lang', (t) async {
      await sweep(t, uid: 'u_admin', routes: adminRoutes, locale: lang, size: phone, textScale: 2.0, problems: problems);
    });
    testWidgets('clinic portal, phone, 200% text, $lang', (t) async {
      await sweep(t, uid: 'u_clinicadmin', routes: clinicRoutes, locale: lang, size: phone, textScale: 2.0, problems: problems);
    });
    testWidgets('seller portal, phone, 200% text, $lang', (t) async {
      await sweep(t, uid: 'u_seller', routes: sellerRoutes, locale: lang, size: phone, textScale: 2.0, problems: problems);
    });
  }
  testWidgets('vet and groomer portals, phone, 200% text, te', (t) async {
    await sweep(t, uid: 'u_vet', routes: vetRoutes, locale: 'te', size: phone, textScale: 2.0, problems: problems);
  });
  testWidgets('groomer portal, phone, 200% text, hi', (t) async {
    await sweep(t, uid: 'u_groomer', routes: providerRoutes, locale: 'hi', size: phone, textScale: 2.0, problems: problems);
  });
  testWidgets('pet parent screens in Easy mode, phone, hi', (t) async {
    await sweep(t, uid: 'u_anjali', routes: ownerRoutes, locale: 'hi', size: phone, easyMode: true, problems: problems);
  });
  const tablet = Size(800, 1100);
  testWidgets('pet parent screens, tablet, 150% text, te', (t) async {
    await sweep(t, uid: 'u_ravi', routes: ownerRoutes, locale: 'te', size: tablet, textScale: 1.5, problems: problems);
  });
  testWidgets('partner portals, tablet, hi', (t) async {
    await sweep(t, uid: 'u_clinicadmin', routes: clinicRoutes, locale: 'hi', size: tablet, problems: problems);
    await sweep(t, uid: 'u_seller', routes: sellerRoutes, locale: 'hi', size: tablet, problems: problems);
  });
  testWidgets('accessibility: labels and tap targets, phone, en', (t) async {
    await sweep(t, uid: 'u_priya', routes: ownerRoutes, locale: 'en', size: phone, a11y: true, problems: problems);
    await sweep(t, uid: 'u_admin', routes: adminRoutes, locale: 'en', size: phone, a11y: true, problems: problems);
    await sweep(t, uid: 'u_clinicadmin', routes: clinicRoutes, locale: 'en', size: phone, a11y: true, problems: problems);
  });
  testWidgets('pet parent screens, desktop, en', (t) async {
    await sweep(t, uid: 'u_priya', routes: ownerRoutes, locale: 'en', size: desktop, problems: problems);
  });
  testWidgets('admin panel, desktop, te', (t) async {
    await sweep(t, uid: 'u_admin', routes: adminRoutes, locale: 'te', size: desktop, problems: problems);
  });

  tearDownAll(() {
    if (problems.isNotEmpty) {
      // ignore: avoid_print
      print('LAYOUT PROBLEMS (${problems.length}):\n${problems.join('\n')}');
    }
    expect(problems, isEmpty, reason: 'see LAYOUT PROBLEMS above');
  });
}
