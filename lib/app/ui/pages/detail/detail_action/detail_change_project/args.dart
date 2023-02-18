import 'package:mobile_sev2/app/infrastructures/misc/base_args.dart';
import 'package:mobile_sev2/domain/project.dart';

enum DetailChangeProjectType {
  add,
  search,
}

class DetailChangeProjectArgs extends BaseArgs {
  List<Project> currentProjects;
  DetailChangeProjectType type;

  DetailChangeProjectArgs({required this.currentProjects, required this.type});

  @override
  String toPrint() {
    return 'DetailChangeProjectArgs data : ${currentProjects.length}';
  }
}
