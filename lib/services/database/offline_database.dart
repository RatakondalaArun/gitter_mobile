part of services.database;

class OfflineDatabaseService extends DatabaseServiceAbs {
  static OfflineDatabaseService _instance = OfflineDatabaseService._();
  CreditionalDatabase _creditionalDB;
  CurrentUserDatabase _currentUserDB;
  MessagesDatabase _messagesDb;
  bool _isInitilized = false;

  static OfflineDatabaseService get instance => _instance;

  @override
  bool get isInitilized => _isInitilized;

  @override
  CreditionalDatabase get creditional => _creditionalDB;

  @override
  CurrentUserDatabase get currentUser {
    if (!isInitilized) {
      throw DatabaseServiceException(
        'NOT_INITILIZED, Call init() method before using this.',
      );
    }
    return _currentUserDB;
  }

  OfflineDatabaseService._();

  @override
  Future<void> init() async {
    // TODO(@RatakondalaArun): Change this to application storage directory
    if (_isInitilized) return;
    final path = (await pp.getExternalStorageDirectory()).path;
    Hive.init(path);
    _creditionalDB =
        OfflineCreditionalDatabase(await Hive.openBox('creditional'));
    _currentUserDB = OfflineCurrentUserDatabase(
      await Hive.openBox<Map>('user'),
    );
    _messagesDb = OfflineMessagesDatabase();
    _isInitilized = true;
  }

  Future<void> close() => Hive.close();

  @override
  MessagesDatabase get messagesDB => _messagesDb;
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

  @override
  Future<List<Room>> getRooms(String userId) {
    final rooms = _currentUser.get(
      'current_user_rooms',
      defaultValue: {'rooms': []},
    )['rooms'] as List<dynamic>;
    return Future.value(rooms.map((room) => Room.fromMap(room)).toList());
  }

  @override
  Future<void> putRooms(List<Room> rooms) {
    return _currentUser.put(
      'current_user_rooms',
      {'rooms': rooms.map((r) => r.toMap()).toList()},
    );
  }
}

class OfflineCreditionalDatabase extends CreditionalDatabase {
  Box<String> _credBox;
  OfflineCreditionalDatabase(this._credBox);

  @override
  Future<void> create(String name, String value) {
    return _credBox.put(name, value);
  }

  @override
  Future<void> delete(String name) {
    return _credBox.delete(name);
  }

  @override
  Future<String> get(String name) {
    return Future.value(_credBox.get(name));
  }

  @override
  Future<void> update(String name, String value) {
    return _credBox.put(name, value);
  }
}

class OfflineMessagesDatabase extends MessagesDatabase {}
