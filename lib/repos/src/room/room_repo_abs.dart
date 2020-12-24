library repos.room;

import 'package:gitter/services/database/database.dart';
import 'package:gitterapi/models.dart';

part 'room_repo_imp.dart';

abstract class RoomRepoAbs {
  Future<List<Message>> getMessages(String roomId);
}
