import 'package:mobile_sev2/app/infrastructures/misc/base_args.dart';

class ReportArgs implements BaseArgs {
  String phId;
  String reportedType;

  ReportArgs({
    required this.phId,
    required this.reportedType,
  });

  @override
  String toPrint() {
    return "ReportArgs data: room $phId, $reportedType";
  }
}
