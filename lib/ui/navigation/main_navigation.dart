import 'package:books_bart/domain/factories/screen_factory.dart';
import 'package:flutter/material.dart';

class MainNavigationNameRoute {
  static const home = '/home';
  static const favoriteBooks = '/favorite_books';
  static const settings = '/settings';
  static const bookDetails = '/home/book_details';
  static const bottomNavigationBar = '/bottom_navigation_bar';
  static const sideBar = '/home/side_bar';
  static const cart = '/cart';
  static const order = '/cart/order';
  static const profile = '/profile';
  static const bookHandling = '/book_handling';
  static const history = '/history';
}

class MainNavigation {
  static final _screenFactory = ScreenFactory();

  final Map<String, WidgetBuilder> routes = {
    MainNavigationNameRoute.home: (_) => _screenFactory.makeHome(),
    MainNavigationNameRoute.favoriteBooks: (_) =>
        _screenFactory.makeFavoriteBooks(),
    MainNavigationNameRoute.settings: (_) => _screenFactory.makeSettings(),
    MainNavigationNameRoute.bottomNavigationBar: (_) =>
        _screenFactory.makeBottomNavigationBar(),
    MainNavigationNameRoute.sideBar: (_) => _screenFactory.makeSideBar(),
    MainNavigationNameRoute.cart: (_) => _screenFactory.makeCart(),
    MainNavigationNameRoute.order: (_) => _screenFactory.makeOrder(),
    MainNavigationNameRoute.profile: (_) => _screenFactory.makeProfile(),
    MainNavigationNameRoute.bookHandling: (_) =>
        _screenFactory.makeBookHandling(),
    MainNavigationNameRoute.history: (_) => _screenFactory.makeHistory(),
  };

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigationNameRoute.bookDetails:
        final bookId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => _screenFactory.makeBookDetails(bookId),
        );
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

  void showAddFormBookInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _screenFactory.makeAddFormBookInfo(),
    );
  }

  void showEditFormBookInfo(BuildContext context, String bookId) {
    showDialog(
      context: context,
      builder: (context) => _screenFactory.makeEditFormBookInfo(bookId),
    );
  }
}
