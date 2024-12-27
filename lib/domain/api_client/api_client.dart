import 'package:books_bart/domain/entity/book.dart';
import 'package:books_bart/domain/entity/favorite_book.dart';
import 'package:books_bart/domain/entity/review.dart';
import 'package:books_bart/domain/entity/variant_of_book.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cloud_firestore;
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
  late cloud_firestore.FirebaseFirestore _firebaseFirestore;
  late FirebaseStorage _firebaseStorage;

  ApiClient._() {
    _init();
  }

  static final ApiClient instance = ApiClient._();

  void _init() {
    _firebaseFirestore = cloud_firestore.FirebaseFirestore.instance;
    _firebaseStorage = FirebaseStorage.instance;
  }

  /// -----------------------------BOOK-----------------------------------------

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
      final variantsOfBook = await _getVariantsOfBookById(bookId);
      return [book, variantsOfBook];
    } on FirebaseException {
      throw ApiClientFirebaseAuthException('Error getting Book Info by ID.');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Map<String, VariantOfBook>> _getVariantsOfBookById(
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

  Future<String> getBookPhotoURL(String title) async {
    try {
      final ref = _firebaseStorage.ref('images/$title.jpg');
      return await ref.getDownloadURL();
    } catch (e) {
      return 'https://edit.org/images/cat/book-covers-big-2019101610.jpg';
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
          await _getVariantsOfBookById(bookId);
      List<VariantOfBook> newVariants = [];
      for (var variantOfBook in variantsOfBook) {
        if (oldVariants.values.contains(variantOfBook)) {
          oldVariants.removeWhere((key, value) => value == variantOfBook);
          continue;
        }
        newVariants.add(variantOfBook);
      }
      for (String id in oldVariants.keys) {
        _deleteVariantOfBook(bookId, id);
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
          (await _getVariantsOfBookById(bookId)).keys.toList();
      for (String id in variantsOfBookId) {
        _deleteVariantOfBook(bookId, id);
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

  Future<void> _deleteVariantOfBook(
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

  /// --------------------------------------------------------------------------

  /// -------------------------FAVORITE_BOOK------------------------------------

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

  // TODO: replace this method to deleteFavoriteBook(String uid, String bookId)
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

  /// --------------------------------------------------------------------------

  /// -------------------------------REVIEW-------------------------------------

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

  /// --------------------------------------------------------------------------
}
