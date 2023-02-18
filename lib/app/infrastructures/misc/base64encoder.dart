import 'dart:convert';
import 'dart:typed_data';

import 'package:mobile_sev2/data/infrastructures/encoder_interface.dart';

class Base64Encoder implements EncoderInterface {
  @override
  String encode(String str) {
    var bytes = utf8.encode(str);
    return base64.encode(bytes);
  }

  @override
  String decode(String str) {
    Codec<String, String> base64Str = utf8.fuse(base64);
    return base64Str.decode(str);
  }

  @override
  String encodeBytes(Uint8List bytes) {
    return base64.encode(bytes);
  }
}
