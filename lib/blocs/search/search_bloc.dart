library blocs.search;

import 'package:bloc/bloc.dart';
import 'package:gitter/repos/repos.dart';

import '../blocs.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepoAbs _searchRepo;
  SearchBloc(this._searchRepo) : super(SearchState.loading()) {
    add(_InitialEvent());
  }

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is _InitialEvent) {
      yield* _mapInitialToState(event);
    } else if (event is SearchEventQuery) {
      yield* _mapQueryToState(event);
    }
  }

  Stream<SearchState> _mapInitialToState(_InitialEvent event) async* {
    try {
      //
      yield SearchState.loaded();
    } catch (e) {
      //
    }
  }

  Stream<SearchState> _mapQueryToState(SearchEventQuery event) async* {
    // Queries server for results.
    try {
      //
      yield state.update(searchStatus: SearchStatus.searcing);
      if (event.query != null && event.query.trim().isNotEmpty) {
        final rooms = await _searchRepo.searchRooms(event.query);
        yield state.loaded(rooms: rooms);
        final users = await _searchRepo.searchUsers(event.query);
        yield state.loaded(users: users);
      } else {
        yield state.update(searchStatus: SearchStatus.searched);
      }
    } catch (_, st) {
      //
      print(st);
    }
  }
}
