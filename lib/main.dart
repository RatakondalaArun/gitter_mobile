import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/blocs.dart';

import 'routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp(router: AppRouter()));
}

class MyApp extends StatelessWidget {
  final AppRouter router;

  const MyApp({
    Key key,
    this.router,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (_) => AuthBloc(router.authRepo),
      child: MaterialApp(
        title: 'Gitter',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        onGenerateRoute: router.onGenerateRoute,
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gitter'),
      ),
      body: Center(
        child: Text('Home'),
      ),
    );
  }
}
