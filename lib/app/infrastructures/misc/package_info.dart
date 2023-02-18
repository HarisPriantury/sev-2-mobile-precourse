import 'dart:async';

import 'package:package_info_plus/package_info_plus.dart';

class PackageInfoDevice {
  static Future<String> getVersion() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    return info.version;
  }
}
