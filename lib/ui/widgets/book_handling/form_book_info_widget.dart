import 'package:books_bart/ui/widgets/book_handling/form_book_info_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class FormBookInfoWidget extends StatelessWidget {
  const FormBookInfoWidget({super.key});

  factory FormBookInfoWidget.add() => const _AddFormBookInfoWidget();

  factory FormBookInfoWidget.edit() => const _EditFormBookInfoWidget();
}

class _AddFormBookInfoWidget extends FormBookInfoWidget {
  const _AddFormBookInfoWidget();

  @override
  Widget build(BuildContext context) {
    final model = context.read<FormBookInfoViewModel>();
    return _FormBookInfoWidget(
      title: 'Add new book',
      submitButtonTitle: 'Add',
      onPressedSubmit: model.onPressedAdd,
    );
  }
}

class _EditFormBookInfoWidget extends FormBookInfoWidget {
  const _EditFormBookInfoWidget();

  @override
  Widget build(BuildContext context) {
    final model = context.read<FormBookInfoViewModel>();
    return _FormBookInfoWidget(
      title: 'Edit book',
      submitButtonTitle: 'Edit',
      onPressedSubmit: model.onPressedEdit,
    );
  }
}

class _FormBookInfoWidget extends FormBookInfoWidget {
  final String title;
  final String submitButtonTitle;
  final void Function() onPressedSubmit;

  const _FormBookInfoWidget({
    required this.title,
    required this.submitButtonTitle,
    required this.onPressedSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final model = context.read<FormBookInfoViewModel>();
    final countVariants = context
        .select((FormBookInfoViewModel vm) => vm.state.variantsOfBook.length);
    return AlertDialog(
      title: Text(title),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _MainBookInfoTextFieldWidget(),
          const SizedBox(height: 20),
          const Text(
            'Variants of book:',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 5),
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: const Color(0xFF7E675E)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: List.generate(countVariants, (index) {
                  if (index > 0) {
                    return Column(
                      children: [
                        const Divider(height: 30),
                        _VariantOfBookTextFieldWidget(index),
                      ],
                    );
                  }
                  return _VariantOfBookTextFieldWidget(index);
                }),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              countVariants > 1
                  ? TextButton(
                      onPressed: model.removeVariant,
                      child: const Text('Remove last variant'),
                    )
                  : const SizedBox.shrink(),
              TextButton(
                onPressed: model.addVariant,
                child: const Text('Add variant'),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: model.onPressedCancel,
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: onPressedSubmit,
          child: Text(submitButtonTitle),
        ),
      ],
      actionsAlignment: MainAxisAlignment.spaceAround,
      scrollable: true,
    );
  }
}

class _MainBookInfoTextFieldWidget extends StatelessWidget {
  const _MainBookInfoTextFieldWidget();

  @override
  Widget build(BuildContext context) {
    final model = context.watch<FormBookInfoViewModel>();
    return Column(
      children: [
        TextField(
          controller: TextEditingController(text: model.state.book.title)
            ..selection = TextSelection.collapsed(
              offset: model.state.book.title.length,
            ),
          decoration: const InputDecoration(labelText: 'title'),
          onChanged: model.onChangedTitleBook,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 10),
        TextField(
          controller: TextEditingController(text: model.state.book.authors)
            ..selection = TextSelection.collapsed(
              offset: model.state.book.authors.length,
            ),
          decoration: const InputDecoration(labelText: 'authors'),
          onChanged: model.onChangedAuthorsBook,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 10),
        TextField(
          controller: TextEditingController(
            text: model.state.book.countPage == 0
                ? ''
                : '${model.state.book.countPage}',
          )..selection = TextSelection.collapsed(
              offset: model.state.book.countPage == 0
                  ? 0
                  : '${model.state.book.countPage}'.length,
            ),
          decoration: const InputDecoration(labelText: 'count of pages'),
          onChanged: model.onChangedCountPageBook,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 10),
        TextField(
          controller: TextEditingController(text: model.state.book.description)
            ..selection = TextSelection.collapsed(
              offset: model.state.book.description.length,
            ),
          decoration: const InputDecoration(labelText: 'description'),
          onChanged: model.onChangedDescriptionBook,
          minLines: 3,
          maxLines: 5,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 10),
        TextField(
          controller: TextEditingController(text: model.state.book.category)
            ..selection = TextSelection.collapsed(
              offset: model.state.book.category.length,
            ),
          decoration: const InputDecoration(labelText: 'category'),
          onChanged: model.onChangedCategoryBook,
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }
}

class _VariantOfBookTextFieldWidget extends StatelessWidget {
  final int index;

  const _VariantOfBookTextFieldWidget(this.index);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<FormBookInfoViewModel>();
    return Column(
      children: [
        TextField(
          controller: TextEditingController(
            text: model.state.variantsOfBook[index].format,
          )..selection = TextSelection.collapsed(
              offset: model.state.variantsOfBook[index].format.length,
            ),
          decoration: const InputDecoration(labelText: 'format'),
          onChanged: (value) =>
              model.onChangedFormatVariantOfBook(index, value),
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 10),
        TextField(
          controller: TextEditingController(
            text: model.state.variantsOfBook[index].count == 0 ||
                    model.state.variantsOfBook[index].count == null
                ? ''
                : '${model.state.variantsOfBook[index].count}',
          )..selection = TextSelection.collapsed(
              offset: model.state.variantsOfBook[index].count == 0 ||
                      model.state.variantsOfBook[index].count == null
                  ? 0
                  : '${model.state.variantsOfBook[index].count}'.length,
            ),
          decoration: const InputDecoration(labelText: 'count'),
          onChanged: (value) => model.onChangedCountVariantOfBook(index, value),
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 10),
        TextField(
          controller: TextEditingController(
            text: model.state.variantsOfBook[index].language,
          )..selection = TextSelection.collapsed(
              offset: model.state.variantsOfBook[index].language.length,
            ),
          decoration: const InputDecoration(labelText: 'language'),
          onChanged: (value) =>
              model.onChangedLanguageVariantOfBook(index, value),
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 10),
        TextField(
          controller: TextEditingController(
            text: model.state.variantsOfBook[index].price == 0
                ? ''
                : '${model.state.variantsOfBook[index].price}',
          )..selection = TextSelection.collapsed(
              offset: model.state.variantsOfBook[index].price == 0
                  ? 0
                  : '${model.state.variantsOfBook[index].price}'.length,
            ),
          decoration: const InputDecoration(labelText: 'price'),
          onChanged: (value) => model.onChangedPriceVariantOfBook(index, value),
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 10),
        TextField(
          controller: TextEditingController(
            text: model.state.variantsOfBook[index].publisher,
          )..selection = TextSelection.collapsed(
              offset: model.state.variantsOfBook[index].publisher.length,
            ),
          decoration: const InputDecoration(labelText: 'publisher'),
          onChanged: (value) =>
              model.onChangedPublisherVariantOfBook(index, value),
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 10),
        TextField(
          controller: TextEditingController(
            text: model.state.variantsOfBook[index].bindingType,
          )..selection = TextSelection.collapsed(
              offset:
                  model.state.variantsOfBook[index].bindingType?.length ?? 0,
            ),
          decoration: const InputDecoration(labelText: 'type of binding'),
          onChanged: (value) =>
              model.onChangedBindingTypeVariantOfBook(index, value),
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 10),
        TextField(
          controller: TextEditingController(
            text: model.state.variantsOfBook[index].yearPublication == 0
                ? ''
                : '${model.state.variantsOfBook[index].yearPublication}',
          )..selection = TextSelection.collapsed(
              offset: model.state.variantsOfBook[index].yearPublication == 0
                  ? 0
                  : '${model.state.variantsOfBook[index].yearPublication}'
                      .length,
            ),
          decoration: const InputDecoration(labelText: 'publication year'),
          onChanged: (value) =>
              model.onChangedYearPublicationVariantOfBook(index, value),
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }
}
