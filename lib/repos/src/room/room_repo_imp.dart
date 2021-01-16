part of repos.room;

class RoomRepoImp extends RoomRepoAbs {
  final DatabaseService _db;

  RoomRepoImp() : _db = DatabaseService.instance;

  @override
  Future<List<Message>> getMessages(
    String roomId, {
    String beforeId,
    String afterId,
    int skip,
    int limit,
    String query,
  }) {
    return _db.messagesDB.getMessages(
      roomId,
      beforeId: beforeId,
      afterId: afterId,
      skip: skip,
      limit: limit,
      query: query,
    );
  }

  @override
  Future<Stream<StreamEvent>> getMessageStream(String roomId) {
    return _db.messagesDB.getMessagesStream(roomId);
  }

  @override
  Future<Message> sendMessage(
    String roomId,
    String message, {
    bool status = false,
  }) {
    return _db.messagesDB.createMessage(roomId, message, status: status);
  }

  @override
  Future<void> markMessageAsRead(
    String userId,
    String roomId,
    List<String> messageIds,
  ) {
    return _db.messagesDB.markMessageAsRead(userId, roomId, messageIds);
  }

  @override
  Future<void> markAllMessagesAsRead(String userId, String roomId) {
    return _db.messagesDB.markAllMessagesAsRead(userId, roomId);
  }
}
