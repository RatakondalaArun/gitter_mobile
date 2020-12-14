part of blocs.auth;

/// Represents [AuthBloc] states
enum AuthBlocStates { initial, loading, signedIn, signedOut, error }

/// State of the [AuthBloc]
class AuthState {
  /// Current Blocs state
  final AuthBlocStates blocState;

  /// If there is any error this will contains the message
  final String errorMessage;

  /// Helper method to check if user is signedIn
  bool get isSignedIn => blocState == AuthBlocStates.signedIn;

  /// Helper method to check if error occured
  bool get isError => blocState == AuthBlocStates.error;

  /// Creates a instance of the [AuthState]
  const AuthState(
    this.blocState, {
    this.errorMessage,
  });

  // Represents initial state of this bloc
  factory AuthState.initial() {
    return AuthState(AuthBlocStates.initial);
  }

  // Represents loading state of the bloc
  factory AuthState.loading() {
    return AuthState(AuthBlocStates.loading);
  }

  ///Represents signedIn state of the bloc
  factory AuthState.signedIn() {
    // TODO(@RatakondalaArun) accept a parameter of type user
    return AuthState(AuthBlocStates.signedIn);
  }

  /// Represents signedOut state of the bloc
  factory AuthState.signedOut() {
    return AuthState(AuthBlocStates.signedOut);
  }

  /// Represents error state of the bloc
  factory AuthState.error(String errorMessage) {
    return AuthState(AuthBlocStates.error, errorMessage: errorMessage);
  }

  /// Returns a new Instance of [AuthState] by updating bloc fields
  AuthState update({
    AuthBlocStates blocState,
    String errorMessage,
  }) {
    return AuthState(
      blocState ?? this.blocState,
      errorMessage: errorMessage,
    );
  }
}
