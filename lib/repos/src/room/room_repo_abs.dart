library repos.room;

import 'package:gitter/services/database/database.dart';
import 'package:gitterapi/gitter_api.dart';
import 'package:gitterapi/models.dart';

part 'room_repo_imp.dart';

abstract class RoomRepoAbs {
  Future<List<Message>> getMessages(
    String roomId, {
    String beforeId,
    String afterId,
    int skip,
    int limit,
    String query,
  });

  Future<Stream<StreamEvent>> getMessageStream(String roomId);

  Future<Message> sendMessage(
    String roomId,
    String message, {
    bool status = false,
  });

  Future<void> markMessageAsRead(
    String userId,
    String roomId,
    List<String> messageIds,
  );

  Future<void> markAllMessagesAsRead(String userId, String roomId);

  Future<Room> joinRoom(String userId, String roomId);
}
