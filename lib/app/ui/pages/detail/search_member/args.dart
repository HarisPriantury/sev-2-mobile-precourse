import 'package:mobile_sev2/app/infrastructures/misc/base_args.dart';
import 'package:mobile_sev2/domain/phobject.dart';

class SearchMemberArgs extends BaseArgs {
  SearchMemberArgs(
    this.phid, {
    this.selectedBefore,
  });

  String phid;
  List<PhObject>? selectedBefore;

  @override
  String toPrint() {
    return "SearchMemberArgs data: $phid";
  }
}
