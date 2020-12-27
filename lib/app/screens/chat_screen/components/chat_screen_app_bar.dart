import 'package:flutter/material.dart';
import 'package:gitterapi/models.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widgets/widgets.dart';

class ChatScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Room room;

  const ChatScreenAppBar({
    Key key,
    @required this.room,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 4,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_outlined,
          color: Colors.black54,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          SizedBox(
            height: 25,
            width: 25,
            child: CircularImage(
              imageUrl: room.avatarUrl ?? '',
              displayName: room.name,
            ),
          ),
          SizedBox(width: 10),
          Text(
            room.name ?? '',
            style: GoogleFonts.roboto(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
