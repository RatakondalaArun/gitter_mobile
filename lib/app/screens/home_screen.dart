import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gitter/blocs/blocs.dart';

class HomePageScreen extends StatelessWidget {
  static const ROUTE_NAME = '/SignInScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gitter')),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (_, state) {
          print(state.user.username);
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Signed In as\n${state.user.username}',
                  textAlign: TextAlign.center,
                ),
                FlatButton(
                  child: Text('Sign Out'),
                  onPressed: () => onPressedSignOut(context),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void onPressedSignOut(BuildContext context) {
    BlocProvider.of<AuthBloc>(context).add(AuthEventSignOut());
  }
}
