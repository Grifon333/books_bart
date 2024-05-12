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
    final model = context.watch<FormBookInfoViewModel>();
    final countVariants = model.state.variantsOfBook.length;
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
    final state = model.state;
    return Column(
      children: [
        _TextFieldBookIndoWidget(
          'title',
          state.title,
          model.onChangedTitle,
          errorText: state.titleError,
        ),
        const SizedBox(height: 10),
        _TextFieldBookIndoWidget(
          'authors',
          state.authors,
          model.onChangedAuthors,
          errorText: state.authorsError,
        ),
        const SizedBox(height: 10),
        _TextFieldBookIndoWidget(
          'count of pages',
          state.countPage,
          model.onChangedCountPage,
          textInputType: TextInputType.datetime,
          errorText: state.countPageError,
        ),
        const SizedBox(height: 10),
        _TextFieldBookIndoWidget(
          'description',
          state.description,
          model.onChangedDescription,
          minLines: 3,
          maxLines: 5,
          errorText: state.descriptionError,
        ),
        const SizedBox(height: 10),
        _TextFieldBookIndoWidget(
          'category',
          state.category,
          model.onChangedCategory,
          textInputAction: TextInputAction.done,
          errorText: state.categoryError,
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
    final model = context.read<FormBookInfoViewModel>();
    final variantOfBook = model.state.variantsOfBook[index];
    return Column(
      children: [
        _TextFieldBookIndoWidget(
          'format',
          variantOfBook.format,
          (value) => model.onChangedFormat(index, value),
          errorText: variantOfBook.formatError,
        ),
        const SizedBox(height: 10),
        _TextFieldBookIndoWidget(
          'count',
          variantOfBook.count,
          (value) => model.onChangedCount(index, value),
          textInputType: TextInputType.datetime,
          errorText: variantOfBook.countError,
        ),
        const SizedBox(height: 10),
        _TextFieldBookIndoWidget(
          'language',
          variantOfBook.language,
          (value) => model.onChangedLanguage(index, value),
          errorText: variantOfBook.languageError,
        ),
        const SizedBox(height: 10),
        _TextFieldBookIndoWidget(
          'price',
          variantOfBook.price,
          (value) => model.onChangedPrice(index, value),
          textInputType: TextInputType.datetime,
          errorText: variantOfBook.priceError,
        ),
        const SizedBox(height: 10),
        _TextFieldBookIndoWidget(
          'publisher',
          variantOfBook.publisher,
          (value) => model.onChangedPublisher(index, value),
          errorText: variantOfBook.publisherError,
        ),
        const SizedBox(height: 10),
        _TextFieldBookIndoWidget(
          'type of binding',
          variantOfBook.bindingType,
          (value) => model.onChangedBindingType(index, value),
          errorText: variantOfBook.bindingTypeError,
        ),
        const SizedBox(height: 10),
        _TextFieldBookIndoWidget(
          'publication year',
          variantOfBook.publicationYear,
          (value) => model.onChangedPublicationYear(index, value),
          textInputType: TextInputType.datetime,
          errorText: variantOfBook.publicationYearError,
        ),
      ],
    );
  }
}

class _TextFieldBookIndoWidget extends StatelessWidget {
  final String label;
  final String? text;
  final void Function(String) onChanged;
  final String? errorText;
  final int minLines;
  final int maxLines;
  final TextInputAction textInputAction;
  final TextInputType textInputType;

  const _TextFieldBookIndoWidget(
    this.label,
    this.text,
    this.onChanged, {
    this.errorText,
    this.minLines = 1,
    this.maxLines = 1,
    this.textInputAction = TextInputAction.next,
    this.textInputType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: text)
        ..selection = TextSelection.collapsed(
          offset: text?.length ?? 0,
        ),
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText,
      ),
      onChanged: onChanged,
      textInputAction: textInputAction,
      minLines: minLines,
      maxLines: maxLines,
      keyboardType: textInputType,
    );
  }
}
