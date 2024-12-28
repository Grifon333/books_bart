import 'package:authentication_repository/authentication_repository.dart';
import 'package:books_bart/domain/repositories/book_repository.dart';
import 'package:books_bart/ui/navigation/main_navigation.dart';
import 'package:books_bart/ui/widgets/book_details/book_details_view_model.dart';
import 'package:books_bart/ui/widgets/book_details/book_details_widget.dart';
import 'package:books_bart/ui/widgets/book_handling/book_handling_view_model.dart';
import 'package:books_bart/ui/widgets/book_handling/book_handling_widget.dart';
import 'package:books_bart/ui/widgets/book_handling/form_book_info_view_model.dart';
import 'package:books_bart/ui/widgets/book_handling/form_book_info_widget.dart';
import 'package:books_bart/ui/widgets/bottom_navigation_bar/bottom_navigation_bar_view_model.dart';
import 'package:books_bart/ui/widgets/bottom_navigation_bar/bottom_navigation_bar_widget.dart';
import 'package:books_bart/ui/widgets/cart/cart_view_model.dart';
import 'package:books_bart/ui/widgets/cart/cart_widget.dart';
import 'package:books_bart/ui/widgets/favorite_books/favorite_books_view_model.dart';
import 'package:books_bart/ui/widgets/favorite_books/favorite_books_widget.dart';
import 'package:books_bart/ui/widgets/history/history_view_model.dart';
import 'package:books_bart/ui/widgets/history/history_widget.dart';
import 'package:books_bart/ui/widgets/home/home_view_model.dart';
import 'package:books_bart/ui/widgets/home/home_widget.dart';
import 'package:books_bart/ui/widgets/order/order_view_model.dart';
import 'package:books_bart/ui/widgets/order/order_widget.dart';
import 'package:books_bart/ui/widgets/profile/profile_view_model.dart';
import 'package:books_bart/ui/widgets/profile/profile_widget.dart';
import 'package:books_bart/ui/widgets/settings/settings_view_model.dart';
import 'package:books_bart/ui/widgets/settings/settings_widget.dart';
import 'package:books_bart/ui/widgets/sidebar/side_bar_view_model.dart';
import 'package:books_bart/ui/widgets/sidebar/side_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:order_repository/order_repository.dart';
import 'package:provider/provider.dart';

class ScreenFactory {
  final MainNavigation _mainNavigation = MainNavigation();
  final BookRepository _bookRepository = BookRepository();

  Widget makeHome() {
    return ChangeNotifierProvider(
      create: (context) => HomeViewModel(
        context,
        bookRepository: _bookRepository,
      ),
      child: const HomeWidget(),
    );
  }

  Widget makeFavoriteBooks() {
    return ChangeNotifierProvider(
      create: (context) => FavoriteBooksViewModel(
        context,
        bookRepository: _bookRepository,
        authenticationRepository: context.read<AuthenticationRepository>(),
        screenFactory: this,
      ),
      child: const FavoriteBooksWidget(),
    );
  }

  Widget makeSettings() {
    return ChangeNotifierProvider(
      create: (context) => SettingsViewModel(context),
      child: const SettingsWidget(),
    );
  }

  Widget makeBookDetails(String bookId) {
    return ChangeNotifierProvider(
      create: (context) => BookDetailsViewModel(
        context,
        bookId,
        bookRepository: _bookRepository,
        orderRepository: context.read<OrderRepository>(),
        authenticationRepository: context.read<AuthenticationRepository>(),
      ),
      child: const BookDetailsWidget(),
    );
  }

  Widget makeBottomNavigationBar() {
    return ChangeNotifierProvider(
      lazy: false,
      create: (context) => BottomNavigationBarViewModel(context,
          authenticationRepository: context.read<AuthenticationRepository>(),
          screenFactory: this),
      child: const BottomNavigationBarWidget(),
    );
  }

  Widget makeSideBar() {
    return ChangeNotifierProvider(
      create: (context) => SideBarViewModel(context, screenFactory: this),
      child: const SideBarWidget(),
    );
  }

  Widget makeCart() {
    return ChangeNotifierProvider(
      create: (context) => CartViewModel(
        context,
        orderRepository: context.read<OrderRepository>(),
        bookRepository: _bookRepository,
        screenFactory: this,
      ),
      child: const CartWidget(),
    );
  }

  Widget makeOrder() {
    return ChangeNotifierProvider(
      create: (context) => OrderViewModel(
        context,
        orderRepository: context.read<OrderRepository>(),
        bookRepository: _bookRepository,
      ),
      child: const OrderWidget(),
    );
  }

  Widget makeProfile() {
    return ChangeNotifierProvider(
      create: (context) => ProfileViewModel(
        context,
        authenticationRepository: context.read<AuthenticationRepository>(),
      ),
      child: const ProfileWidget(),
    );
  }

  Widget makeBookHandling() {
    return ChangeNotifierProvider(
      create: (context) => BookHandlingViewModel(
        context,
        mainNavigation: _mainNavigation,
        bookRepository: _bookRepository,
      ),
      child: const BookHandlingWidget(),
    );
  }

  Widget makeAddFormBookInfo() {
    return ChangeNotifierProvider(
      create: (context) => FormBookInfoViewModel(
        context,
        FormType.add,
        bookRepository: _bookRepository,
      ),
      child: FormBookInfoWidget.add(),
    );
  }

  Widget makeEditFormBookInfo(String bookId) {
    return ChangeNotifierProvider(
      create: (context) => FormBookInfoViewModel(
        context,
        FormType.edit,
        bookId: bookId,
        bookRepository: _bookRepository,
      ),
      child: FormBookInfoWidget.edit(),
    );
  }

  Widget makeHistory() {
    return ChangeNotifierProvider(
      create: (context) => HistoryViewModel(
        context,
        orderRepository: context.read<OrderRepository>(),
        bookRepository: _bookRepository,
        authenticationRepository: context.read<AuthenticationRepository>(),
      ),
      child: const HistoryWidget(),
    );
  }
}
