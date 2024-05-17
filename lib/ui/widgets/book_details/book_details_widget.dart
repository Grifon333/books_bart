import 'package:books_bart/ui/widgets/book_details/book_details_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookDetailsWidget extends StatelessWidget {
  const BookDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<BookDetailsViewModel>();
    return Scaffold(
      backgroundColor: const Color(0xFFF5EEE5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5EEE5),
        elevation: 0,
        leading: IconButton(
          onPressed: model.onPressedReturn,
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
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: ListView(
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
                  SizedBox(height: 20),
                  _VariantsOfBookInfoWidget(),
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
    final title = context.select((BookDetailsViewModel vm) => vm.state.title);
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Color(0xFF7E675E),
      ),
    );
  }
}

class _AuthorWidget extends StatelessWidget {
  const _AuthorWidget();

  @override
  Widget build(BuildContext context) {
    final authors =
        context.select((BookDetailsViewModel vm) => vm.state.authors);
    return Text(
      authors,
      style: const TextStyle(
        fontSize: 14,
        color: Color(0xFFF06267),
      ),
    );
  }
}

class _AdditionInfoWidget extends StatelessWidget {
  const _AdditionInfoWidget();

  List<Widget> listWidget(List<List<String>> additionalInfoList) {
    List<Widget> list = [];
    for (int i = 0; i < additionalInfoList.length; i++) {
      list.add(
        _AdditionInfoTileWidget(
          title: additionalInfoList[i].first,
          value: additionalInfoList[i].last,
        ),
      );
      if (i < additionalInfoList.length - 1) list.add(const VerticalDivider());
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final rating = context.select((BookDetailsViewModel vm) => vm.state.rating);
    final countPage =
        context.select((BookDetailsViewModel vm) => vm.state.countPage);
    final List<List<String>> additionalInfoList = [
      ['Rating', rating],
      ['Pages', countPage],
      ['Language', 'EN'],
    ];
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
            children: listWidget(additionalInfoList),
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
    final model = context.read<BookDetailsViewModel>();
    final isFavorite =
        context.select((BookDetailsViewModel vm) => vm.state.isFavoriteBook);
    return FilledButton(
      onPressed: model.onPressedFavorite,
      style: const ButtonStyle(shape: MaterialStatePropertyAll(CircleBorder())),
      child: Icon(isFavorite ? Icons.bookmark : Icons.bookmark_outline),
    );
  }
}

class _DescriptionWidget extends StatelessWidget {
  const _DescriptionWidget();

  @override
  Widget build(BuildContext context) {
    final description =
        context.select((BookDetailsViewModel vm) => vm.state.description);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 8),
        Text(description),
      ],
    );
  }
}

class _ActionButtonsWidget extends StatelessWidget {
  const _ActionButtonsWidget();

  @override
  Widget build(BuildContext context) {
    final model = context.read<BookDetailsViewModel>();
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: FilledButton(
                onPressed: model.onPressedAddToCart,
                child: const Text(
                  'Add to cart',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VariantsOfBookInfoWidget extends StatelessWidget {
  const _VariantsOfBookInfoWidget();

  @override
  Widget build(BuildContext context) {
    final countVariants =
        context.watch<BookDetailsViewModel>().state.variantsOfBook.length;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          countVariants,
          (index) => Row(
            children: [
              _VariantOfBookInfoWidget(index),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class _VariantOfBookInfoWidget extends StatelessWidget {
  final int index;

  const _VariantOfBookInfoWidget(this.index);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<BookDetailsViewModel>();
    final variantOfBook = model.state.variantsOfBook[index];
    final selectVariantOfBook = model.state.selectVariantOfBook;
    final color = selectVariantOfBook == index ? Colors.black12 : null;
    return GestureDetector(
      onTap: () => model.onTapVariantOfBook(index),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: const Color(0xFF7E675E)),
          color: color,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      variantOfBook.format,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xFF7E675E),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      variantOfBook.language,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  variantOfBook.publisher,
                  style: const TextStyle(fontSize: 16),
                ),
                variantOfBook.bindingType != null
                    ? Text(
                        variantOfBook.bindingType!,
                        style: const TextStyle(fontSize: 16),
                      )
                    : const SizedBox.shrink(),
                Text(
                  variantOfBook.publicationYear,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Spacer(),
                    Text(
                      variantOfBook.price,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xFF7E675E),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
