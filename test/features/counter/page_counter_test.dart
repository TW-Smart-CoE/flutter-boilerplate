import 'package:first_demo/features/counter/page_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_utils/test_util.dart';

void main() {
  testPage('Counter increments smoke test', (tester, buildPage) async {
    // given
    await tester.pumpWidget(buildPage(const CounterPage()));

    // then
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // when
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // then
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
