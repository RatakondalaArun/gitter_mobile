part of blocs.room;

enum RoomBlocState { initial, loading, loaded, error }
enum RoomMessagesState { loading, loaded }
enum RoomMessageStreamState { connecting, connected, disconnected }

class RoomState {
  final RoomBlocState blocState;
  final RoomMessagesState messagesState;
  final RoomMessageStreamState messageStreamState;
  final Room room;
  final bool isAtEdge;
  final List<Message> messages;
  final bool shouldUpdateChat;
  final String errorMessage;

  bool get isInitial => blocState == RoomBlocState.initial;
  bool get isLoading => blocState == RoomBlocState.loading;
  bool get isLoaded => blocState == RoomBlocState.loaded;
  bool get isError => blocState == RoomBlocState.error;

  bool get isMessagesLoading => messagesState == RoomMessagesState.loading;
  bool get isMessagesLoaded => messagesState == RoomMessagesState.loaded;

  bool get isMessageStreamLoading {
    return messageStreamState == RoomMessageStreamState.connecting;
  }

  bool get isMessageStreamLoaded {
    return messageStreamState == RoomMessageStreamState.connecting;
  }

  bool get isMessageStreamDisconnected {
    return messageStreamState == RoomMessageStreamState.disconnected;
  }

  RoomState(
    this.blocState, {
    this.shouldUpdateChat = false,
    this.messagesState = RoomMessagesState.loading,
    this.messageStreamState = RoomMessageStreamState.connecting,
    this.room,
    this.isAtEdge = false,
    this.messages = const [],
    this.errorMessage,
  });

  factory RoomState.initial() {
    return RoomState(
      RoomBlocState.initial,
      messages: [],
    );
  }

  factory RoomState.loading() {
    return RoomState(
      RoomBlocState.loading,
      messages: [],
    );
  }

  factory RoomState.loaded({
    @required Room room,
    @required List<Message> messages,
    bool isAtEdge = false,
  }) {
    return RoomState(
      RoomBlocState.loaded,
      messagesState: RoomMessagesState.loaded,
      room: room,
      messages: messages,
      isAtEdge: isAtEdge,
      shouldUpdateChat: true,
    );
  }

  factory RoomState.error(String errorMessage) {
    return RoomState(
      RoomBlocState.error,
      errorMessage: errorMessage,
    );
  }

  RoomState update({
    RoomBlocState blocState,
    RoomMessagesState messagesState,
    RoomMessageStreamState roomMessageStreamState,
    Room room,
    List<Message> messages,
    String errorMessage,
    bool shouldUpdateChat = false,
    bool isAtEdge,
  }) {
    return RoomState(
      blocState ?? this.blocState,
      messagesState: messagesState ?? this.messagesState,
      messageStreamState: messageStreamState ?? this.messageStreamState,
      room: room ?? this.room,
      messages: messages ?? this.messages,
      isAtEdge: isAtEdge ?? this.isAtEdge,
      shouldUpdateChat: shouldUpdateChat,
      errorMessage: errorMessage,
    );
  }
}
