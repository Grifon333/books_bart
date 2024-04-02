import 'package:books_bart/ui/navigation/main_navigation.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  static final _mainNavigation = MainNavigation();
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: _mainNavigation.initialRoute,
      routes: _mainNavigation.routes,
      onGenerateRoute: _mainNavigation.onGenerateRoute,
    );
  }
}
