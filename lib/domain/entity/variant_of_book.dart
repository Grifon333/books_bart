import 'package:cloud_firestore/cloud_firestore.dart';

class VariantOfBook {
  int? count;
  String format;
  String language;
  double price;
  String publisher;
  String? bindingType;
  int yearPublication;
  String idBook;

  VariantOfBook({
    this.count,
    required this.format,
    required this.language,
    required this.price,
    required this.publisher,
    this.bindingType,
    required this.yearPublication,
    required this.idBook,
  });

  factory VariantOfBook.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return VariantOfBook(
      count: data?['count'],
      format: data?['format'],
      language: data?['language'],
      price: data?['price'],
      publisher: data?['publisher'],
      bindingType: data?['binding_type'],
      yearPublication: data?['year_publication'],
      idBook: data?['id_book'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (count != null) 'count': count,
      'format': format,
      'language': language,
      'price': price,
      'publisher': publisher,
      if (bindingType != null) 'binding_type': bindingType,
      'year_publication': yearPublication,
      'id_book': idBook,
    };
  }

  @override
  String toString() {
    return 'VariantOfBook {\n'
        'count: $count\n'
        'format: $format\n'
        'language: $language\n'
        'price: $price\n'
        'publisher: $publisher\n'
        'id book: $idBook\n'
        'binding type: $bindingType\n'
        'id book: $idBook\n'
        '}';
  }
}
