import 'dart:convert';

import 'package:mobile_sev2/app/infrastructures/misc/base_args.dart';
import 'package:mobile_sev2/domain/room.dart';

class ChatArgs implements BaseArgs {
  Room? room;
  String? from;

  ChatArgs(this.room, {this.from});

  @override
  String toPrint() {
    return "ChatArgs data: room ${jsonEncode(room)}";
  }
}

enum ChatType {
  room,
  direct,
}