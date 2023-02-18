import 'package:mobile_sev2/app/infrastructures/misc/base_args.dart';

class DetailTicketArgs implements BaseArgs {
  String? phid;
  int? id;
  String from;

  DetailTicketArgs({this.phid, this.id, this.from = ""})
      : assert(phid != null || id != null);

  @override
  String toPrint() {
    return "DetailTicketArgs data: $phid $id";
  }
}
