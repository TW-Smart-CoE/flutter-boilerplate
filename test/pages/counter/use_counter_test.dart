import 'package:first_demo/pages/counter/use_counter.dart';
import 'package:flutter_hooks_test/flutter_hooks_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('useCounter', () {
    testWidgets('should start with 0', (tester) async {
      final result = await buildHook(() => useCounter());

      expect(result.current.num.value, 0);
    });

    testWidgets('should increment counter by 1', (tester) async {
      final result = await buildHook(() => useCounter());

      await act(() => result.current.incrementCounter());

      expect(result.current.num.value, 1);
    });

    testWidgets('should increment counter multiple times', (tester) async {
      final result = await buildHook(() => useCounter());

      await act(() => result.current.incrementCounter());
      await act(() => result.current.incrementCounter());
      await act(() => result.current.incrementCounter());

      expect(result.current.num.value, 3);
    });
  });
}
