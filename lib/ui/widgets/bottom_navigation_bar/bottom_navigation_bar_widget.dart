import 'dart:math';

import 'package:books_bart/domain/factories/screen_factory.dart';
import 'package:books_bart/ui/widgets/sidebar/side_bar_widget.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  const BottomNavigationBarWidget({super.key});

  @override
  State<BottomNavigationBarWidget> createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget>
    with SingleTickerProviderStateMixin {
  int selectIndex = 0;
  bool _isOpenSideBar = false;
  final _screenFactory = ScreenFactory();
  late AnimationController _animationController;
  late Animation<double> _animation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addListener(() {
        setState(() {});
      });
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );
    _scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void updateSelectIndex(int value) {
    selectIndex = value;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      backgroundColor: const Color(0xFF7E675E),
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            width: 288,
            left: _isOpenSideBar ? 0 : -288,
            height: MediaQuery.of(context).size.height,
            child: const SideBarWidget(),
          ),
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(_animation.value - 30 * _animation.value * pi / 180),
            child: Transform.translate(
              offset: Offset(_animation.value * 265, 0),
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(24)),
                  child: IndexedStack(
                    index: selectIndex,
                    children: [
                      _screenFactory.makeHome(),
                      _screenFactory.makeFavoriteBooks(),
                      const Center(child: Text('Cart')),
                      _screenFactory.makeSettings(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            left: _isOpenSideBar ? 220 : 8,
            top: 56,
            curve: Curves.fastOutSlowIn,
            child: IconButton(
              onPressed: () {
                if (_isOpenSideBar) {
                  _animationController.reverse();
                } else {
                  _animationController.forward();
                }
                setState(() {
                  _isOpenSideBar = !_isOpenSideBar;
                });
              },
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.white),
              ),
              icon: const Icon(
                Icons.menu,
                size: 32,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Transform.translate(
        offset: Offset(0, 100 * _animation.value),
        child: const _BottomNavigationBar(),
      ),
    );
  }
}

class _BottomNavigationBar extends StatefulWidget {
  const _BottomNavigationBar();

  @override
  State<_BottomNavigationBar> createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<_BottomNavigationBar> {
  final icons = [
    Icons.book,
    Icons.bookmark,
    Icons.shopping_cart,
    Icons.settings,
  ];
  _BottomNavigationBarWidgetState? model;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    model = context.findAncestorStateOfType<_BottomNavigationBarWidgetState>();
  }

  @override
  Widget build(BuildContext context) {
    int selectIndex = model?.selectIndex ?? 0;
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: selectIndex == 0 ? const Color(0xFFF5EEE5) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ...List.generate(
                icons.length,
                (index) {
                  final isSelect = selectIndex == index;
                  return GestureDetector(
                    onTap: () {
                      if (index == selectIndex) return;
                      selectIndex = index;
                      debugPrint('Tap $index');
                      model?.updateSelectIndex(index);
                      setState(() {});
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _TopIdentifier(
                          isSelect: isSelect,
                        ),
                        Icon(
                          icons[index],
                          size: 32,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopIdentifier extends StatelessWidget {
  final bool isSelect;

  const _TopIdentifier({
    required this.isSelect,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 4,
      width: isSelect ? 20 : 0,
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF7E675E),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
