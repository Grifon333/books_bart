import 'package:authentication_repository/authentication_repository.dart';
import 'package:books_bart/ui/navigation/main_navigation.dart';
import 'package:books_bart/ui/theme/main_theme.dart';
import 'package:books_bart/ui/widgets/app/app.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_repository/order_repository.dart';

class App extends StatelessWidget {
  final AuthenticationRepository _authenticationRepository;

  const App({
    super.key,
    required AuthenticationRepository authenticationRepository,
  }) : _authenticationRepository = authenticationRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenticationRepository>(
          create: (_) => _authenticationRepository,
        ),
        RepositoryProvider<OrderRepository>(create: (_) => OrderRepository()),
      ],
      child: BlocProvider(
        lazy: false,
        create: (context) => AppBloc(
          authenticationRepository: _authenticationRepository,
        )..add(const AppUserSubscriptionRequested()),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  static final _mainNavigation = MainNavigation();
  static final _mainTheme = MainTheme();

  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _mainTheme.themeData,
      home: FlowBuilder<AppStatus>(
        state: context.select((AppBloc bloc) => bloc.state.status),
        onGeneratePages: onGenerateAppViewPages,
      ),
      // routes: _mainNavigation.routes,
      // onGenerateRoute: _mainNavigation.onGenerateRoute,
    );
  }
}
