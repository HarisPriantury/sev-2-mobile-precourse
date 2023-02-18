import 'package:mobile_sev2/app/infrastructures/misc/base_args.dart';

class PublicSpaceArgs implements BaseArgs {
  bool? isLogin;

  PublicSpaceArgs(this.isLogin);

  @override
  String toPrint() {
    return "PublicSpaceArgs from: $isLogin";
  }
}
