part of repos.auth;

class AuthRepoImp extends AuthRepoAbs {
  DatabaseService _dBService;

  @override
  bool get isInitilized => _dBService.isInitilized;

  @override
  Stream<User> get currentUserStream =>
      _dBService.currentUser.currentUserChanges;

  AuthRepoImp() : _dBService = DatabaseService();

  @override
  Future<void> init() => _dBService.init();

  @override
  Future<User> getCurrentUser() {
    return _dBService.currentUser.get();
  }

  @override
  Future<User> signIn() async {
    // GET CODE
    final url = AuthUtils.getWebFlowUrl(Keys.CLIENT_ID, Keys.CALLBACK_URL);

    String result;
    try {
      result = await FlutterWebAuth.authenticate(
        url: url,
        callbackUrlScheme: Keys.CALL_BACK_URL_SCHEME,
      );
    } on PlatformException catch (e, st) {
      if (e.code == 'CANCELED') {
        throw AppException<PlatformException>(
          e.code,
          userError: 'Signed in cancled By you.',
          details: e.details,
          stackTrace: st,
        );
      }
      throw AppException<PlatformException>(
        e.code,
        userError: 'Login Failed',
        details: e.details,
        stackTrace: st,
      );
    } catch (_) {
      rethrow;
    }

    // parse code and get token
    final code = _getCodeFrom(result);
    if (code == null)
      throw AppException<Exception>(
        'ERROR_ACCESS_DENIED',
        userError: 'Access denied',
      );

    // this payload contains required field to create a token
    // https://developer.gitter.im/docs/authentication
    final payLoad = AuthUtils.parsetokenBody(
      clientId: Keys.CLIENT_ID,
      clientSecret: Keys.CLIENT_SECERET,
      redirectUrl: Keys.CALLBACK_URL,
      code: code,
    );

    // GET TOKEN
    Response<Map<String, dynamic>> response;
    try {
      response = await Dio(
        BaseOptions(
          contentType: 'application/json',
          headers: {HttpHeaders.acceptHeader: 'applicaiton/json'},
        ),
      ).post<Map<String, dynamic>>(
        AuthUtils.tokenUrl,
        data: payLoad,
      );
    } on DioError catch (e, st) {
      throw AppException<DioError>(
        e.message,
        stackTrace: st,
        orginalError: e,
      );
    } catch (_) {
      rethrow;
    }

    final accessToken = response.data['access_token'];

    // GET USER FROM API
    try {
      final user = await GitterApi(ApiKeys(accessToken)).v1.userResource.me();
      // Save the accessToken and user to disk
      await _dBService.currentUser.create(User.fromMap(user));
      return User.fromMap(user);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signOut() {
    return _dBService.currentUser.delete();
  }
}

String _getCodeFrom(String url) {
  // gitter://success?code=adada;
  return Uri.parse(url).queryParameters['code'];
}
