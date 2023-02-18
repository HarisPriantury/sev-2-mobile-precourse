import 'package:mobile_sev2/app/infrastructures/misc/base_args.dart';
import 'package:mobile_sev2/domain/user.dart';

class ProfileArgs implements BaseArgs {
  User? user;

  ProfileArgs({this.user});

  @override
  String toPrint() {
    return "ProfileArgs data:";
  }
}
