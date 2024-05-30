import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

List<Color> _colors = [
  Colors.red,
  Colors.blue,
  Colors.yellow,
  Colors.green,
  Colors.teal,
  Colors.grey,
];

enum OrderStatus {
  creating,
  newOrder, // Red
  confirmed, // Blue
  processing, // Yellow
  assembled, // Green
  delivered, // Teal
  completed; // Grey

  @override
  String toString() {
    if (index == 1) return 'new';
    return name;
  }

  Color getColor() {
    return _colors[index - 1];
  }

  factory OrderStatus.fromString(String str) {
    if (str == 'new') return OrderStatus.newOrder;
    for (OrderStatus element in OrderStatus.values) {
      if (element.toString() == str) return element;
    }
    return OrderStatus.newOrder;
  }

  int compareTo(OrderStatus other) {
    return index - other.index;
  }
}

class Order {
  String uid;
  DateTime? dateRegistration;
  double price;
  String? paymentMethod;
  OrderStatus status;

  Order({
    required this.uid,
    this.dateRegistration,
    required this.price,
    this.paymentMethod,
    required this.status,
  });

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
}
