import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'history_view_model.dart';

class HistoryWidget extends StatelessWidget {
  const HistoryWidget({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EEE5),
      appBar: AppBar(
        title: const Text('History'),
        backgroundColor: const Color(0xFFF5EEE5),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: _BodyWidget(),
      ),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget();

  @override
  Widget build(BuildContext context) {
    final model = context.watch<HistoryViewModel>();
    final countOrders = model.state.orders.length;
    if (model.state.isLoading) {
      return const Center(
        child: SizedBox(
          width: 70,
          height: 70,
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: RefreshIndicator(
        onRefresh: model.onRefresh,
        child: ListView(
          children: List.generate(
            countOrders,
            (index) => _CartOrderInfoWidget(index),
          ),
        ),
      ),
    );
  }
}

class _CartOrderInfoWidget extends StatelessWidget {
  final int index;

  const _CartOrderInfoWidget(this.index);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<HistoryViewModel>();
    final order = model.state.orders[index];
    final List<BookInfo> books = order.books;
    final Color color = order.statusColor;
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: color, width: 2),
          boxShadow: [
            BoxShadow(
              color: color,
              blurRadius: 4,
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    model.role == 'manager'
                        ? _DropDownListWidget(index)
                        : _OrderStateTextWidget(index),
                    order.dateRegistration != null
                        ? Text(order.dateRegistration!)
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ...List.generate(
                books.length,
                (index) => _BookInfoWidget(books[index]),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    order.price,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.blueAccent),
                  ),
                  order.paymentMethod != null
                      ? Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            '(${order.paymentMethod})',
                            style: const TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _DropDownListWidget extends StatelessWidget {
  final int index;

  const _DropDownListWidget(this.index);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<HistoryViewModel>();
    final orderStatuses = model.state.orderStatuses;
    String dropdownValue = model.state.orders[index].status;
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_drop_down),
      style: const TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      underline: Container(
        height: 1,
        color: const Color(0xFF7E675E),
      ),
      onChanged: (String? value) => model.onChangeOrderStatus(index, value),
      items: orderStatuses.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class _OrderStateTextWidget extends StatelessWidget {
  final int index;

  const _OrderStateTextWidget(this.index);

  @override
  Widget build(BuildContext context) {
    final orderStatus =
        context.watch<HistoryViewModel>().state.orders[index].status;
    return Text(
      orderStatus,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: Colors.black,
        // shadows: const [
        //   Shadow(
        //       // bottomLeft
        //       offset: Offset(-0.2, -0.2),
        //       color: Colors.black),
        //   Shadow(
        //       // bottomRight
        //       offset: Offset(0.2, -0.2),
        //       color: Colors.black),
        //   Shadow(
        //       // topRight
        //       offset: Offset(0.2, 0.2),
        //       color: Colors.black),
        //   Shadow(
        //       // topLeft
        //       offset: Offset(-0.2, 0.2),
        //       color: Colors.black),
        // ],
      ),
    );
  }
}

class _BookInfoWidget extends StatelessWidget {
  final BookInfo bookInfo;

  const _BookInfoWidget(this.bookInfo);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 4,
          child: Text(
            '${bookInfo.title} x ${bookInfo.count}',
            style: const TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Text(
            bookInfo.priceStr,
            style: const TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
