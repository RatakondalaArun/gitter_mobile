part of services.database;

class OnlineDatabaseService extends DatabaseServiceAbs {
  static OnlineDatabaseService _instance = OnlineDatabaseService._();
  OfflineDatabaseService _offlineDB;
  CurrentUserDatabase _userDB;
  bool _isInitilized = false;
  GitterApi _gitterApi;

  static OnlineDatabaseService get instance => _instance;

  OnlineDatabaseService._() {
    _offlineDB = OfflineDatabaseService._instance;
  }

  @override
  bool get isInitilized => _isInitilized;

  @override
  CreditionalDatabase get creditional => throw UnimplementedError();

  @override
  CurrentUserDatabase get currentUser => _userDB;

  @override
  Future<void> init() async {
    final accessToken = await _offlineDB.creditional.get('access_token');
    _gitterApi = GitterApi(ApiKeys(accessToken));
    _userDB = OnlineCurrentUserDatabase(_gitterApi);
    _isInitilized = true;
  }

  @override
  Future<void> close() {
    return null;
  }
}

class OnlineCurrentUserDatabase extends CurrentUserDatabase {
  final GitterApi _gitterApi;

  OnlineCurrentUserDatabase(this._gitterApi);

  @override
  Future<void> create(User user) {
    throw UnimplementedError();
  }

  @override
  Stream<User> get currentUserChanges => throw UnimplementedError();

  @override
  Future<void> delete() {
    throw UnimplementedError();
  }

  @override
  Future<User> get() async {
    return User.fromMap(await _gitterApi.v1.userResource.me());
  }

  @override
  Future<void> update(User user) {
    throw UnimplementedError();
  }
}
