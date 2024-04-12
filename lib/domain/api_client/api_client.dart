import 'package:books_bart/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum ApiClientExceptionType { firebaseAuth, other }

class ApiClientException implements Exception {
  final String massage;
  final ApiClientExceptionType type;

  ApiClientException(
    this.massage,
    this.type,
  );
}

class ApiClient {
  FirebaseAuth? _firebaseAuth;

  ApiClient() {
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _firebaseAuth = FirebaseAuth.instance;
  }

  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _firebaseAuth?.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential?.user;
    } on FirebaseAuthException catch (e) {
      const type = ApiClientExceptionType.firebaseAuth;
      if (e.code == 'invalid-email') {
        throw ApiClientException('The email address is badly formatted.', type);
      } else if (e.code == 'user-not-found') {
        throw ApiClientException('No user found for that email.', type);
      } else if (e.code == 'wrong-password') {
        throw ApiClientException(
            'Wrong password provided for that user.', type);
      } else if (e.code == 'invalid-credential') {
        throw ApiClientException('Email or password are incorrect.', type);
      } else {
        throw ApiClientException('Error with server. Try late.', type);
      }
    } catch (e) {
      throw ApiClientException(e.toString(), ApiClientExceptionType.other);
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final userCredential =
          await _firebaseAuth?.signInWithCredential(credential);
      return userCredential?.user;
    } on FirebaseAuthException {
      const type = ApiClientExceptionType.firebaseAuth;
      throw ApiClientException('Error with server. Try late.', type);
    } catch (e) {
      throw ApiClientException(e.toString(), ApiClientExceptionType.other);
    }
  }

  Future<User?> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential =
          await _firebaseAuth?.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential?.user;
    } on FirebaseAuthException catch (e) {
      const type = ApiClientExceptionType.firebaseAuth;
      if (e.code == 'weak-password') {
        throw ApiClientException('The password provided is too weak.', type);
      } else if (e.code == 'email-already-in-use') {
        throw ApiClientException(
            'The account already exists for that email.', type);
      } else {
        throw ApiClientException('Error with server. Try late.', type);
      }
    } catch (e) {
      throw ApiClientException(e.toString(), ApiClientExceptionType.other);
    }
  }

  Future<void> logout() async {
    await _firebaseAuth?.signOut();
  }

  Future<void> sendEmailVerification(User? user) async {
    await user?.sendEmailVerification();
  }
}
