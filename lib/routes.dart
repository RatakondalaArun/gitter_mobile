import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/blocs.dart';
import 'repos/repos.dart';

import 'app/screens/screens.dart';

final authRepo = AuthRepoImp();

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    default:
      return MaterialPageRoute(builder: (_) {
        return BlocProvider<SignInBloc>(
          create: (_) => SignInBloc(authRepo),
          child: BlocBuilder<AuthBloc, AuthState>(
            buildWhen: (o, n) {
              // otherwise this will get rebuild screen for
              // every update from authstate which affects performs
              return o.blocState != n.blocState;
            },
            builder: (_, state) {
              switch (state.blocState) {
                case AuthBlocStates.loading:
                case AuthBlocStates.initial:
                  return SplashScreen(
                    showLoading: state.blocState == AuthBlocStates.loading,
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
