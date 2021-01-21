library repos.search;

import 'package:gitter/services/database/database.dart';
import 'package:gitterapi/models.dart';

part 'search_repo_imp.dart';

abstract class SearchRepoAbs {
  /// Unified serach for rooms, users and chatmessages.
  Future<List> searchAll(String query, {int limit});

  /// Search for rooms.
  Future<List<Room>> searchRooms(String query, {int limit});

  /// Search and returns a list of users.
  Future<List<User>> searchUsers(String query, {int limit});
}
