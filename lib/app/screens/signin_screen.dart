import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gitter/blocs/blocs.dart';
import 'package:google_fonts/google_fonts.dart';

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
    _signInBloc.listen(_handleSignInBlocState);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 200),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/signin_icon.png',
                    fit: BoxFit.cover,
                    height: 50,
                    width: 50,
                  ),
                  Text(
                    'GITTER',
                    style: GoogleFonts.robotoCondensed(fontSize: 50),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Text(
                '{Where developers come to talk.}',
                style: GoogleFonts.robotoMono(fontSize: 18),
              ),
              SizedBox(height: 200),
              Container(
                margin: const EdgeInsets.all(10),
                child: BlocBuilder<SignInBloc, SignInState>(
                  cubit: _signInBloc,
                  builder: (_, state) {
                    return FlatButton.icon(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      color: Colors.greenAccent,
                      disabledColor: Colors.greenAccent.shade100,
                      height: 50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      icon: Image.asset(
                        'assets/icons/gitter_32px.png',
                        height: 15,
                        width: 15,
                      ),
                      label: state.isSignningIn
                          ? CircularProgressIndicator(strokeWidth: 2)
                          : const Text(
                              'SIGN IN TO GITTER',
                              style: TextStyle(fontSize: 14),
                            ),
                      onPressed: state.isSignningIn ? null : _onPressedLogin,
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _onPressedLogin() {
    _signInBloc.add(SignInEventStart());
  }

  void _handleSignInBlocState(SignInState state) {
    if (state.isSignedIn) {
      BlocProvider.of<AuthBloc>(context).add(AuthEventCheckStatus());
    }
  }
}
