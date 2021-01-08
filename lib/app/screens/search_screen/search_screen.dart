import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/blocs.dart';
import '../../../repos/repos.dart';
import 'components/search_tile.dart';

class SearchScreen extends StatefulWidget {
  final void Function({Room returnValue}) closeCallBack;

  const SearchScreen({
    Key key,
    this.closeCallBack,
  }) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // bloc for this screen
  final _searchBloc = SearchBloc(SearchRepoImp());
  // hides text clear icon on search field
  final _hideQueryClearIcon = ValueNotifier<bool>(true);
  // text controller for searchfield.
  final _queryTextCtrl = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _hideQueryClearIcon.dispose();
    _queryTextCtrl.dispose();
    _searchBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchBloc>.value(
      value: _searchBloc,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.8,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Colors.black87,
            ),
            // returns null if back button is pressed
            onPressed: () => widget.closeCallBack?.call(returnValue: null),
          ),
          // Renders textfield on app bar.
          title: SearchField(
            queryTextCtrl: _queryTextCtrl,
            shouldHideCloseIcon: _hideQueryClearIcon,
          ),
        ),
        body: Stack(
          children: [
            // Shows search results
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: SearchResults(),
            ),
            // Shows progress indicator while loading results
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: BlocBuilder<SearchBloc, SearchState>(
                cubit: _searchBloc,
                builder: (context, state) {
                  if (state.isSearching || state.isLoading) {
                    return LinearProgressIndicator();
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  final TextEditingController queryTextCtrl;
  final ValueNotifier<bool> shouldHideCloseIcon;

  const SearchField({
    Key key,
    this.queryTextCtrl,
    this.shouldHideCloseIcon,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: 1,
      keyboardType: TextInputType.text,
      controller: queryTextCtrl,
      autofocus: true,
      onChanged: (q) => _onQueryChanged(q, context),
      onSubmitted: (q) => _onSubmitted(q, context),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Search for users/rooms',
        hintStyle: TextStyle(
          fontSize: 16,
          color: Colors.black45,
          fontWeight: FontWeight.w400,
        ),
        suffixIcon: ValueListenableBuilder<bool>(
          valueListenable: shouldHideCloseIcon,
          builder: (context, value, _) {
            return value
                ? SizedBox()
                : IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      color: Colors.grey,
                    ),
                    onPressed: () => queryTextCtrl.text = '',
                  );
          },
        ),
      ),
    );
  }

  void _onQueryChanged(String query, BuildContext context) {
    if (query.isEmpty) {
      shouldHideCloseIcon.value = true;
    } else {
      shouldHideCloseIcon.value = false;
    }
    if (query.length % 3 == 0) {
      BlocProvider.of<SearchBloc>(context).add(SearchEventQuery(query));
    }
  }

  void _onSubmitted(String query, BuildContext context) {
    BlocProvider.of<SearchBloc>(context).add(SearchEventQuery(query));
  }
}

class SearchResults extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state.isLoaded) {
          return ListView.builder(
            physics: AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            itemCount: state.rooms.length,
            itemBuilder: (context, index) {
              return SearchTile(room: state.rooms[index]);
            },
          );
        }
        if (state.isLoading) {
          return Container();
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
