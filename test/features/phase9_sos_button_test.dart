import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawsetu/core/l10n/gen/app_localizations.dart';
import 'package:pawsetu/core/providers.dart';
import 'package:pawsetu/core/theme/app_theme.dart';
import 'package:pawsetu/core/widgets/sos_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The red SOS button (spec 7.12): hold for 2 seconds; a quick tap shows a
/// hint; in Easy mode a tap asks first.
void main() {
  Future<void> pump(WidgetTester tester, {required bool easy, required VoidCallback onActivate}) async {
    SharedPreferences.setMockInitialValues({'easyMode': easy});
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(ProviderScope(
      overrides: [prefsProvider.overrideWithValue(prefs)],
      child: MaterialApp(
        theme: AppTheme.build(brightness: Brightness.light, locale: 'en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: Center(child: SosButton(onActivate: onActivate))),
      ),
    ));
    await tester.pump();
  }

  testWidgets('holding for 2 seconds activates SOS', (tester) async {
    var activated = 0;
    await pump(tester, easy: false, onActivate: () => activated++);
    final g = await tester.startGesture(tester.getCenter(find.text('SOS')));
    // Pump frame by frame so the ring fills as it would on a phone.
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(activated, 0, reason: 'not yet after 1 second');
    for (var i = 0; i < 13; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(activated, 1);
    await g.up();
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('a quick tap only shows "Hold for 2 seconds to activate"', (tester) async {
    var activated = 0;
    await pump(tester, easy: false, onActivate: () => activated++);
    await tester.tap(find.text('SOS'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Hold for 2 seconds to activate'), findsOneWidget);
    expect(activated, 0);
    await tester.pump(const Duration(seconds: 3));
  });

  testWidgets('Easy mode: a tap asks first, then activates', (tester) async {
    var activated = 0;
    await pump(tester, easy: true, onActivate: () => activated++);
    await tester.tap(find.text('SOS'));
    await tester.pumpAndSettle();
    expect(find.text('Need emergency help?'), findsOneWidget);
    expect(activated, 0);
    await tester.tap(find.text('Get help now'));
    await tester.pumpAndSettle();
    expect(activated, 1);
  });
}
