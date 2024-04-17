import 'package:books_bart/domain/api_client/api_client.dart';
import 'package:books_bart/domain/repositories/auth_repository.dart';
import 'package:books_bart/ui/navigation/main_navigation.dart';
import 'package:flutter/material.dart';

class SignupState {
  String nickname;
  String email;
  String password;
  String? errorMassage;
  String? errorNicknameMassage;
  String? errorEmailMassage;
  String? errorPasswordMassage;
  bool isObscureText = true;
  bool isProgress = false;

  SignupState({
    required this.nickname,
    required this.email,
    required this.password,
  });
}

class SignupViewModel extends ChangeNotifier {
  final BuildContext context;
  final SignupState _state = SignupState(nickname: '', email: '', password: '');
  final MainNavigation _mainNavigation = MainNavigation();
  final AuthRepository _authRepository = AuthRepository();

  SignupViewModel(this.context);

  SignupState get state => _state;

  void onChangedNickname(String value) {
    _state.nickname = value;
    _state.errorNicknameMassage = value.isEmpty ? 'Fill in the field' : null;
    notifyListeners();
  }

  void onChangedEmail(String value) {
    _state.email = value;
    _state.errorEmailMassage = value.isEmpty ? 'Fill in the field' : null;
    notifyListeners();
  }

  void onChangedPassword(String value) {
    _state.password = value;
    _state.errorPasswordMassage = value.isEmpty ? 'Fill in the field' : null;
    notifyListeners();
  }

  void onChangeVisibilityPassword() {
    _state.isObscureText ^= true;
    notifyListeners();
  }

  Future<void> onSignup() async {
    if (_state.isProgress) return;
    _state.isProgress = true;
    _state.errorMassage = null;
    notifyListeners();
    try {
      if (!_checkFields()) {
        _state.isProgress = false;
        return;
      }
      await _authRepository.signup(
        _state.nickname,
        _state.email,
        _state.password,
      );
      _state.isProgress = false;
      _goToMainScreen();
    } on ApiClientFirebaseAuthException catch (e) {
      _state.errorMassage = e.massage;
      _state.isProgress = false;
      notifyListeners();
    }
  }

  Future<void> onSignupWithGoogle() async {
    if (_state.isProgress) return;
    _state.isProgress = true;
    _state.errorMassage = null;
    notifyListeners();
    try {
      await _authRepository.loginWithGoogle();
      _state.isProgress = false;
      _goToMainScreen();
    } on ApiClientFirebaseAuthException catch (e) {
      _state.errorMassage = e.massage;
      _state.isProgress = false;
      notifyListeners();
    }
  }

  void goToLoginScreen() {
    _mainNavigation.goToLoginScreen(context);
  }

  void _goToMainScreen() {
    _mainNavigation.goToMainScreen(context);
  }

  bool _checkFields() {
    final nicknameIsEmpty = _state.nickname.isEmpty;
    final emailIsEmpty = _state.email.isEmpty;
    final passwordIsEmpty = _state.password.isEmpty;
    _state.errorNicknameMassage = nicknameIsEmpty ? 'Fill in the field' : null;
    _state.errorEmailMassage = emailIsEmpty ? 'Fill in the field' : null;
    _state.errorPasswordMassage = passwordIsEmpty ? 'Fill in the field' : null;
    return !nicknameIsEmpty && !emailIsEmpty && !passwordIsEmpty;
  }
}
