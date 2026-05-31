import 'package:first_demo/features/calculator/use_calculator.dart';
import 'package:first_demo/res/string/strings.dart';
import 'package:first_demo/res/theme/dimension.dart';
import 'package:first_demo/res/theme/shape.dart';
import 'package:first_demo/widgets/scaffold/base_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CalculatorPage extends HookWidget {
  const CalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final calculator = useCalculator();
    final colorScheme = Theme.of(context).colorScheme;

    return BaseScaffold(
      context: context,
      title: stringsOf(context).calculatorPageTitle,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: EdgeInset.S),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            _DisplayArea(
              expression: calculator.expression.value,
              display: calculator.display.value,
              colorScheme: colorScheme,
            ),
            const SizedBox(height: EdgeInset.L),
            _ButtonGrid(calculator: calculator, colorScheme: colorScheme),
            const SizedBox(height: EdgeInset.M),
          ],
        ),
      ),
    );
  }
}

// -- Display Area Widget --

class _DisplayArea extends StatelessWidget {
  final String expression;
  final String display;
  final ColorScheme colorScheme;

  const _DisplayArea({
    required this.expression,
    required this.display,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (expression.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: EdgeInset.XXS),
            child: Text(
              expression,
              style: TextStyle(
                fontSize: 24,
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerRight,
          child: Text(
            display,
            style: TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.w400,
              color: colorScheme.onSurface,
            ),
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}

// -- Button Grid Widget --

class _ButtonGrid extends StatelessWidget {
  final CalculatorState calculator;
  final ColorScheme colorScheme;

  const _ButtonGrid({required this.calculator, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    final functionBg = colorScheme.surfaceContainerHighest;
    final functionText = colorScheme.onSurface;
    final numberBg = colorScheme.surface;
    final numberText = colorScheme.onSurface;
    final operatorBg = colorScheme.primary;
    final operatorText = colorScheme.onPrimary;

    return Column(
      children: [
        _buildRow([
          _CalcButton(
            label: 'C',
            bgColor: functionBg,
            textColor: functionText,
            onTap: calculator.onClear,
          ),
          _CalcButton(
            label: '⁺⁄₋',
            bgColor: functionBg,
            textColor: functionText,
            onTap: calculator.onToggleSign,
          ),
          _CalcButton(
            label: '%',
            bgColor: functionBg,
            textColor: functionText,
            onTap: calculator.onPercent,
          ),
          _CalcButton(
            label: '÷',
            bgColor: operatorBg,
            textColor: operatorText,
            onTap: calculator.onDivide,
          ),
        ]),
        const SizedBox(height: EdgeInset.XS),
        _buildRow([
          _CalcButton(
            label: '7',
            bgColor: numberBg,
            textColor: numberText,
            elevation: 2,
            onTap: () => calculator.onDigit('7'),
          ),
          _CalcButton(
            label: '8',
            bgColor: numberBg,
            textColor: numberText,
            elevation: 2,
            onTap: () => calculator.onDigit('8'),
          ),
          _CalcButton(
            label: '9',
            bgColor: numberBg,
            textColor: numberText,
            elevation: 2,
            onTap: () => calculator.onDigit('9'),
          ),
          _CalcButton(
            label: '×',
            bgColor: operatorBg,
            textColor: operatorText,
            onTap: calculator.onMultiply,
          ),
        ]),
        const SizedBox(height: EdgeInset.XS),
        _buildRow([
          _CalcButton(
            label: '4',
            bgColor: numberBg,
            textColor: numberText,
            elevation: 2,
            onTap: () => calculator.onDigit('4'),
          ),
          _CalcButton(
            label: '5',
            bgColor: numberBg,
            textColor: numberText,
            elevation: 2,
            onTap: () => calculator.onDigit('5'),
          ),
          _CalcButton(
            label: '6',
            bgColor: numberBg,
            textColor: numberText,
            elevation: 2,
            onTap: () => calculator.onDigit('6'),
          ),
          _CalcButton(
            label: '-',
            bgColor: operatorBg,
            textColor: operatorText,
            onTap: calculator.onSubtract,
          ),
        ]),
        const SizedBox(height: EdgeInset.XS),
        _buildRow([
          _CalcButton(
            label: '1',
            bgColor: numberBg,
            textColor: numberText,
            elevation: 2,
            onTap: () => calculator.onDigit('1'),
          ),
          _CalcButton(
            label: '2',
            bgColor: numberBg,
            textColor: numberText,
            elevation: 2,
            onTap: () => calculator.onDigit('2'),
          ),
          _CalcButton(
            label: '3',
            bgColor: numberBg,
            textColor: numberText,
            elevation: 2,
            onTap: () => calculator.onDigit('3'),
          ),
          _CalcButton(
            label: '+',
            bgColor: operatorBg,
            textColor: operatorText,
            onTap: calculator.onAdd,
          ),
        ]),
        const SizedBox(height: EdgeInset.XS),
        _buildRow([
          _CalcButton(
            label: '.',
            bgColor: numberBg,
            textColor: numberText,
            elevation: 2,
            onTap: calculator.onDecimal,
          ),
          _CalcButton(
            label: '0',
            bgColor: numberBg,
            textColor: numberText,
            elevation: 2,
            onTap: () => calculator.onDigit('0'),
          ),
          _CalcButton(
            icon: Icons.backspace_outlined,
            bgColor: numberBg,
            textColor: numberText,
            elevation: 2,
            onTap: calculator.onBackspace,
          ),
          _CalcButton(
            label: '=',
            bgColor: operatorBg,
            textColor: operatorText,
            onTap: calculator.onEquals,
          ),
        ]),
      ],
    );
  }

  Widget _buildRow(List<Widget> buttons) {
    return Row(
      children: buttons
          .map(
            (btn) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: EdgeInset.Smallest,
                ),
                child: btn,
              ),
            ),
          )
          .toList(),
    );
  }
}

// -- Calculator Button Widget --

class _CalcButton extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final Color bgColor;
  final Color textColor;
  final VoidCallback onTap;
  final double elevation;

  const _CalcButton({
    this.label,
    this.icon,
    required this.bgColor,
    required this.textColor,
    required this.onTap,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Material(
        color: bgColor,
        borderRadius: BorderRadius.circular(CornerRadius.M),
        elevation: elevation,
        child: InkWell(
          borderRadius: BorderRadius.circular(CornerRadius.M),
          onTap: onTap,
          child: Center(
            child: icon != null
                ? Icon(icon, color: textColor, size: 28)
                : Text(
                    label ?? '',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
