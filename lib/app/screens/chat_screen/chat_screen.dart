import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gitterapi/models.dart';

import '../../../blocs/blocs.dart';
import 'components/chat_details.dart';
import 'components/chat_bubble.dart';
import 'components/chat_screen_app_bar.dart';
import 'components/message_input.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = '/ChatScreen';
  final Room room;

  const ChatScreen({
    Key key,
    this.room,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  RoomBloc _roomBloc;
  ScrollController _scrollController;
  TextEditingController _messageController;
  FocusNode _messageInputFocus;

  @override
  void initState() {
    _roomBloc = BlocProvider.of<RoomBloc>(context);
    _scrollController = ScrollController();
    _messageController = TextEditingControllerWithMentions(text: '');
    _messageInputFocus = FocusNode();
    _scrollController.addListener(_scrollHandle);
    super.initState();
  }

  void _scrollHandle() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.extentAfter < 200.0 &&
        _scrollController.position.atEdge) {
      if (!_roomBloc.state.isMessagesLoading) {
        _roomBloc.add(RoomEventLoadNext());
      }
    }
  }

  @override
  void dispose() {
    _messageInputFocus?.unfocus();
    _messageInputFocus?.dispose();
    _messageController?.dispose();
    _scrollController?.dispose();
    _roomBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatScreenAppBar(room: widget.room),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            bottom: 65,
            left: 0,
            right: 0,
            child: _ChatView(
              scrollController: _scrollController,
              messageController: _messageController,
              messageFocusNode: _messageInputFocus,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: MessageInput(
              textController: _messageController,
              focusNode: _messageInputFocus,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatView extends StatelessWidget {
  final ScrollController scrollController;
  final TextEditingController messageController;
  final FocusNode messageFocusNode;

  const _ChatView({
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
          return ListView.builder(
            reverse: true,
            controller: scrollController,
            itemCount: state.messages.length,
            itemBuilder: (context, index) {
              // current message
              final message = state.messages[index];
              // current user id
              final currentUserId = message.fromUser.id;
              // next user id if this is last message this should be null
              // to prevant index out of bounds
              final nextUserId = index == state.messages.length - 1
                  ? null
                  : state.messages[index + 1].fromUser.id;
              // this will check if this is different user
              final isDifferentUser = currentUserId != nextUserId;
              return ChatBubble(
                key: Key('chat_item#$index'),
                message: message,
                isDifferentUser: isDifferentUser,
                isOneToOne: state.room.oneToOne,
                onTapUsername: _onTapUsername,
                onLongPress: (m) => _onLongPressMessage(
                  context: context,
                  message: message,
                  isOneToOne: state.room.oneToOne,
                ),
              );
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
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
    final controller = showBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      elevation: 0,
      builder: (context) => ChatDetailDailog(
        message: message,
        isOneToOne: isOneToOne,
      ),
    );
  }
}

/// Styles the `@mentions`
class TextEditingControllerWithMentions extends TextEditingController {
  TextEditingControllerWithMentions({String text}) : super(text: text);

  @override
  TextSpan buildTextSpan({TextStyle style, bool withComposing}) {
    return super.buildTextSpan(style: style, withComposing: withComposing);
    // todo(@RatakondalaArun): implement.
    // this logic has performance drawbacks
    // https://github.com/flutter/flutter/issues/49860

    // final spans = <TextSpan>[];
    // text.split(' ').forEach((element) {
    //   if (!element.startsWith('@')) {
    //     spans.add(TextSpan(text: '$element '));
    //   } else {
    //     spans.add(TextSpan(
    //       text: '$element ',
    //       style: style.merge(TextStyle(color: Colors.green)),
    //     ));
    //   }
    // });
    // return TextSpan(children: spans, style: style);
  }
}
