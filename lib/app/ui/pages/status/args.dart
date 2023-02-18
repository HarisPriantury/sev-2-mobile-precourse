import 'package:mobile_sev2/app/infrastructures/misc/base_args.dart';

class StatusArgs implements BaseArgs {
  bool newPage;

  StatusArgs({required this.newPage});
  @override
  String toPrint() {
    return "ProfileArgs data: $newPage";
  }
}
