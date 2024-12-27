import 'package:books_bart/domain/factories/screen_factory.dart';
import 'package:flutter/material.dart';

class SideBarViewModel extends ChangeNotifier {
  final BuildContext context;
  final ScreenFactory _screenFactory = ScreenFactory();

  SideBarViewModel(this.context);

  void onShowProfile() {
    Navigator.of(context).push<void>(MaterialPageRoute<void>(
      builder: (context) => _screenFactory.makeProfile(),
    ));
  }

  // TODO:
  // Future<void> onPressedLogout() async {
  //   await _authRepository.logout();
  //   await _orderRepository.deleteOrderId();
  //   if (!context.mounted) return;
  //   _mainNavigation.goToLoginScreen(context);
  // }

  void onPressedHistory() {
    Navigator.of(context).push<void>(MaterialPageRoute<void>(
      builder: (context) => _screenFactory.makeHistory(),
    ));
  }
}
