import 'package:mobile_sev2/app/infrastructures/misc/base_args.dart';

class LoginArgs implements BaseArgs {
  LoginType type;
  String workspaceName;

  LoginArgs({required this.type, required this.workspaceName});
  @override
  String toPrint() {
    return "LoginArgs data: $type, $workspaceName";
  }
}

enum LoginType { idp, emailPassword }
