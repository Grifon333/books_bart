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
  bool isObscureText = true;
  bool isProgress = false;

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
    if (_state.isProgress) return;
    _state.isProgress = true;
    _state.errorMassage = null;
    notifyListeners();
    try {
      if (!_checkFields()) {
        _state.isProgress = false;
        return;
      }
      await _authRepository.login(_state.email, _state.password);
      _goToMainScreen();
    } on ApiClientFirebaseAuthException catch (e) {
      _state.errorMassage = e.massage;
      _state.isProgress = false;
      notifyListeners();
    }
  }

  Future<void> onPressedLoginWithGoogle() async {
    if (_state.isProgress) return;
    _state.isProgress = true;
    _state.errorMassage = null;
    notifyListeners();
    try {
      await _authRepository.loginWithGoogle();
      _goToMainScreen();
    } on ApiClientFirebaseAuthException catch(e) {
      _state.errorMassage = e.massage;
      _state.isProgress = false;
      notifyListeners();
    }
  }

  void onChangeVisibilityPassword() {
    _state.isObscureText ^= true;
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

  void goToSignupScreen() {
    _mainNavigation.goToSignupScreen(context);
  }

  void _goToMainScreen() {
    _mainNavigation.goToMainScreen(context);
  }
}
