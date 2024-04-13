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
      final userCredential = await _apiClient.signInWithEmailAndPassword(
        email,
        password,
      );
      if (userCredential != null && userCredential.user != null &&
          userCredential.credential != null) {
        final userData = User(
          uid: userCredential.user!.uid,
          name: userCredential.user!.displayName,
          email: email,
          phoneNumber: userCredential.user!.phoneNumber,
          sighInMethod: userCredential.credential!.signInMethod,
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

  Future<void> loginWithGoogle() async {
    try {
      final userCredential = await _apiClient.signInWithGoogle();
      if (userCredential != null && userCredential.user != null) {
        final userData = User(
          uid: userCredential.user!.uid,
          name: userCredential.user!.displayName,
          email: userCredential.user!.email ?? 'no-email',
          phoneNumber: userCredential.user!.phoneNumber,
          sighInMethod: 'google.com',
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

  Future<void> signup(String nickname,
      String email,
      String password,) async {
    try {
      final userCredential = await _apiClient.createUserWithEmailAndPassword(
        email,
        password,
      );
      await _apiClient.updateDisplayName(nickname);
      if (userCredential != null && userCredential.user != null) {
        final userData = User(
          uid: userCredential.user!.uid,
          name: nickname,
          email: email,
          phoneNumber: userCredential.user!.phoneNumber,
          sighInMethod: 'password',
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
