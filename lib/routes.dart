import 'package:first_demo/common/states/auth_state.dart';
import 'package:first_demo/pages/animal_image/page.dart';
import 'package:first_demo/pages/auth/page.dart';
import 'package:first_demo/pages/counter/page.dart';
import 'package:first_demo/pages/moments/page.dart';
import 'package:go_router/go_router.dart';

abstract class Routes {
  static const LOGIN = '/login';
  static const COUNTER = '/counter';
  static const ANIMAL_IMAGE = '/animal_image';
  static const MOMENTS = '/moments';
  static const INITIAL = MOMENTS;
}

final GoRouter appRouter = GoRouter(
  initialLocation: Routes.INITIAL,
  refreshListenable: authState.isLoggedIn,
  redirect: (context, state) {
    final isLoggedIn = authState.isLoggedIn.value;
    final isOnLoginPage = state.matchedLocation == Routes.LOGIN;

    if (!isLoggedIn && !isOnLoginPage) {
      return Routes.LOGIN;
    }
    if (isLoggedIn && isOnLoginPage) {
      return Routes.INITIAL;
    }
    return null;
  },
  routes: [
    GoRoute(
      path: Routes.LOGIN,
      builder: (context, state) => AuthPage(),
    ),
    GoRoute(
      path: Routes.COUNTER,
      builder: (context, state) => const CounterPage(),
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
