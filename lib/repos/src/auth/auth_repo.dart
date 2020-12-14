library repos.auth;

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:gitter/errors/app_exception.dart';
import 'package:gitterapi/gitter_api.dart';
import 'package:gitterapi/models.dart';

import '../../../keys/keys.dart';

part 'auth_repo_imp.dart';

abstract class AuthRepoAbs {
  /// Returns currently signed in user
  Future<User> getCurrentUser();

  /// Signs in user from the app
  Future<User> signIn();

  /// Signs out user form the app
  Future<void> signOut();
}
