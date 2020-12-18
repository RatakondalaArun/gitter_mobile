part of blocs.home;

abstract class HomeEvent {}

/// This event gets triggerd initially and only once.
///
class _InitialEvent extends HomeEvent {}

/// This event triggers chat refresh
class HomeEventRefreshRooms extends HomeEvent {}

/// This event NavigationBar
class HomeEventUpdateNavBar extends HomeEvent {}

class _PerodicRefreshEvent extends HomeEvent {}
