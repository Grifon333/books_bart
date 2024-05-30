import 'package:books_bart/domain/api_client/api_client.dart';
import 'package:books_bart/domain/data_providers/user_data_provider.dart';
import 'package:books_bart/domain/entity/user.dart';
import 'package:flutter/material.dart';

class AuthRepository {
  final _userDataProvider = UserDataProvider();
  final _apiClient = ApiClient.instance;

  Future<bool> isAuth() async {
    return await _userDataProvider.getUserData() != null;
  }

  String getRole(String email) {
    return email == '201173@nuos.edu.ua' ? 'manager' : 'customer';
  }

  Future<void> login(String email, String password) async {
    try {
      final userCredential = await _apiClient.signInWithEmailAndPassword(
        email,
        password,
      );
      if (userCredential != null &&
          userCredential.user != null) {
        final userData = User(
          uid: userCredential.user!.uid,
          name: userCredential.user!.displayName,
          email: email,
          phoneNumber: userCredential.user!.phoneNumber,
          sighInMethod: userCredential.credential?.signInMethod ?? '',
          urlPhoto: userCredential.user!.photoURL,
          role: getRole(email),
        );
        await _userDataProvider.setUserData(userData);
      }
    } on ApiClientFirebaseAuthException catch (e) {
      throw ApiClientFirebaseAuthException(e.massage);
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      final userCredential = await _apiClient.signInWithGoogle();
      if (userCredential != null && userCredential.user != null) {
        String email = userCredential.user!.email ?? 'no-email';
        final userData = User(
          uid: userCredential.user!.uid,
          name: userCredential.user!.displayName,
          email: email,
          phoneNumber: userCredential.user!.phoneNumber,
          sighInMethod: 'google.com',
          urlPhoto: userCredential.user!.photoURL,
          role: getRole(email),
        );
        await _userDataProvider.setUserData(userData);
      }
    } on ApiClientFirebaseAuthException catch (e) {
      debugPrint('ApiClientException: $e');
    }
  }

  Future<void> signup(
    String nickname,
    String email,
    String password,
  ) async {
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
          sighInMethod: 'password',
          role: getRole(email),
        );
        await _userDataProvider.setUserData(userData);
      }
    } on ApiClientFirebaseAuthException catch (e) {
      throw ApiClientFirebaseAuthException(e.massage);
    }
  }

  Future<void> logout() async {
    await _apiClient.logout();
    _userDataProvider.deleteUserData();
  }
}
