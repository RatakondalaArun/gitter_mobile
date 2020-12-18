import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gitter/blocs/blocs.dart';

class HSDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          BlocBuilder<AuthBloc, AuthState>(
            builder: (_, state) {
              return UserAccountsDrawerHeader(
                accountName: Text(state.user.displayName),
                accountEmail: Text('@${state.user.username}'),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(state.user.avatarUrlMedium),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
