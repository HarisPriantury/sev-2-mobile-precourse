import 'package:mobile_sev2/app/infrastructures/misc/base_args.dart';
import 'package:mobile_sev2/domain/project.dart';

class WorkboardArgs implements BaseArgs {
  Project project;

  WorkboardArgs({required this.project});

  @override
  String toPrint() {
    return "WorkboardArgs data: Project ${project.id} ${project.fullName}";
  }
}
