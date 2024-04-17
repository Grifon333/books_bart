import 'package:books_bart/domain/entity/book.dart';
import 'package:books_bart/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ApiClientFirebaseAuthException implements Exception {
  final String massage;

  ApiClientFirebaseAuthException(this.massage);
}

class ApiClientFirestoreException implements Exception {
  final String massage;

  ApiClientFirestoreException(this.massage);
}

class ApiClient {
  late FirebaseAuth _firebaseAuth;
  late FirebaseFirestore _firestore;

  ApiClient._();

  static final ApiClient instance = ApiClient._();

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _firebaseAuth = FirebaseAuth.instance;
    _firestore = FirebaseFirestore.instance;
  }

  Future<UserCredential?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        throw ApiClientFirebaseAuthException(
            'The email address is badly formatted.');
      } else if (e.code == 'user-not-found') {
        throw ApiClientFirebaseAuthException('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw ApiClientFirebaseAuthException(
            'Wrong password provided for that user.');
      } else if (e.code == 'invalid-credential') {
        throw ApiClientFirebaseAuthException(
            'Email or password are incorrect.');
      } else {
        throw ApiClientFirebaseAuthException('Error with server. Try late.');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      return userCredential;
    } on FirebaseAuthException {
      throw ApiClientFirebaseAuthException('Error with server. Try late.');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<UserCredential?> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw ApiClientFirebaseAuthException(
            'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw ApiClientFirebaseAuthException(
            'The account already exists for that email.');
      } else {
        throw ApiClientFirebaseAuthException('Error with server. Try late.');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException {
      throw ApiClientFirebaseAuthException('Error with server. Try late.');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> sendEmailVerification(User? user) async {
    try {
      await user?.sendEmailVerification();
    } on FirebaseAuthException {
      throw ApiClientFirebaseAuthException('Error with server. Try late.');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> updateDisplayName(String nickname) async {
    try {
      await _firebaseAuth.currentUser?.updateDisplayName(nickname);
    } on FirebaseAuthException {
      throw ApiClientFirebaseAuthException('Error with server. Try late.');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Future<void> updatePassword(String password) async {
  //   _firebaseAuth?.sendPasswordResetEmail(email: '');
  //   await _firebaseAuth?.currentUser?.updatePassword(password);
  // }

  Future<void> updatePhoneNumber(String phoneNumber) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (credential) async {
          await _firebaseAuth.currentUser?.updatePhoneNumber(credential);
        },
        verificationFailed: (err) {
          throw ApiClientFirebaseAuthException('Invalid code. Try again');
        },
        codeSent: (verificationId, [forceResendingToken]) async {
          String code = '123123';
          final credential = PhoneAuthProvider.credential(
            verificationId: verificationId,
            smsCode: code,
          );
          await _firebaseAuth.currentUser?.updatePhoneNumber(credential);
        },
        codeAutoRetrievalTimeout: (_) {},
      );
    } on FirebaseAuthException {
      throw ApiClientFirebaseAuthException('Error with server. Try late.');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> updatePhoto(String photoURL) async {
    try {
      await _firebaseAuth.currentUser?.updatePhotoURL(photoURL);
    } on FirebaseAuthException {
      throw ApiClientFirebaseAuthException('Error with server. Try late.');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<Book>> getAllBooks() async {
    try {
      final collection = await _firestore
          .collection('books')
          .withConverter(
            fromFirestore: Book.fromFirestore,
            toFirestore: (Book book, options) => book.toFirestore(),
          )
          .get();
      return collection.docs.map((e) => e.data()).toList();
    } on FirebaseException {
      throw ApiClientFirebaseAuthException('Error getting all Books.');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> addBook(String title, Book book) async {
    try {
      await _firestore
          .collection('books')
          .withConverter(
            fromFirestore: Book.fromFirestore,
            toFirestore: (Book book, options) => book.toFirestore(),
          )
          .doc(title)
          .set(book);
    } on FirebaseException {
      throw ApiClientFirebaseAuthException('Error adding Book.');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> updateBook(
    String title, [
    String? authors,
    int? countPage,
    String? description,
    String? category,
    Map<String, int>? rating,
  ]) async {
    Map<String, dynamic> updateMap = {
      if (authors != null) 'authors': authors,
      if (countPage != null) 'count_page': countPage,
      if (description != null) 'description': description,
      if (category != null) 'category': category,
      if (rating != null) 'rating': rating,
    };
    try {
      await _firestore
          .collection('books')
          .withConverter(
            fromFirestore: Book.fromFirestore,
            toFirestore: (Book book, options) => book.toFirestore(),
          )
          .doc(title)
          .update(updateMap);
    } on FirebaseException {
      throw ApiClientFirebaseAuthException('Error updating Book.');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> deleteBook(String title) async {
    try {
      await _firestore
          .collection('books')
          .withConverter(
            fromFirestore: Book.fromFirestore,
            toFirestore: (Book book, options) => book.toFirestore(),
          )
          .doc(title)
          .delete();
    } on FirebaseException {
      throw ApiClientFirebaseAuthException('Error deleting Book.');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Book?> getBook(String title) async {
    try {
      final book = await _firestore
          .collection('books')
          .withConverter(
            fromFirestore: Book.fromFirestore,
            toFirestore: (Book book, options) => book.toFirestore(),
          )
          .doc(title)
          .get()
          .then((value) => value.data());
      return book;
    } on FirebaseException catch (e) {
      throw ApiClientFirestoreException(e.message ?? 'Error getting Book');
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
