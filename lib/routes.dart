import 'package:first_demo/pages/animal_image/page.dart';
import 'package:first_demo/pages/counter/page.dart';
import 'package:first_demo/pages/moments/page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/router_report.dart';

abstract class Routes {
  static const COUNTER = '/counter';
  static const ANIMAL_IMAGE = '/animal_image';
  static const MOMENTS = '/moments';
}

abstract class AppPages {
  static final pages = [
    GetPage(
      name: Routes.COUNTER,
      page: () => CounterPage(),
    ),
    GetPage(
      name: Routes.ANIMAL_IMAGE,
      page: () => AnimalImagePage(),
    ),
    GetPage(
      name: Routes.MOMENTS,
      page: () => MomentsPage(),
    ),
  ];
}

/// Let GetX perceive native routes manually
class GetXRouterObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    RouterReportManager.reportCurrentRoute(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) async {
    RouterReportManager.reportRouteDispose(route);
  }
}
