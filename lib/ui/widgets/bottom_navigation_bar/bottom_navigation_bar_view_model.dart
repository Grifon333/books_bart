import 'package:books_bart/domain/factories/screen_factory.dart';
import 'package:books_bart/domain/repositories/user_repository.dart';
import 'package:flutter/material.dart';

class BottomNavigationState {
  int selectPageIndex = 0;
  Color bottomNavigationBarColor = const Color(0xFFF5EEE5);
  bool isOpenSideBar = false;
  List<IconData> icons = [];
  List<Widget> screens = [];
  late Animation<double> rotateAnimation;
  late Animation<double> scaleAnimation;
}

class BottomNavigationBarViewModel extends ChangeNotifier {
  final BuildContext context;
  final BottomNavigationState _state = BottomNavigationState();
  final ScreenFactory _screenFactory = ScreenFactory();
  final UserRepository _userRepository;

  BottomNavigationState get state => _state;

  BottomNavigationBarViewModel(
    this.context, {
    required UserRepository userRepository,
  }) : _userRepository = userRepository {
    _init();
  }

  Future<void> _init() async {
    if (_state.icons.isNotEmpty) return;
    String role = await _userRepository.getRole();
    if (role == 'customer') {
      _state.icons.addAll([
        Icons.book,
        Icons.bookmark,
        Icons.shopping_cart,
        Icons.settings,
      ]);
      _state.screens.addAll([
        _screenFactory.makeHome(),
        _screenFactory.makeFavoriteBooks(),
        _screenFactory.makeCart(),
        _screenFactory.makeSettings(),
      ]);
    } else if (role == 'manager') {
      _state.icons.addAll([
        Icons.book,
        Icons.add,
        Icons.bookmark,
        Icons.shopping_cart,
        Icons.settings,
      ]);
      _state.screens.addAll([
        _screenFactory.makeHome(),
        _screenFactory.makeBookHandling(),
        _screenFactory.makeFavoriteBooks(),
        _screenFactory.makeCart(),
        _screenFactory.makeSettings(),
      ]);
    }
    notifyListeners();
  }

  void initAnimations(AnimationController animationController) {
    _state.rotateAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );
    _state.scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );
  }

  void updatePageIndex(int index) {
    if (_state.selectPageIndex == index) return;
    _state.selectPageIndex = index;
    if (index == 0) {
      _state.bottomNavigationBarColor = const Color(0xFFF5EEE5);
    } else {
      _state.bottomNavigationBarColor = Colors.white;
    }
    notifyListeners();
  }

  void onPressedSideBar(AnimationController animationController) {
    if (_state.isOpenSideBar) {
      animationController.reverse();
    } else {
      animationController.forward();
    }
    _state.isOpenSideBar ^= true;
    notifyListeners();
  }
}
