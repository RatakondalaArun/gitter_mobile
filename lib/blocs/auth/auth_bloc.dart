library blocs.auth;

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:gitter/repos/repos.dart';
import 'package:gitterapi/models.dart';

part 'auth_state.dart';
part 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthRepoAbs _authRepo;
  StreamSubscription _userStateSub;

  AuthBloc(this._authRepo) : super(AuthState.loading()) {
    add(_InitialEvent());
  }

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is _InitialEvent) {
      yield* _mapInitialEvent();
    } else if (event is _UserStateChanged) {
      yield* _mapUserStateToEvent(event);
    } else if (event is AuthEventCheckStatus) {
      yield* _mapCheckStatusToState(event);
    } else if (event is AuthEventSignOut) {
      yield* _mapSignedOutToState(event);
    }
  }

  Stream<AuthState> _mapInitialEvent() async* {
    // This handles authrepo initilization and
    // listens to user state changes events.
    try {
      yield AuthState.loading();
      if (!_authRepo.isInitilized) {
        await _authRepo.init();
      }
      await _userStateSub?.cancel();
      _userStateSub =
          _authRepo.actorStream.listen((user) => add(_UserStateChanged(user)));
      add(AuthEventCheckStatus());
    } catch (e, st) {
      print(e);
      print(st);
      yield AuthState.error('Error While Loading app');
    }
  }

  Stream<AuthState> _mapUserStateToEvent(_UserStateChanged event) async* {
    try {
      if (event.user == null) {
        yield AuthState.signedOut();
      } else {
        yield AuthState.signedIn(event.user);
      }
    } catch (e) {
      // todo:
    }
  }

  Stream<AuthState> _mapCheckStatusToState(AuthEventCheckStatus event) async* {
    // checks if the current user is signed in if yes
    // it yields state to signed in
    try {
      final user = await _authRepo.getActor();
      if (user == null) {
        yield AuthState.signedOut();
      } else {
        yield AuthState.signedIn(user);
      }
    } catch (e, st) {
      print(e);
      print(st);
      // TODO(@RatakondalaArun): Handle Exceptions
      yield AuthState.error('Something went wrong!');
    }
  }

  Stream<AuthState> _mapSignedOutToState(AuthEventSignOut event) async* {
    try {
      // TODO(@RatakondalaArun): Handle Event
      yield state.update(blocState: AuthBlocStates.loading);
      await _authRepo.signOut();
      yield AuthState.signedOut();
    } catch (e) {
      // TODO(@RatakondalaArun): Handle Exceptions
      yield AuthState.error('Something went wrong');
    }
  }

  @override
  Future<void> close() async {
    await _userStateSub?.cancel();
    return super.close();
  }
}
