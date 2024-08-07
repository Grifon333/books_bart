import 'package:books_bart/domain/repositories/auth_repository.dart';
import 'package:books_bart/domain/repositories/order_repository.dart';
import 'package:books_bart/domain/repositories/user_repository.dart';
import 'package:books_bart/ui/navigation/main_navigation.dart';
import 'package:flutter/material.dart';

class SideBarState {
  String nickname = '';
}

class SideBarViewModel extends ChangeNotifier {
  final BuildContext context;
  final SideBarState _state = SideBarState();
  final MainNavigation _mainNavigation = MainNavigation();
  final UserRepository _userRepository = UserRepository();
  final OrderRepository _orderRepository = OrderRepository();
  final AuthRepository _authRepository = AuthRepository();

  SideBarState get state => _state;

  SideBarViewModel(this.context) {
    _init();
  }

  Future<void> _init() async {
    final user = await _userRepository.getCurrentUserData();
    _state.nickname = user.name ?? 'User';
    notifyListeners();
  }

  void onShowProfile() {
    _mainNavigation.goToProfileScreen(context);
  }

  Future<void> onPressedLogout() async {
    await _authRepository.logout();
    await _orderRepository.deleteOrderId();
    if (!context.mounted) return;
    _mainNavigation.goToLoginScreen(context);
  }

  Future<void> onPressedHistory() async {
    _onGoHistoryScreen();
  }

  void _onGoHistoryScreen() {
    _mainNavigation.goToHistoryScreen(context);
  }
}
