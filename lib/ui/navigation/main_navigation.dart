import 'package:books_bart/domain/factories/screen_factory.dart';
import 'package:flutter/material.dart';

class MainNavigationNameRoute {
  static const loader = '/';
  static const home = '/home';
}

class MainNavigation {
  static final _screenFactory = ScreenFactory();
  final String initialRoute = MainNavigationNameRoute.loader;

  final Map<String, WidgetBuilder> routes = {
    MainNavigationNameRoute.loader: (_) => _screenFactory.makeLoader(),
    MainNavigationNameRoute.home: (_) => _screenFactory.makeHome(),
  };

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Error navigation'),
            ),
          ),
        );
    }
  }
}
