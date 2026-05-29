import 'package:first_demo/pages/animal_image/page_animal_image.dart';
import 'package:first_demo/pages/auth/page_auth.dart';
import 'package:first_demo/pages/counter/page_counter.dart';
import 'package:first_demo/pages/moments/page_moments.dart';
import 'package:first_demo/states/state_auth.dart';
import 'package:go_router/go_router.dart';

abstract class Routes {
  static const INITIAL = MOMENTS;
  static const LOGIN = '/login';
  static const COUNTER = '/counter';
  static const ANIMAL_IMAGE = '/animal_image';
  static const MOMENTS = '/moments';
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
