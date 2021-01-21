library blocs.user;

import 'package:bloc/bloc.dart';
import 'package:gitter/blocs/blocs.dart';
import 'package:gitter/repos/src/user/user_repo_abs.dart';

part 'user_event.dart';
part 'user_state.dart';

/// Handles user profile.
class UserBloc extends Bloc<UserEvent, UserState> {
  UserRepoAbs _userRepo;

  UserBloc(this._userRepo) : super(UserState.loading());

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is UserEventLoadProfile) {
      yield* _mapLoadProfileToState(event);
    }
  }

  // loads user profile to state.
  Stream<UserState> _mapLoadProfileToState(UserEventLoadProfile event) async* {
    try {
      if (event.of != null) {
        final profile = await _userRepo.getUserProfile(event.of.username);
        yield UserState.loaded(
          user: event.of,
          userProfile: profile,
        );
      }
    } catch (e, st) {
      //
      print(st);
    }
  }
}
