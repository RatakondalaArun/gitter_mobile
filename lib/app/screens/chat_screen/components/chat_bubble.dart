import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:gitterapi/models.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../widgets/widgets.dart';

class ChatBubble extends StatelessWidget {
  final Message message;
  final bool isOneToOne;
  final bool isDifferentUser;
  final void Function(Mention mention) onSelectMention;
  final void Function(String code) onTapCode;
  final void Function(Message message) onLongPress;
  final void Function(String url) onTapLink;
  final void Function(User user) onTapProfile;
  final void Function(String username) onTapUsername;
  final void Function(Message message) rendered;

  BorderRadius get kBubbleRadious {
    return BorderRadius.only(
      topLeft: Radius.circular(5),
      topRight: Radius.circular(20),
      bottomLeft: isDifferentUser ? Radius.circular(10) : Radius.circular(20),
      bottomRight: Radius.circular(20),
    );
  }

  const ChatBubble({
    Key key,
    @required this.message,
    this.isOneToOne = true,
    this.isDifferentUser = true,
    this.onLongPress,
    this.onSelectMention,
    this.onTapProfile,
    this.onTapCode,
    this.onTapLink,
    this.onTapUsername,
    this.rendered,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    rendered?.call(message);
    return Container(
      margin: EdgeInsets.only(
        top: isDifferentUser ? 8 : 0.8,
        left: 2,
        right: 2,
        bottom: 1,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (isDifferentUser)
                  ? Padding(
                      padding: const EdgeInsets.all(3),
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: InkWell(
                          onTap: () => onTapProfile?.call(message.fromUser),
                          borderRadius: BorderRadius.circular(20),
                          child: CircularImage(
                            imageUrl: message.fromUser.avatarUrlMedium,
                            displayName: message.fromUser.displayName,
                          ),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(3),
                      child: SizedBox(
                        width: 30,
                        height: 30,
                      ),
                    ),
              InkWell(
                onLongPress: () => onLongPress?.call(message),
                borderRadius: kBubbleRadious,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: kBubbleRadious,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isDifferentUser)
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 8,
                            top: 10,
                            bottom: 5,
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(4),
                            radius: 10,
                            onTap: () {
                              return onTapUsername
                                  ?.call(message.fromUser.username);
                            },
                            child: Row(
                              children: [
                                Text(
                                  ' ${message.fromUser.displayName}',
                                  style: TextStyle(
                                    color:
                                        _getColor(message.fromUser.displayName),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  ' @${message.fromUser.username} ',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 50,
                        child: message.isDeleted
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'This message was deleted.',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              )
                            : Html(
                                data: message.html ?? '',
                                shrinkWrap: true,
                                onLinkTap: onTapLink?.call,
                                customRender: _widgetMap(),
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            if (!isOneToOne)
                              Icon(
                                Icons.remove_red_eye,
                                size: 14,
                                color: Colors.grey,
                              ),
                            SizedBox(width: 2),
                            (!isOneToOne)
                                ? Text(
                                    _formattedReadByCount,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  )
                                : Icon(
                                    Icons.done_all,
                                    size: 14,
                                    color: message.readBy == 0
                                        ? Colors.grey
                                        : Colors.blue.shade300,
                                  ),
                            SizedBox(width: 10),
                            Text(
                              _formattedTime,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(width: 10),
                            if (message.isEdited)
                              Row(
                                children: [
                                  Icon(
                                    Icons.edit_outlined,
                                    size: 14,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    'edited',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (_shouldShowThread)
            Row(
              children: [
                SizedBox(width: 40),
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {},
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 2,
                      vertical: 2,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${message.threadMessageCount}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        const Icon(
                          Icons.forum_outlined,
                          size: 16,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  bool get _shouldShowThread => message.isParent;

  String get _formattedTime {
    final time = DateFormat('h:mm a MMM').format(message.sentAs.toLocal());
    final ago = timeago.format(message.sentAs);
    return '$time ( $ago )';
  }

  String get _formattedReadByCount {
    return NumberFormat.compact().format(message.readBy);
  }

  Map<String, CustomRender> _widgetMap() {
    return {
      'em': (context, widget, map, element) {
        return SelectableText(
          element.text ?? '',
          style: TextStyle(fontStyle: FontStyle.italic),
        );
      },
      "span": (context, widget, attributes, element) {
        if (!(attributes.containsKey('class') &&
            attributes['class'] == 'mention')) {
          return widget;
        }

        return SelectableText(
          element.text,
          style: TextStyle(color: Colors.blue[400]),
          onTap: () {
            final mention = message.mentions.lastWhere(
                (e) => e.screenName == attributes['data-screen-name']);
            onSelectMention?.call(mention);
          },
        );
      },
      "blockquote": (context, widget, map, element) {
        return Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: Colors.green.withOpacity(0.3),
                width: 5,
              ),
            ),
          ),
          padding: const EdgeInsets.only(left: 2),
          child: Text(
            '"${element.text.trim()}"',
            style: TextStyle(fontStyle: FontStyle.italic),
            textAlign: TextAlign.left,
          ),
        );
      },
      "code": (context, widget, map, element) {
        return Container(
          padding: EdgeInsets.symmetric(
            vertical: element.text.trim().length < 46 ? 0 : 8,
            horizontal: 8,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.shade300,
          ),
          child: Scrollbar(
            radius: Radius.circular(10),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: GestureDetector(
                onTap: () => onTapCode?.call(element.text),
                child: Text(
                  '${element.text.trim()}',
                  style: GoogleFonts.ubuntuMono(),
                ),
              ),
            ),
          ),
        );
      }
    };
  }
}

final _colors = <String, Color>{
  'A': Colors.pink,
  'B': Colors.green,
  'C': Colors.blue,
  'D': Colors.teal,
  'E': Colors.brown,
  'F': Colors.deepOrange,
  'G': Colors.orange,
  'H': Colors.brown,
  'I': Colors.blueGrey,
  'J': Colors.deepPurple,
  'K': Colors.purple,
  'L': Colors.teal,
  'M': Colors.lime,
  'N': Colors.indigo,
  'O': Colors.cyan,
  'P': Colors.pink,
  'Q': Colors.green,
  'R': Colors.blue,
  'S': Colors.teal,
  'T': Colors.brown,
  'U': Colors.deepOrange,
  'V': Colors.orange,
  'W': Colors.brown,
  'X': Colors.blueGrey,
  'Y': Colors.deepPurple,
  'Z': Colors.purple,
};

Color _getColor(String letter) {
  if (letter == null || letter.isEmpty) {
    return _colors.values.toList()[Random().nextInt(_colors.length).toInt()];
  }
  if (!_colors.containsKey(letter[0].toUpperCase())) {
    return _colors.values.toList()[Random().nextInt(_colors.length).toInt()];
  }
  return _colors[letter[0].toUpperCase()];
}

extension on Message {
  bool get isDeleted => text == null || text.isEmpty;
  bool get isEdited => editedAt != null;
}
