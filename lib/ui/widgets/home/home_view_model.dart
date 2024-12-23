import 'package:books_bart/domain/entity/book.dart';
import 'package:books_bart/domain/repositories/book_repository.dart';
import 'package:books_bart/domain/repositories/user_repository.dart';
import 'package:books_bart/ui/navigation/main_navigation.dart';
import 'package:flutter/material.dart';

class HomeState {
  Map<String, List<BookInfo>> books = {};
  List<BookInfo> filteredBooks = [];
  String searchTitle = '';
  bool isFiltered = false;
  bool canReturn = false;
  String nickname = '';
}

class HomeViewModel extends ChangeNotifier {
  final BuildContext context;
  final HomeState _state = HomeState();
  final MainNavigation _mainNavigation;
  final BookRepository _bookRepository;
  final UserRepository _userRepository;

  HomeViewModel(
    this.context, {
    required MainNavigation mainNavigation,
    required BookRepository bookRepository,
    required UserRepository userRepository,
  })  : _mainNavigation = mainNavigation,
        _bookRepository = bookRepository,
        _userRepository = userRepository {
    _init();
  }

  HomeState get state => _state;

  Future<void> _init() async {
    await _getBooks();
    await _getUserNickname();
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

  Future<void> _getUserNickname() async {
    final userData = await _userRepository.getCurrentUserData();
    _state.nickname = userData.name ?? 'Friend';
  }

  Future<void> onRefresh() async {
    await _init();
  }

  void onTapBookInfo(String bookId) {
    _mainNavigation.goToBookDetailsScreen(context, bookId);
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
