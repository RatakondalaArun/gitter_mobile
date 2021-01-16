library services.database;

import 'package:gitterapi/gitter_api.dart';
import 'package:gitterapi/models.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as pp;

part '../error/database_service_exception.dart';
part '../offline_database.dart';
part '../online_database.dart';

/// Base class for DataBaseService
abstract class DatabaseServiceAbs {
  /// To Make sure that everything is initilized
  bool get isInitilized;

  /// Stores Creditionals.
  CreditionalDatabase get creditional;

  /// Operations on current user.
  CurrentUserDatabase get currentUser;

  /// Operations on rooms messages
  MessagesDatabase get messagesDB;

  /// Users database.
  UsersDatabase get usersDB;

  /// Rooms database.
  RoomsDatabase get roomsDB;

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

  /// Fetches [List<Room>] form `server` and `local`.
  Future<List<Room>> getRooms(String userId);

  /// Stores [List<Room>] from `local`.
  Future<void> putRooms(List<Room> rooms) => throw UnimplementedError();
}

abstract class CreditionalDatabase {
  Future<void> create(String name, String value);
  Future<String> get(String name);
  Future<void> update(String name, String value);
  Future<void> delete(String name);
}

abstract class UsersDatabase {
  Future<List<User>> searchUsers(String query, {int limit}) {
    throw UnimplementedError();
  }

  Future<UserProfile> getProfile(String username) {
    throw UnimplementedError();
  }
}

abstract class MessagesDatabase {
  Future<List<Message>> getMessages(
    String roomId, {
    String beforeId,
    String afterId,
    int skip,
    int limit,
    String query,
  }) {
    throw UnimplementedError();
  }

  Future<Stream<StreamEvent>> getMessagesStream(String roomId) {
    throw UnimplementedError();
  }

  Future<Message> createMessage(
    String roomId,
    String message, {
    bool status = false,
  }) {
    throw UnimplementedError();
  }

  Future<List> readBy(String roomId, String messageId) {
    throw UnimplementedError();
  }

  Future<void> markMessageAsRead(
    String userId,
    String roomId,
    List<String> messageIds,
  ) {
    throw UnimplementedError();
  }

  Future<void> markAllMessagesAsRead(String userId, String roomId) {
    throw UnimplementedError();
  }
}

abstract class RoomsDatabase {
  Future<List<Room>> searchRooms(String query, {int limit}) {
    throw UnimplementedError();
  }
}
