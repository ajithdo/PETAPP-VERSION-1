import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawsetu/core/l10n/gen/app_localizations.dart';
import 'package:pawsetu/core/theme/app_theme.dart';
import 'package:pawsetu/core/theme/tokens.dart';
import 'package:pawsetu/core/widgets/genda_band.dart';

/// UI Design 5's signature on Home (DESIGN.md "The Genda band"): the pet's
/// photo in a garland with one flower per task, the day's title and progress.
void main() {
  Future<void> pump(
    WidgetTester tester, {
    required int done,
    required int total,
    String locale = 'en',
    double width = 390,
    double textScale = 1,
    Brightness brightness = Brightness.light,
    bool reduceMotion = false,
  }) async {
    tester.view.physicalSize = Size(width, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(
      locale: Locale(locale),
      theme: AppTheme.build(brightness: brightness, locale: locale),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: MediaQuery(
        data: MediaQueryData(size: Size(width, 900), textScaler: TextScaler.linear(textScale), disableAnimations: reduceMotion),
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(Space.lg),
            child: GendaBand(petName: 'Bruno', dateLabel: 'Sunday, 8 November', photo: const SizedBox(), done: done, total: total),
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('shows the day, the progress and one label for screen readers', (tester) async {
    await pump(tester, done: 2, total: 4);
    expect(find.text("Bruno's day"), findsOneWidget);
    expect(find.text('2 of 4 done'), findsOneWidget);
    expect(find.bySemanticsLabel("Bruno's day. 2 of 4 done"), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('all done: the kind line replaces the count', (tester) async {
    await pump(tester, done: 4, total: 4);
    expect(find.text('All done for today. Good job with Bruno!'), findsOneWidget);
  });

  testWidgets('nothing planned: no progress bar, an invitation instead', (tester) async {
    await pump(tester, done: 0, total: 0);
    expect(find.text('Nothing planned today. Add a routine.'), findsOneWidget);
    expect(find.byType(FractionallySizedBox), findsNothing);
  });

  testWidgets('Telugu, 200% text, 360 px: stacks without overflowing', (tester) async {
    await pump(tester, done: 1, total: 12, locale: 'te', width: 360, textScale: 2);
    expect(tester.takeException(), isNull);
    expect(find.text('బ్రూనో రోజు'), findsNothing); // the name stays as given
    expect(find.text('Bruno రోజు'), findsOneWidget);
  });

  testWidgets('dark mode and reduce motion settle at once', (tester) async {
    await pump(tester, done: 3, total: 5, brightness: Brightness.dark, reduceMotion: true);
    expect(find.text('3 of 5 done'), findsOneWidget);
    expect(tester.hasRunningAnimations, isFalse);
  });
}
