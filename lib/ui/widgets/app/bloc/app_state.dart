part of 'app_bloc.dart';

enum AppStatus { authenticated, unauthenticated }

@immutable
final class AppState extends Equatable {
  final AppStatus status;
  final User user;

  const AppState({User user = const User.anonymous()})
      : this._(
          status: user == const User.anonymous()
              ? AppStatus.unauthenticated
              : AppStatus.authenticated,
          user: user,
        );

  const AppState._({required this.status, this.user = const User.anonymous()});

  @override
  List<Object> get props => [status, user];
}
