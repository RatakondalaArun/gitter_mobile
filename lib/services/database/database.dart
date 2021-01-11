import 'package:gitterapi/gitter_api.dart';
import 'package:gitterapi/models.dart';

import 'abs/database_abs.dart';

export 'abs/database_abs.dart'
    show DatabaseServiceAbs, CurrentUserDatabase, DatabaseServiceException;

class DatabaseService implements DatabaseServiceAbs {
  static DatabaseService _instance = DatabaseService._();
  bool _isInitilized = false;
  // resources
  DatabaseServiceAbs _offlineDB;
  DatabaseServiceAbs _onlineDB;
  CreditionalDatabase _creditionalDB;
  CurrentUserDatabase _currentUserDB;
  MessagesDatabase _messagesDB;
  UsersDatabase _usersDB;
  RoomsDatabase _roomsDB;

  DatabaseService._() {
    init();
  }

  @override
  Future<void> init() async {
    // Must be initilized before initilizing others
    _offlineDB = OfflineDatabaseService.instance;
    _onlineDB = OnlineDatabaseService.instance;
    await _offlineDB.init();
    _creditionalDB = _offlineDB.creditional;
    await _onlineDB.init();

    _currentUserDB = _CurrentUserService(
      _onlineDB.currentUser,
      _offlineDB.currentUser,
    );
    _messagesDB = _MessageService(_onlineDB.messagesDB, _offlineDB.messagesDB);
    _usersDB = _UsersService(_onlineDB.usersDB, _offlineDB.usersDB);
    _roomsDB = _RoomsService(_onlineDB.roomsDB, _offlineDB.roomsDB);
    _isInitilized = true && _offlineDB.isInitilized && _onlineDB.isInitilized;
  }

  @override
  Future<void> close() {
    return _offlineDB.close();
  }

  /// Returns a singleton instance of [DatabaseService].
  static DatabaseService get instance => _instance;

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

  @override
  CreditionalDatabase get creditional => _creditionalDB;

  @override
  MessagesDatabase get messagesDB => _messagesDB;

  @override
  RoomsDatabase get roomsDB => _roomsDB;

  @override
  UsersDatabase get usersDB => _usersDB;
}

class _CurrentUserService extends CurrentUserDatabase {
  final CurrentUserDatabase _onlineDb;
  final CurrentUserDatabase _offlineDb;

  _CurrentUserService(this._onlineDb, this._offlineDb);

  @override
  Stream<User> get currentUserChanges => _offlineDb.currentUserChanges;

  @override
  Future<void> create(User user) {
    return _offlineDb.create(user);
  }

  @override
  Future<void> delete() {
    return _offlineDb.delete();
  }

  @override
  Future<User> get() async {
    User user;
    try {
      // if failed to get user from online db fetch it from offline
      user = await _onlineDb.get();
      return user;
    } catch (e) {
      print(e);
    }
    return _offlineDb.get();
  }

  @override
  Future<void> update(User user) {
    return _offlineDb.update(user);
  }

  @override
  Future<List<Room>> getRooms(String userId) async {
    try {
      final rooms = await _onlineDb.getRooms(userId);
      return rooms;
    } catch (e) {
      print(e);
    }

    return _offlineDb.getRooms(userId);
  }

  @override
  Future<void> putRooms(List<Room> rooms) {
    return _offlineDb.putRooms(rooms);
  }
}

class _MessageService implements MessagesDatabase {
  final MessagesDatabase _onlineDB;
  final MessagesDatabase _offlineDB;

  _MessageService(this._onlineDB, this._offlineDB);

  @override
  Future<List<Message>> getMessages(
    String roomId, {
    String beforeId,
    String afterId,
    int skip,
    int limit,
    String query,
  }) {
    return _onlineDB.getMessages(
      roomId,
      beforeId: beforeId,
      afterId: afterId,
      skip: skip,
      limit: limit,
      query: query,
    );
  }

  @override
  Future<Stream<StreamEvent>> getMessagesStream(String roomId) {
    return _onlineDB.getMessagesStream(roomId);
  }

  @override
  Future<void> createMessage(
    String roomId,
    String message, {
    bool status = false,
  }) {
    return _onlineDB.createMessage(roomId, message, status: status);
  }

  @override
  Future<List> readBy(String roomId, String messageId) {
    return _onlineDB.readBy(roomId, messageId);
  }
}

class _RoomsService implements RoomsDatabase {
  final RoomsDatabase _onlineDB;
  final RoomsDatabase _offlineDB;

  _RoomsService(
    this._onlineDB,
    this._offlineDB,
  );

  @override
  Future<List<Room>> searchRooms(String query, {int limit}) {
    return _onlineDB.searchRooms(query, limit: limit);
  }
}

class _UsersService implements UsersDatabase {
  final UsersDatabase _onlineDB;
  final UsersDatabase _offlineDB;

  _UsersService(this._onlineDB, this._offlineDB);

  @override
  Future<List<User>> searchUsers(String query, {int limit}) {
    return _onlineDB.searchUsers(query, limit: limit);
  }

  @override
  Future<UserProfile> getProfile(String username) {
    return _onlineDB.getProfile(username);
  }
}
