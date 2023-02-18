
import 'package:mobile_sev2/app/infrastructures/misc/base_args.dart';

class MemberArgs implements BaseArgs {
  String workspace;

  MemberArgs(this.workspace);

  @override
  String toPrint() {
    return "MemberArgs data: $workspace}";
  }
}
