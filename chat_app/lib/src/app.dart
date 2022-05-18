import 'package:chat_app/src/screens/authentication/login/login_screen.dart';
import 'package:chat_app/src/theme.dart';
import 'package:flutter/material.dart';

import '../service_locators.dart';
import 'controllers/navigation/navigation_service.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      restorationScopeId: 'app',
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      darkTheme: appTheme(),
      builder: (context, Widget? child) => child as Widget,
      navigatorKey: locator<NavigationService>().navigatorKey,
      onGenerateRoute: NavigationService.generateRoute,
      initialRoute: LoginScreen.route,
    );
  }
}
