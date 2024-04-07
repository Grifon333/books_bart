import 'package:books_bart/domain/factories/screen_factory.dart';
import 'package:flutter/material.dart';

class MainNavigationNameRoute {
  static const loader = '/';
  static const home = '/home';
  static const signup = '/signup';
  static const login = '/login';
  static const favoriteBooks = '/favorite_books';
  static const settings = '/settings';
  static const bookDetails = '/home/book_details';
  static const bottomNavigationBar = '/bottom_navigation_bar';
}

class MainNavigation {
  static final _screenFactory = ScreenFactory();
  final String initialRoute = MainNavigationNameRoute.bottomNavigationBar;

  final Map<String, WidgetBuilder> routes = {
    MainNavigationNameRoute.loader: (_) => _screenFactory.makeLoader(),
    MainNavigationNameRoute.home: (_) => _screenFactory.makeHome(),
    MainNavigationNameRoute.signup: (_) => _screenFactory.makeSignup(),
    MainNavigationNameRoute.login: (_) => _screenFactory.makeLogin(),
    MainNavigationNameRoute.favoriteBooks: (_) =>
        _screenFactory.makeFavoriteBooks(),
    MainNavigationNameRoute.settings: (_) => _screenFactory.makeSettings(),
    MainNavigationNameRoute.bookDetails: (_) =>
        _screenFactory.makeBookDetails(),
    MainNavigationNameRoute.bottomNavigationBar: (_) =>
        _screenFactory.makeBottomNavigationBar(),
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
