import 'dart:convert';

import 'package:mobile_sev2/app/infrastructures/misc/base_args.dart';
import 'package:mobile_sev2/domain/room.dart';

class RoomStickitArgs implements BaseArgs {
  Room room;

  RoomStickitArgs(this.room);

  @override
  String toPrint() {
    return "RoomStickitArgs data: ${jsonEncode(room)}";
  }
}