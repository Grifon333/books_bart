import 'package:books_bart/domain/entity/book.dart';
import 'package:books_bart/domain/entity/book_in_order.dart';
import 'package:books_bart/domain/entity/favorite_book.dart';
import 'package:books_bart/domain/entity/order.dart';
import 'package:books_bart/domain/entity/review.dart';
import 'package:books_bart/domain/entity/variant_of_book.dart';
import 'package:books_bart/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cloud_firestore;
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
  late cloud_firestore.FirebaseFirestore _firebaseFirestore;
  late FirebaseStorage _firebaseStorage;

  ApiClient._();

  static final ApiClient instance = ApiClient._();

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _firebaseAuth = FirebaseAuth.instance;
    _firebaseFirestore = cloud_firestore.FirebaseFirestore.instance;
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

  Future<void> updatePassword(String password) async {
    try {
      // await _firebaseAuth.sendPasswordResetEmail(
      //   email: _firebaseAuth.currentUser?.email ?? '',
      // );
      await _firebaseAuth.currentUser?.updatePassword(password);
    } on FirebaseAuthException catch(e) {
      throw Exception(e.message);
      // throw ApiClientFirebaseAuthException('Error with server. Try late.');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

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

  Future<Map<String, VariantOfBook>> getVariantsOfBookById(
      String bookId) async {
    try {
      Map<String, VariantOfBook> variantsOfBook = {};
      final querySnapshot = await _firebaseFirestore
          .collection('books/$bookId/variants_of_book')
          .withConverter(
            fromFirestore: VariantOfBook.fromFirestore,
            toFirestore: (VariantOfBook variant, options) =>
                variant.toFirestore(),
          )
          .get();
      for (var doc in querySnapshot.docs) {
        variantsOfBook.addAll({doc.id: doc.data()});
      }
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
      final documentReference = await _firebaseFirestore
          .collection('books')
          .withConverter(
            fromFirestore: Book.fromFirestore,
            toFirestore: (Book book, options) => book.toFirestore(),
          )
          .add(book);
      final bookId = documentReference.id;
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
    List<VariantOfBook> variantsOfBook,
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
      Map<String, VariantOfBook> oldVariants =
          await getVariantsOfBookById(bookId);
      List<VariantOfBook> newVariants = [];
      for (var variantOfBook in variantsOfBook) {
        if (oldVariants.values.contains(variantOfBook)) {
          oldVariants.removeWhere((key, value) => value == variantOfBook);
          continue;
        }
        newVariants.add(variantOfBook);
      }
      for (String id in oldVariants.keys) {
        deleteVariantOfBook(bookId, id);
      }
      for (var variant in newVariants) {
        _addVariantOfBook(bookId, variant);
      }
    } on FirebaseException {
      throw ApiClientFirebaseAuthException('Error updating Book.');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> deleteBook(String bookId) async {
    try {
      List<String> variantsOfBookId =
          (await getVariantsOfBookById(bookId)).keys.toList();
      for (String id in variantsOfBookId) {
        deleteVariantOfBook(bookId, id);
      }
      await _firebaseFirestore
          .collection('books')
          .withConverter(
            fromFirestore: Book.fromFirestore,
            toFirestore: (Book book, options) => book.toFirestore(),
          )
          .doc(bookId)
          .delete();
    } on FirebaseException {
      throw ApiClientFirebaseAuthException('Error deleting Book.');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> deleteVariantOfBook(
    String bookId,
    String variantOfBookId,
  ) async {
    try {
      await _firebaseFirestore
          .collection('books/$bookId/variants_of_book')
          .withConverter(
            fromFirestore: VariantOfBook.fromFirestore,
            toFirestore: (VariantOfBook book, options) => book.toFirestore(),
          )
          .doc(variantOfBookId)
          .delete();
    } on FirebaseException {
      throw ApiClientFirebaseAuthException('Error deleting Variant of Book.');
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

  Future<String> addOrder(Order order) async {
    try {
      final docReference = await _firebaseFirestore
          .collection('order')
          .withConverter(
            fromFirestore: Order.fromFirestore,
            toFirestore: (Order order, options) => order.toFirestore(),
          )
          .add(order);
      return docReference.id;
    } on FirebaseException {
      throw ApiClientFirebaseAuthException(
        'Error adding Order.',
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> addBookInOrder(BookInOrder bookInOrder) async {
    try {
      await _firebaseFirestore
          .collection('book_in_order')
          .withConverter(
            fromFirestore: BookInOrder.fromFirestore,
            toFirestore: (BookInOrder bookInOrder, options) =>
                bookInOrder.toFirestore(),
          )
          .add(bookInOrder);
    } on FirebaseException {
      throw ApiClientFirebaseAuthException(
        'Error adding Book in Order.',
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String?> isExistBookInOrder(BookInOrder bookInOrder) async {
    try {
      final querySnapshot = await _firebaseFirestore
          .collection('book_in_order')
          .withConverter(
            fromFirestore: BookInOrder.fromFirestore,
            toFirestore: (BookInOrder bookInOrder, options) =>
                bookInOrder.toFirestore(),
          )
          .where('id_order', isEqualTo: bookInOrder.idOrder)
          .where('id_variant_of_book', isEqualTo: bookInOrder.idVariantOfBook)
          .where('id_book', isEqualTo: bookInOrder.idBook)
          .get();
      if (querySnapshot.size == 0) return null;
      return querySnapshot.docs[0].id;
    } on FirebaseException {
      throw ApiClientFirebaseAuthException(
        'Error check of exist of Book in Order.',
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> updateCountOfBookInOrder(String bookInOrderId) async {
    try {
      await _firebaseFirestore
          .collection('book_in_order')
          .withConverter(
            fromFirestore: BookInOrder.fromFirestore,
            toFirestore: (BookInOrder bookInOrder, options) =>
                bookInOrder.toFirestore(),
          )
          .doc(bookInOrderId)
          .update({'count': cloud_firestore.FieldValue.increment(1)});
    } on FirebaseException {
      throw ApiClientFirebaseAuthException(
        'Error updating count of Book in Order.',
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Map<String, BookInOrder>> getBooksInOrder(String orderId) async {
    try {
      Map<String, BookInOrder> result = {};
      final docRef = await _firebaseFirestore
          .collection('book_in_order')
          .withConverter(
            fromFirestore: BookInOrder.fromFirestore,
            toFirestore: (BookInOrder bookInOrder, options) =>
                bookInOrder.toFirestore(),
          )
          .where('id_order', isEqualTo: orderId)
          .get();
      for (var doc in docRef.docs) {
        result.addAll({doc.id: doc.data()});
      }
      return result;
    } on FirebaseException {
      throw ApiClientFirebaseAuthException(
        'Error getting Books in Order.',
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> updateBookInOrder(
    String bookInOrderId,
    Map<String, dynamic> changes,
  ) async {
    try {
      await _firebaseFirestore
          .collection('book_in_order')
          .withConverter(
            fromFirestore: BookInOrder.fromFirestore,
            toFirestore: (BookInOrder bookInOrder, options) =>
                bookInOrder.toFirestore(),
          )
          .doc(bookInOrderId)
          .update(changes);
    } on FirebaseException {
      throw ApiClientFirebaseAuthException(
        'Error updating Book in Order.',
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> submitOrder(
    String orderId,
    DateTime dateRegistration,
    String paymentMethod,
  ) async {
    try {
      await _firebaseFirestore
          .collection('order')
          .withConverter(
            fromFirestore: Order.fromFirestore,
            toFirestore: (Order order, options) => order.toFirestore(),
          )
          .doc(orderId)
          .update(
        {
          'payment_method': paymentMethod,
          'date_registration':
              cloud_firestore.Timestamp.fromDate(dateRegistration),
          'status': 'Submitted',
        },
      );
    } on FirebaseException {
      throw ApiClientFirebaseAuthException(
        'Error updating Order.',
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> deleteBookInOrder(String bookInOrderId) async {
    try {
      await _firebaseFirestore
          .collection('book_in_order')
          .withConverter(
            fromFirestore: BookInOrder.fromFirestore,
            toFirestore: (BookInOrder bookInOrder, options) =>
                bookInOrder.toFirestore(),
          )
          .doc(bookInOrderId)
          .delete();
    } on FirebaseException {
      throw ApiClientFirebaseAuthException(
        'Error deleting Order.',
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> addFavoriteBook(FavoriteBook favoriteBook) async {
    try {
      await _firebaseFirestore
          .collection('favorite_book')
          .withConverter(
            fromFirestore: FavoriteBook.fromFirestore,
            toFirestore: (FavoriteBook favoriteBook, options) =>
                favoriteBook.toFirestore(),
          )
          .add(favoriteBook);
    } on FirebaseException {
      throw ApiClientFirebaseAuthException(
        'Error adding FavoriteBook.',
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> isExistFavoriteBook(FavoriteBook favoriteBook) async {
    try {
      final querySnapshot = await _firebaseFirestore
          .collection('favorite_book')
          .withConverter(
            fromFirestore: FavoriteBook.fromFirestore,
            toFirestore: (FavoriteBook favoriteBook, options) =>
                favoriteBook.toFirestore(),
          )
          .where('id_book', isEqualTo: favoriteBook.idBook)
          .where('uid', isEqualTo: favoriteBook.uid)
          .get();
      return querySnapshot.docs.isNotEmpty;
    } on FirebaseException {
      throw ApiClientFirebaseAuthException(
        'Error adding FavoriteBook.',
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> deleteFavoriteBookById(String favoriteBookId) async {
    try {
      await _firebaseFirestore
          .collection('favorite_book')
          .withConverter(
            fromFirestore: FavoriteBook.fromFirestore,
            toFirestore: (FavoriteBook favoriteBook, options) =>
                favoriteBook.toFirestore(),
          )
          .doc(favoriteBookId)
          .delete();
    } on FirebaseException {
      throw ApiClientFirebaseAuthException(
        'Error deleting FavoriteBook.',
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String> getFavoriteBookId(FavoriteBook favoriteBook) async {
    try {
      final querySnapshot = await _firebaseFirestore
          .collection('favorite_book')
          .withConverter(
            fromFirestore: FavoriteBook.fromFirestore,
            toFirestore: (FavoriteBook favoriteBook, options) =>
                favoriteBook.toFirestore(),
          )
          .where('id_book', isEqualTo: favoriteBook.idBook)
          .where('uid', isEqualTo: favoriteBook.uid)
          .get();
      return querySnapshot.docs[0].id;
    } on FirebaseException {
      throw ApiClientFirebaseAuthException(
        'Error getting FavoriteBook by ID.',
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Map<String, FavoriteBook>> getFavoriteBooks(String uid) async {
    try {
      final querySnapshot = await _firebaseFirestore
          .collection('favorite_book')
          .withConverter(
            fromFirestore: FavoriteBook.fromFirestore,
            toFirestore: (FavoriteBook favoriteBook, options) =>
                favoriteBook.toFirestore(),
          )
          .where('uid', isEqualTo: uid)
          .get();
      Map<String, FavoriteBook> favoriteBooks = {};
      for (var doc in querySnapshot.docs) {
        favoriteBooks.addAll({doc.id: doc.data()});
      }
      return favoriteBooks;
    } on FirebaseException {
      throw ApiClientFirebaseAuthException(
        'Error getting FavoriteBook.',
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> addReview(Review review) async {
    try {
      await _firebaseFirestore
          .collection('review')
          .withConverter(
            fromFirestore: Review.fromFirestore,
            toFirestore: (Review review, options) => review.toFirestore(),
          )
          .add(review);
      _updateBookRating(review.idBook, review.rating);
    } on FirebaseException {
      throw ApiClientFirebaseAuthException(
        'Error adding Review.',
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> _updateBookRating(String bookId, int countStars) async {
    try {
      final querySnapshot = await _firebaseFirestore
          .collection('books')
          .withConverter(
            fromFirestore: Book.fromFirestore,
            toFirestore: (Book book, options) => book.toFirestore(),
          )
          .doc(bookId)
          .get();
      Map<String, int> rating = querySnapshot.data()!.rating.map(
            (key, value) => MapEntry(key.toString(), value),
          );
      final oldCount = rating['$countStars'] ?? 0;
      rating['$countStars'] = oldCount + 1;
      await _firebaseFirestore
          .collection('books')
          .withConverter(
            fromFirestore: Book.fromFirestore,
            toFirestore: (Book book, options) => book.toFirestore(),
          )
          .doc(bookId)
          .update({'rating': rating});
    } on FirebaseException {
      throw ApiClientFirebaseAuthException(
        'Error adding Review.',
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<Review>> getReviews(String bookId) async {
    try {
      final querySnapshot = await _firebaseFirestore
          .collection('review')
          .withConverter(
            fromFirestore: Review.fromFirestore,
            toFirestore: (Review review, options) => review.toFirestore(),
          )
          .where('id_book', isEqualTo: bookId)
          .get();
      return querySnapshot.docs.map((e) => e.data()).toList();
    } on FirebaseException {
      throw ApiClientFirebaseAuthException(
        'Error getting Reviews.',
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
