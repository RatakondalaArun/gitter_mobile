part of blocs.room;

/// Abstract class of Events which occur in a room.
abstract class RoomEvent {
  /// Current room the user is in.
  final Room room;

  /// Events fired in the room like new message.
  final StreamEvent streamEvent;

  /// Message sent by user to [room].
  final String message;

  /// Error object of [streamEvent].
  final Object _error;

  /// Creates a instance of [Room].
  RoomEvent({
    this.room,
    this.streamEvent,
    this.message,
    Object error,
  }) : this._error = error;
}

/// This event Initilizes the bloc with [Room].
class RoomEventInitilize extends RoomEvent {
  RoomEventInitilize(Room room) : super(room: room);
}

/// This event loads next messages form server.
class RoomEventPaginateMessages extends RoomEvent {}

/// This event notifies [RoomBloc] about new chat messages.
class _StreamMessageEvent extends RoomEvent {
  _StreamMessageEvent(
    StreamEvent streamEvent,
  ) : super(streamEvent: streamEvent);
}

/// This event notifies [RoomBloc] about chat message stream
/// disconnected.
class _StreamMessageDisconnectedEvent extends RoomEvent {
  _StreamMessageDisconnectedEvent(Object error) : super(error: error);
}

/// This event sends message to the server.
class RoomEventSendMessage extends RoomEvent {
  RoomEventSendMessage({String message}) : super(message: message);
}

/// Joins the current user to this rom.
class RoomEventJoin extends RoomEvent {}
