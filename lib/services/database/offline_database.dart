part of services.database;

class OfflineDatabaseService extends DatabaseServiceAbs {
  CurrentUserDatabase _currentUserDB;
  bool _isInitilized = false;

  @override
  bool get isInitilized => _isInitilized;

  @override
  CurrentUserDatabase get currentUser {
    if (!isInitilized) {
      throw DatabaseServiceException(
        'NOT_INITILIZED, Call init() method before using this.',
      );
    }
    return _currentUserDB;
  }

  OfflineDatabaseService() {
    init();
  }

  @override
  Future<void> init() async {
    // TODO(@RatakondalaArun): Change this to application storage directory
    if (isInitilized) return;
    final path = (await pp.getExternalStorageDirectory()).path;
    Hive.init(path);
    _currentUserDB = OfflineCurrentUserDatabase(
      await Hive.openBox<Map>('user'),
    );
    _isInitilized = true;
  }

  // Future<Box<T>> createIfNotExist<T>(String name) async {
  //   if (await Hive.boxExists(name)) {
  //     return Hive.openBox(name);
  //   }
  //   return await Hive.openBox(name);
  // }

  Future<void> close() => Hive.close();
}

class OfflineCurrentUserDatabase extends CurrentUserDatabase {
  Box<Map> _currentUser;

  OfflineCurrentUserDatabase(this._currentUser);

  Stream<User> get currentUserChanges {
    return _currentUser
        .watch(key: 'current_user')
        .map<User>((event) => User.fromMap(event.value))
        .asBroadcastStream();
  }

  @override
  Future<void> create(User user) {
    return _currentUser.put('current_user', user.toMap());
  }

  @override
  Future<void> delete() {
    return _currentUser.delete('current_user');
  }

  @override
  Future<User> get() {
    return Future.value(User.fromMap(_currentUser.get('current_user')));
  }

  @override
  Future<void> update(User user) {
    return _currentUser.put('current_user', user.toMap());
  }
}
