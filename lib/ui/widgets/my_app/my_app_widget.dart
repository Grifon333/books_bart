import 'package:books_bart/ui/navigation/main_navigation.dart';
import 'package:books_bart/ui/theme/main_theme.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  static final _mainNavigation = MainNavigation();
  static final _mainTheme = MainTheme();

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: _mainTheme.themeData,
      initialRoute: _mainNavigation.initialRoute,
      routes: _mainNavigation.routes,
      onGenerateRoute: _mainNavigation.onGenerateRoute,
    );
  }
}
