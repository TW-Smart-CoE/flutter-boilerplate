import 'package:first_demo/pages/animal_image/page.dart';
import 'package:first_demo/pages/counter/page.dart';
import 'package:first_demo/pages/moments/page.dart';
import 'package:go_router/go_router.dart';

abstract class Routes {
  static const COUNTER = '/counter';
  static const ANIMAL_IMAGE = '/animal_image';
  static const MOMENTS = '/moments';
}

final GoRouter appRouter = GoRouter(
  initialLocation: Routes.MOMENTS,
  routes: [
    GoRoute(
      path: Routes.COUNTER,
      builder: (context, state) => CounterPage(),
    ),
    GoRoute(
      path: Routes.ANIMAL_IMAGE,
      builder: (context, state) => AnimalImagePage(),
    ),
    GoRoute(
      path: Routes.MOMENTS,
      builder: (context, state) => MomentsPage(),
    ),
  ],
);
