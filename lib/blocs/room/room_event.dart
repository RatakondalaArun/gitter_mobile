part of blocs.room;

abstract class RoomEvent {
  final Room room;
  final StreamEvent streamEvent;
  final String message;
  final Object error;

  RoomEvent({
    this.room,
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
  RoomEventSendMessage({String message}) : super(message: message);
}
