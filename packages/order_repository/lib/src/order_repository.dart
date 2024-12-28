import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart' as cloud_firestore;
import 'package:meta/meta.dart';
import 'package:order_repository/src/models/models.dart';
import 'package:order_repository/src/data_providers/data_providers.dart';

class Event {}

class OrderRepository {
  final OrderDataProvider _dataProvider;
  final cloud_firestore.FirebaseFirestore _firebaseFirestore;

  @visibleForTesting
  static const orderIdCacheKey = '__order_id_cache_key__';

  OrderRepository({
    OrderDataProvider? dataProvider,
    cloud_firestore.FirebaseFirestore? firebaseFirestore,
  })  : _dataProvider = dataProvider ?? OrderDataProvider(),
        _firebaseFirestore =
            firebaseFirestore ?? cloud_firestore.FirebaseFirestore.instance;

  cloud_firestore.CollectionReference<Order> get orderCollection =>
      _firebaseFirestore.collection('order').withConverter(
            fromFirestore: Order.fromFirestore,
            toFirestore: (Order order, options) => order.toFirestore(),
          );

  cloud_firestore.CollectionReference<BookInOrder> get bookInOrderCollection =>
      _firebaseFirestore.collection('book_in_order').withConverter(
            fromFirestore: BookInOrder.fromFirestore,
            toFirestore: (BookInOrder bookInOrder, options) =>
                bookInOrder.toFirestore(),
          );

  StreamController<Event> _streamController = StreamController<Event>();

  Stream<Event> get stream => _streamController.stream;

  Future<void> createOrder(String uid) async {
    Order order = Order(uid: uid, price: 0, status: OrderStatus.creating);
    final docRef = await orderCollection.add(order);
    await _dataProvider.setOrderId(docRef.id);
  }

  Future<void> addBookInOrder(
    String uid,
    String bookId,
    String variantOfBookId,
  ) async {
    String? orderId = await _dataProvider.getOrderId();
    if (orderId == null) {
      await createOrder(uid);
      orderId = await _dataProvider.getOrderId();
    }
    if (orderId == null) return;
    BookInOrder bookInOrder = BookInOrder(
      idOrder: orderId,
      count: 1,
      idVariantOfBook: variantOfBookId,
      idBook: bookId,
    );

    String? bookInOrderId;
    final querySnapshot = await bookInOrderCollection
        .where('id_order', isEqualTo: bookInOrder.idOrder)
        .where('id_variant_of_book', isEqualTo: bookInOrder.idVariantOfBook)
        .where('id_book', isEqualTo: bookInOrder.idBook)
        .get();
    if (querySnapshot.size > 0) bookInOrderId = querySnapshot.docs[0].id;

    if (bookInOrderId == null) {
      await bookInOrderCollection.add(bookInOrder);
      _streamController.add(Event());
      return;
    }
    await bookInOrderCollection
        .doc(bookInOrderId)
        .update({'count': cloud_firestore.FieldValue.increment(1)});
    _streamController.add(Event());
  }

  Future<Map<String, BookInOrder>> getBooksInCreatingOrder() async {
    String? orderId = await _dataProvider.getOrderId();
    if (orderId == null) return {};
    Map<String, BookInOrder> result = {};
    final querySnapshot =
        await bookInOrderCollection.where('id_order', isEqualTo: orderId).get();
    for (var doc in querySnapshot.docs) {
      result.addAll({doc.id: doc.data()});
    }
    return result;
  }

  Future<Map<String, BookInOrder>> getBooksInOrder(String orderId) async {
    Map<String, BookInOrder> result = {};
    final querySnapshot =
        await bookInOrderCollection.where('id_order', isEqualTo: orderId).get();
    for (var doc in querySnapshot.docs) {
      result.addAll({doc.id: doc.data()});
    }
    return result;
  }

  Future<void> changeCountBookInOrder(String bookInOrderId, int count) async {
    await bookInOrderCollection.doc(bookInOrderId).update({'count': count});
  }

  Future<void> submitOrder(double price) async {
    String? orderId = await _dataProvider.getOrderId();
    if (orderId == null) return;
    await orderCollection.doc(orderId).update(
      {
        'payment_method': 'Card',
        'date_registration': cloud_firestore.Timestamp.fromDate(DateTime.now()),
        'status': OrderStatus.newOrder.toString(),
        'price': price,
      },
    );
    await _dataProvider.deleteOrderId();
    _streamController.add(Event());
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    await orderCollection.doc(orderId).update({'status': status});
  }

  Future<void> deleteBookInOrder(String bookInOrderId) async {
    await bookInOrderCollection.doc(bookInOrderId).delete();
  }

  void deleteOrderId() async => await _dataProvider.deleteOrderId();

  Future<Map<String, Order>> getOrdersOfCurrentUser(String uid) async {
    Map<String, Order> orders = {};
    final querySnapshot =
        await orderCollection.where('uid', isEqualTo: uid).get();
    for (var doc in querySnapshot.docs) {
      orders.addAll({doc.id: doc.data()});
    }
    return orders;
  }

  Future<Map<String, Order>> getAllOrders() async {
    Map<String, Order> orders = {};
    final querySnapshot = await orderCollection.get();
    for (var doc in querySnapshot.docs) {
      orders.addAll({doc.id: doc.data()});
    }
    return orders;
  }
}
