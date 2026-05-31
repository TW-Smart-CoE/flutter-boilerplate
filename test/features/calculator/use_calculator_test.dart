import 'package:first_demo/features/calculator/use_calculator.dart';
import 'package:flutter_hooks_test/flutter_hooks_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('useCalculator - initial state', () {
    testWidgets('should display 0 with empty expression', (tester) async {
      final result = await buildHook(() => useCalculator());

      expect(result.current.display.value, '0');
      expect(result.current.expression.value, '');
    });
  });

  group('useCalculator - digit input', () {
    testWidgets('should replace initial 0 with digit', (tester) async {
      final result = await buildHook(() => useCalculator());

      await act(() => result.current.onDigit('5'));

      expect(result.current.display.value, '5');
    });

    testWidgets('should append digits', (tester) async {
      final result = await buildHook(() => useCalculator());

      await act(() => result.current.onDigit('1'));
      await act(() => result.current.onDigit('2'));
      await act(() => result.current.onDigit('3'));

      expect(result.current.display.value, '123');
    });

    testWidgets('should format large numbers with commas', (tester) async {
      final result = await buildHook(() => useCalculator());

      await act(() => result.current.onDigit('1'));
      await act(() => result.current.onDigit('2'));
      await act(() => result.current.onDigit('3'));
      await act(() => result.current.onDigit('4'));

      expect(result.current.display.value, '1,234');
    });

    testWidgets('should format seven-digit number with commas', (tester) async {
      final result = await buildHook(() => useCalculator());

      for (final d in ['1', '2', '3', '4', '5', '6', '7']) {
        await act(() => result.current.onDigit(d));
      }

      expect(result.current.display.value, '1,234,567');
    });

    testWidgets(
      'should start new number after selecting operator',
      (tester) async {
        final result = await buildHook(() => useCalculator());

        await act(() => result.current.onDigit('5'));
        await act(() => result.current.onAdd());
        await act(() => result.current.onDigit('3'));

        expect(result.current.display.value, '3');
      },
    );
  });

  group('useCalculator - decimal', () {
    testWidgets('should append decimal point', (tester) async {
      final result = await buildHook(() => useCalculator());

      await act(() => result.current.onDigit('3'));
      await act(() => result.current.onDecimal());

      expect(result.current.display.value, '3.');
    });

    testWidgets('should not add duplicate decimal point', (tester) async {
      final result = await buildHook(() => useCalculator());

      await act(() => result.current.onDigit('3'));
      await act(() => result.current.onDecimal());
      await act(() => result.current.onDecimal());

      expect(result.current.display.value, '3.');
    });

    testWidgets(
      'should start with 0. when decimal pressed after operator',
      (tester) async {
        final result = await buildHook(() => useCalculator());

        await act(() => result.current.onDigit('5'));
        await act(() => result.current.onAdd());
        await act(() => result.current.onDecimal());

        expect(result.current.display.value, '0.');
      },
    );

    testWidgets(
      'should preserve decimal digits with commas in integer part',
      (tester) async {
        final result = await buildHook(() => useCalculator());

        for (final d in ['1', '2', '3', '4']) {
          await act(() => result.current.onDigit(d));
        }
        await act(() => result.current.onDecimal());
        await act(() => result.current.onDigit('5'));

        expect(result.current.display.value, '1,234.5');
      },
    );
  });

  group('useCalculator - arithmetic operations', () {
    testWidgets('should add two numbers', (tester) async {
      final result = await buildHook(() => useCalculator());

      await act(() => result.current.onDigit('5'));
      await act(() => result.current.onAdd());
      await act(() => result.current.onDigit('3'));
      await act(() => result.current.onEquals());

      expect(result.current.display.value, '8');
    });

    testWidgets('should subtract two numbers', (tester) async {
      final result = await buildHook(() => useCalculator());

      await act(() => result.current.onDigit('9'));
      await act(() => result.current.onSubtract());
      await act(() => result.current.onDigit('4'));
      await act(() => result.current.onEquals());

      expect(result.current.display.value, '5');
    });

    testWidgets('should multiply two numbers', (tester) async {
      final result = await buildHook(() => useCalculator());

      await act(() => result.current.onDigit('6'));
      await act(() => result.current.onMultiply());
      await act(() => result.current.onDigit('7'));
      await act(() => result.current.onEquals());

      expect(result.current.display.value, '42');
    });

    testWidgets('should divide two numbers', (tester) async {
      final result = await buildHook(() => useCalculator());

      await act(() => result.current.onDigit('8'));
      await act(() => result.current.onDivide());
      await act(() => result.current.onDigit('4'));
      await act(() => result.current.onEquals());

      expect(result.current.display.value, '2');
    });

    testWidgets('should return 0 when dividing by zero', (tester) async {
      final result = await buildHook(() => useCalculator());

      await act(() => result.current.onDigit('5'));
      await act(() => result.current.onDivide());
      await act(() => result.current.onDigit('0'));
      await act(() => result.current.onEquals());

      expect(result.current.display.value, '0');
    });

    testWidgets('should handle decimal results', (tester) async {
      final result = await buildHook(() => useCalculator());

      await act(() => result.current.onDigit('7'));
      await act(() => result.current.onDivide());
      await act(() => result.current.onDigit('2'));
      await act(() => result.current.onEquals());

      expect(result.current.display.value, '3.5');
    });
  });

  group('useCalculator - chained operations', () {
    testWidgets(
      'should chain operations (3 + 4 + 5 =)',
      (tester) async {
        final result = await buildHook(() => useCalculator());

        await act(() => result.current.onDigit('3'));
        await act(() => result.current.onAdd());
        await act(() => result.current.onDigit('4'));
        await act(() => result.current.onAdd());

        // After pressing second +, intermediate result should show
        expect(result.current.display.value, '7');

        await act(() => result.current.onDigit('5'));
        await act(() => result.current.onEquals());

        expect(result.current.display.value, '12');
      },
    );

    testWidgets(
      'should switch operator without calculating (5 + - 3 =)',
      (tester) async {
        final result = await buildHook(() => useCalculator());

        await act(() => result.current.onDigit('5'));
        await act(() => result.current.onAdd());
        await act(() => result.current.onSubtract());
        await act(() => result.current.onDigit('3'));
        await act(() => result.current.onEquals());

        expect(result.current.display.value, '2');
      },
    );
  });

  group('useCalculator - expression display', () {
    testWidgets(
      'should show expression when operator pressed',
      (tester) async {
        final result = await buildHook(() => useCalculator());

        await act(() => result.current.onDigit('5'));
        await act(() => result.current.onAdd());

        expect(result.current.expression.value, '5+');
      },
    );

    testWidgets(
      'should show full expression after equals',
      (tester) async {
        final result = await buildHook(() => useCalculator());

        await act(() => result.current.onDigit('5'));
        await act(() => result.current.onAdd());
        await act(() => result.current.onDigit('3'));
        await act(() => result.current.onEquals());

        expect(result.current.expression.value, '5+3');
      },
    );

    testWidgets(
      'should show formatted numbers in expression',
      (tester) async {
        final result = await buildHook(() => useCalculator());

        // 1000 + 2000 =
        for (final d in ['1', '0', '0', '0']) {
          await act(() => result.current.onDigit(d));
        }
        await act(() => result.current.onAdd());
        for (final d in ['2', '0', '0', '0']) {
          await act(() => result.current.onDigit(d));
        }
        await act(() => result.current.onEquals());

        expect(result.current.expression.value, '1,000+2,000');
        expect(result.current.display.value, '3,000');
      },
    );
  });

  group('useCalculator - clear', () {
    testWidgets('should reset all state on clear', (tester) async {
      final result = await buildHook(() => useCalculator());

      await act(() => result.current.onDigit('5'));
      await act(() => result.current.onAdd());
      await act(() => result.current.onDigit('3'));
      await act(() => result.current.onClear());

      expect(result.current.display.value, '0');
      expect(result.current.expression.value, '');
    });
  });

  group('useCalculator - toggle sign', () {
    testWidgets('should negate a positive number', (tester) async {
      final result = await buildHook(() => useCalculator());

      await act(() => result.current.onDigit('5'));
      await act(() => result.current.onToggleSign());

      expect(result.current.display.value, '-5');
    });

    testWidgets('should negate back to positive', (tester) async {
      final result = await buildHook(() => useCalculator());

      await act(() => result.current.onDigit('5'));
      await act(() => result.current.onToggleSign());
      await act(() => result.current.onToggleSign());

      expect(result.current.display.value, '5');
    });

    testWidgets('should not toggle sign of zero', (tester) async {
      final result = await buildHook(() => useCalculator());

      await act(() => result.current.onToggleSign());

      expect(result.current.display.value, '0');
    });
  });

  group('useCalculator - percent', () {
    testWidgets('should divide by 100', (tester) async {
      final result = await buildHook(() => useCalculator());

      await act(() => result.current.onDigit('5'));
      await act(() => result.current.onDigit('0'));
      await act(() => result.current.onPercent());

      expect(result.current.display.value, '0.5');
    });

    testWidgets('should handle percent of zero', (tester) async {
      final result = await buildHook(() => useCalculator());

      await act(() => result.current.onPercent());

      expect(result.current.display.value, '0');
    });
  });

  group('useCalculator - backspace', () {
    testWidgets('should remove last digit', (tester) async {
      final result = await buildHook(() => useCalculator());

      await act(() => result.current.onDigit('1'));
      await act(() => result.current.onDigit('2'));
      await act(() => result.current.onDigit('3'));
      await act(() => result.current.onBackspace());

      expect(result.current.display.value, '12');
    });

    testWidgets('should reset to 0 on last digit', (tester) async {
      final result = await buildHook(() => useCalculator());

      await act(() => result.current.onDigit('5'));
      await act(() => result.current.onBackspace());

      expect(result.current.display.value, '0');
    });

    testWidgets(
      'should reset negative single digit to 0',
      (tester) async {
        final result = await buildHook(() => useCalculator());

        await act(() => result.current.onDigit('5'));
        await act(() => result.current.onToggleSign());
        await act(() => result.current.onBackspace());

        expect(result.current.display.value, '0');
      },
    );

    testWidgets(
      'should update commas after backspace',
      (tester) async {
        final result = await buildHook(() => useCalculator());

        // Enter 1234 => "1,234"
        for (final d in ['1', '2', '3', '4']) {
          await act(() => result.current.onDigit(d));
        }
        expect(result.current.display.value, '1,234');

        await act(() => result.current.onBackspace());

        expect(result.current.display.value, '123');
      },
    );

    testWidgets(
      'should handle backspace with decimal',
      (tester) async {
        final result = await buildHook(() => useCalculator());

        await act(() => result.current.onDigit('3'));
        await act(() => result.current.onDecimal());
        await act(() => result.current.onDigit('1'));
        await act(() => result.current.onDigit('4'));
        await act(() => result.current.onBackspace());

        expect(result.current.display.value, '3.1');
      },
    );
  });

  group('useCalculator - equals edge cases', () {
    testWidgets(
      'should do nothing when pressing equals without operator',
      (tester) async {
        final result = await buildHook(() => useCalculator());

        await act(() => result.current.onDigit('5'));
        await act(() => result.current.onEquals());

        expect(result.current.display.value, '5');
        expect(result.current.expression.value, '');
      },
    );

    testWidgets(
      'should format result with commas',
      (tester) async {
        final result = await buildHook(() => useCalculator());

        // 999 + 1 = 1,000
        for (final d in ['9', '9', '9']) {
          await act(() => result.current.onDigit(d));
        }
        await act(() => result.current.onAdd());
        await act(() => result.current.onDigit('1'));
        await act(() => result.current.onEquals());

        expect(result.current.display.value, '1,000');
      },
    );
  });
}
