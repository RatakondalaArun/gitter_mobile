library blocs.auth.signin;

import 'package:bloc/bloc.dart';

part 'signin_event.dart';
part 'signin_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc() : super(SignInState.initial());

  @override
  Stream<SignInState> mapEventToState(SignInEvent event) async* {
    if (event is SignInEventStart) {
      yield* _mapStartToState();
    }
  }

  Stream<SignInState> _mapStartToState() async* {
    try {
      // TODO(@RatakondalaArun): Handle Event

    } catch (e) {
      // TODO(@RatakondalaArun): Handle Exception
    }
  }
}
