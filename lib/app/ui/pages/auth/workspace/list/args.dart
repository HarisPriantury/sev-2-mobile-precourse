import 'package:mobile_sev2/app/infrastructures/misc/base_args.dart';

class WorkspaceListArgs implements BaseArgs {
  String origin;

  WorkspaceListArgs(this.origin);
  @override
  String toPrint() {
    return "WorkspaceListArgs data: $origin";
  }

}