import 'package:books_bart/domain/api_client/api_client.dart';
import 'package:books_bart/domain/repositories/auth_repository.dart';
import 'package:books_bart/domain/repositories/book_repository.dart';
import 'package:books_bart/domain/repositories/order_repository.dart';
import 'package:books_bart/domain/repositories/user_repository.dart';
import 'package:books_bart/ui/navigation/main_navigation.dart';
import 'package:books_bart/ui/widgets/book_details/book_details_view_model.dart';
import 'package:books_bart/ui/widgets/book_details/book_details_widget.dart';
import 'package:books_bart/ui/widgets/book_handling/form_book_info_view_model.dart';
import 'package:books_bart/ui/widgets/book_handling/form_book_info_widget.dart';
import 'package:books_bart/ui/widgets/book_handling/book_handling_view_model.dart';
import 'package:books_bart/ui/widgets/book_handling/book_handling_widget.dart';
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
import 'package:books_bart/ui/widgets/loader/loader_view_model.dart';
import 'package:books_bart/ui/widgets/loader/loader_widget.dart';
import 'package:books_bart/ui/widgets/login/login_view_model.dart';
import 'package:books_bart/ui/widgets/login/login_widget.dart';
import 'package:books_bart/ui/widgets/order/order_view_model.dart';
import 'package:books_bart/ui/widgets/order/order_widget.dart';
import 'package:books_bart/ui/widgets/profile/profile_view_model.dart';
import 'package:books_bart/ui/widgets/profile/profile_widget.dart';
import 'package:books_bart/ui/widgets/settings/settings_view_model.dart';
import 'package:books_bart/ui/widgets/settings/settings_widget.dart';
import 'package:books_bart/ui/widgets/sidebar/side_bar_view_model.dart';
import 'package:books_bart/ui/widgets/sidebar/side_bar_widget.dart';
import 'package:books_bart/ui/widgets/signup/signup_view_model.dart';
import 'package:books_bart/ui/widgets/signup/signup_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScreenFactory {
  final MainNavigation _mainNavigation = MainNavigation();
  final ApiClient _apiClient = ApiClient.instance;
  final AuthRepository _authRepository = AuthRepository();
  final BookRepository _bookRepository = BookRepository();
  final UserRepository _userRepository = UserRepository();
  final OrderRepository _orderRepository = OrderRepository();

  Widget makeLoader() {
    return Provider(
      create: (context) => LoaderViewModel(
        context,
        mainNavigation: _mainNavigation,
        apiClient: _apiClient,
        authRepository: _authRepository,
      ),
      lazy: false,
      child: const LoaderWidget(),
    );
  }

  Widget makeHome() {
    return ChangeNotifierProvider(
      create: (context) => HomeViewModel(
        context,
        mainNavigation: _mainNavigation,
        bookRepository: _bookRepository,
        userRepository: _userRepository,
      ),
      child: const HomeWidget(),
    );
  }

  Widget makeSignup() {
    return ChangeNotifierProvider(
      create: (context) => SignupViewModel(
        context,
        mainNavigation: _mainNavigation,
        authRepository: _authRepository,
      ),
      child: const SignUpWidget(),
    );
  }

  Widget makeLogin() {
    return ChangeNotifierProvider(
      create: (context) => LoginViewModel(
        context,
        mainNavigation: _mainNavigation,
        authRepository: _authRepository,
      ),
      child: const LoginWidget(),
    );
  }

  Widget makeFavoriteBooks() {
    return ChangeNotifierProvider(
      create: (context) => FavoriteBooksViewModel(
        context,
        mainNavigation: _mainNavigation,
        bookRepository: _bookRepository,
        userRepository: _userRepository,
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
        mainNavigation: _mainNavigation,
        bookRepository: _bookRepository,
        orderRepository: _orderRepository,
        userRepository: _userRepository,
      ),
      child: const BookDetailsWidget(),
    );
  }

  Widget makeBottomNavigationBar() {
    return ChangeNotifierProvider(
      lazy: false,
      create: (context) => BottomNavigationBarViewModel(
        context,
        userRepository: _userRepository,
      ),
      child: const BottomNavigationBarWidget(),
    );
  }

  Widget makeSideBar() {
    return ChangeNotifierProvider(
      create: (context) => SideBarViewModel(
        context,
        mainNavigation: _mainNavigation,
        userRepository: _userRepository,
        orderRepository: _orderRepository,
        authRepository: _authRepository,
      ),
      child: const SideBarWidget(),
    );
  }

  Widget makeCart() {
    return ChangeNotifierProvider(
      create: (context) => CartViewModel(
        context,
        mainNavigation: _mainNavigation,
        orderRepository: _orderRepository,
        bookRepository: _bookRepository,
      ),
      child: const CartWidget(),
    );
  }

  Widget makeOrder() {
    return ChangeNotifierProvider(
      create: (context) => OrderViewModel(
        context,
        mainNavigation: _mainNavigation,
        orderRepository: _orderRepository,
        bookRepository: _bookRepository,
      ),
      child: const OrderWidget(),
    );
  }

  Widget makeProfile() {
    return ChangeNotifierProvider(
      create: (context) => ProfileViewModel(
        context,
        mainNavigation: _mainNavigation,
        userRepository: _userRepository,
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
        orderRepository: _orderRepository,
        bookRepository: _bookRepository,
        userRepository: _userRepository,
      ),
      child: const HistoryWidget(),
    );
  }
}
