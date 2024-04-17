import 'package:cloud_firestore/cloud_firestore.dart';

class History {
  String uid;
  List<String> orders;

  History({
    required this.uid,
    required this.orders,
  });

  factory History.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return History(
      uid: data?['uid'],
      orders: data?['orders'] is Iterable ? List.from(data?['orders']) : [],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'orders': orders,
    };
  }

  @override
  String toString() {
    return 'History {\n'
        'uid: $uid\n'
        'orders: $orders\n'
        '}';
  }
}
