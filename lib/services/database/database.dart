import 'package:gitterapi/models/user.dart';

import 'abs/database_abs.dart';

export 'abs/database_abs.dart'
    show DatabaseServiceAbs, CurrentUserDatabase, DatabaseServiceException;

class DatabaseService implements DatabaseServiceAbs {
  bool _isInitilized = false;
  DatabaseServiceAbs _offlineDB;
  DatabaseServiceAbs _onlineDb;
  CreditionalDatabase _creditionalDB;
  CurrentUserDatabase _currentUserDB;

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
}
