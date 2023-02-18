import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CommonUtil {
  bool isDebug() {
    return !kReleaseMode;
  }

  void printd(Object? content) {
    if (isDebug() && content != null) {
      print(content);
    }
  }

  void showNotif(
    BuildContext context,
    String txt, {
    int period: 2,
    TextStyle textStyle: const TextStyle(),
    TextAlign textAlign: TextAlign.start,
    Color backgroundColor: const Color(0xFF323232),
  }) {
    final snackbar = SnackBar(
      backgroundColor: backgroundColor,
      content: Text(
        txt,
        style: textStyle,
        textAlign: textAlign,
      ),
      duration: Duration(seconds: period),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  String get deviceLabel {
    return Platform.localHostname + '(' + Platform.operatingSystem + ")";
  }

  String get userAgent {
    return 'flutter-webrtc/' + Platform.operatingSystem + '-plugin 0.0.1';
  }
}
