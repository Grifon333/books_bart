import 'package:books_bart/domain/entity/book.dart';
import 'package:books_bart/domain/repositories/book_repository.dart';
import 'package:books_bart/domain/repositories/user_repository.dart';
import 'package:books_bart/ui/navigation/main_navigation.dart';
import 'package:flutter/material.dart';

class FavoriteBooksState {
  List<BookInfo> books = [];
}

class FavoriteBooksViewModel extends ChangeNotifier {
  final BuildContext context;
  final FavoriteBooksState _state = FavoriteBooksState();
  final BookRepository _bookRepository = BookRepository();
  final UserRepository _userRepository = UserRepository();
  final MainNavigation _mainNavigation = MainNavigation();

  FavoriteBooksState get state => _state;

  FavoriteBooksViewModel(this.context) {
    _init();
  }

  Future<void> _init() async {
    _state.books.clear();
    String uid = (await _userRepository.getCurrentUserData()).uid;
    final favoriteBooks = await _bookRepository.getFavoriteBooks(uid);
    for (var favoriteBook in favoriteBooks.entries) {
      Book book =
          (await _bookRepository.getBookInfoById(favoriteBook.value.idBook))[0];
      _state.books.add(
        BookInfo(
          id: favoriteBook.key,
          title: book.title,
          author: book.authors,
          bookId: favoriteBook.value.idBook,
        ),
      );
    }
    notifyListeners();
  }

  Future<void> onRefresh() async {
    await _init();
  }

  Future<void> onTapDelete(int index) async {
    await _bookRepository.deleteFavoriteBookById(state.books[index].id);
    state.books.removeAt(index);
    notifyListeners();
  }

  void onTapFavoriteBook(int index) {
    _mainNavigation.goToBookDetailsScreen(
      context,
      _state.books[index].bookId,
    );
  }
}

class BookInfo {
  String id;
  String title;
  String author;
  bool isFavorite;
  String bookId;

  BookInfo({
    required this.id,
    required this.title,
    required this.author,
    // required this.rating,
    this.isFavorite = true,
    // required this.price,
    required this.bookId,
  });
}
