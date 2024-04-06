import 'package:flutter/material.dart';

class FavoriteBooksViewModel extends ChangeNotifier {
  final BuildContext context;

  FavoriteBooksViewModel(this.context);
}

class BookInfo {
  String title;
  String author;
  int rating;
  bool isFavorite;
  String price;

  BookInfo({
    required this.title,
    required this.author,
    required this.rating,
    this.isFavorite = true,
    required this.price,
  });
}
