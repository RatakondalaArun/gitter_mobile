import 'package:flutter/material.dart';

/// Creates CircularProgressIndicator with Gitter Icon.
class GitterLoadingIndicator extends StatefulWidget {
  @override
  _GitterLoadingIndicatorState createState() => _GitterLoadingIndicatorState();
}

class _GitterLoadingIndicatorState extends State<GitterLoadingIndicator>
    with SingleTickerProviderStateMixin {
  final _colorTween = ColorTween(begin: Colors.red, end: Colors.blue);
  AnimationController _progressCtrl;

  @override
  void initState() {
    _progressCtrl = AnimationController(
      lowerBound: 0.1,
      upperBound: 1.0,
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    super.initState();
  }

  @override
  void dispose() {
    _progressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      alignment: Alignment.center,
      child: Stack(
        children: [
          Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: _progressCtrl.drive(_colorTween),
            ),
          ),
          AnimatedBuilder(
            animation: _progressCtrl,
            builder: (context, child) {
              return _GitterIcon(
                rectColor: _progressCtrl.drive(_colorTween).value,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _GitterIcon extends StatelessWidget {
  final Color rectColor;

  const _GitterIcon({
    Key key,
    this.rectColor = Colors.pink,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 25,
        width: 25,
        child: FittedBox(
          fit: BoxFit.contain,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                key: UniqueKey(),
                margin: const EdgeInsets.only(bottom: 40, right: 5),
                width: 10,
                height: 40,
                color: rectColor,
              ),
              Container(
                key: UniqueKey(),
                margin: const EdgeInsets.only(right: 5),
                width: 10,
                height: 50,
                color: rectColor,
              ),
              Container(
                key: UniqueKey(),
                margin: const EdgeInsets.only(right: 5),
                width: 10,
                height: 50,
                color: rectColor,
              ),
              Container(
                key: UniqueKey(),
                margin: const EdgeInsets.only(right: 5, bottom: 25),
                width: 10,
                height: 25,
                color: rectColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
