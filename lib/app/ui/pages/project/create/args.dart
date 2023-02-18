import 'package:mobile_sev2/app/infrastructures/misc/base_args.dart';
import 'package:mobile_sev2/domain/project.dart';

class CreateProjectArgs implements BaseArgs {
  Project? project;
  CreateProjectType type;

  CreateProjectArgs({
    this.project,
    required this.type,
  });

  @override
  String toPrint() {
    return "CreateProjectArgs";
  }
}

enum CreateProjectType {
  projectCreate,
  projectEdit,
  subProject,
  milestoneCreate,
  milestoneEdit,
}
