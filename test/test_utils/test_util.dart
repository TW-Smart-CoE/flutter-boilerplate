import 'package:first_demo/res/string/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fquery/fquery.dart';
import 'package:fquery_core/fquery_core.dart';

typedef PageBuilder = Widget Function(Widget child);

/// A wrapper around [testWidgets] that automatically manages [QueryCache]
/// lifecycle. The [callback] receives a [WidgetTester] and a [PageBuilder]
/// to build the test widget tree with CacheProvider + MaterialApp.
///
/// Usage:
/// ```dart
/// testPage('should show title', (tester, buildPage) async {
///   await tester.pumpWidget(buildPage(MyPage()));
///   expect(find.text('Title'), findsOneWidget);
/// });
/// ```
void testPage(
  String description,
  Future<void> Function(WidgetTester tester, PageBuilder buildPage) callback,
) {
  testWidgets(description, (tester) async {
    final queryCache = QueryCache();

    Widget buildPage(Widget child) {
      return CacheProvider(
        cache: queryCache,
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: child,
        ),
      );
    }

    await callback(tester, buildPage);

    // Dispose the fquery widget tree and advance past GC timers
    // to avoid "A Timer is still pending" errors.
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(minutes: 6));
  });
}
