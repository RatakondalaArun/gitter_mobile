part of blocs.auth;

abstract class AuthEvent {}

/// Checks if user is signed in or out
class AuthEventCheckStatus extends AuthEvent {}

/// Signs in the user
class AuthEventSignedIn extends AuthEvent {}

/// Signs out current user
class AuthEventSignOut extends AuthEvent {}
