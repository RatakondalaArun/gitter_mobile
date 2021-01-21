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
  AuthRepoAbs _authRepo;
  RoomRepoAbs _roomRepo;

  /// current user.
  User _actor;

  /// Subscription of messages stream.
  StreamSubscription _messageStreamSub;

  RoomBloc(
    this._roomRepo,
    this._authRepo,
  ) : super(RoomState.loading());

  @override
  Stream<RoomState> mapEventToState(RoomEvent event) async* {
    if (event is RoomEventInitilize) {
      yield* _mapInitilizeToState(event);
    } else if (event is RoomEventPaginateMessages) {
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

  // Initilizes this Bloc by loading necessary data.
  Stream<RoomState> _mapInitilizeToState(RoomEventInitilize event) async* {
    try {
      _actor = await _authRepo.getActor();
      final messages = await _roomRepo.getMessages(event.room.id);
      yield RoomState.loaded(
        room: event.room,
        messages: messages.reversed.toList(),
      );
      // cancel any previous messages.
      await _messageStreamSub?.cancel();
      final chatStream = await _roomRepo.getMessageStream(event.room.id);
      _messageStreamSub = chatStream.listen(
        (message) => add(_StreamMessageEvent(message)),
        onError: (e) => add(_StreamMessageDisconnectedEvent(e)),
      );

      yield state.update(
        messageStreamState: RoomMessageStreamStatus.connected,
      );

      // TODO: mark each messages as read as the user views the message.
      if (state.room.roomMember && state.room.hasUnreadMessages) {
        // this can only happen if the user is a room member.
        await _roomRepo.markAllMessagesAsRead(
          _actor.id,
          state.room.id,
        );
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  /// Handles stream disconnection event.
  Stream<RoomState> _mapStreamMessageDisconnectedEventToState(
    _StreamMessageDisconnectedEvent event,
  ) async* {
    try {
      // notifies disconnected state.
      if (event._error != null) {
        // TODO: handle chat stream disconnection events.
        print(event._error);
      }
      yield state.update(
        messageStreamState: RoomMessageStreamStatus.disconnected,
      );
    } catch (e, st) {
      print(st);
    }
  }

  /// Handles messages from chat stream
  Stream<RoomState> _mapStreamMessageEventToState(
    _StreamMessageEvent event,
  ) async* {
    try {
      if (event.streamEvent.isHeartbeat) {
        print('HeartBeat event');
      } else if (state.pendingMessagesIds
          .contains(Message.fromMap(event.streamEvent.data).id)) {
        // removes the message id from pending list
        state.pendingMessagesIds.remove(
          Message.fromMap(event.streamEvent.data).id,
        );

        yield state.update(shouldUpdateChat: true);
      } else if (Message.fromMap(event.streamEvent.data).isChild) {
        // update the message count
        final message = Message.fromMap(event.streamEvent.data);

        final updatedMessages =
            await compute<Map<String, dynamic>, List<Message>>(
          _updateThreadCount,
          {
            'messages': state.messages,
            'parentId': message.parentId,
          },
          debugLabel: 'Updating thread messages',
        );

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

  /// fetches and adds paginated messages.
  Stream<RoomState> _mapLoadNextMessagesToState(
    RoomEventPaginateMessages event,
  ) async* {
    try {
      // update state to say messages are loading and prevant unwanted
      // message load events.
      yield state.update(paginationStatus: PaginationState.loading);
      // This makes sure that messages are not empty and the state
      // is not in loading.
      if (state.messages.isNotEmpty && !state.isPaginating) {
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
            paginationStatus: PaginationState.loaded,
            isAtEdge: true,
          );
        } else {
          // now we update state by adding fetched messages
          // and updating messagesState to
          // accept further [RoomEventLoadNext] events
          yield state.update(
            paginationStatus: PaginationState.loaded,
            shouldUpdateChat: true,
            messages: state.messages..addAll(messages.reversed),
          );
        }
      }
    } catch (e, s) {
      yield state.update(paginationStatus: PaginationState.loaded);
      print(e);
      print(s);
    }
  }

  Stream<RoomState> _mapSendMessageToState(RoomEventSendMessage event) async* {
    try {
      // creates a default message object with currentuser and text
      final mockMessage = MessageExtn.createMock(
        fromUser: _actor,
        text: event.message,
      );

      // inserts that mock message into state
      state.messages.insert(0, mockMessage);
      yield state.update(
        messageDelivaryStatus: MessageDelivaryStatus.sending,
        shouldUpdateChat: true,
      );

      // returns a message object sent from server
      final realMessage =
          await _roomRepo.sendMessage(state.room.id, event.message);

      // add this message as pending
      state.pendingMessagesIds.add(realMessage.id);

      // replaces mockmessage with realmessage and updates state.
      state.messages
        ..removeAt(0)
        ..insert(0, realMessage);
      yield state.update(
        messageDelivaryStatus: MessageDelivaryStatus.sent,
        shouldUpdateChat: true,
      );
    } catch (e, st) {
      print(st);
      yield state.update(
        blocState: RoomBlocState.error,
        messageDelivaryStatus: MessageDelivaryStatus.failed,
        shouldUpdateChat: true,
        errorMessage: 'Failed to send message',
      );
    }
  }

  /// joins actor to room.
  Stream<RoomState> _mapJoinToState(RoomEventJoin event) async* {
    try {
      if (!state.room.roomMember) {
        // actor should not be a room member.
        yield state.update(memberShipStatus: RoomMemberShipStatus.joining);
        // send a join request to server which returs [Room].
        final room = await _roomRepo.joinRoom(
          _actor.id,
          state.room.id,
        );
        // update the room
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

// Extended to create a mock method.
extension MessageExtn on Message {
  /// Creates a instance of [Message]
  /// with only minimum fields.
  static Message createMock({
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

// updates the thread count for a perticular message
List<Message> _updateThreadCount(Map<String, dynamic> params) {
  final messages = params['messages'] as List<Message>;
  final targetId = params['parentId'] as String;
  // ?may be we should throw an exception.
  if (messages == null) return [];
  if (targetId == null) return [];

  return messages.map((ele) {
    return ele.id == targetId
        ? ele.copyWith(threadMessageCount: (ele.threadMessageCount ?? 0) + 1)
        : ele;
  }).toList();
}
