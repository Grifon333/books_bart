import 'package:books_bart/domain/api_client/api_client.dart';
import 'package:books_bart/domain/data_providers/user_data_provider.dart';
import 'package:books_bart/domain/entity/user.dart';
import 'package:flutter/material.dart';

class AuthRepository {
  final _userDataProvider = UserDataProvider();
  final _apiClient = ApiClient();

  Future<bool> isAuth() async {
    return await _userDataProvider.getUserData() != null;
  }

  Future<void> login(String email, String password) async {
    try {
      final userFromStorage = await _apiClient.signInWithEmailAndPassword(
        email,
        password,
      );
      if (userFromStorage != null) {
        final userData = User(
          uid: userFromStorage.uid,
          name: userFromStorage.displayName,
          email: userFromStorage.email,
          phoneNumber: userFromStorage.phoneNumber,
        );
        await _userDataProvider.setUserData(userData);
      }
    } on ApiClientException catch (e) {
      if (e.type == ApiClientExceptionType.firebaseAuth) {
        rethrow;
      } else {
        debugPrint('ApiClientException: ${e.massage}');
      }
    }
  }

  Future<void> signup(String email, String password) async {
    try {
      final userFromStorage = await _apiClient.createUserWithEmailAndPassword(
        email,
        password,
      );
      if (userFromStorage != null) {
        final userData = User(
          uid: userFromStorage.uid,
          name: userFromStorage.displayName,
          email: userFromStorage.email,
          phoneNumber: userFromStorage.phoneNumber,
        );
        await _userDataProvider.setUserData(userData);
      }
    } on ApiClientException catch (e) {
      if (e.type == ApiClientExceptionType.firebaseAuth) {
        rethrow;
      } else {
        debugPrint('ApiClientException: ${e.massage}');
      }
    }
  }

  Future<void> logout() async {}
}
