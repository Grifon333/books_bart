import 'package:books_bart/ui/navigation/main_navigation.dart';
import 'package:flutter/material.dart';

class SideBarViewModel extends ChangeNotifier {
  final BuildContext context;
  final MainNavigation _mainNavigation = MainNavigation();

  SideBarViewModel(this.context);

  onShowProfile() {
    _mainNavigation.goToProfileScreen(context);
  }
}