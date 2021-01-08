part of repos.search;

class SearchRepoImp extends SearchRepoAbs {
  final DatabaseService _db;

  SearchRepoImp() : _db = DatabaseService.instance;
  @override
  Future<List> searchAll(String query, {int limit}) {
    // TODO: implement searchAll
    throw UnimplementedError();
  }

  @override
  Future<List<Room>> searchRooms(String query, {int limit}) {
    return _db.roomsDB.searchRooms(query, limit: limit);
  }

  @override
  Future<List<User>> searchUsers(String query, {int limit}) {
    return _db.usersDB.searchUsers(query, limit: limit);
  }
}
