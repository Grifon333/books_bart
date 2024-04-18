import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String title;
  final String authors;
  final int countPage;
  final String description;
  final String category;
  final Map<String, int> rating;

  static const Map<String, int> _emptyRating = {
    '1': 0,
    '2': 0,
    '3': 0,
    '4': 0,
    '5': 0
  };

  Book({
    required this.title,
    required this.authors,
    required this.countPage,
    required this.description,
    required this.category,
    this.rating = _emptyRating,
  });

  factory Book.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    final ratingData = (data?['rating'] is Map<String, int>)
        ? Map.from(data?['rating']) as Map<String, int>
        : _emptyRating;

    return Book(
      title: data?['title'],
      authors: data?['authors'],
      countPage: data?['count_page'],
      description: data?['description'],
      category: data?['category'],
      rating: ratingData,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'authors': authors,
      'count_page': countPage,
      'description': description,
      'category': category,
      'rating': rating,
    };
  }

  @override
  String toString() {
    return 'Book {\n'
        'title: $title\n'
        'authors: $authors,\n'
        'countPage: $countPage,\n'
        'description: $description,\n'
        'category: $category,\n'
        'rating: $rating,\n'
        '}';
  }
}
