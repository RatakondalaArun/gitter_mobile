library repos.room;

import 'package:gitter/services/database/database.dart';
import 'package:gitterapi/gitter_api.dart';
import 'package:gitterapi/models.dart';

part 'room_repo_imp.dart';

abstract class RoomRepoAbs {
  /// Get messages from the database.
  Future<List<Message>> getMessages(
    String roomId, {
    String beforeId,
    String afterId,
    int skip,
    int limit,
    String query,
  });

  /// Get room message stream.
  Future<Stream<StreamEvent>> getMessageStream(String roomId);

  /// Send message to room.
  Future<Message> sendMessage(
    String roomId,
    String message, {
    bool status = false,
  });

  /// Mark a List of messages a read.
  Future<void> markMessageAsRead(
    String userId,
    String roomId,
    List<String> messageIds,
  );

  /// Marks all the messages as read.
  Future<void> markAllMessagesAsRead(String userId, String roomId);

  /// adds/joins a user to a room.
  Future<Room> joinRoom(String userId, String roomId);
}
