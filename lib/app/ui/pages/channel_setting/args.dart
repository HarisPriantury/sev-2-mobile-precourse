import 'package:mobile_sev2/app/infrastructures/misc/base_args.dart';
import 'package:mobile_sev2/domain/room.dart';

class ChannelSettingArgs implements BaseArgs {
  Room room;
  ChannelSettingArgs(this.room);

  @override
  String toPrint() {
    return "ChannelSettingArgs data: room ${room.name}";
  }
}
