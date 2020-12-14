library blocs.auth;

import 'package:bloc/bloc.dart';

part 'auth_state.dart';
part 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthState.initial());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AuthEventCheckStatus) {
      yield* _mapCheckStatusToState(event);
    } else if (event is AuthEventSignedIn) {
      yield* _mapSignedInToState(event);
    } else if (event is AuthEventSignOut) {
      yield* _mapSignedOutToState(event);
    }
  }

  Stream<AuthState> _mapCheckStatusToState(AuthEventCheckStatus event) async* {
    try {
      // TODO(@RatakondalaArun): Handle Event
    } catch (e) {
      // TODO(@RatakondalaArun): Handle Exceptions
    }
  }

  Stream<AuthState> _mapSignedInToState(AuthEventSignedIn event) async* {
    try {
      // TODO(@RatakondalaArun): Handle Event
    } catch (e) {
      // TODO(@RatakondalaArun): Handle Exceptions
    }
  }

  Stream<AuthState> _mapSignedOutToState(AuthEventSignOut event) async* {
    try {
      // TODO(@RatakondalaArun): Handle Event
    } catch (e) {
      // TODO(@RatakondalaArun): Handle Exceptions
    }
  }
}
