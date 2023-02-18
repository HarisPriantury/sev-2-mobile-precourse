import 'dart:convert';

import 'package:mobile_sev2/app/infrastructures/misc/base_args.dart';
import 'package:mobile_sev2/domain/file.dart';
import 'package:mobile_sev2/domain/room.dart';

class RoomDetailArgs implements BaseArgs {
  Room room;
  List<File> files;

  RoomDetailArgs(this.room, this.files);

  @override
  String toPrint() {
    return "RoomDetailArgs data: room ${jsonEncode(room)} files ${jsonEncode(files)}";
  }
}
