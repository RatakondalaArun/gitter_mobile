library blocs.auth.signin;

import 'package:bloc/bloc.dart';
import 'package:gitter/repos/repos.dart';
import 'package:gitterapi/models/user.dart';

part 'signin_event.dart';
part 'signin_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final AuthRepoAbs _authRepo;
  SignInBloc(AuthRepoAbs repo)
      : _authRepo = repo,
        super(SignInState.initial());

  @override
  Stream<SignInState> mapEventToState(SignInEvent event) async* {
    if (event is SignInEventStart) {
      yield* _mapStartToState();
    }
  }

  Stream<SignInState> _mapStartToState() async* {
    try {
      // TODO(@RatakondalaArun): Handle Event
      yield SignInState.signingIn();
      final user = await _authRepo.signIn();
      yield SignInState.signedIn(user);
    } catch (e, st) {
      // TODO(@RatakondalaArun): Handle Exception
      print(st);
      yield SignInState.error('Error while Signing In');
    }
  }
}
