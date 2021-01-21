import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gitterapi/models.dart';

import '../../../blocs/blocs.dart';
import 'components/chat_screen_app_bar.dart';
import 'components/chat_view.dart';
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
  final _shouldShowFAB = ValueNotifier<bool>(false);
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  RoomBloc _roomBloc;
  ScrollController _chatScrollController;
  TextEditingController _messageController;
  FocusNode _messageInputFocus;

  @override
  void initState() {
    _roomBloc = BlocProvider.of<RoomBloc>(context)..listen(_handleState);
    _chatScrollController = ScrollController();
    _messageController = TextEditingControllerWithMentions(text: '');
    _messageInputFocus = FocusNode();
    _chatScrollController.addListener(_scrollHandle);
    super.initState();
  }

  void _scrollHandle() {
    if (!_chatScrollController.hasClients) return;
    if (_chatScrollController.position.extentAfter < 200.0 &&
        _chatScrollController.position.atEdge) {
      if (!_roomBloc.state.isPaginating) {
        _roomBloc.add(RoomEventPaginateMessages());
      }
    }
    if (_chatScrollController.position.extentBefore > 400) {
      if (!_shouldShowFAB.value) _shouldShowFAB.value = true;
    } else {
      _shouldShowFAB.value = false;
    }
  }

  void _handleState(RoomState state) {
    if (state.isError) _notifyErrorToUser(state.errorMessage);
    if (state.messageDelivaryStaus == MessageDelivaryStatus.sent) {
      _messageController.text = '';
    }
  }

  void _notifyErrorToUser(String errorMessage) {
    _scaffoldKey.currentState
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(errorMessage ?? 'Something went Wrong'),
          backgroundColor: Colors.red,
        ),
      );
  }

  @override
  void dispose() {
    _messageInputFocus?.unfocus();
    _messageInputFocus?.dispose();
    _messageController?.dispose();
    _chatScrollController?.dispose();
    _roomBloc?.close();
    _shouldShowFAB.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        appBar: ChatScreenAppBar(room: widget.room),
        body: Stack(
          children: [
            Positioned(
              top: 0,
              bottom: 65,
              left: 0,
              right: 0,
              child: ChatView(
                scrollController: _chatScrollController,
                messageController: _messageController,
                messageFocusNode: _messageInputFocus,
              ),
            ),
            Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                // shows join button incase user is not a roomMember.
                child: BlocBuilder<RoomBloc, RoomState>(
                  cubit: _roomBloc,
                  builder: (context, state) {
                    if (state.isLoading) return Container();
                    if (!(state.room?.roomMember ?? false)) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CupertinoButton(
                            color: Colors.green.shade400,
                            child: state.memberShipStatus ==
                                    RoomMemberShipStatus.joining
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1,
                                    ),
                                  )
                                : Text('Join chat'),
                            onPressed: state.memberShipStatus ==
                                    RoomMemberShipStatus.joining
                                ? null
                                : _joinRoom,
                          ),
                          SizedBox(height: 10)
                        ],
                      );
                    }
                    return MessageInput(
                      textController: _messageController,
                      focusNode: _messageInputFocus,
                      onSend: _sendMessage,
                    );
                  },
                )),
            Positioned(
              right: 10,
              bottom: 100,
              child: ValueListenableBuilder<bool>(
                valueListenable: _shouldShowFAB,
                builder: (_, value, child) {
                  return AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    child: value ? child : Container(),
                  );
                },
                child: FloatingActionButton(
                  backgroundColor: Colors.blue.shade300,
                  mini: true,
                  child: Icon(Icons.arrow_downward_outlined),
                  onPressed: _jumpToRecentChat,
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: Container(
                child: BlocBuilder<RoomBloc, RoomState>(
                  cubit: _roomBloc,
                  builder: (context, state) {
                    return state.isPaginating
                        ? LinearProgressIndicator()
                        : Container();
                  },
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: Container(
                child: BlocBuilder<RoomBloc, RoomState>(
                  cubit: _roomBloc,
                  builder: (context, state) {
                    return state.messageDelivaryStaus ==
                            MessageDelivaryStatus.sending
                        ? LinearProgressIndicator(
                            backgroundColor: Colors.transparent,
                          )
                        : Container();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _jumpToRecentChat() {
    _chatScrollController.animateTo(
      1.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _sendMessage(String message) {
    _roomBloc.add(RoomEventSendMessage(message: message));
  }

  void _joinRoom() {
    _roomBloc.add(RoomEventJoin());
  }
}

/// Styles the @mentions
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
