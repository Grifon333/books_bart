import 'package:books_bart/ui/widgets/book_details/book_details_view_model.dart';
import 'package:books_bart/ui/widgets/book_details/book_details_widget.dart';
import 'package:books_bart/ui/widgets/bottom_navigation_bar/bottom_navigation_bar_view_model.dart';
import 'package:books_bart/ui/widgets/bottom_navigation_bar/bottom_navigation_bar_widget.dart';
import 'package:books_bart/ui/widgets/favorite_books/favorite_books_view_model.dart';
import 'package:books_bart/ui/widgets/favorite_books/favorite_books_widget.dart';
import 'package:books_bart/ui/widgets/home/home_view_model.dart';
import 'package:books_bart/ui/widgets/home/home_widget.dart';
import 'package:books_bart/ui/widgets/loader/loader_view_model.dart';
import 'package:books_bart/ui/widgets/loader/loader_widget.dart';
import 'package:books_bart/ui/widgets/login/login_view_model.dart';
import 'package:books_bart/ui/widgets/login/login_widget.dart';
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

  Widget makeBookDetails() {
    return ChangeNotifierProvider(
      create: (context) => BookDetailsViewModel(context),
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
}
