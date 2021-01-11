part of blocs.user;

enum UserBlocState { initial, loading, loaded, error }

class UserState {
  final UserBlocState blocState;
  final User user;
  final UserProfile userProfile;
  final String errorMessage;

  bool get isInitial => blocState == UserBlocState.initial;
  bool get isLoading => blocState == UserBlocState.loading;
  bool get isLoaded => blocState == UserBlocState.loaded;
  bool get isError => blocState == UserBlocState.error;

  UserState(
    this.blocState, {
    this.user,
    this.userProfile,
    this.errorMessage,
  });

  factory UserState.initial() {
    return UserState(UserBlocState.initial);
  }

  factory UserState.loading() {
    return UserState(UserBlocState.loading);
  }

  factory UserState.loaded({
    User user,
    UserProfile userProfile,
  }) {
    return UserState(
      UserBlocState.loaded,
      user: user,
      userProfile: userProfile,
    );
  }

  factory UserState.error(String errorMessage) {
    return UserState(UserBlocState.error, errorMessage: errorMessage);
  }

  UserState update({
    UserBlocState blocState,
    User user,
    UserProfile userProfile,
    String errorMessage,
  }) {
    return UserState(
      blocState ?? this.blocState,
      user: user ?? this.user,
      userProfile: userProfile ?? this.userProfile,
      errorMessage: errorMessage,
    );
  }

  UserState error(String errorMessage) {
    return UserState(
      UserBlocState.error,
      user: this.user,
      userProfile: this.userProfile,
      errorMessage: errorMessage,
    );
  }

  UserState loaded({
    User user,
    UserProfile userProfile,
  }) {
    return UserState(
      UserBlocState.loaded,
      user: user ?? this.user,
      userProfile: userProfile ?? this.userProfile,
    );
  }
}
