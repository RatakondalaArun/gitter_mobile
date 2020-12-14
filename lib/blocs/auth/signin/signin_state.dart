part of blocs.auth.signin;

enum SignInBlocStates { initial, signingIn, signedIn, error }

class SignInState {
  final SignInBlocStates blocState;
  final String errorMessage;

  bool get isError => blocState == SignInBlocStates.error;

  SignInState(
    this.blocState, {
    this.errorMessage,
  });

  factory SignInState.initial() {
    return SignInState(SignInBlocStates.initial);
  }

  factory SignInState.signingIn() {
    return SignInState(SignInBlocStates.signingIn);
  }

  factory SignInState.signedIn() {
    return SignInState(SignInBlocStates.signedIn);
  }

  factory SignInState.error(String errorMessage) {
    return SignInState(
      SignInBlocStates.error,
      errorMessage: errorMessage,
    );
  }

  SignInState update({
    SignInBlocStates blocState,
    String errorMessage,
  }) {
    return SignInState(
      blocState ?? this.blocState,
      errorMessage: errorMessage,
    );
  }
}
