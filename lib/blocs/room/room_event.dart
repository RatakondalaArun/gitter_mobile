part of blocs.room;

abstract class RoomEvent {
  final Room room;

  RoomEvent({this.room});
}

class RoomEventGetMessages extends RoomEvent {
  RoomEventGetMessages(Room room) : super(room: room);
}
