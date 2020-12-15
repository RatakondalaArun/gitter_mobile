library services.database;

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as pp;
import 'package:gitterapi/models.dart';

part '../error/database_service_exception.dart';
part '../offline_database.dart';

/// Base class for DataBaseService
abstract class DatabaseServiceAbs {
  /// To Make sure that everything is initilized
  bool get isInitilized;

  /// Operations on current user.
  CurrentUserDatabase get currentUser;

  /// Call this before using any method.
  Future<void> init();

  /// Closes all the resources.
  Future<void> close();
}

/// Base class handles services for current user
abstract class CurrentUserDatabase {
  /// Returns changes from current user.
  Stream<User> get currentUserChanges;

  /// Creates current user.
  Future<void> create(User user);

  /// Returns current user.
  Future<User> get();

  /// Updates current user.
  Future<void> update(User user);

  /// Deletes current user.
  Future<void> delete();
}
