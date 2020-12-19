import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/home_tile.dart';
import 'components/hs_drawer.dart';
import 'components/search_bar.dart';
import '../../widgets/widgets.dart';
import '../../../blocs/blocs.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/SignInScreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeBloc _homeBloc;
  PageController _pageController;
  ScrollController _scrollController;
  int _currentPage = 0;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    _homeBloc = BlocProvider.of<HomeBloc>(context);
    _homeBloc.listen(_handleState);
    _pageController = PageController();
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    _homeBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      extendBodyBehindAppBar: true,
      drawer: HSDrawer(),
      body: RefreshIndicator(
        key: _refreshKey,
        onRefresh: () => Future.delayed(Duration(seconds: 2)),
        displacement: 100,
        child: NestedScrollView(
          controller: _scrollController,
          floatHeaderSlivers: true,
          physics: BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          headerSliverBuilder: (_, __) => [
            SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0,
              floating: true,
              snap: false,
              toolbarHeight: kToolbarHeight + 20,
              flexibleSpace: SearchBar(
                onShowDrawer: _showDrawer,
                onShowAccount: _showAccount,
              ),
            ),
          ],
          body: PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: _pageController,
            children: [
              _RoomsPage(controller: _scrollController),
              _DirectMessages(controller: _scrollController),
            ],
          ),
        ),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      // TODO(@RatakondalaArun): Add Join room.
      bottomNavigationBar: BlocBuilder<HomeBloc, HomeState>(
        builder: (_, state) {
          return BottomNavigationBar(
            currentIndex: _currentPage,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            onTap: _goToSelectedPage,
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.w700),
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.meeting_room_outlined),
                activeIcon: Icon(Icons.meeting_room),
                label: 'Rooms',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  state.isDMUnread
                      ? Icons.mark_chat_unread_outlined
                      : Icons.chat_bubble_outlined,
                ),
                activeIcon: Icon(
                  state.isDMUnread ? Icons.mark_chat_unread : Icons.chat_bubble,
                ),
                label: 'DM',
              )
            ],
          );
        },
      ),
    );
  }

  void _goToSelectedPage(int page) {
    if (_currentPage == page) return;
    _pageController.animateToPage(
      page,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    _currentPage = page;
    _homeBloc.add(HomeEventUpdateNavBar());
  }

  Future<void> _handleState(HomeState state) async {
    if (state.isInitial) {
      if (_refreshKey.currentState.mounted) {
        await _refreshKey.currentState.show();
      }
    }
  }

  void _showDrawer() {
    if (!_scaffoldKey.currentState.hasDrawer) return;
    _scaffoldKey.currentState.openDrawer();
  }

  void _showAccount() {
    // TODO(@RatakondalaArun): open account screen
  }
}

class _RoomsPage extends StatelessWidget {
  final ScrollController controller;

  const _RoomsPage({Key key, this.controller}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (n, o) {
        return !n.shouldUpdateNavBar;
      },
      builder: (_, state) {
        if (state.isInitial) {
          return Container(
            alignment: Alignment.center,
            child: Text('Loading'),
          );
        }
        return ListView.builder(
          controller: controller,
          itemCount: state.rooms.length,
          itemBuilder: (context, index) {
            return HomeTile(
              room: state.rooms[index],
            );
          },
        );
      },
    );
  }
}

class _DirectMessages extends StatelessWidget {
  final ScrollController controller;

  const _DirectMessages({Key key, this.controller}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (_, state) {
        if (state.isInitial) {
          return Container(
            alignment: Alignment.center,
            child: Text('Loading'),
          );
        }
        return ListView.builder(
          controller: controller,
          itemCount: state.chats.length,
          itemBuilder: (context, index) {
            final chat = state.chats[index];
            return ListTile(
              leading: SizedBox(
                height: 40,
                width: 40,
                child: CircularImage(
                  displayName: chat?.name,
                  imageUrl: chat.avatarUrl,
                ),
              ),
              title: Text('${chat.name}'),
              trailing: _shouldShowUnread(chat.unreadItems)
                  ? Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.green.shade700,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        _formatUnreadCount(chat.unreadItems),
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : null,
            );
          },
        );
      },
    );
  }

  bool _shouldShowUnread(int count) {
    return !(count == null || count == 0);
  }

  String _formatUnreadCount(int count) {
    return count > 99 ? '99+' : '$count';
  }
}
