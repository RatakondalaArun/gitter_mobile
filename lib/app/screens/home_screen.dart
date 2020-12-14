import 'package:flutter/material.dart';

class HomePageScreen extends StatelessWidget {
  static const ROUTE_NAME = '/SignInScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gitter')),
      body: Center(
        child: Text('Home Page'),
      ),
    );
  }
}
