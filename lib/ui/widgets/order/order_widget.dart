import 'package:books_bart/ui/widgets/order/order_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderWidget extends StatelessWidget {
  const OrderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EEE5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5EEE5),
        title: const Text('Check out'),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: _BodyWidget(),
      ),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget();

  void onPressed() {
    debugPrint('Change credit card number');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(
                color: Color(0xFF7E675E),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _BooksListWidget(),
                    Divider(
                      color: Colors.white70,
                      height: 36,
                    ),
                    _PriceInfoWidget(),
                    Divider(
                      color: Colors.white70,
                      height: 36,
                    ),
                    _TotalPriceWidget(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            DecoratedBox(
              decoration: const BoxDecoration(
                color: Color(0xFF7E675E),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.credit_card,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      '**** **** 2743',
                      style: TextStyle(color: Colors.white),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: onPressed,
                      child: const Text(
                        'Change',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 0,
          width: MediaQuery.of(context).size.width - 40,
          child: const _SubmitOrderButton(),
        ),
      ],
    );
  }
}

class _BooksListWidget extends StatelessWidget {
  const _BooksListWidget();

  @override
  Widget build(BuildContext context) {
    List<BookInfo> booksInfo = context.watch<OrderViewModel>().state.booksInfo;
    return Column(
      children: List.generate(
        booksInfo.length,
        (index) => _RowInfoWidget(
          title: '${booksInfo[index].title}  x  ${booksInfo[index].countStr}',
          info: '\$ ${booksInfo[index].price}',
        ),
      ),
    );
  }
}

class _PriceInfoWidget extends StatelessWidget {
  const _PriceInfoWidget();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OrderViewModel>().state;
    return Column(
      children: [
        _RowInfoWidget(title: 'Subtotal', info: state.subtotal),
        _RowInfoWidget(title: 'Tax & Fees', info: state.taxes),
        _RowInfoWidget(title: 'Discount', info: state.discount),
      ],
    );
  }
}

class _TotalPriceWidget extends StatelessWidget {
  const _TotalPriceWidget();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OrderViewModel>().state;
    return _RowInfoWidget(
      title: 'Total',
      info: state.totalPriceStr,
      size: 24,
      titleColor: Colors.white,
    );
  }
}

class _RowInfoWidget extends StatelessWidget {
  final String title;
  final String info;
  final double? size;
  final Color? titleColor;

  const _RowInfoWidget({
    required this.title,
    required this.info,
    this.size = 16,
    this.titleColor = Colors.white70,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 4,
          child: Text(
            title,
            style: TextStyle(
              fontSize: size,
              color: titleColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Text(
            info,
            style: TextStyle(
              fontSize: size,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _SubmitOrderButton extends StatelessWidget {
  const _SubmitOrderButton();

  @override
  Widget build(BuildContext context) {
    final model = context.watch<OrderViewModel>();
    return ElevatedButton(
      onPressed: model.onPressedSubmitOrder,
      child: const Text(
        'Place Order',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
