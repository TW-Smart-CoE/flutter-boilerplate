import 'package:first_demo/pages/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtherPage extends GetView<HomeController> {
  const OtherPage({Key? key}) : super(key: key);

  @override
  Widget build(context) {
    // 访问更新后的计数变量
    return Scaffold(
      body: Center(
        child: Text("${controller.count}"),
      ),
    );
  }
}
