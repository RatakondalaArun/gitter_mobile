part of repos.auth;

class AuthRepoImp extends AuthRepoAbs {
  @override
  Future<User> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<User> signIn() async {
    // show auth screen and get code
    final url = AuthUtils.getWebFlowUrl(Keys.CLIENT_ID, Keys.CALLBACK_URL);
    final result = await FlutterWebAuth.authenticate(
      url: url,
      callbackUrlScheme: Keys.CALL_BACK_URL_SCHEME,
    );

    // TODO(@RatakondalaArun): Throw error
    if (result == null) return null;

    // parse code and get token
    final code = _getCodeFrom(result);

    final response = await Dio(
      BaseOptions(contentType: 'application/json'),
    ).post<Response>(
      AuthUtils.tokenUrl,
      data: AuthUtils.parsetokenBody(
        Keys.CLIENT_ID,
        Keys.CLIENT_SECERET,
        Keys.CALL_BACK_URL_SCHEME,
        code,
      ),
    );

    if (response.statusCode != 200) {
      print('failed to get token from server');
      print(
          'statusCode: ${response.statusCode} statusMessage: ${response.statusMessage} , data: ${response.data}');
    }
    print(response.data);
    // get user
    return null;
  }

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }
}

String _getCodeFrom(String url) {
  // gitter://success?code=adada;
  return Uri.parse(url).queryParameters['code'];
}
