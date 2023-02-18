import 'package:mobile_sev2/app/infrastructures/misc/base_args.dart';
import 'package:mobile_sev2/domain/phobject.dart';

class EditMemberArgs extends BaseArgs {
  String phid;
  List<PhObject>? selectedBefore;
  EditMemberArgs(
    this.phid, {
    this.selectedBefore,
  });
  @override
  String toPrint() {
    return "EditMemberArgs data: $phid, ${selectedBefore.toString()}";
  }
}
