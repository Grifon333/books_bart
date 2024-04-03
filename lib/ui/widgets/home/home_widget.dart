import 'package:flutter/material.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        SizedBox(height: 24),
        _SearchWidget(),
        SizedBox(height: 36),
        _GenreListWidget(),
        SizedBox(height: 24),
        _ListBookGroupsWidget(),
      ],
    );
  }
}

class _TitleWidget extends StatelessWidget {
  const _TitleWidget();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Hello John!\nWhich book do you want to buy?',
      style: TextStyle(
        fontSize: 24,
        color: Color(0xFF7E675E),
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _SearchWidget extends StatelessWidget {
  const _SearchWidget();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFF5EEE5),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 4,
          )
        ],
      ),
      child: Row(
        children: [
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Color(0xFF7E675E),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              debugPrint('Filter');
            },
            icon: const Icon(Icons.filter_alt),
            color: const Color(0xFF7E675E),
          ),
        ],
      ),
    );
  }
}

class _GenreListWidget extends StatelessWidget {
  const _GenreListWidget();

  @override
  Widget build(BuildContext context) {
    const List<String> genresList = [
      'All',
      'eBooks',
      'New',
      'Bestseller',
      'Audiobooks'
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (int i = 0; i < genresList.length; i++)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: _GenreTileWidget(genresList[i]),
            ),
        ],
      ),
    );
  }
}

class _GenreTileWidget extends StatelessWidget {
  final String title;

  const _GenreTileWidget(this.title);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        debugPrint('Select genre: $title');
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFF7E675E),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 6,
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF7E675E),
            ),
          ),
        ),
      ),
    );
  }
}

class _ListBookGroupsWidget extends StatelessWidget {
  const _ListBookGroupsWidget();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: const [
          _ListBooksInGroupWidget('Popular'),
          SizedBox(height: 16),
          _ListBooksInGroupWidget('Fiction'),
          SizedBox(height: 16),
          _ListBooksInGroupWidget('Health'),
        ],
      ),
    );
  }
}

class _ListBooksInGroupWidget extends StatelessWidget {
  final String groupName;

  const _ListBooksInGroupWidget(this.groupName);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              groupName,
              style: const TextStyle(
                  color: Color(0xFF7E675E),
                  fontSize: 24,
                  fontWeight: FontWeight.w700),
            ),
            TextButton(
              onPressed: () {
                debugPrint('See all: $groupName');
              },
              child: const Text(
                'See all ->',
                style: TextStyle(
                  color: Color(0xFF7E675E),
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _BookTileWidget('Book title', 'Author'),
              SizedBox(width: 16),
              _BookTileWidget('Book title', 'Author'),
              SizedBox(width: 16),
              _BookTileWidget('Book title tttttttttttabcdefghij', 'Author'),
              SizedBox(width: 16),
              _BookTileWidget('Book title', 'Author'),
              SizedBox(width: 16),
              _BookTileWidget('Book title', 'Author'),
              SizedBox(width: 16),
              _BookTileWidget('Book title', 'Author'),
            ],
          ),
        ),
      ],
    );
  }
}

class _BookTileWidget extends StatelessWidget {
  final String _title;
  final String _author;

  const _BookTileWidget(
    this._title,
    this._author,
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 104,
      child: Column(
        children: [
          const SizedBox(
            height: 160,
            width: 104,
            child: ColoredBox(color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            _title,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF7E675E),
            ),
          ),
          Text(
            _author,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFFF06267),
            ),
          )
        ],
      ),
    );
  }
}
