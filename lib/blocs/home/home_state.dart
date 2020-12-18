part of blocs.home;

enum HomeBlocStates { initial, loading, loaded, error }

class HomeState {
  final HomeBlocStates blocState;
  final bool isDMUnread;
  final List<Room> rooms;
  final List<Room> chats;
  final bool shouldUpdateNavBar;
  final String errorMessage;

  bool get isInitial => blocState == HomeBlocStates.initial;
  bool get isLoading => blocState == HomeBlocStates.loading;
  bool get isLoaded => blocState == HomeBlocStates.loaded;
  bool get isError => blocState == HomeBlocStates.error;

  HomeState(
    this.blocState, {
    this.rooms = const [],
    this.chats = const [],
    this.isDMUnread = false,
    this.shouldUpdateNavBar = false,
    this.errorMessage,
  });

  factory HomeState.initial() {
    return HomeState(HomeBlocStates.initial);
  }

  factory HomeState.loading() {
    return HomeState(HomeBlocStates.loading);
  }

  factory HomeState.loaded({
    List<Room> rooms,
    List<Room> chats,
    bool isDMUnread,
  }) {
    return HomeState(
      HomeBlocStates.loaded,
      rooms: rooms,
      chats: chats,
      isDMUnread: isDMUnread,
    );
  }

  factory HomeState.error(String errorMessage) {
    return HomeState(
      HomeBlocStates.error,
      errorMessage: errorMessage,
    );
  }

  HomeState update({
    HomeBlocStates blocStates,
    List<Room> rooms,
    List<Room> chats,
    bool isDMUnread,
    bool shouldUpdateNavBar,
    String errorMessage,
  }) {
    return HomeState(
      blocState ?? this.blocState,
      shouldUpdateNavBar: shouldUpdateNavBar ?? false,
      rooms: rooms ?? this.rooms,
      chats: chats ?? this.chats,
      isDMUnread: isDMUnread ?? this.isDMUnread,
      errorMessage: errorMessage,
    );
  }
}
