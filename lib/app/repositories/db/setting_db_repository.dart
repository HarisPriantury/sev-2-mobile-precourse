import 'package:hive/hive.dart';
import 'package:mobile_sev2/data/payload/contracts/setting_request_interface.dart';
import 'package:mobile_sev2/data/payload/db/setting/get_setting_db_request.dart';
import 'package:mobile_sev2/data/payload/db/setting/update_setting_db_request.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/setting_repository_interface.dart';
import 'package:mobile_sev2/domain/setting.dart';

class SettingDBRepository implements SettingRepository {
  Box<Setting> _box;

  SettingDBRepository(this._box);

  @override
  Future<Setting> find(GetSettingRequestInterface request) {
    var param = request as GetSettingDBRequest;
    var setting = _box.get(param.key);

    if (setting == null) {
      setting = Setting(
        bookmarkedRooms: [],
        currentTask: "",
        hasUnopenedNotification: false,
        hasUnreadChats: false,
      );
    }

    return Future.value(setting);
  }

  @override
  Future<bool> update(UpdateSettingRequestInterface request) {
    var param = request as UpdateSettingDBRequest;
    _box.put(param.key, param.setting);
    return Future.value(true);
  }
}
