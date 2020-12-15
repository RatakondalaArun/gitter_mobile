part of blocs.auth;

abstract class AuthEvent {
  final User user;

  AuthEvent({this.user});
}

/// This is the first event in the bloc.
class _InitialEvent extends AuthEvent {}

/// This event gets triggered everytime user state changes.
class _UserStateChanged extends AuthEvent {
  @override
  final User user;

  _UserStateChanged(this.user);
}

/// Checks if user is signed in or out
class AuthEventCheckStatus extends AuthEvent {}

/// Signs out current user
class AuthEventSignOut extends AuthEvent {}
