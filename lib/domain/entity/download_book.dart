import 'package:cloud_firestore/cloud_firestore.dart';

class DownloadBook {
  String uid;
  String idBook;

  DownloadBook({
    required this.uid,
    required this.idBook,
  });

  factory DownloadBook.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return DownloadBook(
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
    return 'DownloadBook {\n'
        'uid: $uid\n'
        'id book: $idBook\n'
        '}';
  }
}