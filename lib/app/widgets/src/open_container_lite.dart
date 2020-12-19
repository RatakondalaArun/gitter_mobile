import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class OpenContainerLite<T> extends StatelessWidget {
  final Widget toChild;
  final Widget fromChild;

  const OpenContainerLite({
    Key key,
    @required this.toChild,
    @required this.fromChild,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OpenContainer<T>(
      closedBuilder: (context, action) {
        return fromChild;
      },
      openBuilder: (context, action) {
        return toChild;
      },
    );
  }
}
