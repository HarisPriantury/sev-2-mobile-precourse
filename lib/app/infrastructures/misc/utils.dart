import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:path_provider/path_provider.dart';

class Utils {
  static Future<String> getDownloadDir(BuildContext context) async {
    final dir = Theme.of(context).platform == TargetPlatform.android
        ? await (getExternalStorageDirectory())
        : await getApplicationDocumentsDirectory();

    var savedDir = Directory(
        dir!.path + Platform.pathSeparator + AppConstants.DOWNLOAD_FOLDER);

    if (!savedDir.existsSync()) {
      await savedDir.create(recursive: true);
    }

    return savedDir.path;
  }

  static String idrFormat(double number) {
    final formatCurrency = NumberFormat.simpleCurrency(
      locale: 'id_ID',
      name: "Rp.",
      decimalDigits: 0,
    );
    return formatCurrency.format(number);
  }

  static bool isTablet() {
    var window = WidgetsBinding.instance.window;
    var data = MediaQueryData.fromWindow(window);
    var isTablet = data.size.shortestSide >= 540.0;
    return isTablet;
  }
}
