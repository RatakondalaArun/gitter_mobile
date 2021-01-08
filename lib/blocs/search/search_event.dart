part of blocs.search;

abstract class SearchEvent {
  final String query;

  SearchEvent({this.query});
}

class _InitialEvent extends SearchEvent {}

class SearchEventQuery extends SearchEvent {
  SearchEventQuery(String query) : super(query: query);
}
