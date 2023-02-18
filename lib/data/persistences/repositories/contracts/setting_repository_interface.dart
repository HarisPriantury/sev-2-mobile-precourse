import 'package:mobile_sev2/data/payload/contracts/setting_request_interface.dart';
import 'package:mobile_sev2/domain/setting.dart';

abstract class SettingRepository {
  Future<Setting> find(GetSettingRequestInterface request);
  Future<bool> update(UpdateSettingRequestInterface request);
}
