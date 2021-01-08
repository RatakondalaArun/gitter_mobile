library repos.search;

import 'package:gitter/services/database/database.dart';
import 'package:gitterapi/models.dart';

part 'search_repo_imp.dart';

abstract class SearchRepoAbs {
  Future<List> searchAll(String query, {int limit});

  Future<List<Room>> searchRooms(String query, {int limit});

  Future<List<User>> searchUsers(String query, {int limit});
}
