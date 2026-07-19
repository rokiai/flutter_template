import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/main/ui/main_screen.dart';
import '../features/onboarding/ui/splash_screen.dart';
import '../features/profile/ui/appearances_screen.dart';
import '../features/profile/ui/languages_screen.dart';
import 'slide_transition.dart';

part 'app_router.g.dart';

@TypedGoRoute<SplashRoute>(path: '/')
class SplashRoute extends GoRouteData with $SplashRoute {
  const SplashRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      state.slidePage(const SplashScreen());
}

@TypedGoRoute<MainRoute>(path: '/main')
class MainRoute extends GoRouteData with $MainRoute {
  const MainRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      state.slidePage(const MainScreen());
}

@TypedGoRoute<AppearancesRoute>(path: '/appearances')
class AppearancesRoute extends GoRouteData with $AppearancesRoute {
  const AppearancesRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      state.slidePage(const AppearancesScreen());
}

@TypedGoRoute<LanguagesRoute>(path: '/languages')
class LanguagesRoute extends GoRouteData with $LanguagesRoute {
  const LanguagesRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      state.slidePage(const LanguagesScreen());
}

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: const SplashRoute().location,
  routes: $appRoutes,
);
