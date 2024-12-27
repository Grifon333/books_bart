import 'package:books_bart/domain/entity/book.dart';
import 'package:books_bart/domain/factories/screen_factory.dart';
import 'package:books_bart/domain/repositories/book_repository.dart';
import 'package:flutter/material.dart';

class HomeState {
  Map<String, List<BookInfo>> books = {};
  List<BookInfo> filteredBooks = [];
  String searchTitle = '';
  bool isFiltered = false;
  bool canReturn = false;
}

class HomeViewModel extends ChangeNotifier {
  final BuildContext context;
  final HomeState _state = HomeState();
  final BookRepository _bookRepository;

  HomeViewModel(this.context, {required BookRepository bookRepository})
      : _bookRepository = bookRepository {
    _init();
  }

  HomeState get state => _state;

  Future<void> _init() async {
    await _getBooks();
    notifyListeners();
  }

  Future<void> _getBooks() async {
    final books = await _bookRepository.getAllBooksWithId();
    Map<String, List<BookInfo>> booksByCategory = {};
    for (var bookEntry in books.entries) {
      Book book = bookEntry.value;
      String category = book.category;
      String title = book.title;
      String authors = book.authors;
      String url = book.imageURL;
      final BookInfo bookInfo = BookInfo(
        id: bookEntry.key,
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
    for (var booksInCategory in booksByCategory.values) {
      _state.filteredBooks.addAll(booksInCategory);
    }
  }

  Future<void> onRefresh() async => await _init();

  void onTapBookInfo(String bookId) {
    ScreenFactory screenFactory = ScreenFactory();
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
          builder: (_) => screenFactory.makeBookDetails(bookId)),
    );
  }

  void onChangeSearchTitle(String value) {
    value = value.trim();
    _state.searchTitle = value;
    if (value.isNotEmpty) {
      _filterBooksByTitle();
      _state.isFiltered = true;
    } else {
      _state.isFiltered = false;
    }
    notifyListeners();
  }

  void _filterBooksByTitle() {
    _state.filteredBooks.clear();
    List<BookInfo> filteredBooks = [];
    String searchTitle = _state.searchTitle.toLowerCase();
    for (var bookGroup in _state.books.values) {
      for (var book in bookGroup) {
        if (book.title.toLowerCase().contains(searchTitle)) {
          filteredBooks.add(book);
        }
      }
    }
    _state.filteredBooks = filteredBooks;
  }

  void onPressedBookCategory(String category) {
    _filterBooksByCategory(category);
    _state.isFiltered = true;
    _state.canReturn = true;
    notifyListeners();
  }

  void onPressedShowAllBooks() {
    _state.isFiltered = false;
    _state.canReturn = false;
    notifyListeners();
  }

  void _filterBooksByCategory(String category) {
    _state.filteredBooks.clear();
    _state.filteredBooks.addAll(_state.books[category] ?? []);
  }
}

class BookInfo {
  String id;
  String title;
  String authors;
  String imageUrl;

  BookInfo({
    required this.id,
    required this.title,
    required this.authors,
    required this.imageUrl,
  });
}
