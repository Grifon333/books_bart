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
  final MainNavigation _mainNavigation;
  final UserRepository _userRepository;
  final OrderRepository _orderRepository;
  final AuthRepository _authRepository;

  SideBarState get state => _state;

  SideBarViewModel(
    this.context, {
    required MainNavigation mainNavigation,
    required UserRepository userRepository,
    required OrderRepository orderRepository,
    required AuthRepository authRepository,
  })  : _mainNavigation = mainNavigation,
        _userRepository = userRepository,
        _orderRepository = orderRepository,
        _authRepository = authRepository {
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
