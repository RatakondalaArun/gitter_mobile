part of blocs.room;

abstract class RoomEvent {
  final Room room;
  final User currentUser;
  final StreamEvent streamEvent;
  final String message;
  final Object error;

  RoomEvent({
    this.room,
    this.currentUser,
    this.streamEvent,
    this.message,
    this.error,
  });
}

class RoomEventInitilize extends RoomEvent {
  RoomEventInitilize(Room room) : super(room: room);
}

class RoomEventLoadNext extends RoomEvent {}

class _StreamMessageEvent extends RoomEvent {
  _StreamMessageEvent(
    StreamEvent streamEvent,
  ) : super(streamEvent: streamEvent);
}

class _StreamMessageDisconnectedEvent extends RoomEvent {
  _StreamMessageDisconnectedEvent(Object error) : super(error: error);
}

class RoomEventSendMessage extends RoomEvent {
  RoomEventSendMessage({
    User currentUser,
    String message,
  }) : super(
          currentUser: currentUser,
          message: message,
        );
}
