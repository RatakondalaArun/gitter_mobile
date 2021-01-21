part of blocs.room;

/// [RoomBloc] can only be in this states.
enum RoomBlocState {
  loading,
  loaded,
  error,
}

/// Pagination
enum PaginationState {
  /// Data is loading.
  loading,

  /// Data loaded.
  loaded,
}

/// Specifies stream status.
enum RoomMessageStreamStatus {
  /// Stream is making a connection with server.
  connecting,

  /// Stream is successfully connected to server.
  connected,

  /// Stream is disconnected from server.
  disconnected,
}

/// Indicates Message Delivary status.
enum MessageDelivaryStatus {
  /// Message is sending to server.
  sending,

  /// Messages is succuessfully sent to server.
  sent,

  /// Message failed to sent to server.
  failed,
}

/// Specifies if a user is belonged to room.
enum RoomMemberShipStatus {
  /// Indicates user is not a room member.
  left,

  /// User is joining a room.
  joining,

  /// User joined the room.
  joined,
}

class RoomState {
  /// Status of the [RoomBloc]
  final RoomBlocState blocState;

  /// Returns pagination status.
  final PaginationState paginationStatus;

  /// Returns the status messages stream from server.
  final RoomMessageStreamStatus messageStreamState;

  /// Retursn if a user is member or joining or left a room.
  final RoomMemberShipStatus memberShipStatus;

  /// Contains ids of the pending messages.
  final Set<String> pendingMessagesIds;

  /// tells if a message is being sent to server.
  final MessageDelivaryStatus messageDelivaryStaus;

  /// Instance of [Room] this bloc is initilized with.
  final Room room;

  /// Returns true if there are no more
  /// messages to be loaded from server.
  final bool isAtEdge;

  /// Returns a list of chat messages.
  final List<Message> messages;

  /// This indicated if chat needs to be updated.
  final bool shouldUpdateChat;

  /// This contains user specific error messages.
  final String errorMessage;

  bool get isLoading => blocState == RoomBlocState.loading;
  bool get isLoaded => blocState == RoomBlocState.loaded;
  bool get isError => blocState == RoomBlocState.error;

  bool get isPaginating => paginationStatus == PaginationState.loading;
  bool get isPaginated => paginationStatus == PaginationState.loaded;

  bool get isMessageStreamLoading {
    return messageStreamState == RoomMessageStreamStatus.connecting;
  }

  bool get isMessageStreamLoaded {
    return messageStreamState == RoomMessageStreamStatus.connecting;
  }

  bool get isMessageStreamDisconnected {
    return messageStreamState == RoomMessageStreamStatus.disconnected;
  }

  /// Creates a instance of [RoomState].
  RoomState(
    this.blocState, {
    this.shouldUpdateChat = false,
    Set<String> pendingMessagesIds,
    this.messageDelivaryStaus = MessageDelivaryStatus.sent,
    this.paginationStatus = PaginationState.loading,
    this.messageStreamState = RoomMessageStreamStatus.connecting,
    this.memberShipStatus = RoomMemberShipStatus.left,
    this.room,
    this.isAtEdge = false,
    List<Message> messages,
    this.errorMessage,
  })  : this.pendingMessagesIds = pendingMessagesIds ?? <String>{},
        this.messages = messages ?? <Message>[];

  /// Creates a instance of [RoomState]
  /// with all fields set to loading.
  factory RoomState.loading() {
    return RoomState(
      RoomBlocState.loading,
      messages: [],
    );
  }

  /// Creates a instance of [RoomState].
  /// with loaded data.
  factory RoomState.loaded({
    @required Room room,
    @required List<Message> messages,
    bool isAtEdge = false,
  }) {
    return RoomState(
      RoomBlocState.loaded,
      paginationStatus: PaginationState.loaded,
      memberShipStatus: room.roomMember
          ? RoomMemberShipStatus.joined
          : RoomMemberShipStatus.left,
      room: room,
      messages: messages,
      isAtEdge: isAtEdge,
      shouldUpdateChat: true,
    );
  }

  /// Creates a instance of [RoomState]
  /// indicated that bloc encountered a error.
  factory RoomState.error(String errorMessage) {
    return RoomState(
      RoomBlocState.error,
      errorMessage: errorMessage,
    );
  }

  /// Returns a instance of [RoomState]
  /// while only updating necessary fields.
  RoomState update({
    RoomBlocState blocState,
    MessageDelivaryStatus messageDelivaryStatus,
    PaginationState paginationStatus,
    RoomMemberShipStatus memberShipStatus,
    RoomMessageStreamStatus messageStreamState,
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
      messageDelivaryStaus: messageDelivaryStatus ?? this.messageDelivaryStaus,
      paginationStatus: paginationStatus ?? this.paginationStatus,
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
