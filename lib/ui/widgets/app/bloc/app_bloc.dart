import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'app_event.dart';

part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AuthenticationRepository _authenticationRepository;

  AppBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(AppState(user: authenticationRepository.currentUser)) {
    on<AppUserSubscriptionRequested>(_onUserSubscriptionRequested);
    on<AppLogoutPressed>(_onLogoutPressed);
  }

  Future<void> _onUserSubscriptionRequested(
    AppUserSubscriptionRequested event,
    Emitter<AppState> emit,
  ) async {
    return emit.onEach(
      _authenticationRepository.user,
      onData: (user) => emit(AppState(user: user)),
      onError: addError,
    );
  }

  void _onLogoutPressed(AppLogoutPressed event, Emitter<AppState> emit) {
    _authenticationRepository.logOut();
  }
}