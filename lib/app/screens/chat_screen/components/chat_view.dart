import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart' as ul;

import '../../../../blocs/blocs.dart';
import 'chat_bubble.dart';
import 'chat_details.dart';

class ChatView extends StatelessWidget {
  final ScrollController scrollController;
  final TextEditingController messageController;
  final FocusNode messageFocusNode;

  const ChatView({
    Key key,
    this.scrollController,
    this.messageController,
    this.messageFocusNode,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomBloc, RoomState>(
      buildWhen: (_, n) => n.shouldUpdateChat,
      builder: (context, state) {
        if (state.isLoaded) {
          if (state.messages.isEmpty) {
            return Center(
              child: FloatingActionButton.extended(
                heroTag: 'hero_tag',
                label: Text('👋 Say Hello'),
                onPressed: _sayHello,
              ),
            );
          }
          return ListView.separated(
            reverse: true,
            controller: scrollController,
            itemCount: state.messages.length,
            physics: BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            itemBuilder: (context, index) {
              final cmessage = state.messages[index];
              final nmessage = index == state.messages.length - 1
                  ? null
                  : state.messages[index + 1];

              final isDifferentUser = _shouldShowChatHead(cmessage, nmessage) ||
                  _shouldShowDateBadge(cmessage.sentAs, nmessage?.sentAs);
              return ChatBubble(
                key: Key('chat_item#$index'),
                message: cmessage,
                isDifferentUser: isDifferentUser,
                isOneToOne: state.room.oneToOne,
                onTapUsername: _onTapUsername,
                onTapLink: _onTapLink,
                onLongPress: (m) => _onLongPressMessage(
                  context: context,
                  message: cmessage,
                  isOneToOne: state.room.oneToOne,
                ),
              );
            },
            separatorBuilder: (context, index) {
              final cmessage = state.messages[index];
              final nmessage = index == state.messages.length - 1
                  ? null
                  : state.messages[index + 1];

              return _shouldShowDateBadge(cmessage.sentAs, nmessage?.sentAs)
                  ? _DateBadge(dateTime: cmessage.sentAs)
                  : Container();
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  void _sayHello() => messageController.text = 'Hello';

  bool _shouldShowChatHead(Message cmessage, Message nmessage) {
    final currentUserId = cmessage.fromUser.id;
    // next user id if this is last message this should be null
    // to prevant index out of range
    final nextUserId = nmessage?.fromUser?.id;
    return currentUserId != nextUserId;
  }

  bool _shouldShowDateBadge(DateTime cDate, DateTime nDate) {
    return cDate.day != nDate?.day;
  }

  void _onTapUsername(String username) {
    if (messageController == null) return;
    // get current cursur position
    final currentTextValue = messageController.text;
    if (currentTextValue.isEmpty) {
      messageController.text += '@$username ';
      //move cursor to last position
      messageController.selection = TextSelection.collapsed(
        offset: messageController.text.length,
      );
      return;
    }

    final cursorPosition = messageController.selection.base.offset;
    // get the values before the cursor and after the cursour
    final textBeforeCursor = currentTextValue.substring(0, cursorPosition);
    final textAfterCursor = currentTextValue.substring(
      cursorPosition,
      currentTextValue.length,
    );

    messageController.text =
        textBeforeCursor + ' @$username ' + textAfterCursor;

    // move cursor after username length
    final targetOffset = cursorPosition + username.length + 3;
    messageController.selection = TextSelection.collapsed(offset: targetOffset);
    messageController.buildTextSpan(
        style: TextStyle(color: Colors.green), withComposing: true);
  }

  void _onLongPressMessage({
    BuildContext context,
    Message message,
    bool isOneToOne,
  }) {
    messageFocusNode.unfocus();
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, ani, ___) {
          return FadeTransition(
            opacity: ani.drive(Tween(begin: 0.0, end: 1.0)),
            child: ChatDetailDailog(
              message: message,
              isOneToOne: isOneToOne,
            ),
          );
        },
      ),
    );
  }

  void _onTapLink(String url) async {
    if (await ul.canLaunch(url)) {
      ul.launch(url);
    }
  }
}

class _DateBadge extends StatelessWidget {
  final DateTime dateTime;

  const _DateBadge({
    Key key,
    @required this.dateTime,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(indent: 10)),
        Container(
          width: 100,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          margin: const EdgeInsets.only(bottom: 20, top: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.green[800],
          ),
          alignment: Alignment.center,
          child: Text(
            _formatted,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
        ),
        Expanded(child: Divider(endIndent: 10)),
      ],
    );
  }

  String get _formatted {
    final now = DateTime.now();
    final isToday = now.day == dateTime?.day &&
        now.month == dateTime?.month &&
        now.year == dateTime?.year;
    if (isToday) return 'TODAY';
    return DateFormat('yMMMd').format(dateTime ?? '');
  }
}
