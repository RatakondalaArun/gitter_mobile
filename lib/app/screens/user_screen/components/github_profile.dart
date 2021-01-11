import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gitterapi/models.dart';

class GithubProfileComponent extends StatelessWidget {
  final UserProfile profile;

  const GithubProfileComponent({
    Key key,
    this.profile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'GITHUB',
            style: TextStyle(color: Colors.black54),
          ),
          Material(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (profile.location != null)
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    leading: Icon(Icons.location_on_outlined),
                    title: Text(
                      '${profile.location}',
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: Icon(Icons.copy_outlined),
                    onTap: () => _copyToClipboard(profile.location),
                  ),
                if (profile.company != null)
                  ListTile(
                    leading: Icon(Icons.location_city_outlined),
                    title: Text(
                      '${profile.company}',
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: Icon(Icons.copy_outlined),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onTap: () => _copyToClipboard(profile.location),
                  ),
                if (profile.email != null)
                  ListTile(
                    leading: Icon(Icons.mail_outline),
                    title: Text(
                      '${profile.email}',
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: Icon(Icons.copy_outlined),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onTap: () => _copyToClipboard(profile.location),
                  ),
                if (profile.website != null)
                  ListTile(
                    leading: Icon(Icons.link),
                    title: Text(
                      '${profile.website}',
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: Icon(Icons.copy_outlined),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onTap: () => _copyToClipboard(profile.location),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _copyToClipboard(String value) async {
    if (value == null) return;
    await Clipboard.setData(ClipboardData(text: value.trim()));
  }
}
