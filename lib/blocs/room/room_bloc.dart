library blocs.room;

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:gitter/repos/repos.dart';
import 'package:gitterapi/gitter_api.dart';
import 'package:gitterapi/models.dart';

part 'room_event.dart';
part 'room_state.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  AuthRepoImp _authRepo;
  RoomRepoAbs _roomRepo;
  User _currentUser;
  StreamSubscription _messageStreamSub;
  RoomBloc(this._roomRepo, this._authRepo) : super(RoomState.initial());

  @override
  Stream<RoomState> mapEventToState(RoomEvent event) async* {
    if (event is RoomEventInitilize) {
      yield* _mapInitilizeToState(event);
    } else if (event is RoomEventLoadNext) {
      yield* _mapLoadNextMessagesToState(event);
    } else if (event is _StreamMessageEvent) {
      yield* _mapStreamMessageEventToState(event);
    } else if (event is _StreamMessageDisconnectedEvent) {
      yield* _mapStreamMessageDisconnectedEventToState(event);
    } else if (event is RoomEventSendMessage) {
      yield* _mapSendMessageToState(event);
    } else if (event is RoomEventJoin) {
      yield* _mapJoinToState(event);
    }
  }

  Stream<RoomState> _mapInitilizeToState(RoomEventInitilize event) async* {
    try {
      _currentUser = await _authRepo.getCurrentUser();
      final messages = await _roomRepo.getMessages(event.room.id);
      yield RoomState.loaded(
        room: event.room,
        messages: messages.reversed.toList(),
      );
      // this loads messages stream.
      await _messageStreamSub?.cancel();
      final chatStream = await _roomRepo.getMessageStream(event.room.id);
      _messageStreamSub = chatStream.listen(
        (message) => add(_StreamMessageEvent(message)),
        onError: (e) => add(_StreamMessageDisconnectedEvent(e)),
      );
      yield state.update(
        roomMessageStreamState: RoomMessageStreamState.connected,
      );

      // TODO: mark each messages as read as the user views the message.
      if (state.room.roomMember && state.room.hasUnreadMessages) {
        // this can only happen if the user is a room member.
        await _roomRepo.markAllMessagesAsRead(
          _currentUser.id,
          state.room.id,
        );
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  Stream<RoomState> _mapStreamMessageDisconnectedEventToState(
    _StreamMessageDisconnectedEvent event,
  ) async* {
    try {
      if (event.streamEvent.isHeartbeat) {
        print('HeartBeat event');
      } else {
        final updatedMessages = state.messages
          ..insert(0, Message.fromMap(event.streamEvent.data));
        yield state.update(
          messages: updatedMessages,
        );
      }
    } catch (e, st) {
      print(st);
    }
  }

  Stream<RoomState> _mapStreamMessageEventToState(
    _StreamMessageEvent event,
  ) async* {
    try {
      if (event.streamEvent.isHeartbeat) {
        print('HeartBeat event');
      } else if (state.pendingMessagesIds
          .contains(Message.fromMap(event.streamEvent.data).id)) {
        // removes the message id from pending list
        state.pendingMessagesIds
            .remove(Message.fromMap(event.streamEvent.data).id);
        yield state.update(shouldUpdateChat: true);
      } else if (Message.fromMap(event.streamEvent.data).isChild) {
        final message = Message.fromMap(event.streamEvent.data);

        /// Change message parent thread count.
        final updatedMessages = state.messages.map((ele) {
          return ele.id == message.parentId
              ? ele.copyWith(
                  threadMessageCount: (ele.threadMessageCount ?? 0) + 1,
                )
              : ele;
        }).toList();

        yield state.update(
          messages: updatedMessages,
          shouldUpdateChat: true,
        );
      } else {
        final updatedMessages = state.messages
          ..insert(0, Message.fromMap(event.streamEvent.data));
        yield state.update(
          messages: updatedMessages,
          shouldUpdateChat: true,
        );
      }
    } catch (e, st) {
      print(st);
    }
  }

  Stream<RoomState> _mapLoadNextMessagesToState(
    RoomEventLoadNext event,
  ) async* {
    try {
      // update state to say messages are loading and prevant unwanted
      // message load events.
      yield state.update(messagesState: RoomMessagesState.loading);
      // This makes sure that messages are not empty and the state
      // is not in loading.
      if (state.messages.isNotEmpty && !state.isMessagesLoading) {
        // we should look at last message because we reverse the
        // list and load messages.
        final lastMessage = state.messages.last;
        List<Message> messages = [];
        if (!state.isAtEdge) {
          messages = await _roomRepo.getMessages(
            state.room.id,
            beforeId: lastMessage.id,
            limit: 50,
          );
        }

        if (messages.isEmpty) {
          yield state.update(
            messagesState: RoomMessagesState.loaded,
            isAtEdge: true,
          );
        } else {
          // now we update state by adding fetched messages
          // and updating messagesState to
          // accept further [RoomEventLoadNext] events
          yield state.update(
            messagesState: RoomMessagesState.loaded,
            shouldUpdateChat: true,
            messages: state.messages..addAll(messages.reversed),
          );
        }
      }
    } catch (e, s) {
      yield state.update(messagesState: RoomMessagesState.loaded);
      print(e);
      print(s);
    }
  }

  Stream<RoomState> _mapSendMessageToState(RoomEventSendMessage event) async* {
    try {
      // creates a default message object with currentuser and text
      final mockMessage = MessageExtn.fromUser(
        fromUser: _currentUser,
        text: event.message,
      );

      // inserts that mock message into state
      state.messages.insert(0, mockMessage);
      yield state.update(
        messageState: MessageSentState.sending,
        shouldUpdateChat: true,
      );

      // returns a message object sent from server
      final realMessage =
          await _roomRepo.sendMessage(state.room.id, event.message);

      // replaces mockmessage with realmessage and updates state.
      state.messages
        ..removeAt(0)
        ..insert(0, realMessage);
      state.pendingMessagesIds.add(realMessage.id);
      yield state.update(
        messageState: MessageSentState.sent,
        shouldUpdateChat: true,
      );
    } catch (e, st) {
      //
      print(st);
      yield state.update(
        blocState: RoomBlocState.error,
        messageState: MessageSentState.sent,
        shouldUpdateChat: true,
        errorMessage: 'Failed to send message',
      );
    }
  }

  Stream<RoomState> _mapJoinToState(RoomEventJoin event) async* {
    try {
      // joins user to room.
      if (!state.room.roomMember) {
        yield state.update(memberShipStatus: RoomMemberShipStatus.joining);

        final room = await _roomRepo.joinRoom(
          _currentUser.id,
          state.room.id,
        );

        yield state.update(
          room: room,
          memberShipStatus: RoomMemberShipStatus.joined,
        );
      }
    } catch (e, st) {
      print('$e\n$st');
      yield state.update(
        blocState: RoomBlocState.error,
        memberShipStatus: RoomMemberShipStatus.left,
        errorMessage: 'Unable to join room',
      );
    }
  }

  @override
  Future<void> close() {
    _messageStreamSub?.cancel();
    return super.close();
  }
}

extension MessageExtn on Message {
  static Message fromUser({
    User fromUser,
    String text,
    String parentId,
  }) {
    return Message(
      id: 'id_$text',
      text: text,
      html: text,
      sent: DateTime.now().toUtc().toString(),
      fromUser: fromUser,
      parentId: parentId,
      unread: false,
      readBy: 0,
      urls: [],
      mentions: [],
      issues: [],
      meta: [],
    );
  }
}

extension on Room {
  bool get hasUnreadMessages {
    return unreadItems != null && unreadItems != 0;
  }
}
