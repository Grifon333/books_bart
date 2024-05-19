import 'package:books_bart/ui/widgets/favorite_books/favorite_books_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class FavoriteBooksWidget extends StatelessWidget {
  const FavoriteBooksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF5EEE5),
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
    final model = context.read<FavoriteBooksViewModel>();
    return RefreshIndicator(
      onRefresh: model.onRefresh,
      child: ListView(
        children: const [
          _TitleWidget(),
          SizedBox(height: 16),
          _BooksListWidget(),
        ],
      ),
    );
  }
}

class _TitleWidget extends StatelessWidget {
  const _TitleWidget();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Favorite books',
      textAlign: TextAlign.center,
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
    final model = context.watch<FavoriteBooksViewModel>();
    List<BookInfo> books = model.state.books;
    return books.isEmpty
        ? const _EmptyListWidget()
        : Column(
            children: List.generate(
              books.length,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _BookCartWidget(index),
              ),
            ),
          );
  }
}

class _BookCartWidget extends StatelessWidget {
  final int index;

  const _BookCartWidget(this.index);

  @override
  Widget build(BuildContext context) {
    final model = context.read<FavoriteBooksViewModel>();
    final book = model.state.books[index];
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => model.onTapDelete(index),
            foregroundColor: Colors.red,
            backgroundColor: const Color(0xFFF5EEE5),
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 4,
              )
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              onTap: () => model.onTapFavoriteBook(index),
              child: SizedBox(
                height: 160,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 80,
                            height: 128,
                            child: Image.network(book.imageURL),
                          ),
                          const SizedBox(width: 24),
                          SizedBox(
                            width: 200,
                            child: _MainBookInfoWidget(book),
                          )
                        ],
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: _FavoriteButtonWidget(book.isFavorite),
                      ),
                      // Positioned(
                      //   right: 0,
                      //   bottom: 0,
                      //   child: _PriceWidget(_book.price),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MainBookInfoWidget extends StatelessWidget {
  final BookInfo _book;

  const _MainBookInfoWidget(this._book);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          _book.title,
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
          style: const TextStyle(
            color: Color(0xFF7E675E),
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          _book.author,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color(0xFFF06267),
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        // const SizedBox(height: 4),
        // Row(
        //   children: [
        //     for (int i = 0; i < _book.rating; i++) const Icon(Icons.star),
        //     for (int i = _book.rating; i < 5; i++)
        //       const Icon(Icons.star_outline),
        //   ],
        // ),
      ],
    );
  }
}

class _FavoriteButtonWidget extends StatelessWidget {
  final bool _isFavorite;

  const _FavoriteButtonWidget(this._isFavorite);

  @override
  Widget build(BuildContext context) {
    return _isFavorite
        ? const Icon(
            Icons.favorite,
            color: Colors.redAccent,
          )
        : const Icon(
            Icons.favorite_outline,
            color: Colors.redAccent,
          );
  }
}

class _PriceWidget extends StatelessWidget {
  final String price;

  const _PriceWidget(this.price);

  @override
  Widget build(BuildContext context) {
    return Text(
      price,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Color(0xFF607F9D),
      ),
    );
  }
}

class _EmptyListWidget extends StatelessWidget {
  const _EmptyListWidget();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(height: 200),
          Icon(
            Icons.cleaning_services_rounded,
            size: 160,
            color: Colors.black26,
          ),
          Text(
            'Empty',
            style: TextStyle(fontSize: 24, color: Colors.black26),
          ),
        ],
      ),
    );
  }
}
