import 'package:books_bart/ui/navigation/main_navigation.dart';
import 'package:flutter/material.dart';

class BookDetailsViewModel extends ChangeNotifier {
  final BuildContext context;
  final String bookId;
  final MainNavigation _mainNavigation = MainNavigation();

  BookDetailsViewModel(
    this.context,
    this.bookId,
  ) {
    _init();
  }

  Future<void> _init() async {
    notifyListeners();
  }

  void onPressedReturn() {
    _mainNavigation.popFromBookDetailsScreen(context);
  }
}
