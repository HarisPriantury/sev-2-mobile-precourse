import 'dart:convert';

import 'package:mobile_sev2/app/infrastructures/misc/base_args.dart';
import 'package:mobile_sev2/domain/room.dart';

class RoomCalendarArgs implements BaseArgs {
  Room room;

  RoomCalendarArgs(this.room);

  @override
  String toPrint() {
    return "RoomCalendarArgs data: ${jsonEncode(room)}";
  }
}
