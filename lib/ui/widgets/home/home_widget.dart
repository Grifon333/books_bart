import 'package:books_bart/ui/widgets/home/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    bool isSearch = context.watch<HomeViewModel>().state.isFiltered;
    return Column(
      children: [
        const SizedBox(height: 48),
        const _TitleWidget(),
        const SizedBox(height: 24),
        const _SearchWidget(),
        // SizedBox(height: 36),
        // _GenreListWidget(),
        const SizedBox(height: 24),
        isSearch
            ? const _FilteredListBooksWidget()
            : const _ListBookGroupsWidget(),
      ],
    );
  }
}

class _FilteredListBooksWidget extends StatelessWidget {
  const _FilteredListBooksWidget();

  @override
  Widget build(BuildContext context) {
    final model = context.watch<HomeViewModel>();
    final books = model.state.filteredBooks;
    if (books.isEmpty) return const SizedBox.shrink();
    List<List<BookInfo>> grid = List.generate(
      (books.length + 1) ~/ 2,
      (index) => [],
    );
    int rowIndex = 0;
    for (int index = 0; index < books.length; index += 3) {
      grid[rowIndex].add(books[index]);
      if (index + 1 < books.length) {
        grid[rowIndex].add(books[index + 1]);
      }
      if (index + 2 < books.length) {
        grid[rowIndex].add(books[index + 2]);
      }
      rowIndex++;
    }
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (model.state.canReturn)
                TextButton(
                  onPressed: model.onPressedShowAllBooks,
                  child: const Text(
                    '← show all',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: grid
                    .map(
                      (row) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: row.map((el) => _BookTileWidget(el)).toList(),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
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

  void onPressed() => debugPrint('Filter');

  @override
  Widget build(BuildContext context) {
    final model = context.read<HomeViewModel>();
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
              onChanged: model.onChangeSearchTitle,
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
    final model = context.watch<HomeViewModel>();
    final List<String> groupsTitle = model.state.books.keys.toList();
    return Expanded(
      child: RefreshIndicator(
        onRefresh: model.onRefresh,
        child: ListView.separated(
          itemBuilder: (BuildContext context, int index) =>
              _ListBooksInGroupWidget(groupsTitle[index]),
          separatorBuilder: (BuildContext context, int index) =>
              const SizedBox(height: 16),
          itemCount: groupsTitle.length,
        ),
      ),
    );
  }
}

class _ListBooksInGroupWidget extends StatelessWidget {
  final String groupName;

  const _ListBooksInGroupWidget(this.groupName);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<HomeViewModel>();
    final List<BookInfo> booksInfo = model.state.books[groupName] ?? [];
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
              onPressed: () => model.onPressedBookCategory(groupName),
              child: const Text('See more →'),
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

  @override
  Widget build(BuildContext context) {
    final model = context.read<HomeViewModel>();
    return GestureDetector(
      onTap: () => model.onTapBookInfo(_bookInfo.id),
      child: SizedBox(
        width: 100,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 100,
              height: 180,
              child: Image.network(
                _bookInfo.imageUrl,
                fit: BoxFit.fitWidth,
                errorBuilder: (context, error, _) => Image.network(
                  'https://edit.org/images/cat/book-covers-big-2019101610.jpg',
                ),
              ),
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
              _bookInfo.authors,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFFF06267),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
