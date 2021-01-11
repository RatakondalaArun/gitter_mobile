import 'package:url_launcher/url_launcher.dart' as ul;

/// Opens link in browser.
Future<bool> openLink(String url) async {
  if (!await ul.canLaunch(url)) return false;
  return ul.launch(url);
}
