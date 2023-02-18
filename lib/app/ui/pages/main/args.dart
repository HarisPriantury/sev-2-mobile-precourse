import 'dart:convert';

import 'package:mobile_sev2/app/infrastructures/misc/base_args.dart';
import 'package:mobile_sev2/domain/room.dart';

class MainArgs implements BaseArgs {
  String from;
  String? to;
  Room? room;

  MainArgs(this.from, {this.room, this.to});

  @override
  String toPrint() {
    return "MainArgs data: from $from room ${jsonEncode(room)}";
  }
}
