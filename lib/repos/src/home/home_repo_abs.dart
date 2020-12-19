library repos.home;

import 'package:gitter/services/database/database.dart';
import 'package:gitterapi/models.dart';

part 'home_repo_imp.dart';

abstract class HomeRepoAbs {
  Future<List<Room>> getCurrentUserRooms(String userId);
}
