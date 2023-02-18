import 'package:mobile_sev2/domain/phobject.dart';

class AppearanceMethod extends PhObject {
  String appearanceMethodName;

  AppearanceMethod(
    super.id, {
    required this.appearanceMethodName,
  });
}
