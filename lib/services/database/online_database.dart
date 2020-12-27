part of services.database;

class OnlineDatabaseService extends DatabaseServiceAbs {
  static OnlineDatabaseService _instance = OnlineDatabaseService._();
  OfflineDatabaseService _offlineDB;
  CurrentUserDatabase _userDB;
  OnlineMessagesDatabase _messagesDB;
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
  MessagesDatabase get messagesDB => _messagesDB;

  @override
  Future<void> init() async {
    final accessToken = await _offlineDB.creditional.get('access_token');
    _gitterApi = GitterApi(ApiKeys(accessToken));
    _userDB = OnlineCurrentUserDatabase(_gitterApi);
    _messagesDB = OnlineMessagesDatabase(_gitterApi);
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

  @override
  Future<List<Room>> getRooms(String userId) async {
    final mapRooms = await _gitterApi.v1.userResource.getRooms(userId);
    return mapRooms.map((room) => Room.fromMap(room)).toList();
  }

  @override
  Future<void> putRooms(List<Room> rooms) {
    throw UnimplementedError();
  }
}

class OnlineMessagesDatabase extends MessagesDatabase {
  GitterApi _gitterApi;
  OnlineMessagesDatabase(this._gitterApi);
  @override
  Future<List<Message>> getMessages(
    String roomId, {
    String beforeId,
    String afterId,
    int skip,
    int limit,
    String query,
  }) async {
    final messages = await _gitterApi.v1.messageResource.getMessages(
      roomId,
      beforeId: beforeId,
      afterId: afterId,
      skip: skip,
      limit: limit,
      query: query,
    );
    return messages.map((m) => Message.fromMap(m)).toList();
  }

  @override
  Future<Stream<StreamEvent>> getMessagesStream(String roomId) {
    return _gitterApi.v1.streamApi.chatMessages(roomId);
  }
}
