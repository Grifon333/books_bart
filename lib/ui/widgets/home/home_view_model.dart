import 'package:books_bart/domain/entity/book.dart';
import 'package:books_bart/domain/repositories/book_repository.dart';
import 'package:flutter/material.dart';

class HomeState {
  Map<String, List<BookInfo>> books = {};

  HomeState();
}

class HomeViewModel extends ChangeNotifier {
  final BuildContext context;
  final HomeState _state = HomeState();
  final BookRepository _bookRepository = BookRepository();

  HomeViewModel(this.context) {
    _init();
  }

  HomeState get state => _state;

  Future<void> _init() async {
    final books = await _bookRepository.getAllBooks();
    Map<String, List<BookInfo>> booksByCategory = {};
    for (Book book in books) {
      String category = book.category;
      String title = book.title;
      String authors = book.authors;
      String url = book.imageURL;
      final BookInfo bookInfo = BookInfo(
        title: title,
        authors: authors,
        imageUrl: url,
      );
      if (booksByCategory.containsKey(category)) {
        booksByCategory[category]!.add(bookInfo);
      } else {
        booksByCategory.addAll({
          category: [bookInfo]
        });
      }
    }
    _state.books = booksByCategory;
    notifyListeners();
  }

  Future<void> onRefresh() async {
    await _init();
  }
}

class BookInfo {
  String title;
  String authors;
  String imageUrl;

  BookInfo({
    required this.title,
    required this.authors,
    required this.imageUrl,
  });
}
