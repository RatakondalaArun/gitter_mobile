part of services.database;

class OnlineDatabaseService extends DatabaseServiceAbs {
  static OnlineDatabaseService _instance = OnlineDatabaseService._();
  bool _isInitilized = false;
  // services
  OfflineDatabaseService _offlineDB;
  CurrentUserDatabase _userDB;
  OnlineMessagesDatabase _messagesDB;
  OnlineUsersDatabase _usersDB;
  OnlineRoomsDatabase _roomsDB;
  GitterApi _gitterApi;

  OnlineDatabaseService._() {
    _offlineDB = OfflineDatabaseService._instance;
  }

  @override
  Future<void> init() async {
    final accessToken = await _offlineDB.creditional.get('access_token');
    _gitterApi = GitterApi(ApiKeys(accessToken));
    _userDB = OnlineCurrentUserDatabase(_gitterApi);
    _messagesDB = OnlineMessagesDatabase(_gitterApi);
    _usersDB = OnlineUsersDatabase(_gitterApi);
    _roomsDB = OnlineRoomsDatabase(_gitterApi);
    _isInitilized = true;
  }

  @override
  Future<void> close() {
    return Future<void>.value();
  }

  static OnlineDatabaseService get instance => _instance;

  @override
  bool get isInitilized => _isInitilized;

  @override
  CreditionalDatabase get creditional => throw UnimplementedError();

  @override
  CurrentUserDatabase get currentUser => _userDB;

  @override
  MessagesDatabase get messagesDB => _messagesDB;

  @override
  RoomsDatabase get roomsDB => _roomsDB;

  @override
  UsersDatabase get usersDB => _usersDB;
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
    return User.fromMap((await _gitterApi.v1.userResource.me()).data);
  }

  @override
  Future<void> update(User user) {
    throw UnimplementedError();
  }

  @override
  Future<List<Room>> getRooms(String userId) async {
    final mapRooms = await _gitterApi.v1.userResource.getRooms(userId);
    return mapRooms.data.map((room) => Room.fromMap(room)).toList();
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
    return messages.data.map((m) => Message.fromMap(m)).toList();
  }

  @override
  Future<Stream<StreamEvent>> getMessagesStream(String roomId) {
    return _gitterApi.v1.streamApi.chatMessages(roomId);
  }

  @override
  Future<Message> createMessage(
    String roomId,
    String message, {
    bool status = false,
  }) async {
    final result = await _gitterApi.v1.messageResource.sendMessage(
      roomId,
      message,
      status: status,
    );
    return Message.fromMap(result.data);
  }

  Future<List> readBy(String roomId, String messageId) async {
    final readBy = await _gitterApi.v1.messageResource.messageReadBy(
      roomId,
      messageId,
    );
    return readBy.data;
  }

  Future<void> markMessageAsRead(
    String userId,
    String roomId,
    List<String> messageIds,
  ) {
    return _gitterApi.v1.messageResource.markMessagesAsRead(
      userId,
      roomId,
      chatIds: messageIds,
    );
  }

  Future<void> markAllMessagesAsRead(String userId, String roomId) {
    return _gitterApi.v1.messageResource.markAllMessagesAsRead(userId, roomId);
  }
}

class OnlineUsersDatabase extends UsersDatabase {
  final GitterApi _gitterApi;

  OnlineUsersDatabase(this._gitterApi);

  @override
  Future<List<User>> searchUsers(String query, {int limit}) async {
    final result = await _gitterApi.v1.userResource.search(
      query,
      limit: limit,
    );
    final results = result.data['results'] as List;
    if (results == null || results.isEmpty) return [];

    return results.map((u) => User.fromMap(u)).toList();
  }

  @override
  Future<UserProfile> getProfile(String username) async {
    final result =
        await _gitterApi.v1.userResource.getProfileByUsername(username);
    return UserProfile.fromMap(result.data);
  }
}

class OnlineRoomsDatabase extends RoomsDatabase {
  final GitterApi _gitterApi;

  OnlineRoomsDatabase(this._gitterApi);

  @override
  Future<List<Room>> searchRooms(String query, {int limit}) async {
    final result = await _gitterApi.v1.roomResource.search(
      query,
      limit: limit,
    );

    final results = result.data['results'] as List;
    if (results == null || results.isEmpty) return [];

    return results.map((e) => Room.fromMap(e)).toList();
  }
}
