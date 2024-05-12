import 'package:books_bart/domain/entity/book.dart';
import 'package:books_bart/domain/entity/variant_of_book.dart';
import 'package:books_bart/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
  late FirebaseFirestore _firebaseFirestore;
  late FirebaseStorage _firebaseStorage;

  ApiClient._();

  static final ApiClient instance = ApiClient._();

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _firebaseAuth = FirebaseAuth.instance;
    _firebaseFirestore = FirebaseFirestore.instance;
    _firebaseStorage = FirebaseStorage.instance;
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

  Future<Map<String, Book>> getAllBooks() async {
    try {
      final collection = await _firebaseFirestore
          .collection('books')
          .withConverter(
            fromFirestore: Book.fromFirestore,
            toFirestore: (Book book, options) => book.toFirestore(),
          )
          .get();
      Map<String, Book> result = {};
      for (var doc in collection.docs) {
        result.addAll({doc.id: doc.data()});
      }
      return result;
    } on FirebaseException {
      throw ApiClientFirebaseAuthException('Error getting all Books.');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<dynamic>> getBookInfoById(String bookId) async {
    try {
      final book = await _firebaseFirestore
          .collection('books')
          .withConverter(
            fromFirestore: Book.fromFirestore,
            toFirestore: (Book book, options) => book.toFirestore(),
          )
          .doc(bookId)
          .get()
          .then((value) => value.data());
      final variantsOfBook = await getVariantsOfBookById(bookId);
      return [book, variantsOfBook];
    } on FirebaseException {
      throw ApiClientFirebaseAuthException('Error getting Book Info by ID.');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<VariantOfBook>> getVariantsOfBookById(String bookId) async {
    try {
      final variantsOfBook = await _firebaseFirestore
          .collection('books/$bookId/variants_of_book')
          .withConverter(
            fromFirestore: VariantOfBook.fromFirestore,
            toFirestore: (VariantOfBook variant, options) =>
                variant.toFirestore(),
          )
          .get()
          .then((value) => value.docs.map((e) => e.data()).toList());
      return variantsOfBook;
    } on FirebaseException {
      throw ApiClientFirebaseAuthException(
          'Error getting Variants of Book by ID.');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> addBook(Book book, List<VariantOfBook> variants) async {
    try {
      final bookId = await _firebaseFirestore
          .collection('books')
          .withConverter(
            fromFirestore: Book.fromFirestore,
            toFirestore: (Book book, options) => book.toFirestore(),
          )
          .add(book)
          .then((value) => value.id);
      for (VariantOfBook variant in variants) {
        _addVariantOfBook(bookId, variant);
      }
    } on FirebaseException {
      throw ApiClientFirebaseAuthException('Error adding Book.');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> _addVariantOfBook(
    String bookId,
    VariantOfBook variantOfBook,
  ) async {
    try {
      await _firebaseFirestore
          .collection('books/$bookId/variants_of_book')
          .withConverter(
            fromFirestore: VariantOfBook.fromFirestore,
            toFirestore: (VariantOfBook variant, options) =>
                variant.toFirestore(),
          )
          .add(variantOfBook);
    } on FirebaseException {
      throw ApiClientFirebaseAuthException(
        'Error adding Variant of Book (bookId: $bookId).',
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> updateBook(
    String bookId,
    Map<String, dynamic> bookUpdateMap,
    List<VariantOfBook> newVariants,
  ) async {
    try {
      await _firebaseFirestore
          .collection('books')
          .withConverter(
            fromFirestore: Book.fromFirestore,
            toFirestore: (Book book, options) => book.toFirestore(),
          )
          .doc(bookId)
          .update(bookUpdateMap);
      final oldVariants = await getVariantsOfBookById(bookId);
      Function deepEquals = const DeepCollectionEquality().equals;
      if (deepEquals(oldVariants, newVariants)) return;
      for(var variant in newVariants) {
        _addVariantOfBook(bookId, variant);
      }
    } on FirebaseException {
      throw ApiClientFirebaseAuthException('Error updating Book.');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> deleteBook(String title) async {
    try {
      await _firebaseFirestore
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
      final book = await _firebaseFirestore
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

  Future<String> getPhotoURL(String title) async {
    try {
      final ref = _firebaseStorage.ref('images/$title.jpg');
      return await ref.getDownloadURL();
    } catch (e) {
      return 'https://edit.org/images/cat/book-covers-big-2019101610.jpg';
    }
  }
}
