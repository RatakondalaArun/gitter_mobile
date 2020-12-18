library blocs.home;

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:gitter/repos/repos.dart';
import 'package:gitterapi/models.dart';

part 'home_state.dart';
part 'home_event.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeRepoAbs _homeRepo;
  AuthRepoAbs _authRepo;

  StreamSubscription _perodicChatfetch;

  HomeBloc(
    this._authRepo,
    this._homeRepo,
  ) : super(HomeState.initial()) {
    add(_InitialEvent());
  }

  @override
  Future<void> close() {
    _perodicChatfetch?.cancel();
    return super.close();
  }

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is _InitialEvent) {
      yield* _mapInitialEvent(event);
    } else if (event is HomeEventRefreshRooms) {
      yield* _mapRefreshToState();
    } else if (event is HomeEventUpdateNavBar) {
      yield state.update(shouldUpdateNavBar: true);
    } else if (event is _PerodicRefreshEvent) {
      yield* _mapPerodicRefreshToState();
    }
  }

  Stream<HomeState> _mapInitialEvent(_InitialEvent event) async* {
    try {
      yield HomeState.initial();
      final user = await _authRepo.getCurrentUser();
      final rooms = await _homeRepo.getCurrentUserRooms(user.id);
      final sortedRooms = await compute<List<Room>, _SortedRooms>(
        _optmizedRoomsSort,
        rooms,
        debugLabel: 'Sorting Rooms',
      );

      yield HomeState.loaded(
        rooms: sortedRooms.rooms,
        chats: sortedRooms.chats,
        isDMUnread: sortedRooms.isChatsUnread,
      );

      await _perodicChatfetch?.cancel();

      // Refreshs rooms data for every two minutes
      // and triggers a [_PerodicRefreshEvent]. Which then
      // fetches data and updates state.
      _perodicChatfetch = Stream.periodic(
        Duration(minutes: 2),
        (c) => c,
      ).listen(
        (c) => add(_PerodicRefreshEvent()),
        onError: (e, st) => print('$e,$st'),
        cancelOnError: false,
      );
    } catch (e) {
      print(e);
      // todo
    }
  }

  // handles manual refresh events
  Stream<HomeState> _mapRefreshToState() async* {
    try {
      yield HomeState.loading();
      final user = await _authRepo.getCurrentUser();
      final rooms = await _homeRepo.getCurrentUserRooms(user.id);
      final sortedRooms = await compute<List<Room>, _SortedRooms>(
        _optmizedRoomsSort,
        rooms,
        debugLabel: 'Sorting Rooms',
      );
      yield HomeState.loaded(
        rooms: sortedRooms.rooms,
        chats: sortedRooms.chats,
        isDMUnread: sortedRooms.isChatsUnread,
      );
    } catch (e) {
      print(e);
    }
  }

  // handles manual refresh events
  Stream<HomeState> _mapPerodicRefreshToState() async* {
    try {
      print('Perodic Fetch triggered');
      final user = await _authRepo.getCurrentUser();
      final rooms = await _homeRepo.getCurrentUserRooms(user.id);
      final sortedRooms = await compute<List<Room>, _SortedRooms>(
        _optmizedRoomsSort,
        rooms,
        debugLabel: 'Sorting Rooms',
      );
      yield HomeState.loaded(
        rooms: sortedRooms.rooms,
        chats: sortedRooms.chats,
        isDMUnread: sortedRooms.isChatsUnread,
      );
    } catch (e) {
      print(e);
    }
  }
}

_SortedRooms _optmizedRoomsSort(List<Room> rooms) {
  try {
    final unreadRooms = <Room>[];
    final readRooms = <Room>[];
    final unreadChats = <Room>[];
    final readChats = <Room>[];

    /// seperates all chats and rooms base on the unreadcount
    rooms.forEach((room) {
      if ((room.oneToOne ?? false)) {
        if (room.unreadItems == 0) {
          readChats.add(room);
        } else {
          unreadChats.add(room);
        }
      } else {
        if (room.unreadItems == 0) {
          readRooms.add(room);
        } else {
          unreadRooms.add(room);
        }
      }
    });

    // sort rooms
    unreadRooms.sort((a, b) =>
        b.lastAccessTimeAsDateTime.compareTo(a.lastAccessTimeAsDateTime));
    readRooms.sort((a, b) =>
        b.lastAccessTimeAsDateTime.compareTo(a.lastAccessTimeAsDateTime));
    // sort chats
    unreadChats.sort((a, b) =>
        b.lastAccessTimeAsDateTime.compareTo(a.lastAccessTimeAsDateTime));
    readChats.sort((a, b) =>
        b.lastAccessTimeAsDateTime.compareTo(a.lastAccessTimeAsDateTime));

    return _SortedRooms(
      rooms: [...unreadRooms, ...readRooms],
      chats: [...unreadChats, ...readChats],
      totalUnreadRooms: unreadRooms.length,
      totalUnreadChats: unreadChats.length,
    );
  } catch (e) {
    print(e);
    return _SortedRooms(rooms: <Room>[], chats: <Room>[]);
  }
}

class _SortedRooms {
  final List<Room> rooms;
  final List<Room> chats;
  final int totalUnreadRooms;
  final int totalUnreadChats;

  bool get isChatsUnread => totalUnreadChats != 0;
  bool get isRoomsUnread => totalUnreadRooms != 0;

  const _SortedRooms({
    this.rooms,
    this.chats,
    this.totalUnreadRooms = 0,
    this.totalUnreadChats = 0,
  });
}
