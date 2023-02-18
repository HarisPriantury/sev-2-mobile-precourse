import 'package:mobile_sev2/app/infrastructures/misc/base_args.dart';

class AppearanceArgs implements BaseArgs {
  final String appearance;

  AppearanceArgs(this.appearance);
  @override
  String toPrint() {
    return "AppearanceArgs data: $appearance";
  }
}
