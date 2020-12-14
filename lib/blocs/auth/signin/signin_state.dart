part of blocs.auth.signin;

enum SignInBlocStates { initial, signingIn, signedIn, error }

class SignInState {
  final SignInBlocStates blocState;
  final User user;
  final String errorMessage;

  bool get isError => blocState == SignInBlocStates.error;

  SignInState(
    this.blocState, {
    this.user,
    this.errorMessage,
  });

  factory SignInState.initial() {
    return SignInState(SignInBlocStates.initial);
  }

  factory SignInState.signingIn() {
    return SignInState(SignInBlocStates.signingIn);
  }

  factory SignInState.signedIn(User user) {
    return SignInState(
      SignInBlocStates.signedIn,
      user: user,
    );
  }

  factory SignInState.error(String errorMessage) {
    return SignInState(
      SignInBlocStates.error,
      errorMessage: errorMessage,
    );
  }

  SignInState update({
    SignInBlocStates blocState,
    User user,
    String errorMessage,
  }) {
    return SignInState(
      blocState ?? this.blocState,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }
}
