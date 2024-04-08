import 'package:flutter/material.dart';

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
    final List<String> booksTitle = [
      'The last sister',
      'The priority Tree',
      'Werewolf Mountain',
    ];
    final List<int> booksCount = [1, 1, 2];
    final List<double> booksPrice = [120, 90, 105];
    return Column(
      children: [
        ...List.generate(
          booksTitle.length,
          (index) => _RowInfoWidget(
              title: '${booksTitle[index]}  x  ${booksCount[index]}',
              info: '\$ ${booksPrice[index]}'),
        ),
      ],
    );
  }
}

class _PriceInfoWidget extends StatelessWidget {
  const _PriceInfoWidget();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _RowInfoWidget(title: 'Subtotal', info: '\$ 315'),
        _RowInfoWidget(title: 'Tax & Fees', info: '\$ 42'),
        _RowInfoWidget(title: 'Discount', info: '- \$ 315'),
      ],
    );
  }
}

class _TotalPriceWidget extends StatelessWidget {
  const _TotalPriceWidget();

  @override
  Widget build(BuildContext context) {
    return const _RowInfoWidget(
      title: 'Total',
      info: '\$ 315',
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
        Text(
          title,
          style: TextStyle(
            fontSize: size,
            color: titleColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          info,
          style: TextStyle(
            fontSize: size,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _SubmitOrderButton extends StatelessWidget {
  const _SubmitOrderButton();

  void onPressed() {
    debugPrint('Place Order');
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: const Text(
        'Place Order',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
