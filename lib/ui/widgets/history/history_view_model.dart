import 'package:books_bart/domain/entity/book.dart';
import 'package:books_bart/domain/entity/book_in_order.dart';
import 'package:books_bart/domain/entity/order.dart';
import 'package:books_bart/domain/entity/variant_of_book.dart';
import 'package:books_bart/domain/repositories/book_repository.dart';
import 'package:books_bart/domain/repositories/order_repository.dart';
import 'package:books_bart/domain/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryState {
  List<OrderInfo> orders = [];
  bool isLoading = false;
}

class HistoryViewModel extends ChangeNotifier {
  final BuildContext context;
  final HistoryState _state = HistoryState();
  final OrderRepository _orderRepository = OrderRepository();
  final BookRepository _bookRepository = BookRepository();
  final UserRepository _userRepository = UserRepository();

  HistoryState get state => _state;

  HistoryViewModel(this.context) {
    _init();
  }

  Future<void> _init() async {
    _state.isLoading = true;
    notifyListeners();
    await _getOrders();
    _state.isLoading = false;
    notifyListeners();
  }

  Future<void> _getOrders() async {
    _state.orders.clear();
    String role = await _userRepository.getRole();
    final Map<String, Order> orders = role == 'manager'
        ? await _orderRepository.getAllOrders()
        : await _orderRepository.getOrdersOfCurrentUser();
    for (var orderEntry in orders.entries) {
      final Order order = orderEntry.value;
      if (order.status == OrderStatus.creating) continue;
      List<BookInfo> booksInfo = await _getBookInfo(orderEntry.key);
      _state.orders.add(OrderInfo(
        id: orderEntry.key,
        status: order.status.toString(),
        dateRegistration: order.dateRegistration,
        books: booksInfo,
        paymentMethod: order.paymentMethod,
        price: '${order.price}\$',
        statusColor: order.status.getColor(),
      ));
    }
    _state.orders.sort((a, b) => a.compareTo(b));
  }

  Future<List<BookInfo>> _getBookInfo(String orderId) async {
    List<BookInfo> booksInfo = [];
    final Map<String, BookInOrder> booksInOrder =
        await _orderRepository.getBooksInOrder(orderId);
    for (var bookInOrderEntry in booksInOrder.entries) {
      BookInOrder bookInOrder = bookInOrderEntry.value;
      String bookId = bookInOrder.idBook;
      String variantOfBookId = bookInOrder.idVariantOfBook;
      List<dynamic> bookData = await _bookRepository.getBookInfoById(bookId);
      Book book = bookData[0];
      VariantOfBook variantsOfBook =
          (bookData[1] as Map<String, VariantOfBook>)[variantOfBookId]!;
      booksInfo.add(BookInfo(
        title: book.title,
        price: variantsOfBook.price,
        count: bookInOrder.count,
      ));
    }
    return booksInfo;
  }

  Future<void> onRefresh() async {
    await _init();
  }
}

class OrderInfo {
  final String id;
  final String status;
  final DateTime? _dateRegistration;
  final List<BookInfo> books;
  final String? paymentMethod;
  final String price;
  final Color statusColor;

  String? get dateRegistration => _dateRegistration == null
      ? null
      : DateFormat(DateFormat.YEAR_MONTH_DAY).format(_dateRegistration);

  const OrderInfo({
    required this.id,
    required this.status,
    DateTime? dateRegistration,
    required this.books,
    required this.paymentMethod,
    required this.price,
    this.statusColor = Colors.black,
  }) : _dateRegistration = dateRegistration;

  int compareTo(OrderInfo other) {
    int compareStatus = status.compareTo(other.status);
    if (compareStatus != 0) return compareStatus;
    int dateComparison = _dateRegistration!.compareTo(other._dateRegistration!);
    if (dateComparison == 1) {
      return -1;
    } else if (dateComparison == -1) {
      return 1;
    } else {
      return 0;
    }
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
