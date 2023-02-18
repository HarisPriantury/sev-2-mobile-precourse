import 'dart:convert';

import 'package:mobile_sev2/app/infrastructures/misc/base_args.dart';
import 'package:mobile_sev2/domain/project.dart';

class ProjectMemberArgs implements BaseArgs {
  Project project;
  ProjectMemberActionType type;

  ProjectMemberArgs(
    this.project,
    this.type,
  );

  @override
  String toPrint() {
    return "ProjectMemberArgs data: ${jsonEncode(project)}";
  }
}

enum ProjectMemberActionType {
  add,
  remove,
}
