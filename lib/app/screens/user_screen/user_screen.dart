import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../../../blocs/blocs.dart';
import '../../helpers/helpers.dart' as helpers;
import '../../widgets/widgets.dart';
import 'components/github_profile.dart';
import 'components/github_stats.dart';

class UserScreen extends StatefulWidget {
  static const routeName = '/UserScreen';

  final User user;

  const UserScreen({
    Key key,
    this.user,
  }) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  UserBloc _userBloc;

  @override
  void initState() {
    _userBloc = BlocProvider.of<UserBloc>(context);
    _userBloc.add(UserEventLoadProfile(widget.user));
    super.initState();
  }

  @override
  void dispose() {
    _userBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isCurrentUser =
        BlocProvider.of<AuthBloc>(context).state.user.id == widget.user.id;
    return DraggableScrollableSheet(
      minChildSize: 0.3,
      builder: (context, scrollController) {
        return Material(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          child: ListView(
            physics: BouncingScrollPhysics(),
            controller: scrollController,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.rotate(
                    angle: 4.7,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios_rounded),
                      splashRadius: 20,
                      onPressed: _close,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Padding(
                padding: kSectionPadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 80,
                      width: 80,
                      child: CircularImage(
                        imageUrl: widget.user.avatarUrl,
                        displayName: widget.user.displayName,
                      ),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
              ),
              Padding(
                padding: kSectionPadding,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.user.displayName}',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '@${widget.user.username}',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              Divider(),
              _Details(isCurrentUser: isCurrentUser),
              // repos
              // github org
            ],
          ),
        );
      },
    );
  }

  /// Default padding for sections/components
  EdgeInsets get kSectionPadding {
    return const EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 10,
    );
  }

  void _close() {
    Navigator.of(context).pop();
  }
}

class _Details extends StatelessWidget {
  final bool isCurrentUser;

  const _Details({
    Key key,
    this.isCurrentUser,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state.isLoaded) {
          return Column(
            children: [
              if (state.userProfile.isUserFromGithub)
                GithubProfileStats(githubStats: state.userProfile.github),
              ButtonBar(
                mainAxisSize: MainAxisSize.max,
                alignment: MainAxisAlignment.spaceAround,
                children: [
                  if (!isCurrentUser)
                    FlatButton.icon(
                      label: Text('chat'),
                      icon: Icon(Icons.chat_bubble_outline),
                      onPressed: () {},
                    ),
                  if (state.userProfile.isUserFromGithub)
                    FlatButton.icon(
                      label: Text('github'),
                      icon: Icon(FontAwesome.github),
                      onPressed: () => _launchUrl(state.userProfile.profile),
                    ),
                  if (!state.userProfile.isUserFromGithub)
                    FlatButton.icon(
                      label: Text('gitlab'),
                      icon: Icon(FontAwesome.gitlab),
                      onPressed: () => _launchUrl(
                        _parsedGitlabUrlFrom(state.userProfile.username),
                      ),
                    )
                ],
              ),

              // displayes user contact location from the github.
              if (state.userProfile.isUserFromGithub)
                GithubProfileComponent(profile: state.userProfile)
            ],
          );
        }
        return GitterLoadingIndicator();
      },
    );
  }

  String _parsedGitlabUrlFrom(String username) {
    if (username == null) return '';
    if (username.contains('gitlab')) {
      return 'https://gitlab.com/${username.substring(0, username.trim().length - 7)}';
    } else {
      return 'https://gitlab.com/$username}';
    }
  }

  Future<void> _launchUrl(String url) async {
    await helpers.openLink(url);
  }
}
