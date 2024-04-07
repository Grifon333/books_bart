import 'package:books_bart/domain/factories/screen_factory.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  const BottomNavigationBarWidget({super.key});

  @override
  State<BottomNavigationBarWidget> createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  int selectIndex = 0;
  final _screenFactory = ScreenFactory();

  void updateSelectIndex(int value) {
    selectIndex = value;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      appBar: AppBar(
        backgroundColor:
            selectIndex == 0 ? Colors.white : const Color(0xFFF5EEE5),
        leading: IconButton(
          onPressed: () => debugPrint('Menu'),
          icon: const Icon(
            Icons.menu,
            size: 30,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => debugPrint('Notifications'),
            icon: const Icon(
              Icons.notifications,
              size: 30,
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: selectIndex,
        children: [
          _screenFactory.makeHome(),
          _screenFactory.makeFavoriteBooks(),
          const Center(child: Text('Cart')),
          _screenFactory.makeSettings(),
        ],
      ),
      bottomNavigationBar: const SafeArea(
        child: _BottomNavigationBar(),
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: selectIndex == 0 ? const Color(0xFFF5EEE5) : Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
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
