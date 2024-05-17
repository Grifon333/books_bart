import 'package:books_bart/domain/entity/book.dart';
import 'package:books_bart/domain/entity/book_in_order.dart';
import 'package:books_bart/domain/entity/variant_of_book.dart';
import 'package:books_bart/domain/repositories/book_repository.dart';
import 'package:books_bart/domain/repositories/order_repository.dart';
import 'package:books_bart/ui/navigation/main_navigation.dart';
import 'package:flutter/material.dart';

class CartState {
  List<BookInfo> booksInfo = [];
}

class CartViewModel extends ChangeNotifier {
  final BuildContext context;
  final OrderRepository _orderRepository = OrderRepository();
  final BookRepository _bookRepository = BookRepository();
  final CartState _state = CartState();
  final MainNavigation _mainNavigation = MainNavigation();

  CartState get state => _state;

  CartViewModel(this.context) {
    _init();
  }

  Future<void> _init() async {
    _state.booksInfo.clear();
    Map<String, BookInOrder> booksInOrder =
        await _orderRepository.getBooksInOrder();
    for (var bookInOrderEntry in booksInOrder.entries) {
      BookInOrder bookInOrder = bookInOrderEntry.value;
      var bookInfo = await _getBookInfoById(bookInOrder.idBook);
      Book book = bookInfo[0];
      VariantOfBook variantOfBook = (bookInfo[1]
          as Map<String, VariantOfBook>)[bookInOrder.idVariantOfBook]!;
      _state.booksInfo.add(
        BookInfo(
          id: bookInOrderEntry.key,
          title: book.title,
          author: book.authors,
          price: '${variantOfBook.price}',
          count: bookInOrder.count,
        ),
      );
    }
    notifyListeners();
  }

  Future<List<dynamic>> _getBookInfoById(String bookId) async {
    return await _bookRepository.getBookInfoById(bookId);
  }

  void onPressedCountIncrement(int index) {
    int newCount = _state.booksInfo[index].count + 1;
    if (newCount > 10) return;
    _state.booksInfo[index].count = newCount;
    notifyListeners();
    _orderRepository.changeCountBookInOrder(
      _state.booksInfo[index].id,
      newCount,
    );
  }

  void onPressedCountDecrement(int index) {
    int newCount = _state.booksInfo[index].count - 1;
    if (newCount < 1) return;
    _state.booksInfo[index].count = newCount;
    notifyListeners();
    _orderRepository.changeCountBookInOrder(
      _state.booksInfo[index].id,
      newCount,
    );
  }

  void onTapDelete(int index) {
    _orderRepository.deleteBookInOrder(_state.booksInfo[index].id);
    _state.booksInfo.removeAt(index);
    notifyListeners();
  }

  void onPressedOrder() {
    _mainNavigation.goToOrderScreen(context);
  }

  Future<void> onRefresh() async {
    await _init();
  }
}

class BookInfo {
  String id;
  String title;
  String author;
  String price;
  int count;

  String countStr() => '$count';

  BookInfo({
    required this.id,
    required this.title,
    required this.author,
    required this.price,
    this.count = 1,
  });
}
