import 'package:books_bart/domain/repositories/user_repository.dart';
import 'package:flutter/material.dart';

class ProfileState {
  String nickname;
  String email;
  String phoneNumber;
  String imageURL;
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
  final UserRepository _userRepository = UserRepository();

  ProfileViewModel(this.context) {
    _init();
  }

  ProfileState get state => _state;

  Future<void> _init() async {
    await _updateState();
  }

  Future<void> _updateState() async {
    final user = await _userRepository.getCurrentUserData();
    if (user.name != null) _state.nickname = user.name!;
    _state.email = user.email;
    if (user.phoneNumber != null) _state.phoneNumber = user.phoneNumber!;
    if (user.urlPhoto != null) _state.imageURL = user.urlPhoto!;
    notifyListeners();
  }

  void onPopUp() {
    Navigator.of(context).pop();
  }

  void onEdit() {

  }
}
