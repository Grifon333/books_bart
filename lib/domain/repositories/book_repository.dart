import 'package:books_bart/domain/api_client/api_client.dart';
import 'package:books_bart/domain/entity/book.dart';
import 'package:flutter/material.dart';

class BookRepository {
  final ApiClient _apiClient = ApiClient.instance;

  Future<List<Book>> getAllBooks() async {
    try {
      final books = await _apiClient.getAllBooks();
      return books;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }
}