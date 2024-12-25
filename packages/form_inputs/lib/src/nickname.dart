import 'package:formz/formz.dart';

enum NicknameValidationError {
  invalid

  /// other
}

class Nickname extends FormzInput<String, NicknameValidationError> {
  const Nickname.pure() : super.pure('');

  const Nickname.dirty([super.value = '']) : super.dirty();

  @override
  NicknameValidationError? validator(String? value) {
    return (value ?? '').length > 1 ? null : NicknameValidationError.invalid;
  }
}
