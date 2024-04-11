import 'package:books_bart/domain/api_client/api_client.dart';
import 'package:books_bart/domain/repositories/auth_repository.dart';
import 'package:books_bart/ui/navigation/main_navigation.dart';
import 'package:flutter/material.dart';

class LoginState {
  String email;
  String password;
  String? errorMassage;

  LoginState({
    required this.email,
    required this.password,
  });
}

class LoginViewModel extends ChangeNotifier {
  final BuildContext context;
  final LoginState _state = LoginState(email: '', password: '');
  final AuthRepository _authRepository = AuthRepository();
  final MainNavigation _mainNavigation = MainNavigation();

  LoginViewModel(this.context);

  LoginState get state => _state;

  void onPressedLogin() async {
    try {
      _state.errorMassage = null;
      notifyListeners();
      await _authRepository.login(_state.email, _state.password);
      if (!context.mounted) return;
      _mainNavigation.goToMainScreen(context);
    } on ApiClientException catch(e) {
      _state.errorMassage = e.massage;
      notifyListeners();
    }
  }

  void onChangeEmail(String value) {
    _state.email = value;
  }

  void onChangePassword(String value) {
    _state.password = value;
  }
}
