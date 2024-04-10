import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:books_bart/firebase_options.dart';

class AuthRepository {
  FirebaseAuth? _firebaseAuth;

  AuthRepository() {
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _firebaseAuth = FirebaseAuth.instance;
  }

  Future<bool> isAuth() async {
    return _firebaseAuth?.currentUser != null;
  }

  Future<void> login(String email, String password) async {
    try {
      await _firebaseAuth?.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        debugPrint('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password provided for that user.');
      } else {
        debugPrint('Error with server. Try late.');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> signup(String email, String password) async {
    try {
      await _firebaseAuth?.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        debugPrint('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        debugPrint('The account already exists for that email.');
      } else {
        debugPrint('Error with server. Try late.');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> sendEmailVerification(User? user) async {
    await user?.sendEmailVerification();
  }
}
