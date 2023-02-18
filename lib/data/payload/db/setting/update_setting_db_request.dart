import 'package:mobile_sev2/data/payload/contracts/setting_request_interface.dart';
import 'package:mobile_sev2/domain/setting.dart';

class UpdateSettingDBRequest implements UpdateSettingRequestInterface {
  String key = "setting";
  Setting setting;

  UpdateSettingDBRequest(this.setting);
}
