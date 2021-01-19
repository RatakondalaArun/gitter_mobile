part of blocs.room;

enum RoomBlocState { initial, loading, loaded, error }
enum RoomMessagesState { loading, loaded }
enum RoomMessageStreamState { connecting, connected, disconnected }
enum MessageSentState { sending, sent, failed }
enum RoomMemberShipStatus { left, joining, joined }

class RoomState {
  final RoomBlocState blocState;
  final RoomMessagesState messagesState;
  final RoomMessageStreamState messageStreamState;
  final RoomMemberShipStatus memberShipStatus;

  /// Contains ids of the pending messages.
  final Set<String> pendingMessagesIds;

  /// tells if a message is being sent to server.
  final MessageSentState messageState;
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
    Set<String> pendingMessagesIds,
    this.messageState = MessageSentState.sent,
    this.messagesState = RoomMessagesState.loading,
    this.messageStreamState = RoomMessageStreamState.connecting,
    this.memberShipStatus = RoomMemberShipStatus.left,
    this.room,
    this.isAtEdge = false,
    List<Message> messages,
    this.errorMessage,
  })  : this.pendingMessagesIds = pendingMessagesIds ?? <String>{},
        this.messages = messages ?? <Message>[];

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
      memberShipStatus: room.roomMember
          ? RoomMemberShipStatus.joined
          : RoomMemberShipStatus.left,
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
    MessageSentState messageState,
    RoomMessagesState messagesState,
    RoomMemberShipStatus memberShipStatus,
    RoomMessageStreamState roomMessageStreamState,
    Set<String> pendingMessagesIds,
    Room room,
    List<Message> messages,
    String errorMessage,
    bool shouldUpdateChat = false,
    bool isAtEdge,
  }) {
    return RoomState(
      blocState ?? this.blocState,
      pendingMessagesIds: pendingMessagesIds ?? this.pendingMessagesIds,
      messageState: messageState ?? this.messageState,
      messagesState: messagesState ?? this.messagesState,
      messageStreamState: messageStreamState ?? this.messageStreamState,
      memberShipStatus: memberShipStatus ?? this.memberShipStatus,
      room: room ?? this.room,
      messages: messages ?? this.messages,
      isAtEdge: isAtEdge ?? this.isAtEdge,
      shouldUpdateChat: shouldUpdateChat,
      errorMessage: errorMessage,
    );
  }
}
