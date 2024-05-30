import 'dart:math';
import 'package:books_bart/domain/factories/screen_factory.dart';
import 'package:books_bart/ui/widgets/bottom_navigation_bar/bottom_navigation_bar_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  const BottomNavigationBarWidget({super.key});

  @override
  State<BottomNavigationBarWidget> createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget>
    with SingleTickerProviderStateMixin {
  late final BottomNavigationBarViewModel _model;
  final _screenFactory = ScreenFactory();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _model = context.read<BottomNavigationBarViewModel>()
      ..addListener(() {
        setState(() {});
      });
    _model.initAnimations(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isOpenSideBar = _model.state.isOpenSideBar;
    final rotateAnimation = _model.state.rotateAnimation;
    final scaleAnimation = _model.state.scaleAnimation;
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
            left: isOpenSideBar ? 0 : -288,
            height: MediaQuery.of(context).size.height,
            child: _screenFactory.makeSideBar(),
          ),
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(rotateAnimation.value -
                  30 * rotateAnimation.value * pi / 180),
            child: Transform.translate(
              offset: Offset(rotateAnimation.value * 265, 0),
              child: Transform.scale(
                scale: scaleAnimation.value,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(24)),
                  child: IndexedStack(
                    index: _model.state.selectPageIndex,
                    children: _model.state.screens,
                  ),
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            left: isOpenSideBar ? 220 : 8,
            top: 56,
            curve: Curves.fastOutSlowIn,
            child: IconButton(
              onPressed: () => _model.onPressedSideBar(_animationController),
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
        offset: Offset(0, 100 * rotateAnimation.value),
        child: const _BottomNavigationBar(),
      ),
    );
  }
}

class _BottomNavigationBar extends StatelessWidget {
  const _BottomNavigationBar();

  @override
  Widget build(BuildContext context) {
    final model = context.watch<BottomNavigationBarViewModel>();
    int selectIndex = model.state.selectPageIndex;
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: model.state.bottomNavigationBarColor,
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
                model.state.icons.length,
                (index) {
                  final isSelect = selectIndex == index;
                  return GestureDetector(
                    onTap: () => model.updatePageIndex(index),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _TopIdentifier(
                          isSelect: isSelect,
                        ),
                        Icon(
                          model.state.icons[index],
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
