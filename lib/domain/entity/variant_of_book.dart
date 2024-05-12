import 'package:cloud_firestore/cloud_firestore.dart';

class VariantOfBook {
  String format;
  int? count;
  String language;
  double price;
  String publisher;
  String? bindingType;
  int yearPublication;

  VariantOfBook({
    required this.format,
    this.count,
    required this.language,
    required this.price,
    required this.publisher,
    this.bindingType,
    required this.yearPublication,
  });

  factory VariantOfBook.empty() {
    return VariantOfBook(
      format: '',
      language: '',
      price: 0,
      publisher: '',
      yearPublication: 0,
    );
  }

  factory VariantOfBook.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return VariantOfBook(
      format: data?['format'],
      count: data?['count'],
      language: data?['language'],
      price: data?['price'],
      publisher: data?['publisher'],
      bindingType: data?['binding_type'],
      yearPublication: data?['year_publication'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'format': format,
      if (count != null) 'count': count,
      'language': language,
      'price': price,
      'publisher': publisher,
      if (bindingType != null) 'binding_type': bindingType,
      'year_publication': yearPublication,
    };
  }

  VariantOfBook copyWith({
    String? format,
    int? count,
    String? language,
    double? price,
    String? publisher,
    String? bindingType,
    int? yearPublication,
  }) {
    return VariantOfBook(
      format: format ?? this.format,
      language: language ?? this.language,
      price: price ?? this.price,
      publisher: publisher ?? this.publisher,
      yearPublication: yearPublication ?? this.yearPublication,
    );
  }

  @override
  String toString() {
    return 'VariantOfBook {\n'
        'format: $format\n'
        'count: $count\n'
        'language: $language\n'
        'price: $price\n'
        'publisher: $publisher\n'
        'binding type: $bindingType\n'
        'year publication: $yearPublication\n'
        '}';
  }
}
