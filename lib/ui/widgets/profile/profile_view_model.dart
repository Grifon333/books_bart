import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';

class ErrorsMassage {
  static const String emptyField = 'Field is empty';
}

class ProfileState {
  String nickname;
  String email;
  String phoneNumber;
  String imageURL;
  bool isEdit = false;
  bool isChangePassword = false;
  String oldNickname = '';
  String oldPhoneNumber = '';
  String? nicknameError;
  String? phoneNumberError;
  String newPassword = '';
  String? newPasswordError;
  static const _anonymousPhotoURL =
      'https://e7.pngegg.com/pngimages/416/62/png-clipart-anonymous-person-login-google-account-computer-icons-user-activity-miscellaneous-computer.png';

  ProfileState({
    this.nickname = 'none',
    this.email = 'none',
    this.phoneNumber = 'none',
    this.imageURL = _anonymousPhotoURL,
  });
}

class ProfileViewModel extends ChangeNotifier {
  final BuildContext context;
  final ProfileState _state = ProfileState();
  final AuthenticationRepository _authenticationRepository;

  ProfileState get state => _state;

  ProfileViewModel(
    this.context, {
    required AuthenticationRepository authenticationRepository,
  }) : _authenticationRepository = authenticationRepository {
    _init();
  }

  Future<void> _init() async {
    await _updateState();
  }

  Future<void> _updateState() async {
    final user = _authenticationRepository.currentUser;
    if (user.name != null) _state.nickname = user.name!;
    _state.email = user.email;
    if (user.phoneNumber != null) _state.phoneNumber = user.phoneNumber!;
    if (user.photoUrl != null) _state.imageURL = user.photoUrl!;
    notifyListeners();
  }

  void onPopUp() => Navigator.of(context).pop();

  void onEdit() {
    _state.isEdit = true;
    _state.oldNickname = _state.nickname;
    _state.oldPhoneNumber = _state.phoneNumber;
    notifyListeners();
  }

  void onSave() async {
    _state.isEdit = false;
    if (_state.nicknameError == null && _state.phoneNumberError == null) {
      if (_state.oldNickname != _state.nickname) {
        await _authenticationRepository.updateDisplayName(_state.nickname);
      }
      if (_state.oldPhoneNumber != _state.phoneNumber) {
        await _authenticationRepository.updatePhoneNumber(_state.phoneNumber);
      }
    }
    notifyListeners();
  }

  void onChangedNickname(String value) {
    value = value.trim();
    _state.nickname = value;
    if (value.isEmpty) {
      _state.nicknameError = ErrorsMassage.emptyField;
    } else {
      _state.nicknameError = null;
    }
    notifyListeners();
  }

  void onChangedPhoneNumber(String value) {
    value = value.trim();
    _state.phoneNumber = value;
    if (value.isEmpty) {
      _state.phoneNumberError = ErrorsMassage.emptyField;
    } else {
      _state.nicknameError = null;
    }
    notifyListeners();
  }

  Future<void> onPressedChangePassword() async {
    _state.isChangePassword = true;
    notifyListeners();
  }

  Future<void> onPressedSubmitChangePassword() async {
    if (_state.newPasswordError != null) return;
    if (_state.newPassword.isEmpty) {
      _state.newPasswordError = ErrorsMassage.emptyField;
      notifyListeners();
      return;
    }
    _state.isChangePassword = false;
    await _changePassword();
    notifyListeners();
  }

  void onPressedCancelChangePassword() {
    _state.isChangePassword = false;
    notifyListeners();
  }

  void onChangedPassword(String value) {
    value = value.trim();
    _state.newPassword = value;
    if (value.isEmpty) {
      _state.newPasswordError = ErrorsMassage.emptyField;
    } else {
      _state.newPasswordError = null;
    }
    notifyListeners();
  }

  Future<void> _changePassword() async {
    try {
      await _authenticationRepository.updatePassword(_state.newPassword);
    } catch (e) {
      _state.newPasswordError = e.toString();
      notifyListeners();
    }
  }
}
