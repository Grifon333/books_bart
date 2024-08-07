import 'package:cloud_firestore/cloud_firestore.dart';

class BookInOrder {
  String idOrder;
  int count;
  String idVariantOfBook;
  String idBook;

  BookInOrder({
    required this.idOrder,
    required this.count,
    required this.idVariantOfBook,
    required this.idBook,
  });

  factory BookInOrder.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return BookInOrder(
      idOrder: data?['id_order'],
      count: data?['count'],
      idVariantOfBook: data?['id_variant_of_book'],
      idBook: data?['id_book'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id_order': idOrder,
      'count': count,
      'id_variant_of_book': idVariantOfBook,
      'id_book': idBook,
    };
  }

  @override
  String toString() {
    return 'BookInOrder {\n'
        'id order: $idOrder\n'
        'count: $count\n'
        'id variant of book: $idVariantOfBook\n'
        'id book: $idBook\n'
        '}';
  }
}
