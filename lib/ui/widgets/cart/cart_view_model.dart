import 'package:books_bart/domain/entity/book.dart';
import 'package:books_bart/domain/entity/book_in_order.dart';
import 'package:books_bart/domain/entity/variant_of_book.dart';
import 'package:books_bart/domain/factories/screen_factory.dart';
import 'package:books_bart/domain/repositories/book_repository.dart';
import 'package:books_bart/domain/repositories/order_repository.dart';
import 'package:books_bart/ui/navigation/main_navigation.dart';
import 'package:flutter/material.dart';

class CartState {
  List<BookInfo> booksInfo = [];
}

class CartViewModel extends ChangeNotifier {
  final BuildContext context;
  final CartState _state = CartState();
  final OrderRepository _orderRepository;
  final BookRepository _bookRepository;
  final ScreenFactory _screenFactory = ScreenFactory();

  CartState get state => _state;

  CartViewModel(
    this.context, {
    required OrderRepository orderRepository,
    required BookRepository bookRepository,
  })  : _orderRepository = orderRepository,
        _bookRepository = bookRepository {
    _init();
  }

  Future<void> _init() async {
    _state.booksInfo.clear();
    Map<String, BookInOrder> booksInOrder =
        await _orderRepository.getBooksInCreatingOrder();
    for (var bookInOrderEntry in booksInOrder.entries) {
      BookInOrder bookInOrder = bookInOrderEntry.value;
      var bookInfo = await _getBookInfoById(bookInOrder.idBook);
      Book book = bookInfo[0];
      VariantOfBook variantOfBook = (bookInfo[1]
          as Map<String, VariantOfBook>)[bookInOrder.idVariantOfBook]!;
      String format = variantOfBook.format;
      String? bindingType = variantOfBook.bindingType;
      String type = bindingType == null ? format : '$format ($bindingType)';
      _state.booksInfo.add(
        BookInfo(
          id: bookInOrderEntry.key,
          bookId: bookInOrder.idBook,
          title: book.title,
          author: book.authors,
          price: '${variantOfBook.price}',
          count: bookInOrder.count,
          type: type,
          imageURL: book.imageURL,
        ),
      );
    }
    notifyListeners();
  }

  Future<List<dynamic>> _getBookInfoById(String bookId) async {
    return await _bookRepository.getBookInfoById(bookId);
  }

  void onPressedCountIncrement(int index) {
    String type = _state.booksInfo[index].type;
    if (type == 'e-book' || type == 'audio') return;
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
    String type = _state.booksInfo[index].type;
    if (type == 'e-book' || type == 'audio') return;
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
    Navigator.of(context).push<void>(MaterialPageRoute<void>(
      builder: (_) => _screenFactory.makeOrder(),
    ));
  }

  Future<void> onRefresh() async {
    await _init();
  }

  void onTapCartBookInfo(int index) {
    Navigator.of(context).push<void>(MaterialPageRoute<void>(
      builder: (_) => _screenFactory.makeBookDetails(
        _state.booksInfo[index].bookId,
      ),
    ));
  }
}

class BookInfo {
  String id;
  String bookId;
  String title;
  String author;
  String price;
  int count;
  String type;
  String imageURL;

  String countStr() => '$count';

  BookInfo({
    required this.id,
    required this.bookId,
    required this.title,
    required this.author,
    required this.price,
    this.count = 1,
    required this.type,
    required this.imageURL,
  });
}
