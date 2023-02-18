import 'package:mobile_sev2/app/infrastructures/misc/base_args.dart';

class WorkspaceLoginArgs implements BaseArgs {
  String? origin;

  WorkspaceLoginArgs({this.origin});
  @override
  String toPrint() {
    return "WorkspaceLoginArgs data: $origin";
  }

}