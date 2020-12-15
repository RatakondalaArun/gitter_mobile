import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gitter/blocs/blocs.dart';
import 'package:gitter/repos/repos.dart';

import 'app/screens/screens.dart';

final authRepo = AuthRepoImp();

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SignInScreen.ROUTE_NAME:
      return MaterialPageRoute(builder: (_) {
        return BlocProvider<SignInBloc>(
          create: (_) => SignInBloc(authRepo),
          child: SignInScreen(),
        );
      });
    default:
      return MaterialPageRoute(builder: (_) {
        return BlocProvider<SignInBloc>(
          create: (_) => SignInBloc(authRepo),
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (_, state) {
              switch (state.blocState) {
                case AuthBlocStates.initial:
                  // show splash screen
                  return Scaffold(
                    body: Center(
                      child: Text('Splash Screen'),
                    ),
                  );
                case AuthBlocStates.signedIn:
                  return HomePageScreen();
                case AuthBlocStates.signedOut:
                  return SignInScreen();
                default:
                  return SignInScreen();
              }
            },
          ),
        );
      });
  }
}
