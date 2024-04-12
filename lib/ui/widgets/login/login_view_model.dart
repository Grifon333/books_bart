import 'package:books_bart/domain/api_client/api_client.dart';
import 'package:books_bart/domain/repositories/auth_repository.dart';
import 'package:books_bart/ui/navigation/main_navigation.dart';
import 'package:flutter/material.dart';

class LoginState {
  String email;
  String password;
  String? errorMassage;
  String? errorEmailMassage;
  String? errorPasswordMassage;
  bool isVisibilityPassword = false;

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

  Future<void> onPressedLogin() async {
    try {
      _state.errorMassage = null;
      notifyListeners();
      if (!_checkFields()) return;
      await _authRepository.login(_state.email, _state.password);
      _goToMainScreen();
    } on ApiClientException catch (e) {
      _state.errorMassage = e.massage;
      notifyListeners();
    }
  }

  Future<void> onPressedLoginWithGoogle() async {
    try {
      _state.errorMassage = null;
      notifyListeners();
      await _authRepository.loginWithGoogle();
      _goToMainScreen();
    } on ApiClientException catch(e) {
      _state.errorMassage = e.massage;
      notifyListeners();
    }
  }

  void onChangeVisibilityPassword() {
    _state.isVisibilityPassword ^= true;
    notifyListeners();
  }

  bool _checkFields() {
    final emailIsEmpty = _state.email.isEmpty;
    final passwordIsEmpty = _state.password.isEmpty;
    _state.errorEmailMassage = emailIsEmpty ? 'Fill in the field' : null;
    _state.errorPasswordMassage = passwordIsEmpty ? 'Fill in the field' : null;
    return !emailIsEmpty && !passwordIsEmpty;
  }

  void onChangeEmail(String value) {
    _state.email = value;
    _state.errorEmailMassage = value.isEmpty ? 'Fill in the field' : null;
    notifyListeners();
  }

  void onChangePassword(String value) {
    _state.password = value;
    _state.errorPasswordMassage = value.isEmpty ? 'Fill in the field' : null;
    notifyListeners();
  }

  void onTapSignup() {
    _mainNavigation.goToSignupScreen(context);
  }

  void _goToMainScreen() {
    _mainNavigation.goToMainScreen(context);
  }
}
