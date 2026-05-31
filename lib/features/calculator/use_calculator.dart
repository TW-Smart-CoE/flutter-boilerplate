import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

enum _Operation { add, subtract, multiply, divide, none }

typedef CalculatorState = ({
  ValueNotifier<String> display,
  ValueNotifier<String> expression,
  void Function(String) onDigit,
  void Function() onDecimal,
  void Function() onAdd,
  void Function() onSubtract,
  void Function() onMultiply,
  void Function() onDivide,
  void Function() onEquals,
  void Function() onClear,
  void Function() onToggleSign,
  void Function() onPercent,
  void Function() onBackspace,
});

CalculatorState useCalculator() {
  final display = useState('0');
  final expression = useState('');
  final firstOperand = useState<double?>(null);
  final operation = useState(_Operation.none);
  final waitingForSecondOperand = useState(false);

  String formatNumber(double value) {
    if (value == value.truncateToDouble()) {
      return _addCommas(value.toInt().toString());
    }
    final parts = value.toString().split('.');
    return '${_addCommas(parts[0])}.${parts[1]}';
  }

  String getRawDisplay() {
    return display.value.replaceAll(',', '');
  }

  void onDigit(String digit) {
    if (waitingForSecondOperand.value) {
      display.value = digit;
      waitingForSecondOperand.value = false;
    } else {
      final raw = getRawDisplay();
      if (raw == '0') {
        display.value = digit;
      } else {
        final newRaw = raw + digit;
        if (newRaw.contains('.')) {
          final parts = newRaw.split('.');
          display.value = '${_addCommas(parts[0])}.${parts[1]}';
        } else {
          display.value = _addCommas(newRaw);
        }
      }
    }
  }

  void onDecimal() {
    if (waitingForSecondOperand.value) {
      display.value = '0.';
      waitingForSecondOperand.value = false;
      return;
    }
    final raw = getRawDisplay();
    if (!raw.contains('.')) {
      display.value = '${display.value}.';
    }
  }

  String operationSymbol(_Operation op) {
    switch (op) {
      case _Operation.add:
        return '+';
      case _Operation.subtract:
        return '-';
      case _Operation.multiply:
        return '×';
      case _Operation.divide:
        return '÷';
      case _Operation.none:
        return '';
    }
  }

  void performOperation(_Operation op) {
    final raw = getRawDisplay();
    final currentValue = double.tryParse(raw) ?? 0;

    if (firstOperand.value == null) {
      firstOperand.value = currentValue;
    } else if (!waitingForSecondOperand.value) {
      final result = _calculate(firstOperand.value!, currentValue, operation.value);
      firstOperand.value = result;
      display.value = formatNumber(result);
    }

    final formattedFirst = formatNumber(firstOperand.value!);
    expression.value = '$formattedFirst${operationSymbol(op)}';
    operation.value = op;
    waitingForSecondOperand.value = true;
  }

  void onAdd() => performOperation(_Operation.add);
  void onSubtract() => performOperation(_Operation.subtract);
  void onMultiply() => performOperation(_Operation.multiply);
  void onDivide() => performOperation(_Operation.divide);

  void onEquals() {
    if (firstOperand.value == null || operation.value == _Operation.none) return;

    final raw = getRawDisplay();
    final currentValue = double.tryParse(raw) ?? 0;
    final result = _calculate(firstOperand.value!, currentValue, operation.value);

    final formattedFirst = formatNumber(firstOperand.value!);
    final formattedSecond = formatNumber(currentValue);
    expression.value = '$formattedFirst${operationSymbol(operation.value)}$formattedSecond';

    display.value = formatNumber(result);
    firstOperand.value = null;
    operation.value = _Operation.none;
    waitingForSecondOperand.value = false;
  }

  void onClear() {
    display.value = '0';
    expression.value = '';
    firstOperand.value = null;
    operation.value = _Operation.none;
    waitingForSecondOperand.value = false;
  }

  void onToggleSign() {
    final raw = getRawDisplay();
    final value = double.tryParse(raw) ?? 0;
    if (value != 0) {
      final toggled = -value;
      display.value = formatNumber(toggled);
    }
  }

  void onPercent() {
    final raw = getRawDisplay();
    final value = double.tryParse(raw) ?? 0;
    final result = value / 100;
    display.value = formatNumber(result);
  }

  void onBackspace() {
    final raw = getRawDisplay();
    if (raw.length <= 1 || (raw.length == 2 && raw.startsWith('-'))) {
      display.value = '0';
    } else {
      final newRaw = raw.substring(0, raw.length - 1);
      if (newRaw.contains('.')) {
        final parts = newRaw.split('.');
        display.value = '${_addCommas(parts[0])}.${parts[1]}';
      } else {
        display.value = _addCommas(newRaw);
      }
    }
  }

  return (
    display: display,
    expression: expression,
    onDigit: onDigit,
    onDecimal: onDecimal,
    onAdd: onAdd,
    onSubtract: onSubtract,
    onMultiply: onMultiply,
    onDivide: onDivide,
    onEquals: onEquals,
    onClear: onClear,
    onToggleSign: onToggleSign,
    onPercent: onPercent,
    onBackspace: onBackspace,
  );
}

double _calculate(double a, double b, _Operation op) {
  switch (op) {
    case _Operation.add:
      return a + b;
    case _Operation.subtract:
      return a - b;
    case _Operation.multiply:
      return a * b;
    case _Operation.divide:
      return b != 0 ? a / b : 0;
    case _Operation.none:
      return b;
  }
}

String _addCommas(String number) {
  final isNegative = number.startsWith('-');
  final digits = isNegative ? number.substring(1) : number;
  final buffer = StringBuffer();
  final length = digits.length;
  for (var i = 0; i < length; i++) {
    if (i > 0 && (length - i) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(digits[i]);
  }
  return isNegative ? '-${buffer.toString()}' : buffer.toString();
}
