library blocs.room;

import 'package:bloc/bloc.dart';
import 'package:gitter/repos/repos.dart';
import 'package:gitterapi/models.dart';
import 'package:gitterapi/models/message.dart';

part 'room_event.dart';
part 'room_state.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  RoomRepoAbs _roomRepo;
  RoomBloc(this._roomRepo) : super(RoomState.initial());

  @override
  Stream<RoomState> mapEventToState(RoomEvent event) async* {
    if (event is RoomEventGetMessages) {
      yield* _mapGetMessagesToState(event);
    }
  }

  Stream<RoomState> _mapGetMessagesToState(RoomEventGetMessages event) async* {
    try {
      final messages = await _roomRepo.getMessages(event.room.id);
      yield RoomState.loaded(messages);
    } catch (e, s) {
      print(e);
      print(s);
    }
  }
}
