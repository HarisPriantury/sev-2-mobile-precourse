import 'dart:convert';

import 'package:mobile_sev2/app/infrastructures/misc/base_args.dart';
import 'package:mobile_sev2/domain/room.dart';

class RoomMemberArgs implements BaseArgs {
  Room room;

  RoomMemberArgs(this.room);

  @override
  String toPrint() {
    return "RoomMemberArgs data: ${jsonEncode(room)}";
  }
}
