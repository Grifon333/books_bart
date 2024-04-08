import 'package:flutter/material.dart';

class CartViewModel extends ChangeNotifier {
  final BuildContext context;

  CartViewModel(this.context);
}

class BookInfo {
  String title;
  String author;
  String price;

  BookInfo({
    required this.title,
    required this.author,
    required this.price,
  });
}