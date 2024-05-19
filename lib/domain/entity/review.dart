import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  String body;
  int rating;
  String username;
  String idBook;

  Review({
    required this.body,
    required this.rating,
    required this.username,
    required this.idBook,
  });

  factory Review.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Review(
      body: data?['body'],
      rating: data?['rating'],
      username: data?['username'],
      idBook: data?['id_book'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'body': body,
      'rating': rating,
      'username': username,
      'id_book': idBook,
    };
  }

  @override
  String toString() {
    return 'Review {\n'
        'body: $body\n'
        'rating: $rating\n'
        'username: $username\n'
        'id book: $idBook\n'
        '}';
  }
}
