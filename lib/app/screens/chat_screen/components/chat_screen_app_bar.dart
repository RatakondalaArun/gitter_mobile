import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String roomName;

  const ChatScreenAppBar({
    Key key,
    @required this.roomName,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_outlined,
          color: Colors.black54,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        '$roomName',
        style: GoogleFonts.roboto(
          color: Colors.black87,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
