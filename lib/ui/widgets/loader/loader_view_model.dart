import 'package:books_bart/domain/api_client/api_client.dart';
import 'package:books_bart/domain/repositories/auth_repository.dart';
import 'package:books_bart/ui/navigation/main_navigation.dart';
import 'package:flutter/material.dart';

class LoaderViewModel {
  final BuildContext context;
  final AuthRepository _authRepository = AuthRepository();
  final ApiClient _apiClient = ApiClient.instance;
  final MainNavigation _mainNavigation = MainNavigation();

  LoaderViewModel(this.context) {
    _init();
  }

  Future<void> _init() async {
    await _initFirebase();
    final isAuth = await _checkAuth();
    _goToFirstScreen(isAuth);
  }

  Future<void> _initFirebase() async {
    await _apiClient.init();
  }

  Future<bool> _checkAuth() async {
    return await _authRepository.isAuth();
  }

  void _goToFirstScreen(bool isAuth) {
    _mainNavigation.goToFirstScreen(context, isAuth);
  }
}
