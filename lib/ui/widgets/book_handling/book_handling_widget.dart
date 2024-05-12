import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'book_handling_view_model.dart';

class BookHandlingWidget extends StatelessWidget {
  const BookHandlingWidget({super.key});

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
    final model = context.read<BookHandlingViewModel>();
    return Stack(
      children: [
        const Column(
          children: [
            Text(
              'Book handling',
              style: TextStyle(
                fontSize: 32,
                color: Color(0xFF7E675E),
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16),
            _BooksListWidget(),
          ],
        ),
        Positioned(
          right: 0,
          top: 0,
          child: TextButton(
            onPressed: model.onPressedAdd,
            child: const Text(
              'Add',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}

class _BooksListWidget extends StatelessWidget {
  const _BooksListWidget();

  @override
  Widget build(BuildContext context) {
    final model = context.watch<BookHandlingViewModel>();
    final books = model.state.books;
    return Expanded(
      child: RefreshIndicator(
        onRefresh: model.onRefresh,
        child: ListView.separated(
          itemBuilder: (context, index) => _BookCartWidget(books[index]),
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemCount: books.length,
        ),
      ),
    );
  }
}

class _BookCartWidget extends StatelessWidget {
  final BookInfo _book;

  const _BookCartWidget(this._book);

  void onTap() => debugPrint('Title: ${_book.title}');

  @override
  Widget build(BuildContext context) {
    final model = context.read<BookHandlingViewModel>();
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
            SlidableAction(
              onPressed: (_) => model.onPressedEdit(_book.id),
              foregroundColor: Colors.blue,
              backgroundColor: const Color(0xFFF5EEE5),
              icon: Icons.edit,
              label: 'Edit',
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
                          SizedBox(
                            width: 78,
                            height: 120,
                            child: Image.network(_book.imageURL),
                          ),
                          const SizedBox(width: 24),
                          SizedBox(
                            width: 200,
                            child: _MainBookInfoWidget(_book),
                          ),
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
      children: [
        Text(
          _book.title,
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
          style: const TextStyle(
            color: Color(0xFF7E675E),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          _book.authors,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: const TextStyle(
            color: Color(0xFFF06267),
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
