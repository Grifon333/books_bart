import 'package:books_bart/domain/entity/book.dart';
import 'package:books_bart/domain/entity/variant_of_book.dart';
import 'package:books_bart/domain/repositories/book_repository.dart';
import 'package:flutter/material.dart';
import 'package:order_repository/order_repository.dart';

class OrderState {
  List<BookInfo> booksInfo = [];
  String subtotal = '';
  String taxes = '';
  String discount = '';
  String totalPriceStr = '';
  double totalPrice = 0;
}

class OrderViewModel extends ChangeNotifier {
  final BuildContext context;
  final OrderState _state = OrderState();
  final OrderRepository _orderRepository;
  final BookRepository _bookRepository;

  OrderState get state => _state;

  OrderViewModel(
    this.context, {
    required OrderRepository orderRepository,
    required BookRepository bookRepository,
  })  : _orderRepository = orderRepository,
        _bookRepository = bookRepository {
    _init();
  }

  Future<void> _init() async {
    Map<String, BookInOrder> booksInOrder =
        await _orderRepository.getBooksInCreatingOrder();
    for (var bookInOrder in booksInOrder.values) {
      var bookInfo = await _getBookInfoById(bookInOrder.idBook);
      Book book = bookInfo[0];
      VariantOfBook variantOfBook = (bookInfo[1]
          as Map<String, VariantOfBook>)[bookInOrder.idVariantOfBook]!;
      _state.booksInfo.add(
        BookInfo(
          title: book.title,
          price: variantOfBook.price * bookInOrder.count,
          count: bookInOrder.count,
        ),
      );
    }
    _calculateTotalPrice();
    notifyListeners();
  }

  Future<List<dynamic>> _getBookInfoById(String bookId) async {
    return await _bookRepository.getBookInfoById(bookId);
  }

  void _calculateTotalPrice() {
    double subtotal = 0;
    for (BookInfo bookInfo in _state.booksInfo) {
      subtotal += bookInfo.price;
    }
    _state.subtotal = '\$ $subtotal';
    _state.taxes = '\$ 9';
    _state.discount = '- \$ 10';
    double totalPrice = subtotal + 9 - 10;
    _state.totalPrice = totalPrice;
    _state.totalPriceStr = '$totalPrice';
  }

  Future<void> onPressedSubmitOrder() async {
    await _orderRepository.submitOrder(_state.totalPrice);
    if (!context.mounted) return;
    Navigator.of(context).pop();
  }
}

class BookInfo {
  String title;
  double price;
  int count;

  String get countStr => '$count';

  String get priceStr => '$price';

  BookInfo({
    required this.title,
    required this.price,
    required this.count,
  });
}
