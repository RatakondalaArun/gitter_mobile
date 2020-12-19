import 'package:flutter/material.dart';
import 'package:gitterapi/models.dart';

class SearchScreen extends StatelessWidget {
  final void Function({Room returnValue}) closeCallBack;

  const SearchScreen({
    Key key,
    this.closeCallBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.8,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.black87,
          ),
          // returns null if back button is pressed
          onPressed: () => closeCallBack?.call(returnValue: null),
        ),
        title: TextField(
          maxLines: 1,
          keyboardType: TextInputType.text,
          autofocus: true,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Search for users/rooms',
            hintStyle: TextStyle(
              fontSize: 16,
              color: Colors.black45,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
