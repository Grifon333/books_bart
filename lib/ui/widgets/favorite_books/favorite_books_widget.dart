import 'package:books_bart/ui/widgets/favorite_books/favorite_books_view_model.dart';
import 'package:flutter/material.dart';

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
    List<BookInfo> books = [
      BookInfo(title: 'Book1', author: 'Author1', rating: 3, price: '\$20'),
      BookInfo(title: 'Book2', author: 'Author2', rating: 4, price: '\$24'),
      BookInfo(title: 'Book3', author: 'Author3', rating: 4, price: '\$27'),
      BookInfo(title: 'Book4', author: 'Author4', rating: 4, price: '\$45'),
      BookInfo(title: 'Book5', author: 'Author5', rating: 5, price: '\$32'),
      BookInfo(title: 'Book6', author: 'Author6', rating: 3, price: '\$30'),
      BookInfo(title: 'Book7', author: 'Author7', rating: 4, price: '\$29'),
    ];
    return Expanded(
      child: ListView.separated(
        itemBuilder: (context, index) => _BookCartWidget(books[index]),
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemCount: books.length,
      ),
    );
  }
}

class _BookCartWidget extends StatelessWidget {
  final BookInfo _book;

  const _BookCartWidget(this._book);

  void onTap() => debugPrint('Title: ${_book.title}, price: ${_book.price}');

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            onTap: onTap,
            child: SizedBox(
              height: 152,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Stack(
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 78,
                          height: 120,
                          child: ColoredBox(color: Colors.grey),
                        ),
                        const SizedBox(width: 24),
                        SizedBox(
                          width: 200,
                          child: _MainBookInfoWidget(_book),
                        )
                      ],
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: _FavoriteButtonWidget(_book.isFavorite),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: _PriceWidget(_book.price),
                    ),
                  ],
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _book.title,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color(0xFF7E675E),
            fontSize: 24,
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
        const SizedBox(height: 4),
        Row(
          children: [
            for (int i = 0; i < _book.rating; i++) const Icon(Icons.star),
            for (int i = _book.rating; i < 5; i++)
              const Icon(Icons.star_outline),
          ],
        ),
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
