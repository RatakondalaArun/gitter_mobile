import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  final bool showLoading;

  const SplashScreen({
    Key key,
    this.showLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.pink.shade200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    key: UniqueKey(),
                    margin: const EdgeInsets.only(bottom: 80, right: 10),
                    width: 20,
                    height: 80,
                    color: Colors.white,
                  ),
                  Container(
                    key: UniqueKey(),
                    margin: const EdgeInsets.only(right: 10),
                    width: 20,
                    height: 100,
                    color: Colors.white,
                  ),
                  Container(
                    key: UniqueKey(),
                    margin: const EdgeInsets.only(right: 10),
                    width: 20,
                    height: 100,
                    color: Colors.white,
                  ),
                  Container(
                    key: UniqueKey(),
                    margin: const EdgeInsets.only(right: 10, bottom: 50),
                    width: 20,
                    height: 50,
                    color: Colors.white,
                  ),
                ],
              ),
              Text(
                'GITTER',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w300,
                ),
              ),
              if (showLoading)
                Container(
                  width: 100,
                  height: 10,
                  child: Center(child: LinearProgressIndicator()),
                )
            ],
          ),
        ),
      ),
    );
  }
}
