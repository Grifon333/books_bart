import 'package:books_bart/domain/api_client/api_client.dart';
import 'package:books_bart/domain/repositories/auth_repository.dart';
import 'package:books_bart/ui/navigation/main_navigation.dart';
import 'package:flutter/material.dart';

class LoaderViewModel {
  final BuildContext context;
  final AuthRepository _authRepository = AuthRepository();
  final ApiClient _apiClient = ApiClient.instance;

  LoaderViewModel(this.context) {
    init();
  }

  Future<void> init() async {
    await initFirebase();
    await _checkAuth();
  }

  Future<void> initFirebase() async {
    await _apiClient.init();
  }

  Future<void> _checkAuth() async {
    final isAuth = await _authRepository.isAuth();
    final route = isAuth
        ? MainNavigationNameRoute.bottomNavigationBar
        : MainNavigationNameRoute.login;
    if (!context.mounted) return;
    Navigator.of(context).pushReplacementNamed(route);
  }
}
