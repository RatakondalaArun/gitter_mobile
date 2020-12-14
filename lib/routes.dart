import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gitter/blocs/blocs.dart';
import 'package:gitter/repos/repos.dart';

import 'app/screens/screens.dart';

final _authRepo = AuthRepoImp();

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SignInScreen.ROUTE_NAME:
      return MaterialPageRoute(builder: (_) {
        return BlocProvider<SignInBloc>(
          create: (_) => SignInBloc(_authRepo),
          child: SignInScreen(),
        );
      });
    default:
      return MaterialPageRoute(builder: (_) {
        return BlocProvider<SignInBloc>(
          create: (_) => SignInBloc(_authRepo),
          child: SignInScreen(),
        );
      });
  }
}
