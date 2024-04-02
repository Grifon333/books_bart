import 'package:books_bart/ui/widgets/home/home_view_model.dart';
import 'package:books_bart/ui/widgets/home/home_widget.dart';
import 'package:books_bart/ui/widgets/loader/loader_view_model.dart';
import 'package:books_bart/ui/widgets/loader/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScreenFactory {
  Widget makeLoader() {
    return Provider(
      create: (context) => LoaderViewModel(context),
      child: const LoaderWidget(),
    );
  }

  Widget makeHome() {
    return ChangeNotifierProvider(
      create: (context) => HomeViewModel(context),
      child: const HomeWidget(),
    );
  }
}
