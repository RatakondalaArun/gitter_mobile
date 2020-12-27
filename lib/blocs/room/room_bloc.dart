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
  RoomRepoAbs _roomRepo;
  StreamSubscription _messageStreamSub;
  RoomBloc(this._roomRepo) : super(RoomState.initial());

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
      // todo
    }
  }

  Stream<RoomState> _mapInitilizeToState(RoomEventInitilize event) async* {
    try {
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

  @override
  Future<void> close() {
    _messageStreamSub?.cancel();
    return super.close();
  }
}
