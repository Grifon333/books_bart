import 'package:books_bart/domain/api_client/api_client.dart';
import 'package:books_bart/domain/entity/book.dart';
import 'package:books_bart/domain/entity/favorite_book.dart';
import 'package:books_bart/domain/entity/review.dart';
import 'package:books_bart/domain/entity/variant_of_book.dart';
import 'package:flutter/material.dart';

class BookRepository {
  final ApiClient _apiClient = ApiClient.instance;

  Future<Map<String, Book>> getAllBooksWithId() async {
    try {
      final books = await _apiClient.getAllBooks();
      return books;
    } catch (e) {
      debugPrint(e.toString());
      return {};
    }
  }

  Future<void> addBook(Book book, List<VariantOfBook> variants) async {
    try {
      await _apiClient.addBook(book, variants);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<dynamic>> getBookInfoById(String bookId) async {
    try {
      return await _apiClient.getBookInfoById(bookId);
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<void> editBookInfo(
    String bookId,
    Map<String, dynamic> bookUpdateMap,
    List<VariantOfBook> newVariants,
  ) async {
    try {
      await _apiClient.updateBook(bookId, bookUpdateMap, newVariants);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> deleteBook(String bookId) async {
    try {
      await _apiClient.deleteBook(bookId);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> addFavoriteBook(FavoriteBook favoriteBook) async {
    try {
      if (await _apiClient.isExistFavoriteBook(favoriteBook)) return;
      await _apiClient.addFavoriteBook(favoriteBook);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> deleteFavoriteBookById(String favoriteBookId) async {
    try {
      await _apiClient.deleteFavoriteBookById(favoriteBookId);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> deleteFavoriteBook(FavoriteBook favoriteBook) async {
    try {
      String favoriteBookId = await _apiClient.getFavoriteBookId(favoriteBook);
      await _apiClient.deleteFavoriteBookById(favoriteBookId);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<Map<String, FavoriteBook>> getFavoriteBooks(String uid) async {
    try {
      return await _apiClient.getFavoriteBooks(uid);
    } catch (e) {
      debugPrint(e.toString());
      return {};
    }
  }

  Future<bool> isFavoriteBook(FavoriteBook favoriteBook) async {
    try {
      return await _apiClient.isExistFavoriteBook(favoriteBook);
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<void> addReview(Review review) async {
    try {
      await _apiClient.addReview(review);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<Review>> getReviews(String bookId) async {
    try {
      return await _apiClient.getReviews(bookId);
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }
}
