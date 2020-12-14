import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gitter/blocs/blocs.dart';

class SignInScreen extends StatefulWidget {
  static const ROUTE_NAME = '/SignInScreen';

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  SignInBloc _signInBloc;

  @override
  void initState() {
    _signInBloc = BlocProvider.of<SignInBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(child: Text('Login')),
            Container(
              child: FlatButton(
                child: Text('Login'),
                onPressed: _onPressedLogin,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onPressedLogin() {
    _signInBloc.add(SignInEventStart());
  }
}
