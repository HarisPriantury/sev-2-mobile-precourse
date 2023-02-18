import 'package:mobile_sev2/app/infrastructures/misc/base_args.dart';

class RegisterArgs implements BaseArgs {
  String workspaceName;

  RegisterArgs(this.workspaceName);
  @override
  String toPrint() {
    return "RegisterArgs data: $workspaceName";
  }

}