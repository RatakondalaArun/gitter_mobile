import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart' show Html;
import 'package:gitterapi/models.dart';

import 'components/chat_screen_app_bar.dart';

class ChatScreen extends StatelessWidget {
  static const routeName = '/ChatScreen';
  final Room room;

  const ChatScreen({
    Key key,
    this.room,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatScreenAppBar(roomName: room.name),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            bottom: 75,
            left: 0,
            right: 0,
            child: ListView.builder(
              itemCount: mockChatList.length,
              itemBuilder: (context, index) {
                return _ChatItem(
                  data: mockChatList[index]['html'],
                );
              },
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _ChatInput(),
          ),
        ],
      ),
    );
  }
}

class _ChatInput extends StatelessWidget {
  final TextEditingController controller;

  const _ChatInput({
    Key key,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(5),
            width: MediaQuery.of(context).size.width - 80,
            child: TextField(
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 5,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 2,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(50),
            ),
            child: IconButton(
              tooltip: 'Send',
              splashRadius: 30,
              icon: Icon(
                Icons.send,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}

class _ChatItem extends StatelessWidget {
  final String data;

  const _ChatItem({
    Key key,
    @required this.data,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(width: 50),
              SizedBox(
                width: MediaQuery.of(context).size.width - 50,
                child: Html(
                  data: data ?? '',
                  onLinkTap: (url) {
                    print(url);
                  },
                ),
              )
            ],
          ),
          Container(
            height: 10,
            color: Colors.green,
          ),
        ],
      ),
    );
  }
}

final mockChatData =
    "<p><a href=\"https://stackoverflow.com/questions/65343104/how-can-i-compound-postuid-and-userid/65343586?noredirect=1#comment115529032_65343586\" rel=\"nofollow noopener noreferrer\" target=\"_blank\" class=\"link \">https://stackoverflow.com/questions/65343104/how-can-i-compound-postuid-and-userid/65343586?noredirect=1#comment115529032_65343586</a></p><p>still open</p>";

final mockChatList = [
  {
    "id": "5fdc2d25e7f693041f185dd9",
    "text":
        "i guess i see \"dart global\" stuff as distinct from \"flutter-specific\" stuff",
    "html":
        "i guess i see &quot;dart global&quot; stuff as distinct from &quot;flutter-specific&quot; stuff",
    "sent": "2020-12-18T04:16:37.043Z",
    "unread": false,
    "readBy": 21,
    "urls": [],
    "mentions": [],
    "issues": [],
    "meta": [],
    "v": 1,
    "fromUser": {
      "id": "57ec043f40f3a6eec067ddc4",
      "username": "bradyt",
      "displayName": "Brady Trainor",
      "url": "/bradyt",
      "avatarUrl": "https://avatars-02.gitter.im/gh/uv/4/bradyt",
      "avatarUrlSmall":
          "https://avatars0.githubusercontent.com/u/6107051?v=4&s=60",
      "avatarUrlMedium":
          "https://avatars0.githubusercontent.com/u/6107051?v=4&s=128",
      "v": 41,
      "gv": "4"
    }
  },
  {
    "id": "5fdc2d2dacd1e516f89c8f9c",
    "text": "for me",
    "html": "for me",
    "sent": "2020-12-18T04:16:45.089Z",
    "unread": false,
    "readBy": 21,
    "urls": [],
    "mentions": [],
    "issues": [],
    "meta": [],
    "v": 1,
    "fromUser": {
      "id": "57ec043f40f3a6eec067ddc4",
      "username": "bradyt",
      "displayName": "Brady Trainor",
      "url": "/bradyt",
      "avatarUrl": "https://avatars-02.gitter.im/gh/uv/4/bradyt",
      "avatarUrlSmall":
          "https://avatars0.githubusercontent.com/u/6107051?v=4&s=60",
      "avatarUrlMedium":
          "https://avatars0.githubusercontent.com/u/6107051?v=4&s=128",
      "v": 41,
      "gv": "4"
    }
  },
  {
    "id": "5fdc2d3c97312f4b6bd58855",
    "text": "i don't know what flutter thing i need to be global",
    "html": "i don&#39;t know what flutter thing i need to be global",
    "sent": "2020-12-18T04:17:00.716Z",
    "unread": false,
    "readBy": 21,
    "urls": [],
    "mentions": [],
    "issues": [],
    "meta": [],
    "v": 1,
    "fromUser": {
      "id": "57ec043f40f3a6eec067ddc4",
      "username": "bradyt",
      "displayName": "Brady Trainor",
      "url": "/bradyt",
      "avatarUrl": "https://avatars-02.gitter.im/gh/uv/4/bradyt",
      "avatarUrlSmall":
          "https://avatars0.githubusercontent.com/u/6107051?v=4&s=60",
      "avatarUrlMedium":
          "https://avatars0.githubusercontent.com/u/6107051?v=4&s=128",
      "v": 41,
      "gv": "4"
    }
  },
  {
    "id": "5fdc2d41c746c6431cbfe663",
    "text":
        "now the question is, will they converge, will one deprecate, will they always be different.",
    "html":
        "now the question is, will they converge, will one deprecate, will they always be different.",
    "sent": "2020-12-18T04:17:05.593Z",
    "unread": false,
    "readBy": 21,
    "urls": [],
    "mentions": [],
    "issues": [],
    "meta": [],
    "v": 1,
    "fromUser": {
      "id": "5838d1f4d73408ce4f38aaac",
      "username": "RandalSchwartz",
      "displayName": "Randal L. Schwartz",
      "url": "/RandalSchwartz",
      "avatarUrl": "https://avatars-04.gitter.im/gh/uv/4/RandalSchwartz",
      "avatarUrlSmall":
          "https://avatars2.githubusercontent.com/u/6342?v=4&s=60",
      "avatarUrlMedium":
          "https://avatars2.githubusercontent.com/u/6342?v=4&s=128",
      "v": 12,
      "gv": "4"
    }
  },
  {
    "id": "5fdc2d432084ee4b7859b91b",
    "text": "Yeah",
    "html": "Yeah",
    "sent": "2020-12-18T04:17:07.684Z",
    "unread": false,
    "readBy": 21,
    "urls": [],
    "mentions": [],
    "issues": [],
    "meta": [],
    "v": 1,
    "fromUser": {
      "id": "5838d1f4d73408ce4f38aaac",
      "username": "RandalSchwartz",
      "displayName": "Randal L. Schwartz",
      "url": "/RandalSchwartz",
      "avatarUrl": "https://avatars-04.gitter.im/gh/uv/4/RandalSchwartz",
      "avatarUrlSmall":
          "https://avatars2.githubusercontent.com/u/6342?v=4&s=60",
      "avatarUrlMedium":
          "https://avatars2.githubusercontent.com/u/6342?v=4&s=128",
      "v": 12,
      "gv": "4"
    }
  },
  {
    "id": "5fdc2d4f2084ee4b7859b95a",
    "text":
        "it might be that flutter pub will just have flutter-specific stuff",
    "html":
        "it might be that flutter pub will just have flutter-specific stuff",
    "sent": "2020-12-18T04:17:19.415Z",
    "unread": false,
    "readBy": 21,
    "urls": [],
    "mentions": [],
    "issues": [],
    "meta": [],
    "v": 1,
    "fromUser": {
      "id": "57ec043f40f3a6eec067ddc4",
      "username": "bradyt",
      "displayName": "Brady Trainor",
      "url": "/bradyt",
      "avatarUrl": "https://avatars-02.gitter.im/gh/uv/4/bradyt",
      "avatarUrlSmall":
          "https://avatars0.githubusercontent.com/u/6107051?v=4&s=60",
      "avatarUrlMedium":
          "https://avatars0.githubusercontent.com/u/6107051?v=4&s=128",
      "v": 41,
      "gv": "4"
    }
  },
  {
    "id": "5fdc2d57ce40bd3cdbe96a04",
    "text": "i didn't fully compare",
    "html": "i didn&#39;t fully compare",
    "sent": "2020-12-18T04:17:27.100Z",
    "unread": false,
    "readBy": 22,
    "urls": [],
    "mentions": [],
    "issues": [],
    "meta": [],
    "v": 1,
    "fromUser": {
      "id": "57ec043f40f3a6eec067ddc4",
      "username": "bradyt",
      "displayName": "Brady Trainor",
      "url": "/bradyt",
      "avatarUrl": "https://avatars-02.gitter.im/gh/uv/4/bradyt",
      "avatarUrlSmall":
          "https://avatars0.githubusercontent.com/u/6107051?v=4&s=60",
      "avatarUrlMedium":
          "https://avatars0.githubusercontent.com/u/6107051?v=4&s=128",
      "v": 41,
      "gv": "4"
    }
  },
  {
    "id": "5fdc2d74e7f693041f185e65",
    "text":
        "and sometimes flutter team wants things to be easier for flutter, than is demanded of dart",
    "html":
        "and sometimes flutter team wants things to be easier for flutter, than is demanded of dart",
    "sent": "2020-12-18T04:17:56.501Z",
    "unread": false,
    "readBy": 22,
    "urls": [],
    "mentions": [],
    "issues": [],
    "meta": [],
    "v": 1,
    "fromUser": {
      "id": "57ec043f40f3a6eec067ddc4",
      "username": "bradyt",
      "displayName": "Brady Trainor",
      "url": "/bradyt",
      "avatarUrl": "https://avatars-02.gitter.im/gh/uv/4/bradyt",
      "avatarUrlSmall":
          "https://avatars0.githubusercontent.com/u/6107051?v=4&s=60",
      "avatarUrlMedium":
          "https://avatars0.githubusercontent.com/u/6107051?v=4&s=128",
      "v": 41,
      "gv": "4"
    }
  },
  {
    "id": "5fdc2d7eac9d8e7463b8278f",
    "text":
        "I wonder if I install a few things in dart pub global and remove from flutter pub global if I can find them again. :)",
    "html":
        "I wonder if I install a few things in dart pub global and remove from flutter pub global if I can find them again. :)",
    "sent": "2020-12-18T04:18:06.892Z",
    "unread": false,
    "readBy": 22,
    "urls": [],
    "mentions": [],
    "issues": [],
    "meta": [],
    "v": 1,
    "fromUser": {
      "id": "5838d1f4d73408ce4f38aaac",
      "username": "RandalSchwartz",
      "displayName": "Randal L. Schwartz",
      "url": "/RandalSchwartz",
      "avatarUrl": "https://avatars-04.gitter.im/gh/uv/4/RandalSchwartz",
      "avatarUrlSmall":
          "https://avatars2.githubusercontent.com/u/6342?v=4&s=60",
      "avatarUrlMedium":
          "https://avatars2.githubusercontent.com/u/6342?v=4&s=128",
      "v": 12,
      "gv": "4"
    }
  },
  {
    "id": "5fdc2d808bb73474693d5a50",
    "text": "but yeah might propogate backwards",
    "html": "but yeah might propogate backwards",
    "sent": "2020-12-18T04:18:08.219Z",
    "unread": false,
    "readBy": 22,
    "urls": [],
    "mentions": [],
    "issues": [],
    "meta": [],
    "v": 1,
    "fromUser": {
      "id": "57ec043f40f3a6eec067ddc4",
      "username": "bradyt",
      "displayName": "Brady Trainor",
      "url": "/bradyt",
      "avatarUrl": "https://avatars-02.gitter.im/gh/uv/4/bradyt",
      "avatarUrlSmall":
          "https://avatars0.githubusercontent.com/u/6107051?v=4&s=60",
      "avatarUrlMedium":
          "https://avatars0.githubusercontent.com/u/6107051?v=4&s=128",
      "v": 41,
      "gv": "4"
    }
  },
  {
    "id": "5fdc2d8baa6bb528c3585cba",
    "text": "might have to restart terminal `;)`",
    "html": "might have to restart terminal <code>;)</code>",
    "sent": "2020-12-18T04:18:19.832Z",
    "unread": false,
    "readBy": 22,
    "urls": [],
    "mentions": [],
    "issues": [],
    "meta": [],
    "v": 1,
    "fromUser": {
      "id": "57ec043f40f3a6eec067ddc4",
      "username": "bradyt",
      "displayName": "Brady Trainor",
      "url": "/bradyt",
      "avatarUrl": "https://avatars-02.gitter.im/gh/uv/4/bradyt",
      "avatarUrlSmall":
          "https://avatars0.githubusercontent.com/u/6107051?v=4&s=60",
      "avatarUrlMedium":
          "https://avatars0.githubusercontent.com/u/6107051?v=4&s=128",
      "v": 41,
      "gv": "4"
    }
  },
  {
    "id": "5fdc2d9397312f4b6bd5890d",
    "text": "find is my friend. :)",
    "html": "find is my friend. :)",
    "sent": "2020-12-18T04:18:27.314Z",
    "unread": false,
    "readBy": 22,
    "urls": [],
    "mentions": [],
    "issues": [],
    "meta": [],
    "v": 1,
    "fromUser": {
      "id": "5838d1f4d73408ce4f38aaac",
      "username": "RandalSchwartz",
      "displayName": "Randal L. Schwartz",
      "url": "/RandalSchwartz",
      "avatarUrl": "https://avatars-04.gitter.im/gh/uv/4/RandalSchwartz",
      "avatarUrlSmall":
          "https://avatars2.githubusercontent.com/u/6342?v=4&s=60",
      "avatarUrlMedium":
          "https://avatars2.githubusercontent.com/u/6342?v=4&s=128",
      "v": 12,
      "gv": "4"
    }
  },
  {
    "id": "5fdc2da3ce40bd3cdbe96a78",
    "text": "or source the ~/.zshrc again",
    "html": "or source the ~/.zshrc again",
    "sent": "2020-12-18T04:18:43.408Z",
    "unread": false,
    "readBy": 23,
    "urls": [],
    "mentions": [],
    "issues": [],
    "meta": [],
    "v": 1,
    "fromUser": {
      "id": "57ec043f40f3a6eec067ddc4",
      "username": "bradyt",
      "displayName": "Brady Trainor",
      "url": "/bradyt",
      "avatarUrl": "https://avatars-02.gitter.im/gh/uv/4/bradyt",
      "avatarUrlSmall":
          "https://avatars0.githubusercontent.com/u/6107051?v=4&s=60",
      "avatarUrlMedium":
          "https://avatars0.githubusercontent.com/u/6107051?v=4&s=128",
      "v": 41,
      "gv": "4"
    }
  },
  {
    "id": "5fdc2e27ac9d8e7463b8292d",
    "text": "well, I know the dir I have is where flutter pub global puts it",
    "html": "well, I know the dir I have is where flutter pub global puts it",
    "sent": "2020-12-18T04:20:55.147Z",
    "unread": false,
    "readBy": 23,
    "urls": [],
    "mentions": [],
    "issues": [],
    "meta": [],
    "v": 1,
    "fromUser": {
      "id": "5838d1f4d73408ce4f38aaac",
      "username": "RandalSchwartz",
      "displayName": "Randal L. Schwartz",
      "url": "/RandalSchwartz",
      "avatarUrl": "https://avatars-04.gitter.im/gh/uv/4/RandalSchwartz",
      "avatarUrlSmall":
          "https://avatars2.githubusercontent.com/u/6342?v=4&s=60",
      "avatarUrlMedium":
          "https://avatars2.githubusercontent.com/u/6342?v=4&s=128",
      "v": 12,
      "gv": "4"
    }
  },
  {
    "id": "5fdc2e2f8bb73474693d5bdc",
    "text": "not sure of dart pub global",
    "html": "not sure of dart pub global",
    "sent": "2020-12-18T04:21:03.543Z",
    "unread": false,
    "readBy": 23,
    "urls": [],
    "mentions": [],
    "issues": [],
    "meta": [],
    "v": 1,
    "fromUser": {
      "id": "5838d1f4d73408ce4f38aaac",
      "username": "RandalSchwartz",
      "displayName": "Randal L. Schwartz",
      "url": "/RandalSchwartz",
      "avatarUrl": "https://avatars-04.gitter.im/gh/uv/4/RandalSchwartz",
      "avatarUrlSmall":
          "https://avatars2.githubusercontent.com/u/6342?v=4&s=60",
      "avatarUrlMedium":
          "https://avatars2.githubusercontent.com/u/6342?v=4&s=128",
      "v": 12,
      "gv": "4"
    }
  },
  {
    "id": "5fdc2fadaa6bb528c358616d",
    "text": "ahh.  dart pub global puts it in ~/.pub-cache/bin",
    "html": "ahh.  dart pub global puts it in ~/.pub-cache/bin",
    "sent": "2020-12-18T04:27:25.809Z",
    "unread": false,
    "readBy": 23,
    "urls": [],
    "mentions": [],
    "issues": [],
    "meta": [],
    "v": 1,
    "fromUser": {
      "id": "5838d1f4d73408ce4f38aaac",
      "username": "RandalSchwartz",
      "displayName": "Randal L. Schwartz",
      "url": "/RandalSchwartz",
      "avatarUrl": "https://avatars-04.gitter.im/gh/uv/4/RandalSchwartz",
      "avatarUrlSmall":
          "https://avatars2.githubusercontent.com/u/6342?v=4&s=60",
      "avatarUrlMedium":
          "https://avatars2.githubusercontent.com/u/6342?v=4&s=128",
      "v": 12,
      "gv": "4"
    }
  },
  {
    "id": "5fdc2fb2c746c6431cbfebd3",
    "text": "which is not now in my path",
    "html": "which is not now in my path",
    "sent": "2020-12-18T04:27:30.962Z",
    "unread": false,
    "readBy": 23,
    "urls": [],
    "mentions": [],
    "issues": [],
    "meta": [],
    "v": 1,
    "fromUser": {
      "id": "5838d1f4d73408ce4f38aaac",
      "username": "RandalSchwartz",
      "displayName": "Randal L. Schwartz",
      "url": "/RandalSchwartz",
      "avatarUrl": "https://avatars-04.gitter.im/gh/uv/4/RandalSchwartz",
      "avatarUrlSmall":
          "https://avatars2.githubusercontent.com/u/6342?v=4&s=60",
      "avatarUrlMedium":
          "https://avatars2.githubusercontent.com/u/6342?v=4&s=128",
      "v": 12,
      "gv": "4"
    }
  },
  {
    "id": "5fdc2fb58bb73474693d60bc",
    "text": "time for an edit",
    "html": "time for an edit",
    "sent": "2020-12-18T04:27:33.658Z",
    "unread": false,
    "readBy": 23,
    "urls": [],
    "mentions": [],
    "issues": [],
    "meta": [],
    "v": 1,
    "fromUser": {
      "id": "5838d1f4d73408ce4f38aaac",
      "username": "RandalSchwartz",
      "displayName": "Randal L. Schwartz",
      "url": "/RandalSchwartz",
      "avatarUrl": "https://avatars-04.gitter.im/gh/uv/4/RandalSchwartz",
      "avatarUrlSmall":
          "https://avatars2.githubusercontent.com/u/6342?v=4&s=60",
      "avatarUrlMedium":
          "https://avatars2.githubusercontent.com/u/6342?v=4&s=128",
      "v": 12,
      "gv": "4"
    }
  },
  {
    "id": "5fdc303522f12e449bf936bc",
    "text":
        "> export PRE_PATH=~/bin:/opt/git/bin:~/MIRROR/rakudo-GIT/install/bin:~/MIRROR/rakudo-GIT/install/share/perl6/site/bin:/opt/perl/bin:/opt/local/bin:/opt/local/sbin:~/Flutter/.pub-cache/bin:~/Flutter/bin:~/.pub-cache/bin:~/MIRROR/brew-GIT/bin",
    "html":
        "<blockquote>\nexport PRE_PATH=~/bin:/opt/git/bin:~/MIRROR/rakudo-GIT/install/bin:~/MIRROR/rakudo-GIT/install/share/perl6/site/bin:/opt/perl/bin:/opt/local/bin:/opt/local/sbin:~/Flutter/.pub-cache/bin:~/Flutter/bin:~/.pub-cache/bin:~/MIRROR/brew-GIT/bin</blockquote>\n",
    "sent": "2020-12-18T04:29:41.296Z",
    "unread": false,
    "readBy": 23,
    "urls": [],
    "mentions": [],
    "issues": [],
    "meta": [],
    "v": 1,
    "fromUser": {
      "id": "5838d1f4d73408ce4f38aaac",
      "username": "RandalSchwartz",
      "displayName": "Randal L. Schwartz",
      "url": "/RandalSchwartz",
      "avatarUrl": "https://avatars-04.gitter.im/gh/uv/4/RandalSchwartz",
      "avatarUrlSmall":
          "https://avatars2.githubusercontent.com/u/6342?v=4&s=60",
      "avatarUrlMedium":
          "https://avatars2.githubusercontent.com/u/6342?v=4&s=128",
      "v": 12,
      "gv": "4"
    }
  },
  {
    "id": "5fdc3054ac9d8e7463b82dbd",
    "text": "“where!” “Where is that command!\"",
    "html": "“where!” “Where is that command!&quot;",
    "sent": "2020-12-18T04:30:12.697Z",
    "unread": false,
    "readBy": 23,
    "urls": [],
    "mentions": [],
    "issues": [],
    "meta": [],
    "v": 1,
    "fromUser": {
      "id": "5838d1f4d73408ce4f38aaac",
      "username": "RandalSchwartz",
      "displayName": "Randal L. Schwartz",
      "url": "/RandalSchwartz",
      "avatarUrl": "https://avatars-04.gitter.im/gh/uv/4/RandalSchwartz",
      "avatarUrlSmall":
          "https://avatars2.githubusercontent.com/u/6342?v=4&s=60",
      "avatarUrlMedium":
          "https://avatars2.githubusercontent.com/u/6342?v=4&s=128",
      "v": 12,
      "gv": "4"
    }
  },
  {
    "id": "5fdc31474eba353cdfe3e5bd",
    "text":
        "> Flutter note: If you’re using the Flutter SDK, don’t use the pub command directly. Instead use the flutter pub command, as described in Using packages on the Flutter website.",
    "html":
        "<blockquote>\nFlutter note: If you’re using the Flutter SDK, don’t use the pub command directly. Instead use the flutter pub command, as described in Using packages on the Flutter website.</blockquote>\n",
    "sent": "2020-12-18T04:34:15.554Z",
    "unread": false,
    "readBy": 22,
    "urls": [],
    "mentions": [],
    "issues": [],
    "meta": [],
    "v": 1,
    "fromUser": {
      "id": "5838d1f4d73408ce4f38aaac",
      "username": "RandalSchwartz",
      "displayName": "Randal L. Schwartz",
      "url": "/RandalSchwartz",
      "avatarUrl": "https://avatars-04.gitter.im/gh/uv/4/RandalSchwartz",
      "avatarUrlSmall":
          "https://avatars2.githubusercontent.com/u/6342?v=4&s=60",
      "avatarUrlMedium":
          "https://avatars2.githubusercontent.com/u/6342?v=4&s=128",
      "v": 12,
      "gv": "4"
    }
  },
  {
    "id": "5fdc3152ce40bd3cdbe971ab",
    "text": "https://dart.dev/tools/pub/cmd",
    "html":
        "<a href=\"https://dart.dev/tools/pub/cmd\" rel=\"nofollow noopener noreferrer\" target=\"_blank\" class=\"link \">https://dart.dev/tools/pub/cmd</a>",
    "sent": "2020-12-18T04:34:26.904Z",
    "unread": false,
    "readBy": 23,
    "urls": [
      {"url": "https://dart.dev/tools/pub/cmd"}
    ],
    "mentions": [],
    "issues": [],
    "meta": [],
    "v": 1,
    "fromUser": {
      "id": "5838d1f4d73408ce4f38aaac",
      "username": "RandalSchwartz",
      "displayName": "Randal L. Schwartz",
      "url": "/RandalSchwartz",
      "avatarUrl": "https://avatars-04.gitter.im/gh/uv/4/RandalSchwartz",
      "avatarUrlSmall":
          "https://avatars2.githubusercontent.com/u/6342?v=4&s=60",
      "avatarUrlMedium":
          "https://avatars2.githubusercontent.com/u/6342?v=4&s=128",
      "v": 12,
      "gv": "4"
    }
  },
  {
    "id": "5fdc316d93af5216fc4abf8d",
    "text": "often i'm doing dart things that aren't flutter-specific",
    "html": "often i&#39;m doing dart things that aren&#39;t flutter-specific",
    "sent": "2020-12-18T04:34:53.112Z",
    "unread": false,
    "readBy": 23,
    "urls": [],
    "mentions": [],
    "issues": [],
    "meta": [],
    "v": 1,
    "fromUser": {
      "id": "57ec043f40f3a6eec067ddc4",
      "username": "bradyt",
      "displayName": "Brady Trainor",
      "url": "/bradyt",
      "avatarUrl": "https://avatars-02.gitter.im/gh/uv/4/bradyt",
      "avatarUrlSmall":
          "https://avatars0.githubusercontent.com/u/6107051?v=4&s=60",
      "avatarUrlMedium":
          "https://avatars0.githubusercontent.com/u/6107051?v=4&s=128",
      "v": 41,
      "gv": "4"
    }
  },
  {
    "id": "5fdc3239de608143152b3abe",
    "text":
        "oooh… good article on the new spread syntax and other collections: https://medium.com/dartlang/exploring-collections-in-dart-f66b6a02d0b1",
    "html":
        "oooh… good article on the new spread syntax and other collections: <a href=\"https://medium.com/dartlang/exploring-collections-in-dart-f66b6a02d0b1\" rel=\"nofollow noopener noreferrer\" target=\"_blank\" class=\"link \">https://medium.com/dartlang/exploring-collections-in-dart-f66b6a02d0b1</a>",
    "sent": "2020-12-18T04:38:17.211Z",
    "unread": false,
    "readBy": 23,
    "urls": [
      {
        "url":
            "https://medium.com/dartlang/exploring-collections-in-dart-f66b6a02d0b1"
      }
    ],
    "mentions": [],
    "issues": [],
    "meta": [],
    "v": 1,
    "fromUser": {
      "id": "5838d1f4d73408ce4f38aaac",
      "username": "RandalSchwartz",
      "displayName": "Randal L. Schwartz",
      "url": "/RandalSchwartz",
      "avatarUrl": "https://avatars-04.gitter.im/gh/uv/4/RandalSchwartz",
      "avatarUrlSmall":
          "https://avatars2.githubusercontent.com/u/6342?v=4&s=60",
      "avatarUrlMedium":
          "https://avatars2.githubusercontent.com/u/6342?v=4&s=128",
      "v": 12,
      "gv": "4"
    }
  },
  {
    "id": "5fdc32f62084ee4b7859c490",
    "text":
        "Hi,\nAnyone that has used flutter_local_notifications package here?",
    "html":
        "Hi,<br>Anyone that has used flutter_local_notifications package here?",
    "sent": "2020-12-18T04:41:26.683Z",
    "unread": false,
    "readBy": 23,
    "urls": [],
    "mentions": [],
    "issues": [],
    "meta": [],
    "v": 1,
    "fromUser": {
      "id": "592fb657d73408ce4f63cfa2",
      "username": "hborole",
      "displayName": "hborole",
      "url": "/hborole",
      "avatarUrl": "https://avatars-05.gitter.im/gh/uv/4/hborole",
      "avatarUrlSmall":
          "https://avatars2.githubusercontent.com/u/29115370?v=4&s=60",
      "avatarUrlMedium":
          "https://avatars2.githubusercontent.com/u/29115370?v=4&s=128",
      "v": 9,
      "gv": "4"
    }
  },
  {
    "id": "5fdc33502084ee4b7859c549",
    "text": "no, but we’re pretty good at understanding the docs. :)",
    "html": "no, but we’re pretty good at understanding the docs. :)",
    "sent": "2020-12-18T04:42:56.285Z",
    "unread": false,
    "readBy": 22,
    "urls": [],
    "mentions": [],
    "issues": [],
    "meta": [],
    "v": 1,
    "fromUser": {
      "id": "5838d1f4d73408ce4f38aaac",
      "username": "RandalSchwartz",
      "displayName": "Randal L. Schwartz",
      "url": "/RandalSchwartz",
      "avatarUrl": "https://avatars-04.gitter.im/gh/uv/4/RandalSchwartz",
      "avatarUrlSmall":
          "https://avatars2.githubusercontent.com/u/6342?v=4&s=60",
      "avatarUrlMedium":
          "https://avatars2.githubusercontent.com/u/6342?v=4&s=128",
      "v": 12,
      "gv": "4"
    }
  },
  {
    "id": "5fdc33f5aa6bb528c3586984",
    "text":
        "> iOS pending notifications limit: There is a limit imposed by iOS where it will only keep 64 notifications that will fire the soonest.",
    "html":
        "<blockquote>\niOS pending notifications limit: There is a limit imposed by iOS where it will only keep 64 notifications that will fire the soonest.</blockquote>\n",
    "sent": "2020-12-18T04:45:41.372Z",
    "unread": false,
    "readBy": 22,
    "urls": [],
    "mentions": [],
    "issues": [],
    "meta": [],
    "v": 1,
    "fromUser": {
      "id": "5838d1f4d73408ce4f38aaac",
      "username": "RandalSchwartz",
      "displayName": "Randal L. Schwartz",
      "url": "/RandalSchwartz",
      "avatarUrl": "https://avatars-04.gitter.im/gh/uv/4/RandalSchwartz",
      "avatarUrlSmall":
          "https://avatars2.githubusercontent.com/u/6342?v=4&s=60",
      "avatarUrlMedium":
          "https://avatars2.githubusercontent.com/u/6342?v=4&s=128",
      "v": 12,
      "gv": "4"
    }
  },
  {
    "id": "5fdc33ffde608143152b3f28",
    "text": "I’d hate to dismiss 64 notifies. :)",
    "html": "I’d hate to dismiss 64 notifies. :)",
    "sent": "2020-12-18T04:45:51.883Z",
    "unread": false,
    "readBy": 22,
    "urls": [],
    "mentions": [],
    "issues": [],
    "meta": [],
    "v": 1,
    "fromUser": {
      "id": "5838d1f4d73408ce4f38aaac",
      "username": "RandalSchwartz",
      "displayName": "Randal L. Schwartz",
      "url": "/RandalSchwartz",
      "avatarUrl": "https://avatars-04.gitter.im/gh/uv/4/RandalSchwartz",
      "avatarUrlSmall":
          "https://avatars2.githubusercontent.com/u/6342?v=4&s=60",
      "avatarUrlMedium":
          "https://avatars2.githubusercontent.com/u/6342?v=4&s=128",
      "v": 12,
      "gv": "4"
    }
  },
  {
    "id": "5fdc346e8bb73474693d6b64",
    "text": "wow…. this package looks slick",
    "html": "wow…. this package looks slick",
    "sent": "2020-12-18T04:47:42.287Z",
    "unread": false,
    "readBy": 22,
    "urls": [],
    "mentions": [],
    "issues": [],
    "meta": [],
    "v": 1,
    "fromUser": {
      "id": "5838d1f4d73408ce4f38aaac",
      "username": "RandalSchwartz",
      "displayName": "Randal L. Schwartz",
      "url": "/RandalSchwartz",
      "avatarUrl": "https://avatars-04.gitter.im/gh/uv/4/RandalSchwartz",
      "avatarUrlSmall":
          "https://avatars2.githubusercontent.com/u/6342?v=4&s=60",
      "avatarUrlMedium":
          "https://avatars2.githubusercontent.com/u/6342?v=4&s=128",
      "v": 12,
      "gv": "4"
    }
  },
  {
    "id": "5fdc34768bb73474693d6b81",
    "text": "@hborole what is your question?",
    "html":
        "<span data-link-type=\"mention\" data-screen-name=\"hborole\" class=\"mention\">@hborole</span> what is your question?",
    "sent": "2020-12-18T04:47:50.087Z",
    "unread": false,
    "readBy": 22,
    "urls": [],
    "mentions": [
      {
        "screenName": "hborole",
        "userId": "592fb657d73408ce4f63cfa2",
        "userIds": []
      }
    ],
    "issues": [],
    "meta": [],
    "v": 1,
    "fromUser": {
      "id": "5838d1f4d73408ce4f38aaac",
      "username": "RandalSchwartz",
      "displayName": "Randal L. Schwartz",
      "url": "/RandalSchwartz",
      "avatarUrl": "https://avatars-04.gitter.im/gh/uv/4/RandalSchwartz",
      "avatarUrlSmall":
          "https://avatars2.githubusercontent.com/u/6342?v=4&s=60",
      "avatarUrlMedium":
          "https://avatars2.githubusercontent.com/u/6342?v=4&s=128",
      "v": 12,
      "gv": "4"
    }
  },
  {
    "id": "5fdc36fa8bb73474693d71a9",
    "text": "Perhaps none.  {sigh}",
    "html": "Perhaps none.  {sigh}",
    "sent": "2020-12-18T04:58:34.739Z",
    "unread": false,
    "readBy": 22,
    "urls": [],
    "mentions": [],
    "issues": [],
    "meta": [],
    "v": 1,
    "fromUser": {
      "id": "5838d1f4d73408ce4f38aaac",
      "username": "RandalSchwartz",
      "displayName": "Randal L. Schwartz",
      "url": "/RandalSchwartz",
      "avatarUrl": "https://avatars-04.gitter.im/gh/uv/4/RandalSchwartz",
      "avatarUrlSmall":
          "https://avatars2.githubusercontent.com/u/6342?v=4&s=60",
      "avatarUrlMedium":
          "https://avatars2.githubusercontent.com/u/6342?v=4&s=128",
      "v": 12,
      "gv": "4"
    }
  },
  {
    "id": "5fdc3728dbb17f28c585a774",
    "text": "i guess you answered it",
    "html": "i guess you answered it",
    "sent": "2020-12-18T04:59:20.327Z",
    "unread": false,
    "readBy": 23,
    "urls": [],
    "mentions": [],
    "issues": [],
    "meta": [],
    "v": 1,
    "fromUser": {
      "id": "57ec043f40f3a6eec067ddc4",
      "username": "bradyt",
      "displayName": "Brady Trainor",
      "url": "/bradyt",
      "avatarUrl": "https://avatars-02.gitter.im/gh/uv/4/bradyt",
      "avatarUrlSmall":
          "https://avatars0.githubusercontent.com/u/6107051?v=4&s=60",
      "avatarUrlMedium":
          "https://avatars0.githubusercontent.com/u/6107051?v=4&s=128",
      "v": 41,
      "gv": "4"
    }
  },
  {
    "id": "5fdc38ac4eba353cdfe3f639",
    "text": "Heh",
    "html": "Heh",
    "sent": "2020-12-18T05:05:48.470Z",
    "unread": false,
    "readBy": 23,
    "urls": [],
    "mentions": [],
    "issues": [],
    "meta": [],
    "v": 1,
    "fromUser": {
      "id": "5838d1f4d73408ce4f38aaac",
      "username": "RandalSchwartz",
      "displayName": "Randal L. Schwartz",
      "url": "/RandalSchwartz",
      "avatarUrl": "https://avatars-04.gitter.im/gh/uv/4/RandalSchwartz",
      "avatarUrlSmall":
          "https://avatars2.githubusercontent.com/u/6342?v=4&s=60",
      "avatarUrlMedium":
          "https://avatars2.githubusercontent.com/u/6342?v=4&s=128",
      "v": 12,
      "gv": "4"
    }
  },
  {
    "id": "5fdc3927e7f693041f187563",
    "text":
        "hmm.  should be “him/he-man/his-majesty”, that way we cover direct, indirect, and group addressing.",
    "html":
        "hmm.  should be “him/he-man/his-majesty”, that way we cover direct, indirect, and group addressing.",
    "sent": "2020-12-18T05:07:51.493Z",
    "unread": false,
    "readBy": 23,
    "urls": [],
    "mentions": [],
    "issues": [],
    "meta": [],
    "v": 1,
    "fromUser": {
      "id": "5838d1f4d73408ce4f38aaac",
      "username": "RandalSchwartz",
      "displayName": "Randal L. Schwartz",
      "url": "/RandalSchwartz",
      "avatarUrl": "https://avatars-04.gitter.im/gh/uv/4/RandalSchwartz",
      "avatarUrlSmall":
          "https://avatars2.githubusercontent.com/u/6342?v=4&s=60",
      "avatarUrlMedium":
          "https://avatars2.githubusercontent.com/u/6342?v=4&s=128",
      "v": 12,
      "gv": "4"
    }
  },
  {
    "id": "5fdc402997312f4b6bd5af69",
    "text":
        "Why am I getting this error \n```\nI/flutter ( 4815): [MethodChannelFilePicker] Unsupported operation. Method not found. The exception thrown was: MissingPluginException(No implementation found for method any on channel miguelruivo.flutter.plugins.filepicker)\nI/flutter ( 4815): MissingPluginException(No implementation found for method any on channel miguelruivo.flutter.plugins.filepicker)\n```",
    "html":
        "Why am I getting this error <pre><code>I/flutter ( <span class=\"number\">4815</span>): [MethodChannelFilePicker] Unsupported operation. Method <span class=\"keyword\">not</span> found. The exception thrown was: MissingPluginException(No implementation found <span class=\"keyword\">for</span> method any <span class=\"function_start\"><span class=\"keyword\">on</span></span> channel miguelruivo.flutter.plugins.filepicker)\nI/flutter ( <span class=\"number\">4815</span>): MissingPluginException(No implementation found <span class=\"keyword\">for</span> method any <span class=\"function_start\"><span class=\"keyword\">on</span></span> channel miguelruivo.flutter.plugins.filepicker)</code></pre>",
    "sent": "2020-12-18T05:37:45.836Z",
    "editedAt": "2020-12-18T05:38:12.118Z",
    "unread": false,
    "readBy": 22,
    "urls": [],
    "mentions": [],
    "issues": [],
    "meta": [],
    "v": 3,
    "fromUser": {
      "id": "58bb69afd73408ce4f4e6fdc",
      "username": "sauravk7077",
      "displayName": "Saurav Kumar",
      "url": "/sauravk7077",
      "avatarUrl": "https://avatars-02.gitter.im/gh/uv/4/sauravk7077",
      "avatarUrlSmall":
          "https://avatars0.githubusercontent.com/u/17443674?v=4&s=60",
      "avatarUrlMedium":
          "https://avatars0.githubusercontent.com/u/17443674?v=4&s=128",
      "v": 5,
      "gv": "4"
    }
  },
  {
    "id": "5fdc4170ac9d8e7463b84ea0",
    "text": "https://github.com/miguelpruivo/flutter_file_picker/issues/82",
    "html":
        "<a target=\"_blank\" data-link-type=\"issue\" data-issue=\"82\" href=\"https://github.com/miguelpruivo/flutter_file_picker/issues/82\" data-provider=\"github\" data-issue-repo=\"miguelpruivo/flutter_file_picker\" class=\"issue\">miguelpruivo/flutter_file_picker#82</a>",
    "sent": "2020-12-18T05:43:12.550Z",
    "unread": false,
    "readBy": 21,
    "urls": [],
    "mentions": [],
    "issues": [
      {"repo": "miguelpruivo/flutter_file_picker", "number": "82"}
    ],
    "meta": [],
    "v": 1,
    "fromUser": {
      "id": "5838d1f4d73408ce4f38aaac",
      "username": "RandalSchwartz",
      "displayName": "Randal L. Schwartz",
      "url": "/RandalSchwartz",
      "avatarUrl": "https://avatars-04.gitter.im/gh/uv/4/RandalSchwartz",
      "avatarUrlSmall":
          "https://avatars2.githubusercontent.com/u/6342?v=4&s=60",
      "avatarUrlMedium":
          "https://avatars2.githubusercontent.com/u/6342?v=4&s=128",
      "v": 12,
      "gv": "4"
    }
  },
  {
    "id": "5fdc5c6f69ee7f0422abc527",
    "text":
        "Hi all, im in a need to pass a list of files (List<File>) to a separate dart isolate for further processing. How do i pass this in a recommended way? As a list of object or as a list of string of paths to the file? Thank you",
    "html":
        "Hi all, im in a need to pass a list of files (List&lt;File&gt;) to a separate dart isolate for further processing. How do i pass this in a recommended way? As a list of object or as a list of string of paths to the file? Thank you",
    "sent": "2020-12-18T07:38:23.785Z",
    "unread": false,
    "readBy": 18,
    "urls": [],
    "mentions": [],
    "issues": [],
    "meta": [],
    "v": 1,
    "fromUser": {
      "id": "5eecde40d73408ce4fe76435",
      "username": "sajadj313",
      "displayName": "Sajad Jaward",
      "url": "/sajadj313",
      "avatarUrl": "https://avatars-05.gitter.im/gh/uv/4/sajadj313",
      "avatarUrlSmall":
          "https://avatars0.githubusercontent.com/u/34274720?v=4&s=60",
      "avatarUrlMedium":
          "https://avatars0.githubusercontent.com/u/34274720?v=4&s=128",
      "v": 9,
      "gv": "4"
    }
  },
  {
    "id": "5fdc5cab63fe03449603f549",
    "text":
        "last time i looked at stuff like that, i thought you had to send all of it as a string, for example a json string.",
    "html":
        "last time i looked at stuff like that, i thought you had to send all of it as a string, for example a json string.",
    "sent": "2020-12-18T07:39:23.945Z",
    "unread": false,
    "readBy": 18,
    "urls": [],
    "mentions": [],
    "issues": [],
    "meta": [],
    "v": 1,
    "fromUser": {
      "id": "57ec043f40f3a6eec067ddc4",
      "username": "bradyt",
      "displayName": "Brady Trainor",
      "url": "/bradyt",
      "avatarUrl": "https://avatars-02.gitter.im/gh/uv/4/bradyt",
      "avatarUrlSmall":
          "https://avatars0.githubusercontent.com/u/6107051?v=4&s=60",
      "avatarUrlMedium":
          "https://avatars0.githubusercontent.com/u/6107051?v=4&s=128",
      "v": 41,
      "gv": "4"
    }
  },
  {
    "id": "5fdc5cc663fe03449603f582",
    "text":
        "but by no means do i feel i have a solid understanding of working with isolates.",
    "html":
        "but by no means do i feel i have a solid understanding of working with isolates.",
    "sent": "2020-12-18T07:39:50.544Z",
    "unread": false,
    "readBy": 18,
    "urls": [],
    "mentions": [],
    "issues": [],
    "meta": [],
    "v": 1,
    "fromUser": {
      "id": "57ec043f40f3a6eec067ddc4",
      "username": "bradyt",
      "displayName": "Brady Trainor",
      "url": "/bradyt",
      "avatarUrl": "https://avatars-02.gitter.im/gh/uv/4/bradyt",
      "avatarUrlSmall":
          "https://avatars0.githubusercontent.com/u/6107051?v=4&s=60",
      "avatarUrlMedium":
          "https://avatars0.githubusercontent.com/u/6107051?v=4&s=128",
      "v": 41,
      "gv": "4"
    }
  },
  {
    "id": "5fdc5e2797312f4b6bd5f587",
    "text":
        "I read the docs and some googling but still couldn’t properly find out how to pass some params like this. The docs say you need to have a single param.",
    "html":
        "I read the docs and some googling but still couldn’t properly find out how to pass some params like this. The docs say you need to have a single param.",
    "sent": "2020-12-18T07:45:43.192Z",
    "unread": false,
    "readBy": 18,
    "urls": [],
    "mentions": [],
    "issues": [],
    "meta": [],
    "v": 1,
    "fromUser": {
      "id": "5eecde40d73408ce4fe76435",
      "username": "sajadj313",
      "displayName": "Sajad Jaward",
      "url": "/sajadj313",
      "avatarUrl": "https://avatars-05.gitter.im/gh/uv/4/sajadj313",
      "avatarUrlSmall":
          "https://avatars0.githubusercontent.com/u/34274720?v=4&s=60",
      "avatarUrlMedium":
          "https://avatars0.githubusercontent.com/u/34274720?v=4&s=128",
      "v": 9,
      "gv": "4"
    }
  },
  {
    "id": "5fdc5e62acd1e516f89d0033",
    "text":
        "Can i utilize that single param to be a list of objects where the first item would be the sendPort and the second item would be a list of files?",
    "html":
        "Can i utilize that single param to be a list of objects where the first item would be the sendPort and the second item would be a list of files?",
    "sent": "2020-12-18T07:46:42.782Z",
    "unread": false,
    "readBy": 18,
    "urls": [],
    "mentions": [],
    "issues": [],
    "meta": [],
    "v": 1,
    "fromUser": {
      "id": "5eecde40d73408ce4fe76435",
      "username": "sajadj313",
      "displayName": "Sajad Jaward",
      "url": "/sajadj313",
      "avatarUrl": "https://avatars-05.gitter.im/gh/uv/4/sajadj313",
      "avatarUrlSmall":
          "https://avatars0.githubusercontent.com/u/34274720?v=4&s=60",
      "avatarUrlMedium":
          "https://avatars0.githubusercontent.com/u/34274720?v=4&s=128",
      "v": 9,
      "gv": "4"
    }
  },
  {
    "id": "5fdc6242ac9d8e7463b89aee",
    "text":
        "Hi am building a booking app in Flutter and need help. My app will have 2 different users, an actual guest and the host. The host will define the availability and the guest will then see the availability. Is there an easy example anyone can show me on how to code this possibly which includes a calendar?  ",
    "html":
        "Hi am building a booking app in Flutter and need help. My app will have 2 different users, an actual guest and the host. The host will define the availability and the guest will then see the availability. Is there an easy example anyone can show me on how to code this possibly which includes a calendar?  ",
    "sent": "2020-12-18T08:03:14.430Z",
    "unread": false,
    "readBy": 19,
    "urls": [],
    "mentions": [],
    "issues": [],
    "meta": [],
    "v": 1,
    "fromUser": {
      "id": "5fcf1a69d73408ce4ff5fad1",
      "username": "KingKhan1234",
      "displayName": "Muhammad Farooq",
      "url": "/KingKhan1234",
      "avatarUrl": "https://avatars-01.gitter.im/gh/uv/4/KingKhan1234",
      "avatarUrlSmall":
          "https://avatars2.githubusercontent.com/u/32174719?v=4&s=60",
      "avatarUrlMedium":
          "https://avatars2.githubusercontent.com/u/32174719?v=4&s=128",
      "v": 3,
      "gv": "4"
    }
  },
  {
    "id": "5fdc64ab63fe0344960407ec",
    "text":
        "@dgradecak  Thank you for your help but I have fixed the error after I have deeply checked my code",
    "html":
        "<span data-link-type=\"mention\" data-screen-name=\"dgradecak\" class=\"mention\">@dgradecak</span>  Thank you for your help but I have fixed the error after I have deeply checked my code",
    "sent": "2020-12-18T08:13:31.379Z",
    "unread": false,
    "readBy": 19,
    "urls": [],
    "mentions": [
      {
        "screenName": "dgradecak",
        "userId": "5a60dea2d73408ce4f88f9cc",
        "userIds": []
      }
    ],
    "issues": [],
    "meta": [],
    "v": 1,
    "fromUser": {
      "id": "5e8b68f0d73408ce4fdf7c31",
      "username": "kemalturk03",
      "displayName": "Kemal ",
      "url": "/kemalturk03",
      "avatarUrl": "https://avatars-04.gitter.im/gh/uv/4/kemalturk03",
      "avatarUrlSmall":
          "https://avatars2.githubusercontent.com/u/58164337?v=4&s=60",
      "avatarUrlMedium":
          "https://avatars2.githubusercontent.com/u/58164337?v=4&s=128",
      "v": 9,
      "gv": "4"
    }
  },
  {
    "id": "5fdc66fdde608143152bb44d",
    "text": "hmm, wonder when null safety will be on flutter stable",
    "html": "hmm, wonder when null safety will be on flutter stable",
    "sent": "2020-12-18T08:23:25.179Z",
    "unread": false,
    "readBy": 19,
    "urls": [],
    "mentions": [],
    "issues": [],
    "meta": [],
    "v": 1,
    "fromUser": {
      "id": "57ec043f40f3a6eec067ddc4",
      "username": "bradyt",
      "displayName": "Brady Trainor",
      "url": "/bradyt",
      "avatarUrl": "https://avatars-02.gitter.im/gh/uv/4/bradyt",
      "avatarUrlSmall":
          "https://avatars0.githubusercontent.com/u/6107051?v=4&s=60",
      "avatarUrlMedium":
          "https://avatars0.githubusercontent.com/u/6107051?v=4&s=128",
      "v": 41,
      "gv": "4"
    }
  },
  {
    "id": "5fdc67038bb73474693ddb56",
    "text": "i was just going to wait",
    "html": "i was just going to wait",
    "sent": "2020-12-18T08:23:31.217Z",
    "unread": false,
    "readBy": 19,
    "urls": [],
    "mentions": [],
    "issues": [],
    "meta": [],
    "v": 1,
    "fromUser": {
      "id": "57ec043f40f3a6eec067ddc4",
      "username": "bradyt",
      "displayName": "Brady Trainor",
      "url": "/bradyt",
      "avatarUrl": "https://avatars-02.gitter.im/gh/uv/4/bradyt",
      "avatarUrlSmall":
          "https://avatars0.githubusercontent.com/u/6107051?v=4&s=60",
      "avatarUrlMedium":
          "https://avatars0.githubusercontent.com/u/6107051?v=4&s=128",
      "v": 41,
      "gv": "4"
    }
  },
  {
    "id": "5fdc672022f12e449bf9b261",
    "text": "\"open, open, open, open\" -- <80's mervyn's commercial>",
    "html":
        "&quot;open, open, open, open&quot; -- &lt;80&#39;s mervyn&#39;s commercial&gt;",
    "sent": "2020-12-18T08:24:00.122Z",
    "unread": false,
    "readBy": 19,
    "urls": [],
    "mentions": [],
    "issues": [],
    "meta": [],
    "v": 1,
    "fromUser": {
      "id": "57ec043f40f3a6eec067ddc4",
      "username": "bradyt",
      "displayName": "Brady Trainor",
      "url": "/bradyt",
      "avatarUrl": "https://avatars-02.gitter.im/gh/uv/4/bradyt",
      "avatarUrlSmall":
          "https://avatars0.githubusercontent.com/u/6107051?v=4&s=60",
      "avatarUrlMedium":
          "https://avatars0.githubusercontent.com/u/6107051?v=4&s=128",
      "v": 41,
      "gv": "4"
    }
  },
  {
    "id": "5fdc67d863fe034496040f83",
    "text":
        "ah, estimate is right there, at the medium linked from dart home page",
    "html":
        "ah, estimate is right there, at the medium linked from dart home page",
    "sent": "2020-12-18T08:27:04.697Z",
    "unread": false,
    "readBy": 18,
    "urls": [],
    "mentions": [],
    "issues": [],
    "meta": [],
    "v": 1,
    "fromUser": {
      "id": "57ec043f40f3a6eec067ddc4",
      "username": "bradyt",
      "displayName": "Brady Trainor",
      "url": "/bradyt",
      "avatarUrl": "https://avatars-02.gitter.im/gh/uv/4/bradyt",
      "avatarUrlSmall":
          "https://avatars0.githubusercontent.com/u/6107051?v=4&s=60",
      "avatarUrlMedium":
          "https://avatars0.githubusercontent.com/u/6107051?v=4&s=128",
      "v": 41,
      "gv": "4"
    }
  },
  {
    "id": "5fdc67e8c746c6431cc06c7b",
    "text": "\"early 2021\"",
    "html": "&quot;early 2021&quot;",
    "sent": "2020-12-18T08:27:20.243Z",
    "unread": false,
    "readBy": 18,
    "urls": [],
    "mentions": [],
    "issues": [],
    "meta": [],
    "v": 1,
    "fromUser": {
      "id": "57ec043f40f3a6eec067ddc4",
      "username": "bradyt",
      "displayName": "Brady Trainor",
      "url": "/bradyt",
      "avatarUrl": "https://avatars-02.gitter.im/gh/uv/4/bradyt",
      "avatarUrlSmall":
          "https://avatars0.githubusercontent.com/u/6107051?v=4&s=60",
      "avatarUrlMedium":
          "https://avatars0.githubusercontent.com/u/6107051?v=4&s=128",
      "v": 41,
      "gv": "4"
    }
  },
  {
    "id": "5fdc6b0e22f12e449bf9bb8a",
    "text": "Did I see a \"save the date\" for March?",
    "html": "Did I see a &quot;save the date&quot; for March?",
    "sent": "2020-12-18T08:40:46.812Z",
    "unread": false,
    "readBy": 18,
    "urls": [],
    "mentions": [],
    "issues": [],
    "meta": [],
    "v": 1,
    "fromUser": {
      "id": "5c3f0ae8d73408ce4fb4eb87",
      "username": "awhitford",
      "displayName": "Anthony Whitford",
      "url": "/awhitford",
      "avatarUrl": "https://avatars-03.gitter.im/gh/uv/4/awhitford",
      "avatarUrlSmall":
          "https://avatars0.githubusercontent.com/u/123887?v=4&s=60",
      "avatarUrlMedium":
          "https://avatars0.githubusercontent.com/u/123887?v=4&s=128",
      "v": 7,
      "gv": "4"
    }
  },
  {
    "id": "5fdc7fa222f12e449bf9ece0",
    "text":
        "https://stackoverflow.com/questions/65343104/how-can-i-compound-postuid-and-userid/65343586?noredirect=1#comment115529032_65343586\n\nstill open",
    "html":
        "<p><a href=\"https://stackoverflow.com/questions/65343104/how-can-i-compound-postuid-and-userid/65343586?noredirect=1#comment115529032_65343586\" rel=\"nofollow noopener noreferrer\" target=\"_blank\" class=\"link \">https://stackoverflow.com/questions/65343104/how-can-i-compound-postuid-and-userid/65343586?noredirect=1#comment115529032_65343586</a></p><p>still open</p>",
    "sent": "2020-12-18T10:08:34.742Z",
    "unread": false,
    "readBy": 17,
    "urls": [
      {
        "url":
            "https://stackoverflow.com/questions/65343104/how-can-i-compound-postuid-and-userid/65343586?noredirect=1#comment115529032_65343586"
      }
    ],
    "mentions": [],
    "issues": [],
    "meta": [],
    "v": 1,
    "fromUser": {
      "id": "5fcf87dcd73408ce4ff6049d",
      "username": "efe__m8_twitter",
      "displayName": "Efe",
      "url": "/efe__m8_twitter",
      "avatarUrl": "https://avatars-02.gitter.im/g/u/efe__m8_twitter",
      "avatarUrlSmall":
          "https://pbs.twimg.com/profile_images/1325092179686150144/__7iyqSh_bigger.jpg",
      "avatarUrlMedium":
          "https://pbs.twimg.com/profile_images/1325092179686150144/__7iyqSh.jpg",
      "v": 1
    }
  }
];
