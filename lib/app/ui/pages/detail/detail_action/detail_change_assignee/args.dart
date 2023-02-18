import 'package:mobile_sev2/app/infrastructures/misc/base_args.dart';
import 'package:mobile_sev2/domain/user.dart';

class DetailChangeAssigneeArgs extends BaseArgs {
  final User? currentAssignee;

  DetailChangeAssigneeArgs({required this.currentAssignee});

  @override
  String toPrint() {
    return 'DetailChangeAssigneeArgs data: $currentAssignee';
  }
}
