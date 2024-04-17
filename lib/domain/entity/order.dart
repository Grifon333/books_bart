import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  String uid;
  DateTime dateRegistration;
  int price;
  String paymentMethod;
  String status;

  Order({
    required this.uid,
    required this.dateRegistration,
    required this.price,
    required this.paymentMethod,
    required this.status,
  });

  factory Order.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Order(
      uid: data?['uid'],
      dateRegistration: data?['date_registration'],
      price: data?['price'],
      paymentMethod: data?['payment_method'],
      status: data?['status'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'date_registration': dateRegistration,
      'price': price,
      'payment_method': paymentMethod,
      'status': status,
    };
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
