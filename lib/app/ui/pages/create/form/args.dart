import 'dart:convert';

import 'package:mobile_sev2/app/infrastructures/misc/base_args.dart';
import 'package:mobile_sev2/domain/phobject.dart';
import 'package:mobile_sev2/domain/room.dart';

class CreateArgs implements BaseArgs {
  // object is nullable for CreatePage, if object is not null then it become EditPage
  PhObject? object;
  Room? room;
  String? columnId;
  Type type;
  bool isSubTask;
  TaskType taskType;
  bool isCreateTicketFromMain;

  CreateArgs({
    this.object,
    this.room,
    this.columnId,
    required this.type,
    this.isSubTask = false,
    this.taskType = TaskType.task,
    this.isCreateTicketFromMain = false,
  });

  @override
  String toPrint() {
    return "CreateArgs data: ${jsonEncode(object)}";
  }
}

enum TaskType { task, bug, spike }
