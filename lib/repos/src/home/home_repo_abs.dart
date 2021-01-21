library repos.home;

import 'package:gitter/services/database/database.dart';
import 'package:gitterapi/models.dart';

part 'home_repo_imp.dart';

abstract class HomeRepoAbs {
  /// Returns current user rooms.
  Future<List<Room>> getActorRooms(String userId);
}
