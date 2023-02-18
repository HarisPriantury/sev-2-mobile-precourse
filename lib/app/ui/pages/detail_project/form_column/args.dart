import 'package:mobile_sev2/app/infrastructures/misc/base_args.dart';

class FormColumnArgs implements BaseArgs {
  String projectId;
  String? columnId;
  String? columnName;
  FormType? formType;

  FormColumnArgs({
    required this.projectId,
    this.columnId,
    this.columnName,
    this.formType,
  });

  @override
  String toPrint() {
    return "FormColumnArgs data: Project $projectId}";
  }
}

enum FormType {
  rename,
  create,
}
