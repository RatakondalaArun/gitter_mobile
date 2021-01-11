import 'package:flutter/material.dart';

class Shrim extends StatefulWidget {
  final Duration duration;
  final BorderRadius borderRadius;
  final Widget child;
  final double height;
  final double width;

  const Shrim({
    Key key,
    this.child,
    this.height = 50,
    this.width,
    this.borderRadius,
    this.duration = const Duration(seconds: 1),
  }) : super(key: key);

  @override
  _ShrimState createState() => _ShrimState();
}

class _ShrimState extends State<Shrim> with SingleTickerProviderStateMixin {
  AnimationController _shrimmController;

  @override
  void initState() {
    _shrimmController = AnimationController(
      vsync: this,
      lowerBound: 0.0,
      upperBound: 1.0,
      duration: widget.duration,
    )..repeat();
    super.initState();
  }

  @override
  void dispose() {
    _shrimmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      return AnimatedBuilder(
        animation: _shrimmController,
        builder: (context, child) {
          return Container(
            width: widget.width ?? constrains.maxWidth,
            height: widget.height ?? 40,
            margin: const EdgeInsets.symmetric(
              horizontal: 2,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
              gradient: LinearGradient(
                colors: [
                  Colors.grey[300],
                  Colors.grey[100],
                  Colors.grey[300],
                ],
                stops: [
                  0.1 + _shrimmController.value,
                  0.19 + _shrimmController.value,
                  0.3 + _shrimmController.value,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          );
        },
      );
    });
  }
}
