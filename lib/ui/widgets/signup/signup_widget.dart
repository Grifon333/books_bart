import 'package:books_bart/ui/widgets/signup/signup_view_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        _NicknameFormWidget(),
        SizedBox(height: 16),
        _EmailFormWidget(),
        SizedBox(height: 16),
        _PasswordFormWidget(),
        SizedBox(height: 16),
        _ButtonWidget(),
        _ErrorWidget(),
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

class _NicknameFormWidget extends StatelessWidget {
  const _NicknameFormWidget();

  @override
  Widget build(BuildContext context) {
    final model = context.read<SignupViewModel>();
    return TextField(
      onChanged: model.onChangedNickname,
      decoration: const InputDecoration(
        labelText: 'Nickname',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }
}

class _EmailFormWidget extends StatelessWidget {
  const _EmailFormWidget();

  @override
  Widget build(BuildContext context) {
    final model = context.read<SignupViewModel>();
    return TextField(
      onChanged: model.onChangedEmail,
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

  @override
  Widget build(BuildContext context) {
    final model = context.read<SignupViewModel>();
    final isObscureText = context.select(
      (SignupViewModel vm) => vm.state.isObscureText,
    );
    final iconVisibility = Icon(
      isObscureText ? Icons.visibility_off : Icons.visibility,
      size: 24,
    );

    return TextField(
      onChanged: model.onChangedPassword,
      obscureText: isObscureText,
      obscuringCharacter: '*',
      decoration: InputDecoration(
        labelText: 'Password',
        suffixIconConstraints: const BoxConstraints(
          minHeight: 0,
          minWidth: 0,
        ),
        suffixIcon: InkWell(
          onTap: model.onChangeVisibilityPassword,
          radius: 0,
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: iconVisibility,
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
    final model = context.read<SignupViewModel>();
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: model.onSignup,
        child: const Text('Create new account'),
      ),
    );
  }
}

class _SubtextForButtonWidget extends StatelessWidget {
  const _SubtextForButtonWidget();

  @override
  Widget build(BuildContext context) {
    final model = context.read<SignupViewModel>();
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
              recognizer: TapGestureRecognizer()..onTap = model.goToLoginScreen,
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

  @override
  Widget build(BuildContext context) {
    final model = context.read<SignupViewModel>();
    return OutlinedButton(
      onPressed: model.onSignupWithGoogle,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.language),
          SizedBox(width: 10),
          Text('Sign up with Google'),
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
        context.select((SignupViewModel vm) => vm.state.errorMassage);
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
