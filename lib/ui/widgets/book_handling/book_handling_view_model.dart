import 'package:books_bart/domain/entity/book.dart';
import 'package:books_bart/domain/repositories/book_repository.dart';
import 'package:books_bart/ui/navigation/main_navigation.dart';
import 'package:flutter/material.dart';

class BookHandlingState {
  List<BookInfo> books = [];
}

class BookHandlingViewModel extends ChangeNotifier {
  final BuildContext context;
  final BookHandlingState _state = BookHandlingState();
  final MainNavigation _mainNavigation;
  final BookRepository _bookRepository;

  BookHandlingState get state => _state;

  BookHandlingViewModel(
    this.context, {
    required MainNavigation mainNavigation,
    required BookRepository bookRepository,
  })  : _mainNavigation = mainNavigation,
        _bookRepository = bookRepository {
    _init();
  }

  Future<void> _init() async {
    Map<String, Book> booksFromStorage =
        await _bookRepository.getAllBooksWithId();
    _state.books.clear();
    for (var bookEntry in booksFromStorage.entries) {
      Book book = bookEntry.value;
      _state.books.add(
        BookInfo(
          id: bookEntry.key,
          title: book.title,
          authors: book.authors,
          imageURL: book.imageURL,
        ),
      );
    }
    notifyListeners();
  }

  void onPressedAdd() {
    _mainNavigation.showAddFormBookInfo(context);
  }

  void onPressedEdit(String bookId) {
    _mainNavigation.showEditFormBookInfo(context, bookId);
  }

  void onPressedRemove(String bookId) {
    _bookRepository.deleteBook(bookId);
    _state.books.removeWhere((book) => book.id == bookId);
    notifyListeners();
  }

  Future<void> onRefresh() async {
    _init();
  }
}

class BookInfo {
  String id;
  String title;
  String authors;
  String imageURL;

  BookInfo({
    required this.id,
    required this.title,
    required this.authors,
    required this.imageURL,
  });
}
