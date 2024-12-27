import 'package:authentication_repository/authentication_repository.dart';
import 'package:books_bart/domain/entity/book.dart';
import 'package:books_bart/domain/factories/screen_factory.dart';
import 'package:books_bart/domain/repositories/book_repository.dart';
import 'package:flutter/material.dart';

class FavoriteBooksState {
  List<BookInfo> books = [];
}

class FavoriteBooksViewModel extends ChangeNotifier {
  final BuildContext context;
  final FavoriteBooksState _state = FavoriteBooksState();
  final BookRepository _bookRepository;
  final AuthenticationRepository _authenticationRepository;
  final ScreenFactory _screenFactory = ScreenFactory();

  FavoriteBooksState get state => _state;

  FavoriteBooksViewModel(
    this.context, {
    required,
    required BookRepository bookRepository,
    required AuthenticationRepository authenticationRepository,
  })  : _bookRepository = bookRepository,
        _authenticationRepository = authenticationRepository {
    _init();
  }

  Future<void> _init() async {
    _state.books.clear();
    String uid = _authenticationRepository.currentUser.uid;
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
          imageURL: book.imageURL,
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
    Navigator.of(context).push<void>(MaterialPageRoute<void>(
      builder: (_) => _screenFactory.makeBookDetails(
        _state.books[index].bookId,
      ),
    ));
  }
}

class BookInfo {
  String id;
  String title;
  String author;
  bool isFavorite;
  String bookId;
  String imageURL;

  BookInfo({
    required this.id,
    required this.title,
    required this.author,
    this.isFavorite = true,
    required this.bookId,
    required this.imageURL,
  });
}
