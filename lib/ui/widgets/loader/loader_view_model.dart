import 'package:books_bart/domain/repositories/auth_repository.dart';
import 'package:books_bart/ui/navigation/main_navigation.dart';
import 'package:flutter/material.dart';

class LoaderViewModel {
  final BuildContext context;
  final AuthRepository _authRepository = AuthRepository();

  LoaderViewModel(this.context) {
    init();
  }

  Future<void> init() async {
    await _checkAuth();
  }

  Future<void> _checkAuth() async {
    final isAuth = await _authRepository.isAuth();
    final route =
    isAuth ? MainNavigationNameRoute.login : MainNavigationNameRoute.signup;
    if (!context.mounted) return;
    Navigator.of(context).pushReplacementNamed(route);
  }
}
