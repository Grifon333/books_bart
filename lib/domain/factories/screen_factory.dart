import 'package:books_bart/ui/widgets/favorite_books/favorite_books_view_model.dart';
import 'package:books_bart/ui/widgets/favorite_books/favorite_books_widget.dart';
import 'package:books_bart/ui/widgets/home/home_view_model.dart';
import 'package:books_bart/ui/widgets/home/home_widget.dart';
import 'package:books_bart/ui/widgets/loader/loader_view_model.dart';
import 'package:books_bart/ui/widgets/loader/loader_widget.dart';
import 'package:books_bart/ui/widgets/login/login_view_model.dart';
import 'package:books_bart/ui/widgets/login/login_widget.dart';
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
}
