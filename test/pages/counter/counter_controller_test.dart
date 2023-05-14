import 'package:first_demo/pages/counter/counter_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CounterController controller;

  setUp(() {
    controller = CounterController();
  });

  test('value should start at 0', () {
    expect(controller.count(), 0);
  });

  test('value should be incremented', () {
    controller.increment();

    expect(controller.count(), 1);
  });

  test('value should be decremented', () {
    controller.decrement();

    expect(controller.count(), -1);
  });
}
