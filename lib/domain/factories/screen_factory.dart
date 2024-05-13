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
  Widget makeLoader() {
    return Provider(
      create: (context) => LoaderViewModel(context),
      lazy: false,
      child: const LoaderWidget(),
    );
  }

  Widget makeHome() {
    return ChangeNotifierProvider(
      create: (context) => HomeViewModel(context),
      child: const HomeWidget(),
    );
  }

  Widget makeSignup() {
    return ChangeNotifierProvider(
      create: (context) => SignupViewModel(context),
      child: const SignUpWidget(),
    );
  }

  Widget makeLogin() {
    return ChangeNotifierProvider(
      create: (context) => LoginViewModel(context),
      child: const LoginWidget(),
    );
  }

  Widget makeFavoriteBooks() {
    return ChangeNotifierProvider(
      create: (context) => FavoriteBooksViewModel(context),
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
      create: (context) => BookDetailsViewModel(context, bookId),
      child: const BookDetailsWidget(),
    );
  }

  Widget makeBottomNavigationBar() {
    return ChangeNotifierProvider(
      create: (context) => BottomNavigationBarViewModel(context),
      child: const BottomNavigationBarWidget(),
    );
  }

  Widget makeSideBar() {
    return ChangeNotifierProvider(
      create: (context) => SideBarViewModel(context),
      child: const SideBarWidget(),
    );
  }

  Widget makeCart() {
    return ChangeNotifierProvider(
      create: (context) => CartViewModel(context),
      child: const CartWidget(),
    );
  }

  Widget makeOrder() {
    return ChangeNotifierProvider(
      create: (context) => OrderViewModel(context),
      child: const OrderWidget(),
    );
  }

  Widget makeProfile() {
    return ChangeNotifierProvider(
      create: (context) => ProfileViewModel(context),
      child: const ProfileWidget(),
    );
  }

  Widget makeBookHandling() {
    return ChangeNotifierProvider(
      create: (context) => BookHandlingViewModel(context),
      child: const BookHandlingWidget(),
    );
  }

  Widget makeAddFormBookInfo() {
    return ChangeNotifierProvider(
      create: (context) => FormBookInfoViewModel(context, FormType.add),
      child: FormBookInfoWidget.add(),
    );
  }

  Widget makeEditFormBookInfo(String bookId) {
    return ChangeNotifierProvider(
      create: (context) => FormBookInfoViewModel(
        context,
        FormType.edit,
        bookId: bookId,
      ),
      child: FormBookInfoWidget.edit(),
    );
  }
}
