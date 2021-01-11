part of repos.user;

class UserRepoImp extends UserRepoAbs {
  final _db = DatabaseService.instance;

  @override
  Future<UserProfile> getUserProfile(String username) {
    return _db.usersDB.getProfile(username);
  }
}
