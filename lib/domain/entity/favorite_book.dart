import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteBook {
  String uid;
  String idBook;

  FavoriteBook({
    required this.uid,
    required this.idBook,
  });

  factory FavoriteBook.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return FavoriteBook(
      uid: data?['uid'],
      idBook: data?['id_book'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'id_book': idBook,
    };
  }

  @override
  String toString() {
    return 'FavoriteBook {\n'
        'uid: $uid\n'
        'id book: $idBook\n'
        '}';
  }
}
