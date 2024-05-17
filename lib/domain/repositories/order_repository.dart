import 'package:books_bart/domain/api_client/api_client.dart';
import 'package:books_bart/domain/data_providers/order_data_provider.dart';
import 'package:books_bart/domain/data_providers/user_data_provider.dart';
import 'package:books_bart/domain/entity/book_in_order.dart';
import 'package:books_bart/domain/entity/order.dart';
import 'package:flutter/material.dart';

class OrderRepository {
  final ApiClient _apiClient = ApiClient.instance;
  final UserDataProvider _userDataProvider = UserDataProvider();
  final OrderDataProvider _orderDataProvider = OrderDataProvider();

  Future<void> createOrder() async {
    try {
      String? uid = (await _userDataProvider.getUserData())?.uid;
      if (uid == null) return;
      Order order = Order(
        uid: uid,
        price: 0,
        status: 'Creating',
      );
      String orderId = await _apiClient.addOrder(order);
      _orderDataProvider.setOrderId(orderId);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> addBookInOrder(
    String bookId,
    String variantOfBookId,
  ) async {
    try {
      String? orderId = await _orderDataProvider.getOrderId();
      if (orderId == null) {
        createOrder();
        orderId = await _orderDataProvider.getOrderId();
        if (orderId == null) return;
      }
      BookInOrder bookInOrder = BookInOrder(
        idOrder: orderId,
        count: 1,
        idVariantOfBook: variantOfBookId,
        idBook: bookId,
      );
      String? bookInOrderId = await _apiClient.isExistBookInOrder(bookInOrder);
      if (bookInOrderId == null) {
        _apiClient.addBookInOrder(bookInOrder);
        return;
      }
      _apiClient.updateCountOfBookInOrder(bookInOrderId);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<Map<String, BookInOrder>> getBooksInOrder() async {
    try {
      String? orderId = await _orderDataProvider.getOrderId();
      if (orderId == null) return {};
      return await _apiClient.getBooksInOrder(orderId);
    } catch (e) {
      debugPrint(e.toString());
      return {};
    }
  }

  Future<void> changeCountBookInOrder(String bookInOrderId, int count) async {
    try {
      await _apiClient.updateBookInOrder(bookInOrderId, {'count': count});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> submitOrder() async {
    try {
      String? orderId = await _orderDataProvider.getOrderId();
      if (orderId == null) return;
      await _apiClient.submitOrder(
        orderId,
        DateTime.now(),
        'Card',
      );
      _orderDataProvider.deleteOrderId();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> deleteBookInOrder(String bookInOrderId) async {
    try {
      await _apiClient.deleteBookInOrder(bookInOrderId);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
