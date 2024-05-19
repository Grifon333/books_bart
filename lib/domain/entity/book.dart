import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  String title;
  String authors;
  int countPage;
  String description;
  String category;
  String imageURL;
  Map<int, int> rating;

  static const Map<int, int> _emptyRating = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};

  Book({
    required this.title,
    required this.authors,
    required this.countPage,
    required this.description,
    required this.category,
    this.imageURL =
        'https://edit.org/images/cat/book-covers-big-2019101610.jpg',
    this.rating = _emptyRating,
  });

  factory Book.empty() {
    return Book(
      title: '',
      authors: '',
      countPage: 0,
      description: '',
      category: '',
    );
  }

  factory Book.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    final ratingData = data?['rating'] as Map<String, dynamic>;
    final Map<int, int> rating = ratingData.map(
      (key, value) => MapEntry(
        int.tryParse(key.toString()) ?? 0,
        int.tryParse(value.toString()) ?? 0,
      ),
    );
    return Book(
      title: data?['title'],
      authors: data?['authors'],
      countPage: data?['count_page'],
      description: data?['description'],
      category: data?['category'],
      imageURL: data?['image_url'] ??
          'https://edit.org/images/cat/book-covers-big-2019101610.jpg',
      rating: rating,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'authors': authors,
      'count_page': countPage,
      'description': description,
      'category': category,
      'image_url': imageURL,
      'rating': rating.map((key, value) => MapEntry(key.toString(), value)),
    };
  }

  Book copyWith({
    String? title,
    String? authors,
    int? countPage,
    String? description,
    String? category,
    String? imageURL,
    Map<int, int>? rating,
  }) {
    return Book(
      title: title ?? this.title,
      authors: authors ?? this.authors,
      countPage: countPage ?? this.countPage,
      description: description ?? this.description,
      category: category ?? this.category,
      imageURL: imageURL ?? this.imageURL,
      rating: rating ?? this.rating,
    );
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
