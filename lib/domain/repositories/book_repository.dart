import 'package:books_bart/domain/api_client/api_client.dart';
import 'package:books_bart/domain/entity/book.dart';
import 'package:books_bart/domain/entity/variant_of_book.dart';
import 'package:flutter/material.dart';

class BookRepository {
  final ApiClient _apiClient = ApiClient.instance;

  Future<List<Book>> getAllBooks() async {
    try {
      final books = await _apiClient.getAllBooks();
      return books.values.toList();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

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
}
