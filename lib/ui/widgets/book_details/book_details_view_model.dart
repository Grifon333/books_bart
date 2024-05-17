import 'package:books_bart/domain/entity/book.dart';
import 'package:books_bart/domain/entity/favorite_book.dart';
import 'package:books_bart/domain/entity/variant_of_book.dart';
import 'package:books_bart/domain/repositories/book_repository.dart';
import 'package:books_bart/domain/repositories/order_repository.dart';
import 'package:books_bart/domain/repositories/user_repository.dart';
import 'package:books_bart/ui/navigation/main_navigation.dart';
import 'package:flutter/material.dart';

class BookDetailsState {
  String title = '';
  String authors = '';
  String countPage = '';
  String description = '';
  String imageURL = '';
  String rating = '';
  bool isFavoriteBook = false;

  List<VariantOfBookInfo> variantsOfBook = [];
  int selectVariantOfBook = 0;
}

class BookDetailsViewModel extends ChangeNotifier {
  final BuildContext context;
  final String bookId;
  final MainNavigation _mainNavigation = MainNavigation();
  final BookRepository _bookRepository = BookRepository();
  final OrderRepository _orderRepository = OrderRepository();
  final UserRepository _userRepository = UserRepository();
  final BookDetailsState _state = BookDetailsState();

  BookDetailsState get state => _state;

  BookDetailsViewModel(
    this.context,
    this.bookId,
  ) {
    _init();
  }

  Future<void> _init() async {
    final data = await _bookRepository.getBookInfoById(bookId);
    Book book = data[0];
    _setBookInfo(book);
    Map<String, VariantOfBook> variants = data[1];
    _setVariantsOfBookInfo(variants);
    _state.isFavoriteBook = await _isFavoriteBook();
    notifyListeners();
  }

  void _setBookInfo(Book book) {
    _state.title = book.title;
    _state.authors = book.authors;
    _state.countPage = '${book.countPage}';
    _state.description = book.description;
    _state.imageURL = book.imageURL;
    double rating = 0;
    int count = 0;
    for (var ratingEntry in book.rating.entries) {
      int countStars = int.parse(ratingEntry.key);
      int countEvaluation = ratingEntry.value;
      rating += countStars * countEvaluation;
      count += countEvaluation;
    }
    if (rating != 0) {
      rating /= count;
      rating = (rating * 100).roundToDouble() / 100;
    }
    _state.rating = '$rating';
  }

  void _setVariantsOfBookInfo(Map<String, VariantOfBook> variants) {
    for (var variantEntry in variants.entries) {
      VariantOfBook variantOfBook = variantEntry.value;
      _state.variantsOfBook.add(VariantOfBookInfo(
        id: variantEntry.key,
        format: variantOfBook.format,
        language: variantOfBook.language,
        price: '${variantOfBook.price}\$',
        publisher: variantOfBook.publisher,
        bindingType: variantOfBook.bindingType,
        publicationYear: '${variantOfBook.publicationYear}',
      ));
    }
  }

  Future<bool> _isFavoriteBook() async {
    String uid = (await _userRepository.getCurrentUserData()).uid;
    FavoriteBook favoriteBook = FavoriteBook(uid: uid, idBook: bookId);
    return await _bookRepository.isFavoriteBook(favoriteBook);
  }

  void onPressedReturn() {
    _mainNavigation.popFromBookDetailsScreen(context);
  }

  void onTapVariantOfBook(int index) {
    _state.selectVariantOfBook = index;
    notifyListeners();
  }

  void onPressedAddToCart() {
    _orderRepository.addBookInOrder(
      bookId,
      _state.variantsOfBook[_state.selectVariantOfBook].id,
    );
  }

  Future<void> onPressedFavorite() async {
    String uid = (await _userRepository.getCurrentUserData()).uid;
    FavoriteBook favoriteBook = FavoriteBook(uid: uid, idBook: bookId);
    final oldFavorite = _state.isFavoriteBook;
    if (oldFavorite) {
      await _bookRepository.deleteFavoriteBook(favoriteBook);
    } else {
      await _bookRepository.addFavoriteBook(favoriteBook);
    }
    _state.isFavoriteBook ^= true;
    notifyListeners();
  }
}

class VariantOfBookInfo {
  String id;
  String format;
  String language;
  String price;
  String publisher;
  String? bindingType;
  String publicationYear;

  VariantOfBookInfo({
    required this.id,
    required this.format,
    required this.language,
    required this.price,
    required this.publisher,
    required this.bindingType,
    required this.publicationYear,
  });
}
