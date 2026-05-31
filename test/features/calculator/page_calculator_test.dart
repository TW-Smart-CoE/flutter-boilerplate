import 'package:first_demo/features/calculator/page_calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_utils/test_util.dart';

void _setupViewSize(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 1920);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  group('CalculatorPage - rendering', () {
    testPage('should render title', (tester, buildPage) async {
      _setupViewSize(tester);
      await tester.pumpWidget(buildPage(const CalculatorPage()));

      expect(find.text('Calculator'), findsOneWidget);
    });

    testPage('should render all digit buttons', (tester, buildPage) async {
      _setupViewSize(tester);
      await tester.pumpWidget(buildPage(const CalculatorPage()));

      // '0' appears as both display value and button label
      expect(find.text('0'), findsNWidgets(2));
      for (final digit in ['1', '2', '3', '4', '5', '6', '7', '8', '9']) {
        expect(find.text(digit), findsOneWidget);
      }
    });

    testPage('should render operator buttons', (tester, buildPage) async {
      _setupViewSize(tester);
      await tester.pumpWidget(buildPage(const CalculatorPage()));

      expect(find.text('+'), findsOneWidget);
      expect(find.text('-'), findsOneWidget);
      expect(find.text('×'), findsOneWidget);
      expect(find.text('÷'), findsOneWidget);
      expect(find.text('='), findsOneWidget);
    });

    testPage('should render function buttons', (tester, buildPage) async {
      _setupViewSize(tester);
      await tester.pumpWidget(buildPage(const CalculatorPage()));

      expect(find.text('C'), findsOneWidget);
      expect(find.text('⁺⁄₋'), findsOneWidget);
      expect(find.text('%'), findsOneWidget);
      expect(find.text('.'), findsOneWidget);
      expect(find.byIcon(Icons.backspace_outlined), findsOneWidget);
    });

    testPage('should display initial value of 0', (tester, buildPage) async {
      _setupViewSize(tester);
      await tester.pumpWidget(buildPage(const CalculatorPage()));

      // '0' in display + '0' button
      expect(find.text('0'), findsNWidgets(2));
    });
  });

  group('CalculatorPage - interactions', () {
    testPage('should display digit when tapped', (tester, buildPage) async {
      _setupViewSize(tester);
      await tester.pumpWidget(buildPage(const CalculatorPage()));

      await tester.tap(find.text('5'));
      await tester.pump();

      // '5' in display + '5' button
      expect(find.text('5'), findsNWidgets(2));
    });

    testPage(
      'should perform addition via button taps',
      (tester, buildPage) async {
        _setupViewSize(tester);
        await tester.pumpWidget(buildPage(const CalculatorPage()));

        await tester.tap(find.text('3'));
        await tester.pump();
        await tester.tap(find.text('+'));
        await tester.pump();
        await tester.tap(find.text('4'));
        await tester.pump();
        await tester.tap(find.text('='));
        await tester.pump();

        // '7' in display + '7' button
        expect(find.text('7'), findsNWidgets(2));
      },
    );

    testPage('should clear display when C is tapped', (tester, buildPage) async {
      _setupViewSize(tester);
      await tester.pumpWidget(buildPage(const CalculatorPage()));

      await tester.tap(find.text('5'));
      await tester.pump();
      await tester.tap(find.text('C'));
      await tester.pump();

      // '0' appears in display and also as the '0' button
      expect(find.text('0'), findsNWidgets(2));
    });

    testPage(
      'should show expression when operator tapped',
      (tester, buildPage) async {
        _setupViewSize(tester);
        await tester.pumpWidget(buildPage(const CalculatorPage()));

        await tester.tap(find.text('8'));
        await tester.pump();
        await tester.tap(find.text('×'));
        await tester.pump();

        expect(find.text('8×'), findsOneWidget);
      },
    );

    testPage(
      'should perform multiplication end to end',
      (tester, buildPage) async {
        _setupViewSize(tester);
        await tester.pumpWidget(buildPage(const CalculatorPage()));

        await tester.tap(find.text('6'));
        await tester.pump();
        await tester.tap(find.text('×'));
        await tester.pump();
        await tester.tap(find.text('7'));
        await tester.pump();
        await tester.tap(find.text('='));
        await tester.pump();

        expect(find.text('42'), findsOneWidget);
        expect(find.text('6×7'), findsOneWidget);
      },
    );

    testPage(
      'should delete last digit with backspace',
      (tester, buildPage) async {
        _setupViewSize(tester);
        await tester.pumpWidget(buildPage(const CalculatorPage()));

        await tester.tap(find.text('1'));
        await tester.pump();
        await tester.tap(find.text('2'));
        await tester.pump();
        await tester.tap(find.byIcon(Icons.backspace_outlined));
        await tester.pump();

        // '1' in display + '1' button
        expect(find.text('1'), findsNWidgets(2));
      },
    );
  });
}
