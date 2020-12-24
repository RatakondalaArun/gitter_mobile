part of blocs.room;

enum RoomBlocState { initial, loading, loaded, error }

class RoomState {
  final RoomBlocState blocState;
  final List<Message> messages;
  final String errorMessage;

  bool get isInitial => blocState == RoomBlocState.initial;
  bool get isLoading => blocState == RoomBlocState.loading;
  bool get isLoaded => blocState == RoomBlocState.loaded;
  bool get isError => blocState == RoomBlocState.error;

  RoomState(
    this.blocState, {
    this.messages = const [],
    this.errorMessage,
  });

  factory RoomState.initial() {
    return RoomState(
      RoomBlocState.initial,
    );
  }

  factory RoomState.loading() {
    return RoomState(
      RoomBlocState.loading,
    );
  }

  factory RoomState.loaded(List<Message> messages) {
    return RoomState(
      RoomBlocState.loaded,
      messages: messages,
    );
  }

  factory RoomState.error(String errorMessage) {
    return RoomState(
      RoomBlocState.error,
      errorMessage: errorMessage,
    );
  }
}
