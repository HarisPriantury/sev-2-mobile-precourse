import 'dart:typed_data';

abstract class EncoderInterface {
  String encode(String str);
  String encodeBytes(Uint8List bytes);
  String decode(String str);
}
