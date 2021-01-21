part of repos.home;

class HomeRepoImp extends HomeRepoAbs {
  DatabaseService _db;

  HomeRepoImp() : _db = DatabaseService.instance;

  @override
  Future<List<Room>> getActorRooms(String userId) async {
    try {
      final rooms = await _db.currentUser.getRooms(userId) ?? [];
      if (rooms.isNotEmpty) {
        await _db.currentUser.putRooms(rooms);
      }
      return rooms;
    } catch (e, st) {
      print('$e $st');
      return [];
    }
  }
}
