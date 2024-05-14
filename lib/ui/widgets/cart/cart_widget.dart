import 'package:books_bart/ui/widgets/cart/cart_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

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
        SizedBox(height: 16),
        _OrderButtonWidget(),
      ],
    );
  }
}

class _BooksListWidget extends StatelessWidget {
  const _BooksListWidget();

  @override
  Widget build(BuildContext context) {
    final model = context.watch<CartViewModel>();
    List<BookInfo> books = model.state.booksInfo;
    return SingleChildScrollView(
      child: Column(
        children: List.generate(
          books.length,
          (index) => _BookCartWidget(index),
        ),
      ),
    );
  }
}

class _BookCartWidget extends StatelessWidget {
  final int index;

  const _BookCartWidget(this.index);

  void onTap() => debugPrint('Book in Order (index: $index)');

  @override
  Widget build(BuildContext context) {
    final model = context.read<CartViewModel>();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Slidable(
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
                            child: _MainBookInfoWidget(index),
                          ),
                          const Spacer(),
                          _CountWidget(index),
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
  final int index;

  const _MainBookInfoWidget(this.index);

  @override
  Widget build(BuildContext context) {
    final bookInfo = context.read<CartViewModel>().state.booksInfo[index];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          bookInfo.title,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color(0xFF7E675E),
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          bookInfo.author,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color(0xFFF06267),
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        Text(
          bookInfo.price,
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

class _CountWidget extends StatelessWidget {
  final int index;

  const _CountWidget(this.index);

  @override
  Widget build(BuildContext context) {
    final model = context.read<CartViewModel>();
    final bookInfo = model.state.booksInfo[index];

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: () => model.onPressedCountIncrement(index),
          icon: const Icon(Icons.add),
        ),
        Text(
          bookInfo.countStr(),
          style: const TextStyle(fontSize: 16),
        ),
        IconButton(
          onPressed: () => model.onPressedCountDecrement(index),
          icon: const Icon(Icons.remove),
        ),
      ],
    );
  }
}

class _OrderButtonWidget extends StatelessWidget {
  const _OrderButtonWidget();

  @override
  Widget build(BuildContext context) {
    final model = context.read<CartViewModel>();
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: model.onPressedOrder,
        child: const Text(
          'Order',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
