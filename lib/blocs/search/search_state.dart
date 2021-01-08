part of blocs.search;

/// Search Bloc can be in any of this state only.
enum SearchBlocState {
  /// First state before anything happend.
  initial,

  /// Bloc is in loading state.
  loading,

  /// Bloc loaded with results.
  loaded,

  /// Bloc encountered error.
  error,
}

/// To notify search events.
enum SearchStatus {
  /// Bloc is searching for the results.
  /// This can be used to notify user that
  /// Searching resultes are loading.
  searcing,

  /// Bloc finished searching and loaded results.
  searched,
}

class SearchState {
  /// Bloc state.
  final SearchBlocState blocState;

  ///
  final SearchStatus searchStatus;

  /// contains previously searched queries.
  /// This are stored locally.
  final List<String> searchHistory;

  /// Results from the server
  final List<Room> rooms;

  ///
  final List<User> users;

  /// Contains error message if any error or exception occured.
  final String errorMessage;

  bool get isInitial => blocState == SearchBlocState.initial;
  bool get isLoading => blocState == SearchBlocState.loading;
  bool get isLoaded => blocState == SearchBlocState.loaded;
  bool get isError => blocState == SearchBlocState.error;

  bool get isSearching => searchStatus == SearchStatus.searcing;
  bool get isSearched => searchStatus == SearchStatus.searched;

  /// Creates a instance of [SearchState].
  SearchState(
    this.blocState, {
    this.searchStatus = SearchStatus.searched,
    List<String> searchHistory,
    List<Room> rooms,
    List<User> users,
    this.errorMessage,
  })  : this.rooms = rooms ?? <Room>[],
        this.users = users ?? <User>[],
        this.searchHistory = searchHistory ?? <String>[];

  /// Initial State.
  factory SearchState.initial() {
    return SearchState(SearchBlocState.initial);
  }

  /// Loading state.
  factory SearchState.loading() {
    return SearchState(
      SearchBlocState.loading,
      searchStatus: SearchStatus.searcing,
    );
  }

  /// Loaded state.
  factory SearchState.loaded({
    List<Room> rooms = const <Room>[],
    List<User> users = const <User>[],
    List<String> searchHistory = const <String>[],
  }) {
    return SearchState(
      SearchBlocState.loaded,
      searchHistory: searchHistory,
      rooms: rooms,
      users: users,
    );
  }

  /// Error state.
  factory SearchState.error(String errorMessage) {
    return SearchState(
      SearchBlocState.error,
      errorMessage: errorMessage,
    );
  }

  /// Update only partial values without overwriting
  /// others values except errorMessage.
  SearchState update({
    SearchBlocState blocState,
    SearchStatus searchStatus,
    List<Room> rooms,
    List<User> users,
    List<String> searchHistory,
    String errorMessage,
  }) {
    return SearchState(
      blocState ?? this.blocState,
      searchStatus: searchStatus ?? this.searchStatus,
      rooms: rooms ?? this.rooms,
      users: users ?? this.users,
      searchHistory: searchHistory ?? this.searchHistory,
      errorMessage: errorMessage,
    );
  }

  SearchState loaded({
    List<Room> rooms,
    List<User> users,
    List<String> searchHistory,
  }) {
    return SearchState(
      SearchBlocState.loaded,
      searchHistory: searchHistory ?? this.searchHistory,
      rooms: rooms ?? this.rooms,
      users: users ?? this.users,
    );
  }

  /// Generate error State with already defined values.
  SearchState error(String errorMessage) {
    return SearchState(
      SearchBlocState.error,
      searchStatus: SearchStatus.searched,
      rooms: this.rooms,
      searchHistory: this.searchHistory,
      errorMessage: errorMessage,
    );
  }
}
