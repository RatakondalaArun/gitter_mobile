import 'package:gitterapi/gitter_api.dart';
import 'package:gitterapi/models.dart';

import 'abs/database_abs.dart';

export 'abs/database_abs.dart'
    show DatabaseServiceAbs, CurrentUserDatabase, DatabaseServiceException;

class DatabaseService implements DatabaseServiceAbs {
  bool _isInitilized = false;
  DatabaseServiceAbs _offlineDB;
  DatabaseServiceAbs _onlineDb;
  CreditionalDatabase _creditionalDB;
  CurrentUserDatabase _currentUserDB;
  MessagesDatabase _messagesDB;

  static DatabaseService _instance = DatabaseService._();

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

  DatabaseService._() {
    init();
  }

  @override
  Future<void> init() async {
    // Must be initilized before initilizing others
    _offlineDB = OfflineDatabaseService.instance;
    _onlineDb = OnlineDatabaseService.instance;
    await _offlineDB.init();
    _creditionalDB = _offlineDB.creditional;
    await _onlineDb.init();

    _currentUserDB = _CurrentUserService(
      _onlineDb.currentUser,
      _offlineDB.currentUser,
    );
    _messagesDB = _MessageService(_onlineDb.messagesDB, _offlineDB.messagesDB);
    _isInitilized = true && _offlineDB.isInitilized && _onlineDb.isInitilized;
  }

  @override
  Future<void> close() {
    return _offlineDB.close();
  }
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
}
