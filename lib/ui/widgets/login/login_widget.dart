import 'package:books_bart/ui/widgets/login/login_view_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginWidget extends StatelessWidget {
  const LoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: _BodyWidget(),
          ),
        ),
      ),
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
          style: TextStyle(
            color: Colors.black54,
          ),
        ),
        SizedBox(height: 46),
        _EmailFormWidget(),
        SizedBox(height: 16),
        _PasswordFormWidget(),
        _ErrorWidget(),
        SizedBox(height: 16),
        _ButtonWidget(),
        SizedBox(height: 16),
        _SubtextForButtonWidget(),
        SizedBox(height: 36),
        _DividerWidget(),
        SizedBox(height: 16),
        _SignupWithGoogleButtonWidget(),
      ],
    );
  }
}

class _EmailFormWidget extends StatelessWidget {
  const _EmailFormWidget();

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: context.read<LoginViewModel>().onChangeEmail,
      decoration: const InputDecoration(
        labelText: 'Email address',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }
}

class _PasswordFormWidget extends StatelessWidget {
  const _PasswordFormWidget();

  void onTap() => debugPrint('Visibility password');

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: context.read<LoginViewModel>().onChangePassword,
      obscureText: true,
      obscuringCharacter: '*',
      decoration: InputDecoration(
        labelText: 'Password',
        suffixIconConstraints: const BoxConstraints(
          minHeight: 0,
          minWidth: 0,
        ),
        suffixIcon: InkWell(
          onTap: onTap,
          radius: 0,
          child: const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(
              Icons.visibility,
              size: 24,
            ),
          ),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }
}

class _ButtonWidget extends StatelessWidget {
  const _ButtonWidget();

  @override
  Widget build(BuildContext context) {
    final model = context.read<LoginViewModel>();
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: model.onPressedLogin,
        child: const Text('Log in'),
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
              text: 'Don\'t have an account? ',
              style: TextStyle(color: Colors.black54),
            ),
            TextSpan(
              text: 'Sign up',
              style: const TextStyle(color: Color(0xFFF06267)),
              recognizer: TapGestureRecognizer()
                ..onTap = () => debugPrint('Don\'t have an account'),
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
          child: Text(
            'or',
            style: TextStyle(color: Colors.black54),
          ),
        ),
        Expanded(child: Divider()),
      ],
    );
  }
}

class _SignupWithGoogleButtonWidget extends StatelessWidget {
  const _SignupWithGoogleButtonWidget();

  void onPressed() => debugPrint('Log in with Google');

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.language),
          SizedBox(width: 10),
          Text('Log in with Google'),
        ],
      ),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget();

  @override
  Widget build(BuildContext context) {
    final errorMassage =
        context.select((LoginViewModel vm) => vm.state.errorMassage);
    if (errorMassage == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: SizedBox(
        width: double.infinity,
        child: Text(
          errorMassage,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.red,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
