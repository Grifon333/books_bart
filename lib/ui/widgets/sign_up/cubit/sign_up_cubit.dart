import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final AuthenticationRepository _authenticationRepository;

  SignUpCubit(this._authenticationRepository) : super(const SignUpState());

  void nicknameChanged(String value) {
    final nickname = Nickname.dirty(value);
    emit(state.copyWith(
      nickname: nickname,
      isValid: Formz.validate(
        [nickname, state.email, state.password, state.confirmedPassword],
      ),
    ));
  }

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email,
      isValid: Formz.validate(
        [state.nickname, email, state.password, state.confirmedPassword],
      ),
    ));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    final confirmedPassword = ConfirmedPassword.dirty(
      password: password.value,
      value: state.confirmedPassword.value,
    );
    emit(state.copyWith(
      password: password,
      confirmedPassword: confirmedPassword,
      isValid: Formz.validate(
        [state.nickname, state.email, password, confirmedPassword],
      ),
    ));
  }

  void confirmedPasswordChanged(String value) {
    final confirmedPassword = ConfirmedPassword.dirty(
      password: state.password.value,
      value: value,
    );
    emit(state.copyWith(
      confirmedPassword: confirmedPassword,
      isValid: Formz.validate(
        [state.nickname, state.email, state.password, confirmedPassword],
      ),
    ));
  }

  void passwordVisibilityChanged() {
    emit(state.copyWith(passwordVisibility: state.passwordVisibility ^ true));
  }

  void confirmedPasswordVisibilityChanged() {
    emit(state.copyWith(
      confirmedPasswordVisibility: state.confirmedPasswordVisibility ^ true,
    ));
  }

  Future<void> signUpFormSubmitted() async {
    if (!state.isValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _authenticationRepository.signUp(
          email: state.email.value, password: state.password.value);
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on SignUpWithEmailAndPasswordFailure catch (e) {
      emit(state.copyWith(
        errorMessage: e.message,
        status: FormzSubmissionStatus.failure,
      ));
    } catch (_) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }
}
