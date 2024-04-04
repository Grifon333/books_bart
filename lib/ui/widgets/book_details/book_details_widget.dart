import 'package:flutter/material.dart';

class BookDetailsWidget extends StatelessWidget {
  const BookDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EEE5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5EEE5),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            debugPrint('Return');
          },
          icon: const Icon(
            Icons.chevron_left,
            color: Color(0xFF7E675E),
          ),
        ),
      ),
      body: const Stack(
        children: [
          _BodyWidget(),
          Positioned(
            bottom: 0,
            child: _ActionButtonsWidget(),
          ),
        ],
      ),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget();

  @override
  Widget build(BuildContext context) {
    // return CustomScrollView(
    //   slivers: [
    //     SliverPadding(
    //       padding: EdgeInsets.zero,
    //       sliver: SliverList(
    //         delegate: SliverChildListDelegate(
    //           [
    //             const _BookCoverWidget(),
    //             const _BookInfoWidget(),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ],
    // );
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: ListView(
        // shrinkWrap: true,
        children: const [
          _BookCoverWidget(),
          _BookInfoWidget(),
        ],
      ),
    );
  }
}

class _BookCoverWidget extends StatelessWidget {
  const _BookCoverWidget();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: double.infinity,
      child: ColoredBox(
        color: Colors.white,
        child: Center(
          child: SizedBox(
            height: 250,
            width: 190,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BookInfoWidget extends StatelessWidget {
  const _BookInfoWidget();

  @override
  Widget build(BuildContext context) {
    return const Stack(
      clipBehavior: Clip.none,
      children: [
        ColoredBox(
          color: Colors.white,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Color(0xFFF5EEE5),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 40,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TitleWidget(),
                  _AuthorWidget(),
                  SizedBox(height: 16),
                  _AdditionInfoWidget(),
                  SizedBox(height: 20),
                  _DescriptionWidget(),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: -27,
          right: 20,
          width: 54,
          height: 54,
          child: _SaveButtonWidget(),
        ),
      ],
    );
  }
}

class _TitleWidget extends StatelessWidget {
  const _TitleWidget();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Psychology of Money',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _AuthorWidget extends StatelessWidget {
  const _AuthorWidget();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Morgan Housel',
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey,
      ),
    );
  }
}

class _AdditionInfoWidget extends StatelessWidget {
  const _AdditionInfoWidget();

  final divider = const VerticalDivider(
    width: 1,
    color: Colors.grey,
  );

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        height: 90,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const _AdditionInfoTileWidget(
                title: 'Rating',
                value: '4.5',
              ),
              divider,
              const _AdditionInfoTileWidget(
                title: 'Pages',
                value: '200',
              ),
              divider,
              const _AdditionInfoTileWidget(
                title: 'Language',
                value: 'EN',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdditionInfoTileWidget extends StatelessWidget {
  final String title;
  final String value;

  const _AdditionInfoTileWidget({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

class _SaveButtonWidget extends StatelessWidget {
  const _SaveButtonWidget();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        debugPrint('Save');
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFF7E675E),
          borderRadius: BorderRadius.circular(27),
        ),
        child: const Icon(
          Icons.bookmark_outline,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _DescriptionWidget extends StatelessWidget {
  const _DescriptionWidget();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Description'),
        SizedBox(height: 8),
        Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Dignissim tellus ut tincidunt interdum egestas. Et, tempus pellentesque tellus vulputate dignissim.Massa est, in quam tempus. Mattis bibendum sit mattis dapibus viverra'),
        Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Dignissim tellus ut tincidunt interdum egestas. Et, tempus pellentesque tellus vulputate dignissim.Massa est, in quam tempus. Mattis bibendum sit mattis dapibus viverra'),
      ],
    );
  }
}

class _ActionButtonsWidget extends StatelessWidget {
  const _ActionButtonsWidget();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: _ButtonWidget(
                title: 'Add to cart',
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: _ButtonWidget(title: 'Buy e-book'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ButtonWidget extends StatelessWidget {
  final String title;

  const _ButtonWidget({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        debugPrint('Button: $title');
      },
      style: ButtonStyle(
        backgroundColor: const MaterialStatePropertyAll(
          Color(0xFF7E675E),
        ),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }
}
