library services.database;

import 'package:gitter/services/database/database.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as pp;

import 'package:gitterapi/gitter_api.dart';
import 'package:gitterapi/models.dart';

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

abstract class CreditionalDatabase {
  Future<void> create(String name, String value);
  Future<String> get(String name);
  Future<void> update(String name, String value);
  Future<void> delete(String name);
}

abstract class UserResourceDatabase {}

/// Base class for all creditionals
// abstract class CreditionalItem {
//   /// This should be a unique name.
//   ///
//   /// Preffered class name as snakecase. Must not be null.
//   /// ```
//   /// String get name => 'creditional_item';
//   /// ```
//   String get name;

//   /// Returns `lastUpdated` in [DateTime] format.
//   DateTime get lastUpdatedAs => DateTime.tryParse(lastUpdated);

//   /// Last updated time in UTC and stored in String format.
//   final String lastUpdated;

//   /// Creates a instance.
//   CreditionalItem(this.lastUpdated);

//   /// Returns [Map<String,dynamic>]
//   Map<String, dynamic> toMap();
// }

// /// This CreditionalItem holds access_token
// class AccessTokenCItem extends CreditionalItem {
//   final String accessToken;

//   @override
//   String get name => 'access_token_creditional';

//   AccessTokenCItem({
//     this.accessToken,
//     String lastUpdated,
//   }) : super(lastUpdated);

//   factory AccessTokenCItem.create(String accessToken) {
//     return AccessTokenCItem(
//       accessToken: accessToken,
//       lastUpdated: DateTime.now().toUtc().toString(),
//     );
//   }

//   factory AccessTokenCItem.fromMap(Map map) {
//     return AccessTokenCItem(
//       accessToken: map['accessToken'],
//       lastUpdated: map['lastUpdated'],
//     );
//   }

//   @override
//   Map<String, dynamic> toMap() {
//     return {
//       'accessToken': accessToken,
//       'lastUpdated': lastUpdated,
//     };
//   }

//   AccessTokenCItem copyWith({
//     String accessToken,
//     String lastUpdated,
//   }) {
//     return AccessTokenCItem(
//       accessToken: accessToken ?? this.accessToken,
//       lastUpdated: lastUpdated ?? this.lastUpdated,
//     );
//   }

//   @override
//   String toString() {
//     return 'Creditional(lastUpdated: $lastUpdated, accessToken: $accessToken)';
//   }
// }
