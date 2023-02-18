import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FirebaseDynamicLinkService {
  static Future<String> createDynamicLink(bool short, int id) async {
    FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
    String _linkMessage;
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: "${dotenv.env['DYNAMIC_LINK']}",
      link: Uri.parse("${dotenv.env['DYNAMIC_LINK']}/?id=$id"),
      androidParameters: AndroidParameters(
        packageName: 'com.sev_2.android',
        minimumVersion: 0,
      ),
      iosParameters: IOSParameters(
        bundleId: 'com.sev2.ios',
        minimumVersion: '0',
      ),
    );

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink =
          await dynamicLinks.buildShortLink(parameters);
      url = shortLink.shortUrl;
    } else {
      url = await dynamicLinks.buildLink(parameters);
    }

    _linkMessage = url.toString();
    print("_linkMessage: $_linkMessage");
    return _linkMessage;
  }
}
