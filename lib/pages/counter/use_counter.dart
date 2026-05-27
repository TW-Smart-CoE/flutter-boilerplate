import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

({ValueNotifier<int> num, void Function() incrementCounter}) useCounter() {
  final num = useState(0);

  void incrementCounter() {
    num.value++;
  }

  return (num: num, incrementCounter: incrementCounter);
}
