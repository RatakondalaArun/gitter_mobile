part of blocs.auth;

/// Represents [AuthBloc] states
enum AuthBlocStates { loading, signedIn, signedOut, error }

/// State of the [AuthBloc]
class AuthState {
  /// Current Blocs state
  final AuthBlocStates blocState;

  final User user;

  /// If there is any error this will contains the message
  final String errorMessage;

  bool get isLoading => blocState == AuthBlocStates.loading;

  /// Helper method to check if user is signedIn
  bool get isSignedIn => blocState == AuthBlocStates.signedIn;

  bool get isSignedOut => blocState == AuthBlocStates.signedOut;

  /// Helper method to check if error occured
  bool get isError => blocState == AuthBlocStates.error;

  /// Creates a instance of the [AuthState]
  const AuthState(
    this.blocState, {
    this.user,
    this.errorMessage,
  });

  // Represents loading state of the bloc
  factory AuthState.loading() {
    return AuthState(AuthBlocStates.loading);
  }

  ///Represents signedIn state of the bloc
  factory AuthState.signedIn(User user) {
    return AuthState(
      AuthBlocStates.signedIn,
      user: user,
    );
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
    User user,
    String errorMessage,
  }) {
    return AuthState(
      blocState ?? this.blocState,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }
}
