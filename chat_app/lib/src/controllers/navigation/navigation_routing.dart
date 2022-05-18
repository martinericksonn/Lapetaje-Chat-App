part of 'navigation_service.dart';

PageRoute getRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.route:
      return SlideUpRoute(page: LoginScreen(), settings: settings);
    case HomeScreen.route:
      return SlideDownRoute(page: const HomeScreen(), settings: settings);
    default:
      return FadeRoute(page: LoginScreen(), settings: settings);
  }
}
