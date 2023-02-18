import 'package:mobile_sev2/app/infrastructures/misc/base_args.dart';

class DetailEventArgs extends BaseArgs {
  DetailEventArgs({
    this.phid,
    this.id,
  }) : assert(phid != null || id != null);

  int? id;
  String? phid;

  @override
  String toPrint() {
    return "DetailEventArgs data : $phid, $id";
  }
}
