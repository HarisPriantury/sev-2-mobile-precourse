import 'package:mobile_sev2/app/infrastructures/misc/base_args.dart';

class DetailStickitArgs extends BaseArgs {
  String? phid;
  int? id;

  DetailStickitArgs({
    this.phid,
    this.id,
  }) : assert(phid != null || id != null);

  @override
  String toPrint() {
    return "DetailStickitArgs data: $phid $id";
  }
}
