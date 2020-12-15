library blocs.auth.signin;

import 'package:bloc/bloc.dart';
import 'package:gitter/errors/app_exception.dart';
import 'package:gitterapi/models.dart';
import 'package:gitter/repos/repos.dart';

part 'signin_event.dart';
part 'signin_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final AuthRepoAbs _authRepo;
  SignInBloc(AuthRepoAbs repo)
      : _authRepo = repo,
        super(SignInState.initial()) {
    add(_InitilizeEvent());
  }

  @override
  Stream<SignInState> mapEventToState(SignInEvent event) async* {
    if (event is _InitilizeEvent) {
      await _authRepo.init();
    } else if (event is SignInEventStart) {
      yield* _mapStartToState();
    }
  }

  Stream<SignInState> _mapStartToState() async* {
    try {
      yield SignInState.signingIn();
      final user = await _authRepo.signIn();
      yield SignInState.signedIn(user);
    } on AppException catch (e) {
      yield SignInState.error(e.userError);
    } catch (e, st) {
      print(st);
      yield SignInState.error('Error while Signing In');
    }
  }
}
