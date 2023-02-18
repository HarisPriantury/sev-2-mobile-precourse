import 'dart:convert';

import 'package:mobile_sev2/app/infrastructures/misc/base_args.dart';
import 'package:mobile_sev2/domain/room.dart';
import 'package:mobile_sev2/domain/user.dart';

class CreateRoomArgs implements BaseArgs {
  Room? room;
  FormType type;

  CreateRoomArgs({
    required this.type,
    this.room,
  });

  @override
  String toPrint() {
    return "CreateRoomArgs data: selectedUsers";
  }
}

enum FormType {
  create,
  edit,
}
