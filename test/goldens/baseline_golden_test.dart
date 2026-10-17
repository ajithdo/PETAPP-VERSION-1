// Redesign baseline goldens: 17 key screens in 11 combinations of screen
// size, theme, language and text size (187 images), with the real fonts.
//
// Generated in the Claude Code cloud environment (Linux). Goldens are
// platform-sensitive, so compare them in the same environment.
//
// Create or refresh: flutter test --update-goldens test/goldens/
// Compare:           flutter test test/goldens/
//
// The app reads DateTime.now() directly and the demo data is built relative
// to today, so the greeting and printed dates change between runs. Until the
// app reads time through one replaceable clock, the comparison allows a small
// share of changed pixels (see _TolerantComparator).
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

/// Screens by who sees them. `null` means signed out.
const _screens = <String?, Map<String, String>>{
  null: {'welcome': '/welcome', 'signin': '/signin'},
  'u_priya': {
    'home': '/home',
    'health': '/health',
    'book': '/book',
    'shop': '/shop',
    'me': '/me',
    'pet_profile': '/pets/pet_bruno',
    'routine': '/pets/pet_bruno/routine',
    'booking_flow': '/book/new/clinic_blr_1',
    'cart': '/shop/cart',
    'sos': '/sos',
    'vault': '/me/vault',
    'messages': '/messages',
    'notifications': '/notifications',
  },
  'u_clinicadmin': {'partner_dashboard': '/partner'},
  'u_admin': {'admin_dashboard': '/admin'},
};

class _Variant {
  const _Variant(this.size, {this.theme = ThemeMode.light, this.highContrast = false, this.locale = 'en', this.textScale = 1.0});
  final Size size;
  final ThemeMode theme;
  final bool highContrast;
  final String locale;
  final double textScale;

  String get name {
    final mode = highContrast ? 'hc' : theme.name;
    return '${size.width.toInt()}x${size.height.toInt()}_${mode}_${locale}_${textScale.toStringAsFixed(0)}x';
  }
}

const _phone = Size(390, 844);
const _desktop = Size(1280, 800);

const _variants = [
  // Every size, light, English, normal text.
  _Variant(Size(360, 800)),
  _Variant(_phone),
  _Variant(Size(800, 1280)),
  _Variant(_desktop),
  // Phone: dark, high contrast, Hindi, Telugu, 200% text.
  _Variant(_phone, theme: ThemeMode.dark),
  _Variant(_phone, highContrast: true),
  _Variant(_phone, locale: 'hi'),
  _Variant(_phone, locale: 'te'),
  _Variant(_phone, textScale: 2.0),
  // Desktop: dark and Telugu.
  _Variant(_desktop, theme: ThemeMode.dark),
  _Variant(_desktop, locale: 'te'),
];

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
  // Material icons, so icons render as glyphs instead of boxes.
  final icons = FontLoader('MaterialIcons')..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
  await icons.load();
}

/// Errors that come from the test sandbox, not from the app: no network
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

/// Phone notifications need platform plugins the test sandbox doesn't have;
/// their errors would land while a golden is being written.
class _NoNotifications implements NotificationService {
  @override
  Future<void> init() async {}
  @override
  Future<bool> requestPermission() async => false;
  @override
  Future<void> schedule({required int id, required String title, required String body, required DateTime at, required String payload, bool medicineActions = false}) async {}
  @override
  Future<void> showNow({required int id, required String title, required String body, required String payload, bool medicineActions = false}) async {}
  @override
  Future<void> cancelAll() async {}
  @override
  Stream<NotificationTap> get taps => const Stream.empty();
  @override
  bool get supported => false;
}

/// Passes when at most [_tolerance] of the pixels differ, so a changed date
/// or greeting doesn't fail the comparison.
class _TolerantComparator extends LocalFileComparator {
  _TolerantComparator(super.testFile);

  static const _tolerance = 0.03;

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final result = await GoldenFileComparator.compareLists(imageBytes, await getGoldenBytes(golden));
    if (result.passed || result.diffPercent <= _tolerance) {
      result.dispose();
      return true;
    }
    final error = await generateFailureOutput(result, golden, basedir);
    result.dispose();
    throw FlutterError(error);
  }
}

Future<void> _capture(WidgetTester tester, String? uid, _Variant v, List<String> problems) async {
  tester.view.physicalSize = v.size;
  tester.view.devicePixelRatio = 1.0;
  tester.platformDispatcher.textScaleFactorTestValue = v.textScale;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
    tester.platformDispatcher.clearTextScaleFactorTestValue();
  });

  SharedPreferences.setMockInitialValues({'onboardingSeen': uid != null, 'languageChosen': true, 'locale': v.locale});
  final prefs = await SharedPreferences.getInstance();
  final db = FakeFirebaseFirestore();
  await tester.runAsync(() => DemoStore.loadInto(db, DemoSeed.build(DateTime.now())));
  final auth = DemoAuthService(db, prefs);
  if (uid != null) await tester.runAsync(() => auth.signInAsDemo(uid));
  final container = ProviderContainer(overrides: [
    appConfigProvider.overrideWithValue(const AppConfig(mode: AppMode.demo, backend: Backend.standalone, emulatorHost: 'localhost', firebaseProjectId: 'demo-pawsetu')),
    prefsProvider.overrideWithValue(prefs),
    firestoreProvider.overrideWithValue(db),
    authServiceProvider.overrideWithValue(auth),
    notificationServiceProvider.overrideWithValue(_NoNotifications()),
  ]);

  final original = FlutterError.onError;
  var where = 'start';
  FlutterError.onError = (d) {
    if (_sandboxNoise(d)) return;
    final msg = '[${v.name}] $where: ${d.exceptionAsString().split('\n').first}';
    if (!problems.contains(msg)) problems.add(msg);
  };
  try {
    await tester.pumpWidget(UncontrolledProviderScope(container: container, child: const PawSetuApp()));
    for (var i = 0; i < 7; i++) {
      await tester.pump(const Duration(milliseconds: 250));
    }
    // The profile's own settings apply on sign-in; set ours after.
    final settings = container.read(settingsProvider.notifier)
      ..setLocale(v.locale)
      ..setEasyMode(false)
      ..setThemeMode(v.theme)
      ..setHighContrast(v.highContrast);
    settings.setTextScale(1.0);
    final router = container.read(routerProvider);
    for (final MapEntry(key: name, value: route) in _screens[uid]!.entries) {
      where = route;
      router.go(route);
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 200));
      }
      await expectLater(find.byType(PawSetuApp), matchesGoldenFile('baseline/${name}_${v.name}.png'));
    }
    where = 'end';
    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
    await tester.pump(const Duration(minutes: 2));
  } finally {
    FlutterError.onError = original;
  }
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initializeDateFormatting();
    await _loadFonts();
    final basedir = (goldenFileComparator as LocalFileComparator).basedir;
    goldenFileComparator = _TolerantComparator(basedir.resolve('baseline_golden_test.dart'));
  });

  final problems = <String>[];
  for (final v in _variants) {
    for (final uid in _screens.keys) {
      testWidgets('baseline ${uid ?? 'signed out'} ${v.name}', (t) => _capture(t, uid, v, problems), timeout: const Timeout(Duration(minutes: 10)));
    }
  }

  tearDownAll(() {
    if (problems.isNotEmpty) {
      // ignore: avoid_print
      print('PROBLEMS WHILE CAPTURING (${problems.length}):\n${problems.join('\n')}');
    }
  });
}
