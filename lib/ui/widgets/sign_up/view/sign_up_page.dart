import 'package:authentication_repository/authentication_repository.dart';
import 'package:books_bart/ui/widgets/sign_up/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const SignUpPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: BlocProvider(
              create: (_) => SignUpCubit(
                context.read<AuthenticationRepository>(),
              ),
              child: SignUpForm(),
            ),
          ),
        ),
      ),
    );
  }
}
