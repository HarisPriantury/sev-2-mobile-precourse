import 'dart:convert';

import 'package:mobile_sev2/app/infrastructures/misc/base_args.dart';
import 'package:mobile_sev2/domain/ticket.dart';

class TaskActionArgs implements BaseArgs {
  TaskActionType type;
  Ticket task;
  List<Ticket>? subTask;

  TaskActionArgs({
    required this.type,
    required this.task,
    this.subTask,
  });

  @override
  String toPrint() {
    return "TaskActionArgs data: $type ${jsonEncode(task)}";
  }
}

enum TaskActionType { subtask, merge }
