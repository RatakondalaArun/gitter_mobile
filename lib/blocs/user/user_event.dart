part of blocs.user;

abstract class UserEvent {
  final User of;
  UserEvent({this.of});
}

class UserEventLoadProfile extends UserEvent {
  /// Which user profile to load.
  UserEventLoadProfile(User of) : super(of: of);
}
