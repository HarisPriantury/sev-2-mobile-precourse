import 'package:mobile_sev2/app/infrastructures/misc/base_args.dart';
import 'package:mobile_sev2/domain/room.dart';

class UserListArgs implements BaseArgs {
  List<Room> roomList;

  UserListArgs(this.roomList);
  @override
  String toPrint() {
    return "UserListArgs data ${roomList.length}:";
  }
}
