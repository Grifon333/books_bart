import 'package:books_bart/domain/entity/book.dart';
import 'package:books_bart/domain/entity/variant_of_book.dart';
import 'package:books_bart/domain/repositories/book_repository.dart';
import 'package:flutter/material.dart';

enum FormType { add, edit }

class ErrorsMassage {
  static const String emptyField = 'Field is empty';
  static const String parseToInt = 'It is not number';
  static const String parseToDouble = 'It is not decimal';
}

class VariantOfBookState {
  String format = '';
  String? count = '';
  String language = '';
  String price = '';
  String publisher = '';
  String? bindingType = '';
  String publicationYear = '';

  String? formatError;
  String? countError;
  String? languageError;
  String? priceError;
  String? publisherError;
  String? bindingTypeError;
  String? publicationYearError;
}

class FormBookInfoState {
  String title = '';
  String authors = '';
  String countPage = '';
  String description = '';
  String category = '';
  List<VariantOfBookState> variantsOfBook = [VariantOfBookState()];

  String? titleError;
  String? authorsError;
  String? countPageError;
  String? descriptionError;
  String? categoryError;

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
    Book book = data[0];
    _state.title = book.title;
    _state.authors = book.authors;
    _state.countPage = '${book.countPage}';
    _state.description = book.description;
    _state.category = book.category;
    List<VariantOfBook> variantsOfBook =
        (data[1] as Map<String, VariantOfBook>).values.toList();
    _state.variantsOfBook.clear();
    for (var variant in variantsOfBook) {
      final variantState = VariantOfBookState();
      variantState.format = variant.format;
      if (variant.count != null) variantState.count = '${variant.count}';
      variantState.language = variant.language;
      variantState.price = '${variant.price}';
      variantState.publisher = variant.publisher;
      variantState.bindingType = variant.bindingType;
      variantState.publicationYear = '${variant.publicationYear}';
      _state.variantsOfBook.add(variantState);
    }
    notifyListeners();
  }

  void onPressedAdd() {
    if (!checkBookInfoFields()) return;
    if (!checkVariantsOfBookFields()) return;
    Book book = convertStateToBook();
    List<VariantOfBook> variantsOfBook = _state.variantsOfBook
        .map((e) => convertStateToVariantOfBook(e))
        .toList();
    _bookRepository.addBook(book, variantsOfBook);
    onPressedCancel();
  }

  void onPressedEdit() {
    if (!checkBookInfoFields()) return;
    if (!checkVariantsOfBookFields()) return;
    _bookRepository.editBookInfo(
      bookId!,
      _state.bookUpdateMap,
      _state.variantsOfBook.map((e) => convertStateToVariantOfBook(e)).toList(),
    );
    onPressedCancel();
  }

  void onPressedCancel() {
    Navigator.of(context).pop();
  }

  void addVariant() {
    _state.variantsOfBook.add(VariantOfBookState());
    notifyListeners();
  }

  void removeVariant() {
    _state.variantsOfBook.removeLast();
    notifyListeners();
  }

  String? checkEmptyField(String value) {
    return value.isEmpty ? ErrorsMassage.emptyField : null;
  }

  void onChangedTitle(String value) {
    String? errorMassage = checkEmptyField(value);
    if (errorMassage != _state.titleError) {
      _state.titleError = errorMassage;
      notifyListeners();
    }
    _state.title = value.trim();
    if (formType == FormType.edit) {
      _state.bookUpdateMap['title'] = value.trim();
    }
  }

  void onChangedAuthors(String value) {
    String? errorMassage = checkEmptyField(value);
    if (errorMassage != _state.authorsError) {
      _state.authorsError = errorMassage;
      notifyListeners();
    }
    _state.authors = value.trim();
    if (formType == FormType.edit) {
      _state.bookUpdateMap['authors'] = value.trim();
    }
  }

  void onChangedCountPage(String value) {
    String? errorMassage = checkEmptyField(value);
    if (errorMassage != _state.countPageError) {
      _state.countPageError = errorMassage;
      notifyListeners();
    }
    _state.countPage = value.trim();
    if (formType == FormType.edit) {
      _state.bookUpdateMap['count_page'] = value.trim();
    }
  }

  void onChangedDescription(String value) {
    String? errorMassage = checkEmptyField(value);
    if (errorMassage != _state.descriptionError) {
      _state.descriptionError = errorMassage;
      notifyListeners();
    }
    _state.description = value.trim();
    if (formType == FormType.edit) {
      _state.bookUpdateMap['description'] = value.trim();
    }
  }

  void onChangedCategory(String value) {
    String? errorMassage = checkEmptyField(value);
    if (errorMassage != _state.categoryError) {
      _state.categoryError = errorMassage;
      notifyListeners();
    }
    _state.category = value.trim();
    if (formType == FormType.edit) {
      _state.bookUpdateMap['category'] = value.trim();
    }
  }

  void onChangedFormat(int index, String value) {
    String? errorMassage = checkEmptyField(value);
    if (errorMassage != _state.variantsOfBook[index].formatError) {
      _state.variantsOfBook[index].formatError = errorMassage;
      notifyListeners();
    }
    if (value != 'paper') {
      _state.variantsOfBook[index].countError = null;
      _state.variantsOfBook[index].bindingTypeError = null;
      notifyListeners();
    }
    _state.variantsOfBook[index].format = value.trim();
  }

  void onChangedCount(int index, String value) {
    if (_state.variantsOfBook[index].format == 'paper') {
      String? errorMassage = checkEmptyField(value);
      if (errorMassage != _state.variantsOfBook[index].countError) {
        _state.variantsOfBook[index].countError = errorMassage;
        notifyListeners();
      }
    } else {
      if (_state.variantsOfBook[index].countError != null) {
        _state.variantsOfBook[index].countError = null;
        notifyListeners();
      }
    }
    _state.variantsOfBook[index].count = value.trim();
  }

  void onChangedLanguage(int index, String value) {
    String? errorMassage = checkEmptyField(value);
    if (errorMassage != _state.variantsOfBook[index].languageError) {
      _state.variantsOfBook[index].languageError = errorMassage;
      notifyListeners();
    }
    _state.variantsOfBook[index].language = value.trim();
  }

  void onChangedPrice(int index, String value) {
    String? errorMassage = checkEmptyField(value);
    if (errorMassage != _state.variantsOfBook[index].priceError) {
      _state.variantsOfBook[index].priceError = errorMassage;
      notifyListeners();
    }
    _state.variantsOfBook[index].price = value.trim();
  }

  void onChangedPublisher(int index, String value) {
    String? errorMassage = checkEmptyField(value);
    if (errorMassage != _state.variantsOfBook[index].publisherError) {
      _state.variantsOfBook[index].publisherError = errorMassage;
      notifyListeners();
    }
    _state.variantsOfBook[index].publisher = value.trim();
  }

  void onChangedBindingType(int index, String value) {
    if (_state.variantsOfBook[index].format == 'paper') {
      String? errorMassage = checkEmptyField(value);
      if (errorMassage != _state.variantsOfBook[index].bindingTypeError) {
        _state.variantsOfBook[index].bindingTypeError = errorMassage;
        notifyListeners();
      }
    } else {
      if (_state.variantsOfBook[index].bindingTypeError != null) {
        _state.variantsOfBook[index].bindingTypeError = null;
        notifyListeners();
      }
    }
    _state.variantsOfBook[index].bindingType = value.trim();
  }

  void onChangedPublicationYear(int index, String value) {
    String? errorMassage = checkEmptyField(value);
    if (errorMassage != _state.variantsOfBook[index].publicationYearError) {
      _state.variantsOfBook[index].publicationYearError = errorMassage;
      notifyListeners();
    }
    _state.variantsOfBook[index].publicationYear = value.trim();
  }

  Book convertStateToBook() {
    return Book(
      title: _state.title,
      authors: _state.authors,
      countPage: int.parse(_state.countPage),
      description: _state.description,
      category: _state.category,
    );
  }

  VariantOfBook convertStateToVariantOfBook(VariantOfBookState variantState) {
    String bindingType = variantState.bindingType ?? '';
    return VariantOfBook(
      format: variantState.format,
      count: int.tryParse(variantState.count ?? ''),
      language: variantState.language,
      price: double.parse(variantState.price),
      publisher: variantState.publisher,
      bindingType: bindingType.isEmpty ? null : bindingType,
      publicationYear: int.parse(variantState.publicationYear),
    );
  }

  bool checkBookInfoFields() {
    bool isErrorExist = false;
    if (_state.title.isEmpty) {
      _state.titleError = ErrorsMassage.emptyField;
      isErrorExist = true;
    }
    if (_state.authors.isEmpty) {
      _state.authorsError = ErrorsMassage.emptyField;
      isErrorExist = true;
    }
    if (_state.countPage.isEmpty) {
      _state.countPageError = ErrorsMassage.emptyField;
      isErrorExist = true;
    } else if (int.tryParse(_state.countPage) == null) {
      _state.countPageError = ErrorsMassage.parseToInt;
      isErrorExist = true;
    }
    if (_state.description.isEmpty) {
      _state.descriptionError = ErrorsMassage.emptyField;
      isErrorExist = true;
    }
    if (_state.category.isEmpty) {
      _state.categoryError = ErrorsMassage.emptyField;
      isErrorExist = true;
    }
    notifyListeners();
    return !isErrorExist;
  }

  bool checkVariantsOfBookFields() {
    bool isNotErrorExist = true;
    for (int i = 0; i < _state.variantsOfBook.length; i++) {
      isNotErrorExist &= checkVariantOfBookFields(i);
    }
    notifyListeners();
    return isNotErrorExist;
  }

  bool checkVariantOfBookFields(int index) {
    bool isErrorExist = false;
    VariantOfBookState variant = _state.variantsOfBook[index];
    if (variant.format.isEmpty) {
      _state.variantsOfBook[index].formatError = ErrorsMassage.emptyField;
      isErrorExist = true;
    }
    if (variant.format == 'paper' &&
        (variant.count == null || variant.count!.isEmpty)) {
      _state.variantsOfBook[index].countError = ErrorsMassage.emptyField;
      isErrorExist = true;
    } else if (variant.format == 'paper' &&
        int.tryParse(variant.count!) == null) {
      _state.variantsOfBook[index].countError = ErrorsMassage.parseToInt;
      isErrorExist = true;
    }
    if (variant.language.isEmpty) {
      _state.variantsOfBook[index].languageError = ErrorsMassage.emptyField;
      isErrorExist = true;
    }
    if (variant.price.isEmpty) {
      _state.variantsOfBook[index].priceError = ErrorsMassage.emptyField;
      isErrorExist = true;
    } else if (double.tryParse(variant.price) == null) {
      _state.variantsOfBook[index].priceError = ErrorsMassage.parseToDouble;
      isErrorExist = true;
    }
    if (variant.publisher.isEmpty) {
      _state.variantsOfBook[index].publisherError = ErrorsMassage.emptyField;
      isErrorExist = true;
    }
    if (variant.format == 'paper' &&
        (variant.bindingType == null || variant.bindingType!.isEmpty)) {
      _state.variantsOfBook[index].bindingTypeError = ErrorsMassage.emptyField;
      isErrorExist = true;
    }
    if (variant.publicationYear.isEmpty) {
      _state.variantsOfBook[index].publicationYearError =
          ErrorsMassage.emptyField;
      isErrorExist = true;
    } else if (int.tryParse(variant.publicationYear) == null) {
      _state.variantsOfBook[index].publicationYearError =
          ErrorsMassage.parseToInt;
      isErrorExist = true;
    }
    return !isErrorExist;
  }
}
