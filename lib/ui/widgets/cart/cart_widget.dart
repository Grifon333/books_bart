import 'package:books_bart/ui/widgets/cart/cart_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CartWidget extends StatelessWidget {
  const CartWidget({super.key});

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
        Text(
          'My Cart',
          style: TextStyle(
            fontSize: 32,
            color: Color(0xFF7E675E),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 16),
        _BooksListWidget(),
      ],
    );
  }
}

class _BooksListWidget extends StatelessWidget {
  const _BooksListWidget();

  @override
  Widget build(BuildContext context) {
    List<BookInfo> books = [
      BookInfo(title: 'Book1', author: 'Author1', price: '\$20'),
      BookInfo(title: 'Book2', author: 'Author2', price: '\$24'),
      BookInfo(title: 'Book3', author: 'Author3', price: '\$27'),
      BookInfo(title: 'Book4', author: 'Author4', price: '\$45'),
      BookInfo(title: 'Book5', author: 'Author5', price: '\$32'),
      BookInfo(title: 'Book6', author: 'Author6', price: '\$30'),
      BookInfo(title: 'Book7', author: 'Author7', price: '\$29'),
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
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => debugPrint('Delete ${_book.title}'),
              foregroundColor: Colors.red,
              backgroundColor: const Color(0xFFF5EEE5),
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
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
                          ),
                          const Spacer(),
                          const _CountWidget(),
                        ],
                      ),
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
        const Spacer(),
        Text(
          _book.price,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color(0xFF7E675E),
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _CountWidget extends StatefulWidget {
  const _CountWidget();

  @override
  State<_CountWidget> createState() => _CountWidgetState();
}

class _CountWidgetState extends State<_CountWidget> {
  int count = 1;

  void onPressedAdd() {
    count++;
    setState(() {});
  }

  void onPressedDelete() {
    if (count == 0) return;
    count--;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: onPressedAdd,
          icon: const Icon(Icons.add),
        ),
        Text(
          count.toString(),
          style: const TextStyle(fontSize: 16),
        ),
        IconButton(
          onPressed: onPressedDelete,
          icon: const Icon(Icons.remove),
        ),
      ],
    );
  }
}
