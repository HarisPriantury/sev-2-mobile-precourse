import 'package:flutter_beep/flutter_beep.dart';
import 'package:mobile_sev2/data/infrastructures/ringtone_player_interface.dart';

class RingtonePlayer implements RingtonePlayerInterface {
  @override
  void play() {
    FlutterBeep.beep();
  }
}
