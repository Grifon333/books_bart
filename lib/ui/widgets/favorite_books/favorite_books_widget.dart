import 'package:flutter/material.dart';

class FavoriteBooksWidget extends StatelessWidget {
  const FavoriteBooksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EEE5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5EEE5),
        leading: IconButton(
          onPressed: () {
            debugPrint('Menu');
          },
          icon: const Icon(Icons.menu),
        ),
        actions: [
          IconButton(
            onPressed: () {
              debugPrint('Notifications');
            },
            icon: const Icon(Icons.notifications),
          ),
        ],
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: _BodyWidget(),
        ),
      ),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _TitleWidget(),
        SizedBox(height: 16),
        _BooksListWidget(),
      ],
    );
  }
}

class _TitleWidget extends StatelessWidget {
  const _TitleWidget();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Favorite books',
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: Color(0xFF7E675E),
      ),
    );
  }
}

class _BooksListWidget extends StatelessWidget {
  const _BooksListWidget();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        itemBuilder: (context, index) => const _BookCartWidget(),
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemCount: 5,
      ),
    );
  }
}

class _BookCartWidget extends StatelessWidget {
  const _BookCartWidget();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 4,
            )
          ],
        ),
        child: const SizedBox(
          height: 152,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Stack(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 78,
                      height: 120,
                      child: ColoredBox(color: Colors.grey),
                    ),
                    SizedBox(width: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Book title',
                          style: TextStyle(
                            color: Color(0xFF7E675E),
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Author',
                          style: TextStyle(
                            color: Color(0xFFF06267),
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.star),
                            Icon(Icons.star),
                            Icon(Icons.star),
                            Icon(Icons.star),
                            Icon(Icons.star_outline),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Icon(
                    Icons.favorite,
                    color: Colors.redAccent,
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Text(
                    '\$30.50',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF607F9D),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
