import 'package:books_bart/ui/widgets/app/app.dart';
import 'package:books_bart/ui/widgets/bottom_navigation_bar/bottom_navigation_bar_widget.dart';
import 'package:books_bart/ui/widgets/login/login.dart';
import 'package:flutter/widgets.dart';

List<Page<dynamic>> onGenerateAppViewPages(
  AppStatus state,
  List<Page<dynamic>> pages,
) =>
    switch (state) {
      AppStatus.authenticated => [BottomNavigationBarWidget.page()],
      AppStatus.unauthenticated => [LoginPage.page()],
    };
