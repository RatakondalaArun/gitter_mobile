import 'package:flutter/material.dart';
import 'package:gitterapi/models.dart';

import '../../../widgets/widgets.dart';
import '../../screens.dart';

class HomeTile extends StatelessWidget {
  final Room room;

  const HomeTile({
    Key key,
    this.room,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Navigator.of(context).pushNamed(
        ChatScreen.routeName,
        arguments: {'room': room},
      ),
      leading: SizedBox(
        height: 40,
        width: 40,
        child: CircularImage(
          displayName: room.name,
          imageUrl: room.avatarUrl,
        ),
      ),
      title: Text('${room.name}'),
      // Shows unread items count only
      // if the count is not equal 0
      trailing: _shouldShowUnread(room.unreadItems)
          ? Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.green.shade700,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Text(
                _formatUnreadCount(room.unreadItems),
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                ),
              ),
            )
          : null,
      subtitle: Wrap(
        spacing: 2,
        runSpacing: 1,
        children: _renderedTags(),
      ),
    );
  }

  bool _shouldShowUnread(int count) {
    return !(count == null || count == 0);
  }

  // Formats unread items count '99+'
  // if it is more than 99
  String _formatUnreadCount(int count) {
    return count > 99 ? '99+' : '$count';
  }

  List<Widget> _renderedTags() {
    if (room.tags == null) return <Widget>[];
    return room.tags.map<Widget>((tag) => _TagBadge(tag: tag)).toList();
  }
}

class _TagBadge extends StatelessWidget {
  final String tag;

  const _TagBadge({
    Key key,
    @required this.tag,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 1,
      ),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        tag,
        style: TextStyle(fontSize: 12),
      ),
    );
  }
}
