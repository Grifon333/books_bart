import 'package:books_bart/ui/widgets/sign_up/sign_up.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state.status.isSuccess) {
          Navigator.of(context).pop();
        } else if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Sign Up Failure')),
            );
        }
      },
      child: _BodyWidget(),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create your account',
          style: TextStyle(
            fontSize: 30,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Create an account and explore a tailored library of captivating stories.',
          style: TextStyle(color: Colors.black54),
        ),
        SizedBox(height: 46),
        _NicknameInput(),
        SizedBox(height: 16),
        _EmailInput(),
        SizedBox(height: 16),
        _PasswordInput(),
        SizedBox(height: 16),
        _SignUpButton(),
        SizedBox(height: 16),
        _SubtextForButtonWidget(),
        SizedBox(height: 36),
        _DividerWidget(),
        // SizedBox(height: 16),
        // _SignupWithGoogleButtonWidget(),
      ],
    );
  }
}

class _NicknameInput extends StatelessWidget {
  const _NicknameInput();

  @override
  Widget build(BuildContext context) {
    final displayError = context.select(
      (SignUpCubit cubit) => cubit.state.nickname.displayError,
    );
    return TextField(
      key: const Key('signUp_nicknameInput_textField'),
      onChanged: context.read<SignUpCubit>().nicknameChanged,
      decoration: InputDecoration(
        labelText: 'Nickname',
        errorText: displayError != null ? 'invalid nickname' : null,
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  const _EmailInput();

  @override
  Widget build(BuildContext context) {
    final displayError = context.select(
      (SignUpCubit cubit) => cubit.state.email.displayError,
    );
    return TextField(
      key: const Key('signUp_emailInput_textField'),
      onChanged: context.read<SignUpCubit>().emailChanged,
      decoration: InputDecoration(
        labelText: 'Email address',
        errorText: displayError != null ? 'invalid email' : null,
      ),
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput();

  @override
  Widget build(BuildContext context) {
    final passwordVisibility = context.select(
      (SignUpCubit cubit) => cubit.state.passwordVisibility,
    );
    final iconVisibility = Icon(
      passwordVisibility ? Icons.visibility_off : Icons.visibility,
      size: 24,
    );
    final displayError = context.select(
      (SignUpCubit cubit) => cubit.state.password.displayError,
    );

    return TextField(
      key: const Key('signUp_passwordInput_textField'),
      onChanged: context.read<SignUpCubit>().passwordChanged,
      obscureText: passwordVisibility,
      obscuringCharacter: '*',
      decoration: InputDecoration(
        labelText: 'Password',
        suffixIconConstraints: const BoxConstraints(minHeight: 0, minWidth: 0),
        suffixIcon: InkWell(
          onTap: context.read<SignUpCubit>().passwordVisibilityChanged,
          radius: 0,
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: iconVisibility,
          ),
        ),
        errorText: displayError != null ? 'invalid password' : null,
      ),
    );
  }
}

class _ConfirmPasswordInput extends StatelessWidget {
  const _ConfirmPasswordInput();

  @override
  Widget build(BuildContext context) {
    final passwordVisibility = context.select(
      (SignUpCubit cubit) => cubit.state.confirmedPasswordVisibility,
    );
    final iconVisibility = Icon(
      passwordVisibility ? Icons.visibility_off : Icons.visibility,
      size: 24,
    );
    final displayError = context.select(
      (SignUpCubit cubit) => cubit.state.confirmedPassword.displayError,
    );

    return TextField(
      key: const Key('signUp_confirmPasswordInput_textField'),
      onChanged: context.read<SignUpCubit>().confirmedPasswordChanged,
      obscureText: passwordVisibility,
      obscuringCharacter: '*',
      decoration: InputDecoration(
        labelText: 'Confirmed Password',
        suffixIconConstraints: const BoxConstraints(minHeight: 0, minWidth: 0),
        suffixIcon: InkWell(
          onTap: context.read<SignUpCubit>().passwordVisibilityChanged,
          radius: 0,
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: iconVisibility,
          ),
        ),
        errorText: displayError != null ? 'passwords do not match' : null,
      ),
    );
  }
}

class _SignUpButton extends StatelessWidget {
  const _SignUpButton();

  @override
  Widget build(BuildContext context) {
    final isInProgress = context.select(
      (SignUpCubit cubit) => cubit.state.status.isInProgress,
    );
    if (isInProgress) return const CircularProgressIndicator();
    final isValid = context.select((SignUpCubit cubit) => cubit.state.isValid);

    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        key: const Key('signUp_signUpButton_filledButton'),
        onPressed:
            isValid ? context.read<SignUpCubit>().signUpFormSubmitted : null,
        child: const Text('Create new account'),
      ),
    );
  }
}

class _SubtextForButtonWidget extends StatelessWidget {
  const _SubtextForButtonWidget();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            const TextSpan(
              text: 'Already have an account? ',
              style: TextStyle(color: Colors.black54),
            ),
            TextSpan(
              text: 'Login',
              style: const TextStyle(color: Color(0xFFF06267)),
              recognizer: TapGestureRecognizer()
                ..onTap = Navigator.of(context).pop,
            ),
          ],
        ),
      ),
    );
  }
}

class _DividerWidget extends StatelessWidget {
  const _DividerWidget();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: Divider()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('or', style: TextStyle(color: Colors.black54)),
        ),
        Expanded(child: Divider()),
      ],
    );
  }
}

// class _SignupWithGoogleButtonWidget extends StatelessWidget {
//   const _SignupWithGoogleButtonWidget();
//
//   @override
//   Widget build(BuildContext context) {
//     return OutlinedButton(
//       onPressed: Navigator.of(context).pop,
//       child: const Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.language),
//           SizedBox(width: 10),
//           Text('Sign up with Google'),
//         ],
//       ),
//     );
//   }
// }
