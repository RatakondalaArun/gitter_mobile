library repos.user;

import 'package:gitter/services/database/database.dart';
import 'package:gitterapi/models.dart';

part 'user_repo_imp.dart';

abstract class UserRepoAbs {
  Future<UserProfile> getUserProfile(String username);
}
