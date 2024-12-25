import 'package:authentication_repository/authentication_repository.dart';
import 'package:books_bart/ui/widgets/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: LoginPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: BlocProvider(
              create: (_) => LoginCubit(
                context.read<AuthenticationRepository>(),
              ),
              child: LoginForm(),
            ),
          ),
        ),
      )
    );
  }
}
