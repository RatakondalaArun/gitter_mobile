part of repos.room;

class RoomRepoImp extends RoomRepoAbs {
  final DatabaseService _db;

  RoomRepoImp() : _db = DatabaseService.instance;

  @override
  Future<List<Message>> getMessages(String roomId) {
    return _db.messagesDB.getMessages(roomId);
  }
}
