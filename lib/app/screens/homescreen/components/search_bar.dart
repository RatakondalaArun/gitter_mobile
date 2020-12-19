import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gitter/app/screens/screens.dart';
import 'package:gitterapi/models.dart';

import '../../../../blocs/blocs.dart';
import '../../../widgets/widgets.dart';

class SearchBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onShowDrawer;
  final VoidCallback onShowAccount;

  /// This is the room selected by user
  /// this can be null.
  final void Function(Room room) selectedRoom;

  const SearchBar({
    Key key,
    this.onShowDrawer,
    this.onShowAccount,
    this.selectedRoom,
  }) : super(key: key);

  /// SearchBar icons splash radious
  double get splashRadious => 20.0;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 15);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.all(6),
      child: SafeArea(
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: OpenContainer<Room>(
            transitionType: ContainerTransitionType.fadeThrough,
            closedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            closedBuilder: (context, action) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.menu_rounded),
                          tooltip: 'Drawer',
                          splashRadius: splashRadious,
                          onPressed: onShowDrawer?.call,
                        ),
                        const Text(
                          'Search for users/rooms',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black45,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (_, state) {
                        return IconButton(
                          splashRadius: splashRadious,
                          tooltip: 'Profile',
                          onPressed: onShowAccount?.call,
                          icon: CircularImage(
                            imageUrl: state.user.avatarUrlMedium,
                            displayName: state.user.displayName,
                          ),
                        );
                      },
                    )
                  ],
                ),
              );
            },
            openBuilder: (context, action) {
              return SearchScreen(closeCallBack: action);
            },
            // this was the room selected by user
            // this can be null incase user didn't
            // select any user.
            onClosed: selectedRoom?.call,
          ),
        ),
      ),
    );
  }
}
