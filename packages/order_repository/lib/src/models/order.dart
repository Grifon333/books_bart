import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum OrderStatus {
  creating,
  newOrder,
  confirmed,
  processing,
  assembled,
  delivered,
  completed;

  @override
  String toString() => index == 1 ? 'new' : name;

  factory OrderStatus.fromString(String str) {
    if (str == 'new') return OrderStatus.newOrder;
    for (OrderStatus element in OrderStatus.values) {
      if (element.toString() == str) return element;
    }
    return OrderStatus.newOrder;
  }

  int compareTo(OrderStatus other) => index - other.index;
}

class Order extends Equatable {
  final String uid;
  final DateTime? dateRegistration;
  final double price;
  final String? paymentMethod;
  final OrderStatus status;

  const Order({
    required this.uid,
    this.dateRegistration,
    required this.price,
    this.paymentMethod,
    required this.status,
  });

  const Order._()
      : uid = '',
        dateRegistration = null,
        price = 0,
        paymentMethod = null,
        status = OrderStatus.creating;

  const factory Order.empty() = Order._;

  factory Order.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Order(
      uid: data?['uid'],
      dateRegistration: (data?['date_registration'] as Timestamp?)?.toDate(),
      price: data?['price'],
      paymentMethod: data?['payment_method'],
      status: OrderStatus.fromString(data?['status']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'date_registration': dateRegistration,
      'price': price,
      'payment_method': paymentMethod,
      'status': status.toString(),
    };
  }

  int compareTo(Order other) {
    int compareStatus = status.compareTo(other.status);
    if (compareStatus != 0) return compareStatus;
    return dateRegistration!.compareTo(other.dateRegistration!);
  }

  @override
  String toString() {
    return 'Order {\n'
        'uid: $uid\n'
        'date registration: $dateRegistration'
        'price: $price'
        'payment method: $paymentMethod'
        'status: $status'
        '}';
  }

  @override
  List<Object?> get props =>
      [uid, dateRegistration, price, paymentMethod, status];

  Order copyWith({
    String? uid,
    DateTime? dateRegistration,
    double? price,
    String? paymentMethod,
    OrderStatus? status,
  }) {
    return Order(
      uid: uid ?? this.uid,
      dateRegistration: dateRegistration ?? this.dateRegistration,
      price: price ?? this.price,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
    );
  }
}
