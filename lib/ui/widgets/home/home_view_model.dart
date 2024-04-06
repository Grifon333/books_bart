import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  final BuildContext context;

  HomeViewModel(this.context);
}

class BookInfo {
  String imageUrl;
  String title;
  String author;

  BookInfo({
    this.imageUrl =
        '''https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.amazon.co.uk%2
        FEmpty-Akshay-Gupta-ebook%2Fdp%2FB095VJKVWJ&psig=AOvVaw1Hjt4guj1Eus4puv
        Olywuu&ust=1712387137095000&source=images&cd=vfe&opi=89978449&ved=0CBIQ
        jRxqFwoTCMCJ07fBqoUDFQAAAAAdAAAAABAE''',
    required this.title,
    required this.author,
  });
}
