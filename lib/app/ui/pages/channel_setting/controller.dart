import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/ui/pages/channel_setting/args.dart';
import 'package:mobile_sev2/domain/room.dart';

class ChannelSettingController extends BaseController {
  ChannelSettingArgs? _data;

  bool _isSwitchOn = false;
  bool get isSwitchOn => _isSwitchOn;

  Room? _room;
  Room? get room => _room;

  void switchOnChangeHandler(bool switchChanged) {
    _isSwitchOn = switchChanged;
    refreshUI();
  }

  @override
  void disposing() {}

  @override
  void getArgs() {
    if (args != null) _data = args as ChannelSettingArgs;
    _room = _data!.room;
  }

  @override
  void initListeners() {}

  @override
  void load() {}
}
