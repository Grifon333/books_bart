import 'package:books_bart/ui/widgets/home/home_view_model.dart';
import 'package:flutter/material.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        bottom: false,
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
        SizedBox(height: 48),
        _TitleWidget(),
        SizedBox(height: 24),
        _SearchWidget(),
        // SizedBox(height: 36),
        // _GenreListWidget(),
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
    String name = 'John';
    return Text(
      'Hello $name!\nWhich book do you want to buy?',
      style: const TextStyle(
        fontSize: 24,
        color: Color(0xFF7E675E),
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _SearchWidget extends StatelessWidget {
  const _SearchWidget();

  void onChanged(String value) => debugPrint(value);

  void onPressed() => debugPrint('Filter');

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
          Expanded(
            child: TextField(
              onChanged: onChanged,
              decoration: const InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search, size: 24),
              ),
            ),
          ),
          IconButton(
            onPressed: onPressed,
            icon: const Icon(Icons.filter_alt),
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
    final List<String> genresList = [
      'All',
      'eBooks',
      'New',
      'Bestseller',
      'Audiobooks',
      'Fantasy',
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
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

  void onPressed() {
    debugPrint('Group: $title');
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: const ButtonStyle(
        minimumSize: MaterialStatePropertyAll(Size(0, 0)),
        padding: MaterialStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        ),
      ),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}

class _ListBookGroupsWidget extends StatelessWidget {
  const _ListBookGroupsWidget();

  @override
  Widget build(BuildContext context) {
    final List<String> groupsTitle = [
      'Popular',
      'Fiction',
      'Health',
      'Finance',
    ];
    return Expanded(
      child: ListView.separated(
        itemBuilder: (BuildContext context, int index) =>
            _ListBooksInGroupWidget(groupsTitle[index]),
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(height: 16),
        itemCount: groupsTitle.length,
      ),
    );
  }
}

class _ListBooksInGroupWidget extends StatelessWidget {
  final String groupName;

  const _ListBooksInGroupWidget(this.groupName);

  void onPressed() {
    debugPrint('See all: $groupName');
  }

  @override
  Widget build(BuildContext context) {
    final List<BookInfo> booksInfo = [
      BookInfo(title: 'Book1', author: 'Author1'),
      BookInfo(title: 'Book2', author: 'Author2'),
      BookInfo(title: 'Book3', author: 'Author3'),
      BookInfo(title: 'Book4', author: 'Author4'),
      BookInfo(title: 'Book5', author: 'Author5'),
    ];
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
                fontWeight: FontWeight.w700,
              ),
            ),
            TextButton(
              onPressed: onPressed,
              child: const Text('See all ->'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < booksInfo.length; i++)
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: _BookTileWidget(booksInfo[i]),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BookTileWidget extends StatelessWidget {
  final BookInfo _bookInfo;

  const _BookTileWidget(
    this._bookInfo,
  );

  void onTap() {
    debugPrint('Title: ${_bookInfo.title}, author: ${_bookInfo.author}');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 104,
        child: Column(
          children: [
            // Image.network(
            //   _bookInfo.imageUrl,
            //   fit: BoxFit.fitWidth,
            // ),
            const SizedBox(
              height: 160,
              width: 104,
              child: ColoredBox(color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              _bookInfo.title,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF7E675E),
              ),
            ),
            Text(
              _bookInfo.author,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFFF06267),
              ),
            )
          ],
        ),
      ),
    );
  }
}
