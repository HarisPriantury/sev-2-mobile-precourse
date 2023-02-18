import 'dart:convert';

import 'package:mobile_sev2/app/infrastructures/misc/base_args.dart';
import 'package:mobile_sev2/domain/room.dart';

class RoomTicketArgs implements BaseArgs {
  Room room;

  RoomTicketArgs(this.room);

  @override
  String toPrint() {
    return "RoomTicketArgs data: ${jsonEncode(room)}";
  }
}
