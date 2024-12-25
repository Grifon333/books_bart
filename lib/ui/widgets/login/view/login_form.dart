import 'package:books_bart/ui/navigation/main_navigation.dart';
import 'package:books_bart/ui/widgets/login/login.dart';
import 'package:books_bart/ui/widgets/sign_up/sign_up.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Authentication Failure'),
              ),
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
          'Log in',
          style: TextStyle(
            fontSize: 30,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Welcome back! Log in to resume your reading journey',
          style: TextStyle(color: Colors.black54),
        ),
        SizedBox(height: 46),
        _EmailInput(),
        SizedBox(height: 16),
        _PasswordInput(),
        SizedBox(height: 16),
        _LoginButton(),
        SizedBox(height: 16),
        _SignUpButton(),
        SizedBox(height: 36),
        _DividerWidget(),
        SizedBox(height: 16),
        _GoogleLoginButton(),
      ],
    );
  }
}

class _EmailInput extends StatelessWidget {
  const _EmailInput();

  @override
  Widget build(BuildContext context) {
    final displayError = context.select(
      (LoginCubit cubit) => cubit.state.email.displayError,
    );
    return TextField(
      key: const Key('loginForm_emailInput_textField'),
      onChanged: context.read<LoginCubit>().emailChanged,
      keyboardType: TextInputType.emailAddress,
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
    final displayError = context.select(
      (LoginCubit cubit) => cubit.state.password.displayError,
    );
    final isObscureText = context.select(
      (LoginCubit cubit) => cubit.state.passwordVisibility,
    );
    final iconVisibility = Icon(
      isObscureText ? Icons.visibility_off : Icons.visibility,
      size: 24,
    );

    return TextField(
      key: const Key('loginForm_passwordInput_textField'),
      onChanged: context.read<LoginCubit>().passwordChanged,
      obscureText: isObscureText,
      obscuringCharacter: '*',
      decoration: InputDecoration(
        labelText: 'Password',
        suffixIconConstraints: const BoxConstraints(minHeight: 0, minWidth: 0),
        suffixIcon: InkWell(
          onTap: context.read<LoginCubit>().passwordVisibilityChanged,
          radius: 0,
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: iconVisibility,
          ),
        ),
        errorText: displayError != null ? 'invalid email' : null,
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton();

  @override
  Widget build(BuildContext context) {
    final isInProgress = context.select(
      (LoginCubit cubit) => cubit.state.status.isInProgress,
    );
    if (isInProgress) return const CircularProgressIndicator();
    final isValid = context.select((LoginCubit cubit) => cubit.state.isValid);

    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        key: const Key('loginForm_loginButton_filledButton'),
        onPressed:
            isValid ? context.read<LoginCubit>().logInWithCredentials : null,
        child: const Text('Log in'),
      ),
    );
  }
}

class _SignUpButton extends StatelessWidget {
  const _SignUpButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: RichText(
        key: const Key('loginForm_createAccount_text'),
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            const TextSpan(
              text: 'Don\'t have an account? ',
              style: TextStyle(color: Colors.black54),
            ),
            TextSpan(
              text: 'Sign up',
              style: const TextStyle(color: Color(0xFFF06267)),
              recognizer: TapGestureRecognizer()
                ..onTap = () => Navigator.of(context).push<void>(
                      SignUpPage.route(),
                    ),
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

class _GoogleLoginButton extends StatelessWidget {
  const _GoogleLoginButton();

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      key: const Key('loginForm_googleLogin_outlinedButton'),
      onPressed: () => context.read<LoginCubit>().logInWithGoogle(),
      icon: Icon(Icons.language),
      label: const Text('Log in with Google'),
    );
  }
}
