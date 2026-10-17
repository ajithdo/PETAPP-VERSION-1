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
import 'package:pawsetu/core/services/notification_service.dart';
import 'package:pawsetu/core/settings/settings_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../support/map_cache.dart';
import '../support/no_notifications.dart';
import '../support/text_audit.dart';

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

/// Accessibility guidelines counted by the report-only audit.
final _auditGuidelines = <String, AccessibilityGuideline>{
  'labelled tap targets': labeledTapTargetGuideline,
  'Android tap targets (48 px)': androidTapTargetGuideline,
  'iOS tap targets (44 px)': iOSTapTargetGuideline,
  'text contrast': textContrastGuideline,
};

/// Failures for one guideline in one mode.
class A11yTally {
  int screens = 0;
  int failures = 0;
  final failedScreens = <String>{};
  final examples = <String>[];
}

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
  double pixelRatio = 1.0,
  bool easyMode = false,
  bool a11y = false,
  ThemeMode theme = ThemeMode.light,
  bool highContrast = false,
  Map<String, A11yTally>? a11yTally,
  TextAudit? textAudit,
  required List<String> problems,
}) async {
  final semantics = a11y || a11yTally != null ? tester.ensureSemantics() : null;
  tester.view.physicalSize = size * pixelRatio;
  tester.view.devicePixelRatio = pixelRatio;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
    tester.platformDispatcher.clearTextScaleFactorTestValue();
  });

  SharedPreferences.setMockInitialValues({'onboardingSeen': true, 'languageChosen': true, 'locale': locale});
  final prefs = await SharedPreferences.getInstance();
  final db = FakeFirebaseFirestore();
  await tester.runAsync(() => DemoStore.loadInto(db, DemoSeed.build(DateTime.now())));
  final auth = DemoAuthService(db, prefs);
  await tester.runAsync(() => auth.signInAsDemo(uid));
  final container = ProviderContainer(overrides: [
    appConfigProvider.overrideWithValue(const AppConfig(mode: AppMode.demo, backend: Backend.standalone, emulatorHost: 'localhost', firebaseProjectId: 'demo-pawsetu')),
    prefsProvider.overrideWithValue(prefs),
    firestoreProvider.overrideWithValue(db),
    authServiceProvider.overrideWithValue(auth),
    notificationServiceProvider.overrideWithValue(NoNotifications()),
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
    container.read(settingsProvider.notifier).setThemeMode(theme);
    container.read(settingsProvider.notifier).setHighContrast(highContrast);
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
        // (Text contrast is checked exactly in test/core/contrast_test.dart.)
        for (final g in [labeledTapTargetGuideline, androidTapTargetGuideline]) {
          final e = await g.evaluate(tester);
          if (!e.passed) {
            for (final line in (e.reason ?? '').split('\n').where((x) => x.trim().isNotEmpty).take(4)) {
              final msg = '[a11y $locale ${theme.name}] $r: ${line.trim()}';
              if (!problems.contains(msg)) problems.add(msg);
            }
          }
        }
      }
      textAudit?.check(tester, r);
      if (a11yTally != null) {
        // Report only: count failures per guideline and mode, don't fail.
        final mode = highContrast ? 'high contrast' : theme.name;
        for (final MapEntry(key: name, value: g) in _auditGuidelines.entries) {
          final e = await g.evaluate(tester);
          final tally = a11yTally.putIfAbsent('$name ($mode)', A11yTally.new);
          tally.screens++;
          if (!e.passed) {
            tally.failedScreens.add(r);
            final lines = (e.reason ?? '').split('\n').where((x) => x.trim().isNotEmpty).toList();
            tally.failures += lines.length;
            if (tally.examples.length < 12) tally.examples.addAll(lines.take(2).map((x) => '$r: ${x.trim()}'));
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
    useTemporaryMapCache();
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
  testWidgets('dark mode: pet parent and admin screens, phone, te', (t) async {
    await sweep(t, uid: 'u_ravi', routes: ownerRoutes, locale: 'te', size: phone, theme: ThemeMode.dark, problems: problems);
    await sweep(t, uid: 'u_admin', routes: adminRoutes, locale: 'te', size: phone, theme: ThemeMode.dark, problems: problems);
  });
  testWidgets('pet parent screens, desktop, en', (t) async {
    await sweep(t, uid: 'u_priya', routes: ownerRoutes, locale: 'en', size: desktop, problems: problems);
  });
  testWidgets('admin panel, desktop, te', (t) async {
    await sweep(t, uid: 'u_admin', routes: adminRoutes, locale: 'te', size: desktop, problems: problems);
  });

  // Report only (redesign baseline): all four guidelines in light, dark and
  // high contrast. Prints the counts; Phase 7 of the redesign makes them
  // strict. Flutter's text contrast check samples anti-aliased pixels and
  // over-reports at 1 px per point, where small text is mostly anti-aliased
  // edges (see docs/DECISIONS.md), so the audit draws at 3 px per point like
  // a phone; test/core/contrast_test.dart is the exact token check.
  final tally = <String, A11yTally>{};
  final auditLayout = <String>[];
  for (final (theme, hc) in [(ThemeMode.light, false), (ThemeMode.dark, false), (ThemeMode.light, true)]) {
    testWidgets('accessibility audit (report only), phone, en, ${hc ? 'high contrast' : theme.name}', (t) async {
      await sweep(t, uid: 'u_priya', routes: ownerRoutes, locale: 'en', size: phone, theme: theme, highContrast: hc, pixelRatio: 3, a11yTally: tally, problems: auditLayout);
      await sweep(t, uid: 'u_admin', routes: adminRoutes, locale: 'en', size: phone, theme: theme, highContrast: hc, pixelRatio: 3, a11yTally: tally, problems: auditLayout);
      await sweep(t, uid: 'u_clinicadmin', routes: clinicRoutes, locale: 'en', size: phone, theme: theme, highContrast: hc, pixelRatio: 3, a11yTally: tally, problems: auditLayout);
    });
  }

  // Report only (redesign baseline): exact text and icon contrast, small text
  // and cut-off text, from each paragraph's own colours (test/support/text_audit.dart).
  final textAudits = <String, TextAudit>{};
  for (final (label, lang, theme, hc, scale) in [
    ('English, light', 'en', ThemeMode.light, false, 1.0),
    ('Hindi, light', 'hi', ThemeMode.light, false, 1.0),
    ('Telugu, light', 'te', ThemeMode.light, false, 1.0),
    ('English, dark', 'en', ThemeMode.dark, false, 1.0),
    ('English, high contrast', 'en', ThemeMode.light, true, 1.0),
    ('English, light, 200% text', 'en', ThemeMode.light, false, 2.0),
  ]) {
    testWidgets('text audit (report only), phone, $label', (t) async {
      final audit = textAudits[label] = TextAudit();
      for (final (uid, routes) in [('u_priya', ownerRoutes), ('u_admin', adminRoutes), ('u_clinicadmin', clinicRoutes)]) {
        await sweep(t, uid: uid, routes: routes, locale: lang, size: phone, textScale: scale, theme: theme, highContrast: hc, textAudit: audit, problems: auditLayout);
      }
    });
  }

  tearDownAll(() {
    if (textAudits.isNotEmpty) {
      // ignore: avoid_print
      print('TEXT AUDIT (report only):\n${textAudits.entries.map((e) => '  ${e.value.summary(e.key)}').join('\n')}');
    }
    if (tally.isNotEmpty) {
      // ignore: avoid_print
      print('ACCESSIBILITY AUDIT (report only):\n${tally.entries.map((e) => '  ${e.key}: ${e.value.failures} failures on ${e.value.failedScreens.length} of ${e.value.screens} screens'
          '${e.value.failedScreens.isEmpty ? '' : ' [${e.value.failedScreens.join(', ')}]'}'
          '${e.value.examples.isEmpty ? '' : '\n    e.g. ${e.value.examples.join('\n    e.g. ')}'}').join('\n')}\n'
          '  layout problems during the audit runs: ${auditLayout.length}${auditLayout.isEmpty ? '' : '\n    ${auditLayout.join('\n    ')}'}');
    }
    if (problems.isNotEmpty) {
      // ignore: avoid_print
      print('LAYOUT PROBLEMS (${problems.length}):\n${problems.join('\n')}');
    }
    expect(problems, isEmpty, reason: 'see LAYOUT PROBLEMS above');
  });
}
