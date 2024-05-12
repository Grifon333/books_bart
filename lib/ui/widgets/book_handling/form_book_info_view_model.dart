import 'package:books_bart/domain/entity/book.dart';
import 'package:books_bart/domain/entity/variant_of_book.dart';
import 'package:books_bart/domain/repositories/book_repository.dart';
import 'package:flutter/material.dart';

enum FormType { add, edit }

class FormBookInfoState {
  Book book = Book.empty();
  List<VariantOfBook> variantsOfBook = [VariantOfBook.empty()];

  Map<String, dynamic> bookUpdateMap = {};
}

class FormBookInfoViewModel extends ChangeNotifier {
  final BuildContext context;
  final String? bookId;
  final FormBookInfoState _state = FormBookInfoState();
  final FormType formType;
  final BookRepository _bookRepository = BookRepository();

  FormBookInfoState get state => _state;

  FormBookInfoViewModel(
    this.context,
    this.formType, {
    this.bookId,
  }) {
    _init();
  }

  Future<void> _init() async {
    if (bookId == null) return;
    List<dynamic> data = await _bookRepository.getBookInfoById(bookId!);
    _state.book = data[0];
    _state.variantsOfBook = data[1];
    notifyListeners();
  }

  void onPressedAdd() {
    _bookRepository.addBook(_state.book, _state.variantsOfBook);
    onPressedCancel();
  }

  void onPressedEdit() {
    _bookRepository.editBookInfo(
      bookId!,
      _state.bookUpdateMap,
      _state.variantsOfBook,
    );
    onPressedCancel();
  }

  void onPressedCancel() {
    Navigator.of(context).pop();
  }

  void addVariant() {
    _state.variantsOfBook.add(VariantOfBook.empty());
    notifyListeners();
  }

  void removeVariant() {
    _state.variantsOfBook.removeLast();
    notifyListeners();
  }

  void onChangedTitleBook(String value) {
    _state.book.title = value;
    if (formType == FormType.edit) {
      _state.bookUpdateMap['title'] = value;
      notifyListeners();
    }
  }

  void onChangedAuthorsBook(String value) {
    _state.book.authors = value;
    if (formType == FormType.edit) {
      _state.bookUpdateMap['authors'] = value;
      notifyListeners();
    }
  }

  void onChangedCountPageBook(String value) {
    _state.book.countPage = int.parse(value);
    if (formType == FormType.edit) {
      _state.bookUpdateMap['count_page'] = int.parse(value);
      notifyListeners();
    }
  }

  void onChangedDescriptionBook(String value) {
    _state.book.description = value;
    if (formType == FormType.edit) {
      _state.bookUpdateMap['description'] = value;
      notifyListeners();
    }
  }

  void onChangedCategoryBook(String value) {
    _state.book.category = value;
    if (formType == FormType.edit) {
      _state.bookUpdateMap['category'] = value;
      notifyListeners();
    }
  }

  void onChangedFormatVariantOfBook(int index, String value) {
    _state.variantsOfBook[index].format = value;
  }

  void onChangedCountVariantOfBook(int index, String value) {
    _state.variantsOfBook[index].count = int.parse(value);
  }

  void onChangedLanguageVariantOfBook(int index, String value) {
    _state.variantsOfBook[index].language = value;
  }

  void onChangedPriceVariantOfBook(int index, String value) {
    _state.variantsOfBook[index].price = double.parse(value);
  }

  void onChangedPublisherVariantOfBook(int index, String value) {
    _state.variantsOfBook[index].publisher = value;
  }

  void onChangedBindingTypeVariantOfBook(int index, String value) {
    _state.variantsOfBook[index].bindingType = value;
  }

  void onChangedYearPublicationVariantOfBook(int index, String value) {
    _state.variantsOfBook[index].yearPublication = int.parse(value);
  }
}
