import 'package:mobile_sev2/app/infrastructures/misc/base_args.dart';

class ColumnListArgs implements BaseArgs {
  String projectId;

  ColumnListArgs({required this.projectId});

  @override
  String toPrint() {
    return "ColumnListArgs data: Project $projectId";
  }
}
