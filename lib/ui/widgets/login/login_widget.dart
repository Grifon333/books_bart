import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

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
        //TODO: Username
        _EmailFormWidget(),
        SizedBox(height: 20),
        _PasswordFormWidget(),
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

  void onChanged(String value) => debugPrint('Email address: $value');

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
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

  void onChanged(String value) => debugPrint('Password: $value');

  void onTap() => debugPrint('Visibility password');

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
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

  void onPressed() => debugPrint('Log in');

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
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
