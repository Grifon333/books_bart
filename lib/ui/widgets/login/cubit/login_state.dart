part of 'login_cubit.dart';

@immutable
final class LoginState extends Equatable {
  final Email email;
  final Password password;
  final bool passwordVisibility;
  final FormzSubmissionStatus status;
  final bool isValid;
  final String? errorMessage;

  const LoginState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.passwordVisibility = false,
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        email,
        password,
        passwordVisibility,
        status,
        isValid,
        errorMessage,
      ];

  LoginState copyWith({
    Email? email,
    Password? password,
    bool? passwordVisibility,
    FormzSubmissionStatus? status,
    bool? isValid,
    String? errorMessage,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      passwordVisibility: passwordVisibility ?? this.passwordVisibility,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
