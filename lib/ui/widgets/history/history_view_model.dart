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
  List<String> orderStatuses = [];
}

class HistoryViewModel extends ChangeNotifier {
  final BuildContext context;
  final HistoryState _state = HistoryState();
  final OrderRepository _orderRepository;
  final BookRepository _bookRepository;
  final UserRepository _userRepository;
  String? _role;

  HistoryState get state => _state;

  String get role => _role ?? '';

  HistoryViewModel(
    this.context, {
    required OrderRepository orderRepository,
    required BookRepository bookRepository,
    required UserRepository userRepository,
  })  : _orderRepository = orderRepository,
        _bookRepository = bookRepository,
        _userRepository = userRepository {
    _init();
  }

  Future<void> _init() async {
    _state.isLoading = true;
    notifyListeners();
    await _getOrders();
    _state.orderStatuses = OrderStatus.values.map((e) => e.toString()).toList();
    _state.isLoading = false;
    notifyListeners();
  }

  Future<void> _getOrders() async {
    _state.orders.clear();
    _role ??= await _userRepository.getRole();
    final Map<String, Order> orders = _role == 'manager'
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

  void onChangeOrderStatus(int index, String? status) {
    if (status == null) return;
    _state.orders[index].status = status;
    _state.orders[index].statusColor =
        OrderStatus.fromString(status).getColor();
    _orderRepository.updateOrderStatus(_state.orders[index].id, status);
    notifyListeners();
  }

  Future<void> onRefresh() async {
    await _init();
  }
}

class OrderInfo {
  final String id;
  String status;
  final DateTime? _dateRegistration;
  final List<BookInfo> books;
  final String? paymentMethod;
  final String price;
  Color statusColor;

  String? get dateRegistration => _dateRegistration == null
      ? null
      : DateFormat(DateFormat.YEAR_MONTH_DAY).format(_dateRegistration);

  OrderInfo({
    required this.id,
    required this.status,
    DateTime? dateRegistration,
    required this.books,
    required this.paymentMethod,
    required this.price,
    this.statusColor = Colors.black,
  }) : _dateRegistration = dateRegistration;

  int compareTo(OrderInfo other) {
    int compareStatus = OrderStatus.fromString(status)
        .compareTo(OrderStatus.fromString(other.status));
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
