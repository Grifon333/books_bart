import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUpWidget extends StatelessWidget {
  const SignUpWidget({super.key});

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
          style: TextStyle(
            color: Colors.black54,
          ),
        ),
        SizedBox(height: 46),
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

  @override
  Widget build(BuildContext context) {
    return const TextField(
      decoration: InputDecoration(
        labelText: 'Email address',
        isCollapsed: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }
}

class _PasswordFormWidget extends StatelessWidget {
  const _PasswordFormWidget();

  @override
  Widget build(BuildContext context) {
    return const TextField(
      obscureText: true,
      obscuringCharacter: '*',
      decoration: InputDecoration(
        labelText: 'Password',
        isCollapsed: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        // suffix: Icon(Icons.visibility),
        border: OutlineInputBorder(
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
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: const ButtonStyle(
          minimumSize: MaterialStatePropertyAll(Size(0, 50)),
          shape: MaterialStatePropertyAll(RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          )),
          backgroundColor: MaterialStatePropertyAll(Color(0xFF7E675E)),
        ),
        child: const Text(
          'Create new account',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
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
                ..onTap = () => debugPrint('Already have an account'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DividerWidget extends StatelessWidget {
  const _DividerWidget();

  final Widget horizontalDivider = const SizedBox(
    height: 0.5,
    child: ColoredBox(color: Colors.black54),
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: horizontalDivider),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or',
            style: TextStyle(color: Colors.black54),
          ),
        ),
        Expanded(child: horizontalDivider),
      ],
    );
  }
}

class _SignupWithGoogleButtonWidget extends StatelessWidget {
  const _SignupWithGoogleButtonWidget();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ButtonStyle(
        minimumSize: const MaterialStatePropertyAll(Size(double.infinity, 50)),
        shadowColor: const MaterialStatePropertyAll(Colors.transparent),
        backgroundColor: const MaterialStatePropertyAll(Colors.white),
        // surfaceTintColor: const MaterialStatePropertyAll(Colors.transparent),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Color(0xFF7E675E))),
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.language,
            color: Color(0xFF7E675E),
          ),
          SizedBox(width: 10),
          Text(
            'Sign up with Google',
            style: TextStyle(
              color: Color(0xFF7E675E),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
