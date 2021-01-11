import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/screens/screens.dart';
import 'blocs/blocs.dart';
import 'repos/repos.dart';

final authRepo = AuthRepoImp();
final homeRepo = HomeRepoImp();
final roomRepo = RoomRepoImp();
final userRepo = UserRepoImp();

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  final arguments = settings.arguments as Map<String, dynamic>;
  switch (settings.name) {
    case ChatScreen.routeName:
      final room = arguments['room'];
      return PageRouteBuilder<Offset>(
        pageBuilder: (_, __, ___) {
          return BlocProvider(
            create: (context) =>
                RoomBloc(roomRepo)..add(RoomEventInitilize(room)),
            lazy: false,
            child: ChatScreen(room: room),
          );
        },
        transitionsBuilder: (context, animation, _, child) {
          return SlideTransition(
            position: animation.drive(Tween(
              begin: Offset(1.0, 0),
              end: Offset.zero,
            )),
            child: child,
          );
        },
      );
    case UserScreen.routeName:
      final user = arguments['user'] as User;
      return PageRouteBuilder<Offset>(
        opaque: false,
        barrierColor: Colors.black.withOpacity(0.7),
        barrierDismissible: true,
        barrierLabel: 'Dismiss User Profile',
        fullscreenDialog: true,
        pageBuilder: (_, __, ___) {
          return BlocProvider<UserBloc>(
            create: (_) => UserBloc(userRepo),
            child: UserScreen(user: user),
          );
        },
        transitionsBuilder: (context, animation, _, child) {
          return SlideTransition(
            position: animation.drive(Tween(
              begin: Offset(0, 1.0),
              end: Offset.zero,
            )),
            child: child,
          );
        },
      );
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
                  return BlocProvider(
                    create: (_) => HomeBloc(authRepo, homeRepo),
                    child: HomeScreen(),
                  );
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
