import 'dart:convert';

import 'package:mobile_sev2/app/infrastructures/misc/base_args.dart';
import 'package:mobile_sev2/domain/room.dart';

class RoomFileArgs implements BaseArgs {
  Room? room;
  bool isRoom;

  RoomFileArgs({
    this.room,
    this.isRoom = false,
  });

  @override
  String toPrint() {
    return "RoomFileArgs data: ${jsonEncode(room)}";
  }
}
