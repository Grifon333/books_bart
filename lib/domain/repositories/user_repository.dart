import 'package:books_bart/domain/api_client/api_client.dart';
import 'package:books_bart/domain/data_providers/user_data_provider.dart';
import 'package:books_bart/domain/entity/user.dart';

class UserRepository {
  final UserDataProvider _userDataProvider = UserDataProvider();
  final ApiClient _apiClient = ApiClient.instance;

  Future<User> getCurrentUserData() async {
    User? userData = await _userDataProvider.getUserData();
    userData ??= User.anonymous();
    return userData;
  }

  Future<void> updateNickname(String nickname) async {
    await _apiClient.updateDisplayName(nickname);
    User user = await getCurrentUserData()
      ..name = nickname;
    _userDataProvider.setUserData(user);
  }

  Future<void> updatePhoneNumber(String phoneNumber) async {
    await _apiClient.updatePhoneNumber(phoneNumber);
    User user = await getCurrentUserData()
      ..phoneNumber = phoneNumber;
    _userDataProvider.setUserData(user);
  }

  Future<void> updatePassword(String password) async {
    await _apiClient.updatePassword(password);
  }

  Future<void> updatePhotoURL(String photoURL) async {
    await _apiClient.updatePhoto(photoURL);
    User user = await getCurrentUserData()
      ..urlPhoto = photoURL;
    _userDataProvider.setUserData(user);
  }

  Future<String> getRole() async {
    User userData = await _userDataProvider.getUserData() ?? User.anonymous();
    return userData.role;
  }
}
