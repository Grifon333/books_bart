part of 'sign_up_cubit.dart';

@immutable
final class SignUpState extends Equatable{
  final Nickname nickname;
  final Email email;
  final Password password;
  final ConfirmedPassword confirmedPassword;
  final bool passwordVisibility;
  final bool confirmedPasswordVisibility;
  final FormzSubmissionStatus status;
  final bool isValid;
  final String? errorMessage;

  const SignUpState({
    this.nickname = const Nickname.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmedPassword = const ConfirmedPassword.pure(),
    this.passwordVisibility = false,
    this.confirmedPasswordVisibility = false,
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
    nickname,
    email,
    password,
    confirmedPassword,
    passwordVisibility,
    confirmedPasswordVisibility,
    status,
    isValid,
    errorMessage,
  ];

  SignUpState copyWith({
    Nickname? nickname,
    Email? email,
    Password? password,
    ConfirmedPassword? confirmedPassword,
    bool? passwordVisibility,
    bool? confirmedPasswordVisibility,
    FormzSubmissionStatus? status,
    bool? isValid,
    String? errorMessage,
  }) {
    return SignUpState(
      nickname: nickname ?? this.nickname,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      passwordVisibility: passwordVisibility ?? this.passwordVisibility,
      confirmedPasswordVisibility:
          confirmedPasswordVisibility ?? this.confirmedPasswordVisibility,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
