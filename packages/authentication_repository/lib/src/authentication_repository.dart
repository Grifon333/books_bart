import 'package:authentication_repository/authentication_repository.dart';
import 'package:cache/cache.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

part 'authentication_failure.dart';

class AuthenticationRepository {
  final CacheClient _cache;
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  @visibleForTesting
  bool isWeb = kIsWeb;

  @visibleForTesting
  static const userCacheKey = '__user_cache_key__';

  AuthenticationRepository({
    CacheClient? cache,
    firebase_auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _cache = cache ?? CacheClient(),
        _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard();

  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user =
          firebaseUser == null ? User.anonymous() : firebaseUser.toUser;
      _cache.write<User>(key: userCacheKey, value: user);
      return user;
    });
  }

  User get currentUser {
    return _cache.read<User>(key: userCacheKey) ?? User.anonymous();
  }

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw SignUpWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const SignUpWithEmailAndPasswordFailure();
    }
  }

  Future<void> logInWithGoogle() async {
    try {
      late final firebase_auth.AuthCredential credential;
      if (isWeb) {
        final googleProvider = firebase_auth.GoogleAuthProvider();
        final userCredentials = await _firebaseAuth.signInWithPopup(
          googleProvider,
        );
        credential = userCredentials.credential!;
      } else {
        final googleUser = await _googleSignIn.signIn();
        final googleAuth = await googleUser!.authentication;
        credential = firebase_auth.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
      }
      await _firebaseAuth.signInWithCredential(credential);
    } on firebase_auth.FirebaseException catch (e) {
      throw LogInWithGoogleFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithGoogleFailure();
    }
  }

  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on firebase_auth.FirebaseException catch (e) {
      throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithEmailAndPasswordFailure();
    }
  }

  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (_) {
      throw const LogOutFailure();
    }
  }

  Future<void> updateDisplayName(String displayName) async {
    try {
      await _firebaseAuth.currentUser?.updateDisplayName(displayName);
    } catch (_) {
      throw const UpdateDisplayNameFailure();
    }
  }

  Future<void> updatePassword(String password) async {
    try {
      await _firebaseAuth.currentUser?.updatePassword(password);
    } on firebase_auth.FirebaseException catch (e) {
      throw UpdatePasswordFailure(e.code);
    } catch (_) {
      throw const UpdatePasswordFailure();
    }
  }

  Future<void> updatePhoneNumber(String phoneNumber) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (credential) async {
          await _firebaseAuth.currentUser?.updatePhoneNumber(credential);
        },
        verificationFailed: (e) => throw UpdatePhoneNumberFailure(e.code),
        codeSent: (verificationId, [forceResendingToken]) async {
          String code = '123123';
          final credential = firebase_auth.PhoneAuthProvider.credential(
            verificationId: verificationId,
            smsCode: code,
          );
          await _firebaseAuth.currentUser?.updatePhoneNumber(credential);
        },
        codeAutoRetrievalTimeout: (_) {},
      );
    } on firebase_auth.FirebaseException catch (e) {
      throw UpdatePhoneNumberFailure(e.code);
    } catch (_) {
      throw const UpdatePhoneNumberFailure();
    }
  }

  Future<void> updatePhoto(String photoURL) async {
    try {
      await _firebaseAuth.currentUser?.updatePhotoURL(photoURL);
    } catch (_) {
      throw const UpdatePhotoURLFailure();
    }
  }
}

extension on firebase_auth.User {
  User get toUser {
    return User(
      uid: uid,
      name: displayName,
      email: email ?? 'no-email',
      photoUrl: photoURL,
      phoneNumber: phoneNumber,
    );
  }
}
