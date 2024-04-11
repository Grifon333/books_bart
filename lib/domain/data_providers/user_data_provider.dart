import 'dart:convert';

import 'package:books_bart/domain/entity/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserDataProvider {
  static const _storage = FlutterSecureStorage();

  Future<void> setUserData(User user) async {
    final userEncode = jsonEncode(user);
    await _storage.write(key: 'user', value: userEncode);
  }

  Future<User?> getUserData() async {
    final userDataStr = await _storage.read(key: 'user');
    if (userDataStr != null) {
      final userJson = jsonDecode(userDataStr) as Map<String, dynamic>;
      return User.fromJson(userJson);
    }
    return null;
  }
}
