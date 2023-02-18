import 'package:mobile_sev2/app/infrastructures/misc/base_args.dart';

class DetailProjectArgs extends BaseArgs {
  String? phid;
  int? id;
  String from;

  DetailProjectArgs({this.phid, this.id, this.from = ""})
      : assert(phid != null || id != null);

  @override
  String toPrint() {
    return "DetailProjectArgs data: ";
  }
}
