import 'abs/database_abs.dart';

export 'abs/database_abs.dart'
    show DatabaseServiceAbs, CurrentUserDatabase, DatabaseServiceException;

class DatabaseService implements DatabaseServiceAbs {
  bool _isInitilized = false;
  DatabaseServiceAbs _offlineDB;

  @override
  bool get isInitilized => _isInitilized;

  @override
  CurrentUserDatabase get currentUser {
    if (!isInitilized) {
      throw DatabaseServiceException(
        'NOT_INITILIZED, Call init() method before using this.',
      );
    }
    return _offlineDB.currentUser;
  }

  DatabaseService() {
    init();
  }

  @override
  Future<void> init() async {
    _offlineDB = OfflineDatabaseService();
    await _offlineDB.init();
    _isInitilized = true && _offlineDB.isInitilized;
  }

  @override
  Future<void> close() {
    return _offlineDB.close();
  }
}
